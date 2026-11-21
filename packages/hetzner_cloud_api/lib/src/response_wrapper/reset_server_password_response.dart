// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_reset_password_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_reset_password_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_reset_password_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ResetServerPasswordResponse {
  const ResetServerPasswordResponse();
}

@_i1.immutable
class ResetServerPasswordResponse201 extends ResetServerPasswordResponse {
  const ResetServerPasswordResponse201({required this.body});

  final _i2.ServersIdActionsResetPasswordPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetServerPasswordResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ResetServerPasswordResponse4XX extends ResetServerPasswordResponse {
  const ResetServerPasswordResponse4XX({required this.body});

  final _i4.ServersIdActionsResetPasswordPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetServerPasswordResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ResetServerPasswordResponse5XX extends ResetServerPasswordResponse {
  const ResetServerPasswordResponse5XX({required this.body});

  final _i5.ServersIdActionsResetPasswordPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ResetServerPasswordResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
