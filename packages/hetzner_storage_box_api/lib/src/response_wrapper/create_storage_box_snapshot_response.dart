// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_post201_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class CreateStorageBoxSnapshotResponse {
  const CreateStorageBoxSnapshotResponse();
}

@_i1.immutable
class CreateStorageBoxSnapshotResponse201
    extends CreateStorageBoxSnapshotResponse {
  const CreateStorageBoxSnapshotResponse201({required this.body});

  final _i2.StorageBoxesIdSnapshotsPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateStorageBoxSnapshotResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateStorageBoxSnapshotResponse4XX
    extends CreateStorageBoxSnapshotResponse {
  const CreateStorageBoxSnapshotResponse4XX({required this.body});

  final _i4.StorageBoxesIdSnapshotsPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateStorageBoxSnapshotResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateStorageBoxSnapshotResponse5XX
    extends CreateStorageBoxSnapshotResponse {
  const CreateStorageBoxSnapshotResponse5XX({required this.body});

  final _i5.StorageBoxesIdSnapshotsPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateStorageBoxSnapshotResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
