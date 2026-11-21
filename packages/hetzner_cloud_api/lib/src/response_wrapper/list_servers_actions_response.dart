// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_actions_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_actions_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_actions_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListServersActionsResponse {
  const ListServersActionsResponse();
}

@_i1.immutable
class ListServersActionsResponse200 extends ListServersActionsResponse {
  const ListServersActionsResponse200({required this.body});

  final _i2.ServersActionsGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListServersActionsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListServersActionsResponse4XX extends ListServersActionsResponse {
  const ListServersActionsResponse4XX({required this.body});

  final _i4.ServersActionsGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListServersActionsResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListServersActionsResponse5XX extends ListServersActionsResponse {
  const ListServersActionsResponse5XX({required this.body});

  final _i5.ServersActionsGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListServersActionsResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
