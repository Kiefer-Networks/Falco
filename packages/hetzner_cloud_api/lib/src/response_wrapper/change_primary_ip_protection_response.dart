// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_change_protection_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_change_protection_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_change_protection_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ChangePrimaryIpProtectionResponse {
  const ChangePrimaryIpProtectionResponse();
}

@_i1.immutable
class ChangePrimaryIpProtectionResponse201
    extends ChangePrimaryIpProtectionResponse {
  const ChangePrimaryIpProtectionResponse201({required this.body});

  final _i2.PrimaryIpsIdActionsChangeProtectionPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangePrimaryIpProtectionResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangePrimaryIpProtectionResponse4XX
    extends ChangePrimaryIpProtectionResponse {
  const ChangePrimaryIpProtectionResponse4XX({required this.body});

  final _i4.PrimaryIpsIdActionsChangeProtectionPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangePrimaryIpProtectionResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangePrimaryIpProtectionResponse5XX
    extends ChangePrimaryIpProtectionResponse {
  const ChangePrimaryIpProtectionResponse5XX({required this.body});

  final _i5.PrimaryIpsIdActionsChangeProtectionPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangePrimaryIpProtectionResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
