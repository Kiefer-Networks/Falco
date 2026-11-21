// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_put200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_put4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_put5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class UpdateServerResponse {
  const UpdateServerResponse();
}

@_i1.immutable
class UpdateServerResponse200 extends UpdateServerResponse {
  const UpdateServerResponse200({required this.body});

  final _i2.ServersIdPut200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdateServerResponse4XX extends UpdateServerResponse {
  const UpdateServerResponse4XX({required this.body});

  final _i4.ServersIdPut4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdateServerResponse5XX extends UpdateServerResponse {
  const UpdateServerResponse5XX({required this.body});

  final _i5.ServersIdPut5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateServerResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
