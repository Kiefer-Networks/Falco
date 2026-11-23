// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_change_type_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_change_type_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_change_type_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ChangeServerTypeResponse {
  const ChangeServerTypeResponse();
}

@_i1.immutable
class ChangeServerTypeResponse201 extends ChangeServerTypeResponse {
  const ChangeServerTypeResponse201({required this.body});

  final _i2.ServersIdActionsChangeTypePost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeServerTypeResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeServerTypeResponse4XX extends ChangeServerTypeResponse {
  const ChangeServerTypeResponse4XX({required this.body});

  final _i4.ServersIdActionsChangeTypePost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeServerTypeResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeServerTypeResponse5XX extends ChangeServerTypeResponse {
  const ChangeServerTypeResponse5XX({required this.body});

  final _i5.ServersIdActionsChangeTypePost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeServerTypeResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
