// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_action_id_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_action_id_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_action_id_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetZoneActionResponse {
  const GetZoneActionResponse();
}

@_i1.immutable
class GetZoneActionResponse200 extends GetZoneActionResponse {
  const GetZoneActionResponse200({required this.body});

  final _i2.ZonesIdOrNameActionsActionIdGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetZoneActionResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetZoneActionResponse4XX extends GetZoneActionResponse {
  const GetZoneActionResponse4XX({required this.body});

  final _i4.ZonesIdOrNameActionsActionIdGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetZoneActionResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetZoneActionResponse5XX extends GetZoneActionResponse {
  const GetZoneActionResponse5XX({required this.body});

  final _i5.ZonesIdOrNameActionsActionIdGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetZoneActionResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
