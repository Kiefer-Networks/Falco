// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class CreateServerResponse {
  const CreateServerResponse();
}

@_i1.immutable
class CreateServerResponse201 extends CreateServerResponse {
  const CreateServerResponse201({required this.body});

  final _i2.ServersPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateServerResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateServerResponse4XX extends CreateServerResponse {
  const CreateServerResponse4XX({required this.body});

  final _i4.ServersPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateServerResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateServerResponse5XX extends CreateServerResponse {
  const CreateServerResponse5XX({required this.body});

  final _i5.ServersPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateServerResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
