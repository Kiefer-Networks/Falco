// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_change_dns_ptr_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_change_dns_ptr_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_change_dns_ptr_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ChangePrimaryIpDnsPtrResponse {
  const ChangePrimaryIpDnsPtrResponse();
}

@_i1.immutable
class ChangePrimaryIpDnsPtrResponse201 extends ChangePrimaryIpDnsPtrResponse {
  const ChangePrimaryIpDnsPtrResponse201({required this.body});

  final _i2.PrimaryIpsIdActionsChangeDnsPtrPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangePrimaryIpDnsPtrResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangePrimaryIpDnsPtrResponse4XX extends ChangePrimaryIpDnsPtrResponse {
  const ChangePrimaryIpDnsPtrResponse4XX({required this.body});

  final _i4.PrimaryIpsIdActionsChangeDnsPtrPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangePrimaryIpDnsPtrResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangePrimaryIpDnsPtrResponse5XX extends ChangePrimaryIpDnsPtrResponse {
  const ChangePrimaryIpDnsPtrResponse5XX({required this.body});

  final _i5.PrimaryIpsIdActionsChangeDnsPtrPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangePrimaryIpDnsPtrResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
