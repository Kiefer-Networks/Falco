// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/service_http_protocol_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/service_http_protocol_model2.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServiceHttpProtocol implements _i1.ParameterEncodable, _i1.UriEncodable {
  const ServiceHttpProtocol({
    required this.serviceHttpProtocolModel,
    required this.serviceHttpProtocolModel2,
  });

  factory ServiceHttpProtocol.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return ServiceHttpProtocol(
      serviceHttpProtocolModel: _i4.ServiceHttpProtocolModel.fromSimple(
        value,
        explode: explode,
        isHeader: isHeader,
      ),
      serviceHttpProtocolModel2: _i5.ServiceHttpProtocolModel2.fromSimple(
        value,
        explode: explode,
        isHeader: isHeader,
      ),
    );
  }

  factory ServiceHttpProtocol.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return ServiceHttpProtocol(
      serviceHttpProtocolModel: _i4.ServiceHttpProtocolModel.fromForm(
        value,
        explode: explode,
      ),
      serviceHttpProtocolModel2: _i5.ServiceHttpProtocolModel2.fromForm(
        value,
        explode: explode,
      ),
    );
  }

  factory ServiceHttpProtocol.fromJson(_i3.Object? json) {
    return ServiceHttpProtocol(
      serviceHttpProtocolModel: _i4.ServiceHttpProtocolModel.fromJson(json),
      serviceHttpProtocolModel2: _i5.ServiceHttpProtocolModel2.fromJson(json),
    );
  }

  final _i4.ServiceHttpProtocolModel serviceHttpProtocolModel;

  final _i5.ServiceHttpProtocolModel2 serviceHttpProtocolModel2;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$serviceHttpProtocolModelJson = this.serviceHttpProtocolModel
        .toJson();
    if (_$serviceHttpProtocolModelJson is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected serviceHttpProtocolModel.toJson() to return Map<String, Object?>, got ${_$serviceHttpProtocolModelJson.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$serviceHttpProtocolModelJson);
    final _$serviceHttpProtocolModel2Json = this.serviceHttpProtocolModel2
        .toJson();
    if (_$serviceHttpProtocolModel2Json is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected serviceHttpProtocolModel2.toJson() to return Map<String, Object?>, got ${_$serviceHttpProtocolModel2Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$serviceHttpProtocolModel2Json);
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.serviceHttpProtocolModel.parameterProperties(allowEmpty: allowEmpty),
    );
    _$mergedProperties.addAll(
      this.serviceHttpProtocolModel2.parameterProperties(
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
      r'Cannot uriEncode ServiceHttpProtocol: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServiceHttpProtocol &&
        other.serviceHttpProtocolModel == this.serviceHttpProtocolModel &&
        other.serviceHttpProtocolModel2 == this.serviceHttpProtocolModel2;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.serviceHttpProtocolModel,
      this.serviceHttpProtocolModel2,
    ]);
  }

  ServiceHttpProtocol Function({
    _i4.ServiceHttpProtocolModel? serviceHttpProtocolModel,
    _i5.ServiceHttpProtocolModel2? serviceHttpProtocolModel2,
  })
  get copyWith {
    return ({
      _i4.ServiceHttpProtocolModel? serviceHttpProtocolModel,
      _i5.ServiceHttpProtocolModel2? serviceHttpProtocolModel2,
    }) => ServiceHttpProtocol(
      serviceHttpProtocolModel:
          serviceHttpProtocolModel ?? this.serviceHttpProtocolModel,
      serviceHttpProtocolModel2:
          serviceHttpProtocolModel2 ?? this.serviceHttpProtocolModel2,
    );
  }
}
