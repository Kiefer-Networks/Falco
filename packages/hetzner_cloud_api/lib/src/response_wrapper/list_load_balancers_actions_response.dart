// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_actions_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/load_balancers_actions_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_actions_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListLoadBalancersActionsResponse {
  const ListLoadBalancersActionsResponse();
}

@_i1.immutable
class ListLoadBalancersActionsResponse200
    extends ListLoadBalancersActionsResponse {
  const ListLoadBalancersActionsResponse200({required this.body});

  final _i2.LoadBalancersActionsGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListLoadBalancersActionsResponse200 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListLoadBalancersActionsResponse4XX
    extends ListLoadBalancersActionsResponse {
  const ListLoadBalancersActionsResponse4XX({required this.body});

  final _i4.LoadBalancersActionsGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListLoadBalancersActionsResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListLoadBalancersActionsResponse5XX
    extends ListLoadBalancersActionsResponse {
  const ListLoadBalancersActionsResponse5XX({required this.body});

  final _i5.LoadBalancersActionsGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListLoadBalancersActionsResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
