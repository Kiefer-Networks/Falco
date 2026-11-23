// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_metrics_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_metrics_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_metrics_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetLoadBalancerMetricsResponse {
  const GetLoadBalancerMetricsResponse();
}

@_i1.immutable
class GetLoadBalancerMetricsResponse200 extends GetLoadBalancerMetricsResponse {
  const GetLoadBalancerMetricsResponse200({required this.body});

  final _i2.LoadBalancersIdMetricsGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetLoadBalancerMetricsResponse200 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetLoadBalancerMetricsResponse4XX extends GetLoadBalancerMetricsResponse {
  const GetLoadBalancerMetricsResponse4XX({required this.body});

  final _i4.LoadBalancersIdMetricsGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetLoadBalancerMetricsResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetLoadBalancerMetricsResponse5XX extends GetLoadBalancerMetricsResponse {
  const GetLoadBalancerMetricsResponse5XX({required this.body});

  final _i5.LoadBalancersIdMetricsGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetLoadBalancerMetricsResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
