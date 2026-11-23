// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_add_service_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_add_service_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_add_service_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class AddLoadBalancerServiceResponse {
  const AddLoadBalancerServiceResponse();
}

@_i1.immutable
class AddLoadBalancerServiceResponse201 extends AddLoadBalancerServiceResponse {
  const AddLoadBalancerServiceResponse201({required this.body});

  final _i2.LoadBalancersIdActionsAddServicePost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddLoadBalancerServiceResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class AddLoadBalancerServiceResponse4XX extends AddLoadBalancerServiceResponse {
  const AddLoadBalancerServiceResponse4XX({required this.body});

  final _i4.LoadBalancersIdActionsAddServicePost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddLoadBalancerServiceResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class AddLoadBalancerServiceResponse5XX extends AddLoadBalancerServiceResponse {
  const AddLoadBalancerServiceResponse5XX({required this.body});

  final _i5.LoadBalancersIdActionsAddServicePost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddLoadBalancerServiceResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
