// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_get200_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListStorageBoxesResponse {
  const ListStorageBoxesResponse();
}

@_i1.immutable
class ListStorageBoxesResponse200 extends ListStorageBoxesResponse {
  const ListStorageBoxesResponse200({required this.body});

  final _i2.StorageBoxesGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListStorageBoxesResponse4XX extends ListStorageBoxesResponse {
  const ListStorageBoxesResponse4XX({required this.body});

  final _i4.StorageBoxesGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxesResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListStorageBoxesResponse5XX extends ListStorageBoxesResponse {
  const ListStorageBoxesResponse5XX({required this.body});

  final _i5.StorageBoxesGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxesResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
