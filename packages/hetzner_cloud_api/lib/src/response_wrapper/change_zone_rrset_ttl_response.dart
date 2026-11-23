// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_change_ttl_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_change_ttl_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_change_ttl_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ChangeZoneRrsetTtlResponse {
  const ChangeZoneRrsetTtlResponse();
}

@_i1.immutable
class ChangeZoneRrsetTtlResponse201 extends ChangeZoneRrsetTtlResponse {
  const ChangeZoneRrsetTtlResponse201({required this.body});

  final _i2.ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPost201BodyModel
  body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeZoneRrsetTtlResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeZoneRrsetTtlResponse4XX extends ChangeZoneRrsetTtlResponse {
  const ChangeZoneRrsetTtlResponse4XX({required this.body});

  final _i4.ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPost4xxBodyModel
  body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeZoneRrsetTtlResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeZoneRrsetTtlResponse5XX extends ChangeZoneRrsetTtlResponse {
  const ChangeZoneRrsetTtlResponse5XX({required this.body});

  final _i5.ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPost5xxBodyModel
  body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeZoneRrsetTtlResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
