// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_services_array_one_of_all_of_protocol_model6.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel9
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel9({
    this.protocol,
  });

  factory LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel9.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'protocol'},
      listKeys: {},
      context:
          r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel9',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel9(
      protocol: _$values[r'protocol'] == null
          ? null
          : _i4.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfProtocolModel6.fromSimple(
              _$values[r'protocol'],
              explode: explode,
            ),
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel9.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context:
          r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel9',
    );
    return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel9(
      protocol: _$map[r'protocol'] == null
          ? null
          : _i4.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfProtocolModel6.fromJson(
              _$map[r'protocol'],
            ),
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel9.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'protocol'},
      listKeys: {},
      context:
          r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel9',
    );
    return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel9(
      protocol: _$values[r'protocol'] == null
          ? null
          : _i4.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfProtocolModel6.fromForm(
              _$values[r'protocol'],
              explode: explode,
            ),
    );
  }

  /// **Example**:
  /// ```
  /// tcp
  /// ```
  final _i4.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfProtocolModel6?
  protocol;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.protocol != null) r'protocol': this.protocol?.toJson(),
  };

  LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel9 Function({
    _i4.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfProtocolModel6?
    protocol,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? protocol = _sentinel,
    }) => LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel9(
      protocol: _i3.identical(protocol, _sentinel)
          ? this.protocol
          : (protocol
                as _i4.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfProtocolModel6?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel9 &&
        other.protocol == this.protocol;
  }

  @_i3.override
  _i3.int get hashCode => this.protocol.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (this.protocol != null) {
      _$result[r'protocol'] = _i1.PropertyValue.scalar(this.protocol!.toJson());
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfModel9: complex types cannot be URI-encoded',
    );
  }
}
