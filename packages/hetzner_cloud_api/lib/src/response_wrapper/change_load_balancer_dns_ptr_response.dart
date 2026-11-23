// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_change_dns_ptr_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_change_dns_ptr_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_change_dns_ptr_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ChangeLoadBalancerDnsPtrResponse {
  const ChangeLoadBalancerDnsPtrResponse();
}

@_i1.immutable
class ChangeLoadBalancerDnsPtrResponse201
    extends ChangeLoadBalancerDnsPtrResponse {
  const ChangeLoadBalancerDnsPtrResponse201({required this.body});

  final _i2.LoadBalancersIdActionsChangeDnsPtrPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeLoadBalancerDnsPtrResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeLoadBalancerDnsPtrResponse4XX
    extends ChangeLoadBalancerDnsPtrResponse {
  const ChangeLoadBalancerDnsPtrResponse4XX({required this.body});

  final _i4.LoadBalancersIdActionsChangeDnsPtrPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeLoadBalancerDnsPtrResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeLoadBalancerDnsPtrResponse5XX
    extends ChangeLoadBalancerDnsPtrResponse {
  const ChangeLoadBalancerDnsPtrResponse5XX({required this.body});

  final _i5.LoadBalancersIdActionsChangeDnsPtrPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeLoadBalancerDnsPtrResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
