// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_add_service_post_body_body_all_of_health_check_all_of_http_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_add_service_post_body_body_all_of_health_check_all_of_protocol_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Service health check.
@_i2.immutable
class LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2({
    this.protocol,
    this.port,
    this.interval,
    this.timeout,
    this.retries,
    this.http,
  });

  factory LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2: contains complex types',
    );
  }

  factory LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2',
    );
    return LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2(
      protocol: _$map[r'protocol'] == null
          ? null
          : _i4.LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfProtocolModel.fromJson(
              _$map[r'protocol'],
            ),
      port: _$map[r'port'].decodeJsonNullableInt(
        context: r'LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2.port',
      ),
      interval: _$map[r'interval'].decodeJsonNullableInt(
        context: r'LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2.interval',
      ),
      timeout: _$map[r'timeout'].decodeJsonNullableInt(
        context: r'LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2.timeout',
      ),
      retries: _$map[r'retries'].decodeJsonNullableInt(
        context: r'LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2.retries',
      ),
      http: _$map[r'http'] == null
          ? null
          : _i5.LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfHttpModel.fromJson(
              _$map[r'http'],
            ),
    );
  }

  factory LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2: contains complex types',
    );
  }

  /// Type of the health check.
  ///
  /// **Example**:
  /// ```
  /// http
  /// ```
  final _i4.LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfProtocolModel?
  protocol;

  /// Port the health check will be performed on.
  ///
  /// **Example**:
  /// ```json
  /// 4711
  /// ```
  final _i3.int? port;

  /// Time interval in seconds health checks are performed.
  ///
  /// **Example**:
  /// ```json
  /// 15
  /// ```
  final _i3.int? interval;

  /// Time in seconds after an attempt is considered a timeout.
  ///
  /// **Example**:
  /// ```json
  /// 10
  /// ```
  final _i3.int? timeout;

  /// Unsuccessful retries needed until a target is considered unhealthy; an unhealthy target needs the same number of successful retries to become healthy again.
  ///
  /// **Example**:
  /// ```json
  /// 3
  /// ```
  final _i3.int? retries;

  /// Additional configuration for protocol http.
  final _i5.LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfHttpModel?
  http;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.protocol != null) r'protocol': this.protocol?.toJson(),
    if (this.port != null) r'port': this.port,
    if (this.interval != null) r'interval': this.interval,
    if (this.timeout != null) r'timeout': this.timeout,
    if (this.retries != null) r'retries': this.retries,
    if (this.http != null) r'http': this.http?.toJson(),
  };

  LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2
  Function({
    _i4.LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfProtocolModel?
    protocol,
    _i3.int? port,
    _i3.int? interval,
    _i3.int? timeout,
    _i3.int? retries,
    _i5.LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfHttpModel?
    http,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? protocol = _sentinel,
      _i3.Object? port = _sentinel,
      _i3.Object? interval = _sentinel,
      _i3.Object? timeout = _sentinel,
      _i3.Object? retries = _sentinel,
      _i3.Object? http = _sentinel,
    }) => LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2(
      protocol: _i3.identical(protocol, _sentinel)
          ? this.protocol
          : (protocol
                as _i4.LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfProtocolModel?),
      port: _i3.identical(port, _sentinel) ? this.port : (port as _i3.int?),
      interval: _i3.identical(interval, _sentinel)
          ? this.interval
          : (interval as _i3.int?),
      timeout: _i3.identical(timeout, _sentinel)
          ? this.timeout
          : (timeout as _i3.int?),
      retries: _i3.identical(retries, _sentinel)
          ? this.retries
          : (retries as _i3.int?),
      http: _i3.identical(http, _sentinel)
          ? this.http
          : (http
                as _i5.LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfHttpModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2 &&
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
    r'parameterProperties not supported for LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersIdActionsAddServicePostBodyBodyAllOfHealthCheckAllOfModel2: complex types cannot be URI-encoded',
    );
  }
}
