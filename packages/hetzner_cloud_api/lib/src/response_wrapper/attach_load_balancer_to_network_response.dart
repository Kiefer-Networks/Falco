// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_attach_to_network_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_attach_to_network_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_attach_to_network_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class AttachLoadBalancerToNetworkResponse {
  const AttachLoadBalancerToNetworkResponse();
}

@_i1.immutable
class AttachLoadBalancerToNetworkResponse201
    extends AttachLoadBalancerToNetworkResponse {
  const AttachLoadBalancerToNetworkResponse201({required this.body});

  final _i2.LoadBalancersIdActionsAttachToNetworkPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AttachLoadBalancerToNetworkResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class AttachLoadBalancerToNetworkResponse4XX
    extends AttachLoadBalancerToNetworkResponse {
  const AttachLoadBalancerToNetworkResponse4XX({required this.body});

  final _i4.LoadBalancersIdActionsAttachToNetworkPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AttachLoadBalancerToNetworkResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class AttachLoadBalancerToNetworkResponse5XX
    extends AttachLoadBalancerToNetworkResponse {
  const AttachLoadBalancerToNetworkResponse5XX({required this.body});

  final _i5.LoadBalancersIdActionsAttachToNetworkPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AttachLoadBalancerToNetworkResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
