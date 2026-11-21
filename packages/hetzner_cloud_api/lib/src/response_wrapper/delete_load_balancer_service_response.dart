// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_delete_service_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_delete_service_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_delete_service_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class DeleteLoadBalancerServiceResponse {
  const DeleteLoadBalancerServiceResponse();
}

@_i1.immutable
class DeleteLoadBalancerServiceResponse201
    extends DeleteLoadBalancerServiceResponse {
  const DeleteLoadBalancerServiceResponse201({required this.body});

  final _i2.LoadBalancersIdActionsDeleteServicePost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteLoadBalancerServiceResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeleteLoadBalancerServiceResponse4XX
    extends DeleteLoadBalancerServiceResponse {
  const DeleteLoadBalancerServiceResponse4XX({required this.body});

  final _i4.LoadBalancersIdActionsDeleteServicePost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteLoadBalancerServiceResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeleteLoadBalancerServiceResponse5XX
    extends DeleteLoadBalancerServiceResponse {
  const DeleteLoadBalancerServiceResponse5XX({required this.body});

  final _i5.LoadBalancersIdActionsDeleteServicePost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteLoadBalancerServiceResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
