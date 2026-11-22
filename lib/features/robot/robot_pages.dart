// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/api/robot/robot_client.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/actions/action_tracker.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/features/activity/activity_page.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/robot/robot.dart';
import 'package:falco/features/robot/robot_server_page.dart';
import 'package:falco/features/robot/robot_ui.dart';
import 'package:falco/features/ssh_keys/openssh.dart';
import 'package:falco/features/ssh_keys/ssh_key_pages.dart';
import 'package:falco/features/ssh_keys/ssh_keys.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:material_ui/material_ui.dart';

/// A Robot detail before it loaded.
Widget? _loading<T>(
  WidgetRef ref,
  AsyncValue<T> async,
  String title,
  VoidCallback retry,
) => async.hasValue
    ? null
    : DetailLoading(title: title, error: async.error, onRetry: retry);

/// One failover IP: route to another server, unroute (ROB-018, ROB-019,
/// ROB-044).
class RobotFailoverPage extends ConsumerWidget {
  const new({required this.accountId, required this.ip, super.key});

  final String accountId;
  final String ip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final a = accountId;
    final provider = robotFailoversProvider(a);
    final async = ref.watch(provider);
    if (_loading(ref, async, l10n.robotFailover, () => ref.invalidate(provider))
        case final w?) {
      return w;
    }
    final f = async.requireValue.where((f) => f.ip == ip).firstOrNull;
    if (f == null) {
      return DetailLoading(
        title: l10n.robotFailover,
        error: const NotFound(),
        onRetry: () => ref.invalidate(provider),
      );
    }
    final names = serverNames(ref, a);
    final refresh = <ProviderOrFamily>[provider];
    final active = f.activeServerIp;

    Future<void> route() async {
      // The current target from `GET /failover/{ip}` (ROB-044); the new
      // one must differ (ROB-018).
      final RobotFailover current;
      final List<RobotServer> servers;
      try {
        final api = ref.read(robotApiProvider(a));
        current = await api.failover(ip);
        if (!context.mounted) return;
        servers = await ref.read(robotServersProvider(a).future);
      } on Object catch (e) {
        if (context.mounted) {
          FalcoScaffold.showSnack(
            context,
            robotErrorText(toFalcoError(e), l10n),
          );
        }
        return;
      }
      final v6 = ip.contains(':');
      final targets = {
        for (final s in servers)
          if (v6 ? s.ipv6Net : s.ipv4 case final t?
              when t != current.activeServerIp)
            t: s.label,
      };
      if (!context.mounted) return;
      if (targets.isEmpty) {
        FalcoScaffold.showSnack(context, l10n.failoverNoTargets);
        return;
      }
      final target = await ChoiceList.show(
        context,
        title: l10n.failoverRoute,
        selected: '',
        options: targets,
        details: {for (final t in targets.keys) t: t},
        searchable: true,
      );
      if (target == null || !context.mounted) return;
      final ok = await ConfirmSheet.show(
        context,
        title: l10n.failoverRouteTitle(ip, targets[target]!),
        consequence: l10n.failoverRouteConsequence,
        confirmLabel: l10n.failoverRoute,
        resourceName: ip,
      );
      if (ok && context.mounted) {
        await runRobot(
          context,
          ref,
          a,
          (api) => api.routeFailover(ip, target),
          command: RobotCommand.failover,
          refresh: refresh,
        );
      }
    }

    return FalcoScaffold(
      title: l10n.robotFailover,
      body: DetailPage(
        status: active == null ? ResourceStatus.off : ResourceStatus.active,
        statusDetail: active == null
            ? l10n.failoverUnrouted
            : l10n.failoverActiveOn(names[active] ?? active),
        name: formatIp(f.ip),
        ids: [
          DetailId(formatIp(f.ip), icon: Icons.public, copy: true),
          DetailId(f.netmask, icon: Icons.lan_outlined),
        ],
        facts: [
          Fact(l10n.failoverOwner, text: names[f.serverIp] ?? f.serverIp),
          Fact(
            l10n.failoverActive,
            text: active == null ? l10n.commonNone : names[active] ?? active,
          ),
        ],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          DetailAction(
            icon: Icons.alt_route,
            label: l10n.failoverRoute,
            group: ActionGroup.network,
            onTap: route,
          ),
          DetailAction(
            icon: Icons.link_off,
            label: l10n.failoverUnroute,
            group: ActionGroup.network,
            onTap: active == null
                ? null
                : () async {
                    final ok = await ConfirmSheet.show(
                      context,
                      title: l10n.failoverUnrouteTitle(ip),
                      consequence: l10n.failoverUnrouteConsequence,
                      confirmLabel: l10n.failoverUnroute,
                      resourceName: ip,
                      destructive: true,
                    );
                    if (ok && context.mounted) {
                      await runRobot(
                        context,
                        ref,
                        a,
                        (api) => api.unrouteFailover(ip),
                        command: RobotCommand.failover,
                        refresh: refresh,
                      );
                    }
                  },
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionNetwork,
            facts: [
              Fact(l10n.fieldAddress, text: formatIp(f.ip), copy: true),
              Fact(l10n.robotNetmask, text: f.netmask, mono: true),
              Fact(l10n.failoverOwner, text: f.serverIp, copy: true),
              if (active != null)
                Fact(l10n.failoverActive, text: active, copy: true),
            ],
          ),
        ],
      ),
    );
  }
}

/// Valid vSwitch VLAN ids (ROB-025, ROB-030).
bool validVlan(String v) => switch (int.tryParse(v.trim())) {
  final n? => n >= 4000 && n <= 4091,
  _ => false,
};

/// One vSwitch: servers, edit, add and remove servers, cancel (ROB-026
/// to ROB-031).
class RobotVSwitchPage extends ConsumerWidget {
  const new({required this.accountId, required this.id, super.key});

  final String accountId;
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final a = accountId;
    final provider = robotVSwitchProvider(a, id);
    final async = ref.watch(provider);
    if (_loading(ref, async, l10n.robotVSwitch, () => ref.invalidate(provider))
        case final w?) {
      return w;
    }
    final v = async.requireValue;
    final names = serverNumbers(ref, a);
    final refresh = <ProviderOrFamily>[provider, robotVSwitchesProvider(a)];

    Future<void> add() async {
      final List<RobotServer> servers;
      try {
        servers = await ref.read(robotServersProvider(a).future);
      } on Object catch (e) {
        if (context.mounted) {
          FalcoScaffold.showSnack(
            context,
            robotErrorText(toFalcoError(e), l10n),
          );
        }
        return;
      }
      final inside = {for (final s in v.servers) s.number};
      if (!context.mounted) return;
      final pick = await ChoiceList.show(
        context,
        title: l10n.vswitchAddServer,
        selected: '',
        searchable: true,
        options: {
          for (final s in servers)
            if (!inside.contains(s.number)) '${s.number}': s.label,
        },
        details: {
          for (final s in servers) '${s.number}': '${s.ipv4 ?? ''} · ${s.dc}',
        },
      );
      if (pick != null && context.mounted) {
        await runRobot(
          context,
          ref,
          a,
          (api) => api.addVSwitchServers(id, [int.parse(pick)]),
          command: RobotCommand.vswitch,
          refresh: refresh,
        );
      }
    }

    Future<void> remove(VSwitchServer s) async {
      final name = names[s.number] ?? '#${s.number}';
      final ok = await ConfirmSheet.show(
        context,
        title: l10n.vswitchRemoveTitle(name, v.name),
        consequence: l10n.vswitchRemoveConsequence,
        confirmLabel: l10n.actionRemove,
        resourceName: name,
      );
      if (ok && context.mounted) {
        await runRobot(
          context,
          ref,
          a,
          (api) => api.removeVSwitchServers(id, [s.number]),
          command: RobotCommand.vswitch,
          refresh: refresh,
        );
      }
    }

    Future<void> cancel() async {
      final date = await pickCancellationDate(context);
      if (date == null || !context.mounted) return;
      final ok = await ConfirmSheet.show(
        context,
        title: l10n.cancelTitle(v.name),
        consequence: l10n.vswitchCancelConsequence,
        confirmLabel: l10n.robotCancel,
        resourceName: v.name,
        level: ConfirmLevel.typeName,
        destructive: true,
        facts: [ConfirmFact(l10n.cancelDate, cancelDateText(date, l10n))],
      );
      if (!ok || !context.mounted) return;
      final done = await runRobot(
        context,
        ref,
        a,
        (api) => api.cancelVSwitch(id, date),
        command: RobotCommand.vswitch,
        refresh: refresh,
      );
      if (done && date == 'now' && context.mounted) Navigator.pop(context);
    }

    return FalcoScaffold(
      title: l10n.robotVSwitch,
      body: DetailPage(
        status: v.cancelled ? ResourceStatus.cancelled : ResourceStatus.active,
        name: v.name,
        ids: [DetailId('#${v.id}', copy: true, copyText: '${v.id}')],
        facts: [
          Fact('VLAN', text: '${v.vlan}', mono: true),
          Fact(l10n.robotServers, text: '${v.servers.length}'),
        ],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          DetailAction(
            icon: Icons.add_link,
            label: l10n.vswitchAddServer,
            group: ActionGroup.network,
            onTap: v.cancelled ? null : add,
          ),
          DetailAction(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            group: ActionGroup.manage,
            onTap: () => FormSheet.show(
              context,
              title: l10n.commonEdit,
              fields: (_) => [
                FieldSpec('name', l10n.fieldName, initial: v.name),
                FieldSpec(
                  'vlan',
                  'VLAN',
                  initial: '${v.vlan}',
                  helper: l10n.vlanHint,
                ),
              ],
              valid: (x) =>
                  (x['name'] ?? '').trim().isNotEmpty &&
                  validVlan(x['vlan'] ?? ''),
              onSave: (x) => saveRobot(
                ref,
                a,
                (api) => api.updateVSwitch(
                  id,
                  x['name']!.trim(),
                  int.parse(x['vlan']!.trim()),
                ),
                command: RobotCommand.vswitch,
                refresh: refresh,
              ),
            ),
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.robotServers,
            cards: [
              for (final s in v.servers)
                RelatedCard(
                  icon: Icons.dns_outlined,
                  title: names[s.number] ?? '#${s.number}',
                  subtitle: '${s.ip} · ${s.status}',
                  onTap: () => RobotServerRoute(
                    accountId: a,
                    number: s.number,
                  ).push<void>(context),
                  trailing: v.cancelled
                      ? null
                      : IconButton(
                          tooltip: l10n.actionRemove,
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => remove(s),
                        ),
                ),
            ],
            child: v.servers.isEmpty
                ? entries(const [], l10n.vswitchNoServers)
                : null,
          ),
          if (v.subnets.isNotEmpty || v.cloudNetworks.isNotEmpty)
            DetailSection(
              title: l10n.sectionNetwork,
              facts: [
                for (final s in v.subnets)
                  Fact(l10n.robotSubnet, text: s, copy: true),
                for (final c in v.cloudNetworks)
                  Fact(l10n.resourceNetwork, text: c, mono: true),
              ],
            ),
        ],
        dangerZone: [
          if (!v.cancelled)
            DeleteButton(label: l10n.robotCancel, onPressed: cancel),
        ],
      ),
    );
  }
}

/// One Robot SSH key: rename, delete (ROB-034, ROB-047, ROB-048).
class RobotKeyPage extends ConsumerWidget {
  const new({required this.accountId, required this.fingerprint, super.key});

  final String accountId;
  final String fingerprint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final a = accountId;
    final provider = robotKeyProvider(a, fingerprint);
    final async = ref.watch(provider);
    if (_loading(
          ref,
          async,
          l10n.resourceSshKey,
          () => ref.invalidate(provider),
        )
        case final w?) {
      return w;
    }
    final k = async.requireValue;
    final refresh = <ProviderOrFamily>[provider, robotKeysProvider(a)];
    return FalcoScaffold(
      title: l10n.resourceSshKey,
      body: DetailPage(
        name: k.name,
        ids: [DetailId(k.fingerprint, icon: Icons.fingerprint, copy: true)],
        facts: [
          Fact(l10n.fieldType, text: k.type, mono: true),
          Fact(l10n.keyBits, text: '${k.size}'),
          Fact(l10n.fieldCreated, text: k.created),
        ],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          DetailAction(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            group: ActionGroup.manage,
            onTap: () => FormSheet.show(
              context,
              title: l10n.commonEdit,
              fields: (_) => [
                FieldSpec('name', l10n.fieldName, initial: k.name),
              ],
              valid: (v) => (v['name'] ?? '').trim().isNotEmpty,
              onSave: (v) => saveRobot(
                ref,
                a,
                (api) => api.renameKey(fingerprint, v['name']!.trim()),
                command: RobotCommand.key,
                refresh: refresh,
              ),
            ),
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.fieldPublicKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Mono(k.data, maxLines: 8),
            ),
          ),
        ],
        dangerZone: [
          DeleteButton(
            onPressed: () async {
              final ok = await ConfirmSheet.show(
                context,
                title: l10n.deleteTitle(k.name),
                consequence: l10n.robotKeyDeleteConsequence,
                confirmLabel: l10n.actionDelete,
                resourceName: k.name,
                destructive: true,
              );
              if (!ok || !context.mounted) return;
              final done = await runRobot(
                context,
                ref,
                a,
                (api) => api.deleteKey(fingerprint),
                command: RobotCommand.key,
                refresh: <ProviderOrFamily>[robotKeysProvider(a)],
                done: l10n.deletedMessage(k.name),
              );
              if (done && context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

/// One single IP or subnet: traffic warnings, separate MAC, cancellation,
/// traffic (ROB-049 to ROB-056).
class RobotAddressPage extends ConsumerWidget {
  const new({
    required this.accountId,
    required this.kind,
    required this.ip,
    super.key,
  });

  final String accountId;
  final AddressKind kind;
  final String ip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final a = accountId;
    final title = kind == AddressKind.ip ? l10n.robotIp : l10n.robotSubnet;
    final provider = robotAddressProvider(a, kind, ip);
    final async = ref.watch(provider);
    if (_loading(ref, async, title, () => ref.invalidate(provider))
        case final w?) {
      return w;
    }
    final x = async.requireValue;
    final mac = ref.watch(robotMacProvider(a, kind, ip)).value;
    final cancellation = ref
        .watch(robotAddressCancellationProvider(a, kind, ip))
        .value;
    final names = serverNumbers(ref, a);

    Future<void> warnings() async {
      final saved = await FormSheet.show(
        context,
        title: l10n.trafficWarnings,
        fields: (_) => [
          FieldSpec(
            'on',
            l10n.trafficWarnings,
            initial: '${x.warnings}',
            options: {'true': l10n.commonYes, 'false': l10n.commonNo},
          ),
          FieldSpec('hourly', l10n.trafficHourly, initial: '${x.hourly}'),
          FieldSpec('daily', l10n.trafficDaily, initial: '${x.daily}'),
          FieldSpec('monthly', l10n.trafficMonthly, initial: '${x.monthly}'),
        ],
        valid: (v) => [
          'hourly',
          'daily',
          'monthly',
        ].every((k) => (int.tryParse(v[k] ?? '') ?? -1) >= 0),
        onSave: (v) => saveRobot(
          ref,
          a,
          (api) => api.setTrafficWarnings(
            kind,
            ip,
            enabled: v['on'] == 'true',
            hourly: int.parse(v['hourly']!),
            daily: int.parse(v['daily']!),
            monthly: int.parse(v['monthly']!),
          ),
          command: RobotCommand.address,
          refresh: <ProviderOrFamily>[
            provider,
            robotAddressesProvider(a, kind),
          ],
        ),
      );
      if (saved && context.mounted) {
        FalcoScaffold.showSnack(context, l10n.robotDone);
      }
    }

    Future<void> toggleMac() async {
      final on = mac?.$2 == null;
      final ok = await ConfirmSheet.show(
        context,
        title: on ? l10n.macOnTitle(ip) : l10n.macOffTitle(ip),
        consequence: on ? l10n.macOnConsequence : l10n.macOffConsequence,
        confirmLabel: on ? l10n.macOn : l10n.macOff,
        resourceName: ip,
      );
      if (ok && context.mounted) {
        await runRobot(
          context,
          ref,
          a,
          (api) => api.setMac(kind, ip, on: on),
          command: RobotCommand.address,
          refresh: <ProviderOrFamily>[robotMacProvider(a, kind, ip), provider],
        );
      }
    }

    Future<void> cancel(AddressCancellation c) async {
      final date = await pickCancellationDate(context, earliest: c.earliest);
      if (date == null || !context.mounted) return;
      final name = addressText(x, kind);
      final ok = await ConfirmSheet.show(
        context,
        title: l10n.cancelTitle(name),
        consequence: l10n.addressCancelConsequence,
        confirmLabel: l10n.robotCancel,
        resourceName: x.ip,
        level: ConfirmLevel.typeName,
        destructive: true,
        facts: [ConfirmFact(l10n.cancelDate, cancelDateText(date, l10n))],
      );
      if (ok && context.mounted) {
        await runRobot(
          context,
          ref,
          a,
          (api) => api.cancelAddress(kind, ip, date),
          command: RobotCommand.cancel,
          refresh: <ProviderOrFamily>[
            robotAddressCancellationProvider(a, kind, ip),
          ],
        );
      }
    }

    Future<void> withdraw() async {
      final ok = await ConfirmSheet.show(
        context,
        title: l10n.cancelWithdrawTitle(addressText(x, kind)),
        consequence: l10n.cancelWithdrawConsequence,
        confirmLabel: l10n.cancelWithdraw,
        resourceName: x.ip,
      );
      if (ok && context.mounted) {
        await runRobot(
          context,
          ref,
          a,
          (api) => api.withdrawAddressCancellation(kind, ip),
          command: RobotCommand.withdraw,
          refresh: <ProviderOrFamily>[
            robotAddressCancellationProvider(a, kind, ip),
          ],
        );
      }
    }

    final macPossible = mac?.$1 ?? false;
    return FalcoScaffold(
      title: title,
      body: DetailPage(
        status: x.locked ? ResourceStatus.locked : ResourceStatus.active,
        name: addressText(x, kind),
        ids: [DetailId(addressText(x, kind), icon: Icons.public, copy: true)],
        facts: [
          Fact(
            l10n.robotServer,
            text: names[x.serverNumber] ?? '#${x.serverNumber}',
          ),
          if (kind == AddressKind.subnet)
            Fact(l10n.robotFailover, on: x.failover),
          Fact(l10n.robotLocked, on: x.locked),
        ],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          DetailAction(
            icon: Icons.notifications_outlined,
            label: l10n.trafficWarnings,
            group: ActionGroup.manage,
            onTap: warnings,
          ),
          DetailAction(
            icon: Icons.settings_ethernet,
            label: mac?.$2 == null ? l10n.macOn : l10n.macOff,
            group: ActionGroup.network,
            onTap: macPossible ? toggleMac : null,
          ),
          DetailAction(
            icon: Icons.swap_vert,
            label: l10n.trafficTitle,
            group: ActionGroup.manage,
            onTap: () => RobotTrafficRoute(
              accountId: a,
              ip: kind == AddressKind.ip ? x.ip : null,
              subnet: kind == AddressKind.subnet ? x.ip : null,
            ).push<void>(context),
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionNetwork,
            facts: [
              Fact(l10n.fieldAddress, text: addressText(x, kind), copy: true),
              if (x.gateway case final g?)
                Fact(l10n.fieldGateway, text: g, copy: true),
              if (x.broadcast case final b?)
                Fact(l10n.robotBroadcast, text: b, mono: true),
              if (mac?.$2 case final m? when macPossible)
                Fact(l10n.robotMac, text: m, copy: true)
              else
                Fact(
                  l10n.robotMac,
                  text: macPossible ? l10n.commonNone : l10n.macUnavailable,
                ),
            ],
          ),
          DetailSection(
            title: l10n.robotServer,
            cards: [
              RelatedCard(
                icon: Icons.dns_outlined,
                title: names[x.serverNumber] ?? '#${x.serverNumber}',
                subtitle: '#${x.serverNumber}',
                onTap: () => RobotServerRoute(
                  accountId: a,
                  number: x.serverNumber,
                ).push<void>(context),
              ),
            ],
          ),
          DetailSection(
            title: l10n.trafficWarnings,
            facts: [
              Fact(l10n.trafficWarnings, on: x.warnings),
              Fact(l10n.trafficHourly, text: '${x.hourly}', mono: true),
              Fact(l10n.trafficDaily, text: '${x.daily}', mono: true),
              Fact(l10n.trafficMonthly, text: '${x.monthly}', mono: true),
            ],
          ),
          if (cancellation != null)
            DetailSection(
              title: l10n.cancellation,
              facts: [
                Fact(
                  l10n.fieldStatus,
                  text: cancellation.cancelled
                      ? l10n.cancelledOn(cancellation.date ?? '')
                      : l10n.notCancelled,
                ),
                Fact(l10n.cancelEarliest, text: cancellation.earliest),
              ],
            ),
        ],
        dangerZone: [
          if (cancellation?.cancelled ?? false)
            OutlinedButton.icon(
              onPressed: withdraw,
              icon: const Icon(Icons.undo),
              label: Text(l10n.cancelWithdraw),
            )
          else
            DeleteButton(
              label: l10n.robotCancel,
              onPressed: cancellation == null
                  ? null
                  : () => cancel(cancellation),
            ),
        ],
      ),
    );
  }
}

/// The firewall of a server: status, IPv6 filter, Hetzner services,
/// rules, apply a template, clear (ROB-057).
class RobotFirewallPage extends ConsumerStatefulWidget {
  const new({required this.accountId, required this.number, super.key});

  final String accountId;
  final int number;

  @override
  ConsumerState<RobotFirewallPage> createState() => _RobotFirewallPageState();
}

class _RobotFirewallPageState extends ConsumerState<RobotFirewallPage> {
  /// Unsaved edits; null shows what Robot has.
  RobotFirewall? _draft;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final a = widget.accountId;
    final n = widget.number;
    final provider = robotFirewallProvider(a, n);
    final async = ref.watch(provider);
    if (_loading(ref, async, l10n.robotFirewall, () => ref.invalidate(provider))
        case final w?) {
      return w;
    }
    final f = _draft ?? async.requireValue;
    final active = f.status == 'active';
    void edit(RobotFirewall next) => setState(() => _draft = next);
    RobotFirewall copy({
      String? status,
      bool? filterIpv6,
      bool? whitelistHos,
      FirewallRules? rules,
    }) => (
      id: f.id,
      name: f.name,
      status: status ?? f.status,
      filterIpv6: filterIpv6 ?? f.filterIpv6,
      whitelistHos: whitelistHos ?? f.whitelistHos,
      isDefault: f.isDefault,
      port: f.port,
      rules: rules ?? f.rules,
    );

    Future<void> apply({int? template}) async {
      final done = await runRobot(
        context,
        ref,
        a,
        (api) => api.setFirewall(
          n,
          active: f.status != 'disabled',
          filterIpv6: f.filterIpv6,
          whitelistHos: f.whitelistHos,
          rules: f.rules,
          templateId: template,
        ),
        command: RobotCommand.firewall,
        server: n,
        refresh: <ProviderOrFamily>[provider],
      );
      if (done && mounted) setState(() => _draft = null);
    }

    Future<void> useTemplate() async {
      Future<T?> load<T>(Future<T> future) async {
        try {
          return await future;
        } on Object catch (e) {
          if (context.mounted) {
            FalcoScaffold.showSnack(
              context,
              robotErrorText(toFalcoError(e), l10n),
            );
          }
          return null;
        }
      }

      final templates = await load(ref.read(robotTemplatesProvider(a).future));
      if (templates == null || !context.mounted) return;
      final pick = await ChoiceList.show(
        context,
        title: l10n.firewallUseTemplate,
        selected: '',
        options: {for (final t in templates) '${t.id}': t.name},
      );
      if (pick == null) return;
      // The list carries no rules; the confirmation counts them.
      final t = await load(
        ref.read(robotTemplateProvider(a, int.parse(pick)).future),
      );
      if (t == null || !context.mounted) return;
      final ok = await ConfirmSheet.show(
        context,
        title: l10n.firewallTemplateApplyTitle(t.name),
        consequence: l10n.firewallTemplateApplyConsequence,
        confirmLabel: l10n.firewallUseTemplate,
        resourceName: t.name,
        level: ConfirmLevel.typeName,
        facts: [
          ConfirmFact(
            l10n.firewallRules,
            '${t.rules.values.fold(0, (n, r) => n + r.length)}',
          ),
        ],
        destructive: true,
      );
      if (ok && context.mounted) await apply(template: t.id);
    }

    Future<void> clear() async {
      final ok = await ConfirmSheet.show(
        context,
        title: l10n.firewallClearTitle,
        consequence: l10n.firewallClearConsequence,
        confirmLabel: l10n.firewallClear,
        resourceName: '#$n',
        destructive: true,
      );
      if (ok && context.mounted) {
        await runRobot(
          context,
          ref,
          a,
          (api) => api.clearFirewall(n),
          command: RobotCommand.firewall,
          server: n,
          refresh: <ProviderOrFamily>[provider],
        );
        if (mounted) setState(() => _draft = null);
      }
    }

    return FalcoScaffold(
      title: l10n.robotFirewall,
      body: DetailPage(
        status: switch (f.status) {
          'active' => ResourceStatus.active,
          'disabled' => ResourceStatus.off,
          _ => ResourceStatus.inProgress,
        },
        statusDetail: _draft == null ? null : l10n.firewallUnsaved,
        name: l10n.robotFirewall,
        ids: [
          DetailId('#$n', copy: true, copyText: '$n'),
          if (f.port.isNotEmpty)
            DetailId(f.port, icon: Icons.settings_ethernet),
        ],
        onRefresh: () async {
          setState(() => _draft = null);
          await refreshQuietly(ref, provider.future);
        },
        actions: [
          DetailAction(
            icon: Icons.save_outlined,
            label: l10n.firewallApply,
            group: ActionGroup.network,
            onTap: _draft == null ? null : apply,
          ),
          DetailAction(
            icon: active ? Icons.shield : Icons.shield_outlined,
            label: active ? l10n.firewallDisable : l10n.firewallEnable,
            group: ActionGroup.manage,
            onTap: () => edit(copy(status: active ? 'disabled' : 'active')),
          ),
          DetailAction(
            label: l10n.firewallUseTemplate,
            icon: Icons.copy_all,
            group: ActionGroup.manage,
            onTap: useTemplate,
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionConfiguration,
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.firewallFilterIpv6),
                  value: f.filterIpv6,
                  onChanged: (v) => edit(copy(filterIpv6: v)),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.firewallHetznerServices),
                  value: f.whitelistHos,
                  onChanged: (v) => edit(copy(whitelistHos: v)),
                ),
              ],
            ),
          ),
          DetailSection(
            title: l10n.firewallRules,
            child: RulesSection(
              rules: f.rules,
              onChanged: (r) => edit(copy(rules: r)),
            ),
          ),
        ],
        dangerZone: [DeleteButton(label: l10n.firewallClear, onPressed: clear)],
      ),
    );
  }
}

/// One firewall template: settings, rules, delete (ROB-058).
class RobotTemplatePage extends ConsumerStatefulWidget {
  const new({required this.accountId, required this.id, super.key});

  final String accountId;
  final int id;

  @override
  ConsumerState<RobotTemplatePage> createState() => _RobotTemplatePageState();
}

class _RobotTemplatePageState extends ConsumerState<RobotTemplatePage> {
  RobotFirewall? _draft;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final a = widget.accountId;
    final provider = robotTemplateProvider(a, widget.id);
    final async = ref.watch(provider);
    if (_loading(ref, async, l10n.robotTemplate, () => ref.invalidate(provider))
        case final w?) {
      return w;
    }
    final t = _draft ?? async.requireValue;
    final refresh = <ProviderOrFamily>[provider, robotTemplatesProvider(a)];
    RobotFirewall copy({
      String? name,
      bool? filterIpv6,
      bool? whitelistHos,
      bool? isDefault,
      FirewallRules? rules,
    }) => (
      id: t.id,
      name: name ?? t.name,
      status: t.status,
      filterIpv6: filterIpv6 ?? t.filterIpv6,
      whitelistHos: whitelistHos ?? t.whitelistHos,
      isDefault: isDefault ?? t.isDefault,
      port: t.port,
      rules: rules ?? t.rules,
    );
    void edit(RobotFirewall next) => setState(() => _draft = next);

    return FalcoScaffold(
      title: l10n.robotTemplate,
      body: DetailPage(
        statusDetail: _draft == null ? null : l10n.firewallUnsaved,
        status: _draft == null ? null : ResourceStatus.inProgress,
        name: t.name,
        ids: [DetailId('#${t.id}', copy: true, copyText: '${t.id}')],
        onRefresh: () async {
          setState(() => _draft = null);
          await refreshQuietly(ref, provider.future);
        },
        actions: [
          DetailAction(
            icon: Icons.save_outlined,
            label: l10n.commonSave,
            group: ActionGroup.manage,
            onTap: _draft == null
                ? null
                : () async {
                    final done = await runRobot(
                      context,
                      ref,
                      a,
                      (api) => api.saveTemplate(
                        id: t.id,
                        name: t.name,
                        filterIpv6: t.filterIpv6,
                        whitelistHos: t.whitelistHos,
                        isDefault: t.isDefault,
                        rules: t.rules,
                      ),
                      command: RobotCommand.firewall,
                      refresh: refresh,
                    );
                    if (done && mounted) setState(() => _draft = null);
                  },
          ),
          DetailAction(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            group: ActionGroup.manage,
            onTap: () => FormSheet.show(
              context,
              title: l10n.commonEdit,
              fields: (_) => [
                FieldSpec('name', l10n.fieldName, initial: t.name),
              ],
              valid: (v) => (v['name'] ?? '').trim().isNotEmpty,
              onSave: (v) async => edit(copy(name: v['name']!.trim())),
            ),
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionConfiguration,
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.firewallFilterIpv6),
                  value: t.filterIpv6,
                  onChanged: (v) => edit(copy(filterIpv6: v)),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.firewallHetznerServices),
                  value: t.whitelistHos,
                  onChanged: (v) => edit(copy(whitelistHos: v)),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.templateDefault),
                  value: t.isDefault,
                  onChanged: (v) => edit(copy(isDefault: v)),
                ),
              ],
            ),
          ),
          DetailSection(
            title: l10n.firewallRules,
            child: RulesSection(
              rules: t.rules,
              onChanged: (r) => edit(copy(rules: r)),
            ),
          ),
        ],
        dangerZone: [
          DeleteButton(
            onPressed: () async {
              final ok = await ConfirmSheet.show(
                context,
                title: l10n.deleteTitle(t.name),
                consequence: l10n.templateDeleteConsequence,
                confirmLabel: l10n.actionDelete,
                resourceName: t.name,
                level: ConfirmLevel.typeName,
                destructive: true,
              );
              if (!ok || !context.mounted) return;
              final done = await runRobot(
                context,
                ref,
                a,
                (api) => api.deleteTemplate(t.id),
                command: RobotCommand.firewall,
                refresh: <ProviderOrFamily>[robotTemplatesProvider(a)],
                done: l10n.deletedMessage(t.name),
              );
              if (done && context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

/// Traffic of an IP or subnet for a day, month or year (ROB-059).
class RobotTrafficPage extends ConsumerStatefulWidget {
  const new({
    required this.accountId,
    this.ip,
    this.subnet,
    this.day,
    super.key,
  });

  final String accountId;
  final String? ip;
  final String? subnet;

  /// The day whose period shows first; today when null.
  final DateTime? day;

  @override
  ConsumerState<RobotTrafficPage> createState() => _RobotTrafficPageState();
}

class _RobotTrafficPageState extends ConsumerState<RobotTrafficPage> {
  TrafficType _type = TrafficType.month;
  late DateTime _day = widget.day ?? DateTime.now();

  /// `from` and `to` of the period around [_day] in Robot's format.
  (String, String) get _range {
    final d = _day;
    return switch (_type) {
      TrafficType.day => ('${isoDate(d)}T00', '${isoDate(d)}T23'),
      TrafficType.month => (
        isoDate(DateTime(d.year, d.month)),
        isoDate(DateTime(d.year, d.month + 1, 0)),
      ),
      TrafficType.year => ('${d.year}-01', '${d.year}-12'),
    };
  }

  Future<Map<String, Traffic>> _query() {
    final (from, to) = _range;
    return ref
        .read(robotApiProvider(widget.accountId))
        .traffic(
          type: _type,
          from: from,
          to: to,
          ips: [?widget.ip],
          subnets: [?widget.subnet],
        );
  }

  late Future<Map<String, Traffic>> _result = _query();

  void _load() => setState(() {
    _result = _query();
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (from, to) = _range;
    return FalcoScaffold(
      title: l10n.trafficTitle,
      body: ListView(
        padding: const EdgeInsets.all(FalcoSpacing.l),
        children: [
          Mono(widget.ip ?? widget.subnet ?? ''),
          const SizedBox(height: FalcoSpacing.m),
          SegmentedButton<TrafficType>(
            segments: [
              ButtonSegment(
                value: TrafficType.day,
                label: Text(l10n.trafficDay),
              ),
              ButtonSegment(
                value: TrafficType.month,
                label: Text(l10n.trafficMonthType),
              ),
              ButtonSegment(
                value: TrafficType.year,
                label: Text(l10n.trafficYear),
              ),
            ],
            selected: {_type},
            onSelectionChanged: (s) {
              _type = s.first;
              _load();
            },
          ),
          const SizedBox(height: FalcoSpacing.m),
          OutlinedButton.icon(
            onPressed: () async {
              final day = await showDatePicker(
                context: context,
                firstDate: DateTime(2010),
                lastDate: DateTime.now(),
                initialDate: _day,
              );
              if (day == null) return;
              _day = day;
              _load();
            },
            icon: const Icon(Icons.calendar_today),
            label: Text('$from – $to'),
          ),
          const SizedBox(height: FalcoSpacing.l),
          FutureBuilder(
            future: _result,
            builder: (context, snap) => switch (snap) {
              AsyncSnapshot(:final error?) => ErrorCard(
                message: robotErrorText(toFalcoError(error), l10n),
                onRetry: _load,
              ),
              AsyncSnapshot(connectionState: ConnectionState.done, :final data?)
                  when data.isEmpty =>
                Text(l10n.trafficNone),
              AsyncSnapshot(
                connectionState: ConnectionState.done,
                :final data?,
              ) =>
                FactRows([
                  for (final MapEntry(key: address, value: t)
                      in data.entries) ...[
                    ConfirmFact(l10n.fieldAddress, address, mono: true),
                    ConfirmFact(l10n.trafficIn, gbText(t.inGb), mono: true),
                    ConfirmFact(l10n.trafficOut, gbText(t.outGb), mono: true),
                    ConfirmFact(l10n.trafficSum, gbText(t.sumGb), mono: true),
                  ],
                ]),
              _ => const LinearProgressIndicator(),
            },
          ),
        ],
      ),
    );
  }
}

/// Robot changes of this session (ROB-016), with the same rows as the
/// Cloud activity.
class RobotActivityPage extends ConsumerWidget {
  const new({required this.accountId, super.key});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(robotActivityProvider(accountId));
    return FalcoScaffold(
      title: l10n.activityTitle,
      body: ResourceList<ActionProgress>(
        title: l10n.activityTitle,
        items: items,
        onRefresh: () async {},
        empty: EmptyHint(message: l10n.robotActivityEmpty),
        searchText: (a) => actionCommandText(a.command, l10n),
        filters: [
          ResourceFilter(l10n.filterAll, (_) => true),
          ResourceFilter(
            l10n.filterFailed,
            (a) => a.status == ActionStatus.error,
          ),
        ],
        itemBuilder: (context, a) => ActivityRow(action: a),
      ),
    );
  }
}

/// Create a vSwitch, reverse DNS entry, SSH key or firewall template
/// (ROB-021, ROB-025, ROB-033, ROB-058).
class RobotCreatePage extends ConsumerStatefulWidget {
  const new({required this.accountId, required this.kind, super.key});

  final String accountId;
  final RobotCreateKind kind;

  @override
  ConsumerState<RobotCreatePage> createState() => _RobotCreatePageState();
}

class _RobotCreatePageState extends ConsumerState<RobotCreatePage> {
  late var _values = <String, String>{
    if (widget.kind == RobotCreateKind.vswitch) 'vlan': '4000',
    if (widget.kind == RobotCreateKind.template) ...{
      'filterIpv6': 'false',
      'whitelistHos': 'true',
      'isDefault': 'false',
    },
  };
  bool _creating = false;

  /// Counts filled keys, so the key field shows them.
  int _files = 0;

  /// A generated pair until its private key is handed over (ROB-061).
  SshKeyPair? _pair;

  /// The generated private key while the key field holds its public key;
  /// a changed comment or line break does not count.
  String? get _private => switch (_pair) {
    final p? when sameSshKey(_values['key'] ?? '', p.publicKey) => p.privateKey,
    _ => null,
  };

  String _v(String key) => (_values[key] ?? '').trim();

  bool get _valid => switch (widget.kind) {
    RobotCreateKind.vswitch => _v('name').isNotEmpty && validVlan(_v('vlan')),
    RobotCreateKind.rdns => _v('ip').isNotEmpty && _v('ptr').isNotEmpty,
    RobotCreateKind.key =>
      _v('name').isNotEmpty && sshKeyProblem(_v('key')) == null,
    RobotCreateKind.template => _v('name').isNotEmpty,
  };

  Future<void> _create() async {
    if (_creating) return;
    final private = _private;
    setState(() => _creating = true);
    final l10n = AppLocalizations.of(context);
    final a = widget.accountId;
    final name = switch (widget.kind) {
      RobotCreateKind.rdns => _v('ip'),
      _ => _v('name'),
    };
    final ok = await runRobot(
      context,
      ref,
      a,
      (api) => switch (widget.kind) {
        RobotCreateKind.vswitch => api.createVSwitch(
          _v('name'),
          int.parse(_v('vlan')),
        ),
        RobotCreateKind.rdns => api.setRdns(_v('ip'), _v('ptr'), create: true),
        RobotCreateKind.key => api.addKey(
          _v('name'),
          normalizeSshKey(_v('key')),
        ),
        RobotCreateKind.template => api.saveTemplate(
          name: _v('name'),
          filterIpv6: _values['filterIpv6'] == 'true',
          whitelistHos: _values['whitelistHos'] != 'false',
          isDefault: _values['isDefault'] == 'true',
          rules: const {},
        ),
      },
      command: switch (widget.kind) {
        RobotCreateKind.vswitch => RobotCommand.vswitch,
        RobotCreateKind.rdns => RobotCommand.rdns,
        RobotCreateKind.key => RobotCommand.key,
        RobotCreateKind.template => RobotCommand.firewall,
      },
      refresh: <ProviderOrFamily>[
        switch (widget.kind) {
          RobotCreateKind.vswitch => robotVSwitchesProvider(a),
          RobotCreateKind.rdns => robotRdnsProvider(a),
          RobotCreateKind.key => robotKeysProvider(a),
          RobotCreateKind.template => robotTemplatesProvider(a),
        },
      ],
      done: l10n.createdMessage(name),
    );
    if (!mounted) return;
    setState(() => _creating = false);
    if (private != null) {
      if (ok) _pair = null;
      await showPrivateKey(context, ref, private, failed: !ok);
    }
    if (ok && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (title, fields) = switch (widget.kind) {
      RobotCreateKind.vswitch => (
        l10n.vswitchCreate,
        [
          FieldSpec('name', l10n.fieldName),
          FieldSpec('vlan', 'VLAN', helper: l10n.vlanHint),
        ],
      ),
      RobotCreateKind.rdns => (
        l10n.rdnsCreate,
        [FieldSpec('ip', l10n.fieldAddress), FieldSpec('ptr', l10n.reverseDns)],
      ),
      RobotCreateKind.key => (
        l10n.sshKeyAdd,
        [
          FieldSpec('name', l10n.fieldName),
          FieldSpec(
            'key',
            l10n.fieldPublicKey,
            initial: _values['key'] ?? '',
            multiline: true,
            helper: sshKeyProblemText(_v('key'), l10n) ?? l10n.sshKeyHint,
          ),
        ],
      ),
      RobotCreateKind.template => (
        l10n.templateCreate,
        [
          FieldSpec('name', l10n.fieldName),
          for (final (k, label) in [
            ('filterIpv6', l10n.firewallFilterIpv6),
            ('whitelistHos', l10n.firewallHetznerServices),
            ('isDefault', l10n.templateDefault),
          ])
            FieldSpec(
              k,
              label,
              options: {'true': l10n.commonYes, 'false': l10n.commonNo},
            ),
        ],
      ),
    };
    return CreateWizard(
      title: title,
      creating: _creating,
      onCreate: _create,
      steps: [
        WizardStep(
          title: l10n.wizardDetails,
          canContinue: _valid,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormFields(
                // A file fills the key field anew.
                key: ValueKey(_files),
                fields: prefill(fields, _values),
                values: _values,
                onChanged: (v) => setState(() => _values = {..._values, ...v}),
              ),
              if (widget.kind == RobotCreateKind.key)
                SshKeySources(
                  comment: _v('name'),
                  onKey: (public, pair) => setState(() {
                    _values = {..._values, 'key': public};
                    _pair = pair;
                    _files++;
                  }),
                ),
            ],
          ),
        ),
      ],
      summary: FactRows([
        for (final f in fields)
          ConfirmFact(
            f.label,
            f.options[_values[f.key] ?? ''] ?? _values[f.key] ?? '',
            mono: f.key == 'key' || f.key == 'ip',
          ),
        if (_private != null)
          ConfirmFact(l10n.sshKeyPrivateTitle, l10n.sshKeyPrivateAfter),
      ]),
    );
  }
}
