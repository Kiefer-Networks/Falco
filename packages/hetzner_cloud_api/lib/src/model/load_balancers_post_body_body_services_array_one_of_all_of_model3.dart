// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_post_body_body_services_array_one_of_all_of_model4.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_post_body_body_services_array_one_of_all_of_model9.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel3
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel3({
    required this.loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4,
    required this.loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9,
  });

  factory LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel3.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel3(
      loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4:
          _i4.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
      loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9:
          _i5.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
    );
  }

  factory LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel3.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel3(
      loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4:
          _i4.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4.fromForm(
            value,
            explode: explode,
          ),
      loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9:
          _i5.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9.fromForm(
            value,
            explode: explode,
          ),
    );
  }

  factory LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel3.fromJson(
    _i3.Object? json,
  ) {
    return LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel3(
      loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4:
          _i4.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4.fromJson(
            json,
          ),
      loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9:
          _i5.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9.fromJson(
            json,
          ),
    );
  }

  final _i4.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4
  loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4;

  final _i5.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9
  loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4Json = this
        .loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4
        .toJson();
    if (_$loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4.toJson() to return Map<String, Object?>, got ${_$loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4Json,
    );
    final _$loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9Json = this
        .loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9
        .toJson();
    if (_$loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9.toJson() to return Map<String, Object?>, got ${_$loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9Json,
    );
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4
          .parameterProperties(allowEmpty: allowEmpty),
    );
    _$mergedProperties.addAll(
      this.loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9
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
      r'Cannot uriEncode LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel3: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel3 &&
        other.loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4 ==
            this.loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4 &&
        other.loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9 ==
            this.loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4,
      this.loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9,
    ]);
  }

  LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel3 Function({
    _i4.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4?
    loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4,
    _i5.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9?
    loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9,
  })
  get copyWith {
    return ({
      _i4.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4?
      loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4,
      _i5.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9?
      loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9,
    }) => LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel3(
      loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4:
          loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4 ??
          this.loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel4,
      loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9:
          loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9 ??
          this.loadBalancersPostBodyBodyServicesArrayOneOfAllOfModel9,
    );
  }
}
