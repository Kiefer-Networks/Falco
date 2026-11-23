// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/networks_id_actions_action_id_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_action_id_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_action_id_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetNetworkActionResponse {
  const GetNetworkActionResponse();
}

@_i1.immutable
class GetNetworkActionResponse200 extends GetNetworkActionResponse {
  const GetNetworkActionResponse200({required this.body});

  final _i2.NetworksIdActionsActionIdGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetNetworkActionResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetNetworkActionResponse4XX extends GetNetworkActionResponse {
  const GetNetworkActionResponse4XX({required this.body});

  final _i4.NetworksIdActionsActionIdGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetNetworkActionResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetNetworkActionResponse5XX extends GetNetworkActionResponse {
  const GetNetworkActionResponse5XX({required this.body});

  final _i5.NetworksIdActionsActionIdGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetNetworkActionResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
