// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_poweroff_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_poweroff_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_poweroff_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class PoweroffServerResponse {
  const PoweroffServerResponse();
}

@_i1.immutable
class PoweroffServerResponse201 extends PoweroffServerResponse {
  const PoweroffServerResponse201({required this.body});

  final _i2.ServersIdActionsPoweroffPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PoweroffServerResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class PoweroffServerResponse4XX extends PoweroffServerResponse {
  const PoweroffServerResponse4XX({required this.body});

  final _i4.ServersIdActionsPoweroffPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PoweroffServerResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class PoweroffServerResponse5XX extends PoweroffServerResponse {
  const PoweroffServerResponse5XX({required this.body});

  final _i5.ServersIdActionsPoweroffPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PoweroffServerResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
