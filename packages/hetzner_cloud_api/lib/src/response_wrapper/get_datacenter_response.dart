// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/datacenters_id_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/datacenters_id_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/datacenters_id_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetDatacenterResponse {
  const GetDatacenterResponse();
}

@_i1.immutable
class GetDatacenterResponse200 extends GetDatacenterResponse {
  const GetDatacenterResponse200({required this.body});

  final _i2.DatacentersIdGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDatacenterResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetDatacenterResponse4XX extends GetDatacenterResponse {
  const GetDatacenterResponse4XX({required this.body});

  final _i4.DatacentersIdGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDatacenterResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetDatacenterResponse5XX extends GetDatacenterResponse {
  const GetDatacenterResponse5XX({required this.body});

  final _i5.DatacentersIdGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetDatacenterResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
