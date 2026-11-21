// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_set_records_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_set_records_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_set_records_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class SetZoneRrsetRecordsResponse {
  const SetZoneRrsetRecordsResponse();
}

@_i1.immutable
class SetZoneRrsetRecordsResponse201 extends SetZoneRrsetRecordsResponse {
  const SetZoneRrsetRecordsResponse201({required this.body});

  final _i2.ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPost201BodyModel
  body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetZoneRrsetRecordsResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class SetZoneRrsetRecordsResponse4XX extends SetZoneRrsetRecordsResponse {
  const SetZoneRrsetRecordsResponse4XX({required this.body});

  final _i4.ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPost4xxBodyModel
  body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetZoneRrsetRecordsResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class SetZoneRrsetRecordsResponse5XX extends SetZoneRrsetRecordsResponse {
  const SetZoneRrsetRecordsResponse5XX({required this.body});

  final _i5.ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPost5xxBodyModel
  body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetZoneRrsetRecordsResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
