// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_disable_snapshot_plan_post201_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_disable_snapshot_plan_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_disable_snapshot_plan_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class DisableStorageBoxSnapshotPlanResponse {
  const DisableStorageBoxSnapshotPlanResponse();
}

@_i1.immutable
class DisableStorageBoxSnapshotPlanResponse201
    extends DisableStorageBoxSnapshotPlanResponse {
  const DisableStorageBoxSnapshotPlanResponse201({required this.body});

  final _i2.StorageBoxesIdActionsDisableSnapshotPlanPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableStorageBoxSnapshotPlanResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DisableStorageBoxSnapshotPlanResponse4XX
    extends DisableStorageBoxSnapshotPlanResponse {
  const DisableStorageBoxSnapshotPlanResponse4XX({required this.body});

  final _i4.StorageBoxesIdActionsDisableSnapshotPlanPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableStorageBoxSnapshotPlanResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DisableStorageBoxSnapshotPlanResponse5XX
    extends DisableStorageBoxSnapshotPlanResponse {
  const DisableStorageBoxSnapshotPlanResponse5XX({required this.body});

  final _i5.StorageBoxesIdActionsDisableSnapshotPlanPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableStorageBoxSnapshotPlanResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
