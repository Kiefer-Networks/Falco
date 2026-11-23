// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_get5xx_body_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/response/servers_get200_response.dart'
    as _i2;
import 'package:meta/meta.dart' as _i1;

sealed class ListServersResponse {
  const ListServersResponse();
}

@_i1.immutable
class ListServersResponse200 extends ListServersResponse {
  const ListServersResponse200({required this.body});

  final _i2.ServersGet200Response body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListServersResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListServersResponse4XX extends ListServersResponse {
  const ListServersResponse4XX({required this.body});

  final _i4.ServersGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListServersResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListServersResponse5XX extends ListServersResponse {
  const ListServersResponse5XX({required this.body});

  final _i5.ServersGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListServersResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
