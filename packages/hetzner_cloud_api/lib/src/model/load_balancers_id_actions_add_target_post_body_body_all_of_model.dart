// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_add_target_post_body_body_all_of_model2.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_add_target_post_body_body_all_of_model3.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel({
    required this.loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2,
    required this.loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3,
  });

  factory LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel(
      loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2:
          _i4.LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
      loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3:
          _i5.LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
    );
  }

  factory LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel(
      loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2:
          _i4.LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2.fromForm(
            value,
            explode: explode,
          ),
      loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3:
          _i5.LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3.fromForm(
            value,
            explode: explode,
          ),
    );
  }

  factory LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel.fromJson(
    _i3.Object? json,
  ) {
    return LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel(
      loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2:
          _i4.LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2.fromJson(
            json,
          ),
      loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3:
          _i5.LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3.fromJson(
            json,
          ),
    );
  }

  final _i4.LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2
  loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2;

  final _i5.LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3
  loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2Json = this
        .loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2
        .toJson();
    if (_$loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2.toJson() to return Map<String, Object?>, got ${_$loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2Json,
    );
    final _$loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3Json = this
        .loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3
        .toJson();
    if (_$loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3.toJson() to return Map<String, Object?>, got ${_$loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3Json,
    );
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2
          .parameterProperties(allowEmpty: allowEmpty),
    );
    _$mergedProperties.addAll(
      this.loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3
          .parameterProperties(allowEmpty: allowEmpty),
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
      r'Cannot uriEncode LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel &&
        other.loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2 ==
            this.loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2 &&
        other.loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3 ==
            this.loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2,
      this.loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3,
    ]);
  }

  LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel Function({
    _i4.LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2?
    loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2,
    _i5.LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3?
    loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3,
  })
  get copyWith {
    return ({
      _i4.LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2?
      loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2,
      _i5.LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3?
      loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3,
    }) => LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel(
      loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2:
          loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2 ??
          this.loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel2,
      loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3:
          loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3 ??
          this.loadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3,
    );
  }
}
