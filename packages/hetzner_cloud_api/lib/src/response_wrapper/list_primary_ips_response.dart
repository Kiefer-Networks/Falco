// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/primary_ips_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/primary_ips_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/primary_ips_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListPrimaryIpsResponse {
  const ListPrimaryIpsResponse();
}

@_i1.immutable
class ListPrimaryIpsResponse200 extends ListPrimaryIpsResponse {
  const ListPrimaryIpsResponse200({required this.body});

  final _i2.PrimaryIpsGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPrimaryIpsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListPrimaryIpsResponse4XX extends ListPrimaryIpsResponse {
  const ListPrimaryIpsResponse4XX({required this.body});

  final _i4.PrimaryIpsGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPrimaryIpsResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListPrimaryIpsResponse5XX extends ListPrimaryIpsResponse {
  const ListPrimaryIpsResponse5XX({required this.body});

  final _i5.PrimaryIpsGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPrimaryIpsResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
