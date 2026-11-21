// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_shutdown_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_shutdown_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_shutdown_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ShutdownServerResponse {
  const ShutdownServerResponse();
}

@_i1.immutable
class ShutdownServerResponse201 extends ShutdownServerResponse {
  const ShutdownServerResponse201({required this.body});

  final _i2.ServersIdActionsShutdownPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ShutdownServerResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ShutdownServerResponse4XX extends ShutdownServerResponse {
  const ShutdownServerResponse4XX({required this.body});

  final _i4.ServersIdActionsShutdownPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ShutdownServerResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ShutdownServerResponse5XX extends ShutdownServerResponse {
  const ShutdownServerResponse5XX({required this.body});

  final _i5.ServersIdActionsShutdownPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ShutdownServerResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
