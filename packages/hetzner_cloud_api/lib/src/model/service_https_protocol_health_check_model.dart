// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/service_https_protocol_health_check_http_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/service_https_protocol_health_check_protocol_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Service health check.
@_i2.immutable
class ServiceHttpsProtocolHealthCheckModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServiceHttpsProtocolHealthCheckModel({
    required this.protocol,
    required this.port,
    required this.interval,
    required this.timeout,
    required this.retries,
    this.http,
  });

  factory ServiceHttpsProtocolHealthCheckModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServiceHttpsProtocolHealthCheckModel: contains complex types',
    );
  }

  factory ServiceHttpsProtocolHealthCheckModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'ServiceHttpsProtocolHealthCheckModel',
    );
    return ServiceHttpsProtocolHealthCheckModel(
      protocol: _i4.ServiceHttpsProtocolHealthCheckProtocolModel.fromJson(
        _$map[r'protocol'],
      ),
      port: _$map[r'port'].decodeJsonInt(
        context: r'ServiceHttpsProtocolHealthCheckModel.port',
      ),
      interval: _$map[r'interval'].decodeJsonInt(
        context: r'ServiceHttpsProtocolHealthCheckModel.interval',
      ),
      timeout: _$map[r'timeout'].decodeJsonInt(
        context: r'ServiceHttpsProtocolHealthCheckModel.timeout',
      ),
      retries: _$map[r'retries'].decodeJsonInt(
        context: r'ServiceHttpsProtocolHealthCheckModel.retries',
      ),
      http: _$map[r'http'] == null
          ? null
          : _i5.ServiceHttpsProtocolHealthCheckHttpModel.fromJson(
              _$map[r'http'],
            ),
    );
  }

  factory ServiceHttpsProtocolHealthCheckModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServiceHttpsProtocolHealthCheckModel: contains complex types',
    );
  }

  /// Type of the health check.
  ///
  /// **Example**:
  /// ```
  /// http
  /// ```
  final _i4.ServiceHttpsProtocolHealthCheckProtocolModel protocol;

  /// Port the health check will be performed on.
  ///
  /// **Example**:
  /// ```json
  /// 4711
  /// ```
  final _i3.int port;

  /// Time interval in seconds health checks are performed.
  ///
  /// **Example**:
  /// ```json
  /// 15
  /// ```
  final _i3.int interval;

  /// Time in seconds after an attempt is considered a timeout.
  ///
  /// **Example**:
  /// ```json
  /// 10
  /// ```
  final _i3.int timeout;

  /// Unsuccessful retries needed until a target is considered unhealthy; an unhealthy target needs the same number of successful retries to become healthy again.
  ///
  /// **Example**:
  /// ```json
  /// 3
  /// ```
  final _i3.int retries;

  /// Additional configuration for protocol http.
  final _i5.ServiceHttpsProtocolHealthCheckHttpModel? http;

  @_i3.override
  _i3.Object? toJson() => {
    r'protocol': this.protocol.toJson(),
    r'port': this.port,
    r'interval': this.interval,
    r'timeout': this.timeout,
    r'retries': this.retries,
    if (this.http != null) r'http': this.http?.toJson(),
  };

  ServiceHttpsProtocolHealthCheckModel Function({
    _i4.ServiceHttpsProtocolHealthCheckProtocolModel? protocol,
    _i3.int? port,
    _i3.int? interval,
    _i3.int? timeout,
    _i3.int? retries,
    _i5.ServiceHttpsProtocolHealthCheckHttpModel? http,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i4.ServiceHttpsProtocolHealthCheckProtocolModel? protocol,
      _i3.int? port,
      _i3.int? interval,
      _i3.int? timeout,
      _i3.int? retries,
      _i3.Object? http = _sentinel,
    }) => ServiceHttpsProtocolHealthCheckModel(
      protocol: protocol ?? this.protocol,
      port: port ?? this.port,
      interval: interval ?? this.interval,
      timeout: timeout ?? this.timeout,
      retries: retries ?? this.retries,
      http: _i3.identical(http, _sentinel)
          ? this.http
          : (http as _i5.ServiceHttpsProtocolHealthCheckHttpModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServiceHttpsProtocolHealthCheckModel &&
        other.protocol == this.protocol &&
        other.port == this.port &&
        other.interval == this.interval &&
        other.timeout == this.timeout &&
        other.retries == this.retries &&
        other.http == this.http;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.protocol,
      this.port,
      this.interval,
      this.timeout,
      this.retries,
      this.http,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServiceHttpsProtocolHealthCheckModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServiceHttpsProtocolHealthCheckModel: complex types cannot be URI-encoded',
    );
  }
}
