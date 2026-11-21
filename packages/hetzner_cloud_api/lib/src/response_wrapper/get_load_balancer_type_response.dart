// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancer_types_id_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancer_types_id_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancer_types_id_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetLoadBalancerTypeResponse {
  const GetLoadBalancerTypeResponse();
}

@_i1.immutable
class GetLoadBalancerTypeResponse200 extends GetLoadBalancerTypeResponse {
  const GetLoadBalancerTypeResponse200({required this.body});

  final _i2.LoadBalancerTypesIdGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetLoadBalancerTypeResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetLoadBalancerTypeResponse4XX extends GetLoadBalancerTypeResponse {
  const GetLoadBalancerTypeResponse4XX({required this.body});

  final _i4.LoadBalancerTypesIdGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetLoadBalancerTypeResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetLoadBalancerTypeResponse5XX extends GetLoadBalancerTypeResponse {
  const GetLoadBalancerTypeResponse5XX({required this.body});

  final _i5.LoadBalancerTypesIdGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetLoadBalancerTypeResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
