// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_create_image_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_create_image_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_create_image_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class CreateServerImageResponse {
  const CreateServerImageResponse();
}

@_i1.immutable
class CreateServerImageResponse201 extends CreateServerImageResponse {
  const CreateServerImageResponse201({required this.body});

  final _i2.ServersIdActionsCreateImagePost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateServerImageResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateServerImageResponse4XX extends CreateServerImageResponse {
  const CreateServerImageResponse4XX({required this.body});

  final _i4.ServersIdActionsCreateImagePost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateServerImageResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateServerImageResponse5XX extends CreateServerImageResponse {
  const CreateServerImageResponse5XX({required this.body});

  final _i5.ServersIdActionsCreateImagePost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateServerImageResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
