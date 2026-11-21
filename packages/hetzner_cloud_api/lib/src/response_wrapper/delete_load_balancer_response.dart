// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_delete201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_delete4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_delete5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class DeleteLoadBalancerResponse {
  const DeleteLoadBalancerResponse();
}

@_i1.immutable
class DeleteLoadBalancerResponse201 extends DeleteLoadBalancerResponse {
  const DeleteLoadBalancerResponse201({required this.body});

  final _i2.LoadBalancersIdDelete201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteLoadBalancerResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeleteLoadBalancerResponse4XX extends DeleteLoadBalancerResponse {
  const DeleteLoadBalancerResponse4XX({required this.body});

  final _i4.LoadBalancersIdDelete4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteLoadBalancerResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeleteLoadBalancerResponse5XX extends DeleteLoadBalancerResponse {
  const DeleteLoadBalancerResponse5XX({required this.body});

  final _i5.LoadBalancersIdDelete5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteLoadBalancerResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
