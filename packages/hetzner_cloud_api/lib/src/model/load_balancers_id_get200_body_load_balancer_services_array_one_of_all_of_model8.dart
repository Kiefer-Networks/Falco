// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_services_array_one_of_all_of_http_model2.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_services_array_one_of_all_of_protocol_model5.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel8
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel8({
    required this.http,
    this.protocol,
  });

  factory LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel8.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel8: contains complex types',
    );
  }

  factory LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel8.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context:
          r'LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel8',
    );
    return LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel8(
      protocol: _$map[r'protocol'] == null
          ? null
          : _i4.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfProtocolModel5.fromJson(
              _$map[r'protocol'],
            ),
      http:
          _i5.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2.fromJson(
            _$map[r'http'],
          ),
    );
  }

  factory LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel8.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel8: contains complex types',
    );
  }

  /// **Example**:
  /// ```
  /// http
  /// ```
  final _i4.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfProtocolModel5?
  protocol;

  /// Configuration option for protocol http.
  final _i5.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2
  http;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.protocol != null) r'protocol': this.protocol?.toJson(),
    r'http': this.http.toJson(),
  };

  LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel8 Function({
    _i4.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfProtocolModel5?
    protocol,
    _i5.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2?
    http,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? protocol = _sentinel,
      _i5.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2?
      http,
    }) => LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel8(
      protocol: _i3.identical(protocol, _sentinel)
          ? this.protocol
          : (protocol
                as _i4.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfProtocolModel5?),
      http: http ?? this.http,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel8 &&
        other.protocol == this.protocol &&
        other.http == this.http;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.protocol, this.http]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel8: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfAllOfModel8: complex types cannot be URI-encoded',
    );
  }
}
