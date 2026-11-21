// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_rollback_snapshot_post201_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_rollback_snapshot_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_rollback_snapshot_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class RollbackStorageBoxSnapshotResponse {
  const RollbackStorageBoxSnapshotResponse();
}

@_i1.immutable
class RollbackStorageBoxSnapshotResponse201
    extends RollbackStorageBoxSnapshotResponse {
  const RollbackStorageBoxSnapshotResponse201({required this.body});

  final _i2.StorageBoxesIdActionsRollbackSnapshotPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RollbackStorageBoxSnapshotResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class RollbackStorageBoxSnapshotResponse4XX
    extends RollbackStorageBoxSnapshotResponse {
  const RollbackStorageBoxSnapshotResponse4XX({required this.body});

  final _i4.StorageBoxesIdActionsRollbackSnapshotPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RollbackStorageBoxSnapshotResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class RollbackStorageBoxSnapshotResponse5XX
    extends RollbackStorageBoxSnapshotResponse {
  const RollbackStorageBoxSnapshotResponse5XX({required this.body});

  final _i5.StorageBoxesIdActionsRollbackSnapshotPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RollbackStorageBoxSnapshotResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
