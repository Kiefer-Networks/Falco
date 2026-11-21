// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_remove_target_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_remove_target_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_remove_target_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class RemoveLoadBalancerTargetResponse {
  const RemoveLoadBalancerTargetResponse();
}

@_i1.immutable
class RemoveLoadBalancerTargetResponse201
    extends RemoveLoadBalancerTargetResponse {
  const RemoveLoadBalancerTargetResponse201({required this.body});

  final _i2.LoadBalancersIdActionsRemoveTargetPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveLoadBalancerTargetResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class RemoveLoadBalancerTargetResponse4XX
    extends RemoveLoadBalancerTargetResponse {
  const RemoveLoadBalancerTargetResponse4XX({required this.body});

  final _i4.LoadBalancersIdActionsRemoveTargetPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveLoadBalancerTargetResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class RemoveLoadBalancerTargetResponse5XX
    extends RemoveLoadBalancerTargetResponse {
  const RemoveLoadBalancerTargetResponse5XX({required this.body});

  final _i5.LoadBalancersIdActionsRemoveTargetPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveLoadBalancerTargetResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
