// SPDX-License-Identifier: GPL-3.0-or-later
/// Cloud images: system images for create and rebuild, own snapshots and
/// backups to manage (CMP-077, CMP-090, CMP-093 to CMP-096).
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

part 'images.g.dart';

/// Kind of an image.
enum ImageKind { system, app, snapshot, backup }

/// An image as Falco shows it.
@immutable
class CloudImage {
  const new({
    required this.id,
    required this.projectId,
    required this.kind,
    required this.description,
    required this.status,
    required this.architecture,
    required this.created,
    this.name,
    this.sizeGb,
    this.diskGb = 0,
    this.source,
    this.deprecated = false,
    this.protectDelete = false,
    this.labels = const {},
  });

  /// Maps a generated image; every image endpoint has this schema.
  factory fromModel(cloud.ImagesGet200BodyImagesArrayModel i, String p) =>
      CloudImage(
        id: i.id,
        projectId: p,
        kind:
            ImageKind.values.where((k) => k.name == i.$type.name).firstOrNull ??
            ImageKind.system,
        name: i.name,
        description: i.description,
        status: switch (i.status) {
          cloud.ImagesGet200BodyImagesArrayStatusModel.available =>
            ResourceStatus.available,
          cloud.ImagesGet200BodyImagesArrayStatusModel.creating =>
            ResourceStatus.initializing,
          _ => ResourceStatus.unavailable,
        },
        architecture: i.architecture.name,
        sizeGb: i.imageSize,
        diskGb: i.diskSize,
        source: i.createdFrom?.name,
        deprecated: i.deprecation != null,
        protectDelete: i.protection.delete,
        labels: i.labels,
        created: i.created,
      );

  final int id;
  final String projectId;
  final ImageKind kind;

  /// Set for system and app images.
  final String? name;
  final String description;

  /// [description], or `#id` when it is empty (a snapshot may have none).
  String get label => description.trim().isEmpty ? '#$id' : description;

  final ResourceStatus status;

  /// `x86` or `arm`.
  final String architecture;

  /// Size of a snapshot or backup in GB.
  final num? sizeGb;
  final num diskGb;

  /// Name of the server it was created from.
  final String? source;
  final bool deprecated;
  final bool protectDelete;
  final Map<String, String> labels;
  final DateTime created;

  /// Own snapshot or backup, managed in the Images list.
  bool get own => kind == ImageKind.snapshot || kind == ImageKind.backup;
}

/// All images of [scope]: system, app, snapshots and backups.
@riverpod
Future<List<CloudImage>> images(Ref ref, Scope scope) => perProject(
  ref,
  scope,
  (api, projectId) => fetchAll((page) async {
    final r = await unwrap(
      cloud.ImagesApi(api).listImages(page: page, perPage: maxPerPage),
    );
    if (r is! cloud.ListImagesResponse200) throw const Server();
    return (
      items: [
        for (final i in r.body.images)
          if (i.deleted == null) CloudImage.fromModel(i, projectId),
      ],
      nextPage: r.body.meta.pagination.nextPage,
    );
  }),
);

/// One image (CMP-093).
@riverpod
Future<CloudImage> image(Ref ref, ProjectScope scope, int imageId) async {
  final api = cloud.ImagesApi(ref.watch(cloudApiProvider(scope.projectId)));
  // Decoded from the raw body like the list: re-encoding the model throws
  // on enum values the spec does not know yet.
  final i = json((await cloudJson(api.getImage(id: imageId)))['image']);
  if (i.isEmpty) throw const NotFound();
  return CloudImage.fromModel(
    cloud.ImagesGet200BodyImagesArrayModel.fromJson(i),
    scope.projectId,
  );
}

/// Changes description and labels of an image; [toSnapshot] converts a
/// backup into a snapshot (CMP-094).
Future<void> updateImage(
  cloud.Server api,
  int id, {
  String? description,
  Map<String, String>? labels,
  bool toSnapshot = false,
}) => unwrap(
  cloud.ImagesApi(api).updateImage(
    id: id,
    body: cloud.ImagesIdPutBodyBodyModel.fromJson({
      'description': ?description,
      'labels': ?labels,
      if (toSnapshot) 'type': 'snapshot',
    }),
  ),
);

/// Deletes an image (CMP-095).
Future<void> deleteImage(cloud.Server api, int id) =>
    unwrap(cloud.ImagesApi(api).deleteImage(id: id));

/// Turns delete protection of image [id] on or off (CMP-096).
Future<int> protectImage(cloud.Server api, int id, {required bool delete}) =>
    actionOf(
      cloud.ImageActionsApi(api).changeImageProtection(
        id: id,
        body: cloud.ImagesIdActionsChangeProtectionPostBodyBodyModel.fromJson({
          'delete': delete,
        }),
      ),
      (r) =>
          r is cloud.ChangeImageProtectionResponse201 ? r.body.action.id : null,
    );
