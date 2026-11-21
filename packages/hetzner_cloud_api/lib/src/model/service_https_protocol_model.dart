// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/service_https_protocol_health_check_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/service_https_protocol_protocol_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServiceHttpsProtocolModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServiceHttpsProtocolModel({
    required this.protocol,
    required this.listenPort,
    required this.destinationPort,
    required this.proxyprotocol,
    required this.healthCheck,
  });

  factory ServiceHttpsProtocolModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServiceHttpsProtocolModel: contains complex types',
    );
  }

  factory ServiceHttpsProtocolModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ServiceHttpsProtocolModel');
    return ServiceHttpsProtocolModel(
      protocol: _i4.ServiceHttpsProtocolProtocolModel.fromJson(
        _$map[r'protocol'],
      ),
      listenPort: _$map[r'listen_port'].decodeJsonInt(
        context: r'ServiceHttpsProtocolModel.listen_port',
      ),
      destinationPort: _$map[r'destination_port'].decodeJsonInt(
        context: r'ServiceHttpsProtocolModel.destination_port',
      ),
      proxyprotocol: _$map[r'proxyprotocol'].decodeJsonBool(
        context: r'ServiceHttpsProtocolModel.proxyprotocol',
      ),
      healthCheck: _i5.ServiceHttpsProtocolHealthCheckModel.fromJson(
        _$map[r'health_check'],
      ),
    );
  }

  factory ServiceHttpsProtocolModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServiceHttpsProtocolModel: contains complex types',
    );
  }

  /// Protocol of the Load Balancer.
  final _i4.ServiceHttpsProtocolProtocolModel protocol;

  /// Port the Load Balancer listens on.
  ///
  /// **Example**:
  /// ```json
  /// 443
  /// ```
  final _i3.int listenPort;

  /// Port the Load Balancer will balance to.
  ///
  /// **Example**:
  /// ```json
  /// 80
  /// ```
  final _i3.int destinationPort;

  /// Is Proxyprotocol enabled or not.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool proxyprotocol;

  /// Service health check.
  final _i5.ServiceHttpsProtocolHealthCheckModel healthCheck;

  @_i3.override
  _i3.Object? toJson() => {
    r'protocol': this.protocol.toJson(),
    r'listen_port': this.listenPort,
    r'destination_port': this.destinationPort,
    r'proxyprotocol': this.proxyprotocol,
    r'health_check': this.healthCheck.toJson(),
  };

  ServiceHttpsProtocolModel Function({
    _i4.ServiceHttpsProtocolProtocolModel? protocol,
    _i3.int? listenPort,
    _i3.int? destinationPort,
    _i3.bool? proxyprotocol,
    _i5.ServiceHttpsProtocolHealthCheckModel? healthCheck,
  })
  get copyWith {
    return ({
      _i4.ServiceHttpsProtocolProtocolModel? protocol,
      _i3.int? listenPort,
      _i3.int? destinationPort,
      _i3.bool? proxyprotocol,
      _i5.ServiceHttpsProtocolHealthCheckModel? healthCheck,
    }) => ServiceHttpsProtocolModel(
      protocol: protocol ?? this.protocol,
      listenPort: listenPort ?? this.listenPort,
      destinationPort: destinationPort ?? this.destinationPort,
      proxyprotocol: proxyprotocol ?? this.proxyprotocol,
      healthCheck: healthCheck ?? this.healthCheck,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServiceHttpsProtocolModel &&
        other.protocol == this.protocol &&
        other.listenPort == this.listenPort &&
        other.destinationPort == this.destinationPort &&
        other.proxyprotocol == this.proxyprotocol &&
        other.healthCheck == this.healthCheck;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.protocol,
      this.listenPort,
      this.destinationPort,
      this.proxyprotocol,
      this.healthCheck,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServiceHttpsProtocolModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServiceHttpsProtocolModel: complex types cannot be URI-encoded',
    );
  }
}
