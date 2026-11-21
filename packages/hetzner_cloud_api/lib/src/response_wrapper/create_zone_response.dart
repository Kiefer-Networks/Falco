// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/zones_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class CreateZoneResponse {
  const CreateZoneResponse();
}

@_i1.immutable
class CreateZoneResponse201 extends CreateZoneResponse {
  const CreateZoneResponse201({required this.body});

  final _i2.ZonesPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateZoneResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateZoneResponse4XX extends CreateZoneResponse {
  const CreateZoneResponse4XX({required this.body});

  final _i4.ZonesPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateZoneResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateZoneResponse5XX extends CreateZoneResponse {
  const CreateZoneResponse5XX({required this.body});

  final _i5.ZonesPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateZoneResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
