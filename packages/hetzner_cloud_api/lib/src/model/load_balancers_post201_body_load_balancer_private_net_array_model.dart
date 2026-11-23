// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel({
    required this.network,
    required this.ip,
  });

  factory LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'network', r'ip'},
      listKeys: {},
      context: r'LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel(
      network: _$values[r'network'].decodeSimpleInt(
        context:
            r'LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel.network',
      ),
      ip: _$values[r'ip'].decodeSimpleString(
        context: r'LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel.ip',
      ),
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel',
    );
    return LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel(
      network: _$map[r'network'].decodeJsonInt(
        context:
            r'LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel.network',
      ),
      ip: _$map[r'ip'].decodeJsonString(
        context: r'LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel.ip',
      ),
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'network', r'ip'},
      listKeys: {},
      context: r'LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel',
    );
    return LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel(
      network: _$values[r'network'].decodeFormInt(
        context:
            r'LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel.network',
      ),
      ip: _$values[r'ip'].decodeFormString(
        context: r'LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel.ip',
      ),
    );
  }

  /// ID of the Network.
  ///
  /// **Example**:
  /// ```json
  /// 4711
  /// ```
  final _i3.int network;

  /// IP address (v4) of this Load Balancer in this Network.
  ///
  /// **Example**:
  /// ```
  /// 10.0.0.2
  /// ```
  final _i3.String ip;

  @_i3.override
  _i3.Object? toJson() => {r'network': this.network, r'ip': this.ip};

  LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel Function({
    _i3.int? network,
    _i3.String? ip,
  })
  get copyWith {
    return ({_i3.int? network, _i3.String? ip}) =>
        LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel(
          network: network ?? this.network,
          ip: ip ?? this.ip,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel &&
        other.network == this.network &&
        other.ip == this.ip;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.network, this.ip]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'network'] = _i1.PropertyValue.scalar(this.network.toString());
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
      r'Cannot uriEncode LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel: complex types cannot be URI-encoded',
    );
  }
}
