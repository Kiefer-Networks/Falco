// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_detach_iso_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_detach_iso_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_detach_iso_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class DetachServerIsoResponse {
  const DetachServerIsoResponse();
}

@_i1.immutable
class DetachServerIsoResponse201 extends DetachServerIsoResponse {
  const DetachServerIsoResponse201({required this.body});

  final _i2.ServersIdActionsDetachIsoPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DetachServerIsoResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DetachServerIsoResponse4XX extends DetachServerIsoResponse {
  const DetachServerIsoResponse4XX({required this.body});

  final _i4.ServersIdActionsDetachIsoPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DetachServerIsoResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DetachServerIsoResponse5XX extends DetachServerIsoResponse {
  const DetachServerIsoResponse5XX({required this.body});

  final _i5.ServersIdActionsDetachIsoPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DetachServerIsoResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
