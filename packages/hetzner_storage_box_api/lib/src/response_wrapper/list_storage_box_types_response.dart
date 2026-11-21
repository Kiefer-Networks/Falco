// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_box_types_get200_body_model.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/model/storage_box_types_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_box_types_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListStorageBoxTypesResponse {
  const ListStorageBoxTypesResponse();
}

@_i1.immutable
class ListStorageBoxTypesResponse200 extends ListStorageBoxTypesResponse {
  const ListStorageBoxTypesResponse200({required this.body});

  final _i2.StorageBoxTypesGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxTypesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListStorageBoxTypesResponse4XX extends ListStorageBoxTypesResponse {
  const ListStorageBoxTypesResponse4XX({required this.body});

  final _i4.StorageBoxTypesGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxTypesResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListStorageBoxTypesResponse5XX extends ListStorageBoxTypesResponse {
  const ListStorageBoxTypesResponse5XX({required this.body});

  final _i5.StorageBoxTypesGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListStorageBoxTypesResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
