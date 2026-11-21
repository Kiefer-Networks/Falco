// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_get200_body_zone_one_of_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesIdOrNameGet200BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesIdOrNameGet200BodyModel({required this.zone});

  factory ZonesIdOrNameGet200BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ZonesIdOrNameGet200BodyModel: contains complex types',
    );
  }

  factory ZonesIdOrNameGet200BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ZonesIdOrNameGet200BodyModel');
    return ZonesIdOrNameGet200BodyModel(
      zone: _i4.ZonesIdOrNameGet200BodyZoneOneOfModel.fromJson(_$map[r'zone']),
    );
  }

  factory ZonesIdOrNameGet200BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ZonesIdOrNameGet200BodyModel: contains complex types',
    );
  }

  final _i4.ZonesIdOrNameGet200BodyZoneOneOfModel zone;

  @_i3.override
  _i3.Object? toJson() => {r'zone': this.zone.toJson()};

  ZonesIdOrNameGet200BodyModel Function({
    _i4.ZonesIdOrNameGet200BodyZoneOneOfModel? zone,
  })
  get copyWith {
    return ({_i4.ZonesIdOrNameGet200BodyZoneOneOfModel? zone}) =>
        ZonesIdOrNameGet200BodyModel(zone: zone ?? this.zone);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesIdOrNameGet200BodyModel && other.zone == this.zone;
  }

  @_i3.override
  _i3.int get hashCode => this.zone.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'zone'] = _i1.encodeAnyValueToPropertyValue(
      this.zone.toJson(),
      allowEmpty: allowEmpty,
    );
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ZonesIdOrNameGet200BodyModel: complex types cannot be URI-encoded',
    );
  }
}
