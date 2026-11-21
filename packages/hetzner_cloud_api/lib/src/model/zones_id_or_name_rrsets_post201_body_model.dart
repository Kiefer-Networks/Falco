// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_post201_body_action_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_post201_body_rrset_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesIdOrNameRrsetsPost201BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesIdOrNameRrsetsPost201BodyModel({
    required this.rrset,
    required this.action,
  });

  factory ZonesIdOrNameRrsetsPost201BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ZonesIdOrNameRrsetsPost201BodyModel: contains complex types',
    );
  }

  factory ZonesIdOrNameRrsetsPost201BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'ZonesIdOrNameRrsetsPost201BodyModel',
    );
    return ZonesIdOrNameRrsetsPost201BodyModel(
      rrset: _i4.ZonesIdOrNameRrsetsPost201BodyRrsetModel.fromJson(
        _$map[r'rrset'],
      ),
      action: _i5.ZonesIdOrNameRrsetsPost201BodyActionModel.fromJson(
        _$map[r'action'],
      ),
    );
  }

  factory ZonesIdOrNameRrsetsPost201BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ZonesIdOrNameRrsetsPost201BodyModel: contains complex types',
    );
  }

  final _i4.ZonesIdOrNameRrsetsPost201BodyRrsetModel rrset;

  final _i5.ZonesIdOrNameRrsetsPost201BodyActionModel action;

  @_i3.override
  _i3.Object? toJson() => {
    r'rrset': this.rrset.toJson(),
    r'action': this.action.toJson(),
  };

  ZonesIdOrNameRrsetsPost201BodyModel Function({
    _i4.ZonesIdOrNameRrsetsPost201BodyRrsetModel? rrset,
    _i5.ZonesIdOrNameRrsetsPost201BodyActionModel? action,
  })
  get copyWith {
    return ({
      _i4.ZonesIdOrNameRrsetsPost201BodyRrsetModel? rrset,
      _i5.ZonesIdOrNameRrsetsPost201BodyActionModel? action,
    }) => ZonesIdOrNameRrsetsPost201BodyModel(
      rrset: rrset ?? this.rrset,
      action: action ?? this.action,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesIdOrNameRrsetsPost201BodyModel &&
        other.rrset == this.rrset &&
        other.action == this.action;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.rrset, this.action]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ZonesIdOrNameRrsetsPost201BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ZonesIdOrNameRrsetsPost201BodyModel: complex types cannot be URI-encoded',
    );
  }
}
