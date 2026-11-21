// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_actions_id_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancers_actions_id_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_actions_id_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetLoadBalancersActionResponse {
  const GetLoadBalancersActionResponse();
}

@_i1.immutable
class GetLoadBalancersActionResponse200 extends GetLoadBalancersActionResponse {
  const GetLoadBalancersActionResponse200({required this.body});

  final _i2.LoadBalancersActionsIdGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetLoadBalancersActionResponse200 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetLoadBalancersActionResponse4XX extends GetLoadBalancersActionResponse {
  const GetLoadBalancersActionResponse4XX({required this.body});

  final _i4.LoadBalancersActionsIdGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetLoadBalancersActionResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetLoadBalancersActionResponse5XX extends GetLoadBalancersActionResponse {
  const GetLoadBalancersActionResponse5XX({required this.body});

  final _i5.LoadBalancersActionsIdGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetLoadBalancersActionResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
