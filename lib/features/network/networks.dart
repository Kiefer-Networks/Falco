// SPDX-License-Identifier: GPL-3.0-or-later
/// Private networks: model, providers, operations and the address rules
/// of their forms (NET-039 to NET-055, NET-090, NET-092).
library;

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/http/pagination.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:flutter/foundation.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'networks.g.dart';

/// Network zones a subnet can live in (NET-041).
const networkZones = ['eu-central', 'us-east', 'us-west', 'ap-southeast'];

/// Subnet types (NET-041); `vswitch` needs a vSwitch id.
const subnetTypes = ['cloud', 'server', 'vswitch'];

typedef Subnet = ({
  String type,
  String? ipRange,
  String zone,
  String gateway,
  int? vswitchId,
});

typedef Route = ({String destination, String gateway});

/// A private network as Falco shows it.
@immutable
class CloudNetwork {
  const new({
    required this.id,
    required this.projectId,
    required this.name,
    required this.ipRange,
    required this.created,
    this.subnets = const [],
    this.routes = const [],
    this.servers = const [],
    this.loadBalancers = const [],
    this.exposeRoutes = false,
    this.protectDelete = false,
    this.labels = const {},
  });

  factory fromJson(Json n, String projectId) => CloudNetwork(
    id: n['id']! as int,
    projectId: projectId,
    name: n['name']! as String,
    ipRange: n['ip_range']! as String,
    created: DateTime.parse(n['created']! as String),
    subnets: [
      for (final s in jsonList(n['subnets']))
        (
          type: s['type']! as String,
          ipRange: s['ip_range'] as String?,
          zone: s['network_zone']! as String,
          gateway: s['gateway'] as String? ?? '',
          vswitchId: s['vswitch_id'] as int?,
        ),
    ],
    routes: [
      for (final r in jsonList(n['routes']))
        (
          destination: r['destination']! as String,
          gateway: r['gateway']! as String,
        ),
    ],
    servers: [...?(n['servers'] as List?)?.cast<int>()],
    loadBalancers: [...?(n['load_balancers'] as List?)?.cast<int>()],
    exposeRoutes: n['expose_routes_to_vswitch'] as bool? ?? false,
    protectDelete: json(n['protection'])['delete'] as bool? ?? false,
    labels: json(n['labels']).cast<String, String>(),
  );

  final int id;
  final String projectId;
  final String name;
  final String ipRange;
  final DateTime created;
  final List<Subnet> subnets;
  final List<Route> routes;
  final List<int> servers;
  final List<int> loadBalancers;
  final bool exposeRoutes;
  final bool protectDelete;
  final Map<String, String> labels;

  /// Whether a vSwitch is coupled through a subnet.
  bool get hasVswitch => subnets.any((s) => s.type == 'vswitch');
}

/// A server or load balancer in a network with its private IP (NET-092).
typedef NetworkMember = ({
  String type,
  int id,
  String ip,
  String status,
  List<String> aliasIps,
});

/// All networks of [scope] (NET-039).
@riverpod
Future<List<CloudNetwork>> networks(Ref ref, Scope scope) => perProject(
  ref,
  scope,
  (api, projectId) => fetchAllJson(
    (page) =>
        cloud.NetworksApi(api).listNetworks(page: page, perPage: maxPerPage),
    'networks',
    (j) => CloudNetwork.fromJson(j, projectId),
  ),
);

/// One network (NET-043).
@riverpod
Future<CloudNetwork> network(Ref ref, ProjectScope scope, int networkId) async {
  final api = ref.watch(cloudApiProvider(scope.projectId));
  final body = await cloudJson(
    cloud.NetworksApi(api).getNetwork(id: networkId),
  );
  return CloudNetwork.fromJson(json(body['network']), scope.projectId);
}

/// Servers and load balancers of a network (NET-092).
@riverpod
Future<List<NetworkMember>> networkMembers(
  Ref ref,
  ProjectScope scope,
  int networkId,
) => fetchAllJson(
  (page) =>
      cloud.NetworksApi(ref.watch(cloudApiProvider(scope.projectId)))
          .listNetworkMembers(id: networkId, page: page, perPage: maxPerPage),
  'members',
  (m) => (
    type: m['type']! as String,
    id: m['id']! as int,
    ip: m['ip']! as String,
    status: m['status']! as String,
    aliasIps: [...?(m['alias_ips'] as List?)?.cast<String>()],
  ),
);

/// Creates a network, optionally with its first subnet (NET-040 to
/// NET-042). Returns its id; creating starts no action.
Future<int> createNetwork(
  cloud.Server api, {
  required String name,
  required String ipRange,
  Json? subnet,
  Map<String, String> labels = const {},
}) async {
  final body = await cloudJson(
    cloud.NetworksApi(api).createNetwork(
      body: cloud.NetworksPostBodyBodyModel.fromJson({
        'name': name,
        'ip_range': ipRange,
        'subnets': [?subnet],
        'labels': labels,
      }),
    ),
  );
  return json(body['network'])['id']! as int;
}

/// The body of a subnet (NET-041, NET-046); an empty range lets Hetzner
/// pick the next free one.
Json subnetJson({
  required String type,
  required String zone,
  String ipRange = '',
  int? vswitchId,
}) => {
  'type': type,
  'network_zone': zone,
  if (ipRange.isNotEmpty) 'ip_range': ipRange,
  if (type == 'vswitch') 'vswitch_id': ?vswitchId,
};

/// Renames, relabels or sets "expose routes to vSwitch" (NET-052, NET-053,
/// NET-090).
Future<void> updateNetwork(
  cloud.Server api,
  int id, {
  String? name,
  Map<String, String>? labels,
  bool? exposeRoutes,
}) => unwrap(
  cloud.NetworksApi(api).updateNetwork(
    id: id,
    body: cloud.NetworksIdPutBodyBodyModel.fromJson({
      'name': ?name,
      'labels': ?labels,
      'expose_routes_to_vswitch': ?exposeRoutes,
    }),
  ),
);

/// Deletes a network with its subnets (NET-055).
Future<void> deleteNetwork(cloud.Server api, int id) =>
    unwrap(cloud.NetworksApi(api).deleteNetwork(id: id));

/// Network actions; each starts one Hetzner action.
sealed class NetworkChange {
  const new();
}

final class AddSubnet extends NetworkChange {
  const new(this.subnet);

  final Json subnet;
}

final class DeleteSubnet extends NetworkChange {
  const new(this.ipRange);

  final String ipRange;
}

final class AddRoute extends NetworkChange {
  const new(this.route);

  final Route route;
}

final class DeleteRoute extends NetworkChange {
  const new(this.route);

  final Route route;
}

final class ChangeIpRange extends NetworkChange {
  const new(this.ipRange);

  final String ipRange;
}

final class ProtectNetwork extends NetworkChange {
  const new({required this.delete});

  final bool delete;
}

/// Starts [change] on network [id] (NET-046 to NET-051, NET-054).
Future<int> changeNetwork(cloud.Server api, int id, NetworkChange change) {
  final a = cloud.NetworkActionsApi(api);
  Json route(Route r) => {'destination': r.destination, 'gateway': r.gateway};
  return cloudAction(switch (change) {
    AddSubnet(:final subnet) => a.addNetworkSubnet(
      id: id,
      body: cloud.NetworksIdActionsAddSubnetPostBodyBodyModel.fromJson(subnet),
    ),
    DeleteSubnet(:final ipRange) => a.deleteNetworkSubnet(
      id: id,
      body: cloud.NetworksIdActionsDeleteSubnetPostBodyBodyModel.fromJson({
        'ip_range': ipRange,
      }),
    ),
    AddRoute(route: final r) => a.addNetworkRoute(
      id: id,
      body: cloud.NetworksIdActionsAddRoutePostBodyBodyModel.fromJson(route(r)),
    ),
    DeleteRoute(route: final r) => a.deleteNetworkRoute(
      id: id,
      body: cloud.NetworksIdActionsDeleteRoutePostBodyBodyModel.fromJson(
        route(r),
      ),
    ),
    ChangeIpRange(:final ipRange) => a.changeNetworkIpRange(
      id: id,
      body: cloud.NetworksIdActionsChangeIpRangePostBodyBodyModel.fromJson({
        'ip_range': ipRange,
      }),
    ),
    ProtectNetwork(:final delete) => a.changeNetworkProtection(
      id: id,
      body: cloud.NetworksIdActionsChangeProtectionPostBodyBodyModel.fromJson({
        'delete': delete,
      }),
    ),
  });
}

/// An IPv4 block: network address and prefix length.
typedef Cidr = ({int address, int prefix});

/// Parses `a.b.c.d`; null when it is none.
int? parseIpv4(String text) {
  final parts = text.trim().split('.');
  if (parts.length != 4) return null;
  var value = 0;
  for (final p in parts) {
    final n = int.tryParse(p);
    if (n == null || n < 0 || n > 255 || '$n' != p) return null;
    value = value << 8 | n;
  }
  return value;
}

/// Parses `a.b.c.d/n` with the host bits zero; null when it is none.
Cidr? parseCidr(String text) {
  final [ip, prefix, ...rest] = '${text.trim()}/'.split('/');
  if (rest.length != 1 || rest.single.isNotEmpty) return null;
  final address = parseIpv4(ip);
  final n = int.tryParse(prefix);
  if (address == null || n == null || n < 0 || n > 32) return null;
  if (address & ~_mask(n) & 0xFFFFFFFF != 0) return null;
  return (address: address, prefix: n);
}

int _mask(int prefix) =>
    prefix == 0 ? 0 : (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;

/// Whether [inner] lies within [outer].
bool cidrContains(Cidr outer, Cidr inner) =>
    inner.prefix >= outer.prefix &&
    inner.address & _mask(outer.prefix) == outer.address;

/// Whether [ip] lies within [block].
bool ipInCidr(Cidr block, int ip) => ip & _mask(block.prefix) == block.address;

/// The private ranges of RFC 1918, the only ones a network may use.
final List<Cidr> privateRanges = [
  for (final r in ['10.0.0.0/8', '172.16.0.0/12', '192.168.0.0/16'])
    parseCidr(r)!,
];

/// A network range: a private CIDR block (NET-040).
bool validNetworkRange(String text) => switch (parseCidr(text)) {
  final c? => privateRanges.any((p) => cidrContains(p, c)),
  null => false,
};

/// A subnet range: empty (Hetzner picks one) or a block inside [network]
/// (NET-046).
bool validSubnetRange(String text, String network) =>
    text.trim().isEmpty ||
    switch ((parseCidr(text), parseCidr(network))) {
      (final s?, final n?) => cidrContains(n, s),
      _ => false,
    };

/// A route: any destination block and a gateway inside [network]
/// (NET-049).
bool validRoute(String destination, String gateway, String network) =>
    parseCidr(destination) != null &&
    switch ((parseIpv4(gateway), parseCidr(network))) {
      (final g?, final n?) => ipInCidr(n, g),
      _ => false,
    };

/// A new range must contain the current one and differ from it (NET-051).
bool validRangeChange(String text, String current) =>
    switch ((parseCidr(text), parseCidr(current))) {
      (final next?, final now?) =>
        next != now &&
            cidrContains(next, now) &&
            privateRanges.any((p) => cidrContains(p, next)),
      _ => false,
    };
