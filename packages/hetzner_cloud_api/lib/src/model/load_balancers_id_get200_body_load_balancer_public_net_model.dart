// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_public_net_ipv4_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_public_net_ipv6_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Public network information.
@_i2.immutable
class LoadBalancersIdGet200BodyLoadBalancerPublicNetModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdGet200BodyLoadBalancerPublicNetModel({
    required this.enabled,
    required this.ipv4,
    required this.ipv6,
  });

  factory LoadBalancersIdGet200BodyLoadBalancerPublicNetModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancersIdGet200BodyLoadBalancerPublicNetModel: contains complex types',
    );
  }

  factory LoadBalancersIdGet200BodyLoadBalancerPublicNetModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersIdGet200BodyLoadBalancerPublicNetModel',
    );
    return LoadBalancersIdGet200BodyLoadBalancerPublicNetModel(
      enabled: _$map[r'enabled'].decodeJsonBool(
        context: r'LoadBalancersIdGet200BodyLoadBalancerPublicNetModel.enabled',
      ),
      ipv4:
          _i4.LoadBalancersIdGet200BodyLoadBalancerPublicNetIpv4Model.fromJson(
            _$map[r'ipv4'],
          ),
      ipv6:
          _i5.LoadBalancersIdGet200BodyLoadBalancerPublicNetIpv6Model.fromJson(
            _$map[r'ipv6'],
          ),
    );
  }

  factory LoadBalancersIdGet200BodyLoadBalancerPublicNetModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancersIdGet200BodyLoadBalancerPublicNetModel: contains complex types',
    );
  }

  /// Public Interface enabled or not.
  final _i3.bool enabled;

  /// IP address (v4).
  final _i4.LoadBalancersIdGet200BodyLoadBalancerPublicNetIpv4Model ipv4;

  /// IP address (v6).
  final _i5.LoadBalancersIdGet200BodyLoadBalancerPublicNetIpv6Model ipv6;

  @_i3.override
  _i3.Object? toJson() => {
    r'enabled': this.enabled,
    r'ipv4': this.ipv4.toJson(),
    r'ipv6': this.ipv6.toJson(),
  };

  LoadBalancersIdGet200BodyLoadBalancerPublicNetModel Function({
    _i3.bool? enabled,
    _i4.LoadBalancersIdGet200BodyLoadBalancerPublicNetIpv4Model? ipv4,
    _i5.LoadBalancersIdGet200BodyLoadBalancerPublicNetIpv6Model? ipv6,
  })
  get copyWith {
    return ({
      _i3.bool? enabled,
      _i4.LoadBalancersIdGet200BodyLoadBalancerPublicNetIpv4Model? ipv4,
      _i5.LoadBalancersIdGet200BodyLoadBalancerPublicNetIpv6Model? ipv6,
    }) => LoadBalancersIdGet200BodyLoadBalancerPublicNetModel(
      enabled: enabled ?? this.enabled,
      ipv4: ipv4 ?? this.ipv4,
      ipv6: ipv6 ?? this.ipv6,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersIdGet200BodyLoadBalancerPublicNetModel &&
        other.enabled == this.enabled &&
        other.ipv4 == this.ipv4 &&
        other.ipv6 == this.ipv6;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.enabled, this.ipv4, this.ipv6]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for LoadBalancersIdGet200BodyLoadBalancerPublicNetModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersIdGet200BodyLoadBalancerPublicNetModel: complex types cannot be URI-encoded',
    );
  }
}
