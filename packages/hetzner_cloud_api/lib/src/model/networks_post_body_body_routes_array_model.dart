// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class NetworksPostBodyBodyRoutesArrayModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const NetworksPostBodyBodyRoutesArrayModel({
    required this.destination,
    required this.gateway,
  });

  factory NetworksPostBodyBodyRoutesArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'destination', r'gateway'},
      listKeys: {},
      context: r'NetworksPostBodyBodyRoutesArrayModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return NetworksPostBodyBodyRoutesArrayModel(
      destination: _$values[r'destination'].decodeSimpleString(
        context: r'NetworksPostBodyBodyRoutesArrayModel.destination',
      ),
      gateway: _$values[r'gateway'].decodeSimpleString(
        context: r'NetworksPostBodyBodyRoutesArrayModel.gateway',
      ),
    );
  }

  factory NetworksPostBodyBodyRoutesArrayModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'NetworksPostBodyBodyRoutesArrayModel',
    );
    return NetworksPostBodyBodyRoutesArrayModel(
      destination: _$map[r'destination'].decodeJsonString(
        context: r'NetworksPostBodyBodyRoutesArrayModel.destination',
      ),
      gateway: _$map[r'gateway'].decodeJsonString(
        context: r'NetworksPostBodyBodyRoutesArrayModel.gateway',
      ),
    );
  }

  factory NetworksPostBodyBodyRoutesArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'destination', r'gateway'},
      listKeys: {},
      context: r'NetworksPostBodyBodyRoutesArrayModel',
    );
    return NetworksPostBodyBodyRoutesArrayModel(
      destination: _$values[r'destination'].decodeFormString(
        context: r'NetworksPostBodyBodyRoutesArrayModel.destination',
      ),
      gateway: _$values[r'gateway'].decodeFormString(
        context: r'NetworksPostBodyBodyRoutesArrayModel.gateway',
      ),
    );
  }

  /// Destination network or host of the route.
  ///
  /// Packages addressed for IPs matching the destination IP prefix will be send to the specified gateway.
  ///
  /// Must be one of
  /// * private IPv4 ranges of RFC1918
  /// * or `0.0.0.0/0`.
  ///
  /// Must not overlap with
  /// * an existing ip_range in any subnets
  /// * or with any destinations in other routes
  /// * or with `172.31.1.1`.
  ///
  /// `172.31.1.1` is being used as a gateway for the public network interface of [Servers](#tag/servers).
  ///
  ///
  /// **Example**:
  /// ```
  /// 10.100.1.0/24
  /// ```
  final _i3.String destination;

  /// Gateway of the route.
  ///
  /// Packages addressed for the specified destination will be send to this IP address.
  ///
  /// Cannot be
  /// * the first IP of the networks ip_range,
  /// * an IP behind a vSwitch or
  /// * `172.31.1.1`.
  ///
  /// `172.31.1.1` is being used as a gateway for the public network interface of [Servers](#tag/servers).
  ///
  ///
  /// **Example**:
  /// ```
  /// 10.0.1.1
  /// ```
  final _i3.String gateway;

  @_i3.override
  _i3.Object? toJson() => {
    r'destination': this.destination,
    r'gateway': this.gateway,
  };

  NetworksPostBodyBodyRoutesArrayModel Function({
    _i3.String? destination,
    _i3.String? gateway,
  })
  get copyWith {
    return ({_i3.String? destination, _i3.String? gateway}) =>
        NetworksPostBodyBodyRoutesArrayModel(
          destination: destination ?? this.destination,
          gateway: gateway ?? this.gateway,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is NetworksPostBodyBodyRoutesArrayModel &&
        other.destination == this.destination &&
        other.gateway == this.gateway;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.destination, this.gateway]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'destination'] = _i1.PropertyValue.scalar(this.destination);
    _$result[r'gateway'] = _i1.PropertyValue.scalar(this.gateway);
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode NetworksPostBodyBodyRoutesArrayModel: complex types cannot be URI-encoded',
    );
  }
}
