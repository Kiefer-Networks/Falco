// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_zonefile_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_zonefile_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_zonefile_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetZoneZonefileResponse {
  const GetZoneZonefileResponse();
}

@_i1.immutable
class GetZoneZonefileResponse200 extends GetZoneZonefileResponse {
  const GetZoneZonefileResponse200({required this.body});

  final _i2.ZonesIdOrNameZonefileGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetZoneZonefileResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetZoneZonefileResponse4XX extends GetZoneZonefileResponse {
  const GetZoneZonefileResponse4XX({required this.body});

  final _i4.ZonesIdOrNameZonefileGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetZoneZonefileResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetZoneZonefileResponse5XX extends GetZoneZonefileResponse {
  const GetZoneZonefileResponse5XX({required this.body});

  final _i5.ZonesIdOrNameZonefileGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetZoneZonefileResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
