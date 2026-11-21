// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/networks_id_actions_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListNetworkActionsResponse {
  const ListNetworkActionsResponse();
}

@_i1.immutable
class ListNetworkActionsResponse200 extends ListNetworkActionsResponse {
  const ListNetworkActionsResponse200({required this.body});

  final _i2.NetworksIdActionsGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListNetworkActionsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListNetworkActionsResponse4XX extends ListNetworkActionsResponse {
  const ListNetworkActionsResponse4XX({required this.body});

  final _i4.NetworksIdActionsGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListNetworkActionsResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListNetworkActionsResponse5XX extends ListNetworkActionsResponse {
  const ListNetworkActionsResponse5XX({required this.body});

  final _i5.NetworksIdActionsGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListNetworkActionsResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
