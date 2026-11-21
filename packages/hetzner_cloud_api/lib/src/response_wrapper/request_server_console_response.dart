// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_request_console_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_request_console_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_request_console_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class RequestServerConsoleResponse {
  const RequestServerConsoleResponse();
}

@_i1.immutable
class RequestServerConsoleResponse201 extends RequestServerConsoleResponse {
  const RequestServerConsoleResponse201({required this.body});

  final _i2.ServersIdActionsRequestConsolePost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RequestServerConsoleResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class RequestServerConsoleResponse4XX extends RequestServerConsoleResponse {
  const RequestServerConsoleResponse4XX({required this.body});

  final _i4.ServersIdActionsRequestConsolePost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RequestServerConsoleResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class RequestServerConsoleResponse5XX extends RequestServerConsoleResponse {
  const RequestServerConsoleResponse5XX({required this.body});

  final _i5.ServersIdActionsRequestConsolePost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RequestServerConsoleResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
