// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_update_service_post_body_body_all_of_health_check_all_of_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_update_service_post_body_body_all_of_protocol_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3({
    this.protocol,
    this.listenPort,
    this.destinationPort,
    this.proxyprotocol,
    this.healthCheck,
  });

  factory LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3: contains complex types',
    );
  }

  factory LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3',
    );
    return LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3(
      protocol: _$map[r'protocol'] == null
          ? null
          : _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfProtocolModel.fromJson(
              _$map[r'protocol'],
            ),
      listenPort: _$map[r'listen_port'].decodeJsonNullableInt(
        context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3.listen_port',
      ),
      destinationPort: _$map[r'destination_port'].decodeJsonNullableInt(
        context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3.destination_port',
      ),
      proxyprotocol: _$map[r'proxyprotocol'].decodeJsonNullableBool(
        context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3.proxyprotocol',
      ),
      healthCheck: _$map[r'health_check'] == null
          ? null
          : _i5.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel.fromJson(
              _$map[r'health_check'],
            ),
    );
  }

  factory LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3: contains complex types',
    );
  }

  /// Protocol of the Load Balancer.
  ///
  /// **Example**:
  /// ```
  /// https
  /// ```
  final _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfProtocolModel?
  protocol;

  /// Port the Load Balancer listens on.
  ///
  /// **Example**:
  /// ```json
  /// 443
  /// ```
  final _i3.int? listenPort;

  /// Port the Load Balancer will balance to.
  ///
  /// **Example**:
  /// ```json
  /// 80
  /// ```
  final _i3.int? destinationPort;

  /// Is Proxyprotocol enabled or not.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool? proxyprotocol;

  final _i5.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel?
  healthCheck;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.protocol != null) r'protocol': this.protocol?.toJson(),
    if (this.listenPort != null) r'listen_port': this.listenPort,
    if (this.destinationPort != null) r'destination_port': this.destinationPort,
    if (this.proxyprotocol != null) r'proxyprotocol': this.proxyprotocol,
    if (this.healthCheck != null) r'health_check': this.healthCheck?.toJson(),
  };

  LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3 Function({
    _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfProtocolModel?
    protocol,
    _i3.int? listenPort,
    _i3.int? destinationPort,
    _i3.bool? proxyprotocol,
    _i5.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel?
    healthCheck,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? protocol = _sentinel,
      _i3.Object? listenPort = _sentinel,
      _i3.Object? destinationPort = _sentinel,
      _i3.Object? proxyprotocol = _sentinel,
      _i3.Object? healthCheck = _sentinel,
    }) => LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3(
      protocol: _i3.identical(protocol, _sentinel)
          ? this.protocol
          : (protocol
                as _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfProtocolModel?),
      listenPort: _i3.identical(listenPort, _sentinel)
          ? this.listenPort
          : (listenPort as _i3.int?),
      destinationPort: _i3.identical(destinationPort, _sentinel)
          ? this.destinationPort
          : (destinationPort as _i3.int?),
      proxyprotocol: _i3.identical(proxyprotocol, _sentinel)
          ? this.proxyprotocol
          : (proxyprotocol as _i3.bool?),
      healthCheck: _i3.identical(healthCheck, _sentinel)
          ? this.healthCheck
          : (healthCheck
                as _i5.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckAllOfModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3 &&
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
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (this.protocol != null) {
      _$result[r'protocol'] = _i1.PropertyValue.scalar(this.protocol!.toJson());
    }
    if (this.listenPort != null) {
      _$result[r'listen_port'] = _i1.PropertyValue.scalar(
        this.listenPort!.toString(),
      );
    }
    if (this.destinationPort != null) {
      _$result[r'destination_port'] = _i1.PropertyValue.scalar(
        this.destinationPort!.toString(),
      );
    }
    if (this.proxyprotocol != null) {
      _$result[r'proxyprotocol'] = _i1.PropertyValue.scalar(
        this.proxyprotocol!.toString(),
      );
    }
    if (this.healthCheck != null) {
      _$result[r'health_check'] = _i1.encodeAnyValueToPropertyValue(
        this.healthCheck!.toJson(),
        allowEmpty: allowEmpty,
      );
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel3: complex types cannot be URI-encoded',
    );
  }
}
