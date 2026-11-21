// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/floating_ips_id_actions_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/floating_ips_id_actions_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/floating_ips_id_actions_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListFloatingIpActionsResponse {
  const ListFloatingIpActionsResponse();
}

@_i1.immutable
class ListFloatingIpActionsResponse200 extends ListFloatingIpActionsResponse {
  const ListFloatingIpActionsResponse200({required this.body});

  final _i2.FloatingIpsIdActionsGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListFloatingIpActionsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListFloatingIpActionsResponse4XX extends ListFloatingIpActionsResponse {
  const ListFloatingIpActionsResponse4XX({required this.body});

  final _i4.FloatingIpsIdActionsGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListFloatingIpActionsResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListFloatingIpActionsResponse5XX extends ListFloatingIpActionsResponse {
  const ListFloatingIpActionsResponse5XX({required this.body});

  final _i5.FloatingIpsIdActionsGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListFloatingIpActionsResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
