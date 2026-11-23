// SPDX-License-Identifier: GPL-3.0-or-later
/// Firewalls: model, providers, operations and the rule checks
/// (NET-001 to NET-017, NET-089, NET-090).
// Generated model names of nested paths exceed 80 characters.
// ignore_for_file: lines_longer_than_80_chars
library;

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/http/pagination.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/network/networks.dart';
import 'package:flutter/foundation.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firewalls.g.dart';

/// Rule protocols; only tcp and udp have ports (NET-007).
const firewallProtocols = ['tcp', 'udp', 'icmp', 'esp', 'gre'];

/// "Any IPv4" and "Any IPv6" (NET-009).
const anyIpv4 = '0.0.0.0/0';
const anyIpv6 = '::/0';

/// One firewall rule. [ips] are the source IPs of an inbound rule and the
/// destination IPs of an outbound one (NET-006).
@immutable
class FirewallRule {
  const new({
    required this.inbound,
    required this.protocol,
    required this.ips,
    this.port,
    this.description,
  });

  factory fromJson(Json r) {
    final inbound = r['direction'] == 'in';
    return FirewallRule(
      inbound: inbound,
      protocol: r['protocol']! as String,
      port: r['port'] as String?,
      ips: [
        ...?(r[inbound ? 'source_ips' : 'destination_ips'] as List?)
            ?.cast<String>(),
      ],
      description: r['description'] as String?,
    );
  }

  final bool inbound;
  final String protocol;
  final String? port;
  final List<String> ips;
  final String? description;

  Json toJson() => {
    'direction': inbound ? 'in' : 'out',
    'protocol': protocol,
    if (hasPort(protocol)) 'port': port,
    inbound ? 'source_ips' : 'destination_ips': ips,
    'description': ?(description?.trim().isEmpty ?? true ? null : description),
  };

  /// Rules are equal by value: a rule of a page snapshot finds itself
  /// among the rules the firewall has now.
  @override
  bool operator ==(Object other) =>
      other is FirewallRule &&
      other.inbound == inbound &&
      other.protocol == protocol &&
      other.port == port &&
      listEquals(other.ips, ips) &&
      other.description == description;

  @override
  int get hashCode =>
      Object.hash(inbound, protocol, port, Object.hashAll(ips), description);
}

/// What a firewall is applied to: a server or a label selector.
typedef FirewallTarget = ({int? server, String? selector});

/// A firewall as Falco shows it.
@immutable
class Firewall {
  const new({
    required this.id,
    required this.projectId,
    required this.name,
    required this.created,
    this.rules = const [],
    this.appliedTo = const [],
    this.labels = const {},
  });

  factory fromJson(Json f, String projectId) => Firewall(
    id: f['id']! as int,
    projectId: projectId,
    name: f['name']! as String,
    created: DateTime.parse(f['created']! as String),
    rules: [for (final r in jsonList(f['rules'])) FirewallRule.fromJson(r)],
    appliedTo: [
      for (final a in jsonList(f['applied_to']))
        (
          server: json(a['server'])['id'] as int?,
          selector: json(a['label_selector'])['selector'] as String?,
        ),
    ],
    labels: json(f['labels']).cast<String, String>(),
  );

  final int id;
  final String projectId;
  final String name;
  final DateTime created;
  final List<FirewallRule> rules;
  final List<FirewallTarget> appliedTo;
  final Map<String, String> labels;

  /// Applied to anything (NET-001).
  bool get active => appliedTo.isNotEmpty;
}

/// All firewalls of [scope] (NET-001).
@riverpod
Future<List<Firewall>> firewalls(Ref ref, Scope scope) => perProject(
  ref,
  scope,
  (api, projectId) => fetchAllJson(
    (page) =>
        cloud.FirewallsApi(api).listFirewalls(page: page, perPage: maxPerPage),
    'firewalls',
    (j) => Firewall.fromJson(j, projectId),
  ),
);

/// One firewall (NET-004, NET-013).
@riverpod
Future<Firewall> firewall(Ref ref, ProjectScope scope, int firewallId) =>
    getFirewall(
      ref.watch(cloudApiProvider(scope.projectId)),
      scope,
      firewallId,
    );

/// One firewall as the server has it now.
Future<Firewall> getFirewall(
  cloud.Server api,
  ProjectScope scope,
  int firewallId,
) async {
  final body = await cloudJson(
    cloud.FirewallsApi(api).getFirewall(id: firewallId),
  );
  return Firewall.fromJson(json(body['firewall']), scope.projectId);
}

Json _target(FirewallTarget t) => t.server != null
    ? {
        'type': 'server',
        'server': {'id': t.server},
      }
    : {
        'type': 'label_selector',
        'label_selector': {'selector': t.selector},
      };

/// Creates a firewall with rules and targets (NET-002); returns its id and
/// the actions applying it.
Future<({int id, List<int> actions})> createFirewall(
  cloud.Server api, {
  required String name,
  List<FirewallRule> rules = const [],
  List<FirewallTarget> applyTo = const [],
  Map<String, String> labels = const {},
}) async {
  final body = await cloudJson(
    cloud.FirewallsApi(api).createFirewall(
      body: cloud.FirewallsPostBodyBodyModel.fromJson({
        'name': name,
        'rules': [for (final r in rules) r.toJson()],
        'apply_to': [for (final t in applyTo) _target(t)],
        'labels': labels,
      }),
    ),
  );
  return (
    id: json(body['firewall'])['id']! as int,
    actions: [for (final a in jsonList(body['actions'])) a['id']! as int],
  );
}

/// Renames or relabels a firewall (NET-016, NET-090).
Future<void> updateFirewall(
  cloud.Server api,
  int id, {
  String? name,
  Map<String, String>? labels,
}) => unwrap(
  cloud.FirewallsApi(api).updateFirewall(
    id: id,
    body: cloud.FirewallsIdPutBodyBodyModel.fromJson({
      'name': ?name,
      'labels': ?labels,
    }),
  ),
);

/// Deletes a firewall (NET-017).
Future<void> deleteFirewall(cloud.Server api, int id) =>
    unwrap(cloud.FirewallsApi(api).deleteFirewall(id: id));

/// Replaces all rules (NET-005, NET-011, NET-012). Returns the actions,
/// one per server the firewall is applied to.
Future<List<int>> setRules(
  cloud.Server api,
  int id,
  List<FirewallRule> rules,
) async {
  final body = await cloudJson(
    cloud.FirewallActionsApi(api).setFirewallRules(
      id: id,
      body: cloud.FirewallsIdActionsSetRulesPostBodyBodyModel.fromJson({
        'rules': [for (final r in rules) r.toJson()],
      }),
    ),
  );
  return [for (final a in jsonList(body['actions'])) a['id']! as int];
}

/// Applies the firewall to [target] (NET-003, NET-014, NET-089) or removes
/// it (NET-015).
Future<List<int>> applyFirewall(
  cloud.Server api,
  int id,
  FirewallTarget target, {
  bool remove = false,
}) async {
  final a = cloud.FirewallActionsApi(api);
  final targets = {
    'apply_to': [_target(target)],
  };
  final body = await cloudJson(
    remove
        ? a.removeFirewallFromResources(
            id: id,
            body:
                cloud
                    .FirewallsIdActionsRemoveFromResourcesPostBodyBodyModel.fromJson(
                  {'remove_from': targets['apply_to']},
                ),
          )
        : a.applyFirewallToResources(
            id: id,
            body:
                cloud
                    .FirewallsIdActionsApplyToResourcesPostBodyBodyModel.fromJson(
                  targets,
                ),
          ),
  );
  return [for (final a in jsonList(body['actions'])) a['id']! as int];
}

/// Whether [protocol] has ports (NET-007).
bool hasPort(String protocol) => protocol == 'tcp' || protocol == 'udp';

/// A port: `any`, one port or a range `8000-9000`, each 1 to 65535
/// (NET-008).
bool validPort(String text) {
  if (text.trim().toLowerCase() == 'any') return true;
  final parts = text.trim().split('-');
  if (parts.length > 2) return false;
  final ports = [for (final p in parts) int.tryParse(p.trim())];
  if (ports.any((p) => p == null || p < 1 || p > 65535)) return false;
  return ports.length == 1 || ports[0]! < ports[1]!;
}

/// IP blocks of a rule: one per line or comma separated.
List<String> splitIps(String text) => [
  for (final p in text.split(RegExp(r'[\s,]+')))
    if (p.isNotEmpty) p,
];

/// At least one block, each an IPv4 or IPv6 CIDR (NET-009).
bool validIps(String text) {
  final ips = splitIps(text);
  return ips.isNotEmpty && ips.every(_validBlock);
}

bool _validBlock(String block) {
  if (parseCidr(block) != null) return true;
  final [ip, prefix, ...rest] = '$block/'.split('/');
  final n = int.tryParse(prefix);
  return rest.length == 1 &&
      rest.single.isEmpty &&
      ip.contains(':') &&
      Uri.tryParse('http://[$ip]/') != null &&
      n != null &&
      n >= 0 &&
      n <= 128;
}
