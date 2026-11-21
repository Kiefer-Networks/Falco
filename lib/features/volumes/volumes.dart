// SPDX-License-Identifier: GPL-3.0-or-later
/// Cloud volumes: model, providers and operations (CMP-050 to CMP-064,
/// CMP-088).
library;

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/http/pagination.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/compute/catalog.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'volumes.g.dart';

/// Smallest and largest volume in GB (CMP-052).
const minVolumeGb = 10;
const maxVolumeGb = 10240;

/// Size presets of the create wizard in GB (CMP-052).
const volumePresets = [10, 50, 100, 250, 500, 1024, 2048, 5120, 10240];

/// File systems a new volume can be formatted with; empty means none
/// (CMP-053).
const volumeFormats = ['', 'ext4', 'xfs'];

/// A volume as Falco shows it.
@immutable
class Volume {
  const new({
    required this.id,
    required this.projectId,
    required this.name,
    required this.sizeGb,
    required this.location,
    required this.status,
    required this.created,
    this.server,
    this.format,
    this.device = '',
    this.protectDelete = false,
    this.labels = const {},
  });

  /// Maps a generated volume; every volume endpoint has this schema.
  factory fromModel(cloud.VolumesGet200BodyVolumesArrayModel v, String p) =>
      Volume(
        id: v.id,
        projectId: p,
        name: v.name,
        sizeGb: v.size.toInt(),
        location: v.location.name,
        status:
            v.status == cloud.VolumesGet200BodyVolumesArrayStatusModel.creating
            ? ResourceStatus.initializing
            : ResourceStatus.available,
        server: v.assignee?.id,
        format: v.format,
        device: v.linuxDevice,
        protectDelete: v.protection.delete,
        labels: v.labels,
        created: v.created,
      );

  final int id;
  final String projectId;
  final String name;
  final int sizeGb;
  final String location;

  final ResourceStatus status;

  /// Attached server id.
  final int? server;
  final String? format;
  final String device;
  final bool protectDelete;
  final Map<String, String> labels;
  final DateTime created;
}

/// All volumes of [scope] (CMP-050).
@riverpod
Future<List<Volume>> volumes(Ref ref, Scope scope) => perProject(
  ref,
  scope,
  (api, projectId) => fetchAll((page) async {
    final r = await unwrap(
      cloud.VolumesApi(api).listVolumes(page: page, perPage: maxPerPage),
    );
    if (r is! cloud.ListVolumesResponse200) throw const Server();
    return (
      items: [for (final v in r.body.volumes) Volume.fromModel(v, projectId)],
      nextPage: r.body.meta.pagination.nextPage,
    );
  }),
);

/// One volume (CMP-057, CMP-058).
@riverpod
Future<Volume> volume(Ref ref, ProjectScope scope, int volumeId) async {
  final api = cloud.VolumesApi(ref.watch(cloudApiProvider(scope.projectId)));
  // Decoded from the raw body like the list: re-encoding the model throws
  // on enum values the spec does not know yet.
  final v = json((await cloudJson(api.getVolume(id: volumeId)))['volume']);
  if (v.isEmpty) throw const NotFound();
  return Volume.fromModel(
    cloud.VolumesGet200BodyVolumesArrayModel.fromJson(v),
    scope.projectId,
  );
}

/// Monthly price of [sizeGb] (CMP-055).
({num gross, num net}) volumePrice(int sizeGb, Pricing p) =>
    (gross: p.volumeGross * sizeGb, net: p.volumeNet * sizeGb);

/// Creates a volume in [location] or next to [server] (CMP-051 to
/// CMP-056). Returns the create action and the next actions (attach),
/// all to be tracked.
Future<List<int>> createVolume(
  cloud.Server api, {
  required String name,
  required int sizeGb,
  String? location,
  int? server,
  String format = '',
  bool automount = false,
  Map<String, String> labels = const {},
}) async {
  final r = await unwrap(
    cloud.VolumesApi(api).createVolume(
      body: cloud.VolumesPostBodyBodyModel.fromJson({
        'name': name,
        'size': sizeGb,
        if (server == null)
          'location': location
        else
          'assignee': {'id': server, 'type': 'server'},
        if (server != null) 'automount': automount,
        if (format.isNotEmpty) 'format': format,
        'labels': labels,
      }),
    ),
  );
  if (r is! cloud.CreateVolumeResponse201) throw const Server();
  return [r.body.action.id, for (final a in r.body.nextActions) a.id];
}

/// Renames or relabels a volume (CMP-062, CMP-088).
Future<void> updateVolume(
  cloud.Server api,
  int id, {
  String? name,
  Map<String, String>? labels,
}) => unwrap(
  cloud.VolumesApi(api).updateVolume(
    id: id,
    body: cloud.VolumesIdPutBodyBodyModel.fromJson({
      'name': ?name,
      'labels': ?labels,
    }),
  ),
);

/// Deletes a volume (CMP-064).
Future<void> deleteVolume(cloud.Server api, int id) =>
    unwrap(cloud.VolumesApi(api).deleteVolume(id: id));

/// Attaches volume [id] to [server] (CMP-059).
Future<int> attachVolume(
  cloud.Server api,
  int id,
  int server, {
  bool automount = false,
}) => actionOf(
  cloud.VolumeActionsApi(api).attachVolume(
    id: id,
    body: cloud.VolumesIdActionsAttachPostBodyBodyModel.fromJson({
      'assignee': {'id': server, 'type': 'server'},
      'automount': automount,
    }),
  ),
  (r) => r is cloud.AttachVolumeResponse201 ? r.body.action.id : null,
);

/// Detaches volume [id] (CMP-060).
Future<int> detachVolume(cloud.Server api, int id) => actionOf(
  cloud.VolumeActionsApi(api).detachVolume(id: id),
  (r) => r is cloud.DetachVolumeResponse201 ? r.body.action.id : null,
);

/// Grows volume [id] to [sizeGb]; shrinking is impossible (CMP-061).
Future<int> resizeVolume(cloud.Server api, int id, int sizeGb) => actionOf(
  cloud.VolumeActionsApi(api).resizeVolume(
    id: id,
    body: cloud.VolumesIdActionsResizePostBodyBodyModel.fromJson({
      'size': sizeGb,
    }),
  ),
  (r) => r is cloud.ResizeVolumeResponse201 ? r.body.action.id : null,
);

/// Turns delete protection of volume [id] on or off (CMP-063).
Future<int> protectVolume(cloud.Server api, int id, {required bool delete}) =>
    actionOf(
      cloud.VolumeActionsApi(api).changeVolumeProtection(
        id: id,
        body: cloud.VolumesIdActionsChangeProtectionPostBodyBodyModel.fromJson({
          'delete': delete,
        }),
      ),
      (r) => r is cloud.ChangeVolumeProtectionResponse201
          ? r.body.action.id
          : null,
    );
