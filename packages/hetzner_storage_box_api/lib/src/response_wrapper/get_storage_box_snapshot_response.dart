// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_snapshot_id_get200_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_snapshot_id_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_snapshot_id_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetStorageBoxSnapshotResponse {
  const GetStorageBoxSnapshotResponse();
}

@_i1.immutable
class GetStorageBoxSnapshotResponse200 extends GetStorageBoxSnapshotResponse {
  const GetStorageBoxSnapshotResponse200({required this.body});

  final _i2.StorageBoxesIdSnapshotsSnapshotIdGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetStorageBoxSnapshotResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetStorageBoxSnapshotResponse4XX extends GetStorageBoxSnapshotResponse {
  const GetStorageBoxSnapshotResponse4XX({required this.body});

  final _i4.StorageBoxesIdSnapshotsSnapshotIdGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetStorageBoxSnapshotResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetStorageBoxSnapshotResponse5XX extends GetStorageBoxSnapshotResponse {
  const GetStorageBoxSnapshotResponse5XX({required this.body});

  final _i5.StorageBoxesIdSnapshotsSnapshotIdGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetStorageBoxSnapshotResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
