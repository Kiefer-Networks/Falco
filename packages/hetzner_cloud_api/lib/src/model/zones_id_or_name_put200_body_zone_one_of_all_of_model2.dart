// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_put200_body_zone_one_of_all_of_model3.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_put200_body_zone_one_of_all_of_model6.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesIdOrNamePut200BodyZoneOneOfAllOfModel2
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const ZonesIdOrNamePut200BodyZoneOneOfAllOfModel2({
    required this.zonesIdOrNamePut200BodyZoneOneOfAllOfModel3,
    required this.zonesIdOrNamePut200BodyZoneOneOfAllOfModel6,
  });

  factory ZonesIdOrNamePut200BodyZoneOneOfAllOfModel2.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return ZonesIdOrNamePut200BodyZoneOneOfAllOfModel2(
      zonesIdOrNamePut200BodyZoneOneOfAllOfModel3:
          _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel3.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
      zonesIdOrNamePut200BodyZoneOneOfAllOfModel6:
          _i5.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel6.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
    );
  }

  factory ZonesIdOrNamePut200BodyZoneOneOfAllOfModel2.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return ZonesIdOrNamePut200BodyZoneOneOfAllOfModel2(
      zonesIdOrNamePut200BodyZoneOneOfAllOfModel3:
          _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel3.fromForm(
            value,
            explode: explode,
          ),
      zonesIdOrNamePut200BodyZoneOneOfAllOfModel6:
          _i5.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel6.fromForm(
            value,
            explode: explode,
          ),
    );
  }

  factory ZonesIdOrNamePut200BodyZoneOneOfAllOfModel2.fromJson(
    _i3.Object? json,
  ) {
    return ZonesIdOrNamePut200BodyZoneOneOfAllOfModel2(
      zonesIdOrNamePut200BodyZoneOneOfAllOfModel3:
          _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel3.fromJson(json),
      zonesIdOrNamePut200BodyZoneOneOfAllOfModel6:
          _i5.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel6.fromJson(json),
    );
  }

  final _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel3
  zonesIdOrNamePut200BodyZoneOneOfAllOfModel3;

  final _i5.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel6
  zonesIdOrNamePut200BodyZoneOneOfAllOfModel6;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$zonesIdOrNamePut200BodyZoneOneOfAllOfModel3Json = this
        .zonesIdOrNamePut200BodyZoneOneOfAllOfModel3
        .toJson();
    if (_$zonesIdOrNamePut200BodyZoneOneOfAllOfModel3Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected zonesIdOrNamePut200BodyZoneOneOfAllOfModel3.toJson() to return Map<String, Object?>, got ${_$zonesIdOrNamePut200BodyZoneOneOfAllOfModel3Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$zonesIdOrNamePut200BodyZoneOneOfAllOfModel3Json,
    );
    final _$zonesIdOrNamePut200BodyZoneOneOfAllOfModel6Json = this
        .zonesIdOrNamePut200BodyZoneOneOfAllOfModel6
        .toJson();
    if (_$zonesIdOrNamePut200BodyZoneOneOfAllOfModel6Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected zonesIdOrNamePut200BodyZoneOneOfAllOfModel6.toJson() to return Map<String, Object?>, got ${_$zonesIdOrNamePut200BodyZoneOneOfAllOfModel6Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$zonesIdOrNamePut200BodyZoneOneOfAllOfModel6Json,
    );
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.zonesIdOrNamePut200BodyZoneOneOfAllOfModel3.parameterProperties(
        allowEmpty: allowEmpty,
      ),
    );
    _$mergedProperties.addAll(
      this.zonesIdOrNamePut200BodyZoneOneOfAllOfModel6.parameterProperties(
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
      r'Cannot uriEncode ZonesIdOrNamePut200BodyZoneOneOfAllOfModel2: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesIdOrNamePut200BodyZoneOneOfAllOfModel2 &&
        other.zonesIdOrNamePut200BodyZoneOneOfAllOfModel3 ==
            this.zonesIdOrNamePut200BodyZoneOneOfAllOfModel3 &&
        other.zonesIdOrNamePut200BodyZoneOneOfAllOfModel6 ==
            this.zonesIdOrNamePut200BodyZoneOneOfAllOfModel6;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.zonesIdOrNamePut200BodyZoneOneOfAllOfModel3,
      this.zonesIdOrNamePut200BodyZoneOneOfAllOfModel6,
    ]);
  }

  ZonesIdOrNamePut200BodyZoneOneOfAllOfModel2 Function({
    _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel3?
    zonesIdOrNamePut200BodyZoneOneOfAllOfModel3,
    _i5.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel6?
    zonesIdOrNamePut200BodyZoneOneOfAllOfModel6,
  })
  get copyWith {
    return ({
      _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel3?
      zonesIdOrNamePut200BodyZoneOneOfAllOfModel3,
      _i5.ZonesIdOrNamePut200BodyZoneOneOfAllOfModel6?
      zonesIdOrNamePut200BodyZoneOneOfAllOfModel6,
    }) => ZonesIdOrNamePut200BodyZoneOneOfAllOfModel2(
      zonesIdOrNamePut200BodyZoneOneOfAllOfModel3:
          zonesIdOrNamePut200BodyZoneOneOfAllOfModel3 ??
          this.zonesIdOrNamePut200BodyZoneOneOfAllOfModel3,
      zonesIdOrNamePut200BodyZoneOneOfAllOfModel6:
          zonesIdOrNamePut200BodyZoneOneOfAllOfModel6 ??
          this.zonesIdOrNamePut200BodyZoneOneOfAllOfModel6,
    );
  }
}
