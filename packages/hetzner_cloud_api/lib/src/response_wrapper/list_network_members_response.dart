// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/networks_id_members_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/networks_id_members_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/networks_id_members_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListNetworkMembersResponse {
  const ListNetworkMembersResponse();
}

@_i1.immutable
class ListNetworkMembersResponse200 extends ListNetworkMembersResponse {
  const ListNetworkMembersResponse200({required this.body});

  final _i2.NetworksIdMembersGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListNetworkMembersResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListNetworkMembersResponse4XX extends ListNetworkMembersResponse {
  const ListNetworkMembersResponse4XX({required this.body});

  final _i4.NetworksIdMembersGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListNetworkMembersResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListNetworkMembersResponse5XX extends ListNetworkMembersResponse {
  const ListNetworkMembersResponse5XX({required this.body});

  final _i5.NetworksIdMembersGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListNetworkMembersResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
