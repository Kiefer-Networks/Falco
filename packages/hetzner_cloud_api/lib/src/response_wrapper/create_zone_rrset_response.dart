// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class CreateZoneRrsetResponse {
  const CreateZoneRrsetResponse();
}

@_i1.immutable
class CreateZoneRrsetResponse201 extends CreateZoneRrsetResponse {
  const CreateZoneRrsetResponse201({required this.body});

  final _i2.ZonesIdOrNameRrsetsPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateZoneRrsetResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateZoneRrsetResponse4XX extends CreateZoneRrsetResponse {
  const CreateZoneRrsetResponse4XX({required this.body});

  final _i4.ZonesIdOrNameRrsetsPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateZoneRrsetResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateZoneRrsetResponse5XX extends CreateZoneRrsetResponse {
  const CreateZoneRrsetResponse5XX({required this.body});

  final _i5.ZonesIdOrNameRrsetsPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateZoneRrsetResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
