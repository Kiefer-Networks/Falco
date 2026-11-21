// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_action_id_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_action_id_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_action_id_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetServerActionResponse {
  const GetServerActionResponse();
}

@_i1.immutable
class GetServerActionResponse200 extends GetServerActionResponse {
  const GetServerActionResponse200({required this.body});

  final _i2.ServersIdActionsActionIdGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerActionResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetServerActionResponse4XX extends GetServerActionResponse {
  const GetServerActionResponse4XX({required this.body});

  final _i4.ServersIdActionsActionIdGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerActionResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetServerActionResponse5XX extends GetServerActionResponse {
  const GetServerActionResponse5XX({required this.body});

  final _i5.ServersIdActionsActionIdGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetServerActionResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
