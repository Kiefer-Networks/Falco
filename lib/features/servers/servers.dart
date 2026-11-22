// SPDX-License-Identifier: GPL-3.0-or-later
/// Cloud servers of a scope: model, data providers and every server
/// operation (CMP-002 to CMP-049).
library;

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/http/pagination.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'servers.g.dart';

/// A Cloud server as Falco shows it.
@immutable
class CloudServer {
  const new({
    required this.id,
    required this.projectId,
    required this.name,
    required this.status,
    required this.type,
    required this.cores,
    required this.memoryGb,
    required this.diskGb,
    required this.location,
    required this.created,
    this.architecture = 'x86',
    this.ipv4,
    this.ipv4Ptr,
    this.ipv6,
    this.image,
    this.iso,
    this.placementGroup,
    this.backupWindow,
    this.rescue = false,
    this.protectDelete = false,
    this.protectRebuild = false,
    this.labels = const {},
    this.volumes = const [],
    this.networks = const [],
    this.firewalls = const [],
    this.loadBalancers = const [],
  });

  /// Maps a generated server; `GET /servers/{id}` has the same schema.
  factory fromModel(
    cloud.ServersGet200BodyServersArrayModel s,
    String projectId,
  ) => CloudServer(
    id: s.id,
    projectId: projectId,
    name: s.name,
    status: switch (s.status) {
      cloud.ServersGet200BodyServersArrayStatusModel.running =>
        ResourceStatus.running,
      cloud.ServersGet200BodyServersArrayStatusModel.off => ResourceStatus.off,
      cloud.ServersGet200BodyServersArrayStatusModel.starting =>
        ResourceStatus.starting,
      cloud.ServersGet200BodyServersArrayStatusModel.stopping =>
        ResourceStatus.stopping,
      cloud.ServersGet200BodyServersArrayStatusModel.initializing =>
        ResourceStatus.initializing,
      cloud.ServersGet200BodyServersArrayStatusModel.rebuilding =>
        ResourceStatus.rebuilding,
      cloud.ServersGet200BodyServersArrayStatusModel.migrating =>
        ResourceStatus.migrating,
      cloud.ServersGet200BodyServersArrayStatusModel.deleting =>
        ResourceStatus.deleting,
      _ => ResourceStatus.unknown,
    },
    ipv4: s.publicNet.ipv4?.ip,
    ipv4Ptr: s.publicNet.ipv4?.dnsPtr,
    ipv6: s.publicNet.ipv6?.ip,
    type: s.serverType.name,
    cores: s.serverType.cores.toInt(),
    memoryGb: s.serverType.memory,
    diskGb: s.primaryDiskSize,
    architecture: s.serverType.architecture.name,
    // Location, not datacenter (BUG-011).
    location: s.location.name,
    image: s.image?.description,
    // The server carries the ISO; no extra call (CMP-037).
    iso: s.iso == null ? null : (s.iso!.name ?? s.iso!.description),
    placementGroup: s.placementGroup == null
        ? null
        : (id: s.placementGroup!.id, name: s.placementGroup!.name),
    backupWindow: s.backupWindow,
    rescue: s.rescueEnabled,
    protectDelete: s.protection.delete,
    protectRebuild: s.protection.rebuild,
    labels: s.labels,
    volumes: s.volumes ?? const [],
    networks: [
      for (final n in s.privateNet)
        if (n.network case final id?)
          (id: id, ip: n.ip ?? '', aliasIps: n.aliasIps ?? const []),
    ],
    firewalls: [
      for (final f in s.publicNet.firewalls ?? const <Never>[]) ?f.id,
    ],
    loadBalancers: s.loadBalancers ?? const [],
    created: s.created,
  );

  final int id;

  /// Local id of the project the server belongs to.
  final String projectId;
  final String name;
  final ResourceStatus status;
  final String? ipv4;

  /// Reverse DNS of [ipv4].
  final String? ipv4Ptr;
  final String? ipv6;

  /// Server type name, e.g. `cx22`.
  final String type;
  final int cores;
  final num memoryGb;
  final num diskGb;

  /// `x86` or `arm`, picks matching images and ISOs.
  final String architecture;

  /// Location name, e.g. `fsn1`.
  final String location;
  final String? image;

  /// Name of the inserted ISO.
  final String? iso;
  final ({int id, String name})? placementGroup;

  /// Set while backups are enabled.
  final String? backupWindow;
  final bool rescue;
  final bool protectDelete;
  final bool protectRebuild;
  final Map<String, String> labels;
  final List<int> volumes;

  /// Private networks with the server's IP and alias IPs in each.
  final List<({int id, String ip, List<String> aliasIps})> networks;
  final List<int> firewalls;
  final List<int> loadBalancers;
  final DateTime created;

  /// Public IPv4, else IPv6 (CMP-003).
  String? get address => ipv4 ?? ipv6;
}

/// All servers of [scope], every page, every project of the scope (CMP-002).
@riverpod
Future<List<CloudServer>> servers(Ref ref, Scope scope) => perProject(
  ref,
  scope,
  (api, projectId) => fetchAll((page) async {
    final r = await unwrap(
      cloud.ServersApi(api).listServers(page: page, perPage: maxPerPage),
    );
    if (r is! cloud.ListServersResponse200) throw const Server();
    return (
      items: [
        for (final s in r.body.body.servers)
          CloudServer.fromModel(s, projectId),
      ],
      nextPage: r.body.body.meta.pagination.nextPage,
    );
  }),
);

/// One server.
@riverpod
Future<CloudServer> server(Ref ref, ProjectScope scope, int serverId) async {
  final api = cloud.ServersApi(ref.watch(cloudApiProvider(scope.projectId)));
  // Decoded from the raw body like the list: re-encoding the model throws
  // on enum values the spec does not know yet.
  final s = json((await cloudJson(api.getServer(id: serverId)))['server']);
  if (s.isEmpty) throw const NotFound();
  return CloudServer.fromModel(
    cloud.ServersGet200BodyServersArrayModel.fromJson(s),
    scope.projectId,
  );
}

/// Metric families of `GET /servers/{id}/metrics`, with the series keys
/// each chart shows.
enum ServerMetric {
  cpu(cloud.ServersIdMetricsParametersArrayModel.cpu, ['cpu']),
  disk(cloud.ServersIdMetricsParametersArrayModel.disk, [
    'disk.0.bandwidth.read',
    'disk.0.bandwidth.write',
  ]),
  network(cloud.ServersIdMetricsParametersArrayModel.network, [
    'network.0.bandwidth.in',
    'network.0.bandwidth.out',
  ]);

  new(this.param, this.keys);

  final cloud.ServersIdMetricsParametersArrayModel param;
  final List<String> keys;
}

/// Samples of [metric] over [period], one list per [ServerMetric.keys]
/// entry. One request per metric keeps the `type` parameter unambiguous.
@riverpod
Future<List<List<(DateTime, double)>>> serverMetrics(
  Ref ref,
  ProjectScope scope,
  int serverId,
  ServerMetric metric,
  MetricPeriod period,
) async {
  final end = DateTime.now().toUtc();
  final api = cloud.ServersApi(ref.watch(cloudApiProvider(scope.projectId)));
  final r = await unwrap(
    api.getServerMetrics(
      id: serverId,
      $type: [metric.param],
      start: end.subtract(period.duration).toIso8601String(),
      end: end.toIso8601String(),
      // About 120 samples per chart.
      step: '${period.duration.inSeconds ~/ 120}',
    ),
  );
  if (r is! cloud.GetServerMetricsResponse200) throw const Server();
  final series = r.body.metrics.timeSeries;
  return [
    for (final key in metric.keys)
      [
        for (final v in series[key]?.values ?? const <List<Object?>>[])
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
}

/// Power actions of a server (CMP-020 to CMP-024).
enum ServerPower { reboot, shutdown, powerOff, powerOn, reset }

/// Starts [power] on server [serverId] and returns the action id.
Future<int> startPower(
  cloud.Server api,
  int serverId,
  ServerPower power,
) async {
  final a = cloud.ServerActionsApi(api);
  final id = switch (power) {
    ServerPower.reboot => switch (await unwrap(a.rebootServer(id: serverId))) {
      cloud.RebootServerResponse201(:final body) => body.action.id,
      _ => null,
    },
    ServerPower.shutdown => switch (await unwrap(
      a.shutdownServer(id: serverId),
    )) {
      cloud.ShutdownServerResponse201(:final body) => body.action.id,
      _ => null,
    },
    ServerPower.powerOff => switch (await unwrap(
      a.poweroffServer(id: serverId),
    )) {
      cloud.PoweroffServerResponse201(:final body) => body.action.id,
      _ => null,
    },
    ServerPower.powerOn => switch (await unwrap(
      a.poweronServer(id: serverId),
    )) {
      cloud.PoweronServerResponse201(:final body) => body.action.id,
      _ => null,
    },
    ServerPower.reset => switch (await unwrap(a.resetServer(id: serverId))) {
      cloud.ResetServerResponse201(:final body) => body.action.id,
      _ => null,
    },
  };
  return id ?? (throw const Server());
}

/// Everything to create a server (CMP-008, CMP-012, CMP-081 to CMP-086).
@immutable
class ServerDraft {
  const new({
    required this.name,
    required this.location,
    required this.type,
    required this.image,
    this.sshKeys = const [],
    this.networks = const [],
    this.firewalls = const [],
    this.volumes = const [],
    this.automount = false,
    this.placementGroup,
    this.ipv4 = true,
    this.ipv6 = true,
    this.ipv4Id,
    this.ipv6Id,
    this.userData = '',
    this.labels = const {},
    this.startAfterCreate = true,
  });

  final String name;
  final String location;
  final String type;

  /// Image id or name.
  final String image;
  final List<int> sshKeys;
  final List<int> networks;
  final List<int> firewalls;
  final List<int> volumes;
  final bool automount;
  final int? placementGroup;
  final bool ipv4;
  final bool ipv6;

  /// Existing Primary IPs to use instead of new ones (CMP-085).
  final int? ipv4Id;
  final int? ipv6Id;
  final String userData;
  final Map<String, String> labels;
  final bool startAfterCreate;
}

/// Creates a server; the root password comes back when no SSH key was
/// given (CMP-013, CMP-014). The actions are the create action and the
/// next actions (start, attach networks), all to be tracked.
Future<({int id, List<int> actions, String? rootPassword})> createServer(
  cloud.Server api,
  ServerDraft d,
) async {
  final r = await unwrap(
    cloud.ServersApi(api).createServer(
      body: cloud.ServersPostBodyBodyModel.fromJson({
        'name': d.name,
        'location': d.location,
        'server_type': d.type,
        'image': d.image,
        'start_after_create': d.startAfterCreate,
        'ssh_keys': [for (final k in d.sshKeys) '$k'],
        'networks': d.networks,
        'firewalls': [
          for (final f in d.firewalls) {'firewall': f},
        ],
        'volumes': d.volumes,
        if (d.volumes.isNotEmpty) 'automount': d.automount,
        'placement_group': ?d.placementGroup,
        'public_net': {
          'enable_ipv4': d.ipv4,
          'enable_ipv6': d.ipv6,
          if (d.ipv4) 'ipv4': ?d.ipv4Id,
          if (d.ipv6) 'ipv6': ?d.ipv6Id,
        },
        if (d.userData.trim().isNotEmpty) 'user_data': d.userData,
        'labels': d.labels,
      }),
    ),
  );
  if (r is! cloud.CreateServerResponse201) throw const Server();
  return (
    id: r.body.server.id,
    actions: [r.body.action.id, for (final a in r.body.nextActions) a.id],
    rootPassword: r.body.rootPassword,
  );
}

/// Renames or relabels a server (CMP-047, CMP-087).
Future<void> updateServer(
  cloud.Server api,
  int id, {
  String? name,
  Map<String, String>? labels,
}) => unwrap(
  cloud.ServersApi(api).updateServer(
    id: id,
    body: cloud.ServersIdPutBodyBodyModel.fromJson({
      'name': ?name,
      'labels': ?labels,
    }),
  ),
);

/// Deletes a server (CMP-048).
Future<int> deleteServer(cloud.Server api, int id) => actionOf(
  cloud.ServersApi(api).deleteServer(id: id),
  (r) => r is cloud.DeleteServerResponse200 ? r.body.action?.id : null,
);

/// An action that may return a one time root password: rebuild
/// (CMP-031, CMP-032), rescue (CMP-039) and password reset (CMP-030).
typedef PasswordAction = ({int action, String? password});

/// Rebuilds server [id] from [image] (id or name).
Future<PasswordAction> rebuildServer(
  cloud.Server api,
  int id,
  String image,
) async {
  final r = await unwrap(
    cloud.ServerActionsApi(api).rebuildServer(
      id: id,
      body: cloud.ServersIdActionsRebuildPostBodyBodyModel.fromJson({
        'image': image,
      }),
    ),
  );
  if (r case cloud.RebuildServerResponse201(:final body)) {
    if (body.action case final a?) {
      return (action: a.id, password: body.rootPassword);
    }
  }
  throw const Server();
}

/// Enables rescue mode with [sshKeys] (CMP-039).
Future<PasswordAction> enableRescue(
  cloud.Server api,
  int id, [
  List<int> sshKeys = const [],
]) async {
  final r = await unwrap(
    cloud.ServerActionsApi(api).enableServerRescue(
      id: id,
      body: cloud.ServersIdActionsEnableRescuePostBodyBodyModel.fromJson({
        'ssh_keys': sshKeys,
      }),
    ),
  );
  if (r case cloud.EnableServerRescueResponse201(:final body)) {
    if (body.action case final a?) {
      return (action: a.id, password: body.rootPassword);
    }
  }
  throw const Server();
}

/// Resets the root password (CMP-030).
Future<PasswordAction> resetPassword(cloud.Server api, int id) async {
  final r = await unwrap(
    cloud.ServerActionsApi(api).resetServerPassword(id: id),
  );
  if (r case cloud.ResetServerPasswordResponse201(:final body)) {
    if (body.action case final a?) {
      return (action: a.id, password: body.rootPassword);
    }
  }
  throw const Server();
}

/// Requests a VNC console: websocket URL and password, valid about a
/// minute (CMP-026).
Future<({String url, String password})> requestConsole(
  cloud.Server api,
  int id,
) async {
  final r = await unwrap(
    cloud.ServerActionsApi(api).requestServerConsole(id: id),
  );
  if (r is! cloud.RequestServerConsoleResponse201) throw const Server();
  return (url: r.body.wssUrl, password: r.body.password);
}

/// Server actions that need at most a value or a flag. Each starts one
/// Hetzner action.
sealed class ServerChange {
  const new();
}

final class DisableRescue extends ServerChange {
  const new();
}

final class AttachIso extends ServerChange {
  const new(this.iso);

  final String iso;
}

final class DetachIso extends ServerChange {
  const new();
}

final class ChangeType extends ServerChange {
  const new(this.type, {required this.upgradeDisk});

  final String type;
  final bool upgradeDisk;
}

final class SetBackups extends ServerChange {
  const new({required this.enabled});

  final bool enabled;
}

/// Delete and rebuild protection together; the API takes only equal
/// values (CMP-046).
final class SetServerProtection extends ServerChange {
  const new(this.protect);

  final bool protect;
}

final class CreateSnapshot extends ServerChange {
  const new(this.description, this.labels);

  final String description;
  final Map<String, String> labels;
}

final class AddToPlacementGroup extends ServerChange {
  const new(this.group);

  final int group;
}

final class RemoveFromPlacementGroup extends ServerChange {
  const new();
}

/// Attaches the server to a network, with an IP or the next free one
/// (CMP-040).
final class AttachToNetwork extends ServerChange {
  const new(this.network, {this.ip = '', this.aliasIps = const []});

  final int network;
  final String ip;
  final List<String> aliasIps;
}

/// Removes the server from a network (CMP-041).
final class DetachFromNetwork extends ServerChange {
  const new(this.network);

  final int network;
}

/// Replaces the alias IPs in a network (NET-086).
final class ChangeAliasIps extends ServerChange {
  const new(this.network, this.aliasIps);

  final int network;
  final List<String> aliasIps;
}

final class ChangeDnsPtr extends ServerChange {
  const new(this.ip, this.ptr);

  final String ip;

  /// Empty resets to the Hetzner default (CMP-042).
  final String ptr;
}

/// Starts [change] on server [id] and returns the action id
/// (CMP-025, CMP-033 to CMP-046, CMP-089, NET-086).
Future<int> changeServer(cloud.Server api, int id, ServerChange change) {
  final a = cloud.ServerActionsApi(api);
  return switch (change) {
    DisableRescue() => actionOf(
      a.disableServerRescue(id: id),
      (r) =>
          r is cloud.DisableServerRescueResponse201 ? r.body.action.id : null,
    ),
    AttachIso(:final iso) => actionOf(
      a.attachServerIso(
        id: id,
        body: cloud.ServersIdActionsAttachIsoPostBodyBodyModel.fromJson({
          'iso': iso,
        }),
      ),
      (r) => r is cloud.AttachServerIsoResponse201 ? r.body.action.id : null,
    ),
    DetachIso() => actionOf(
      a.detachServerIso(id: id),
      (r) => r is cloud.DetachServerIsoResponse201 ? r.body.action.id : null,
    ),
    ChangeType(:final type, :final upgradeDisk) => actionOf(
      a.changeServerType(
        id: id,
        body: cloud.ServersIdActionsChangeTypePostBodyBodyModel.fromJson({
          'server_type': type,
          'upgrade_disk': upgradeDisk,
        }),
      ),
      (r) => r is cloud.ChangeServerTypeResponse201 ? r.body.action.id : null,
    ),
    SetBackups(enabled: true) => actionOf(
      a.enableServerBackup(id: id),
      (r) => r is cloud.EnableServerBackupResponse201 ? r.body.action.id : null,
    ),
    SetBackups() => actionOf(
      a.disableServerBackup(id: id),
      (r) =>
          r is cloud.DisableServerBackupResponse201 ? r.body.action.id : null,
    ),
    SetServerProtection(:final protect) => actionOf(
      a.changeServerProtection(
        id: id,
        body: cloud.ServersIdActionsChangeProtectionPostBodyBodyModel.fromJson({
          'delete': protect,
          'rebuild': protect,
        }),
      ),
      (r) => r is cloud.ChangeServerProtectionResponse201
          ? r.body.action.id
          : null,
    ),
    CreateSnapshot(:final description, :final labels) => actionOf(
      a.createServerImage(
        id: id,
        body: cloud.ServersIdActionsCreateImagePostBodyBodyModel.fromJson({
          'type': 'snapshot',
          // An empty description makes an image without a name.
          if (description.isNotEmpty) 'description': description,
          'labels': labels,
        }),
      ),
      (r) => r is cloud.CreateServerImageResponse201 ? r.body.action?.id : null,
    ),
    AddToPlacementGroup(:final group) => actionOf(
      a.addServerToPlacementGroup(
        id: id,
        body:
            cloud.ServersIdActionsAddToPlacementGroupPostBodyBodyModel.fromJson(
              {'placement_group': group},
            ),
      ),
      (r) => r is cloud.AddServerToPlacementGroupResponse201
          ? r.body.action.id
          : null,
    ),
    RemoveFromPlacementGroup() => actionOf(
      a.removeServerFromPlacementGroup(id: id),
      (r) => r is cloud.RemoveServerFromPlacementGroupResponse201
          ? r.body.action.id
          : null,
    ),
    AttachToNetwork(:final network, :final ip, :final aliasIps) => cloudAction(
      a.attachServerToNetwork(
        id: id,
        body: cloud.ServersIdActionsAttachToNetworkPostBodyBodyModel.fromJson({
          'network': network,
          if (ip.trim().isNotEmpty) 'ip': ip.trim(),
          if (aliasIps.isNotEmpty) 'alias_ips': aliasIps,
        }),
      ),
    ),
    DetachFromNetwork(:final network) => cloudAction(
      a.detachServerFromNetwork(
        id: id,
        body: cloud.ServersIdActionsDetachFromNetworkPostBodyBodyModel.fromJson(
          {'network': network},
        ),
      ),
    ),
    ChangeAliasIps(:final network, :final aliasIps) => cloudAction(
      a.changeServerAliasIps(
        id: id,
        body: cloud.ServersIdActionsChangeAliasIpsPostBodyBodyModel.fromJson({
          'network': network,
          'alias_ips': aliasIps,
        }),
      ),
    ),
    ChangeDnsPtr(:final ip, :final ptr) => actionOf(
      a.changeServerDnsPtr(
        id: id,
        body: cloud.ServersIdActionsChangeDnsPtrPostBodyBodyModel.fromJson({
          'ip': ip,
          'dns_ptr': ptr.trim().isEmpty ? null : ptr.trim(),
        }),
      ),
      (r) => r is cloud.ChangeServerDnsPtrResponse201 ? r.body.action.id : null,
    ),
  };
}
