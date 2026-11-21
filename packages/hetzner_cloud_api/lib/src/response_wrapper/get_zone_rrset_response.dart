// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetZoneRrsetResponse {
  const GetZoneRrsetResponse();
}

@_i1.immutable
class GetZoneRrsetResponse200 extends GetZoneRrsetResponse {
  const GetZoneRrsetResponse200({required this.body});

  final _i2.ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetZoneRrsetResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetZoneRrsetResponse4XX extends GetZoneRrsetResponse {
  const GetZoneRrsetResponse4XX({required this.body});

  final _i4.ZonesIdOrNameRrsetsRrNameRrTypeGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetZoneRrsetResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetZoneRrsetResponse5XX extends GetZoneRrsetResponse {
  const GetZoneRrsetResponse5XX({required this.body});

  final _i5.ZonesIdOrNameRrsetsRrNameRrTypeGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetZoneRrsetResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
