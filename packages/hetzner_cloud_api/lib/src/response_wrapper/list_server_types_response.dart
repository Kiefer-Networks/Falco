// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/server_types_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/server_types_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/server_types_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListServerTypesResponse {
  const ListServerTypesResponse();
}

@_i1.immutable
class ListServerTypesResponse200 extends ListServerTypesResponse {
  const ListServerTypesResponse200({required this.body});

  final _i2.ServerTypesGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListServerTypesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListServerTypesResponse4XX extends ListServerTypesResponse {
  const ListServerTypesResponse4XX({required this.body});

  final _i4.ServerTypesGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListServerTypesResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListServerTypesResponse5XX extends ListServerTypesResponse {
  const ListServerTypesResponse5XX({required this.body});

  final _i5.ServerTypesGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListServerTypesResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
