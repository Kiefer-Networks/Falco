// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/activity/activity_page.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/network/load_balancers.dart';
import 'package:falco/features/network/networks.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Private networks of a scope (NET-039).
class NetworkList extends ConsumerWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = networksProvider(scope);
    final async = ref.watch(provider);
    final accounts = scope is AllProjectsScope
        ? ref.watch(accountsProvider.select((a) => a.value))
        : null;
    return ResourceList<CloudNetwork>(
      title: l10n.resourceNetworks,
      items: async.value,
      loading: async.isLoading,
      error: async.hasError
          ? errorText(toFalcoError(async.error!), l10n)
          : null,
      onRefresh: () => refreshQuietly(ref, provider.future),
      empty: EmptyHint(message: l10n.emptyNetworks),
      searchText: (n) => '${n.name} ${n.ipRange}',
      sorts: [ResourceSort(l10n.sortName, (a, b) => a.name.compareTo(b.name))],
      itemBuilder: (context, n) => ResourceRow(
        status: ResourceStatus.available,
        name: n.name,
        monoLine: [
          n.ipRange,
          l10n.subnetCount(n.subnets.length),
          if (accounts != null) projectName(accounts, n.projectId),
        ].join(' · '),
        onTap: () => openDetail(
          context,
          NetworkRoute(
            accountId: scope.accountId,
            projectId: n.projectId,
            networkId: n.id,
          ),
        ),
      ),
    );
  }
}

/// Fields of a subnet (NET-041, NET-046); the vSwitch id only for a
/// vSwitch subnet.
List<FieldSpec> subnetFields(
  AppLocalizations l10n,
  Map<String, String> v,
  String networkRange,
) => [
  FieldSpec(
    'type',
    l10n.fieldType,
    initial: 'cloud',
    options: {for (final t in subnetTypes) t: t},
  ),
  FieldSpec(
    'zone',
    l10n.fieldNetworkZone,
    initial: networkZones.first,
    options: {for (final z in networkZones) z: z},
  ),
  FieldSpec(
    'range',
    l10n.fieldIpRange,
    helper: l10n.subnetRangeHint(networkRange),
  ),
  if (v['type'] == 'vswitch') FieldSpec('vswitch', l10n.fieldVswitchId),
];

/// Whether subnet form [v] is complete within [networkRange].
bool validSubnet(Map<String, String> v, String networkRange) =>
    validSubnetRange(v['range'] ?? '', networkRange) &&
    (v['type'] != 'vswitch' || int.tryParse(v['vswitch'] ?? '') != null);

/// The subnet body of form [v].
Map<String, Object?> subnetOf(Map<String, String> v) => subnetJson(
  type: v['type'] ?? 'cloud',
  zone: v['zone'] ?? networkZones.first,
  ipRange: (v['range'] ?? '').trim(),
  vswitchId: int.tryParse(v['vswitch'] ?? ''),
);

/// One network: subnets, routes, members, IP range, vSwitch routes,
/// edit, protection, delete (NET-043 to NET-055, NET-090, NET-092).
class NetworkDetailPage extends ConsumerWidget {
  const new({required this.scope, required this.networkId, super.key});

  final ProjectScope scope;
  final int networkId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = networkProvider(scope, networkId);
    final async = ref.watch(provider);
    final n = async.value;
    if (n == null) {
      return DetailLoading(
        title: l10n.resourceNetwork,
        error: async.error,
        onRetry: () => ref.invalidate(provider),
      );
    }
    final t = (scope: scope, type: CloudType.network, id: n.id, name: n.name);
    final progress = ref
        .watch(trackedActionProvider(scope, CloudType.network, n.id))
        .value;
    final busy = progress != null && !progress.done;
    Future<void> change(NetworkChange c) =>
        startTracked(ref, scope, (api) => changeNetwork(api, n.id, c));

    return FalcoScaffold(
      title: l10n.resourceNetwork,
      body: DetailPage(
        status: busy ? ResourceStatus.inProgress : ResourceStatus.available,
        statusDetail: busy
            ? '${progress.progress} %'
            : (n.protectDelete ? l10n.protected : null),
        name: n.name,
        ids: [n.ipRange],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          DetailAction(
            icon: Icons.add_box_outlined,
            label: l10n.subnetAdd,
            onTap: busy
                ? null
                : () => FormSheet.show(
                    context,
                    title: l10n.subnetAdd,
                    fields: (v) => subnetFields(l10n, v, n.ipRange),
                    valid: (v) => validSubnet(v, n.ipRange),
                    onSave: (v) => change(AddSubnet(subnetOf(v))),
                  ),
          ),
          DetailAction(
            icon: Icons.alt_route,
            label: l10n.routeAdd,
            onTap: busy
                ? null
                : () => FormSheet.show(
                    context,
                    title: l10n.routeAdd,
                    fields: (_) => [
                      FieldSpec('destination', l10n.fieldDestination),
                      FieldSpec(
                        'gateway',
                        l10n.fieldGateway,
                        helper: l10n.gatewayHint(n.ipRange),
                      ),
                    ],
                    valid: (v) => validRoute(
                      v['destination'] ?? '',
                      v['gateway'] ?? '',
                      n.ipRange,
                    ),
                    onSave: (v) => change(
                      AddRoute((
                        destination: v['destination']!.trim(),
                        gateway: v['gateway']!.trim(),
                      )),
                    ),
                  ),
          ),
          DetailAction(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            onTap: () => editNameAndLabels(
              context,
              ref,
              t,
              n.labels,
              (api, name, labels) =>
                  updateNetwork(api, n.id, name: name, labels: labels),
            ),
          ),
          DetailAction(
            icon: n.protectDelete ? Icons.lock : Icons.lock_open,
            label: l10n.fieldProtection,
            onTap: busy
                ? null
                : () => toggleProtection(
                    context,
                    ref,
                    t,
                    protected: n.protectDelete,
                    start: (api, p) =>
                        changeNetwork(api, n.id, ProtectNetwork(delete: p)),
                  ),
          ),
          DetailAction(
            label: l10n.networkChangeRange,
            icon: Icons.open_in_full,
            onTap: () => FormSheet.show(
              context,
              title: l10n.networkChangeRange,
              fields: (_) => [
                FieldSpec(
                  'range',
                  l10n.fieldIpRange,
                  initial: n.ipRange,
                  helper: l10n.networkRangeHint,
                ),
              ],
              valid: (v) => validRangeChange(v['range'] ?? '', n.ipRange),
              onSave: (v) => change(ChangeIpRange(v['range']!.trim())),
            ),
          ),
          DetailAction(
            label: n.exposeRoutes
                ? l10n.networkExposeOff
                : l10n.networkExposeOn,
            icon: Icons.alt_route,
            onTap: () async {
              final ok = await ConfirmSheet.show(
                context,
                title: n.exposeRoutes
                    ? l10n.networkExposeOff
                    : l10n.networkExposeOn,
                consequence: l10n.networkExposeConsequence,
                confirmLabel: l10n.commonSave,
                resourceName: n.name,
              );
              if (ok && context.mounted) {
                await runChange(
                  context,
                  ref,
                  t,
                  (api) =>
                      updateNetwork(api, n.id, exposeRoutes: !n.exposeRoutes),
                );
              }
            },
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionOverview,
            child: FactRows([
              ConfirmFact(l10n.fieldIpRange, n.ipRange, mono: true),
              ConfirmFact(l10n.sectionSubnets, '${n.subnets.length}'),
              ConfirmFact(l10n.sectionRoutes, '${n.routes.length}'),
              ConfirmFact(l10n.fieldVswitch, yesNo(n.hasVswitch, l10n)),
              ConfirmFact(l10n.networkExpose, yesNo(n.exposeRoutes, l10n)),
              ConfirmFact(
                l10n.fieldDeleteProtection,
                yesNo(n.protectDelete, l10n),
              ),
              ConfirmFact(
                l10n.fieldCreated,
                formatDateTime(n.created, l10n.localeName),
              ),
              ConfirmFact(l10n.fieldLabels, labelsText(n.labels, l10n)),
            ]),
          ),
          DetailSection(
            title: l10n.sectionSubnets,
            child: entries([
              for (final s in n.subnets)
                EntryRow(
                  title: s.ipRange ?? s.zone,
                  subtitle: [
                    s.type,
                    s.zone,
                    if (s.gateway.isNotEmpty) l10n.gatewayValue(s.gateway),
                    if (s.vswitchId case final v?) 'vSwitch #$v',
                  ].join(' · '),
                  onRemove: s.ipRange == null || busy
                      ? null
                      : () => confirmAction(
                          context,
                          ref,
                          scope,
                          title: l10n.subnetDeleteTitle(s.ipRange!),
                          consequence: l10n.subnetDeleteConsequence,
                          label: l10n.actionDelete,
                          name: n.name,
                          destructive: true,
                          start: (api) => changeNetwork(
                            api,
                            n.id,
                            DeleteSubnet(s.ipRange!),
                          ),
                        ),
                ),
            ], l10n.subnetsEmpty),
          ),
          DetailSection(
            title: l10n.sectionRoutes,
            child: entries([
              for (final r in n.routes)
                EntryRow(
                  title: r.destination,
                  subtitle: l10n.gatewayValue(r.gateway),
                  onRemove: busy
                      ? null
                      : () => confirmAction(
                          context,
                          ref,
                          scope,
                          title: l10n.routeDeleteTitle(r.destination),
                          consequence: l10n.routeDeleteConsequence(r.gateway),
                          label: l10n.actionDelete,
                          name: n.name,
                          destructive: true,
                          start: (api) =>
                              changeNetwork(api, n.id, DeleteRoute(r)),
                        ),
                ),
            ], l10n.routesEmpty),
          ),
          DetailSection(
            title: l10n.sectionMembers,
            child: _Members(scope: scope, networkId: n.id),
          ),
          activitySection(l10n, scope, CloudType.network, n.id),
        ],
        dangerZone: [
          DeleteButton(
            onPressed: busy
                ? null
                : () => deleteResource(
                    context,
                    ref,
                    t,
                    l10n.networkDeleteConsequence,
                    (api) => deleteNetwork(api, n.id),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Servers and load balancers in a network with their private IPs
/// (NET-092).
class _Members extends ConsumerWidget {
  const new({required this.scope, required this.networkId});

  final ProjectScope scope;
  final int networkId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final members =
        ref.watch(networkMembersProvider(scope, networkId)).value ?? const [];
    final servers = {
      for (final s
          in ref.watch(serversProvider(scope)).value ?? const <CloudServer>[])
        s.id: s.name,
    };
    final lbs = {
      for (final l
          in ref.watch(loadBalancersProvider(scope)).value ??
              const <LoadBalancer>[])
        l.id: l.name,
    };
    return entries([
      for (final m in members)
        if (m.type == 'server')
          EntryRow(
            leading: const Icon(Icons.dns_outlined),
            title: servers[m.id] ?? '#${m.id}',
            subtitle: [m.ip, ...m.aliasIps].join(' · '),
            onTap: () => ServerRoute(
              accountId: scope.accountId,
              projectId: scope.projectId,
              serverId: m.id,
            ).push<void>(context),
          )
        else
          EntryRow(
            leading: const Icon(Icons.balance),
            title: lbs[m.id] ?? '#${m.id}',
            subtitle: m.ip,
            onTap: () => LoadBalancerRoute(
              accountId: scope.accountId,
              projectId: scope.projectId,
              lbId: m.id,
            ).push<void>(context),
          ),
    ], l10n.membersEmpty);
  }
}

/// Create a network: name and range, optionally a first subnet
/// (NET-040 to NET-042).
class CreateNetworkPage extends ConsumerStatefulWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  ConsumerState<CreateNetworkPage> createState() => _CreateNetworkPageState();
}

class _CreateNetworkPageState extends ConsumerState<CreateNetworkPage> {
  String? _project;
  var _values = <String, String>{'range': '10.0.0.0/16'};
  var _subnet = <String, String>{'type': 'cloud', 'zone': networkZones.first};
  bool _withSubnet = true;
  bool _creating = false;

  String get _range => (_values['range'] ?? '').trim();

  Future<void> _create(ProjectScope scope) async {
    if (_creating) return;
    setState(() => _creating = true);
    final l10n = AppLocalizations.of(context);
    final name = _values['name']!.trim();
    final ok = await runChange(
      context,
      ref,
      (scope: scope, type: CloudType.network, id: 0, name: name),
      (api) => createNetwork(
        api,
        name: name,
        ipRange: _range,
        subnet: _withSubnet ? subnetOf(_subnet) : null,
        labels: parseLabels(_values['labels'] ?? '') ?? const {},
      ),
      done: l10n.createdMessage(name),
    );
    if (!mounted) return;
    setState(() => _creating = false);
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = targetScope(widget.scope, _project);
    return CreateWizard(
      title: l10n.networkCreate,
      creating: _creating,
      onCreate: scope == null ? null : () => _create(scope),
      projectStep: projectStep(
        ref,
        l10n,
        widget.scope,
        _project,
        (p) => setState(() => _project = p),
      ),
      steps: [
        WizardStep(
          title: l10n.wizardDetails,
          canContinue:
              (_values['name'] ?? '').trim().isNotEmpty &&
              validNetworkRange(_range) &&
              validLabels(_values),
          child: FormFields(
            fields: [
              FieldSpec('name', l10n.fieldName, maxLength: 63),
              FieldSpec(
                'range',
                l10n.fieldIpRange,
                initial: '10.0.0.0/16',
                helper: l10n.networkRangeCreateHint,
              ),
              labelsField(l10n),
            ],
            values: _values,
            onChanged: (v) => setState(() => _values = {..._values, ...v}),
          ),
        ),
        WizardStep(
          title: l10n.sectionSubnets,
          canContinue: !_withSubnet || validSubnet(_subnet, _range),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: FalcoSpacing.l,
            children: [
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: Text(l10n.subnetAdd),
                value: _withSubnet,
                onChanged: (v) => setState(() => _withSubnet = v),
              ),
              if (_withSubnet)
                FormFields(
                  fields: subnetFields(l10n, _subnet, _range),
                  values: _subnet,
                  onChanged: (v) =>
                      setState(() => _subnet = {..._subnet, ...v}),
                ),
            ],
          ),
        ),
      ],
      summary: FactRows([
        ConfirmFact(l10n.fieldName, (_values['name'] ?? '').trim()),
        ConfirmFact(l10n.fieldIpRange, _range, mono: true),
        ConfirmFact(
          l10n.sectionSubnets,
          _withSubnet
              ? [
                  _subnet['type'],
                  _subnet['zone'],
                  if ((_subnet['range'] ?? '').trim().isNotEmpty)
                    _subnet['range']!.trim(),
                ].join(' · ')
              : l10n.commonNone,
        ),
        ConfirmFact(
          l10n.fieldLabels,
          labelsText(parseLabels(_values['labels'] ?? '') ?? const {}, l10n),
        ),
      ]),
    );
  }
}
