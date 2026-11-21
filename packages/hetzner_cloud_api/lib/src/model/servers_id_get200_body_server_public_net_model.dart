// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i8;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i7;
import 'package:hetzner_cloud_api/src/model/servers_id_get200_body_server_public_net_firewalls_array_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/servers_id_get200_body_server_public_net_ipv4_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_get200_body_server_public_net_ipv6_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Public network information. The Server's IPv4 address can be found in `public_net->ipv4->ip`.
@_i2.immutable
class ServersIdGet200BodyServerPublicNetModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdGet200BodyServerPublicNetModel({
    required this.ipv4,
    required this.ipv6,
    required this.floatingIps,
    this.firewalls,
  });

  factory ServersIdGet200BodyServerPublicNetModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServersIdGet200BodyServerPublicNetModel: contains complex types',
    );
  }

  factory ServersIdGet200BodyServerPublicNetModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'ServersIdGet200BodyServerPublicNetModel',
    );
    return ServersIdGet200BodyServerPublicNetModel(
      ipv4: _$map[r'ipv4'] == null
          ? null
          : _i4.ServersIdGet200BodyServerPublicNetIpv4Model.fromJson(
              _$map[r'ipv4'],
            ),
      ipv6: _$map[r'ipv6'] == null
          ? null
          : _i5.ServersIdGet200BodyServerPublicNetIpv6Model.fromJson(
              _$map[r'ipv6'],
            ),
      floatingIps: _$map[r'floating_ips'].decodeJsonList<_i3.int>(
        context: r'ServersIdGet200BodyServerPublicNetModel.floating_ips',
      ),
      firewalls: _$map[r'firewalls']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'ServersIdGet200BodyServerPublicNetModel.firewalls',
          )
          ?.map(
            _i6.ServersIdGet200BodyServerPublicNetFirewallsArrayModel.fromJson,
          )
          .toList(),
    );
  }

  factory ServersIdGet200BodyServerPublicNetModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServersIdGet200BodyServerPublicNetModel: contains complex types',
    );
  }

  /// IP address (v4) and its reverse DNS entry of this Server.
  final _i4.ServersIdGet200BodyServerPublicNetIpv4Model? ipv4;

  /// IPv6 network assigned to this Server and its reverse DNS entry.
  final _i5.ServersIdGet200BodyServerPublicNetIpv6Model? ipv6;

  /// IDs of Floating IPs assigned to this Server.
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   478
  /// ]
  /// ```
  final _i3.List<_i3.int> floatingIps;

  /// Firewalls applied to the public network interface of this Server.
  final _i3.List<_i6.ServersIdGet200BodyServerPublicNetFirewallsArrayModel>?
  firewalls;

  @_i3.override
  _i3.Object? toJson() => {
    r'ipv4': this.ipv4?.toJson(),
    r'ipv6': this.ipv6?.toJson(),
    r'floating_ips': this.floatingIps,
    if (this.firewalls != null)
      r'firewalls': this.firewalls?.map((e) => e.toJson()).toList(),
  };

  ServersIdGet200BodyServerPublicNetModel Function({
    _i4.ServersIdGet200BodyServerPublicNetIpv4Model? ipv4,
    _i5.ServersIdGet200BodyServerPublicNetIpv6Model? ipv6,
    _i3.List<_i3.int>? floatingIps,
    _i3.List<_i6.ServersIdGet200BodyServerPublicNetFirewallsArrayModel>?
    firewalls,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? ipv4 = _sentinel,
      _i3.Object? ipv6 = _sentinel,
      _i3.List<_i3.int>? floatingIps,
      _i3.Object? firewalls = _sentinel,
    }) => ServersIdGet200BodyServerPublicNetModel(
      ipv4: _i3.identical(ipv4, _sentinel)
          ? this.ipv4
          : (ipv4 as _i4.ServersIdGet200BodyServerPublicNetIpv4Model?),
      ipv6: _i3.identical(ipv6, _sentinel)
          ? this.ipv6
          : (ipv6 as _i5.ServersIdGet200BodyServerPublicNetIpv6Model?),
      floatingIps: floatingIps ?? this.floatingIps,
      firewalls: _i3.identical(firewalls, _sentinel)
          ? this.firewalls
          : (firewalls
                as _i3.List<
                  _i6.ServersIdGet200BodyServerPublicNetFirewallsArrayModel
                >?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i7.DeepCollectionEquality();
    return other is ServersIdGet200BodyServerPublicNetModel &&
        other.ipv4 == this.ipv4 &&
        other.ipv6 == this.ipv6 &&
        _$deepEquals.equals(other.floatingIps, this.floatingIps) &&
        _$deepEquals.equals(other.firewalls, this.firewalls);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i7.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.ipv4,
      this.ipv6,
      deepEquals.hash(this.floatingIps),
      deepEquals.hash(this.firewalls),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServersIdGet200BodyServerPublicNetModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i8.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServersIdGet200BodyServerPublicNetModel: complex types cannot be URI-encoded',
    );
  }
}
