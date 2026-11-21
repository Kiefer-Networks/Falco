// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_attach_iso_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_attach_iso_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_attach_iso_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class AttachServerIsoResponse {
  const AttachServerIsoResponse();
}

@_i1.immutable
class AttachServerIsoResponse201 extends AttachServerIsoResponse {
  const AttachServerIsoResponse201({required this.body});

  final _i2.ServersIdActionsAttachIsoPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AttachServerIsoResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class AttachServerIsoResponse4XX extends AttachServerIsoResponse {
  const AttachServerIsoResponse4XX({required this.body});

  final _i4.ServersIdActionsAttachIsoPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AttachServerIsoResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class AttachServerIsoResponse5XX extends AttachServerIsoResponse {
  const AttachServerIsoResponse5XX({required this.body});

  final _i5.ServersIdActionsAttachIsoPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AttachServerIsoResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
