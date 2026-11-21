// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/floating_ips_id_actions_unassign_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/floating_ips_id_actions_unassign_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/floating_ips_id_actions_unassign_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class UnassignFloatingIpResponse {
  const UnassignFloatingIpResponse();
}

@_i1.immutable
class UnassignFloatingIpResponse201 extends UnassignFloatingIpResponse {
  const UnassignFloatingIpResponse201({required this.body});

  final _i2.FloatingIpsIdActionsUnassignPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnassignFloatingIpResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UnassignFloatingIpResponse4XX extends UnassignFloatingIpResponse {
  const UnassignFloatingIpResponse4XX({required this.body});

  final _i4.FloatingIpsIdActionsUnassignPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnassignFloatingIpResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UnassignFloatingIpResponse5XX extends UnassignFloatingIpResponse {
  const UnassignFloatingIpResponse5XX({required this.body});

  final _i5.FloatingIpsIdActionsUnassignPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UnassignFloatingIpResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
