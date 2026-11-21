// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_delete201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_delete4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_delete5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class DeleteZoneRrsetResponse {
  const DeleteZoneRrsetResponse();
}

@_i1.immutable
class DeleteZoneRrsetResponse201 extends DeleteZoneRrsetResponse {
  const DeleteZoneRrsetResponse201({required this.body});

  final _i2.ZonesIdOrNameRrsetsRrNameRrTypeDelete201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteZoneRrsetResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeleteZoneRrsetResponse4XX extends DeleteZoneRrsetResponse {
  const DeleteZoneRrsetResponse4XX({required this.body});

  final _i4.ZonesIdOrNameRrsetsRrNameRrTypeDelete4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteZoneRrsetResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeleteZoneRrsetResponse5XX extends DeleteZoneRrsetResponse {
  const DeleteZoneRrsetResponse5XX({required this.body});

  final _i5.ZonesIdOrNameRrsetsRrNameRrTypeDelete5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteZoneRrsetResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
