// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/api/robot/robot_client.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/robot/robot.dart';
import 'package:falco/features/robot/robot_ui.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:material_ui/material_ui.dart';

/// The Robot area of an account: dedicated servers, failover IPs,
/// vSwitches, reverse DNS, SSH keys, IPs, subnets and firewall templates
/// as tabs (ROB-001).
class RobotPage extends StatefulWidget {
  const new({required this.accountId, super.key});

  final String accountId;

  @override
  State<RobotPage> createState() => _RobotPageState();
}

class _RobotPageState extends State<RobotPage>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 8, vsync: this)
    ..addListener(() => setState(() {}));

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final a = widget.accountId;
    final create = switch (_tabs.index) {
      2 => (RobotCreateKind.vswitch, l10n.vswitchCreate),
      3 => (RobotCreateKind.rdns, l10n.rdnsCreate),
      4 => (RobotCreateKind.key, l10n.sshKeyAdd),
      7 => (RobotCreateKind.template, l10n.templateCreate),
      _ => null,
    };
    return Scaffold(
      floatingActionButton: switch (create) {
        (final kind, final label) => FloatingActionButton.extended(
          heroTag: kind,
          onPressed: () =>
              RobotCreateRoute(accountId: a, kind: kind).push<void>(context),
          icon: const Icon(Icons.add),
          label: Text(label),
        ),
        null => null,
      },
      body: Column(
        children: [
          TabBar(
            controller: _tabs,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l10n.robotServers),
              Tab(text: l10n.robotFailover),
              Tab(text: l10n.robotVSwitches),
              Tab(text: l10n.reverseDns),
              Tab(text: l10n.resourceSshKeys),
              Tab(text: l10n.robotIps),
              Tab(text: l10n.robotSubnets),
              Tab(text: l10n.robotTemplates),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                RobotServerList(accountId: a),
                FailoverList(accountId: a),
                VSwitchList(accountId: a),
                RdnsList(accountId: a),
                RobotKeyList(accountId: a),
                AddressList(accountId: a, kind: AddressKind.ip),
                AddressList(accountId: a, kind: AddressKind.subnet),
                TemplateList(accountId: a),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A Robot list: loading, the access hint for a section the login may
/// not use (ROB-002), empty, search.
class _RobotList<T> extends ConsumerWidget {
  const new({
    required this.title,
    required this.provider,
    required this.future,
    required this.empty,
    required this.itemBuilder,
    required this.searchText,
    this.filters = const [],
  });

  final String title;
  final ProviderListenable<AsyncValue<List<T>>> provider;
  final Refreshable<Future<Object?>> future;
  final EmptyHint empty;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String Function(T item) searchText;
  final List<ResourceFilter<T>> filters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(provider);
    return ResourceList<T>(
      title: title,
      items: async.value,
      loading: async.isLoading,
      error: async.hasError
          ? robotErrorText(toFalcoError(async.error!), l10n)
          : null,
      onRefresh: () => refreshQuietly(ref, future),
      empty: empty,
      searchText: searchText,
      filters: filters,
      itemBuilder: itemBuilder,
    );
  }
}

/// Status of a dedicated server: cancelled, in process or ready.
ResourceStatus serverStatus(RobotServer s) => s.cancelled
    ? ResourceStatus.cancelled
    : s.status == 'ready'
    ? ResourceStatus.active
    : ResourceStatus.inProgress;

/// Dedicated servers: name or number, cancelled badge, IPv4, IPv6 net,
/// data center, paid until (ROB-004). Long press offers reset and Wake on
/// LAN (ROB-005).
class RobotServerList extends ConsumerWidget {
  const new({required this.accountId, super.key});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = robotServersProvider(accountId);
    return _RobotList<RobotServer>(
      title: l10n.robotServers,
      provider: provider,
      future: provider.future,
      empty: EmptyHint(message: l10n.robotServersEmpty),
      searchText: (s) => '${s.label} ${s.ipv4} ${s.product} ${s.dc}',
      filters: [
        ResourceFilter(l10n.filterAll, (_) => true),
        ResourceFilter(l10n.filterCancelled, (s) => s.cancelled),
      ],
      itemBuilder: (context, s) => GestureDetector(
        onLongPress: () => quickActions(context, ref, accountId, s),
        child: ResourceRow(
          status: serverStatus(s),
          name: s.label,
          monoLine: [
            ?s.ipv4,
            ?s.ipv6Net,
            s.dc,
            l10n.robotPaidUntil(s.paidUntil),
          ].join(' · '),
          onTap: () => RobotServerRoute(
            accountId: accountId,
            number: s.number,
          ).push<void>(context),
        ),
      ),
    );
  }
}

/// Reset or Wake on LAN from the list row (ROB-005); reset types come
/// from `GET /reset` (ROB-036).
Future<void> quickActions(
  BuildContext context,
  WidgetRef ref,
  String accountId,
  RobotServer s,
) async {
  final l10n = AppLocalizations.of(context);
  final List<String> types;
  try {
    types =
        (await ref.read(robotResetsProvider(accountId).future))[s.number] ??
        const [];
  } on Object catch (e) {
    if (context.mounted) {
      FalcoScaffold.showSnack(context, robotErrorText(toFalcoError(e), l10n));
    }
    return;
  }
  if (!context.mounted) return;
  final pick = await ChoiceList.show(
    context,
    title: s.label,
    selected: '',
    options: {
      for (final t in types) t: resetTypeText(t, l10n),
      'wol': l10n.robotWol,
    },
  );
  if (pick == null || !context.mounted) return;
  if (pick == 'wol') {
    await wakeOnLan(context, ref, accountId, s);
  } else {
    await resetServer(context, ref, accountId, s, pick);
  }
}

/// Failover IPs and where they are active (ROB-017).
class FailoverList extends ConsumerWidget {
  const new({required this.accountId, super.key});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = robotFailoversProvider(accountId);
    final names = serverNames(ref, accountId);
    return _RobotList<RobotFailover>(
      title: l10n.robotFailover,
      provider: provider,
      future: provider.future,
      empty: EmptyHint(message: l10n.failoverEmpty),
      searchText: (f) => '${f.ip} ${f.activeServerIp}',
      itemBuilder: (context, f) => ResourceRow(
        status: f.activeServerIp == null
            ? ResourceStatus.off
            : ResourceStatus.active,
        name: formatIp(f.ip),
        monoLine: switch (f.activeServerIp) {
          null => l10n.failoverUnrouted,
          final ip => l10n.failoverActiveOn(names[ip] ?? ip),
        },
        onTap: () => RobotFailoverRoute(
          accountId: accountId,
          ip: f.ip,
        ).push<void>(context),
      ),
    );
  }
}

/// vSwitches: name, VLAN, id, cancelled badge (ROB-024).
class VSwitchList extends ConsumerWidget {
  const new({required this.accountId, super.key});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = robotVSwitchesProvider(accountId);
    return _RobotList<RobotVSwitch>(
      title: l10n.robotVSwitches,
      provider: provider,
      future: provider.future,
      empty: EmptyHint(
        message: l10n.vswitchEmpty,
        actionLabel: l10n.vswitchCreate,
        onAction: () => RobotCreateRoute(
          accountId: accountId,
          kind: RobotCreateKind.vswitch,
        ).push<void>(context),
      ),
      searchText: (v) => '${v.name} ${v.vlan} ${v.id}',
      itemBuilder: (context, v) => ResourceRow(
        status: v.cancelled ? ResourceStatus.cancelled : ResourceStatus.active,
        name: v.name,
        monoLine: 'VLAN ${v.vlan} · #${v.id}',
        onTap: () => RobotVSwitchRoute(
          accountId: accountId,
          id: v.id,
        ).push<void>(context),
      ),
    );
  }
}

/// Reverse DNS entries: IP and PTR; tap edits (IP locked), the button
/// deletes (ROB-020, ROB-022, ROB-023).
class RdnsList extends ConsumerWidget {
  const new({required this.accountId, super.key});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = robotRdnsProvider(accountId);
    return _RobotList<RobotRdns>(
      title: l10n.reverseDns,
      provider: provider,
      future: provider.future,
      empty: EmptyHint(
        message: l10n.rdnsEmpty,
        actionLabel: l10n.rdnsCreate,
        onAction: () => RobotCreateRoute(
          accountId: accountId,
          kind: RobotCreateKind.rdns,
        ).push<void>(context),
      ),
      searchText: (r) => '${r.ip} ${r.ptr}',
      itemBuilder: (context, r) => Row(
        children: [
          Expanded(
            child: ResourceRow(
              status: ResourceStatus.active,
              name: r.ptr,
              monoLine: formatIp(r.ip),
              onTap: () => editRdns(context, ref, accountId, r.ip),
            ),
          ),
          IconButton(
            tooltip: l10n.actionDelete,
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => deleteRdns(context, ref, accountId, r),
          ),
        ],
      ),
    );
  }
}

/// SSH keys stored in Robot: name, fingerprint, type, bits (ROB-032).
class RobotKeyList extends ConsumerWidget {
  const new({required this.accountId, super.key});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = robotKeysProvider(accountId);
    return _RobotList<RobotKey>(
      title: l10n.resourceSshKeys,
      provider: provider,
      future: provider.future,
      empty: EmptyHint(
        message: l10n.robotKeysEmpty,
        actionLabel: l10n.sshKeyAdd,
        onAction: () => RobotCreateRoute(
          accountId: accountId,
          kind: RobotCreateKind.key,
        ).push<void>(context),
      ),
      searchText: (k) => '${k.name} ${k.fingerprint}',
      itemBuilder: (context, k) => ResourceRow(
        status: ResourceStatus.available,
        name: k.name,
        monoLine: '${k.fingerprint} · ${k.type} · ${k.size} bit',
        onTap: () => RobotKeyRoute(
          accountId: accountId,
          fingerprint: k.fingerprint,
        ).push<void>(context),
      ),
    );
  }
}

/// Single IPs or subnets with their server and traffic warnings
/// (ROB-049, ROB-053).
class AddressList extends ConsumerWidget {
  const new({required this.accountId, required this.kind, super.key});

  final String accountId;
  final AddressKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = robotAddressesProvider(accountId, kind);
    final names = serverNumbers(ref, accountId);
    final ip = kind == AddressKind.ip;
    return _RobotList<RobotAddress>(
      title: ip ? l10n.robotIps : l10n.robotSubnets,
      provider: provider,
      future: provider.future,
      empty: EmptyHint(message: ip ? l10n.robotIpsEmpty : l10n.subnetsEmpty),
      searchText: (a) => '${a.ip} ${names[a.serverNumber]}',
      itemBuilder: (context, a) => ResourceRow(
        status: a.locked ? ResourceStatus.locked : ResourceStatus.active,
        name: addressText(a, kind),
        monoLine: [
          names[a.serverNumber] ?? '#${a.serverNumber}',
          ?a.gateway,
          if (a.failover) l10n.robotFailover,
          if (a.warnings) l10n.trafficWarningsOn,
        ].join(' · '),
        onTap: () => RobotAddressRoute(
          accountId: accountId,
          kind: kind,
          ip: a.ip,
        ).push<void>(context),
      ),
    );
  }
}

/// Firewall templates (ROB-058).
class TemplateList extends ConsumerWidget {
  const new({required this.accountId, super.key});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = robotTemplatesProvider(accountId);
    return _RobotList<RobotFirewall>(
      title: l10n.robotTemplates,
      provider: provider,
      future: provider.future,
      empty: EmptyHint(
        message: l10n.templatesEmpty,
        actionLabel: l10n.templateCreate,
        onAction: () => RobotCreateRoute(
          accountId: accountId,
          kind: RobotCreateKind.template,
        ).push<void>(context),
      ),
      searchText: (t) => t.name,
      itemBuilder: (context, t) => ResourceRow(
        status: ResourceStatus.available,
        name: t.name,
        monoLine: [
          '#${t.id}',
          if (t.isDefault) l10n.templateDefault,
          if (t.whitelistHos) l10n.firewallHetznerServices,
        ].join(' · '),
        onTap: () => RobotTemplateRoute(
          accountId: accountId,
          id: t.id,
        ).push<void>(context),
      ),
    );
  }
}
