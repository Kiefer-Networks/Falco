// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancer_types_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancer_types_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancer_types_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListLoadBalancerTypesResponse {
  const ListLoadBalancerTypesResponse();
}

@_i1.immutable
class ListLoadBalancerTypesResponse200 extends ListLoadBalancerTypesResponse {
  const ListLoadBalancerTypesResponse200({required this.body});

  final _i2.LoadBalancerTypesGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListLoadBalancerTypesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListLoadBalancerTypesResponse4XX extends ListLoadBalancerTypesResponse {
  const ListLoadBalancerTypesResponse4XX({required this.body});

  final _i4.LoadBalancerTypesGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListLoadBalancerTypesResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListLoadBalancerTypesResponse5XX extends ListLoadBalancerTypesResponse {
  const ListLoadBalancerTypesResponse5XX({required this.body});

  final _i5.LoadBalancerTypesGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListLoadBalancerTypesResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
