// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/networks_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/networks_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/networks_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class CreateNetworkResponse {
  const CreateNetworkResponse();
}

@_i1.immutable
class CreateNetworkResponse201 extends CreateNetworkResponse {
  const CreateNetworkResponse201({required this.body});

  final _i2.NetworksPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateNetworkResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateNetworkResponse4XX extends CreateNetworkResponse {
  const CreateNetworkResponse4XX({required this.body});

  final _i4.NetworksPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateNetworkResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateNetworkResponse5XX extends CreateNetworkResponse {
  const CreateNetworkResponse5XX({required this.body});

  final _i5.NetworksPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateNetworkResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
