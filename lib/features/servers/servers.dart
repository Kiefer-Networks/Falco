// SPDX-License-Identifier: GPL-3.0-or-later
/// Cloud servers of a scope: model, data providers, power actions and the
/// action tracker that refreshes them when an action ends.
library;

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/actions/action_tracker.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/http/pagination.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/scope/scope_repository.dart';
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
    this.ipv4,
    this.ipv6,
    this.image,
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
    ipv6: s.publicNet.ipv6?.ip,
    type: s.serverType.name,
    cores: s.serverType.cores.toInt(),
    memoryGb: s.serverType.memory,
    diskGb: s.primaryDiskSize,
    // Location, not datacenter (BUG-011).
    location: s.location.name,
    image: s.image?.description,
    created: s.created,
  );

  final int id;

  /// Local id of the project the server belongs to.
  final String projectId;
  final String name;
  final ResourceStatus status;
  final String? ipv4;
  final String? ipv6;

  /// Server type name, e.g. `cx22`.
  final String type;
  final int cores;
  final num memoryGb;
  final num diskGb;

  /// Location name, e.g. `fsn1`.
  final String location;
  final String? image;
  final DateTime created;

  /// Public IPv4, else IPv6 (CMP-003).
  String? get address => ipv4 ?? ipv6;
}

/// All servers of [scope], every page, every project of the scope (CMP-002).
@riverpod
Future<List<CloudServer>> servers(Ref ref, Scope scope) async {
  final projects = await ref.watch(scopeRepositoryProvider).projectsOf(scope);
  final lists = await Future.wait([
    for (final p in projects)
      _projectServers(
        cloud.ServersApi(ref.watch(cloudApiProvider(p.id))),
        p.id,
      ),
  ]);
  return [for (final l in lists) ...l];
}

Future<List<CloudServer>> _projectServers(
  cloud.ServersApi api,
  String projectId,
) => fetchAll((page) async {
  final r = await unwrap(api.listServers(page: page, perPage: maxPerPage));
  if (r is! cloud.ListServersResponse200) throw const Server();
  return (
    items: [
      for (final s in r.body.body.servers) CloudServer.fromModel(s, projectId),
    ],
    nextPage: r.body.body.meta.pagination.nextPage,
  );
});

/// One server.
@riverpod
Future<CloudServer> server(Ref ref, ProjectScope scope, int serverId) async {
  final api = cloud.ServersApi(ref.watch(cloudApiProvider(scope.projectId)));
  final r = await unwrap(api.getServer(id: serverId));
  final s = r is cloud.GetServerResponse200 ? r.body.server : null;
  if (s == null) throw const NotFound();
  return CloudServer.fromModel(
    cloud.ServersGet200BodyServersArrayModel.fromJson(s.toJson()),
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

/// Actions of [scope], newest first; of one server when [serverId] is set.
/// All pages are loaded like every list (BUG-022).
// ponytail: project activity covers server actions only; the other
// resource types join with their areas (Phase 4 to 8).
@riverpod
Future<List<ActionProgress>> activity(
  Ref ref,
  ProjectScope scope,
  int? serverId,
) {
  final api = cloud.ServerActionsApi(
    ref.watch(cloudApiProvider(scope.projectId)),
  );
  if (serverId != null) {
    return fetchAll((page) async {
      final r = await unwrap(
        api.listServerActions(
          id: serverId,
          sort: [cloud.ServersIdActionsParametersArrayModel.starteddesc],
          page: page,
          perPage: maxPerPage,
        ),
      );
      if (r is! cloud.ListServerActionsResponse200) throw const Server();
      return (
        items: [
          for (final a in r.body.actions)
            // Same schema as the project wide list; one mapper for both.
            _action(
              cloud.ServersActionsGet200BodyActionsArrayModel.fromJson(
                a.toJson(),
              ),
            ),
        ],
        nextPage: r.body.meta.pagination.nextPage,
      );
    });
  }
  return fetchAll((page) async {
    final r = await unwrap(
      api.listServersActions(
        sort: [cloud.ServersActionsParametersArrayModel.starteddesc],
        page: page,
        perPage: maxPerPage,
      ),
    );
    if (r is! cloud.ListServersActionsResponse200) throw const Server();
    return (
      items: [for (final a in r.body.actions) _action(a)],
      nextPage: r.body.meta.pagination.nextPage,
    );
  });
}

ActionProgress _action(cloud.ServersActionsGet200BodyActionsArrayModel a) =>
    ActionProgress(
      id: a.id,
      command: a.command,
      status: switch (a.status) {
        cloud.ServersActionsGet200BodyActionsArrayStatusModel.success =>
          ActionStatus.success,
        cloud.ServersActionsGet200BodyActionsArrayStatusModel.error =>
          ActionStatus.error,
        _ => ActionStatus.running,
      },
      progress: a.progress,
      resources: [for (final r in a.resources) (r.$type, r.id)],
      errorCode: a.error?.code,
      started: a.started,
    );

/// Follows the actions of one project and, when one ends, reloads what it
/// touched: the server, every server list and the activity (QRS-028).
@Riverpod(keepAlive: true)
ActionTracker actionTracker(Ref ref, ProjectScope scope) => ActionTracker(
  (id) => cloudActionFetcher(
    cloud.ActionsApi(ref.read(cloudApiProvider(scope.projectId))),
  )(id),
  onDone: (action) {
    for (final (type, id) in action.resources) {
      if (type == 'server') ref.invalidate(serverProvider(scope, id));
    }
    ref
      ..invalidate(serversProvider)
      ..invalidate(activityProvider);
  },
);

/// The latest tracked action touching server [serverId]: the running one
/// when the page opens, then every update until it ends. Read from the
/// tracker, so the progress survives leaving and reopening the page.
@riverpod
Stream<ActionProgress?> serverAction(
  Ref ref,
  ProjectScope scope,
  int serverId,
) async* {
  final tracker = ref.watch(actionTrackerProvider(scope));
  bool touches(ActionProgress a) => a.resources.contains(('server', serverId));
  yield tracker.running.where(touches).lastOrNull;
  yield* tracker.changes.where(touches);
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
