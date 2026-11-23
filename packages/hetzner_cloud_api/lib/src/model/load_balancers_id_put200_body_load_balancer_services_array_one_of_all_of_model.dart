// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_put200_body_load_balancer_services_array_one_of_all_of_model6.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_put200_body_load_balancer_services_array_one_of_all_of_model7.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel({
    required this.loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6,
    required this.loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7,
  });

  factory LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel(
      loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6:
          _i4.LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
      loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7:
          _i5.LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
    );
  }

  factory LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel(
      loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6:
          _i4.LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6.fromForm(
            value,
            explode: explode,
          ),
      loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7:
          _i5.LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7.fromForm(
            value,
            explode: explode,
          ),
    );
  }

  factory LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel.fromJson(
    _i3.Object? json,
  ) {
    return LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel(
      loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6:
          _i4.LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6.fromJson(
            json,
          ),
      loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7:
          _i5.LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7.fromJson(
            json,
          ),
    );
  }

  final _i4.LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6
  loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6;

  final _i5.LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7
  loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6Json =
        this.loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6
            .toJson();
    if (_$loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6.toJson() to return Map<String, Object?>, got ${_$loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6Json,
    );
    final _$loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7Json =
        this.loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7
            .toJson();
    if (_$loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7.toJson() to return Map<String, Object?>, got ${_$loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7Json,
    );
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6
          .parameterProperties(allowEmpty: allowEmpty),
    );
    _$mergedProperties.addAll(
      this.loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7
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
      r'Cannot uriEncode LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel &&
        other.loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6 ==
            this.loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6 &&
        other.loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7 ==
            this.loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6,
      this.loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7,
    ]);
  }

  LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel Function({
    _i4.LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6?
    loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6,
    _i5.LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7?
    loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7,
  })
  get copyWith {
    return ({
      _i4.LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6?
      loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6,
      _i5.LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7?
      loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7,
    }) => LoadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel(
      loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6:
          loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6 ??
          this.loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel6,
      loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7:
          loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7 ??
          this.loadBalancersIdPut200BodyLoadBalancerServicesArrayOneOfAllOfModel7,
    );
  }
}
