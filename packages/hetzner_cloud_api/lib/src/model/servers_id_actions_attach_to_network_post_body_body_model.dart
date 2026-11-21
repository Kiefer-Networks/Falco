// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersIdActionsAttachToNetworkPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdActionsAttachToNetworkPostBodyBodyModel({
    required this.network,
    this.ip,
    this.aliasIps,
    this.ipRange,
  });

  factory ServersIdActionsAttachToNetworkPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'network', r'ip', r'alias_ips', r'ip_range'},
      listKeys: {r'alias_ips'},
      context: r'ServersIdActionsAttachToNetworkPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ServersIdActionsAttachToNetworkPostBodyBodyModel(
      network: _$values[r'network'].decodeSimpleInt(
        context: r'ServersIdActionsAttachToNetworkPostBodyBodyModel.network',
      ),
      ip: _$values[r'ip'].decodeSimpleNullableString(
        context: r'ServersIdActionsAttachToNetworkPostBodyBodyModel.ip',
      ),
      aliasIps: _$values[r'alias_ips'].decodeSimpleNullableStringList(
        context: r'ServersIdActionsAttachToNetworkPostBodyBodyModel.alias_ips',
        isHeader: isHeader,
      ),
      ipRange: _$values[r'ip_range'].decodeSimpleNullableString(
        context: r'ServersIdActionsAttachToNetworkPostBodyBodyModel.ip_range',
      ),
    );
  }

  factory ServersIdActionsAttachToNetworkPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ServersIdActionsAttachToNetworkPostBodyBodyModel',
    );
    return ServersIdActionsAttachToNetworkPostBodyBodyModel(
      network: _$map[r'network'].decodeJsonInt(
        context: r'ServersIdActionsAttachToNetworkPostBodyBodyModel.network',
      ),
      ip: _$map[r'ip'].decodeJsonNullableString(
        context: r'ServersIdActionsAttachToNetworkPostBodyBodyModel.ip',
      ),
      aliasIps: _$map[r'alias_ips'].decodeJsonNullableList<_i3.String>(
        context: r'ServersIdActionsAttachToNetworkPostBodyBodyModel.alias_ips',
      ),
      ipRange: _$map[r'ip_range'].decodeJsonNullableString(
        context: r'ServersIdActionsAttachToNetworkPostBodyBodyModel.ip_range',
      ),
    );
  }

  factory ServersIdActionsAttachToNetworkPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'network', r'ip', r'alias_ips', r'ip_range'},
      listKeys: {r'alias_ips'},
      context: r'ServersIdActionsAttachToNetworkPostBodyBodyModel',
    );
    return ServersIdActionsAttachToNetworkPostBodyBodyModel(
      network: _$values[r'network'].decodeFormInt(
        context: r'ServersIdActionsAttachToNetworkPostBodyBodyModel.network',
      ),
      ip: _$values[r'ip'].decodeFormNullableString(
        context: r'ServersIdActionsAttachToNetworkPostBodyBodyModel.ip',
      ),
      aliasIps: _$values[r'alias_ips'].decodeFormNullableStringList(
        context: r'ServersIdActionsAttachToNetworkPostBodyBodyModel.alias_ips',
      ),
      ipRange: _$values[r'ip_range'].decodeFormNullableString(
        context: r'ServersIdActionsAttachToNetworkPostBodyBodyModel.ip_range',
      ),
    );
  }

  /// ID of an existing network to attach the Server to.
  ///
  /// **Example**:
  /// ```json
  /// 4711
  /// ```
  final _i3.int network;

  /// IP to request to be assigned to this Server; if you do not provide this then you will be auto assigned an IP address.
  ///
  /// **Example**:
  /// ```
  /// 10.0.1.1
  /// ```
  final _i3.String? ip;

  /// Additional IPs to be assigned to this Server.
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   "10.0.1.2"
  /// ]
  /// ```
  final _i3.List<_i3.String>? aliasIps;

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
    if (this.aliasIps != null) r'alias_ips': this.aliasIps,
    if (this.ipRange != null) r'ip_range': this.ipRange,
  };

  ServersIdActionsAttachToNetworkPostBodyBodyModel Function({
    _i3.int? network,
    _i3.String? ip,
    _i3.List<_i3.String>? aliasIps,
    _i3.String? ipRange,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? network,
      _i3.Object? ip = _sentinel,
      _i3.Object? aliasIps = _sentinel,
      _i3.Object? ipRange = _sentinel,
    }) => ServersIdActionsAttachToNetworkPostBodyBodyModel(
      network: network ?? this.network,
      ip: _i3.identical(ip, _sentinel) ? this.ip : (ip as _i3.String?),
      aliasIps: _i3.identical(aliasIps, _sentinel)
          ? this.aliasIps
          : (aliasIps as _i3.List<_i3.String>?),
      ipRange: _i3.identical(ipRange, _sentinel)
          ? this.ipRange
          : (ipRange as _i3.String?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is ServersIdActionsAttachToNetworkPostBodyBodyModel &&
        other.network == this.network &&
        other.ip == this.ip &&
        _$deepEquals.equals(other.aliasIps, this.aliasIps) &&
        other.ipRange == this.ipRange;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.network,
      this.ip,
      deepEquals.hash(this.aliasIps),
      this.ipRange,
    ]);
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
    if (this.aliasIps != null) {
      _$result[r'alias_ips'] = _i1.PropertyValue.array(this.aliasIps!);
    }
    if (this.ipRange != null) {
      _$result[r'ip_range'] = _i1.PropertyValue.scalar(this.ipRange!);
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
      r'Cannot uriEncode ServersIdActionsAttachToNetworkPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
