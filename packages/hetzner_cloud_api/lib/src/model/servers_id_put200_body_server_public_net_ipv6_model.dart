// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/servers_id_put200_body_server_public_net_ipv6_dns_ptr_array_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// IPv6 network assigned to this Server and its reverse DNS entry.
@_i2.immutable
class $RawServersIdPut200BodyServerPublicNetIpv6Model
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const $RawServersIdPut200BodyServerPublicNetIpv6Model({
    required this.ip,
    required this.blocked,
    required this.dnsPtr,
    this.id,
  });

  factory $RawServersIdPut200BodyServerPublicNetIpv6Model.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for $RawServersIdPut200BodyServerPublicNetIpv6Model: contains complex types',
    );
  }

  factory $RawServersIdPut200BodyServerPublicNetIpv6Model.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'$RawServersIdPut200BodyServerPublicNetIpv6Model',
    );
    return $RawServersIdPut200BodyServerPublicNetIpv6Model(
      id: _$map[r'id'].decodeJsonNullableInt(
        context: r'$RawServersIdPut200BodyServerPublicNetIpv6Model.id',
      ),
      ip: _$map[r'ip'].decodeJsonString(
        context: r'$RawServersIdPut200BodyServerPublicNetIpv6Model.ip',
      ),
      blocked: _$map[r'blocked'].decodeJsonBool(
        context: r'$RawServersIdPut200BodyServerPublicNetIpv6Model.blocked',
      ),
      dnsPtr: _$map[r'dns_ptr']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'$RawServersIdPut200BodyServerPublicNetIpv6Model.dns_ptr',
          )
          ?.map(
            _i4.ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel.fromJson,
          )
          .toList(),
    );
  }

  factory $RawServersIdPut200BodyServerPublicNetIpv6Model.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for $RawServersIdPut200BodyServerPublicNetIpv6Model: contains complex types',
    );
  }

  /// ID of the [Primary IP](#tag/primary-ips).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int? id;

  /// IP address (v6) of this Server.
  ///
  /// **Example**:
  /// ```
  /// 2001:db8::/64
  /// ```
  final _i3.String ip;

  /// Whether the IP is blocked by our abuse department.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool blocked;

  /// Reverse DNS PTR entries for the IPv6 addresses of this Server.
  final _i3.List<_i4.ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel>?
  dnsPtr;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.id != null) r'id': this.id,
    r'ip': this.ip,
    r'blocked': this.blocked,
    r'dns_ptr': this.dnsPtr?.map((e) => e.toJson()).toList(),
  };

  $RawServersIdPut200BodyServerPublicNetIpv6Model Function({
    _i3.int? id,
    _i3.String? ip,
    _i3.bool? blocked,
    _i3.List<_i4.ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel>?
    dnsPtr,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? id = _sentinel,
      _i3.String? ip,
      _i3.bool? blocked,
      _i3.Object? dnsPtr = _sentinel,
    }) => $RawServersIdPut200BodyServerPublicNetIpv6Model(
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int?),
      ip: ip ?? this.ip,
      blocked: blocked ?? this.blocked,
      dnsPtr: _i3.identical(dnsPtr, _sentinel)
          ? this.dnsPtr
          : (dnsPtr
                as _i3.List<
                  _i4.ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel
                >?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is $RawServersIdPut200BodyServerPublicNetIpv6Model &&
        other.id == this.id &&
        other.ip == this.ip &&
        other.blocked == this.blocked &&
        _$deepEquals.equals(other.dnsPtr, this.dnsPtr);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.ip,
      this.blocked,
      deepEquals.hash(this.dnsPtr),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServersIdPut200BodyServerPublicNetIpv6Model: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode $RawServersIdPut200BodyServerPublicNetIpv6Model: complex types cannot be URI-encoded',
    );
  }
}

typedef ServersIdPut200BodyServerPublicNetIpv6Model =
    $RawServersIdPut200BodyServerPublicNetIpv6Model?;
