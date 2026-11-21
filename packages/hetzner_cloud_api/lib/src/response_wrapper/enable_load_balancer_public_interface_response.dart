// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_enable_public_interface_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_enable_public_interface_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_enable_public_interface_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class EnableLoadBalancerPublicInterfaceResponse {
  const EnableLoadBalancerPublicInterfaceResponse();
}

@_i1.immutable
class EnableLoadBalancerPublicInterfaceResponse201
    extends EnableLoadBalancerPublicInterfaceResponse {
  const EnableLoadBalancerPublicInterfaceResponse201({required this.body});

  final _i2.LoadBalancersIdActionsEnablePublicInterfacePost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnableLoadBalancerPublicInterfaceResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class EnableLoadBalancerPublicInterfaceResponse4XX
    extends EnableLoadBalancerPublicInterfaceResponse {
  const EnableLoadBalancerPublicInterfaceResponse4XX({required this.body});

  final _i4.LoadBalancersIdActionsEnablePublicInterfacePost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnableLoadBalancerPublicInterfaceResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class EnableLoadBalancerPublicInterfaceResponse5XX
    extends EnableLoadBalancerPublicInterfaceResponse {
  const EnableLoadBalancerPublicInterfaceResponse5XX({required this.body});

  final _i5.LoadBalancersIdActionsEnablePublicInterfacePost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnableLoadBalancerPublicInterfaceResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
