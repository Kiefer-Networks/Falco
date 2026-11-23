// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_enable_rescue_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_enable_rescue_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_enable_rescue_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class EnableServerRescueResponse {
  const EnableServerRescueResponse();
}

@_i1.immutable
class EnableServerRescueResponse201 extends EnableServerRescueResponse {
  const EnableServerRescueResponse201({required this.body});

  final _i2.ServersIdActionsEnableRescuePost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnableServerRescueResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class EnableServerRescueResponse4XX extends EnableServerRescueResponse {
  const EnableServerRescueResponse4XX({required this.body});

  final _i4.ServersIdActionsEnableRescuePost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnableServerRescueResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class EnableServerRescueResponse5XX extends EnableServerRescueResponse {
  const EnableServerRescueResponse5XX({required this.body});

  final _i5.ServersIdActionsEnableRescuePost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnableServerRescueResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
