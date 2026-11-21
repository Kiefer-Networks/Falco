// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/service_https_protocol_http_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/service_https_protocol_protocol_model2.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServiceHttpsProtocolModel2 extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServiceHttpsProtocolModel2({required this.http, this.protocol});

  factory ServiceHttpsProtocolModel2.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServiceHttpsProtocolModel2: contains complex types',
    );
  }

  factory ServiceHttpsProtocolModel2.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ServiceHttpsProtocolModel2');
    return ServiceHttpsProtocolModel2(
      protocol: _$map[r'protocol'] == null
          ? null
          : _i4.ServiceHttpsProtocolProtocolModel2.fromJson(_$map[r'protocol']),
      http: _i5.ServiceHttpsProtocolHttpModel.fromJson(_$map[r'http']),
    );
  }

  factory ServiceHttpsProtocolModel2.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServiceHttpsProtocolModel2: contains complex types',
    );
  }

  /// **Example**:
  /// ```
  /// https
  /// ```
  final _i4.ServiceHttpsProtocolProtocolModel2? protocol;

  /// Configuration option for protocol https.
  final _i5.ServiceHttpsProtocolHttpModel http;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.protocol != null) r'protocol': this.protocol?.toJson(),
    r'http': this.http.toJson(),
  };

  ServiceHttpsProtocolModel2 Function({
    _i4.ServiceHttpsProtocolProtocolModel2? protocol,
    _i5.ServiceHttpsProtocolHttpModel? http,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? protocol = _sentinel,
      _i5.ServiceHttpsProtocolHttpModel? http,
    }) => ServiceHttpsProtocolModel2(
      protocol: _i3.identical(protocol, _sentinel)
          ? this.protocol
          : (protocol as _i4.ServiceHttpsProtocolProtocolModel2?),
      http: http ?? this.http,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServiceHttpsProtocolModel2 &&
        other.protocol == this.protocol &&
        other.http == this.http;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.protocol, this.http]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServiceHttpsProtocolModel2: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServiceHttpsProtocolModel2: complex types cannot be URI-encoded',
    );
  }
}
