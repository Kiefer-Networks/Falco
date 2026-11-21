// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_post_body_body_targets_array_all_of_model2.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_post_body_body_targets_array_all_of_model3.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersPostBodyBodyTargetsArrayAllOfModel
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const LoadBalancersPostBodyBodyTargetsArrayAllOfModel({
    required this.loadBalancersPostBodyBodyTargetsArrayAllOfModel2,
    required this.loadBalancersPostBodyBodyTargetsArrayAllOfModel3,
  });

  factory LoadBalancersPostBodyBodyTargetsArrayAllOfModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return LoadBalancersPostBodyBodyTargetsArrayAllOfModel(
      loadBalancersPostBodyBodyTargetsArrayAllOfModel2:
          _i4.LoadBalancersPostBodyBodyTargetsArrayAllOfModel2.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
      loadBalancersPostBodyBodyTargetsArrayAllOfModel3:
          _i5.LoadBalancersPostBodyBodyTargetsArrayAllOfModel3.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
    );
  }

  factory LoadBalancersPostBodyBodyTargetsArrayAllOfModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return LoadBalancersPostBodyBodyTargetsArrayAllOfModel(
      loadBalancersPostBodyBodyTargetsArrayAllOfModel2:
          _i4.LoadBalancersPostBodyBodyTargetsArrayAllOfModel2.fromForm(
            value,
            explode: explode,
          ),
      loadBalancersPostBodyBodyTargetsArrayAllOfModel3:
          _i5.LoadBalancersPostBodyBodyTargetsArrayAllOfModel3.fromForm(
            value,
            explode: explode,
          ),
    );
  }

  factory LoadBalancersPostBodyBodyTargetsArrayAllOfModel.fromJson(
    _i3.Object? json,
  ) {
    return LoadBalancersPostBodyBodyTargetsArrayAllOfModel(
      loadBalancersPostBodyBodyTargetsArrayAllOfModel2:
          _i4.LoadBalancersPostBodyBodyTargetsArrayAllOfModel2.fromJson(json),
      loadBalancersPostBodyBodyTargetsArrayAllOfModel3:
          _i5.LoadBalancersPostBodyBodyTargetsArrayAllOfModel3.fromJson(json),
    );
  }

  final _i4.LoadBalancersPostBodyBodyTargetsArrayAllOfModel2
  loadBalancersPostBodyBodyTargetsArrayAllOfModel2;

  final _i5.LoadBalancersPostBodyBodyTargetsArrayAllOfModel3
  loadBalancersPostBodyBodyTargetsArrayAllOfModel3;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$loadBalancersPostBodyBodyTargetsArrayAllOfModel2Json = this
        .loadBalancersPostBodyBodyTargetsArrayAllOfModel2
        .toJson();
    if (_$loadBalancersPostBodyBodyTargetsArrayAllOfModel2Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersPostBodyBodyTargetsArrayAllOfModel2.toJson() to return Map<String, Object?>, got ${_$loadBalancersPostBodyBodyTargetsArrayAllOfModel2Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersPostBodyBodyTargetsArrayAllOfModel2Json,
    );
    final _$loadBalancersPostBodyBodyTargetsArrayAllOfModel3Json = this
        .loadBalancersPostBodyBodyTargetsArrayAllOfModel3
        .toJson();
    if (_$loadBalancersPostBodyBodyTargetsArrayAllOfModel3Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersPostBodyBodyTargetsArrayAllOfModel3.toJson() to return Map<String, Object?>, got ${_$loadBalancersPostBodyBodyTargetsArrayAllOfModel3Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersPostBodyBodyTargetsArrayAllOfModel3Json,
    );
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.loadBalancersPostBodyBodyTargetsArrayAllOfModel2.parameterProperties(
        allowEmpty: allowEmpty,
      ),
    );
    _$mergedProperties.addAll(
      this.loadBalancersPostBodyBodyTargetsArrayAllOfModel3.parameterProperties(
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
      r'Cannot uriEncode LoadBalancersPostBodyBodyTargetsArrayAllOfModel: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersPostBodyBodyTargetsArrayAllOfModel &&
        other.loadBalancersPostBodyBodyTargetsArrayAllOfModel2 ==
            this.loadBalancersPostBodyBodyTargetsArrayAllOfModel2 &&
        other.loadBalancersPostBodyBodyTargetsArrayAllOfModel3 ==
            this.loadBalancersPostBodyBodyTargetsArrayAllOfModel3;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.loadBalancersPostBodyBodyTargetsArrayAllOfModel2,
      this.loadBalancersPostBodyBodyTargetsArrayAllOfModel3,
    ]);
  }

  LoadBalancersPostBodyBodyTargetsArrayAllOfModel Function({
    _i4.LoadBalancersPostBodyBodyTargetsArrayAllOfModel2?
    loadBalancersPostBodyBodyTargetsArrayAllOfModel2,
    _i5.LoadBalancersPostBodyBodyTargetsArrayAllOfModel3?
    loadBalancersPostBodyBodyTargetsArrayAllOfModel3,
  })
  get copyWith {
    return ({
      _i4.LoadBalancersPostBodyBodyTargetsArrayAllOfModel2?
      loadBalancersPostBodyBodyTargetsArrayAllOfModel2,
      _i5.LoadBalancersPostBodyBodyTargetsArrayAllOfModel3?
      loadBalancersPostBodyBodyTargetsArrayAllOfModel3,
    }) => LoadBalancersPostBodyBodyTargetsArrayAllOfModel(
      loadBalancersPostBodyBodyTargetsArrayAllOfModel2:
          loadBalancersPostBodyBodyTargetsArrayAllOfModel2 ??
          this.loadBalancersPostBodyBodyTargetsArrayAllOfModel2,
      loadBalancersPostBodyBodyTargetsArrayAllOfModel3:
          loadBalancersPostBodyBodyTargetsArrayAllOfModel3 ??
          this.loadBalancersPostBodyBodyTargetsArrayAllOfModel3,
    );
  }
}
