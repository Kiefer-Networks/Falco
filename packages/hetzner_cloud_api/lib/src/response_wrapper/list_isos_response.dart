// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/isos_get200_body_model.dart' as _i2;
import 'package:hetzner_cloud_api/src/model/isos_get4xx_body_model.dart' as _i4;
import 'package:hetzner_cloud_api/src/model/isos_get5xx_body_model.dart' as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListIsosResponse {
  const ListIsosResponse();
}

@_i1.immutable
class ListIsosResponse200 extends ListIsosResponse {
  const ListIsosResponse200({required this.body});

  final _i2.IsosGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListIsosResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListIsosResponse4XX extends ListIsosResponse {
  const ListIsosResponse4XX({required this.body});

  final _i4.IsosGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListIsosResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListIsosResponse5XX extends ListIsosResponse {
  const ListIsosResponse5XX({required this.body});

  final _i5.IsosGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListIsosResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
