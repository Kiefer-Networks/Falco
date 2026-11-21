// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zone_secondary_model.dart' as _i4;
import 'package:hetzner_cloud_api/src/model/zone_secondary_model2.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZoneSecondary implements _i1.ParameterEncodable, _i1.UriEncodable {
  const ZoneSecondary({
    required this.zoneSecondaryModel,
    required this.zoneSecondaryModel2,
  });

  factory ZoneSecondary.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return ZoneSecondary(
      zoneSecondaryModel: _i4.ZoneSecondaryModel.fromSimple(
        value,
        explode: explode,
        isHeader: isHeader,
      ),
      zoneSecondaryModel2: _i5.ZoneSecondaryModel2.fromSimple(
        value,
        explode: explode,
        isHeader: isHeader,
      ),
    );
  }

  factory ZoneSecondary.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return ZoneSecondary(
      zoneSecondaryModel: _i4.ZoneSecondaryModel.fromForm(
        value,
        explode: explode,
      ),
      zoneSecondaryModel2: _i5.ZoneSecondaryModel2.fromForm(
        value,
        explode: explode,
      ),
    );
  }

  factory ZoneSecondary.fromJson(_i3.Object? json) {
    return ZoneSecondary(
      zoneSecondaryModel: _i4.ZoneSecondaryModel.fromJson(json),
      zoneSecondaryModel2: _i5.ZoneSecondaryModel2.fromJson(json),
    );
  }

  final _i4.ZoneSecondaryModel zoneSecondaryModel;

  final _i5.ZoneSecondaryModel2 zoneSecondaryModel2;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$zoneSecondaryModelJson = this.zoneSecondaryModel.toJson();
    if (_$zoneSecondaryModelJson is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected zoneSecondaryModel.toJson() to return Map<String, Object?>, got ${_$zoneSecondaryModelJson.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$zoneSecondaryModelJson);
    final _$zoneSecondaryModel2Json = this.zoneSecondaryModel2.toJson();
    if (_$zoneSecondaryModel2Json is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected zoneSecondaryModel2.toJson() to return Map<String, Object?>, got ${_$zoneSecondaryModel2Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$zoneSecondaryModel2Json);
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.zoneSecondaryModel.parameterProperties(allowEmpty: allowEmpty),
    );
    _$mergedProperties.addAll(
      this.zoneSecondaryModel2.parameterProperties(allowEmpty: allowEmpty),
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
      r'Cannot uriEncode ZoneSecondary: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZoneSecondary &&
        other.zoneSecondaryModel == this.zoneSecondaryModel &&
        other.zoneSecondaryModel2 == this.zoneSecondaryModel2;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.zoneSecondaryModel,
      this.zoneSecondaryModel2,
    ]);
  }

  ZoneSecondary Function({
    _i4.ZoneSecondaryModel? zoneSecondaryModel,
    _i5.ZoneSecondaryModel2? zoneSecondaryModel2,
  })
  get copyWith {
    return ({
      _i4.ZoneSecondaryModel? zoneSecondaryModel,
      _i5.ZoneSecondaryModel2? zoneSecondaryModel2,
    }) => ZoneSecondary(
      zoneSecondaryModel: zoneSecondaryModel ?? this.zoneSecondaryModel,
      zoneSecondaryModel2: zoneSecondaryModel2 ?? this.zoneSecondaryModel2,
    );
  }
}
