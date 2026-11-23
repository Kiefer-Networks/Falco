// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_delete200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_delete4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_delete5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class DeleteServerResponse {
  const DeleteServerResponse();
}

@_i1.immutable
class DeleteServerResponse200 extends DeleteServerResponse {
  const DeleteServerResponse200({required this.body});

  final _i2.ServersIdDelete200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteServerResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeleteServerResponse4XX extends DeleteServerResponse {
  const DeleteServerResponse4XX({required this.body});

  final _i4.ServersIdDelete4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteServerResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeleteServerResponse5XX extends DeleteServerResponse {
  const DeleteServerResponse5XX({required this.body});

  final _i5.ServersIdDelete5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DeleteServerResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
