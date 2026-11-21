// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_put200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_put4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_put5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class UpdateZoneRrsetResponse {
  const UpdateZoneRrsetResponse();
}

@_i1.immutable
class UpdateZoneRrsetResponse200 extends UpdateZoneRrsetResponse {
  const UpdateZoneRrsetResponse200({required this.body});

  final _i2.ZonesIdOrNameRrsetsRrNameRrTypePut200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateZoneRrsetResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdateZoneRrsetResponse4XX extends UpdateZoneRrsetResponse {
  const UpdateZoneRrsetResponse4XX({required this.body});

  final _i4.ZonesIdOrNameRrsetsRrNameRrTypePut4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateZoneRrsetResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdateZoneRrsetResponse5XX extends UpdateZoneRrsetResponse {
  const UpdateZoneRrsetResponse5XX({required this.body});

  final _i5.ZonesIdOrNameRrsetsRrNameRrTypePut5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateZoneRrsetResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
