// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersPost201BodyServerPrivateNetArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersPost201BodyServerPrivateNetArrayModel({
    this.network,
    this.ip,
    this.aliasIps,
    this.macAddress,
  });

  factory ServersPost201BodyServerPrivateNetArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'network', r'ip', r'alias_ips', r'mac_address'},
      listKeys: {r'alias_ips'},
      context: r'ServersPost201BodyServerPrivateNetArrayModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ServersPost201BodyServerPrivateNetArrayModel(
      network: _$values[r'network'].decodeSimpleNullableInt(
        context: r'ServersPost201BodyServerPrivateNetArrayModel.network',
      ),
      ip: _$values[r'ip'].decodeSimpleNullableString(
        context: r'ServersPost201BodyServerPrivateNetArrayModel.ip',
      ),
      aliasIps: _$values[r'alias_ips'].decodeSimpleNullableStringList(
        context: r'ServersPost201BodyServerPrivateNetArrayModel.alias_ips',
        isHeader: isHeader,
      ),
      macAddress: _$values[r'mac_address'].decodeSimpleNullableString(
        context: r'ServersPost201BodyServerPrivateNetArrayModel.mac_address',
      ),
    );
  }

  factory ServersPost201BodyServerPrivateNetArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ServersPost201BodyServerPrivateNetArrayModel',
    );
    return ServersPost201BodyServerPrivateNetArrayModel(
      network: _$map[r'network'].decodeJsonNullableInt(
        context: r'ServersPost201BodyServerPrivateNetArrayModel.network',
      ),
      ip: _$map[r'ip'].decodeJsonNullableString(
        context: r'ServersPost201BodyServerPrivateNetArrayModel.ip',
      ),
      aliasIps: _$map[r'alias_ips'].decodeJsonNullableList<_i3.String>(
        context: r'ServersPost201BodyServerPrivateNetArrayModel.alias_ips',
      ),
      macAddress: _$map[r'mac_address'].decodeJsonNullableString(
        context: r'ServersPost201BodyServerPrivateNetArrayModel.mac_address',
      ),
    );
  }

  factory ServersPost201BodyServerPrivateNetArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'network', r'ip', r'alias_ips', r'mac_address'},
      listKeys: {r'alias_ips'},
      context: r'ServersPost201BodyServerPrivateNetArrayModel',
    );
    return ServersPost201BodyServerPrivateNetArrayModel(
      network: _$values[r'network'].decodeFormNullableInt(
        context: r'ServersPost201BodyServerPrivateNetArrayModel.network',
      ),
      ip: _$values[r'ip'].decodeFormNullableString(
        context: r'ServersPost201BodyServerPrivateNetArrayModel.ip',
      ),
      aliasIps: _$values[r'alias_ips'].decodeFormNullableStringList(
        context: r'ServersPost201BodyServerPrivateNetArrayModel.alias_ips',
      ),
      macAddress: _$values[r'mac_address'].decodeFormNullableString(
        context: r'ServersPost201BodyServerPrivateNetArrayModel.mac_address',
      ),
    );
  }

  /// The Network ID the server is attached to.
  ///
  /// **Example**:
  /// ```json
  /// 4711
  /// ```
  final _i3.int? network;

  /// The server IP address on the network.
  ///
  /// **Example**:
  /// ```
  /// 10.0.0.2
  /// ```
  final _i3.String? ip;

  /// Additional IP addresses of the server on the network.
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   "10.0.0.3",
  ///   "10.0.0.4"
  /// ]
  /// ```
  final _i3.List<_i3.String>? aliasIps;

  /// The server MAC address on the network.
  ///
  /// **Example**:
  /// ```
  /// 86:00:ff:2a:7d:e1
  /// ```
  final _i3.String? macAddress;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.network != null) r'network': this.network,
    if (this.ip != null) r'ip': this.ip,
    if (this.aliasIps != null) r'alias_ips': this.aliasIps,
    if (this.macAddress != null) r'mac_address': this.macAddress,
  };

  ServersPost201BodyServerPrivateNetArrayModel Function({
    _i3.int? network,
    _i3.String? ip,
    _i3.List<_i3.String>? aliasIps,
    _i3.String? macAddress,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? network = _sentinel,
      _i3.Object? ip = _sentinel,
      _i3.Object? aliasIps = _sentinel,
      _i3.Object? macAddress = _sentinel,
    }) => ServersPost201BodyServerPrivateNetArrayModel(
      network: _i3.identical(network, _sentinel)
          ? this.network
          : (network as _i3.int?),
      ip: _i3.identical(ip, _sentinel) ? this.ip : (ip as _i3.String?),
      aliasIps: _i3.identical(aliasIps, _sentinel)
          ? this.aliasIps
          : (aliasIps as _i3.List<_i3.String>?),
      macAddress: _i3.identical(macAddress, _sentinel)
          ? this.macAddress
          : (macAddress as _i3.String?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is ServersPost201BodyServerPrivateNetArrayModel &&
        other.network == this.network &&
        other.ip == this.ip &&
        _$deepEquals.equals(other.aliasIps, this.aliasIps) &&
        other.macAddress == this.macAddress;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.network,
      this.ip,
      deepEquals.hash(this.aliasIps),
      this.macAddress,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (this.network != null) {
      _$result[r'network'] = _i1.PropertyValue.scalar(this.network!.toString());
    }
    if (this.ip != null) {
      _$result[r'ip'] = _i1.PropertyValue.scalar(this.ip!);
    }
    if (this.aliasIps != null) {
      _$result[r'alias_ips'] = _i1.PropertyValue.array(this.aliasIps!);
    }
    if (this.macAddress != null) {
      _$result[r'mac_address'] = _i1.PropertyValue.scalar(this.macAddress!);
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
      r'Cannot uriEncode ServersPost201BodyServerPrivateNetArrayModel: complex types cannot be URI-encoded',
    );
  }
}
