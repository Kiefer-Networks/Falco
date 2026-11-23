// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListZoneRrsetsResponse {
  const ListZoneRrsetsResponse();
}

@_i1.immutable
class ListZoneRrsetsResponse200 extends ListZoneRrsetsResponse {
  const ListZoneRrsetsResponse200({required this.body});

  final _i2.ZonesIdOrNameRrsetsGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListZoneRrsetsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListZoneRrsetsResponse4XX extends ListZoneRrsetsResponse {
  const ListZoneRrsetsResponse4XX({required this.body});

  final _i4.ZonesIdOrNameRrsetsGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListZoneRrsetsResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListZoneRrsetsResponse5XX extends ListZoneRrsetsResponse {
  const ListZoneRrsetsResponse5XX({required this.body});

  final _i5.ZonesIdOrNameRrsetsGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListZoneRrsetsResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
