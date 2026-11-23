// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Public network options of the Load Balancer.
///
/// Only allowed if the public interface is enabled.
///
@_i2.immutable
class LoadBalancersPostBodyBodyPublicNetModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersPostBodyBodyPublicNetModel({this.ipv4, this.ipv6});

  factory LoadBalancersPostBodyBodyPublicNetModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'ipv4', r'ipv6'},
      listKeys: {},
      context: r'LoadBalancersPostBodyBodyPublicNetModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersPostBodyBodyPublicNetModel(
      ipv4: _$values[r'ipv4'].decodeSimpleNullableInt(
        context: r'LoadBalancersPostBodyBodyPublicNetModel.ipv4',
      ),
      ipv6: _$values[r'ipv6'].decodeSimpleNullableInt(
        context: r'LoadBalancersPostBodyBodyPublicNetModel.ipv6',
      ),
    );
  }

  factory LoadBalancersPostBodyBodyPublicNetModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersPostBodyBodyPublicNetModel',
    );
    return LoadBalancersPostBodyBodyPublicNetModel(
      ipv4: _$map[r'ipv4'].decodeJsonNullableInt(
        context: r'LoadBalancersPostBodyBodyPublicNetModel.ipv4',
      ),
      ipv6: _$map[r'ipv6'].decodeJsonNullableInt(
        context: r'LoadBalancersPostBodyBodyPublicNetModel.ipv6',
      ),
    );
  }

  factory LoadBalancersPostBodyBodyPublicNetModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'ipv4', r'ipv6'},
      listKeys: {},
      context: r'LoadBalancersPostBodyBodyPublicNetModel',
    );
    return LoadBalancersPostBodyBodyPublicNetModel(
      ipv4: _$values[r'ipv4'].decodeFormNullableInt(
        context: r'LoadBalancersPostBodyBodyPublicNetModel.ipv4',
      ),
      ipv6: _$values[r'ipv6'].decodeFormNullableInt(
        context: r'LoadBalancersPostBodyBodyPublicNetModel.ipv6',
      ),
    );
  }

  /// ID of an existing [Primary IP](#tag/primary-ips) of type `ipv4` to assign to the Load Balancer.
  ///
  /// The [Primary IP](#tag/primary-ips) must be unassigned, must not be blocked and must be bound to the
  /// same Location as the Load Balancer.
  ///
  /// Omit or set to `null` to get a system managed IP address instead. System managed IP addresses are
  /// not [Primary IPs](#tag/primary-ips) and are created and deleted together with the Load Balancer.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int? ipv4;

  /// ID of an existing [Primary IP](#tag/primary-ips) of type `ipv6` to assign to the Load Balancer.
  ///
  /// The [Primary IP](#tag/primary-ips) must be unassigned, must not be blocked and must be bound to the
  /// same Location as the Load Balancer.
  ///
  /// Omit or set to `null` to get a system managed IP address instead. System managed IP addresses are
  /// not [Primary IPs](#tag/primary-ips) and are created and deleted together with the Load Balancer.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int? ipv6;

  @_i3.override
  _i3.Object? toJson() => {r'ipv4': this.ipv4, r'ipv6': this.ipv6};

  LoadBalancersPostBodyBodyPublicNetModel Function({
    _i3.int? ipv4,
    _i3.int? ipv6,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({_i3.Object? ipv4 = _sentinel, _i3.Object? ipv6 = _sentinel}) =>
        LoadBalancersPostBodyBodyPublicNetModel(
          ipv4: _i3.identical(ipv4, _sentinel) ? this.ipv4 : (ipv4 as _i3.int?),
          ipv6: _i3.identical(ipv6, _sentinel) ? this.ipv6 : (ipv6 as _i3.int?),
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersPostBodyBodyPublicNetModel &&
        other.ipv4 == this.ipv4 &&
        other.ipv6 == this.ipv6;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.ipv4, this.ipv6]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (this.ipv4 != null) {
      _$result[r'ipv4'] = _i1.PropertyValue.scalar(this.ipv4!.toString());
    }
    if (this.ipv6 != null) {
      _$result[r'ipv6'] = _i1.PropertyValue.scalar(this.ipv6!.toString());
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
      r'Cannot uriEncode LoadBalancersPostBodyBodyPublicNetModel: complex types cannot be URI-encoded',
    );
  }
}
