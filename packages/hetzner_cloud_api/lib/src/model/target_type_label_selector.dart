// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/target_type_label_selector_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/target_type_label_selector_model2.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class TargetTypeLabelSelector
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const TargetTypeLabelSelector({
    required this.targetTypeLabelSelectorModel,
    required this.targetTypeLabelSelectorModel2,
  });

  factory TargetTypeLabelSelector.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return TargetTypeLabelSelector(
      targetTypeLabelSelectorModel: _i4.TargetTypeLabelSelectorModel.fromSimple(
        value,
        explode: explode,
        isHeader: isHeader,
      ),
      targetTypeLabelSelectorModel2:
          _i5.TargetTypeLabelSelectorModel2.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
    );
  }

  factory TargetTypeLabelSelector.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return TargetTypeLabelSelector(
      targetTypeLabelSelectorModel: _i4.TargetTypeLabelSelectorModel.fromForm(
        value,
        explode: explode,
      ),
      targetTypeLabelSelectorModel2: _i5.TargetTypeLabelSelectorModel2.fromForm(
        value,
        explode: explode,
      ),
    );
  }

  factory TargetTypeLabelSelector.fromJson(_i3.Object? json) {
    return TargetTypeLabelSelector(
      targetTypeLabelSelectorModel: _i4.TargetTypeLabelSelectorModel.fromJson(
        json,
      ),
      targetTypeLabelSelectorModel2: _i5.TargetTypeLabelSelectorModel2.fromJson(
        json,
      ),
    );
  }

  final _i4.TargetTypeLabelSelectorModel targetTypeLabelSelectorModel;

  final _i5.TargetTypeLabelSelectorModel2 targetTypeLabelSelectorModel2;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$targetTypeLabelSelectorModelJson = this.targetTypeLabelSelectorModel
        .toJson();
    if (_$targetTypeLabelSelectorModelJson
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected targetTypeLabelSelectorModel.toJson() to return Map<String, Object?>, got ${_$targetTypeLabelSelectorModelJson.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$targetTypeLabelSelectorModelJson);
    final _$targetTypeLabelSelectorModel2Json = this
        .targetTypeLabelSelectorModel2
        .toJson();
    if (_$targetTypeLabelSelectorModel2Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected targetTypeLabelSelectorModel2.toJson() to return Map<String, Object?>, got ${_$targetTypeLabelSelectorModel2Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$targetTypeLabelSelectorModel2Json);
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.targetTypeLabelSelectorModel.parameterProperties(
        allowEmpty: allowEmpty,
      ),
    );
    _$mergedProperties.addAll(
      this.targetTypeLabelSelectorModel2.parameterProperties(
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
      r'Cannot uriEncode TargetTypeLabelSelector: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is TargetTypeLabelSelector &&
        other.targetTypeLabelSelectorModel ==
            this.targetTypeLabelSelectorModel &&
        other.targetTypeLabelSelectorModel2 ==
            this.targetTypeLabelSelectorModel2;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.targetTypeLabelSelectorModel,
      this.targetTypeLabelSelectorModel2,
    ]);
  }

  TargetTypeLabelSelector Function({
    _i4.TargetTypeLabelSelectorModel? targetTypeLabelSelectorModel,
    _i5.TargetTypeLabelSelectorModel2? targetTypeLabelSelectorModel2,
  })
  get copyWith {
    return ({
      _i4.TargetTypeLabelSelectorModel? targetTypeLabelSelectorModel,
      _i5.TargetTypeLabelSelectorModel2? targetTypeLabelSelectorModel2,
    }) => TargetTypeLabelSelector(
      targetTypeLabelSelectorModel:
          targetTypeLabelSelectorModel ?? this.targetTypeLabelSelectorModel,
      targetTypeLabelSelectorModel2:
          targetTypeLabelSelectorModel2 ?? this.targetTypeLabelSelectorModel2,
    );
  }
}
