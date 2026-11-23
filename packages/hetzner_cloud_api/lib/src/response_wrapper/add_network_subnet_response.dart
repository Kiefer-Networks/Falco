// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/networks_id_actions_add_subnet_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_add_subnet_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_add_subnet_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class AddNetworkSubnetResponse {
  const AddNetworkSubnetResponse();
}

@_i1.immutable
class AddNetworkSubnetResponse201 extends AddNetworkSubnetResponse {
  const AddNetworkSubnetResponse201({required this.body});

  final _i2.NetworksIdActionsAddSubnetPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddNetworkSubnetResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class AddNetworkSubnetResponse4XX extends AddNetworkSubnetResponse {
  const AddNetworkSubnetResponse4XX({required this.body});

  final _i4.NetworksIdActionsAddSubnetPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddNetworkSubnetResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class AddNetworkSubnetResponse5XX extends AddNetworkSubnetResponse {
  const AddNetworkSubnetResponse5XX({required this.body});

  final _i5.NetworksIdActionsAddSubnetPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddNetworkSubnetResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
