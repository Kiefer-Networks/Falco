// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_change_algorithm_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_change_algorithm_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_change_algorithm_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ChangeLoadBalancerAlgorithmResponse {
  const ChangeLoadBalancerAlgorithmResponse();
}

@_i1.immutable
class ChangeLoadBalancerAlgorithmResponse201
    extends ChangeLoadBalancerAlgorithmResponse {
  const ChangeLoadBalancerAlgorithmResponse201({required this.body});

  final _i2.LoadBalancersIdActionsChangeAlgorithmPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeLoadBalancerAlgorithmResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeLoadBalancerAlgorithmResponse4XX
    extends ChangeLoadBalancerAlgorithmResponse {
  const ChangeLoadBalancerAlgorithmResponse4XX({required this.body});

  final _i4.LoadBalancersIdActionsChangeAlgorithmPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeLoadBalancerAlgorithmResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeLoadBalancerAlgorithmResponse5XX
    extends ChangeLoadBalancerAlgorithmResponse {
  const ChangeLoadBalancerAlgorithmResponse5XX({required this.body});

  final _i5.LoadBalancersIdActionsChangeAlgorithmPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeLoadBalancerAlgorithmResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
