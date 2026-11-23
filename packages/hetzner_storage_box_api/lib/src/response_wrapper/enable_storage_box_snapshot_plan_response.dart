// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_enable_snapshot_plan_post201_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_enable_snapshot_plan_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_enable_snapshot_plan_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class EnableStorageBoxSnapshotPlanResponse {
  const EnableStorageBoxSnapshotPlanResponse();
}

@_i1.immutable
class EnableStorageBoxSnapshotPlanResponse201
    extends EnableStorageBoxSnapshotPlanResponse {
  const EnableStorageBoxSnapshotPlanResponse201({required this.body});

  final _i2.StorageBoxesIdActionsEnableSnapshotPlanPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnableStorageBoxSnapshotPlanResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class EnableStorageBoxSnapshotPlanResponse4XX
    extends EnableStorageBoxSnapshotPlanResponse {
  const EnableStorageBoxSnapshotPlanResponse4XX({required this.body});

  final _i4.StorageBoxesIdActionsEnableSnapshotPlanPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnableStorageBoxSnapshotPlanResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class EnableStorageBoxSnapshotPlanResponse5XX
    extends EnableStorageBoxSnapshotPlanResponse {
  const EnableStorageBoxSnapshotPlanResponse5XX({required this.body});

  final _i5.StorageBoxesIdActionsEnableSnapshotPlanPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnableStorageBoxSnapshotPlanResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
