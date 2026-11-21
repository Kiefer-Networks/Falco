// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/networks_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/networks_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/networks_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListNetworksResponse {
  const ListNetworksResponse();
}

@_i1.immutable
class ListNetworksResponse200 extends ListNetworksResponse {
  const ListNetworksResponse200({required this.body});

  final _i2.NetworksGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListNetworksResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListNetworksResponse4XX extends ListNetworksResponse {
  const ListNetworksResponse4XX({required this.body});

  final _i4.NetworksGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListNetworksResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListNetworksResponse5XX extends ListNetworksResponse {
  const ListNetworksResponse5XX({required this.body});

  final _i5.NetworksGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListNetworksResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
