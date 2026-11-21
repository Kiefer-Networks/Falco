// SPDX-License-Identifier: GPL-3.0-or-later
/// Hetzner actions of a project: the activity lists, the action tracker
/// and the one rule which data an ended action or a change refreshes.
library;

import 'package:dio/dio.dart';
import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/actions/action_tracker.dart';
import 'package:falco/core/http/pagination.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/dns/zones.dart';
import 'package:falco/features/images/images.dart';
import 'package:falco/features/network/certificates.dart';
import 'package:falco/features/network/firewalls.dart';
import 'package:falco/features/network/ips.dart';
import 'package:falco/features/network/load_balancers.dart';
import 'package:falco/features/network/networks.dart';
import 'package:falco/features/placement_groups/placement_groups.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/features/ssh_keys/ssh_keys.dart';
import 'package:falco/features/storage/storage_boxes.dart';
import 'package:falco/features/volumes/volumes.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tonik_util/tonik_util.dart';

part 'activity.g.dart';

/// Resource types as the Cloud API names them in `action.resources`.
abstract final class CloudType {
  static const server = 'server';
  static const volume = 'volume';
  static const image = 'image';
  static const placementGroup = 'placement_group';
  static const sshKey = 'ssh_key';
  static const network = 'network';
  static const firewall = 'firewall';
  static const floatingIp = 'floating_ip';
  static const primaryIp = 'primary_ip';
  static const loadBalancer = 'load_balancer';
  static const certificate = 'certificate';
  static const zone = 'zone';
}

/// Reloads what a change of resource [type] [id] touched: its detail and
/// every list of its type (QRS-028), plus the views showing it from the
/// other side (a server's networks, a network's members). [invalidate] is
/// `ref.invalidate` of a provider or a widget.
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
      // Placement group members, volume attachments (both sides), IP
      // assignees, network members and firewall targets follow servers.
      invalidate(placementGroupsProvider);
      invalidate(placementGroupProvider);
      invalidate(publicIpsProvider);
      invalidate(publicIpProvider);
      invalidate(networkMembersProvider);
      invalidate(firewallProvider);
      invalidate(volumesProvider);
      invalidate(volumeProvider);
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
    case CloudType.network:
      invalidate(networkProvider(scope, id));
      invalidate(networksProvider);
      invalidate(networkMembersProvider);
      invalidate(serverProvider);
      invalidate(loadBalancerProvider);
    case CloudType.firewall:
      invalidate(firewallProvider(scope, id));
      invalidate(firewallsProvider);
      invalidate(serverProvider);
    case CloudType.floatingIp || CloudType.primaryIp:
      invalidate(publicIpProvider);
      invalidate(publicIpsProvider);
      invalidate(serverProvider);
      invalidate(serversProvider);
    case CloudType.loadBalancer:
      invalidate(loadBalancerProvider(scope, id));
      invalidate(loadBalancersProvider);
      invalidate(networkMembersProvider);
      invalidate(serverProvider);
    case CloudType.certificate:
      invalidate(certificateProvider(scope, id));
      invalidate(certificatesProvider);
    case CloudType.zone:
      invalidate(zoneProvider(scope, id));
      invalidate(zonesProvider);
      invalidate(rrsetsProvider);
      invalidate(rrsetProvider);
    case storageBoxType:
      invalidate(storageBoxProvider(scope, id));
      invalidate(storageBoxesProvider);
      invalidate(boxSnapshotsProvider(scope, id));
      invalidate(subaccountsProvider(scope, id));
      invalidate(boxActionsProvider(scope, id));
      invalidate(boxFoldersProvider(scope, id));
    // Their box id is not part of the action; reload them all.
    case 'storage_box_snapshot':
      invalidate(boxSnapshotsProvider);
      invalidate(boxSnapshotProvider);
    case 'storage_box_subaccount':
      invalidate(subaccountsProvider);
      invalidate(subaccountProvider);
  }
  invalidate(activityProvider);
}

/// Actions of a project, newest first: every resource type with an
/// action list (SUC-006). With [type] and [id] those of one resource
/// (CMP-045, SUC-011 and the action lists per type). All pages, like
/// every list (BUG-022).
@riverpod
Future<List<ActionProgress>> activity(
  Ref ref,
  ProjectScope scope, {
  String? type,
  int? id,
}) async {
  if (type == storageBoxType && id != null) {
    return await boxActions(ref, scope, id);
  }
  final api = ref.watch(cloudApiProvider(scope.projectId));
  Future<List<ActionProgress>> list(
    Future<TonikResult<Object?, Response<Object?>>> Function(int page) call,
  ) => fetchAllJson(call, 'actions', _action);
  const n = maxPerPage;
  if (id != null) {
    final Future<TonikResult<Object?, Response<Object?>>> Function(int p)?
    call = switch (type) {
      CloudType.server => (p) => cloud.ServerActionsApi(
        api,
      ).listServerActions(id: id, page: p, perPage: n),
      CloudType.volume => (p) => cloud.VolumeActionsApi(
        api,
      ).listVolumeActions(id: id, page: p, perPage: n),
      CloudType.image => (p) => cloud.ImageActionsApi(
        api,
      ).listImageActions(id: id, page: p, perPage: n),
      CloudType.network => (p) => cloud.NetworkActionsApi(
        api,
      ).listNetworkActions(id: id, page: p, perPage: n),
      CloudType.firewall => (p) => cloud.FirewallActionsApi(
        api,
      ).listFirewallActions(id: id, page: p, perPage: n),
      CloudType.floatingIp => (p) => cloud.FloatingIpActionsApi(
        api,
      ).listFloatingIpActions(id: id, page: p, perPage: n),
      CloudType.primaryIp => (p) => cloud.PrimaryIpActionsApi(
        api,
      ).listPrimaryIpActions(id: id, page: p, perPage: n),
      CloudType.loadBalancer => (p) => cloud.LoadBalancerActionsApi(
        api,
      ).listLoadBalancerActions(id: id, page: p, perPage: n),
      CloudType.certificate => (p) => cloud.CertificateActionsApi(
        api,
      ).listCertificateActions(id: id, page: p, perPage: n),
      CloudType.zone => (p) => cloud.ZoneActionsApi(
        api,
      ).listZoneActions(idOrName: '$id', page: p, perPage: n),
      _ => null,
    };
    return call == null ? const [] : _newestFirst(await list(call));
  }
  final lists = await Future.wait([
    list(
      (p) =>
          cloud.ServerActionsApi(api).listServersActions(page: p, perPage: n),
    ),
    list(
      (p) =>
          cloud.VolumeActionsApi(api).listVolumesActions(page: p, perPage: n),
    ),
    list(
      (p) => cloud.ImageActionsApi(api).listImagesActions(page: p, perPage: n),
    ),
    list(
      (p) =>
          cloud.NetworkActionsApi(api).listNetworksActions(page: p, perPage: n),
    ),
    list(
      (p) =>
          cloud.FirewallActionsApi(api)
              .listFirewallsActions(page: p, perPage: n),
    ),
    list(
      (p) =>
          cloud.FloatingIpActionsApi(api)
              .listFloatingIpsActions(page: p, perPage: n),
    ),
    list(
      (p) =>
          cloud.PrimaryIpActionsApi(api)
              .listPrimaryIpsActions(page: p, perPage: n),
    ),
    list(
      (p) =>
          cloud.LoadBalancerActionsApi(api)
              .listLoadBalancersActions(page: p, perPage: n),
    ),
    list(
      (p) =>
          cloud.CertificateActionsApi(api)
              .listCertificatesActions(page: p, perPage: n),
    ),
    list(
      (p) => cloud.ZoneActionsApi(api).listZonesActions(page: p, perPage: n),
    ),
    // Last: Storage Box action ids are their own series, kept apart so
    // equal ids do not hide each other (STB-022).
    allBoxActions(ref.watch(storageBoxApiProvider(scope.projectId))),
  ]);
  final boxes = lists.removeLast();
  // An action touching a server and a volume is listed by both.
  final byId = {
    for (final l in lists)
      for (final a in l) a.id: a,
  };
  return _newestFirst([...byId.values, ...boxes]);
}

List<ActionProgress> _newestFirst(List<ActionProgress> all) => all
  ..sort(
    (a, b) => (b.started ?? DateTime(0)).compareTo(a.started ?? DateTime(0)),
  );

/// Every action list has the schema of `GET /servers/actions`; one mapper.
ActionProgress _action(Json json) {
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
    finished: a.finished,
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

/// Follows the Storage Box actions of one project (api.hetzner.com has
/// its own action ids) and refreshes what they touched (STB-027).
@Riverpod(keepAlive: true)
ActionTracker storageBoxTracker(Ref ref, ProjectScope scope) => ActionTracker(
  (id) =>
      boxActionFetcher(ref.read(storageBoxApiProvider(scope.projectId)))(id),
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
  final tracker = type == storageBoxType
      ? ref.watch(storageBoxTrackerProvider(scope))
      : ref.watch(actionTrackerProvider(scope));
  bool touches(ActionProgress a) => a.resources.contains((type, id));
  yield tracker.running.where(touches).lastOrNull;
  yield* tracker.changes.where(touches);
}
