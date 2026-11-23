// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_action_id_get200_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_action_id_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_action_id_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetStorageBoxActionResponse {
  const GetStorageBoxActionResponse();
}

@_i1.immutable
class GetStorageBoxActionResponse200 extends GetStorageBoxActionResponse {
  const GetStorageBoxActionResponse200({required this.body});

  final _i2.StorageBoxesIdActionsActionIdGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetStorageBoxActionResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetStorageBoxActionResponse4XX extends GetStorageBoxActionResponse {
  const GetStorageBoxActionResponse4XX({required this.body});

  final _i4.StorageBoxesIdActionsActionIdGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetStorageBoxActionResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetStorageBoxActionResponse5XX extends GetStorageBoxActionResponse {
  const GetStorageBoxActionResponse5XX({required this.body});

  final _i5.StorageBoxesIdActionsActionIdGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetStorageBoxActionResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
