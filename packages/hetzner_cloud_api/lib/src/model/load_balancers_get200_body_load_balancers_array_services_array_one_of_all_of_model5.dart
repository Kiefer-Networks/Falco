// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_get200_body_load_balancers_array_services_array_one_of_all_of_health_check_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/load_balancers_get200_body_load_balancers_array_services_array_one_of_all_of_protocol_model2.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5({
    required this.protocol,
    required this.listenPort,
    required this.destinationPort,
    required this.proxyprotocol,
    required this.healthCheck,
  });

  factory LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5: contains complex types',
    );
  }

  factory LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5',
    );
    return LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5(
      protocol:
          _i4.LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfProtocolModel2.fromJson(
            _$map[r'protocol'],
          ),
      listenPort: _$map[r'listen_port'].decodeJsonInt(
        context: r'LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5.listen_port',
      ),
      destinationPort: _$map[r'destination_port'].decodeJsonInt(
        context: r'LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5.destination_port',
      ),
      proxyprotocol: _$map[r'proxyprotocol'].decodeJsonBool(
        context: r'LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5.proxyprotocol',
      ),
      healthCheck:
          _i5.LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfHealthCheckModel.fromJson(
            _$map[r'health_check'],
          ),
    );
  }

  factory LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5: contains complex types',
    );
  }

  /// Protocol of the Load Balancer.
  final _i4.LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfProtocolModel2
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
  final _i5.LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfHealthCheckModel
  healthCheck;

  @_i3.override
  _i3.Object? toJson() => {
    r'protocol': this.protocol.toJson(),
    r'listen_port': this.listenPort,
    r'destination_port': this.destinationPort,
    r'proxyprotocol': this.proxyprotocol,
    r'health_check': this.healthCheck.toJson(),
  };

  LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5
  Function({
    _i4.LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfProtocolModel2?
    protocol,
    _i3.int? listenPort,
    _i3.int? destinationPort,
    _i3.bool? proxyprotocol,
    _i5.LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfHealthCheckModel?
    healthCheck,
  })
  get copyWith {
    return ({
      _i4.LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfProtocolModel2?
      protocol,
      _i3.int? listenPort,
      _i3.int? destinationPort,
      _i3.bool? proxyprotocol,
      _i5.LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfHealthCheckModel?
      healthCheck,
    }) =>
        LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5(
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
    return other
            is LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5 &&
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
    r'parameterProperties not supported for LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersGet200BodyLoadBalancersArrayServicesArrayOneOfAllOfModel5: complex types cannot be URI-encoded',
    );
  }
}
