// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/networks_id_actions_change_ip_range_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_change_ip_range_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_change_ip_range_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ChangeNetworkIpRangeResponse {
  const ChangeNetworkIpRangeResponse();
}

@_i1.immutable
class ChangeNetworkIpRangeResponse201 extends ChangeNetworkIpRangeResponse {
  const ChangeNetworkIpRangeResponse201({required this.body});

  final _i2.NetworksIdActionsChangeIpRangePost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeNetworkIpRangeResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeNetworkIpRangeResponse4XX extends ChangeNetworkIpRangeResponse {
  const ChangeNetworkIpRangeResponse4XX({required this.body});

  final _i4.NetworksIdActionsChangeIpRangePost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeNetworkIpRangeResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ChangeNetworkIpRangeResponse5XX extends ChangeNetworkIpRangeResponse {
  const ChangeNetworkIpRangeResponse5XX({required this.body});

  final _i5.NetworksIdActionsChangeIpRangePost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ChangeNetworkIpRangeResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
