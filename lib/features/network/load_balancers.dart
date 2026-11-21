// SPDX-License-Identifier: GPL-3.0-or-later
/// Load balancers: model, providers, metrics and operations
/// (NET-056 to NET-078, NET-087, NET-088, NET-090, NET-091).
// Generated model names of nested paths exceed 80 characters.
// ignore_for_file: lines_longer_than_80_chars
library;

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/http/pagination.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'load_balancers.g.dart';

/// Service protocols (NET-060).
const lbProtocols = ['tcp', 'http', 'https'];

/// Balancing algorithms (NET-068).
const lbAlgorithms = ['round_robin', 'least_connections'];

/// A service as the API sends it: `protocol`, `listen_port`,
/// `destination_port`, `proxyprotocol`, `health_check` and, for http and
/// https, `http` (NET-059, NET-087, NET-088).
typedef LbService = Json;

/// A target as the API sends it: `type` with `server`, `label_selector`
/// or `ip`, `use_private_ip` and `health_status` (NET-063).
typedef LbTarget = Json;

/// A load balancer type with its limits and monthly gross price per
/// location (NET-069, NET-091).
@immutable
class LbType {
  const new({
    required this.name,
    required this.description,
    required this.maxConnections,
    required this.maxServices,
    required this.maxTargets,
    required this.maxCertificates,
    this.prices = const {},
    this.deprecated = false,
  });

  factory fromJson(Json t) => LbType(
    name: t['name']! as String,
    description: t['description'] as String? ?? '',
    maxConnections: t['max_connections'] as int? ?? 0,
    maxServices: t['max_services'] as int? ?? 0,
    maxTargets: t['max_targets'] as int? ?? 0,
    maxCertificates: t['max_assigned_certificates'] as int? ?? 0,
    prices: {
      for (final p in jsonList(t['prices']))
        p['location']! as String: num.parse(
          '${json(p['price_monthly'])['gross']}',
        ),
    },
    deprecated: t['deprecation'] != null,
  );

  final String name;
  final String description;
  final int maxConnections;
  final int maxServices;
  final int maxTargets;
  final int maxCertificates;
  final Map<String, num> prices;
  final bool deprecated;
}

/// A load balancer as Falco shows it.
@immutable
class LoadBalancer {
  const new({
    required this.id,
    required this.projectId,
    required this.name,
    required this.type,
    required this.location,
    required this.algorithm,
    required this.created,
    this.publicEnabled = true,
    this.ipv4,
    this.ipv6,
    this.ipv4Ptr,
    this.privateNets = const [],
    this.services = const [],
    this.targets = const [],
    this.protectDelete = false,
    this.labels = const {},
  });

  factory fromJson(Json j, String projectId) {
    final net = json(j['public_net']);
    return LoadBalancer(
      id: j['id']! as int,
      projectId: projectId,
      name: j['name']! as String,
      type: LbType.fromJson(json(j['load_balancer_type'])),
      location: json(j['location'])['name'] as String? ?? '',
      algorithm: json(j['algorithm'])['type'] as String? ?? 'round_robin',
      created: DateTime.parse(j['created']! as String),
      publicEnabled: net['enabled'] as bool? ?? false,
      ipv4: json(net['ipv4'])['ip'] as String?,
      ipv6: json(net['ipv6'])['ip'] as String?,
      ipv4Ptr: json(net['ipv4'])['dns_ptr'] as String?,
      privateNets: [
        for (final p in jsonList(j['private_net']))
          (network: p['network']! as int, ip: p['ip']! as String),
      ],
      services: jsonList(j['services']),
      targets: jsonList(j['targets']),
      protectDelete: json(j['protection'])['delete'] as bool? ?? false,
      labels: json(j['labels']).cast<String, String>(),
    );
  }

  final int id;
  final String projectId;
  final String name;
  final LbType type;
  final String location;
  final String algorithm;
  final DateTime created;
  final bool publicEnabled;
  final String? ipv4;
  final String? ipv6;
  final String? ipv4Ptr;
  final List<({int network, String ip})> privateNets;
  final List<LbService> services;
  final List<LbTarget> targets;
  final bool protectDelete;
  final Map<String, String> labels;

  /// Healthy when every target answers on every service.
  ResourceStatus get status {
    final states = [
      for (final t in targets)
        for (final h in jsonList(t['health_status'])) h['status'],
    ];
    if (states.contains('unhealthy')) return ResourceStatus.error;
    return ResourceStatus.running;
  }
}

/// All load balancers of [scope] (NET-056).
@riverpod
Future<List<LoadBalancer>> loadBalancers(Ref ref, Scope scope) => perProject(
  ref,
  scope,
  (api, projectId) => fetchAllJson(
    (page) =>
        cloud.LoadBalancersApi(api)
            .listLoadBalancers(page: page, perPage: maxPerPage),
    'load_balancers',
    (j) => LoadBalancer.fromJson(j, projectId),
  ),
);

/// One load balancer (NET-057, NET-058).
@riverpod
Future<LoadBalancer> loadBalancer(Ref ref, ProjectScope scope, int lbId) async {
  final api = ref.watch(cloudApiProvider(scope.projectId));
  final body = await cloudJson(
    cloud.LoadBalancersApi(api).getLoadBalancer(id: lbId),
  );
  return LoadBalancer.fromJson(json(body['load_balancer']), scope.projectId);
}

/// Load balancer types offered (NET-069, NET-091).
@riverpod
Future<List<LbType>> loadBalancerTypes(Ref ref, ProjectScope scope) =>
    fetchAllJson(
      (page) => cloud.LoadBalancerTypesApi(
        ref.watch(cloudApiProvider(scope.projectId)),
      ).listLoadBalancerTypes(page: page, perPage: maxPerPage),
      'load_balancer_types',
      LbType.fromJson,
    );

/// Metric families of `GET /load_balancers/{id}/metrics` with their
/// series keys (NET-078).
enum LbMetric {
  openConnections('open_connections', ['open_connections']),
  connectionsPerSecond('connections_per_second', ['connections_per_second']),
  requestsPerSecond('requests_per_second', ['requests_per_second']),
  bandwidth('bandwidth', ['bandwidth.in', 'bandwidth.out']);

  new(this.param, this.keys);

  final String param;
  final List<String> keys;
}

/// Samples of [metric] over [period], one list per series key.
@riverpod
Future<List<List<(DateTime, double)>>> loadBalancerMetrics(
  Ref ref,
  ProjectScope scope,
  int lbId,
  LbMetric metric,
  MetricPeriod period,
) async {
  final end = DateTime.now().toUtc();
  final body = await cloudJson(
    cloud.LoadBalancersApi(
      ref.watch(cloudApiProvider(scope.projectId)),
    ).getLoadBalancerMetrics(
      id: lbId,
      $type: [
        cloud.LoadBalancersIdMetricsParametersArrayModel.fromJson(metric.param),
      ],
      start: end.subtract(period.duration).toIso8601String(),
      end: end.toIso8601String(),
      step: '${period.duration.inSeconds ~/ 120}',
    ),
  );
  return metricSeries(json(json(body['metrics'])['time_series']), metric.keys);
}

/// Series of a metrics `time_series` object: one list of samples per key.
List<List<(DateTime, double)>> metricSeries(Json series, List<String> keys) => [
  for (final key in keys)
    [
      for (final v in (json(series[key])['values'] as List?) ?? const [])
        if (v case [final num t, final String value])
          (
            DateTime.fromMillisecondsSinceEpoch(
              (t * 1000).round(),
              isUtc: true,
            ).toLocal(),
            double.tryParse(value) ?? 0,
          ),
    ],
];

/// Creates a load balancer (NET-074). Returns its id and action.
Future<({int id, int action})> createLoadBalancer(
  cloud.Server api, {
  required String name,
  required String type,
  required String location,
  String algorithm = 'round_robin',
  int? network,
  List<LbService> services = const [],
  List<LbTarget> targets = const [],
  Map<String, String> labels = const {},
}) async {
  final body = await cloudJson(
    cloud.LoadBalancersApi(api).createLoadBalancer(
      body: cloud.LoadBalancersPostBodyBodyModel.fromJson({
        'name': name,
        'load_balancer_type': type,
        'location': location,
        'algorithm': {'type': algorithm},
        'network': ?network,
        'services': services,
        'targets': targets,
        'labels': labels,
      }),
    ),
  );
  return (
    id: json(body['load_balancer'])['id']! as int,
    action: json(body['action'])['id']! as int,
  );
}

/// Renames or relabels a load balancer (NET-072, NET-090).
Future<void> updateLoadBalancer(
  cloud.Server api,
  int id, {
  String? name,
  Map<String, String>? labels,
}) => unwrap(
  cloud.LoadBalancersApi(api).updateLoadBalancer(
    id: id,
    body: cloud.LoadBalancersIdPutBodyBodyModel.fromJson({
      'name': ?name,
      'labels': ?labels,
    }),
  ),
);

/// Deletes a load balancer (NET-073).
Future<void> deleteLoadBalancer(cloud.Server api, int id) =>
    unwrap(cloud.LoadBalancersApi(api).deleteLoadBalancer(id: id));

/// The body naming [target] for removal: its type and key only.
Json targetKey(LbTarget target) => {
  'type': target['type'],
  switch (target['type']) {
    'server' => 'server',
    'label_selector' => 'label_selector',
    _ => 'ip',
  }: switch (target['type']) {
    'server' => {'id': json(target['server'])['id']},
    'label_selector' => {
      'selector': json(target['label_selector'])['selector'],
    },
    _ => {'ip': json(target['ip'])['ip']},
  },
};

/// Load balancer actions; each starts one Hetzner action.
sealed class LbChange {
  const new();
}

final class AddService extends LbChange {
  const new(this.service);

  final LbService service;
}

/// Updates the service on its `listen_port` (NET-061, NET-087).
final class UpdateService extends LbChange {
  const new(this.service);

  final LbService service;
}

final class DeleteService extends LbChange {
  const new(this.listenPort);

  final int listenPort;
}

final class AddTarget extends LbChange {
  const new(this.target);

  final LbTarget target;
}

final class RemoveTarget extends LbChange {
  const new(this.target);

  final LbTarget target;
}

final class ChangeAlgorithm extends LbChange {
  const new(this.algorithm);

  final String algorithm;
}

final class ChangeLbType extends LbChange {
  const new(this.type);

  final String type;
}

final class AttachLbToNetwork extends LbChange {
  const new(this.network, [this.ip = '']);

  final int network;
  final String ip;
}

final class DetachLbFromNetwork extends LbChange {
  const new(this.network);

  final int network;
}

final class SetPublicInterface extends LbChange {
  const new({required this.enabled});

  final bool enabled;
}

final class SetLbDnsPtr extends LbChange {
  const new(this.ip, this.ptr);

  final String ip;

  /// Empty resets to the Hetzner default.
  final String ptr;
}

final class ProtectLb extends LbChange {
  const new({required this.delete});

  final bool delete;
}

/// Starts [change] on load balancer [id] (NET-060 to NET-071, NET-075 to
/// NET-077).
Future<int> changeLoadBalancer(cloud.Server api, int id, LbChange change) {
  final a = cloud.LoadBalancerActionsApi(api);
  return cloudAction(switch (change) {
    AddService(:final service) => a.addLoadBalancerService(
      id: id,
      body:
          cloud.LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel.fromJson(
            service,
          ),
    ),
    UpdateService(:final service) => a.updateLoadBalancerService(
      id: id,
      body:
          cloud
              .LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel.fromJson(
            service,
          ),
    ),
    DeleteService(:final listenPort) => a.deleteLoadBalancerService(
      id: id,
      body: cloud.LoadBalancersIdActionsDeleteServicePostBodyBodyModel.fromJson(
        {'listen_port': listenPort},
      ),
    ),
    AddTarget(:final target) => a.addLoadBalancerTarget(
      id: id,
      body:
          cloud.LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel.fromJson(
            target,
          ),
    ),
    RemoveTarget(:final target) => a.removeLoadBalancerTarget(
      id: id,
      body: cloud.LoadBalancersIdActionsRemoveTargetPostBodyBodyModel.fromJson(
        targetKey(target),
      ),
    ),
    ChangeAlgorithm(:final algorithm) => a.changeLoadBalancerAlgorithm(
      id: id,
      body:
          cloud.LoadBalancersIdActionsChangeAlgorithmPostBodyBodyModel.fromJson(
            {'type': algorithm},
          ),
    ),
    ChangeLbType(:final type) => a.changeLoadBalancerType(
      id: id,
      body: cloud.LoadBalancersIdActionsChangeTypePostBodyBodyModel.fromJson({
        'load_balancer_type': type,
      }),
    ),
    AttachLbToNetwork(:final network, :final ip) =>
      a.attachLoadBalancerToNetwork(
        id: id,
        body:
            cloud
                .LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel.fromJson(
              {'network': network, if (ip.trim().isNotEmpty) 'ip': ip.trim()},
            ),
      ),
    DetachLbFromNetwork(:final network) => a.detachLoadBalancerFromNetwork(
      id: id,
      body:
          cloud
              .LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel.fromJson(
            {'network': network},
          ),
    ),
    SetPublicInterface(enabled: true) => a.enableLoadBalancerPublicInterface(
      id: id,
    ),
    SetPublicInterface() => a.disableLoadBalancerPublicInterface(id: id),
    SetLbDnsPtr(:final ip, :final ptr) => a.changeLoadBalancerDnsPtr(
      id: id,
      body: cloud.LoadBalancersIdActionsChangeDnsPtrPostBodyBodyModel.fromJson({
        'ip': ip.trim(),
        'dns_ptr': ptr.trim().isEmpty ? null : ptr.trim(),
      }),
    ),
    ProtectLb(:final delete) => a.changeLoadBalancerProtection(
      id: id,
      body:
          cloud
              .LoadBalancersIdActionsChangeProtectionPostBodyBodyModel.fromJson(
            {'delete': delete},
          ),
    ),
  });
}

/// A port 1 to 65535 (NET-060).
bool validServicePort(String? text) {
  final p = int.tryParse(text?.trim() ?? '');
  return p != null && p >= 1 && p <= 65535;
}

/// Builds a service body from form [v] (NET-060, NET-087, NET-088).
/// Health check http options apply to an http health check only.
LbService serviceJson(Map<String, String> v) {
  final protocol = v['protocol'] ?? 'tcp';
  final health = v['hcProtocol'] ?? 'tcp';
  int n(String key, int fallback) =>
      int.tryParse(v[key]?.trim() ?? '') ?? fallback;
  final destination = n('destination', 80);
  return {
    'protocol': protocol,
    'listen_port': n('listen', 80),
    'destination_port': destination,
    'proxyprotocol': v['proxy'] == 'true',
    'health_check': {
      'protocol': health,
      'port': n('hcPort', destination),
      'interval': n('hcInterval', 15),
      'timeout': n('hcTimeout', 10),
      'retries': n('hcRetries', 3),
      if (health == 'http')
        'http': {
          'domain': (v['hcDomain'] ?? '').trim().isEmpty
              ? null
              : v['hcDomain']!.trim(),
          'path': (v['hcPath'] ?? '').trim().isEmpty
              ? '/'
              : v['hcPath']!.trim(),
          'status_codes': [
            for (final c in (v['hcCodes'] ?? '').split(RegExp(r'[\s,]+')))
              if (c.isNotEmpty) c,
          ],
          'tls': v['hcTls'] == 'true',
        },
    },
    if (protocol != 'tcp')
      'http': {
        'sticky_sessions': v['sticky'] == 'true',
        if ((v['cookie'] ?? '').trim().isNotEmpty)
          'cookie_name': v['cookie']!.trim(),
        'cookie_lifetime': ?int.tryParse(v['cookieLifetime']?.trim() ?? ''),
        if (protocol == 'https') ...{
          'redirect_http': v['redirect'] == 'true',
          'certificates': [
            for (final c in (v['certificates'] ?? '').split(','))
              ?int.tryParse(c),
          ],
        },
      },
  };
}

/// Form values of [s], the inverse of [serviceJson].
Map<String, String> serviceValues(LbService s) {
  final h = json(s['health_check']);
  final hh = json(h['http']);
  final http = json(s['http']);
  return {
    'protocol': '${s['protocol']}',
    'listen': '${s['listen_port']}',
    'destination': '${s['destination_port']}',
    'proxy': '${s['proxyprotocol'] ?? false}',
    'hcProtocol': '${h['protocol'] ?? 'tcp'}',
    'hcPort': '${h['port'] ?? ''}',
    'hcInterval': '${h['interval'] ?? 15}',
    'hcTimeout': '${h['timeout'] ?? 10}',
    'hcRetries': '${h['retries'] ?? 3}',
    'hcDomain': '${hh['domain'] ?? ''}',
    'hcPath': '${hh['path'] ?? '/'}',
    'hcCodes': ((hh['status_codes'] as List?) ?? const ['2??', '3??']).join(
      ', ',
    ),
    'hcTls': '${hh['tls'] ?? false}',
    'sticky': '${http['sticky_sessions'] ?? false}',
    'cookie': '${http['cookie_name'] ?? ''}',
    'cookieLifetime': '${http['cookie_lifetime'] ?? ''}',
    'redirect': '${http['redirect_http'] ?? false}',
    'certificates': ((http['certificates'] as List?) ?? const []).join(','),
  };
}

/// Whether service form [v] is complete: ports in range, health check
/// numbers within the API limits (NET-060, NET-087).
bool validService(Map<String, String> v) {
  bool within(String key, int min, int max) {
    final n = int.tryParse(v[key]?.trim() ?? '');
    return n != null && n >= min && n <= max;
  }

  return validServicePort(v['listen']) &&
      validServicePort(v['destination']) &&
      ((v['hcPort'] ?? '').trim().isEmpty || validServicePort(v['hcPort'])) &&
      within('hcInterval', 3, 60) &&
      within('hcTimeout', 1, 60) &&
      within('hcRetries', 1, 5) &&
      (v['protocol'] != 'https' || (v['certificates'] ?? '').isNotEmpty);
}

/// Builds a target body from form [v] (NET-064 to NET-066).
LbTarget targetJson(Map<String, String> v) => switch (v['type']) {
  'label_selector' => {
    'type': 'label_selector',
    'label_selector': {'selector': v['selector']!.trim()},
    'use_private_ip': v['private'] == 'true',
  },
  'ip' => {
    'type': 'ip',
    'ip': {'ip': v['ip']!.trim()},
  },
  _ => {
    'type': 'server',
    'server': {'id': int.parse(v['server']!)},
    'use_private_ip': v['private'] == 'true',
  },
};

/// Whether target form [v] names a target.
bool validTarget(Map<String, String> v) => switch (v['type']) {
  'label_selector' => (v['selector'] ?? '').trim().isNotEmpty,
  'ip' => (v['ip'] ?? '').trim().isNotEmpty,
  _ => int.tryParse(v['server'] ?? '') != null,
};
