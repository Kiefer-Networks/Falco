// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_change_type_post201_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_change_type_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_change_type_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ChangeStorageBoxTypeResponse {
  const ChangeStorageBoxTypeResponse();
}

@_i1.immutable
class ChangeStorageBoxTypeResponse201 extends ChangeStorageBoxTypeResponse {
  const ChangeStorageBoxTypeResponse201({required this.body});

  final _i2.StorageBoxesIdActionsChangeTypePost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeStorageBoxTypeResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeStorageBoxTypeResponse4XX extends ChangeStorageBoxTypeResponse {
  const ChangeStorageBoxTypeResponse4XX({required this.body});

  final _i4.StorageBoxesIdActionsChangeTypePost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeStorageBoxTypeResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeStorageBoxTypeResponse5XX extends ChangeStorageBoxTypeResponse {
  const ChangeStorageBoxTypeResponse5XX({required this.body});

  final _i5.StorageBoxesIdActionsChangeTypePost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeStorageBoxTypeResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
