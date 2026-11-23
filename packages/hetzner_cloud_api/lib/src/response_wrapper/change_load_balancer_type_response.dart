// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_change_type_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_change_type_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_change_type_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ChangeLoadBalancerTypeResponse {
  const ChangeLoadBalancerTypeResponse();
}

@_i1.immutable
class ChangeLoadBalancerTypeResponse201 extends ChangeLoadBalancerTypeResponse {
  const ChangeLoadBalancerTypeResponse201({required this.body});

  final _i2.LoadBalancersIdActionsChangeTypePost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeLoadBalancerTypeResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeLoadBalancerTypeResponse4XX extends ChangeLoadBalancerTypeResponse {
  const ChangeLoadBalancerTypeResponse4XX({required this.body});

  final _i4.LoadBalancersIdActionsChangeTypePost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeLoadBalancerTypeResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeLoadBalancerTypeResponse5XX extends ChangeLoadBalancerTypeResponse {
  const ChangeLoadBalancerTypeResponse5XX({required this.body});

  final _i5.LoadBalancersIdActionsChangeTypePost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeLoadBalancerTypeResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
