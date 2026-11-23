// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/networks_id_actions_change_protection_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_change_protection_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_change_protection_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ChangeNetworkProtectionResponse {
  const ChangeNetworkProtectionResponse();
}

@_i1.immutable
class ChangeNetworkProtectionResponse201
    extends ChangeNetworkProtectionResponse {
  const ChangeNetworkProtectionResponse201({required this.body});

  final _i2.NetworksIdActionsChangeProtectionPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeNetworkProtectionResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeNetworkProtectionResponse4XX
    extends ChangeNetworkProtectionResponse {
  const ChangeNetworkProtectionResponse4XX({required this.body});

  final _i4.NetworksIdActionsChangeProtectionPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeNetworkProtectionResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeNetworkProtectionResponse5XX
    extends ChangeNetworkProtectionResponse {
  const ChangeNetworkProtectionResponse5XX({required this.body});

  final _i5.NetworksIdActionsChangeProtectionPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeNetworkProtectionResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
