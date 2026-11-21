// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_post_body_body_services_array_one_of_all_of_health_check_model2.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/load_balancers_post_body_body_services_array_one_of_all_of_protocol_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6({
    required this.protocol,
    required this.listenPort,
    required this.destinationPort,
    required this.proxyprotocol,
    required this.healthCheck,
  });

  factory LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6: contains complex types',
    );
  }

  factory LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6',
    );
    return LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6(
      protocol:
          _i4.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfProtocolModel.fromJson(
            _$map[r'protocol'],
          ),
      listenPort: _$map[r'listen_port'].decodeJsonInt(
        context: r'LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6.listen_port',
      ),
      destinationPort: _$map[r'destination_port'].decodeJsonInt(
        context: r'LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6.destination_port',
      ),
      proxyprotocol: _$map[r'proxyprotocol'].decodeJsonBool(
        context: r'LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6.proxyprotocol',
      ),
      healthCheck:
          _i5.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfHealthCheckModel2.fromJson(
            _$map[r'health_check'],
          ),
    );
  }

  factory LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6: contains complex types',
    );
  }

  /// Protocol of the Load Balancer.
  final _i4.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfProtocolModel
  protocol;

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
  final _i5.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfHealthCheckModel2
  healthCheck;

  @_i3.override
  _i3.Object? toJson() => {
    r'protocol': this.protocol.toJson(),
    r'listen_port': this.listenPort,
    r'destination_port': this.destinationPort,
    r'proxyprotocol': this.proxyprotocol,
    r'health_check': this.healthCheck.toJson(),
  };

  LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6 Function({
    _i4.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfProtocolModel? protocol,
    _i3.int? listenPort,
    _i3.int? destinationPort,
    _i3.bool? proxyprotocol,
    _i5.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfHealthCheckModel2?
    healthCheck,
  })
  get copyWith {
    return ({
      _i4.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfProtocolModel?
      protocol,
      _i3.int? listenPort,
      _i3.int? destinationPort,
      _i3.bool? proxyprotocol,
      _i5.LoadBalancersPostBodyBodyServicesArrayOneOfAllOfHealthCheckModel2?
      healthCheck,
    }) => LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6(
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
    return other is LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6 &&
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
    r'parameterProperties not supported for LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersPostBodyBodyServicesArrayOneOfAllOfModel6: complex types cannot be URI-encoded',
    );
  }
}
