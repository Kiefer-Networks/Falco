// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_get200_body_zones_array_one_of_all_of_model4.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_get200_body_zones_array_one_of_all_of_model5.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesGet200BodyZonesArrayOneOfAllOfModel
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const ZonesGet200BodyZonesArrayOneOfAllOfModel({
    required this.zonesGet200BodyZonesArrayOneOfAllOfModel4,
    required this.zonesGet200BodyZonesArrayOneOfAllOfModel5,
  });

  factory ZonesGet200BodyZonesArrayOneOfAllOfModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return ZonesGet200BodyZonesArrayOneOfAllOfModel(
      zonesGet200BodyZonesArrayOneOfAllOfModel4:
          _i4.ZonesGet200BodyZonesArrayOneOfAllOfModel4.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
      zonesGet200BodyZonesArrayOneOfAllOfModel5:
          _i5.ZonesGet200BodyZonesArrayOneOfAllOfModel5.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
    );
  }

  factory ZonesGet200BodyZonesArrayOneOfAllOfModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return ZonesGet200BodyZonesArrayOneOfAllOfModel(
      zonesGet200BodyZonesArrayOneOfAllOfModel4:
          _i4.ZonesGet200BodyZonesArrayOneOfAllOfModel4.fromForm(
            value,
            explode: explode,
          ),
      zonesGet200BodyZonesArrayOneOfAllOfModel5:
          _i5.ZonesGet200BodyZonesArrayOneOfAllOfModel5.fromForm(
            value,
            explode: explode,
          ),
    );
  }

  factory ZonesGet200BodyZonesArrayOneOfAllOfModel.fromJson(_i3.Object? json) {
    return ZonesGet200BodyZonesArrayOneOfAllOfModel(
      zonesGet200BodyZonesArrayOneOfAllOfModel4:
          _i4.ZonesGet200BodyZonesArrayOneOfAllOfModel4.fromJson(json),
      zonesGet200BodyZonesArrayOneOfAllOfModel5:
          _i5.ZonesGet200BodyZonesArrayOneOfAllOfModel5.fromJson(json),
    );
  }

  final _i4.ZonesGet200BodyZonesArrayOneOfAllOfModel4
  zonesGet200BodyZonesArrayOneOfAllOfModel4;

  final _i5.ZonesGet200BodyZonesArrayOneOfAllOfModel5
  zonesGet200BodyZonesArrayOneOfAllOfModel5;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$zonesGet200BodyZonesArrayOneOfAllOfModel4Json = this
        .zonesGet200BodyZonesArrayOneOfAllOfModel4
        .toJson();
    if (_$zonesGet200BodyZonesArrayOneOfAllOfModel4Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected zonesGet200BodyZonesArrayOneOfAllOfModel4.toJson() to return Map<String, Object?>, got ${_$zonesGet200BodyZonesArrayOneOfAllOfModel4Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$zonesGet200BodyZonesArrayOneOfAllOfModel4Json);
    final _$zonesGet200BodyZonesArrayOneOfAllOfModel5Json = this
        .zonesGet200BodyZonesArrayOneOfAllOfModel5
        .toJson();
    if (_$zonesGet200BodyZonesArrayOneOfAllOfModel5Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected zonesGet200BodyZonesArrayOneOfAllOfModel5.toJson() to return Map<String, Object?>, got ${_$zonesGet200BodyZonesArrayOneOfAllOfModel5Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$zonesGet200BodyZonesArrayOneOfAllOfModel5Json);
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.zonesGet200BodyZonesArrayOneOfAllOfModel4.parameterProperties(
        allowEmpty: allowEmpty,
      ),
    );
    _$mergedProperties.addAll(
      this.zonesGet200BodyZonesArrayOneOfAllOfModel5.parameterProperties(
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
      r'Cannot uriEncode ZonesGet200BodyZonesArrayOneOfAllOfModel: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesGet200BodyZonesArrayOneOfAllOfModel &&
        other.zonesGet200BodyZonesArrayOneOfAllOfModel4 ==
            this.zonesGet200BodyZonesArrayOneOfAllOfModel4 &&
        other.zonesGet200BodyZonesArrayOneOfAllOfModel5 ==
            this.zonesGet200BodyZonesArrayOneOfAllOfModel5;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.zonesGet200BodyZonesArrayOneOfAllOfModel4,
      this.zonesGet200BodyZonesArrayOneOfAllOfModel5,
    ]);
  }

  ZonesGet200BodyZonesArrayOneOfAllOfModel Function({
    _i4.ZonesGet200BodyZonesArrayOneOfAllOfModel4?
    zonesGet200BodyZonesArrayOneOfAllOfModel4,
    _i5.ZonesGet200BodyZonesArrayOneOfAllOfModel5?
    zonesGet200BodyZonesArrayOneOfAllOfModel5,
  })
  get copyWith {
    return ({
      _i4.ZonesGet200BodyZonesArrayOneOfAllOfModel4?
      zonesGet200BodyZonesArrayOneOfAllOfModel4,
      _i5.ZonesGet200BodyZonesArrayOneOfAllOfModel5?
      zonesGet200BodyZonesArrayOneOfAllOfModel5,
    }) => ZonesGet200BodyZonesArrayOneOfAllOfModel(
      zonesGet200BodyZonesArrayOneOfAllOfModel4:
          zonesGet200BodyZonesArrayOneOfAllOfModel4 ??
          this.zonesGet200BodyZonesArrayOneOfAllOfModel4,
      zonesGet200BodyZonesArrayOneOfAllOfModel5:
          zonesGet200BodyZonesArrayOneOfAllOfModel5 ??
          this.zonesGet200BodyZonesArrayOneOfAllOfModel5,
    );
  }
}
