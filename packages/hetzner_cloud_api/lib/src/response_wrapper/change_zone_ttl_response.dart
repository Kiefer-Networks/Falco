// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_change_ttl_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_change_ttl_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_change_ttl_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ChangeZoneTtlResponse {
  const ChangeZoneTtlResponse();
}

@_i1.immutable
class ChangeZoneTtlResponse201 extends ChangeZoneTtlResponse {
  const ChangeZoneTtlResponse201({required this.body});

  final _i2.ZonesIdOrNameActionsChangeTtlPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeZoneTtlResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeZoneTtlResponse4XX extends ChangeZoneTtlResponse {
  const ChangeZoneTtlResponse4XX({required this.body});

  final _i4.ZonesIdOrNameActionsChangeTtlPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeZoneTtlResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeZoneTtlResponse5XX extends ChangeZoneTtlResponse {
  const ChangeZoneTtlResponse5XX({required this.body});

  final _i5.ZonesIdOrNameActionsChangeTtlPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeZoneTtlResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
