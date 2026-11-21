// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancers_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class CreateLoadBalancerResponse {
  const CreateLoadBalancerResponse();
}

@_i1.immutable
class CreateLoadBalancerResponse201 extends CreateLoadBalancerResponse {
  const CreateLoadBalancerResponse201({required this.body});

  final _i2.LoadBalancersPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateLoadBalancerResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateLoadBalancerResponse4XX extends CreateLoadBalancerResponse {
  const CreateLoadBalancerResponse4XX({required this.body});

  final _i4.LoadBalancersPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateLoadBalancerResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateLoadBalancerResponse5XX extends CreateLoadBalancerResponse {
  const CreateLoadBalancerResponse5XX({required this.body});

  final _i5.LoadBalancersPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateLoadBalancerResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
