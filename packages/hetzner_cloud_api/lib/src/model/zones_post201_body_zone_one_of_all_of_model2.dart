// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_post201_body_zone_one_of_all_of_model3.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_post201_body_zone_one_of_all_of_model6.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesPost201BodyZoneOneOfAllOfModel2
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const ZonesPost201BodyZoneOneOfAllOfModel2({
    required this.zonesPost201BodyZoneOneOfAllOfModel3,
    required this.zonesPost201BodyZoneOneOfAllOfModel6,
  });

  factory ZonesPost201BodyZoneOneOfAllOfModel2.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return ZonesPost201BodyZoneOneOfAllOfModel2(
      zonesPost201BodyZoneOneOfAllOfModel3:
          _i4.ZonesPost201BodyZoneOneOfAllOfModel3.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
      zonesPost201BodyZoneOneOfAllOfModel6:
          _i5.ZonesPost201BodyZoneOneOfAllOfModel6.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
    );
  }

  factory ZonesPost201BodyZoneOneOfAllOfModel2.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return ZonesPost201BodyZoneOneOfAllOfModel2(
      zonesPost201BodyZoneOneOfAllOfModel3:
          _i4.ZonesPost201BodyZoneOneOfAllOfModel3.fromForm(
            value,
            explode: explode,
          ),
      zonesPost201BodyZoneOneOfAllOfModel6:
          _i5.ZonesPost201BodyZoneOneOfAllOfModel6.fromForm(
            value,
            explode: explode,
          ),
    );
  }

  factory ZonesPost201BodyZoneOneOfAllOfModel2.fromJson(_i3.Object? json) {
    return ZonesPost201BodyZoneOneOfAllOfModel2(
      zonesPost201BodyZoneOneOfAllOfModel3:
          _i4.ZonesPost201BodyZoneOneOfAllOfModel3.fromJson(json),
      zonesPost201BodyZoneOneOfAllOfModel6:
          _i5.ZonesPost201BodyZoneOneOfAllOfModel6.fromJson(json),
    );
  }

  final _i4.ZonesPost201BodyZoneOneOfAllOfModel3
  zonesPost201BodyZoneOneOfAllOfModel3;

  final _i5.ZonesPost201BodyZoneOneOfAllOfModel6
  zonesPost201BodyZoneOneOfAllOfModel6;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$zonesPost201BodyZoneOneOfAllOfModel3Json = this
        .zonesPost201BodyZoneOneOfAllOfModel3
        .toJson();
    if (_$zonesPost201BodyZoneOneOfAllOfModel3Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected zonesPost201BodyZoneOneOfAllOfModel3.toJson() to return Map<String, Object?>, got ${_$zonesPost201BodyZoneOneOfAllOfModel3Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$zonesPost201BodyZoneOneOfAllOfModel3Json);
    final _$zonesPost201BodyZoneOneOfAllOfModel6Json = this
        .zonesPost201BodyZoneOneOfAllOfModel6
        .toJson();
    if (_$zonesPost201BodyZoneOneOfAllOfModel6Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected zonesPost201BodyZoneOneOfAllOfModel6.toJson() to return Map<String, Object?>, got ${_$zonesPost201BodyZoneOneOfAllOfModel6Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$zonesPost201BodyZoneOneOfAllOfModel6Json);
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.zonesPost201BodyZoneOneOfAllOfModel3.parameterProperties(
        allowEmpty: allowEmpty,
      ),
    );
    _$mergedProperties.addAll(
      this.zonesPost201BodyZoneOneOfAllOfModel6.parameterProperties(
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
      r'Cannot uriEncode ZonesPost201BodyZoneOneOfAllOfModel2: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesPost201BodyZoneOneOfAllOfModel2 &&
        other.zonesPost201BodyZoneOneOfAllOfModel3 ==
            this.zonesPost201BodyZoneOneOfAllOfModel3 &&
        other.zonesPost201BodyZoneOneOfAllOfModel6 ==
            this.zonesPost201BodyZoneOneOfAllOfModel6;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.zonesPost201BodyZoneOneOfAllOfModel3,
      this.zonesPost201BodyZoneOneOfAllOfModel6,
    ]);
  }

  ZonesPost201BodyZoneOneOfAllOfModel2 Function({
    _i4.ZonesPost201BodyZoneOneOfAllOfModel3?
    zonesPost201BodyZoneOneOfAllOfModel3,
    _i5.ZonesPost201BodyZoneOneOfAllOfModel6?
    zonesPost201BodyZoneOneOfAllOfModel6,
  })
  get copyWith {
    return ({
      _i4.ZonesPost201BodyZoneOneOfAllOfModel3?
      zonesPost201BodyZoneOneOfAllOfModel3,
      _i5.ZonesPost201BodyZoneOneOfAllOfModel6?
      zonesPost201BodyZoneOneOfAllOfModel6,
    }) => ZonesPost201BodyZoneOneOfAllOfModel2(
      zonesPost201BodyZoneOneOfAllOfModel3:
          zonesPost201BodyZoneOneOfAllOfModel3 ??
          this.zonesPost201BodyZoneOneOfAllOfModel3,
      zonesPost201BodyZoneOneOfAllOfModel6:
          zonesPost201BodyZoneOneOfAllOfModel6 ??
          this.zonesPost201BodyZoneOneOfAllOfModel6,
    );
  }
}
