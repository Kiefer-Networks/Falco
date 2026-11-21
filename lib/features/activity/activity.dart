// SPDX-License-Identifier: GPL-3.0-or-later
/// Hetzner actions of a project: the activity lists, the action tracker
/// and the one rule which data an ended action or a change refreshes.
library;

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/actions/action_tracker.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/http/pagination.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/images/images.dart';
import 'package:falco/features/placement_groups/placement_groups.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/features/ssh_keys/ssh_keys.dart';
import 'package:falco/features/volumes/volumes.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity.g.dart';

/// Resource types as the Cloud API names them in `action.resources`.
abstract final class CloudType {
  static const server = 'server';
  static const volume = 'volume';
  static const image = 'image';
  static const placementGroup = 'placement_group';
  static const sshKey = 'ssh_key';
}

/// Reloads what a change of resource [type] [id] touched: its detail and
/// every list of its type (QRS-028). Lists of other types stay as they
/// are. [invalidate] is `ref.invalidate` of a provider or a widget.
void refreshResource(
  void Function(ProviderOrFamily provider) invalidate,
  ProjectScope scope,
  String type,
  int id,
) {
  switch (type) {
    case CloudType.server:
      invalidate(serverProvider(scope, id));
      invalidate(serversProvider);
      // Placement group members and volume attachments follow servers.
      invalidate(placementGroupsProvider);
      invalidate(placementGroupProvider);
    case CloudType.volume:
      invalidate(volumeProvider(scope, id));
      invalidate(volumesProvider);
      invalidate(serverProvider);
    case CloudType.image:
      invalidate(imageProvider(scope, id));
      invalidate(imagesProvider);
    case CloudType.placementGroup:
      invalidate(placementGroupProvider(scope, id));
      invalidate(placementGroupsProvider);
    case CloudType.sshKey:
      invalidate(sshKeyProvider(scope, id));
      invalidate(sshKeysProvider);
  }
  invalidate(activityProvider);
}

/// Actions of a project, newest first: servers, volumes and images. With
/// [serverId] those of one server. All pages, like every list (BUG-022).
@riverpod
Future<List<ActionProgress>> activity(
  Ref ref,
  ProjectScope scope,
  int? serverId,
) async {
  final api = ref.watch(cloudApiProvider(scope.projectId));
  if (serverId != null) {
    return await fetchAll((page) async {
      final r = await unwrap(
        cloud.ServerActionsApi(api).listServerActions(
          id: serverId,
          sort: [cloud.ServersIdActionsParametersArrayModel.starteddesc],
          page: page,
          perPage: maxPerPage,
        ),
      );
      if (r is! cloud.ListServerActionsResponse200) throw const Server();
      return (
        items: [for (final a in r.body.actions) _action(a.toJson())],
        nextPage: r.body.meta.pagination.nextPage,
      );
    });
  }
  final lists = await Future.wait([
    fetchAll((page) async {
      final r = await unwrap(
        cloud.ServerActionsApi(api).listServersActions(
          sort: [cloud.ServersActionsParametersArrayModel.starteddesc],
          page: page,
          perPage: maxPerPage,
        ),
      );
      if (r is! cloud.ListServersActionsResponse200) throw const Server();
      return (
        items: [for (final a in r.body.actions) _action(a.toJson())],
        nextPage: r.body.meta.pagination.nextPage,
      );
    }),
    fetchAll((page) async {
      final r = await unwrap(
        cloud.VolumeActionsApi(api)
            .listVolumesActions(page: page, perPage: maxPerPage),
      );
      if (r is! cloud.ListVolumesActionsResponse200) throw const Server();
      return (
        items: [for (final a in r.body.actions) _action(a.toJson())],
        nextPage: r.body.meta.pagination.nextPage,
      );
    }),
    fetchAll((page) async {
      final r = await unwrap(
        cloud.ImageActionsApi(api)
            .listImagesActions(page: page, perPage: maxPerPage),
      );
      if (r is! cloud.ListImagesActionsResponse200) throw const Server();
      return (
        items: [for (final a in r.body.actions) _action(a.toJson())],
        nextPage: r.body.meta.pagination.nextPage,
      );
    }),
  ]);
  // An action touching a server and a volume is listed by both.
  final byId = {
    for (final l in lists)
      for (final a in l) a.id: a,
  };
  final all = byId.values.toList()
    ..sort(
      (a, b) => (b.started ?? DateTime(0)).compareTo(a.started ?? DateTime(0)),
    );
  return all;
}

/// Every action list has the schema of `GET /servers/actions`; one mapper.
ActionProgress _action(Object? json) {
  final a = cloud.ServersActionsGet200BodyActionsArrayModel.fromJson(json);
  return ActionProgress(
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
}

/// Follows the actions of one project and, when one ends, refreshes what
/// it touched (QRS-028).
@Riverpod(keepAlive: true)
ActionTracker actionTracker(Ref ref, ProjectScope scope) => ActionTracker(
  (id) => cloudActionFetcher(
    cloud.ActionsApi(ref.read(cloudApiProvider(scope.projectId))),
  )(id),
  onDone: (action) {
    for (final (type, id) in action.resources) {
      refreshResource(ref.invalidate, scope, type, id);
    }
    ref.invalidate(activityProvider);
  },
);

/// The latest tracked action touching resource [type] [id]: the running
/// one when the page opens, then every update until it ends. Read from
/// the tracker, so progress survives leaving and reopening the page.
@riverpod
Stream<ActionProgress?> trackedAction(
  Ref ref,
  ProjectScope scope,
  String type,
  int id,
) async* {
  final tracker = ref.watch(actionTrackerProvider(scope));
  bool touches(ActionProgress a) => a.resources.contains((type, id));
  yield tracker.running.where(touches).lastOrNull;
  yield* tracker.changes.where(touches);
}
