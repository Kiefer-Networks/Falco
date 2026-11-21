// SPDX-License-Identifier: GPL-3.0-or-later
/// Placement groups: model, providers and operations (CMP-065 to
/// CMP-069, CMP-091).
library;

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/http/pagination.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:flutter/foundation.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'placement_groups.g.dart';

/// Placement group types offered by the spec, not a fixed "spread"
/// (CMP-091, BUG-008).
final List<String> placementGroupTypes = [
  for (final t in cloud.PlacementGroupsPostBodyBodyTypeModel.values)
    if (t != cloud.PlacementGroupsPostBodyBodyTypeModel.unknown) t.name,
];

/// A placement group with its member servers.
@immutable
class PlacementGroup {
  const new({
    required this.id,
    required this.projectId,
    required this.name,
    required this.type,
    required this.servers,
    required this.created,
    this.labels = const {},
  });

  factory fromModel(
    cloud.PlacementGroupsGet200BodyPlacementGroupsArrayModel g,
    String p,
  ) => PlacementGroup(
    id: g.id,
    projectId: p,
    name: g.name,
    type: g.$type.name,
    servers: g.servers,
    labels: g.labels,
    created: g.created,
  );

  final int id;
  final String projectId;
  final String name;
  final String type;
  final List<int> servers;
  final Map<String, String> labels;
  final DateTime created;
}

/// All placement groups of [scope] (CMP-065).
@riverpod
Future<List<PlacementGroup>> placementGroups(Ref ref, Scope scope) =>
    perProject(
      ref,
      scope,
      (api, projectId) => fetchAll((page) async {
        final r = await unwrap(
          cloud.PlacementGroupsApi(api)
              .listPlacementGroups(page: page, perPage: maxPerPage),
        );
        if (r is! cloud.ListPlacementGroupsResponse200) throw const Server();
        return (
          items: [
            for (final g in r.body.placementGroups)
              PlacementGroup.fromModel(g, projectId),
          ],
          nextPage: r.body.meta.pagination.nextPage,
        );
      }),
    );

/// One placement group with its servers (CMP-069).
@riverpod
Future<PlacementGroup> placementGroup(
  Ref ref,
  ProjectScope scope,
  int groupId,
) async {
  final api = cloud.PlacementGroupsApi(
    ref.watch(cloudApiProvider(scope.projectId)),
  );
  final r = await unwrap(api.getPlacementGroup(id: groupId));
  if (r is! cloud.GetPlacementGroupResponse200) throw const NotFound();
  return PlacementGroup.fromModel(
    cloud.PlacementGroupsGet200BodyPlacementGroupsArrayModel.fromJson(
      r.body.placementGroup.toJson(),
    ),
    scope.projectId,
  );
}

/// Creates a placement group (CMP-066, CMP-091).
Future<int> createPlacementGroup(
  cloud.Server api, {
  required String name,
  required String type,
  Map<String, String> labels = const {},
}) async {
  final r = await unwrap(
    cloud.PlacementGroupsApi(api).createPlacementGroup(
      body: cloud.PlacementGroupsPostBodyBodyModel.fromJson({
        'name': name,
        'type': type,
        'labels': labels,
      }),
    ),
  );
  if (r is! cloud.CreatePlacementGroupResponse201) throw const Server();
  return r.body.placementGroup.id;
}

/// Renames or relabels a placement group (CMP-067).
Future<void> updatePlacementGroup(
  cloud.Server api,
  int id, {
  String? name,
  Map<String, String>? labels,
}) => unwrap(
  cloud.PlacementGroupsApi(api).updatePlacementGroup(
    id: id,
    body: cloud.PlacementGroupsIdPutBodyBodyModel.fromJson({
      'name': ?name,
      'labels': ?labels,
    }),
  ),
);

/// Deletes a placement group (CMP-068).
Future<void> deletePlacementGroup(cloud.Server api, int id) =>
    unwrap(cloud.PlacementGroupsApi(api).deletePlacementGroup(id: id));
