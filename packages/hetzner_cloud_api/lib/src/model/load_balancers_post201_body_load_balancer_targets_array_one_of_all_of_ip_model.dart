// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// IP target where the traffic should be routed to. It is only possible to use the (Public or vSwitch) IPs of Hetzner Online Root Servers belonging to the project owner. IPs belonging to other users are blocked. Additionally IPs belonging to services provided by Hetzner Cloud (Servers, Load Balancers, ...) are blocked as well. Only present for target type `ip`.
@_i2.immutable
class LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel({
    required this.ip,
  });

  factory LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'ip'},
      listKeys: {},
      context:
          r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel(
      ip: _$values[r'ip'].decodeSimpleString(
        context: r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel.ip',
      ),
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context:
          r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel',
    );
    return LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel(
      ip: _$map[r'ip'].decodeJsonString(
        context: r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel.ip',
      ),
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'ip'},
      listKeys: {},
      context:
          r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel',
    );
    return LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel(
      ip: _$values[r'ip'].decodeFormString(
        context: r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel.ip',
      ),
    );
  }

  /// IP of a server that belongs to the same customer (public IPv4/IPv6) or private IP in a subnet type vswitch.
  ///
  /// **Example**:
  /// ```
  /// 203.0.113.1
  /// ```
  final _i3.String ip;

  @_i3.override
  _i3.Object? toJson() => {r'ip': this.ip};

  LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel Function({
    _i3.String? ip,
  })
  get copyWith {
    return ({_i3.String? ip}) =>
        LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel(
          ip: ip ?? this.ip,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel &&
        other.ip == this.ip;
  }

  @_i3.override
  _i3.int get hashCode => this.ip.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'ip'] = _i1.PropertyValue.scalar(this.ip);
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
      r'Cannot uriEncode LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfIpModel: complex types cannot be URI-encoded',
    );
  }
}
