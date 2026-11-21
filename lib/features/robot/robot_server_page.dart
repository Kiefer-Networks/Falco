// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/api/robot/robot_client.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/robot/robot.dart';
import 'package:falco/features/robot/robot_page.dart';
import 'package:falco/features/robot/robot_ui.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:material_ui/material_ui.dart';

/// A dedicated server: reset, rescue, Wake on LAN, rename, network,
/// traffic, boot configurations, cancellation (ROB-006 to ROB-016,
/// ROB-035 to ROB-043).
class RobotServerPage extends ConsumerWidget {
  const new({required this.accountId, required this.number, super.key});

  final String accountId;
  final int number;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = robotServerProvider(accountId, number);
    final async = ref.watch(provider);
    final s = async.value;
    if (s == null) {
      return DetailLoading(
        title: l10n.robotServer,
        error: async.error,
        onRetry: () => ref.invalidate(provider),
      );
    }
    return _ServerDetail(accountId: accountId, server: s);
  }
}

class _ServerDetail extends ConsumerWidget {
  const new({required this.accountId, required this.server});

  final String accountId;
  final RobotServer server;

  int get n => server.number;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final a = accountId;
    final s = server;
    final boot = ref.watch(robotBootProvider(a, n)).value ?? const {};
    final rescue = boot[BootKind.rescue];
    final wol = ref.watch(robotWolProvider(a, n)).value ?? false;
    final cancellation = ref.watch(robotCancellationProvider(a, n)).value;
    final traffic = s.ipv4 == null
        ? null
        : ref.watch(robotMonthTrafficProvider(a, s.ipv4!));
    final rdns = {
      for (final r
          in ref.watch(robotRdnsProvider(a)).value ?? const <RobotRdns>[])
        r.ip: r.ptr,
    };
    final active = [
      for (final MapEntry(:key, :value) in boot.entries)
        if (value.active) key,
    ];

    return FalcoScaffold(
      title: l10n.robotServer,
      moreMenu: MoreMenu(
        items: [
          for (final k in const [BootKind.linux, BootKind.vnc])
            if (k != BootKind.vnc || s.vnc)
              MoreMenuItem(
                label: bootText(k, l10n),
                icon: Icons.install_desktop,
                onSelected: () => boot[k]?.active ?? false
                    ? _deactivate(context, ref, k)
                    : _activate(context, ref, k),
              ),
          if (s.windows)
            MoreMenuItem(
              label: bootText(BootKind.windows, l10n),
              icon: Icons.window,
              onSelected: () => boot[BootKind.windows]?.active ?? false
                  ? _deactivate(context, ref, BootKind.windows)
                  : _activate(context, ref, BootKind.windows),
            ),
          for (final k in const [BootKind.rescue, BootKind.linux])
            MoreMenuItem(
              label: lastBootText(k, l10n),
              icon: Icons.history,
              onSelected: () => _showLast(context, ref, k),
            ),
          MoreMenuItem(
            label: l10n.robotFirewall,
            icon: Icons.shield_outlined,
            onSelected: () =>
                RobotFirewallRoute(accountId: a, number: n).push<void>(context),
          ),
          if (s.ipv4 case final ip?)
            MoreMenuItem(
              label: l10n.trafficTitle,
              icon: Icons.swap_vert,
              onSelected: () =>
                  RobotTrafficRoute(accountId: a, ip: ip).push<void>(context),
            ),
        ],
      ),
      body: DetailPage(
        status: serverStatus(s),
        statusDetail: s.cancelled
            ? l10n.cancelledOn(cancellation?.date ?? '')
            : null,
        name: s.label,
        ids: [?s.ipv4, '#${s.number}'],
        onRefresh: () async {
          ref
            ..invalidate(robotBootProvider(a, n))
            ..invalidate(robotCancellationProvider(a, n));
          await refreshQuietly(ref, robotServerProvider(a, n).future);
        },
        actions: [
          ActionTile(
            icon: Icons.restart_alt,
            label: l10n.actionReset,
            onTap: s.reset ? () => _reset(context, ref) : null,
          ),
          ActionTile(
            icon: Icons.medical_services_outlined,
            label: rescue?.active ?? false ? l10n.rescueOff : l10n.rescueOn,
            onTap: !s.rescue
                ? null
                : rescue?.active ?? false
                ? () => _deactivate(context, ref, BootKind.rescue)
                : () => _activate(context, ref, BootKind.rescue),
          ),
          ActionTile(
            icon: Icons.power_settings_new,
            label: l10n.robotWol,
            onTap: wol ? () => wakeOnLan(context, ref, a, s) : null,
          ),
          ActionTile(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            onTap: () => _rename(context, ref),
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionOverview,
            child: FactRows([
              ConfirmFact(l10n.robotNumber, '#${s.number}', mono: true),
              ConfirmFact(l10n.robotProduct, s.product),
              ConfirmFact(l10n.robotDatacenter, s.dc),
              ConfirmFact(l10n.fieldStatus, serverStatus(s).label(l10n)),
              ConfirmFact(l10n.robotPaidUntilLabel, s.paidUntil),
              ConfirmFact(l10n.robotTrafficQuota, s.traffic),
            ]),
          ),
          DetailSection(
            title: l10n.sectionNetwork,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FactRows([
                  if (s.ipv4 case final ip?)
                    ConfirmFact('IPv4', ip, mono: true),
                  if (s.ipv6Net case final net?)
                    ConfirmFact(l10n.robotIpv6Net, net, mono: true),
                ]),
                for (final ip in s.ips)
                  EntryRow(
                    leading: const Icon(Icons.dns_outlined),
                    title: formatIp(ip),
                    subtitle: rdns[ip] ?? l10n.rdnsDefault,
                    onTap: () => editRdns(context, ref, a, ip),
                  ),
                for (final net in s.subnets)
                  EntryRow(
                    leading: const Icon(Icons.lan_outlined),
                    title: net,
                    onTap: () => RobotAddressRoute(
                      accountId: a,
                      kind: AddressKind.subnet,
                      ip: net.split('/').first,
                    ).push<void>(context),
                  ),
              ],
            ),
          ),
          if (traffic != null)
            DetailSection(
              title: l10n.trafficMonth,
              child: switch (traffic) {
                AsyncData(value: final t?) => FactRows([
                  ConfirmFact(l10n.trafficIn, gbText(t.inGb), mono: true),
                  ConfirmFact(l10n.trafficOut, gbText(t.outGb), mono: true),
                  ConfirmFact(l10n.trafficSum, gbText(t.sumGb), mono: true),
                ]),
                AsyncData() => Text(l10n.trafficNone),
                AsyncError(:final error) => Text(
                  robotErrorText(toFalcoError(error), l10n),
                ),
                _ => const LinearProgressIndicator(),
              },
            ),
          DetailSection(
            title: l10n.robotBoot,
            child: Text(
              active.isEmpty
                  ? l10n.bootNone
                  : active.map((k) => bootText(k, l10n)).join(', '),
            ),
          ),
          if (cancellation != null)
            DetailSection(
              title: l10n.cancellation,
              child: FactRows([
                ConfirmFact(
                  l10n.fieldStatus,
                  cancellation.cancelled
                      ? l10n.cancelledOn(cancellation.date ?? '')
                      : l10n.notCancelled,
                ),
                ConfirmFact(l10n.cancelEarliest, cancellation.earliest),
                if (cancellation.cancelled)
                  ConfirmFact(
                    l10n.cancelReserve,
                    yesNo(cancellation.reserved, l10n),
                  ),
              ]),
            ),
        ],
        dangerZone: [
          if (cancellation?.cancelled ?? s.cancelled)
            OutlinedButton.icon(
              onPressed: () => _withdraw(context, ref),
              icon: const Icon(Icons.undo),
              label: Text(l10n.cancelWithdraw),
            )
          else
            DeleteButton(
              label: l10n.robotCancel,
              onPressed: cancellation == null
                  ? null
                  : () => _cancel(context, ref, cancellation),
            ),
        ],
      ),
    );
  }

  List<ProviderOrFamily> _refresh() => [
    robotServerProvider(accountId, n),
    robotServersProvider(accountId),
  ];

  /// Reset with the types the server offers (ROB-009, ROB-035).
  Future<void> _reset(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final List<String> types;
    try {
      types = await ref.read(robotResetTypesProvider(accountId, n).future);
    } on Object catch (e) {
      if (context.mounted) {
        FalcoScaffold.showSnack(context, robotErrorText(toFalcoError(e), l10n));
      }
      return;
    }
    if (!context.mounted) return;
    final type = await ChoiceList.show(
      context,
      title: l10n.actionReset,
      selected: '',
      options: {for (final t in types) t: resetTypeText(t, l10n)},
    );
    if (type != null && context.mounted) {
      await resetServer(context, ref, accountId, server, type);
    }
  }

  /// Rename (ROB-042).
  Future<void> _rename(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final saved = await FormSheet.show(
      context,
      title: l10n.commonEdit,
      fields: (_) => [
        FieldSpec('name', l10n.fieldName, initial: server.name, maxLength: 100),
      ],
      valid: (_) => true,
      onSave: (v) => saveRobot(
        ref,
        accountId,
        (api) => api.renameServer(n, (v['name'] ?? '').trim()),
        command: RobotCommand.rename,
        server: n,
        refresh: <ProviderOrFamily>[
          robotServerProvider(accountId, n),
          robotServersProvider(accountId),
        ],
      ),
    );
    if (saved && context.mounted) {
      FalcoScaffold.showSnack(context, l10n.robotDone);
    }
  }

  /// Activates rescue or an installation: options of the server, SSH keys
  /// from Robot, the password shown once (ROB-011, ROB-039 to ROB-041).
  /// An installation wipes the disks, so it needs the typed name.
  Future<void> _activate(
    BuildContext context,
    WidgetRef ref,
    String kind,
  ) async {
    final l10n = AppLocalizations.of(context);
    final api = ref.read(robotApiProvider(accountId));
    final BootOption options;
    final List<RobotKey> keys;
    try {
      options = await api.bootOption(n, kind);
      keys = kind == BootKind.rescue || kind == BootKind.linux
          ? await api.keys()
          : const [];
    } on Object catch (e) {
      if (context.mounted) {
        FalcoScaffold.showSnack(context, robotErrorText(toFalcoError(e), l10n));
      }
      return;
    }
    if (!context.mounted) return;
    Map<String, String> choice(List<String> values) => {
      for (final v in values) v: v,
    };
    Map<String, String>? picked;
    final ok = await FormSheet.show(
      context,
      title: bootText(kind, l10n),
      fields: (_) => [
        if (options.os.isNotEmpty)
          FieldSpec(
            'os',
            l10n.bootOs,
            initial: options.os.first,
            options: choice(options.os),
          ),
        if (options.dist.isNotEmpty && kind != BootKind.windows)
          FieldSpec(
            'dist',
            l10n.bootDist,
            initial: options.dist.first,
            options: choice(options.dist),
          ),
        if (options.arch.isNotEmpty)
          FieldSpec(
            'arch',
            l10n.fieldArchitecture,
            initial: options.arch.first,
            options: {for (final a in options.arch) a: '$a bit'},
          ),
        if (options.lang.isNotEmpty)
          FieldSpec(
            'lang',
            l10n.bootLang,
            initial: options.lang.first,
            options: choice(options.lang),
          ),
        if (keys.isNotEmpty)
          FieldSpec(
            'keys',
            l10n.resourceSshKeys,
            multiple: true,
            helper: l10n.bootKeysHint,
            options: {for (final k in keys) k.fingerprint: k.name},
          ),
      ],
      valid: (_) => true,
      onSave: (v) async => picked = v,
    );
    final v = picked;
    if (!ok || v == null || !context.mounted) return;
    if (kind != BootKind.rescue &&
        !await ConfirmSheet.show(
          context,
          title: l10n.installTitle(server.label),
          consequence: l10n.installConsequence,
          confirmLabel: l10n.bootActivate,
          resourceName: server.label,
          level: ConfirmLevel.typeName,
          destructive: true,
        )) {
      return;
    }
    if (!context.mounted) return;
    String? value(String key) => switch (v[key]) {
      final x? when x.isNotEmpty => x,
      _ => null,
    };
    BootOption? result;
    final done = await runRobot(
      context,
      ref,
      accountId,
      (api) async => result = await api.activateBoot(
        n,
        kind,
        os: value('os'),
        dist: value('dist'),
        arch: value('arch'),
        lang: value('lang'),
        keys: [
          for (final k in (v['keys'] ?? '').split(','))
            if (k.isNotEmpty) k,
        ],
      ),
      command: RobotCommand.bootOn,
      server: n,
      refresh: <ProviderOrFamily>[robotBootProvider(accountId, n)],
      done: l10n.bootActivated,
    );
    final password = result?.password;
    if (done && password != null && context.mounted) {
      await showSecretSheet(
        context,
        title: bootText(kind, l10n),
        note: l10n.bootPasswordNote,
        secrets: {l10n.fieldRootPassword: password},
      );
    }
  }

  /// Turns rescue or an installation off (ROB-012).
  Future<void> _deactivate(
    BuildContext context,
    WidgetRef ref,
    String kind,
  ) async {
    final l10n = AppLocalizations.of(context);
    final ok = await ConfirmSheet.show(
      context,
      title: l10n.bootOffTitle(bootText(kind, l10n), server.label),
      consequence: l10n.bootOffConsequence,
      confirmLabel: l10n.bootDeactivate,
      resourceName: server.label,
    );
    if (ok && context.mounted) {
      await runRobot(
        context,
        ref,
        accountId,
        (api) => api.deactivateBoot(n, kind),
        command: RobotCommand.bootOff,
        server: n,
        refresh: <ProviderOrFamily>[robotBootProvider(accountId, n)],
      );
    }
  }

  /// The last rescue or Linux activation with its password (ROB-038,
  /// ROB-039).
  Future<void> _showLast(
    BuildContext context,
    WidgetRef ref,
    String kind,
  ) async {
    final l10n = AppLocalizations.of(context);
    final BootOption last;
    try {
      last = await ref.read(robotApiProvider(accountId)).lastBoot(n, kind);
    } on Object catch (e) {
      if (context.mounted) {
        FalcoScaffold.showSnack(context, robotErrorText(toFalcoError(e), l10n));
      }
      return;
    }
    if (!context.mounted) return;
    await showSecretSheet(
      context,
      title: lastBootText(kind, l10n),
      note: [
        ...last.os,
        ...last.dist,
        ...last.lang,
        if (last.active) l10n.statusActive,
      ].join(' · '),
      secrets: {l10n.fieldRootPassword: ?last.password},
    );
  }

  /// Cancels at a date from the earliest one on, with reason and the
  /// location reservation (ROB-014, BUG-013).
  Future<void> _cancel(
    BuildContext context,
    WidgetRef ref,
    RobotCancellation c,
  ) async {
    final l10n = AppLocalizations.of(context);
    final date = await pickCancellationDate(context, earliest: c.earliest);
    if (date == null || !context.mounted) return;
    Map<String, String>? picked;
    final ok = await FormSheet.show(
      context,
      title: l10n.robotCancel,
      fields: (_) => [
        if (c.reasons.isNotEmpty)
          FieldSpec(
            'reason',
            l10n.cancelReason,
            options: {'': l10n.commonNone, for (final r in c.reasons) r: r},
          ),
        if (c.reservationPossible)
          FieldSpec(
            'reserve',
            l10n.cancelReserve,
            initial: 'false',
            helper: l10n.cancelReserveHint,
            options: {'true': l10n.commonYes, 'false': l10n.commonNo},
          ),
      ],
      valid: (_) => true,
      onSave: (v) async => picked = v,
    );
    final v = picked;
    if (!ok || v == null || !context.mounted) return;
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.cancelTitle(server.label),
      consequence: l10n.cancelConsequence,
      confirmLabel: l10n.robotCancel,
      resourceName: server.label,
      level: ConfirmLevel.typeName,
      destructive: true,
      facts: [ConfirmFact(l10n.cancelDate, cancelDateText(date, l10n))],
    );
    if (!confirmed || !context.mounted) return;
    await runRobot(
      context,
      ref,
      accountId,
      (api) => api.cancelServer(
        n,
        date: date,
        reason: v['reason'],
        reserve: c.reservationPossible ? v['reserve'] == 'true' : null,
      ),
      command: RobotCommand.cancel,
      server: n,
      refresh: <ProviderOrFamily>[
        robotCancellationProvider(accountId, n),
        ..._refresh(),
      ],
    );
  }

  /// Withdraws a pending cancellation (ROB-015).
  Future<void> _withdraw(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await ConfirmSheet.show(
      context,
      title: l10n.cancelWithdrawTitle(server.label),
      consequence: l10n.cancelWithdrawConsequence,
      confirmLabel: l10n.cancelWithdraw,
      resourceName: server.label,
    );
    if (ok && context.mounted) {
      await runRobot(
        context,
        ref,
        accountId,
        (api) => api.withdrawCancellation(n),
        command: RobotCommand.withdraw,
        server: n,
        refresh: <ProviderOrFamily>[
          robotCancellationProvider(accountId, n),
          ..._refresh(),
        ],
      );
    }
  }
}

/// Name of a boot configuration.
String bootText(String kind, AppLocalizations l10n) => switch (kind) {
  BootKind.rescue => l10n.bootRescue,
  BootKind.linux => l10n.bootLinux,
  BootKind.vnc => l10n.bootVnc,
  _ => l10n.bootWindows,
};

/// "Last rescue activation" or "Last Linux installation".
String lastBootText(String kind, AppLocalizations l10n) =>
    kind == BootKind.rescue ? l10n.bootLastRescue : l10n.bootLastLinux;

/// Gigabytes with two decimals.
String gbText(double gb) => '${gb.toStringAsFixed(2)} GB';
