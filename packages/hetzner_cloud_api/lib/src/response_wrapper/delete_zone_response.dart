// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_delete201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_delete4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_delete5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class DeleteZoneResponse {
  const DeleteZoneResponse();
}

@_i1.immutable
class DeleteZoneResponse201 extends DeleteZoneResponse {
  const DeleteZoneResponse201({required this.body});

  final _i2.ZonesIdOrNameDelete201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteZoneResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeleteZoneResponse4XX extends DeleteZoneResponse {
  const DeleteZoneResponse4XX({required this.body});

  final _i4.ZonesIdOrNameDelete4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteZoneResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeleteZoneResponse5XX extends DeleteZoneResponse {
  const DeleteZoneResponse5XX({required this.body});

  final _i5.ZonesIdOrNameDelete5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteZoneResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
