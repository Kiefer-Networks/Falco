// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/compute/catalog.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/images/images.dart';
import 'package:falco/features/network/firewalls.dart';
import 'package:falco/features/network/networks.dart';
import 'package:falco/features/placement_groups/placement_groups.dart';
import 'package:falco/features/servers/create_server_page.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:material_ui/material_ui.dart';

/// Types server [s] can change to: offered at its location, same
/// architecture and storage type, a disk at least as large as its own
/// (disks never shrink), not deprecated unless it is the current one
/// (CMP-033).
List<ServerType> changeTypeOptions(List<ServerType> all, CloudServer s) {
  final current = all.where((t) => t.name == s.type).firstOrNull;
  return [
    for (final t in all)
      if (t.prices.containsKey(s.location) &&
          t.architecture == s.architecture &&
          t.diskGb >= s.diskGb &&
          (current == null || t.storageType == current.storageType) &&
          (!t.deprecated || t.name == s.type))
        t,
  ];
}

/// The flows of a server detail page: every action asks per the
/// confirmation rule (level 1, or level 2 for rebuild and delete), runs,
/// and hands its Hetzner action to the tracker.
class ServerOps {
  new(this.context, this.ref, this.scope, this.server);

  final BuildContext context;
  final WidgetRef ref;
  final ProjectScope scope;
  final CloudServer server;

  AppLocalizations get l10n => AppLocalizations.of(context);
  Target get target =>
      (scope: scope, type: CloudType.server, id: server.id, name: server.name);

  List<ConfirmFact> get _facts => [
    ConfirmFact(
      l10n.scopeProject,
      projectName(ref.read(accountsProvider).value, server.projectId),
    ),
    if (server.address case final a?)
      ConfirmFact(l10n.fieldAddress, formatIp(a), mono: true),
  ];

  Future<bool> _confirm(
    String title,
    String consequence,
    String label, {
    bool destructive = false,
    ConfirmLevel level = ConfirmLevel.simple,
  }) => ConfirmSheet.show(
    context,
    title: title,
    consequence: consequence,
    confirmLabel: label,
    resourceName: server.name,
    destructive: destructive,
    level: level,
    facts: _facts,
  );

  Future<void> _change(ServerChange change) => runAction(
    context,
    ref,
    scope,
    (api) => changeServer(api, server.id, change),
  );

  /// Runs [start] as a tracked action and shows the one time root password
  /// it returns. The password is shown on the root navigator, read before
  /// the action starts, so it is not lost when the page closes meanwhile.
  Future<void> _withPassword(
    Future<PasswordAction> Function(cloud.Server api) start,
  ) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    final texts = l10n;
    String? password;
    final started = await runAction(context, ref, scope, (api) async {
      final r = await start(api);
      password = r.password;
      return r.action;
    });
    if (!started || password == null || !navigator.mounted) return;
    await showSecretSheet(
      navigator.context,
      title: texts.rootPasswordTitle,
      note: texts.rootPasswordNote,
      secrets: {texts.fieldRootPassword: password!},
    );
  }

  /// Power actions; power on needs no confirmation (CMP-020 to CMP-024).
  Future<void> power(ServerPower power) async {
    if (power != ServerPower.powerOn) {
      final s = server.name;
      final (title, consequence, label) = switch (power) {
        ServerPower.reboot => (
          l10n.rebootTitle(s),
          l10n.rebootConsequence,
          l10n.actionReboot,
        ),
        ServerPower.shutdown => (
          l10n.shutdownTitle(s),
          l10n.shutdownConsequence,
          l10n.actionShutdown,
        ),
        ServerPower.powerOff => (
          l10n.powerOffTitle(s),
          l10n.powerOffConsequence,
          l10n.actionPowerOff,
        ),
        ServerPower.reset || ServerPower.powerOn => (
          l10n.resetTitle(s),
          l10n.resetConsequence,
          l10n.actionReset,
        ),
      };
      final ok = await _confirm(
        title,
        consequence,
        label,
        destructive:
            power == ServerPower.powerOff || power == ServerPower.reset,
      );
      if (!ok || !context.mounted) return;
    }
    await runAction(
      context,
      ref,
      scope,
      (api) => startPower(api, server.id, power),
    );
  }

  /// Console login: websocket URL and password, valid about a minute
  /// (CMP-026).
  Future<void> console() async {
    try {
      final c = await requestConsole(
        ref.read(cloudApiProvider(scope.projectId)),
        server.id,
      );
      if (!context.mounted) return;
      await showSecretSheet(
        context,
        title: l10n.consoleTitle(server.name),
        note: l10n.consoleNote,
        secrets: {l10n.consoleUrl: c.url, l10n.consolePassword: c.password},
      );
    } on FalcoError catch (e) {
      if (context.mounted) FalcoScaffold.showSnack(context, errorText(e, l10n));
    }
  }

  /// Snapshot with description and labels (CMP-025, CMP-089).
  Future<void> snapshot() => FormSheet.show(
    context,
    title: l10n.actionSnapshot,
    fields: (_) => [
      FieldSpec(
        'description',
        l10n.fieldImageDescription,
        initial:
            '${server.name} ${formatDateTime(DateTime.now(), l10n.localeName)}',
      ),
      labelsField(l10n),
    ],
    valid: validLabels,
    onSave: (v) async {
      final container = ProviderScope.containerOf(context, listen: false);
      await startTracked(
        ref,
        scope,
        (api) => changeServer(
          api,
          server.id,
          CreateSnapshot(
            v['description']!.trim(),
            parseLabels(v['labels'] ?? '')!,
          ),
        ),
      );
      refreshResource(container.invalidate, scope, CloudType.image, 0);
    },
  );

  /// Rebuild from an image, level 2 (CMP-031, CMP-032).
  Future<void> rebuild() async {
    final images = bootImages(
      await ref.read(imagesProvider(scope).future),
      server.architecture,
      l10n,
    );
    if (!context.mounted) return;
    final image = await ChoiceList.show(
      context,
      title: l10n.rebuildPick,
      options: images.options,
      details: images.details,
      selected: '',
      searchable: true,
    );
    if (image == null || !context.mounted) return;
    final ok = await _confirm(
      l10n.rebuildTitle(server.name),
      l10n.rebuildConsequence(images.options[image] ?? image),
      l10n.actionRebuild,
      destructive: true,
      level: ConfirmLevel.typeName,
    );
    if (!ok || !context.mounted) return;
    await _withPassword((api) => rebuildServer(api, server.id, image));
  }

  /// Rescue mode on (password once) or off (CMP-039).
  Future<void> rescue() async {
    if (server.rescue) {
      if (await _confirm(
            l10n.rescueOffTitle(server.name),
            l10n.rescueOffConsequence,
            l10n.rescueOff,
          ) &&
          context.mounted) {
        await _change(const DisableRescue());
      }
      return;
    }
    if (!await _confirm(
          l10n.rescueOnTitle(server.name),
          l10n.rescueOnConsequence,
          l10n.rescueOn,
        ) ||
        !context.mounted) {
      return;
    }
    await _withPassword((api) => enableRescue(api, server.id));
  }

  /// New root password, shown once (CMP-030).
  Future<void> resetRootPassword() async {
    if (!await _confirm(
          l10n.resetPasswordTitle(server.name),
          l10n.resetPasswordConsequence,
          l10n.resetPassword,
        ) ||
        !context.mounted) {
      return;
    }
    await _withPassword((api) => resetPassword(api, server.id));
  }

  /// Insert an ISO (search, deprecated marked) or eject it
  /// (CMP-035, CMP-036).
  Future<void> iso() async {
    if (server.iso != null) {
      if (await _confirm(
            l10n.isoDetachTitle(server.iso!),
            l10n.isoDetachConsequence,
            l10n.isoDetach,
          ) &&
          context.mounted) {
        await _change(const DetachIso());
      }
      return;
    }
    final isos = [
      for (final i in await ref.read(isosProvider(scope).future))
        if (i.architecture == null || i.architecture == server.architecture) i,
    ];
    if (!context.mounted) return;
    final picked = await ChoiceList.show(
      context,
      title: l10n.isoAttach,
      options: {for (final i in isos) '${i.iso.id}': i.iso.name},
      details: {
        for (final i in isos)
          '${i.iso.id}': [
            if (i.iso.detail != i.iso.name) i.iso.detail,
            if (i.deprecated) l10n.deprecated,
          ].join(' · '),
      },
      selected: '',
      searchable: true,
    );
    if (picked != null && context.mounted) await _change(AttachIso(picked));
  }

  /// Change type: server must be off; disk upgrade is irreversible
  /// (CMP-033, CMP-034).
  Future<void> changeType() async {
    if (server.status != ResourceStatus.off) {
      FalcoScaffold.showSnack(context, l10n.changeTypeNeedsOff);
      return;
    }
    // Both read before the first await.
    final pricing = ref.read(pricingProvider(scope).future);
    final all = await ref.read(serverTypesProvider(scope).future);
    final currency = (await pricing).currency;
    if (!context.mounted) return;
    final types = changeTypeOptions(all, server);
    final picked = await ChoiceList.show(
      context,
      title: l10n.changeType,
      options: {for (final t in types) t.name: t.name.toUpperCase()},
      details: {
        for (final t in types)
          t.name: [
            typeSpecs(t, l10n),
            l10n.perMonth(
              formatMoney(
                t.prices[server.location]!,
                currency,
                l10n.localeName,
              ),
            ),
          ].join(' · '),
      },
      selected: server.type,
    );
    if (picked == null || picked == server.type || !context.mounted) return;
    await FormSheet.show(
      context,
      title: l10n.changeTypeTo(picked.toUpperCase()),
      fields: (_) => [
        FieldSpec(
          'upgradeDisk',
          l10n.upgradeDisk,
          initial: 'false',
          helper: l10n.upgradeDiskHint,
          options: {'false': l10n.commonNo, 'true': l10n.commonYes},
        ),
      ],
      valid: (_) => true,
      onSave: (v) async {
        await startTracked(
          ref,
          scope,
          (api) => changeServer(
            api,
            server.id,
            ChangeType(picked, upgradeDisk: v['upgradeDisk'] == 'true'),
          ),
        );
      },
    );
  }

  /// Backups on or off (CMP-038).
  Future<void> backups() async {
    final on = server.backupWindow == null;
    if (await _confirm(
          on
              ? l10n.backupsOnTitle(server.name)
              : l10n.backupsOffTitle(server.name),
          on ? l10n.backupsOnConsequence : l10n.backupsOffConsequence,
          on ? l10n.backupsOn : l10n.backupsOff,
          destructive: !on,
        ) &&
        context.mounted) {
      await _change(SetBackups(enabled: on));
    }
  }

  /// Add to a placement group or remove from it (CMP-043, CMP-044).
  Future<void> placementGroup() async {
    if (server.placementGroup case final g?) {
      if (await _confirm(
            l10n.placementGroupRemoveTitle(server.name, g.name),
            l10n.placementGroupRemoveConsequence,
            l10n.placementGroupRemove,
          ) &&
          context.mounted) {
        await _change(const RemoveFromPlacementGroup());
      }
      return;
    }
    final groups = await ref.read(placementGroupsProvider(scope).future);
    if (!context.mounted) return;
    if (groups.isEmpty) {
      FalcoScaffold.showSnack(context, l10n.placementGroupNone);
      return;
    }
    final picked = await ChoiceList.show(
      context,
      title: l10n.placementGroupAdd,
      options: {for (final g in groups) '${g.id}': g.name},
      details: {for (final g in groups) '${g.id}': g.type},
      selected: '',
    );
    if (picked != null && context.mounted) {
      await _change(AddToPlacementGroup(int.parse(picked)));
    }
  }

  /// Delete and rebuild protection as one switch: the API rejects
  /// different values (CMP-046). Partly protected counts as off.
  Future<void> protection() => toggleProtection(
    context,
    ref,
    target,
    protected: server.protectDelete && server.protectRebuild,
    start: (api, protect) =>
        changeServer(api, server.id, SetServerProtection(protect)),
  );

  /// Name and labels (CMP-047, CMP-087).
  Future<void> edit() => editNameAndLabels(
    context,
    ref,
    target,
    server.labels,
    (api, name, labels) =>
        updateServer(api, server.id, name: name, labels: labels),
  );

  /// Reverse DNS of an IP; empty resets to the default (CMP-042).
  Future<void> reverseDns() => FormSheet.show(
    context,
    title: l10n.reverseDns,
    fields: (_) => [
      FieldSpec('ip', l10n.fieldAddress, initial: server.ipv4 ?? ''),
      FieldSpec(
        'ptr',
        l10n.reverseDns,
        initial: server.ipv4Ptr ?? '',
        helper: l10n.reverseDnsHint,
      ),
    ],
    valid: (v) => (v['ip'] ?? '').trim().isNotEmpty,
    onSave: (v) async {
      await startTracked(
        ref,
        scope,
        (api) => changeServer(
          api,
          server.id,
          ChangeDnsPtr(v['ip']!.trim(), v['ptr'] ?? ''),
        ),
      );
    },
  );

  /// Attaches the server to a network of its project, with an optional
  /// IP; a hint when there is none to pick (CMP-040).
  Future<void> attachNetwork() async {
    final networks = [
      for (final n in await ref.read(networksProvider(scope).future))
        if (!server.networks.any((m) => m.id == n.id)) n,
    ];
    if (!context.mounted) return;
    if (networks.isEmpty) {
      FalcoScaffold.showSnack(context, l10n.serverNoNetworks);
      return;
    }
    await FormSheet.show(
      context,
      title: l10n.networkAttach,
      fields: (_) => [
        FieldSpec(
          'network',
          l10n.resourceNetwork,
          options: {for (final n in networks) '${n.id}': n.name},
        ),
        FieldSpec('ip', l10n.fieldPrivateIp, helper: l10n.privateIpHint),
        FieldSpec('alias', l10n.fieldAliasIps, helper: l10n.aliasIpsHint),
      ],
      valid: (v) => (v['network'] ?? '').isNotEmpty,
      onSave: (v) async {
        await startTracked(
          ref,
          scope,
          (api) => changeServer(
            api,
            server.id,
            AttachToNetwork(
              int.parse(v['network']!),
              ip: v['ip'] ?? '',
              aliasIps: splitIps(v['alias'] ?? ''),
            ),
          ),
        );
      },
    );
  }

  /// Removes the server from [network], level 1 with its name (CMP-041).
  Future<void> detachNetwork(int network, String name) async {
    final ok = await ConfirmSheet.show(
      context,
      title: l10n.networkDetachTitle(server.name, name),
      consequence: l10n.networkDetachConsequence,
      confirmLabel: l10n.actionRemove,
      resourceName: server.name,
      facts: [ConfirmFact(l10n.resourceNetwork, name)],
    );
    if (ok && context.mounted) await _change(DetachFromNetwork(network));
  }

  /// Alias IPs of the server in [network] (NET-086).
  Future<void> aliasIps(int network, List<String> current) => FormSheet.show(
    context,
    title: l10n.fieldAliasIps,
    fields: (_) => [
      FieldSpec(
        'alias',
        l10n.fieldAliasIps,
        initial: current.join(', '),
        helper: l10n.aliasIpsHint,
      ),
    ],
    valid: (_) => true,
    onSave: (v) async {
      await startTracked(
        ref,
        scope,
        (api) => changeServer(
          api,
          server.id,
          ChangeAliasIps(network, splitIps(v['alias'] ?? '')),
        ),
      );
    },
  );

  /// Delete, level 2; volumes stay (CMP-048). Returns whether it started.
  Future<bool> delete() async {
    if (!await confirmDelete(context, target, l10n.deleteConsequence) ||
        !context.mounted) {
      return false;
    }
    return await runAction(
      context,
      ref,
      scope,
      (api) => deleteServer(api, server.id),
    );
  }
}
