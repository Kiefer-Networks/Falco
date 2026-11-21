// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/target_type_server_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/target_type_server_model2.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TargetTypeServer implements _i1.ParameterEncodable, _i1.UriEncodable {
  const TargetTypeServer({
    required this.targetTypeServerModel,
    required this.targetTypeServerModel2,
  });

  factory TargetTypeServer.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return TargetTypeServer(
      targetTypeServerModel: _i4.TargetTypeServerModel.fromSimple(
        value,
        explode: explode,
        isHeader: isHeader,
      ),
      targetTypeServerModel2: _i5.TargetTypeServerModel2.fromSimple(
        value,
        explode: explode,
        isHeader: isHeader,
      ),
    );
  }

  factory TargetTypeServer.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return TargetTypeServer(
      targetTypeServerModel: _i4.TargetTypeServerModel.fromForm(
        value,
        explode: explode,
      ),
      targetTypeServerModel2: _i5.TargetTypeServerModel2.fromForm(
        value,
        explode: explode,
      ),
    );
  }

  factory TargetTypeServer.fromJson(_i3.Object? json) {
    return TargetTypeServer(
      targetTypeServerModel: _i4.TargetTypeServerModel.fromJson(json),
      targetTypeServerModel2: _i5.TargetTypeServerModel2.fromJson(json),
    );
  }

  final _i4.TargetTypeServerModel targetTypeServerModel;

  final _i5.TargetTypeServerModel2 targetTypeServerModel2;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$targetTypeServerModelJson = this.targetTypeServerModel.toJson();
    if (_$targetTypeServerModelJson is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected targetTypeServerModel.toJson() to return Map<String, Object?>, got ${_$targetTypeServerModelJson.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$targetTypeServerModelJson);
    final _$targetTypeServerModel2Json = this.targetTypeServerModel2.toJson();
    if (_$targetTypeServerModel2Json is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected targetTypeServerModel2.toJson() to return Map<String, Object?>, got ${_$targetTypeServerModel2Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$targetTypeServerModel2Json);
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.targetTypeServerModel.parameterProperties(allowEmpty: allowEmpty),
    );
    _$mergedProperties.addAll(
      this.targetTypeServerModel2.parameterProperties(allowEmpty: allowEmpty),
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
      r'Cannot uriEncode TargetTypeServer: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TargetTypeServer &&
        other.targetTypeServerModel == this.targetTypeServerModel &&
        other.targetTypeServerModel2 == this.targetTypeServerModel2;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.targetTypeServerModel,
      this.targetTypeServerModel2,
    ]);
  }

  TargetTypeServer Function({
    _i4.TargetTypeServerModel? targetTypeServerModel,
    _i5.TargetTypeServerModel2? targetTypeServerModel2,
  })
  get copyWith {
    return ({
      _i4.TargetTypeServerModel? targetTypeServerModel,
      _i5.TargetTypeServerModel2? targetTypeServerModel2,
    }) => TargetTypeServer(
      targetTypeServerModel:
          targetTypeServerModel ?? this.targetTypeServerModel,
      targetTypeServerModel2:
          targetTypeServerModel2 ?? this.targetTypeServerModel2,
    );
  }
}
