// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/floating_ips_id_put200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/floating_ips_id_put4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/floating_ips_id_put5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class UpdateFloatingIpResponse {
  const UpdateFloatingIpResponse();
}

@_i1.immutable
class UpdateFloatingIpResponse200 extends UpdateFloatingIpResponse {
  const UpdateFloatingIpResponse200({required this.body});

  final _i2.FloatingIpsIdPut200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateFloatingIpResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdateFloatingIpResponse4XX extends UpdateFloatingIpResponse {
  const UpdateFloatingIpResponse4XX({required this.body});

  final _i4.FloatingIpsIdPut4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateFloatingIpResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdateFloatingIpResponse5XX extends UpdateFloatingIpResponse {
  const UpdateFloatingIpResponse5XX({required this.body});

  final _i5.FloatingIpsIdPut5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateFloatingIpResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
