// SPDX-License-Identifier: GPL-3.0-or-later
/// Floating IPs and Primary IPs: one model and one set of operations for
/// both kinds (NET-018 to NET-038, NET-093, NET-094, BUG-015).
library;

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/http/pagination.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:flutter/foundation.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ips.g.dart';

/// Floating IPs move between servers; Primary IPs are a server's public
/// address and need the server off to move.
enum IpKind { floating, primary }

/// A Floating or Primary IP as Falco shows it.
@immutable
class PublicIp {
  const new({
    required this.kind,
    required this.id,
    required this.projectId,
    required this.name,
    required this.ip,
    required this.ipv6,
    required this.location,
    required this.created,
    this.server,
    this.reverseDns = const {},
    this.description,
    this.autoDelete = false,
    this.blocked = false,
    this.protectDelete = false,
    this.labels = const {},
  });

  factory fromJson(IpKind kind, Json j, String projectId) => PublicIp(
    kind: kind,
    id: j['id']! as int,
    projectId: projectId,
    name: j['name']! as String,
    ip: j['ip']! as String,
    ipv6: j['type'] == 'ipv6',
    // Home location of a Floating IP; location of a Primary IP (BUG-011).
    location:
        json(j[kind == IpKind.floating ? 'home_location' : 'location'])['name']
            as String? ??
        '',
    created: DateTime.parse(j['created']! as String),
    server: kind == IpKind.floating
        ? j['server'] as int?
        : j['assignee_id'] as int?,
    reverseDns: {
      for (final d in jsonList(j['dns_ptr']))
        d['ip']! as String: d['dns_ptr']! as String,
    },
    description: j['description'] as String?,
    autoDelete: j['auto_delete'] as bool? ?? false,
    blocked: j['blocked'] as bool? ?? false,
    protectDelete: json(j['protection'])['delete'] as bool? ?? false,
    labels: json(j['labels']).cast<String, String>(),
  );

  final IpKind kind;
  final int id;
  final String projectId;
  final String name;

  /// The address; an IPv6 network for IPv6 (`2001:db8::/64`).
  final String ip;
  final bool ipv6;
  final String location;
  final DateTime created;

  /// Assigned server id.
  final int? server;

  /// Address to PTR record.
  final Map<String, String> reverseDns;
  final String? description;
  final bool autoDelete;
  final bool blocked;
  final bool protectDelete;
  final Map<String, String> labels;

  /// The address a reverse DNS entry is set for by default: the IP itself,
  /// or `::1` of an IPv6 network.
  String get ptrAddress =>
      ipv6 ? ip.split('/').first.replaceAll(RegExp(r'::$'), '::1') : ip;
}

String _collection(IpKind kind) =>
    kind == IpKind.floating ? 'floating_ips' : 'primary_ips';

/// All IPs of [kind] in [scope] (NET-018, NET-031).
@riverpod
Future<List<PublicIp>> publicIps(Ref ref, Scope scope, IpKind kind) =>
    perProject(
      ref,
      scope,
      (api, projectId) => fetchAllJson(
        (page) => kind == IpKind.floating
            ? cloud.FloatingIPsApi(api)
                  .listFloatingIps(page: page, perPage: maxPerPage)
            : cloud.PrimaryIPsApi(api)
                  .listPrimaryIps(page: page, perPage: maxPerPage),
        _collection(kind),
        (j) => PublicIp.fromJson(kind, j, projectId),
      ),
    );

/// One IP (NET-024, NET-034).
@riverpod
Future<PublicIp> publicIp(
  Ref ref,
  ProjectScope scope,
  IpKind kind,
  int ipId,
) async {
  final api = ref.watch(cloudApiProvider(scope.projectId));
  final body = await cloudJson(
    kind == IpKind.floating
        ? cloud.FloatingIPsApi(api).getFloatingIp(id: ipId)
        : cloud.PrimaryIPsApi(api).getPrimaryIp(id: ipId),
  );
  return PublicIp.fromJson(
    kind,
    json(body[kind == IpKind.floating ? 'floating_ip' : 'primary_ip']),
    scope.projectId,
  );
}

/// Creates an IP in [location] or assigned to [server] (NET-019 to
/// NET-023, NET-032, NET-033). Returns its id and the action, if any.
Future<({int id, int? action})> createIp(
  cloud.Server api,
  IpKind kind, {
  required bool ipv6,
  required String name,
  String? location,
  int? server,
  String description = '',
  Map<String, String> labels = const {},
}) async {
  final type = ipv6 ? 'ipv6' : 'ipv4';
  final body = await cloudJson(
    kind == IpKind.floating
        ? cloud.FloatingIPsApi(api).createFloatingIp(
            body: cloud.FloatingIpsPostBodyBodyModel.fromJson({
              'type': type,
              if (server == null)
                'home_location': location
              else
                'server': server,
              if (name.isNotEmpty) 'name': name,
              if (description.isNotEmpty) 'description': description,
              'labels': labels,
            }),
          )
        : cloud.PrimaryIPsApi(api).createPrimaryIp(
            body: cloud.PrimaryIpsPostBodyBodyModel.fromJson({
              'type': type,
              'name': name,
              if (server == null) ...{
                'location': location,
                'assignee_type': 'unassigned',
              } else ...{
                'assignee_type': 'server',
                'assignee_id': server,
              },
              'labels': labels,
            }),
          ),
  );
  return (
    id:
        json(
              body[kind == IpKind.floating ? 'floating_ip' : 'primary_ip'],
            )['id']!
            as int,
    action: json(body['action'])['id'] as int?,
  );
}

/// Name, labels, a Floating IP's description, a Primary IP's auto delete
/// (NET-028, NET-090, NET-093).
Future<void> updateIp(
  cloud.Server api,
  IpKind kind,
  int id, {
  String? name,
  Map<String, String>? labels,
  String? description,
  bool? autoDelete,
}) => kind == IpKind.floating
    ? unwrap(
        cloud.FloatingIPsApi(api).updateFloatingIp(
          id: id,
          body: cloud.FloatingIpsIdPutBodyBodyModel.fromJson({
            'name': ?name,
            'labels': ?labels,
            // Empty clears it.
            if (description != null)
              'description': description.isEmpty ? null : description,
          }),
        ),
      )
    : unwrap(
        cloud.PrimaryIPsApi(api).updatePrimaryIp(
          id: id,
          body: cloud.PrimaryIpsIdPutBodyBodyModel.fromJson({
            'name': ?name,
            'labels': ?labels,
            'auto_delete': ?autoDelete,
          }),
        ),
      );

/// Deletes an IP (NET-030, NET-038).
Future<void> deleteIp(cloud.Server api, IpKind kind, int id) =>
    kind == IpKind.floating
    ? unwrap(cloud.FloatingIPsApi(api).deleteFloatingIp(id: id))
    : unwrap(cloud.PrimaryIPsApi(api).deletePrimaryIp(id: id));

/// IP actions; each starts one Hetzner action.
sealed class IpChange {
  const new();
}

final class AssignIp extends IpChange {
  const new(this.server);

  final int server;
}

final class UnassignIp extends IpChange {
  const new();
}

final class SetIpDnsPtr extends IpChange {
  const new(this.ip, this.ptr);

  final String ip;

  /// Empty resets to the Hetzner default.
  final String ptr;
}

final class ProtectIp extends IpChange {
  const new({required this.delete});

  final bool delete;
}

/// Starts [change] on IP [id] (NET-025 to NET-027, NET-029, NET-035 to
/// NET-037, NET-094).
Future<int> changeIp(cloud.Server api, IpKind kind, int id, IpChange change) {
  final f = cloud.FloatingIpActionsApi(api);
  final p = cloud.PrimaryIpActionsApi(api);
  final floating = kind == IpKind.floating;
  return cloudAction(switch (change) {
    AssignIp(:final server) when floating => f.assignFloatingIp(
      id: id,
      body: cloud.FloatingIpsIdActionsAssignPostBodyBodyModel.fromJson({
        'server': server,
      }),
    ),
    AssignIp(:final server) => p.assignPrimaryIp(
      id: id,
      body: cloud.PrimaryIpsIdActionsAssignPostBodyBodyModel.fromJson({
        'assignee_type': 'server',
        'assignee_id': server,
      }),
    ),
    UnassignIp() when floating => f.unassignFloatingIp(id: id),
    UnassignIp() => p.unassignPrimaryIp(id: id),
    SetIpDnsPtr(:final ip, :final ptr) when floating =>
      f.changeFloatingIpDnsPtr(
        id: id,
        body: cloud.FloatingIpsIdActionsChangeDnsPtrPostBodyBodyModel.fromJson(
          _ptr(ip, ptr),
        ),
      ),
    SetIpDnsPtr(:final ip, :final ptr) => p.changePrimaryIpDnsPtr(
      id: id,
      body: cloud.PrimaryIpsIdActionsChangeDnsPtrPostBodyBodyModel.fromJson(
        _ptr(ip, ptr),
      ),
    ),
    ProtectIp(:final delete) when floating => f.changeFloatingIpProtection(
      id: id,
      body:
          cloud.FloatingIpsIdActionsChangeProtectionPostBodyBodyModel.fromJson({
            'delete': delete,
          }),
    ),
    ProtectIp(:final delete) => p.changePrimaryIpProtection(
      id: id,
      body: cloud.PrimaryIpsIdActionsChangeProtectionPostBodyBodyModel.fromJson(
        {'delete': delete},
      ),
    ),
  });
}

Json _ptr(String ip, String ptr) => {
  'ip': ip.trim(),
  'dns_ptr': ptr.trim().isEmpty ? null : ptr.trim(),
};
