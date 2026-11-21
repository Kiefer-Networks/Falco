// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_disable_rescue_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_disable_rescue_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_disable_rescue_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class DisableServerRescueResponse {
  const DisableServerRescueResponse();
}

@_i1.immutable
class DisableServerRescueResponse201 extends DisableServerRescueResponse {
  const DisableServerRescueResponse201({required this.body});

  final _i2.ServersIdActionsDisableRescuePost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableServerRescueResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DisableServerRescueResponse4XX extends DisableServerRescueResponse {
  const DisableServerRescueResponse4XX({required this.body});

  final _i4.ServersIdActionsDisableRescuePost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableServerRescueResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DisableServerRescueResponse5XX extends DisableServerRescueResponse {
  const DisableServerRescueResponse5XX({required this.body});

  final _i5.ServersIdActionsDisableRescuePost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DisableServerRescueResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
