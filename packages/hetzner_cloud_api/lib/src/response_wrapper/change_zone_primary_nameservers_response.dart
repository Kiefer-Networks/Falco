// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_change_primary_nameservers_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_change_primary_nameservers_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_change_primary_nameservers_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ChangeZonePrimaryNameserversResponse {
  const ChangeZonePrimaryNameserversResponse();
}

@_i1.immutable
class ChangeZonePrimaryNameserversResponse201
    extends ChangeZonePrimaryNameserversResponse {
  const ChangeZonePrimaryNameserversResponse201({required this.body});

  final _i2.ZonesIdOrNameActionsChangePrimaryNameserversPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeZonePrimaryNameserversResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeZonePrimaryNameserversResponse4XX
    extends ChangeZonePrimaryNameserversResponse {
  const ChangeZonePrimaryNameserversResponse4XX({required this.body});

  final _i4.ZonesIdOrNameActionsChangePrimaryNameserversPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeZonePrimaryNameserversResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeZonePrimaryNameserversResponse5XX
    extends ChangeZonePrimaryNameserversResponse {
  const ChangeZonePrimaryNameserversResponse5XX({required this.body});

  final _i5.ZonesIdOrNameActionsChangePrimaryNameserversPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeZonePrimaryNameserversResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
