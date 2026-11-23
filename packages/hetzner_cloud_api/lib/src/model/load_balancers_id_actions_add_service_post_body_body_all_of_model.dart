// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_add_service_post_body_body_all_of_model2.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_add_service_post_body_body_all_of_model3.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel({
    required this.loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3,
    required this.loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2,
  });

  factory LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel(
      loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2:
          _i4.LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
      loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3:
          _i5.LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel3.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
    );
  }

  factory LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel(
      loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2:
          _i4.LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2.fromForm(
            value,
            explode: explode,
          ),
      loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3:
          _i5.LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel3.fromForm(
            value,
            explode: explode,
          ),
    );
  }

  factory LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel.fromJson(
    _i3.Object? json,
  ) {
    return LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel(
      loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2:
          _i4.LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2.fromJson(
            json,
          ),
      loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3:
          _i5.LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel3.fromJson(
            json,
          ),
    );
  }

  final _i5.LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel3
  loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3;

  final _i4.LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2
  loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2Json = this
        .loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2
        .toJson();
    if (_$loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2.toJson() to return Map<String, Object?>, got ${_$loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2Json,
    );
    final _$loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3Json = this
        .loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3
        .toJson();
    if (_$loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3.toJson() to return Map<String, Object?>, got ${_$loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3Json,
    );
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2
          .parameterProperties(allowEmpty: allowEmpty),
    );
    _$mergedProperties.addAll(
      this.loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3
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
      r'Cannot uriEncode LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel &&
        other.loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3 ==
            this.loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3 &&
        other.loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2 ==
            this.loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3,
      this.loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2,
    ]);
  }

  LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel Function({
    _i5.LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel3?
    loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3,
    _i4.LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2?
    loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2,
  })
  get copyWith {
    return ({
      _i5.LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel3?
      loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3,
      _i4.LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel2?
      loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2,
    }) => LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel(
      loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3:
          loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3 ??
          this.loadBalancersIdActionsAddServicePostBodyBodyAllOfModel3,
      loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2:
          loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2 ??
          this.loadBalancersIdActionsAddServicePostBodyBodyAllOfModel2,
    );
  }
}
