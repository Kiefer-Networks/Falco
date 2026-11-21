// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_actions_id_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/zones_actions_id_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_actions_id_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetZonesActionResponse {
  const GetZonesActionResponse();
}

@_i1.immutable
class GetZonesActionResponse200 extends GetZonesActionResponse {
  const GetZonesActionResponse200({required this.body});

  final _i2.ZonesActionsIdGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetZonesActionResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetZonesActionResponse4XX extends GetZonesActionResponse {
  const GetZonesActionResponse4XX({required this.body});

  final _i4.ZonesActionsIdGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetZonesActionResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetZonesActionResponse5XX extends GetZonesActionResponse {
  const GetZonesActionResponse5XX({required this.body});

  final _i5.ZonesActionsIdGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetZonesActionResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
