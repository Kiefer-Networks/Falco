// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_disable_public_interface_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_disable_public_interface_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_disable_public_interface_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class DisableLoadBalancerPublicInterfaceResponse {
  const DisableLoadBalancerPublicInterfaceResponse();
}

@_i1.immutable
class DisableLoadBalancerPublicInterfaceResponse201
    extends DisableLoadBalancerPublicInterfaceResponse {
  const DisableLoadBalancerPublicInterfaceResponse201({required this.body});

  final _i2.LoadBalancersIdActionsDisablePublicInterfacePost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableLoadBalancerPublicInterfaceResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DisableLoadBalancerPublicInterfaceResponse4XX
    extends DisableLoadBalancerPublicInterfaceResponse {
  const DisableLoadBalancerPublicInterfaceResponse4XX({required this.body});

  final _i4.LoadBalancersIdActionsDisablePublicInterfacePost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableLoadBalancerPublicInterfaceResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DisableLoadBalancerPublicInterfaceResponse5XX
    extends DisableLoadBalancerPublicInterfaceResponse {
  const DisableLoadBalancerPublicInterfaceResponse5XX({required this.body});

  final _i5.LoadBalancersIdActionsDisablePublicInterfacePost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableLoadBalancerPublicInterfaceResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
