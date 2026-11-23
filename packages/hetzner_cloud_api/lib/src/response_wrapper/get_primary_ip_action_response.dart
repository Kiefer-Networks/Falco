// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_action_id_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_action_id_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_action_id_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetPrimaryIpActionResponse {
  const GetPrimaryIpActionResponse();
}

@_i1.immutable
class GetPrimaryIpActionResponse200 extends GetPrimaryIpActionResponse {
  const GetPrimaryIpActionResponse200({required this.body});

  final _i2.PrimaryIpsIdActionsActionIdGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetPrimaryIpActionResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetPrimaryIpActionResponse4XX extends GetPrimaryIpActionResponse {
  const GetPrimaryIpActionResponse4XX({required this.body});

  final _i4.PrimaryIpsIdActionsActionIdGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetPrimaryIpActionResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetPrimaryIpActionResponse5XX extends GetPrimaryIpActionResponse {
  const GetPrimaryIpActionResponse5XX({required this.body});

  final _i5.PrimaryIpsIdActionsActionIdGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetPrimaryIpActionResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
