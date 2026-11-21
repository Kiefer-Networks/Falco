// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/service_tcp_model.dart' as _i4;
import 'package:hetzner_cloud_api/src/model/service_tcp_model2.dart' as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServiceTcp implements _i1.ParameterEncodable, _i1.UriEncodable {
  const ServiceTcp({
    required this.serviceTcpModel,
    required this.serviceTcpModel2,
  });

  factory ServiceTcp.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return ServiceTcp(
      serviceTcpModel: _i4.ServiceTcpModel.fromSimple(
        value,
        explode: explode,
        isHeader: isHeader,
      ),
      serviceTcpModel2: _i5.ServiceTcpModel2.fromSimple(
        value,
        explode: explode,
        isHeader: isHeader,
      ),
    );
  }

  factory ServiceTcp.fromForm(_i3.String? value, {required _i3.bool explode}) {
    return ServiceTcp(
      serviceTcpModel: _i4.ServiceTcpModel.fromForm(value, explode: explode),
      serviceTcpModel2: _i5.ServiceTcpModel2.fromForm(value, explode: explode),
    );
  }

  factory ServiceTcp.fromJson(_i3.Object? json) {
    return ServiceTcp(
      serviceTcpModel: _i4.ServiceTcpModel.fromJson(json),
      serviceTcpModel2: _i5.ServiceTcpModel2.fromJson(json),
    );
  }

  final _i4.ServiceTcpModel serviceTcpModel;

  final _i5.ServiceTcpModel2 serviceTcpModel2;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$serviceTcpModelJson = this.serviceTcpModel.toJson();
    if (_$serviceTcpModelJson is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected serviceTcpModel.toJson() to return Map<String, Object?>, got ${_$serviceTcpModelJson.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$serviceTcpModelJson);
    final _$serviceTcpModel2Json = this.serviceTcpModel2.toJson();
    if (_$serviceTcpModel2Json is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected serviceTcpModel2.toJson() to return Map<String, Object?>, got ${_$serviceTcpModel2Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$serviceTcpModel2Json);
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.serviceTcpModel.parameterProperties(allowEmpty: allowEmpty),
    );
    _$mergedProperties.addAll(
      this.serviceTcpModel2.parameterProperties(allowEmpty: allowEmpty),
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
      r'Cannot uriEncode ServiceTcp: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServiceTcp &&
        other.serviceTcpModel == this.serviceTcpModel &&
        other.serviceTcpModel2 == this.serviceTcpModel2;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.serviceTcpModel, this.serviceTcpModel2]);
  }

  ServiceTcp Function({
    _i4.ServiceTcpModel? serviceTcpModel,
    _i5.ServiceTcpModel2? serviceTcpModel2,
  })
  get copyWith {
    return ({
      _i4.ServiceTcpModel? serviceTcpModel,
      _i5.ServiceTcpModel2? serviceTcpModel2,
    }) => ServiceTcp(
      serviceTcpModel: serviceTcpModel ?? this.serviceTcpModel,
      serviceTcpModel2: serviceTcpModel2 ?? this.serviceTcpModel2,
    );
  }
}
