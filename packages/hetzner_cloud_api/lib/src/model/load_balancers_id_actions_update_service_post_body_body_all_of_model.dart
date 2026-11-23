// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_update_service_post_body_body_all_of_model2.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_update_service_post_body_body_all_of_model3.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel({
    required this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3,
    required this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2,
  });

  factory LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel(
      loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2:
          _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
      loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3:
          _i5.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
    );
  }

  factory LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel(
      loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2:
          _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2.fromForm(
            value,
            explode: explode,
          ),
      loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3:
          _i5.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3.fromForm(
            value,
            explode: explode,
          ),
    );
  }

  factory LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel.fromJson(
    _i3.Object? json,
  ) {
    return LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel(
      loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2:
          _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2.fromJson(
            json,
          ),
      loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3:
          _i5.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3.fromJson(
            json,
          ),
    );
  }

  final _i5.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3
  loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3;

  final _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2
  loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2Json =
        this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2
            .toJson();
    if (_$loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2.toJson() to return Map<String, Object?>, got ${_$loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2Json,
    );
    final _$loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3Json =
        this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3
            .toJson();
    if (_$loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3.toJson() to return Map<String, Object?>, got ${_$loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3Json,
    );
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2
          .parameterProperties(allowEmpty: allowEmpty),
    );
    _$mergedProperties.addAll(
      this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3
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
      r'Cannot uriEncode LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel &&
        other.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3 ==
            this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3 &&
        other.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2 ==
            this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3,
      this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2,
    ]);
  }

  LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel Function({
    _i5.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3?
    loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3,
    _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2?
    loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2,
  })
  get copyWith {
    return ({
      _i5.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3?
      loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3,
      _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2?
      loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2,
    }) => LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel(
      loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3:
          loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3 ??
          this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3,
      loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2:
          loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2 ??
          this.loadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2,
    );
  }
}
