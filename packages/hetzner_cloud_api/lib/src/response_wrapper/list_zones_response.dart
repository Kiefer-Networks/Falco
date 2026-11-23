// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/zones_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListZonesResponse {
  const ListZonesResponse();
}

@_i1.immutable
class ListZonesResponse200 extends ListZonesResponse {
  const ListZonesResponse200({required this.body});

  final _i2.ZonesGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListZonesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListZonesResponse4XX extends ListZonesResponse {
  const ListZonesResponse4XX({required this.body});

  final _i4.ZonesGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListZonesResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListZonesResponse5XX extends ListZonesResponse {
  const ListZonesResponse5XX({required this.body});

  final _i5.ZonesGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListZonesResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
