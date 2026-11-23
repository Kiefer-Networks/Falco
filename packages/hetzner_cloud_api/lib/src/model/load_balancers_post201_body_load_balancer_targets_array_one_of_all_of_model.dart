// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_targets_array_one_of_all_of_model6.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_targets_array_one_of_all_of_model7.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel({
    required this.loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6,
    required this.loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7,
  });

  factory LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel(
      loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6:
          _i4.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
      loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7:
          _i5.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel(
      loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6:
          _i4.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6.fromForm(
            value,
            explode: explode,
          ),
      loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7:
          _i5.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7.fromForm(
            value,
            explode: explode,
          ),
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel.fromJson(
    _i3.Object? json,
  ) {
    return LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel(
      loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6:
          _i4.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6.fromJson(
            json,
          ),
      loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7:
          _i5.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7.fromJson(
            json,
          ),
    );
  }

  final _i4.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6
  loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6;

  final _i5.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7
  loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6Json =
        this.loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6
            .toJson();
    if (_$loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6.toJson() to return Map<String, Object?>, got ${_$loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6Json,
    );
    final _$loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7Json =
        this.loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7
            .toJson();
    if (_$loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7.toJson() to return Map<String, Object?>, got ${_$loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7Json,
    );
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6
          .parameterProperties(allowEmpty: allowEmpty),
    );
    _$mergedProperties.addAll(
      this.loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7
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
      r'Cannot uriEncode LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel &&
        other.loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6 ==
            this.loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6 &&
        other.loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7 ==
            this.loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6,
      this.loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7,
    ]);
  }

  LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel Function({
    _i4.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6?
    loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6,
    _i5.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7?
    loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7,
  })
  get copyWith {
    return ({
      _i4.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6?
      loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6,
      _i5.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7?
      loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7,
    }) => LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel(
      loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6:
          loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6 ??
          this.loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel6,
      loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7:
          loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7 ??
          this.loadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel7,
    );
  }
}
