// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_delete201_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_delete4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_delete5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class DeleteStorageBoxResponse {
  const DeleteStorageBoxResponse();
}

@_i1.immutable
class DeleteStorageBoxResponse201 extends DeleteStorageBoxResponse {
  const DeleteStorageBoxResponse201({required this.body});

  final _i2.StorageBoxesIdDelete201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteStorageBoxResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeleteStorageBoxResponse4XX extends DeleteStorageBoxResponse {
  const DeleteStorageBoxResponse4XX({required this.body});

  final _i4.StorageBoxesIdDelete4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteStorageBoxResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeleteStorageBoxResponse5XX extends DeleteStorageBoxResponse {
  const DeleteStorageBoxResponse5XX({required this.body});

  final _i5.StorageBoxesIdDelete5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteStorageBoxResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
