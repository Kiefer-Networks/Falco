// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_change_protection_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_change_protection_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_change_protection_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ChangeLoadBalancerProtectionResponse {
  const ChangeLoadBalancerProtectionResponse();
}

@_i1.immutable
class ChangeLoadBalancerProtectionResponse201
    extends ChangeLoadBalancerProtectionResponse {
  const ChangeLoadBalancerProtectionResponse201({required this.body});

  final _i2.LoadBalancersIdActionsChangeProtectionPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeLoadBalancerProtectionResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeLoadBalancerProtectionResponse4XX
    extends ChangeLoadBalancerProtectionResponse {
  const ChangeLoadBalancerProtectionResponse4XX({required this.body});

  final _i4.LoadBalancersIdActionsChangeProtectionPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeLoadBalancerProtectionResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeLoadBalancerProtectionResponse5XX
    extends ChangeLoadBalancerProtectionResponse {
  const ChangeLoadBalancerProtectionResponse5XX({required this.body});

  final _i5.LoadBalancersIdActionsChangeProtectionPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeLoadBalancerProtectionResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
