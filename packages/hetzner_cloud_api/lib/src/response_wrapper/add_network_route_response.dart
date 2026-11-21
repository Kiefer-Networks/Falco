// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/networks_id_actions_add_route_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_add_route_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_add_route_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class AddNetworkRouteResponse {
  const AddNetworkRouteResponse();
}

@_i1.immutable
class AddNetworkRouteResponse201 extends AddNetworkRouteResponse {
  const AddNetworkRouteResponse201({required this.body});

  final _i2.NetworksIdActionsAddRoutePost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddNetworkRouteResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class AddNetworkRouteResponse4XX extends AddNetworkRouteResponse {
  const AddNetworkRouteResponse4XX({required this.body});

  final _i4.NetworksIdActionsAddRoutePost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddNetworkRouteResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class AddNetworkRouteResponse5XX extends AddNetworkRouteResponse {
  const AddNetworkRouteResponse5XX({required this.body});

  final _i5.NetworksIdActionsAddRoutePost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddNetworkRouteResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
