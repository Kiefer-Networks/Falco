// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_get200_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetStorageBoxResponse {
  const GetStorageBoxResponse();
}

@_i1.immutable
class GetStorageBoxResponse200 extends GetStorageBoxResponse {
  const GetStorageBoxResponse200({required this.body});

  final _i2.StorageBoxesIdGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetStorageBoxResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetStorageBoxResponse4XX extends GetStorageBoxResponse {
  const GetStorageBoxResponse4XX({required this.body});

  final _i4.StorageBoxesIdGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetStorageBoxResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetStorageBoxResponse5XX extends GetStorageBoxResponse {
  const GetStorageBoxResponse5XX({required this.body});

  final _i5.StorageBoxesIdGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetStorageBoxResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
