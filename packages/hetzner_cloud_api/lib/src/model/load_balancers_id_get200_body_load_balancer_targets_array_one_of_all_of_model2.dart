// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_targets_array_one_of_all_of_model5.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_targets_array_one_of_all_of_model8.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel2
    implements _i1.ParameterEncodable, _i1.UriEncodable {
  const LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel2({
    required this.loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5,
    required this.loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8,
  });

  factory LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel2.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel2(
      loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5:
          _i4.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
      loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8:
          _i5.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8.fromSimple(
            value,
            explode: explode,
            isHeader: isHeader,
          ),
    );
  }

  factory LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel2.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel2(
      loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5:
          _i4.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5.fromForm(
            value,
            explode: explode,
          ),
      loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8:
          _i5.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8.fromForm(
            value,
            explode: explode,
          ),
    );
  }

  factory LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel2.fromJson(
    _i3.Object? json,
  ) {
    return LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel2(
      loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5:
          _i4.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5.fromJson(
            json,
          ),
      loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8:
          _i5.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8.fromJson(
            json,
          ),
    );
  }

  final _i4.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5
  loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5;

  final _i5.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8
  loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5Json =
        this.loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5
            .toJson();
    if (_$loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5.toJson() to return Map<String, Object?>, got ${_$loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5Json,
    );
    final _$loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8Json =
        this.loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8
            .toJson();
    if (_$loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8Json
        is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8.toJson() to return Map<String, Object?>, got ${_$loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(
      _$map,
      _$loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8Json,
    );
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5
          .parameterProperties(allowEmpty: allowEmpty),
    );
    _$mergedProperties.addAll(
      this.loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8
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
      r'Cannot uriEncode LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel2: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel2 &&
        other.loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5 ==
            this.loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5 &&
        other.loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8 ==
            this.loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5,
      this.loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8,
    ]);
  }

  LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel2 Function({
    _i4.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5?
    loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5,
    _i5.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8?
    loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8,
  })
  get copyWith {
    return ({
      _i4.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5?
      loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5,
      _i5.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8?
      loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8,
    }) => LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel2(
      loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5:
          loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5 ??
          this.loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5,
      loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8:
          loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8 ??
          this.loadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel8,
    );
  }
}
