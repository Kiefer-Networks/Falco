// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/locations_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/locations_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/locations_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListLocationsResponse {
  const ListLocationsResponse();
}

@_i1.immutable
class ListLocationsResponse200 extends ListLocationsResponse {
  const ListLocationsResponse200({required this.body});

  final _i2.LocationsGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListLocationsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListLocationsResponse4XX extends ListLocationsResponse {
  const ListLocationsResponse4XX({required this.body});

  final _i4.LocationsGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListLocationsResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListLocationsResponse5XX extends ListLocationsResponse {
  const ListLocationsResponse5XX({required this.body});

  final _i5.LocationsGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListLocationsResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
