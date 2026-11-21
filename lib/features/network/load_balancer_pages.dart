// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/activity/activity_page.dart';
import 'package:falco/features/compute/catalog.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/network/certificates.dart';
import 'package:falco/features/network/load_balancers.dart';
import 'package:falco/features/network/networks.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:material_ui/material_ui.dart';

String _algorithm(String a, AppLocalizations l10n) =>
    a == 'least_connections' ? l10n.lbLeastConnections : l10n.lbRoundRobin;

/// Load balancers of a scope: name, type, status (NET-056).
class LoadBalancerList extends ConsumerWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = loadBalancersProvider(scope);
    final async = ref.watch(provider);
    final accounts = scope is AllProjectsScope
        ? ref.watch(accountsProvider).value
        : null;
    return ResourceList<LoadBalancer>(
      title: l10n.resourceLoadBalancers,
      items: async.value,
      loading: async.isLoading,
      error: async.hasError
          ? errorText(toFalcoError(async.error!), l10n)
          : null,
      onRefresh: () => refreshQuietly(ref, provider.future),
      empty: EmptyHint(
        message: l10n.emptyLoadBalancers,
        actionLabel: l10n.loadBalancerCreate,
        onAction: () =>
            CreateRoute.of(scope, CreateKind.loadBalancer).push<void>(context),
      ),
      searchText: (lb) => '${lb.name} ${lb.ipv4 ?? ''}',
      sorts: [ResourceSort(l10n.sortName, (a, b) => a.name.compareTo(b.name))],
      itemBuilder: (context, lb) => ResourceRow(
        status: lb.status,
        name: lb.name,
        monoLine: [
          lb.type.name.toUpperCase(),
          lb.location,
          if (lb.ipv4 case final ip?) formatIp(ip),
          l10n.serviceCount(lb.services.length),
          l10n.targetCount(lb.targets.length),
          if (accounts != null) projectName(accounts, lb.projectId),
        ].join(' · '),
        onTap: () => LoadBalancerRoute(
          accountId: scope.accountId,
          projectId: lb.projectId,
          lbId: lb.id,
        ).push<void>(context),
      ),
    );
  }
}

/// Default values of a new service: HTTP on port 80 with an HTTP health
/// check.
const _newService = {
  'protocol': 'http',
  'listen': '80',
  'destination': '80',
  'proxy': 'false',
  'hcProtocol': 'http',
  'hcPort': '',
  'hcInterval': '15',
  'hcTimeout': '10',
  'hcRetries': '3',
  'hcPath': '/',
  'hcCodes': '2??, 3??',
  'hcTls': 'false',
  'sticky': 'false',
  'redirect': 'false',
};

/// Fields of a service: protocol, ports, PROXY protocol, HTTP options,
/// certificates and redirect for https, health check (NET-060, NET-061,
/// NET-087, NET-088). The listen port is the service's key and cannot
/// change when [editing].
List<FieldSpec> serviceFields(
  AppLocalizations l10n,
  Map<String, String> v,
  Map<String, String> certificates, {
  bool editing = false,
}) {
  final yesNo = {'true': l10n.commonYes, 'false': l10n.commonNo};
  final protocol = v['protocol'] ?? _newService['protocol']!;
  final health = v['hcProtocol'] ?? _newService['hcProtocol']!;
  return [
    FieldSpec(
      'protocol',
      l10n.fieldProtocol,
      options: {for (final p in lbProtocols) p: p.toUpperCase()},
    ),
    if (!editing) FieldSpec('listen', l10n.fieldListenPort),
    FieldSpec('destination', l10n.fieldDestinationPort),
    FieldSpec('proxy', l10n.fieldProxyProtocol, options: yesNo),
    if (protocol == 'https') ...[
      FieldSpec(
        'certificates',
        l10n.resourceCertificates,
        options: certificates,
        multiple: true,
        helper: certificates.isEmpty ? l10n.lbNoCertificates : null,
      ),
      FieldSpec('redirect', l10n.fieldRedirectHttp, options: yesNo),
    ],
    if (protocol != 'tcp') ...[
      FieldSpec('sticky', l10n.fieldStickySessions, options: yesNo),
      FieldSpec('cookie', l10n.fieldCookieName, helper: 'HCLBSTICKY'),
      FieldSpec(
        'cookieLifetime',
        l10n.fieldCookieLifetime,
        helper: l10n.secondsHint(30, 86400),
      ),
    ],
    FieldSpec(
      'hcProtocol',
      l10n.fieldHealthCheck,
      options: const {'tcp': 'TCP', 'http': 'HTTP'},
    ),
    FieldSpec('hcPort', l10n.fieldHealthPort, helper: l10n.healthPortHint),
    FieldSpec(
      'hcInterval',
      l10n.fieldInterval,
      helper: l10n.secondsHint(3, 60),
    ),
    FieldSpec('hcTimeout', l10n.fieldTimeout, helper: l10n.secondsHint(1, 60)),
    FieldSpec('hcRetries', l10n.fieldRetries, helper: '1 – 5'),
    if (health == 'http') ...[
      FieldSpec('hcDomain', l10n.fieldHealthDomain),
      FieldSpec('hcPath', l10n.fieldHealthPath),
      FieldSpec('hcCodes', l10n.fieldStatusCodes, helper: '2??, 3??'),
      FieldSpec('hcTls', l10n.fieldHealthTls, options: yesNo),
    ],
  ];
}

/// The service sheet, new or filled with [initial] (NET-060, NET-061).
Future<bool> showServiceSheet(
  BuildContext context,
  WidgetRef ref,
  ProjectScope scope, {
  required Future<void> Function(LbService service) save,
  LbService? initial,
}) async {
  final l10n = AppLocalizations.of(context);
  final certificates = {
    for (final c in await ref.read(certificatesProvider(scope).future))
      '${c.id}': c.name,
  };
  if (!context.mounted) return false;
  final values = initial == null ? _newService : serviceValues(initial);
  return await FormSheet.show(
    context,
    title: initial == null ? l10n.serviceAdd : l10n.serviceEdit,
    fields: (v) => prefill(
      serviceFields(l10n, v, certificates, editing: initial != null),
      values,
    ),
    valid: (v) => validService({...values, ...v}),
    onSave: (v) => save(serviceJson({...values, ...v})),
  );
}

/// The target sheet: a server, a label selector or an IP (NET-064 to
/// NET-066).
Future<bool> showTargetSheet(
  BuildContext context,
  WidgetRef ref,
  ProjectScope scope, {
  required Future<void> Function(LbTarget target) save,
}) async {
  final l10n = AppLocalizations.of(context);
  final servers = await ref.read(serversProvider(scope).future);
  if (!context.mounted) return false;
  final yesNo = {'true': l10n.commonYes, 'false': l10n.commonNo};
  return await FormSheet.show(
    context,
    title: l10n.targetAdd,
    fields: (v) => [
      FieldSpec(
        'type',
        l10n.fieldType,
        initial: 'server',
        options: {
          'server': l10n.resourceServer,
          'label_selector': l10n.labelSelector,
          'ip': l10n.fieldAddress,
        },
      ),
      switch (v['type'] ?? 'server') {
        'label_selector' => FieldSpec(
          'selector',
          l10n.labelSelector,
          helper: l10n.selectorHint,
        ),
        'ip' => FieldSpec('ip', l10n.fieldAddress, helper: l10n.targetIpHint),
        _ => FieldSpec(
          'server',
          l10n.resourceServer,
          options: {for (final s in servers) '${s.id}': s.name},
        ),
      },
      if (v['type'] != 'ip')
        FieldSpec(
          'private',
          l10n.fieldUsePrivateIp,
          initial: 'false',
          options: yesNo,
        ),
    ],
    valid: validTarget,
    onSave: (v) => save(targetJson(v)),
  );
}

/// A service in one line, e.g. `HTTPS 443 → 80`.
String serviceTitle(LbService s) =>
    '${'${s['protocol']}'.toUpperCase()} ${s['listen_port']} → '
    '${s['destination_port']}';

/// Health check and options of a service in one line.
String serviceDetail(LbService s, AppLocalizations l10n) {
  final h = json(s['health_check']);
  return [
    l10n.healthCheckValue(
      '${h['protocol']}'.toUpperCase(),
      '${h['port']}',
      '${h['interval']}',
    ),
    if (s['proxyprotocol'] == true) l10n.fieldProxyProtocol,
    if (json(s['http'])['sticky_sessions'] == true) l10n.fieldStickySessions,
  ].join(' · ');
}

/// A target's name: the server, the selector or the IP.
String targetTitle(LbTarget t, Map<int, String> servers) => switch (t['type']) {
  'server' => () {
    final id = json(t['server'])['id'] as int?;
    return servers[id] ?? '#$id';
  }(),
  'label_selector' => '${json(t['label_selector'])['selector']}',
  _ => '${json(t['ip'])['ip']}',
};

/// A target's kind, routing and health in one line.
String targetDetail(LbTarget t, AppLocalizations l10n) {
  final health = {
    for (final h in jsonList(t['health_status'])) '${h['status']}',
  };
  return [
    switch (t['type']) {
      'server' => l10n.resourceServer,
      'label_selector' => l10n.labelSelector,
      _ => l10n.fieldAddress,
    },
    if (t['use_private_ip'] == true) l10n.fieldUsePrivateIp,
    if (health.isNotEmpty) health.join(', '),
  ].join(' · ');
}

/// One load balancer: services, targets, network, metrics and every
/// change (NET-057 to NET-078, NET-087, NET-088, NET-090, NET-091).
class LoadBalancerDetailPage extends ConsumerWidget {
  const new({required this.scope, required this.lbId, super.key});

  final ProjectScope scope;
  final int lbId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = loadBalancerProvider(scope, lbId);
    final async = ref.watch(provider);
    final lb = async.value;
    if (lb == null) {
      return DetailLoading(
        title: l10n.resourceLoadBalancer,
        error: async.error,
        onRetry: () => ref.invalidate(provider),
      );
    }
    final t = (
      scope: scope,
      type: CloudType.loadBalancer,
      id: lb.id,
      name: lb.name,
    );
    final progress = ref
        .watch(trackedActionProvider(scope, CloudType.loadBalancer, lb.id))
        .value;
    final busy = progress != null && !progress.done;
    final servers = {
      for (final s
          in ref.watch(serversProvider(scope)).value ?? const <CloudServer>[])
        s.id: s.name,
    };
    final networks = {
      for (final n
          in ref.watch(networksProvider(scope)).value ?? const <CloudNetwork>[])
        n.id: n.name,
    };
    Future<void> change(LbChange c) =>
        startTracked(ref, scope, (api) => changeLoadBalancer(api, lb.id, c));
    Future<void> run(LbChange c) => runAction(
      context,
      ref,
      scope,
      (api) => changeLoadBalancer(api, lb.id, c),
    );

    Future<void> changeType() async {
      final types = await ref.read(loadBalancerTypesProvider(scope).future);
      if (!context.mounted) return;
      final pick = await ChoiceList.show(
        context,
        title: l10n.lbChangeType,
        selected: lb.type.name,
        options: {
          for (final ty in types)
            if (!ty.deprecated) ty.name: ty.name.toUpperCase(),
        },
        details: {for (final ty in types) ty.name: _typeDetail(ty, l10n)},
      );
      if (pick != null && pick != lb.type.name && context.mounted) {
        await run(ChangeLbType(pick));
      }
    }

    Future<void> attachNetwork() async {
      final all = [
        for (final n in await ref.read(networksProvider(scope).future))
          if (!lb.privateNets.any((p) => p.network == n.id)) n,
      ];
      if (!context.mounted) return;
      if (all.isEmpty) {
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
            options: {for (final n in all) '${n.id}': n.name},
          ),
          FieldSpec('ip', l10n.fieldPrivateIp, helper: l10n.privateIpHint),
        ],
        valid: (v) => (v['network'] ?? '').isNotEmpty,
        onSave: (v) =>
            change(AttachLbToNetwork(int.parse(v['network']!), v['ip'] ?? '')),
      );
    }

    return FalcoScaffold(
      title: l10n.resourceLoadBalancer,
      moreMenu: MoreMenu(
        items: [
          MoreMenuItem(
            label: l10n.lbAlgorithm,
            icon: Icons.shuffle,
            onSelected: () => FormSheet.show(
              context,
              title: l10n.lbAlgorithm,
              fields: (_) => [
                FieldSpec(
                  'algorithm',
                  l10n.lbAlgorithm,
                  initial: lb.algorithm,
                  options: {
                    for (final a in lbAlgorithms) a: _algorithm(a, l10n),
                  },
                ),
              ],
              // Saving only when it changed (NET-068).
              valid: (v) => v['algorithm'] != lb.algorithm,
              onSave: (v) => change(ChangeAlgorithm(v['algorithm']!)),
            ),
          ),
          MoreMenuItem(
            label: l10n.lbChangeType,
            icon: Icons.swap_vert,
            onSelected: changeType,
          ),
          MoreMenuItem(
            label: l10n.networkAttach,
            icon: Icons.hub_outlined,
            onSelected: attachNetwork,
          ),
          MoreMenuItem(
            label: lb.publicEnabled ? l10n.lbPublicOff : l10n.lbPublicOn,
            icon: Icons.public,
            onSelected: () => lb.publicEnabled
                ? confirmAction(
                    context,
                    ref,
                    scope,
                    title: l10n.lbPublicOff,
                    consequence: l10n.lbPublicOffConsequence,
                    label: l10n.lbPublicOff,
                    name: lb.name,
                    start: (api) => changeLoadBalancer(
                      api,
                      lb.id,
                      const SetPublicInterface(enabled: false),
                    ),
                  )
                : run(const SetPublicInterface(enabled: true)),
          ),
          MoreMenuItem(
            label: l10n.reverseDns,
            icon: Icons.dns_outlined,
            onSelected: () => FormSheet.show(
              context,
              title: l10n.reverseDns,
              fields: (_) => [
                FieldSpec('ip', l10n.fieldAddress, initial: lb.ipv4 ?? ''),
                FieldSpec(
                  'ptr',
                  l10n.reverseDns,
                  initial: lb.ipv4Ptr ?? '',
                  helper: l10n.reverseDnsHint,
                ),
              ],
              valid: (v) => (v['ip'] ?? '').trim().isNotEmpty,
              onSave: (v) => change(SetLbDnsPtr(v['ip']!, v['ptr'] ?? '')),
            ),
          ),
        ],
      ),
      body: DetailPage(
        status: busy ? ResourceStatus.inProgress : lb.status,
        statusDetail: busy
            ? '${progress.progress} %'
            : (lb.protectDelete ? l10n.protected : null),
        name: lb.name,
        ids: [
          if (lb.ipv4 case final ip?) formatIp(ip),
          lb.type.name.toUpperCase(),
          lb.location,
        ],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          ActionTile(
            icon: Icons.add_link,
            label: l10n.serviceAdd,
            onTap: busy
                ? null
                : () => showServiceSheet(
                    context,
                    ref,
                    scope,
                    save: (s) => change(AddService(s)),
                  ),
          ),
          ActionTile(
            icon: Icons.add_circle_outline,
            label: l10n.targetAdd,
            onTap: busy
                ? null
                : () => showTargetSheet(
                    context,
                    ref,
                    scope,
                    save: (target) => change(AddTarget(target)),
                  ),
          ),
          ActionTile(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            onTap: () => editNameAndLabels(
              context,
              ref,
              t,
              lb.labels,
              (api, name, labels) =>
                  updateLoadBalancer(api, lb.id, name: name, labels: labels),
            ),
          ),
          ActionTile(
            icon: lb.protectDelete ? Icons.lock : Icons.lock_open,
            label: l10n.fieldProtection,
            onTap: busy
                ? null
                : () => toggleProtection(
                    context,
                    ref,
                    t,
                    protected: lb.protectDelete,
                    start: (api, p) =>
                        changeLoadBalancer(api, lb.id, ProtectLb(delete: p)),
                  ),
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionOverview,
            child: FactRows([
              ConfirmFact(
                l10n.fieldType,
                '${lb.type.name.toUpperCase()} · ${_typeDetail(lb.type, l10n)}',
              ),
              ConfirmFact(l10n.fieldLocation, lb.location),
              ConfirmFact(l10n.lbAlgorithm, _algorithm(lb.algorithm, l10n)),
              ConfirmFact(l10n.sectionServices, '${lb.services.length}'),
              ConfirmFact(l10n.sectionTargets, '${lb.targets.length}'),
              ConfirmFact(
                l10n.fieldDeleteProtection,
                yesNo(lb.protectDelete, l10n),
              ),
              ConfirmFact(
                l10n.fieldCreated,
                formatDateTime(lb.created, l10n.localeName),
              ),
              ConfirmFact(l10n.fieldLabels, labelsText(lb.labels, l10n)),
            ]),
          ),
          DetailSection(
            title: l10n.sectionNetwork,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!lb.publicEnabled)
                  Text(l10n.lbPublicDisabled)
                else ...[
                  if (lb.ipv4 case final ip?) ...[
                    Text(l10n.publicIpv4),
                    CopyableValue(formatIp(ip)),
                    if (lb.ipv4Ptr case final ptr? when ptr.isNotEmpty)
                      Text(l10n.reverseDnsValue(ptr)),
                  ],
                  if (lb.ipv6 case final ip?) ...[
                    Text(l10n.publicIpv6),
                    CopyableValue(formatIp(ip)),
                  ],
                ],
                for (final p in lb.privateNets)
                  EntryRow(
                    leading: const Icon(Icons.hub_outlined),
                    title: networks[p.network] ?? '#${p.network}',
                    subtitle: p.ip,
                    removeLabel: l10n.actionRemove,
                    onRemove: busy
                        ? null
                        : () => confirmAction(
                            context,
                            ref,
                            scope,
                            title: l10n.networkDetachTitle(
                              lb.name,
                              networks[p.network] ?? '#${p.network}',
                            ),
                            consequence: l10n.networkDetachConsequence,
                            label: l10n.actionRemove,
                            name: lb.name,
                            start: (api) => changeLoadBalancer(
                              api,
                              lb.id,
                              DetachLbFromNetwork(p.network),
                            ),
                          ),
                  ),
              ],
            ),
          ),
          DetailSection(
            title: l10n.sectionServices,
            child: entries([
              for (final s in lb.services)
                EntryRow(
                  title: serviceTitle(s),
                  subtitle: serviceDetail(s, l10n),
                  onTap: busy
                      ? null
                      : () => showServiceSheet(
                          context,
                          ref,
                          scope,
                          initial: s,
                          save: (next) => change(UpdateService(next)),
                        ),
                  onRemove: busy
                      ? null
                      : () => confirmAction(
                          context,
                          ref,
                          scope,
                          title: l10n.serviceDeleteTitle(serviceTitle(s)),
                          consequence: l10n.serviceDeleteConsequence,
                          label: l10n.actionDelete,
                          name: lb.name,
                          destructive: true,
                          start: (api) => changeLoadBalancer(
                            api,
                            lb.id,
                            DeleteService(s['listen_port']! as int),
                          ),
                        ),
                ),
            ], l10n.servicesEmpty),
          ),
          DetailSection(
            title: l10n.sectionTargets,
            child: entries([
              for (final target in lb.targets)
                EntryRow(
                  title: targetTitle(target, servers),
                  subtitle: targetDetail(target, l10n),
                  removeLabel: l10n.actionRemove,
                  onRemove: busy
                      ? null
                      : () => confirmAction(
                          context,
                          ref,
                          scope,
                          title: l10n.targetRemoveTitle(
                            targetTitle(target, servers),
                          ),
                          consequence: l10n.targetRemoveConsequence,
                          label: l10n.actionRemove,
                          name: lb.name,
                          start: (api) => changeLoadBalancer(
                            api,
                            lb.id,
                            RemoveTarget(target),
                          ),
                        ),
                ),
            ], l10n.targetsEmpty),
          ),
          DetailSection(
            title: l10n.sectionMetrics,
            child: Column(
              spacing: FalcoSpacing.m,
              children: [
                for (final (metric, title, labels, rate) in [
                  (
                    LbMetric.openConnections,
                    l10n.metricOpenConnections,
                    [l10n.metricOpenConnections],
                    false,
                  ),
                  (
                    LbMetric.connectionsPerSecond,
                    l10n.metricConnectionsPerSecond,
                    [l10n.metricConnectionsPerSecond],
                    false,
                  ),
                  (
                    LbMetric.requestsPerSecond,
                    l10n.metricRequestsPerSecond,
                    [l10n.metricRequestsPerSecond],
                    false,
                  ),
                  (
                    LbMetric.bandwidth,
                    l10n.metricNetwork,
                    [l10n.metricIn, l10n.metricOut],
                    true,
                  ),
                ])
                  MetricPanel(
                    title: title,
                    labels: labels,
                    rate: rate,
                    data: (period) => loadBalancerMetricsProvider(
                      scope,
                      lb.id,
                      metric,
                      period,
                    ),
                  ),
              ],
            ),
          ),
          activitySection(l10n, scope, CloudType.loadBalancer, lb.id),
        ],
        dangerZone: [
          DeleteButton(
            onPressed: busy
                ? null
                : () => deleteResource(
                    context,
                    ref,
                    t,
                    l10n.lbDeleteConsequence,
                    (api) => deleteLoadBalancer(api, lb.id),
                  ),
          ),
        ],
      ),
    );
  }
}

String _typeDetail(LbType t, AppLocalizations l10n) =>
    l10n.lbLimits(t.maxConnections, t.maxServices, t.maxTargets);

/// Create a load balancer: location, type, network, details, services
/// and targets (NET-074).
class CreateLoadBalancerPage extends ConsumerStatefulWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  ConsumerState<CreateLoadBalancerPage> createState() =>
      _CreateLoadBalancerPageState();
}

class _CreateLoadBalancerPageState
    extends ConsumerState<CreateLoadBalancerPage> {
  String? _project;
  String _location = '';
  String _type = '';
  String _network = '';
  var _values = <String, String>{'algorithm': 'round_robin'};
  final _services = <LbService>[];
  final _targets = <LbTarget>[];
  bool _creating = false;

  Future<void> _create(ProjectScope scope) async {
    if (_creating) return;
    setState(() => _creating = true);
    final l10n = AppLocalizations.of(context);
    final name = _values['name']!.trim();
    final ok = await runChange(
      context,
      ref,
      (scope: scope, type: CloudType.loadBalancer, id: 0, name: name),
      (api) async {
        final r = await createLoadBalancer(
          api,
          name: name,
          type: _type,
          location: _location,
          algorithm: _values['algorithm'] ?? 'round_robin',
          network: int.tryParse(_network),
          services: _services,
          targets: _targets,
          labels: parseLabels(_values['labels'] ?? '') ?? const {},
        );
        ref.read(actionTrackerProvider(scope)).track(r.action);
      },
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
    List<T> load<T>(
      ProviderListenable<AsyncValue<List<T>>> Function(ProjectScope) p,
    ) => scope == null ? <T>[] : ref.watch(p(scope)).value ?? <T>[];
    final locations = load(locationsProvider.call);
    final pricing = scope == null
        ? null
        : ref.watch(pricingProvider(scope)).value;
    final types = [
      for (final t in load(loadBalancerTypesProvider.call))
        if (!t.deprecated && t.prices.containsKey(_location)) t,
    ];
    final networks = load(networksProvider.call);
    final servers = {for (final s in load(serversProvider.call)) s.id: s.name};
    String price(LbType t) => l10n.perMonth(
      formatMoney(
        t.prices[_location] ?? 0,
        pricing?.currency ?? 'EUR',
        l10n.localeName,
      ),
    );
    final networkNames = {
      '': l10n.commonNone,
      for (final n in networks) '${n.id}': n.name,
    };
    return CreateWizard(
      title: l10n.loadBalancerCreate,
      creating: _creating,
      onCreate: scope == null ? null : () => _create(scope),
      projectStep: projectStep(
        ref,
        l10n,
        widget.scope,
        _project,
        (p) => setState(() {
          _project = p;
          _location = _type = _network = '';
          _services.clear();
          _targets.clear();
        }),
      ),
      steps: [
        WizardStep(
          title: l10n.fieldLocation,
          canContinue: _location.isNotEmpty,
          child: ChoiceList(
            options: {for (final l in locations) l.name: l.name},
            details: {for (final l in locations) l.name: l.detail},
            selected: _location,
            onSelected: (v) => setState(() {
              _location = v;
              _type = '';
            }),
          ),
        ),
        WizardStep(
          title: l10n.fieldType,
          canContinue: types.any((t) => t.name == _type),
          child: ChoiceList(
            options: {for (final t in types) t.name: t.name.toUpperCase()},
            details: {
              for (final t in types)
                t.name: '${_typeDetail(t, l10n)} · ${price(t)}',
            },
            selected: _type,
            onSelected: (v) => setState(() => _type = v),
          ),
        ),
        WizardStep(
          title: l10n.resourceNetwork,
          child: ChoiceList(
            options: networkNames,
            selected: _network,
            onSelected: (v) => setState(() => _network = v),
          ),
        ),
        WizardStep(
          title: l10n.wizardDetails,
          canContinue:
              (_values['name'] ?? '').trim().isNotEmpty && validLabels(_values),
          child: FormFields(
            fields: [
              FieldSpec('name', l10n.fieldName, maxLength: 63),
              FieldSpec(
                'algorithm',
                l10n.lbAlgorithm,
                initial: 'round_robin',
                options: {for (final a in lbAlgorithms) a: _algorithm(a, l10n)},
              ),
              labelsField(l10n),
            ],
            values: _values,
            onChanged: (v) => setState(() => _values = {..._values, ...v}),
          ),
        ),
        WizardStep(
          title: l10n.sectionServices,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              entries([
                for (final s in _services)
                  EntryRow(
                    title: serviceTitle(s),
                    subtitle: serviceDetail(s, l10n),
                    onRemove: () => setState(() => _services.remove(s)),
                  ),
              ], l10n.servicesEmpty),
              OutlinedButton.icon(
                onPressed: scope == null
                    ? null
                    : () => showServiceSheet(
                        context,
                        ref,
                        scope,
                        save: (s) async => setState(() => _services.add(s)),
                      ),
                icon: const Icon(Icons.add),
                label: Text(l10n.serviceAdd),
              ),
            ],
          ),
        ),
        WizardStep(
          title: l10n.sectionTargets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              entries([
                for (final target in _targets)
                  EntryRow(
                    title: targetTitle(target, servers),
                    subtitle: targetDetail(target, l10n),
                    onRemove: () => setState(() => _targets.remove(target)),
                  ),
              ], l10n.targetsEmpty),
              OutlinedButton.icon(
                onPressed: scope == null
                    ? null
                    : () => showTargetSheet(
                        context,
                        ref,
                        scope,
                        save: (target) async =>
                            setState(() => _targets.add(target)),
                      ),
                icon: const Icon(Icons.add),
                label: Text(l10n.targetAdd),
              ),
            ],
          ),
        ),
      ],
      summary: FactRows([
        ConfirmFact(l10n.fieldName, (_values['name'] ?? '').trim()),
        ConfirmFact(l10n.fieldLocation, _location),
        ConfirmFact(l10n.fieldType, _type.toUpperCase()),
        ConfirmFact(l10n.resourceNetwork, networkNames[_network] ?? ''),
        ConfirmFact(
          l10n.lbAlgorithm,
          _algorithm(_values['algorithm'] ?? 'round_robin', l10n),
        ),
        ConfirmFact(
          l10n.sectionServices,
          _services.map(serviceTitle).join(', '),
        ),
        ConfirmFact(
          l10n.sectionTargets,
          [for (final t in _targets) targetTitle(t, servers)].join(', '),
        ),
        for (final t in types)
          if (t.name == _type) ConfirmFact(l10n.fieldPrice, price(t)),
      ]),
    );
  }
}
