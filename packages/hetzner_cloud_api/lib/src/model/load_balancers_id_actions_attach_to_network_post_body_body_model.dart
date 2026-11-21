// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel({
    required this.network,
    this.ip,
    this.ipRange,
  });

  factory LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'network', r'ip', r'ip_range'},
      listKeys: {},
      context: r'LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel(
      network: _$values[r'network'].decodeSimpleInt(
        context:
            r'LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel.network',
      ),
      ip: _$values[r'ip'].decodeSimpleNullableString(
        context: r'LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel.ip',
      ),
      ipRange: _$values[r'ip_range'].decodeSimpleNullableString(
        context:
            r'LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel.ip_range',
      ),
    );
  }

  factory LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel',
    );
    return LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel(
      network: _$map[r'network'].decodeJsonInt(
        context:
            r'LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel.network',
      ),
      ip: _$map[r'ip'].decodeJsonNullableString(
        context: r'LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel.ip',
      ),
      ipRange: _$map[r'ip_range'].decodeJsonNullableString(
        context:
            r'LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel.ip_range',
      ),
    );
  }

  factory LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'network', r'ip', r'ip_range'},
      listKeys: {},
      context: r'LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel',
    );
    return LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel(
      network: _$values[r'network'].decodeFormInt(
        context:
            r'LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel.network',
      ),
      ip: _$values[r'ip'].decodeFormNullableString(
        context: r'LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel.ip',
      ),
      ipRange: _$values[r'ip_range'].decodeFormNullableString(
        context:
            r'LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel.ip_range',
      ),
    );
  }

  /// ID of an existing network to attach the Load Balancer to.
  ///
  /// **Example**:
  /// ```json
  /// 123
  /// ```
  final _i3.int network;

  /// IP to request to be assigned to this Load Balancer; if you do not provide this then you will be auto assigned an IP address.
  ///
  /// **Example**:
  /// ```
  /// 10.0.1.1
  /// ```
  final _i3.String? ip;

  /// IP range in CIDR block notation of the subnet to attach to.
  ///
  /// This allows for auto assigning an IP address for a specific subnet.
  /// Providing `ip` that is not part of `ip_range` will result in an error.
  ///
  ///
  /// **Example**:
  /// ```
  /// 10.0.1.0/24
  /// ```
  final _i3.String? ipRange;

  @_i3.override
  _i3.Object? toJson() => {
    r'network': this.network,
    if (this.ip != null) r'ip': this.ip,
    if (this.ipRange != null) r'ip_range': this.ipRange,
  };

  LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel Function({
    _i3.int? network,
    _i3.String? ip,
    _i3.String? ipRange,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? network,
      _i3.Object? ip = _sentinel,
      _i3.Object? ipRange = _sentinel,
    }) => LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel(
      network: network ?? this.network,
      ip: _i3.identical(ip, _sentinel) ? this.ip : (ip as _i3.String?),
      ipRange: _i3.identical(ipRange, _sentinel)
          ? this.ipRange
          : (ipRange as _i3.String?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel &&
        other.network == this.network &&
        other.ip == this.ip &&
        other.ipRange == this.ipRange;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.network, this.ip, this.ipRange]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'network'] = _i1.PropertyValue.scalar(this.network.toString());
    if (this.ip != null) {
      _$result[r'ip'] = _i1.PropertyValue.scalar(this.ip!);
    }
    if (this.ipRange != null) {
      _$result[r'ip_range'] = _i1.PropertyValue.scalar(this.ipRange!);
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
      r'Cannot uriEncode LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
