// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_post201_body_action_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/zones_post201_body_zone_one_of_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesPost201BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesPost201BodyModel({required this.zone, required this.action});

  factory ZonesPost201BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ZonesPost201BodyModel: contains complex types',
    );
  }

  factory ZonesPost201BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ZonesPost201BodyModel');
    return ZonesPost201BodyModel(
      zone: _i4.ZonesPost201BodyZoneOneOfModel.fromJson(_$map[r'zone']),
      action: _i5.ZonesPost201BodyActionModel.fromJson(_$map[r'action']),
    );
  }

  factory ZonesPost201BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ZonesPost201BodyModel: contains complex types',
    );
  }

  final _i4.ZonesPost201BodyZoneOneOfModel zone;

  final _i5.ZonesPost201BodyActionModel action;

  @_i3.override
  _i3.Object? toJson() => {
    r'zone': this.zone.toJson(),
    r'action': this.action.toJson(),
  };

  ZonesPost201BodyModel Function({
    _i4.ZonesPost201BodyZoneOneOfModel? zone,
    _i5.ZonesPost201BodyActionModel? action,
  })
  get copyWith {
    return ({
      _i4.ZonesPost201BodyZoneOneOfModel? zone,
      _i5.ZonesPost201BodyActionModel? action,
    }) => ZonesPost201BodyModel(
      zone: zone ?? this.zone,
      action: action ?? this.action,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesPost201BodyModel &&
        other.zone == this.zone &&
        other.action == this.action;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.zone, this.action]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ZonesPost201BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ZonesPost201BodyModel: complex types cannot be URI-encoded',
    );
  }
}
