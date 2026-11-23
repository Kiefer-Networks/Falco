// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/target_type_ip_model.dart' as _i4;
import 'package:hetzner_cloud_api/src/model/target_type_ip_model2.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TargetTypeIp implements _i1.ParameterEncodable, _i1.UriEncodable {
  const TargetTypeIp({
    required this.targetTypeIpModel,
    required this.targetTypeIpModel2,
  });

  factory TargetTypeIp.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return TargetTypeIp(
      targetTypeIpModel: _i4.TargetTypeIpModel.fromSimple(
        value,
        explode: explode,
        isHeader: isHeader,
      ),
      targetTypeIpModel2: _i5.TargetTypeIpModel2.fromSimple(
        value,
        explode: explode,
        isHeader: isHeader,
      ),
    );
  }

  factory TargetTypeIp.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return TargetTypeIp(
      targetTypeIpModel: _i4.TargetTypeIpModel.fromForm(
        value,
        explode: explode,
      ),
      targetTypeIpModel2: _i5.TargetTypeIpModel2.fromForm(
        value,
        explode: explode,
      ),
    );
  }

  factory TargetTypeIp.fromJson(_i3.Object? json) {
    return TargetTypeIp(
      targetTypeIpModel: _i4.TargetTypeIpModel.fromJson(json),
      targetTypeIpModel2: _i5.TargetTypeIpModel2.fromJson(json),
    );
  }

  final _i4.TargetTypeIpModel targetTypeIpModel;

  final _i5.TargetTypeIpModel2 targetTypeIpModel2;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$targetTypeIpModelJson = this.targetTypeIpModel.toJson();
    if (_$targetTypeIpModelJson is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected targetTypeIpModel.toJson() to return Map<String, Object?>, got ${_$targetTypeIpModelJson.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$targetTypeIpModelJson);
    final _$targetTypeIpModel2Json = this.targetTypeIpModel2.toJson();
    if (_$targetTypeIpModel2Json is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected targetTypeIpModel2.toJson() to return Map<String, Object?>, got ${_$targetTypeIpModel2Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$targetTypeIpModel2Json);
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.targetTypeIpModel.parameterProperties(allowEmpty: allowEmpty),
    );
    _$mergedProperties.addAll(
      this.targetTypeIpModel2.parameterProperties(allowEmpty: allowEmpty),
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
      r'Cannot uriEncode TargetTypeIp: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TargetTypeIp &&
        other.targetTypeIpModel == this.targetTypeIpModel &&
        other.targetTypeIpModel2 == this.targetTypeIpModel2;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.targetTypeIpModel,
      this.targetTypeIpModel2,
    ]);
  }

  TargetTypeIp Function({
    _i4.TargetTypeIpModel? targetTypeIpModel,
    _i5.TargetTypeIpModel2? targetTypeIpModel2,
  })
  get copyWith {
    return ({
      _i4.TargetTypeIpModel? targetTypeIpModel,
      _i5.TargetTypeIpModel2? targetTypeIpModel2,
    }) => TargetTypeIp(
      targetTypeIpModel: targetTypeIpModel ?? this.targetTypeIpModel,
      targetTypeIpModel2: targetTypeIpModel2 ?? this.targetTypeIpModel2,
    );
  }
}
