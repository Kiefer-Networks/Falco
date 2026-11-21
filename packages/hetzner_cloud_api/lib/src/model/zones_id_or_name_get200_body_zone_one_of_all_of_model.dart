// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_get200_body_zone_one_of_all_of_model4.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_get200_body_zone_one_of_all_of_model5.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesIdOrNameGet200BodyZoneOneOfAllOfModel
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const ZonesIdOrNameGet200BodyZoneOneOfAllOfModel({
    required this.zonesIdOrNameGet200BodyZoneOneOfAllOfModel4,
    required this.zonesIdOrNameGet200BodyZoneOneOfAllOfModel5,
  });

  factory ZonesIdOrNameGet200BodyZoneOneOfAllOfModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return ZonesIdOrNameGet200BodyZoneOneOfAllOfModel(
      zonesIdOrNameGet200BodyZoneOneOfAllOfModel4:
          _i4.ZonesIdOrNameGet200BodyZoneOneOfAllOfModel4.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
      zonesIdOrNameGet200BodyZoneOneOfAllOfModel5:
          _i5.ZonesIdOrNameGet200BodyZoneOneOfAllOfModel5.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
    );
  }

  factory ZonesIdOrNameGet200BodyZoneOneOfAllOfModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return ZonesIdOrNameGet200BodyZoneOneOfAllOfModel(
      zonesIdOrNameGet200BodyZoneOneOfAllOfModel4:
          _i4.ZonesIdOrNameGet200BodyZoneOneOfAllOfModel4.fromForm(
            value,
            explode: explode,
          ),
      zonesIdOrNameGet200BodyZoneOneOfAllOfModel5:
          _i5.ZonesIdOrNameGet200BodyZoneOneOfAllOfModel5.fromForm(
            value,
            explode: explode,
          ),
    );
  }

  factory ZonesIdOrNameGet200BodyZoneOneOfAllOfModel.fromJson(
    _i3.Object? json,
  ) {
    return ZonesIdOrNameGet200BodyZoneOneOfAllOfModel(
      zonesIdOrNameGet200BodyZoneOneOfAllOfModel4:
          _i4.ZonesIdOrNameGet200BodyZoneOneOfAllOfModel4.fromJson(json),
      zonesIdOrNameGet200BodyZoneOneOfAllOfModel5:
          _i5.ZonesIdOrNameGet200BodyZoneOneOfAllOfModel5.fromJson(json),
    );
  }

  final _i4.ZonesIdOrNameGet200BodyZoneOneOfAllOfModel4
  zonesIdOrNameGet200BodyZoneOneOfAllOfModel4;

  final _i5.ZonesIdOrNameGet200BodyZoneOneOfAllOfModel5
  zonesIdOrNameGet200BodyZoneOneOfAllOfModel5;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$zonesIdOrNameGet200BodyZoneOneOfAllOfModel4Json = this
        .zonesIdOrNameGet200BodyZoneOneOfAllOfModel4
        .toJson();
    if (_$zonesIdOrNameGet200BodyZoneOneOfAllOfModel4Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected zonesIdOrNameGet200BodyZoneOneOfAllOfModel4.toJson() to return Map<String, Object?>, got ${_$zonesIdOrNameGet200BodyZoneOneOfAllOfModel4Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$zonesIdOrNameGet200BodyZoneOneOfAllOfModel4Json,
    );
    final _$zonesIdOrNameGet200BodyZoneOneOfAllOfModel5Json = this
        .zonesIdOrNameGet200BodyZoneOneOfAllOfModel5
        .toJson();
    if (_$zonesIdOrNameGet200BodyZoneOneOfAllOfModel5Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected zonesIdOrNameGet200BodyZoneOneOfAllOfModel5.toJson() to return Map<String, Object?>, got ${_$zonesIdOrNameGet200BodyZoneOneOfAllOfModel5Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$zonesIdOrNameGet200BodyZoneOneOfAllOfModel5Json,
    );
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.zonesIdOrNameGet200BodyZoneOneOfAllOfModel4.parameterProperties(
        allowEmpty: allowEmpty,
      ),
    );
    _$mergedProperties.addAll(
      this.zonesIdOrNameGet200BodyZoneOneOfAllOfModel5.parameterProperties(
        allowEmpty: allowEmpty,
      ),
    );
    return _$mergedProperties;
  }

  @_i3.override
  _i3.String toSimple({
    required _i3.bool explode,
    required _i3.bool allowEmpty,
    _i3.bool literal = false,
  }) {
    return parameterProperties(allowEmpty: allowEmpty)
        .toSimple(explode: explode, allowEmpty: allowEmpty, literal: literal);
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toForm(
    _i3.String paramName, {
    required _i3.bool explode,
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
    _i3.Map<_i3.String, _i1.FormFieldEncoding> fieldEncodings = const {},
  }) {
    return parameterProperties(allowEmpty: allowEmpty).toForm(
      paramName,
      explode: explode,
      allowEmpty: allowEmpty,
      useQueryComponent: useQueryComponent,
      allowReserved: allowReserved,
      fieldEncodings: fieldEncodings,
      textEncoding: textEncoding,
    );
  }

  @_i3.override
  _i3.String toLabel({
    required _i3.bool explode,
    required _i3.bool allowEmpty,
  }) {
    return parameterProperties(allowEmpty: allowEmpty)
        .toLabel(explode: explode, allowEmpty: allowEmpty);
  }

  @_i3.override
  _i3.String toMatrix(
    _i3.String paramName, {
    required _i3.bool explode,
    required _i3.bool allowEmpty,
  }) {
    return parameterProperties(allowEmpty: allowEmpty)
        .toMatrix(paramName, explode: explode, allowEmpty: allowEmpty);
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toDeepObject(
    _i3.String paramName, {
    required _i3.bool explode,
    required _i3.bool allowEmpty,
    _i3.bool allowReserved = false,
  }) {
    return parameterProperties(allowEmpty: allowEmpty).toDeepObject(
      paramName,
      explode: explode,
      allowEmpty: allowEmpty,
      allowReserved: allowReserved,
    );
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toPipeDelimited(
    _i3.String paramName, {
    required _i3.bool allowEmpty,
    _i3.bool allowReserved = false,
  }) {
    return parameterProperties(allowEmpty: allowEmpty).toPipeDelimited(
      paramName,
      allowEmpty: allowEmpty,
      allowReserved: allowReserved,
    );
  }

  @_i3.override
  _i3.List<_i1.ParameterEntry> toSpaceDelimited(
    _i3.String paramName, {
    required _i3.bool allowEmpty,
    _i3.bool allowReserved = false,
  }) {
    return parameterProperties(allowEmpty: allowEmpty).toSpaceDelimited(
      paramName,
      allowEmpty: allowEmpty,
      allowReserved: allowReserved,
    );
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ZonesIdOrNameGet200BodyZoneOneOfAllOfModel: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesIdOrNameGet200BodyZoneOneOfAllOfModel &&
        other.zonesIdOrNameGet200BodyZoneOneOfAllOfModel4 ==
            this.zonesIdOrNameGet200BodyZoneOneOfAllOfModel4 &&
        other.zonesIdOrNameGet200BodyZoneOneOfAllOfModel5 ==
            this.zonesIdOrNameGet200BodyZoneOneOfAllOfModel5;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.zonesIdOrNameGet200BodyZoneOneOfAllOfModel4,
      this.zonesIdOrNameGet200BodyZoneOneOfAllOfModel5,
    ]);
  }

  ZonesIdOrNameGet200BodyZoneOneOfAllOfModel Function({
    _i4.ZonesIdOrNameGet200BodyZoneOneOfAllOfModel4?
    zonesIdOrNameGet200BodyZoneOneOfAllOfModel4,
    _i5.ZonesIdOrNameGet200BodyZoneOneOfAllOfModel5?
    zonesIdOrNameGet200BodyZoneOneOfAllOfModel5,
  })
  get copyWith {
    return ({
      _i4.ZonesIdOrNameGet200BodyZoneOneOfAllOfModel4?
      zonesIdOrNameGet200BodyZoneOneOfAllOfModel4,
      _i5.ZonesIdOrNameGet200BodyZoneOneOfAllOfModel5?
      zonesIdOrNameGet200BodyZoneOneOfAllOfModel5,
    }) => ZonesIdOrNameGet200BodyZoneOneOfAllOfModel(
      zonesIdOrNameGet200BodyZoneOneOfAllOfModel4:
          zonesIdOrNameGet200BodyZoneOneOfAllOfModel4 ??
          this.zonesIdOrNameGet200BodyZoneOneOfAllOfModel4,
      zonesIdOrNameGet200BodyZoneOneOfAllOfModel5:
          zonesIdOrNameGet200BodyZoneOneOfAllOfModel5 ??
          this.zonesIdOrNameGet200BodyZoneOneOfAllOfModel5,
    );
  }
}
