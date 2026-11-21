// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_snapshot_id_put200_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_snapshot_id_put4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_snapshot_id_put5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class UpdateStorageBoxSnapshotResponse {
  const UpdateStorageBoxSnapshotResponse();
}

@_i1.immutable
class UpdateStorageBoxSnapshotResponse200
    extends UpdateStorageBoxSnapshotResponse {
  const UpdateStorageBoxSnapshotResponse200({required this.body});

  final _i2.StorageBoxesIdSnapshotsSnapshotIdPut200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateStorageBoxSnapshotResponse200 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdateStorageBoxSnapshotResponse4XX
    extends UpdateStorageBoxSnapshotResponse {
  const UpdateStorageBoxSnapshotResponse4XX({required this.body});

  final _i4.StorageBoxesIdSnapshotsSnapshotIdPut4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateStorageBoxSnapshotResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdateStorageBoxSnapshotResponse5XX
    extends UpdateStorageBoxSnapshotResponse {
  const UpdateStorageBoxSnapshotResponse5XX({required this.body});

  final _i5.StorageBoxesIdSnapshotsSnapshotIdPut5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateStorageBoxSnapshotResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
