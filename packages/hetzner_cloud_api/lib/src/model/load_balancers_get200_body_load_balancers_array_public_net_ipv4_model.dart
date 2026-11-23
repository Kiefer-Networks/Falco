// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// IP address (v4).
@_i2.immutable
class LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model({
    required this.id,
    required this.ip,
    required this.blocked,
    required this.dnsPtr,
  });

  factory LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'id', r'ip', r'blocked', r'dns_ptr'},
      listKeys: {},
      context: r'LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model(
      id: _$values[r'id'].decodeSimpleNullableInt(
        context:
            r'LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model.id',
      ),
      ip: _$values[r'ip'].decodeSimpleNullableString(
        context:
            r'LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model.ip',
      ),
      blocked: _$values[r'blocked'].decodeSimpleBool(
        context: r'LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model.blocked',
      ),
      dnsPtr: _$values[r'dns_ptr'].decodeSimpleNullableString(
        context: r'LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model.dns_ptr',
      ),
    );
  }

  factory LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model',
    );
    return LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model(
      id: _$map[r'id'].decodeJsonNullableInt(
        context:
            r'LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model.id',
      ),
      ip: _$map[r'ip'].decodeJsonNullableString(
        context:
            r'LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model.ip',
      ),
      blocked: _$map[r'blocked'].decodeJsonBool(
        context: r'LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model.blocked',
      ),
      dnsPtr: _$map[r'dns_ptr'].decodeJsonNullableString(
        context: r'LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model.dns_ptr',
      ),
    );
  }

  factory LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'id', r'ip', r'blocked', r'dns_ptr'},
      listKeys: {},
      context: r'LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model',
    );
    return LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model(
      id: _$values[r'id'].decodeFormNullableInt(
        context:
            r'LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model.id',
      ),
      ip: _$values[r'ip'].decodeFormNullableString(
        context:
            r'LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model.ip',
      ),
      blocked: _$values[r'blocked'].decodeFormBool(
        context: r'LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model.blocked',
      ),
      dnsPtr: _$values[r'dns_ptr'].decodeFormNullableString(
        context: r'LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model.dns_ptr',
      ),
    );
  }

  /// ID of the [Primary IP](#tag/primary-ips) assigned to this Load Balancer.
  ///
  /// `null` if the IP address is still managed by the system and is not a [Primary IP](#tag/primary-ips) yet.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int? id;

  /// IP address (v4) of this Load Balancer.
  ///
  /// **Example**:
  /// ```
  /// 1.2.3.4
  /// ```
  final _i3.String? ip;

  /// Whether the IP is blocked by our abuse department.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool blocked;

  /// Reverse DNS PTR entry for the IPv4 address of this Load Balancer.
  ///
  /// **Example**:
  /// ```
  /// lb1.example.com
  /// ```
  final _i3.String? dnsPtr;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'ip': this.ip,
    r'blocked': this.blocked,
    r'dns_ptr': this.dnsPtr,
  };

  LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model Function({
    _i3.int? id,
    _i3.String? ip,
    _i3.bool? blocked,
    _i3.String? dnsPtr,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? id = _sentinel,
      _i3.Object? ip = _sentinel,
      _i3.bool? blocked,
      _i3.Object? dnsPtr = _sentinel,
    }) => LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model(
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int?),
      ip: _i3.identical(ip, _sentinel) ? this.ip : (ip as _i3.String?),
      blocked: blocked ?? this.blocked,
      dnsPtr: _i3.identical(dnsPtr, _sentinel)
          ? this.dnsPtr
          : (dnsPtr as _i3.String?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model &&
        other.id == this.id &&
        other.ip == this.ip &&
        other.blocked == this.blocked &&
        other.dnsPtr == this.dnsPtr;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.id, this.ip, this.blocked, this.dnsPtr]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (this.id != null) {
      _$result[r'id'] = _i1.PropertyValue.scalar(this.id!.toString());
    }
    if (this.ip != null) {
      _$result[r'ip'] = _i1.PropertyValue.scalar(this.ip!);
    }
    _$result[r'blocked'] = _i1.PropertyValue.scalar(this.blocked.toString());
    if (this.dnsPtr != null) {
      _$result[r'dns_ptr'] = _i1.PropertyValue.scalar(this.dnsPtr!);
    }
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
      r'Cannot uriEncode LoadBalancersGet200BodyLoadBalancersArrayPublicNetIpv4Model: complex types cannot be URI-encoded',
    );
  }
}
