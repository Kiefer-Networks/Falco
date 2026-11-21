// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancers_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListLoadBalancersResponse {
  const ListLoadBalancersResponse();
}

@_i1.immutable
class ListLoadBalancersResponse200 extends ListLoadBalancersResponse {
  const ListLoadBalancersResponse200({required this.body});

  final _i2.LoadBalancersGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListLoadBalancersResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListLoadBalancersResponse4XX extends ListLoadBalancersResponse {
  const ListLoadBalancersResponse4XX({required this.body});

  final _i4.LoadBalancersGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListLoadBalancersResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListLoadBalancersResponse5XX extends ListLoadBalancersResponse {
  const ListLoadBalancersResponse5XX({required this.body});

  final _i5.LoadBalancersGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListLoadBalancersResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
