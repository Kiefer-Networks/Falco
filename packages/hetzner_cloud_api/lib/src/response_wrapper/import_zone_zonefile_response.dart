// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_import_zonefile_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_import_zonefile_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_import_zonefile_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ImportZoneZonefileResponse {
  const ImportZoneZonefileResponse();
}

@_i1.immutable
class ImportZoneZonefileResponse201 extends ImportZoneZonefileResponse {
  const ImportZoneZonefileResponse201({required this.body});

  final _i2.ZonesIdOrNameActionsImportZonefilePost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportZoneZonefileResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ImportZoneZonefileResponse4XX extends ImportZoneZonefileResponse {
  const ImportZoneZonefileResponse4XX({required this.body});

  final _i4.ZonesIdOrNameActionsImportZonefilePost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportZoneZonefileResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ImportZoneZonefileResponse5XX extends ImportZoneZonefileResponse {
  const ImportZoneZonefileResponse5XX({required this.body});

  final _i5.ZonesIdOrNameActionsImportZonefilePost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ImportZoneZonefileResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
