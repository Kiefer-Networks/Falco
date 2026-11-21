// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel({
    required this.ip,
    required this.dnsPtr,
  });

  factory ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'ip', r'dns_ptr'},
      listKeys: {},
      context: r'ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel(
      ip: _$values[r'ip'].decodeSimpleString(
        context: r'ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel.ip',
      ),
      dnsPtr: _$values[r'dns_ptr'].decodeSimpleString(
        context:
            r'ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel.dns_ptr',
      ),
    );
  }

  factory ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel',
    );
    return ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel(
      ip: _$map[r'ip'].decodeJsonString(
        context: r'ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel.ip',
      ),
      dnsPtr: _$map[r'dns_ptr'].decodeJsonString(
        context:
            r'ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel.dns_ptr',
      ),
    );
  }

  factory ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'ip', r'dns_ptr'},
      listKeys: {},
      context: r'ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel',
    );
    return ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel(
      ip: _$values[r'ip'].decodeFormString(
        context: r'ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel.ip',
      ),
      dnsPtr: _$values[r'dns_ptr'].decodeFormString(
        context:
            r'ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel.dns_ptr',
      ),
    );
  }

  /// Single IPv6 address of this Server for which the reverse DNS entry has been set up.
  ///
  /// **Example**:
  /// ```
  /// 2001:db8::1
  /// ```
  final _i3.String ip;

  /// DNS pointer for the specific IP address.
  ///
  /// **Example**:
  /// ```
  /// server.example.com
  /// ```
  final _i3.String dnsPtr;

  @_i3.override
  _i3.Object? toJson() => {r'ip': this.ip, r'dns_ptr': this.dnsPtr};

  ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel Function({
    _i3.String? ip,
    _i3.String? dnsPtr,
  })
  get copyWith {
    return ({_i3.String? ip, _i3.String? dnsPtr}) =>
        ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel(
          ip: ip ?? this.ip,
          dnsPtr: dnsPtr ?? this.dnsPtr,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel &&
        other.ip == this.ip &&
        other.dnsPtr == this.dnsPtr;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.ip, this.dnsPtr]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'ip'] = _i1.PropertyValue.scalar(this.ip);
    _$result[r'dns_ptr'] = _i1.PropertyValue.scalar(this.dnsPtr);
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
      r'Cannot uriEncode ServersIdPut200BodyServerPublicNetIpv6DnsPtrArrayModel: complex types cannot be URI-encoded',
    );
  }
}
