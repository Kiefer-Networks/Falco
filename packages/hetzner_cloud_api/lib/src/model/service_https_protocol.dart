// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/service_https_protocol_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/service_https_protocol_model2.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServiceHttpsProtocol implements _i1.ParameterEncodable, _i1.UriEncodable {
  const ServiceHttpsProtocol({
    required this.serviceHttpsProtocolModel,
    required this.serviceHttpsProtocolModel2,
  });

  factory ServiceHttpsProtocol.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    return ServiceHttpsProtocol(
      serviceHttpsProtocolModel: _i4.ServiceHttpsProtocolModel.fromSimple(
        value,
        explode: explode,
        isHeader: isHeader,
      ),
      serviceHttpsProtocolModel2: _i5.ServiceHttpsProtocolModel2.fromSimple(
        value,
        explode: explode,
        isHeader: isHeader,
      ),
    );
  }

  factory ServiceHttpsProtocol.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    return ServiceHttpsProtocol(
      serviceHttpsProtocolModel: _i4.ServiceHttpsProtocolModel.fromForm(
        value,
        explode: explode,
      ),
      serviceHttpsProtocolModel2: _i5.ServiceHttpsProtocolModel2.fromForm(
        value,
        explode: explode,
      ),
    );
  }

  factory ServiceHttpsProtocol.fromJson(_i3.Object? json) {
    return ServiceHttpsProtocol(
      serviceHttpsProtocolModel: _i4.ServiceHttpsProtocolModel.fromJson(json),
      serviceHttpsProtocolModel2: _i5.ServiceHttpsProtocolModel2.fromJson(json),
    );
  }

  final _i4.ServiceHttpsProtocolModel serviceHttpsProtocolModel;

  final _i5.ServiceHttpsProtocolModel2 serviceHttpsProtocolModel2;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Object? toJson() {
    final _$map = <_i3.String, _i3.Object?>{};
    final _$serviceHttpsProtocolModelJson = this.serviceHttpsProtocolModel
        .toJson();
    if (_$serviceHttpsProtocolModelJson is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected serviceHttpsProtocolModel.toJson() to return Map<String, Object?>, got ${_$serviceHttpsProtocolModelJson.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$serviceHttpsProtocolModelJson);
    final _$serviceHttpsProtocolModel2Json = this.serviceHttpsProtocolModel2
        .toJson();
    if (_$serviceHttpsProtocolModel2Json is! _i3.Map<_i3.String, _i3.Object?>) {
      throw _i1.EncodingException(
        'Expected serviceHttpsProtocolModel2.toJson() to return Map<String, Object?>, got ${_$serviceHttpsProtocolModel2Json.runtimeType}',
      );
    }
    _i1.mergeJsonObject(_$map, _$serviceHttpsProtocolModel2Json);
    return _$map;
  }

  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$mergedProperties = <_i3.String, _i1.PropertyValue>{};
    _$mergedProperties.addAll(
      this.serviceHttpsProtocolModel.parameterProperties(
        allowEmpty: allowEmpty,
      ),
    );
    _$mergedProperties.addAll(
      this.serviceHttpsProtocolModel2.parameterProperties(
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
      r'Cannot uriEncode ServiceHttpsProtocol: contains complex types',
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServiceHttpsProtocol &&
        other.serviceHttpsProtocolModel == this.serviceHttpsProtocolModel &&
        other.serviceHttpsProtocolModel2 == this.serviceHttpsProtocolModel2;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.serviceHttpsProtocolModel,
      this.serviceHttpsProtocolModel2,
    ]);
  }

  ServiceHttpsProtocol Function({
    _i4.ServiceHttpsProtocolModel? serviceHttpsProtocolModel,
    _i5.ServiceHttpsProtocolModel2? serviceHttpsProtocolModel2,
  })
  get copyWith {
    return ({
      _i4.ServiceHttpsProtocolModel? serviceHttpsProtocolModel,
      _i5.ServiceHttpsProtocolModel2? serviceHttpsProtocolModel2,
    }) => ServiceHttpsProtocol(
      serviceHttpsProtocolModel:
          serviceHttpsProtocolModel ?? this.serviceHttpsProtocolModel,
      serviceHttpsProtocolModel2:
          serviceHttpsProtocolModel2 ?? this.serviceHttpsProtocolModel2,
    );
  }
}
