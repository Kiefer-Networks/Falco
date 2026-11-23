// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel({
    required this.ip,
    required this.dnsPtr,
  });

  factory PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'ip', r'dns_ptr'},
      listKeys: {},
      context: r'PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel(
      ip: _$values[r'ip'].decodeSimpleString(
        context: r'PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel.ip',
      ),
      dnsPtr: _$values[r'dns_ptr'].decodeSimpleString(
        context: r'PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel.dns_ptr',
      ),
    );
  }

  factory PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel',
    );
    return PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel(
      ip: _$map[r'ip'].decodeJsonString(
        context: r'PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel.ip',
      ),
      dnsPtr: _$map[r'dns_ptr'].decodeJsonString(
        context: r'PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel.dns_ptr',
      ),
    );
  }

  factory PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'ip', r'dns_ptr'},
      listKeys: {},
      context: r'PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel',
    );
    return PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel(
      ip: _$values[r'ip'].decodeFormString(
        context: r'PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel.ip',
      ),
      dnsPtr: _$values[r'dns_ptr'].decodeFormString(
        context: r'PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel.dns_ptr',
      ),
    );
  }

  /// Single IPv4 or IPv6 address of the record.
  ///
  ///
  /// **Example**:
  /// ```
  /// 2001:db8::1
  /// ```
  final _i3.String ip;

  /// Domain Name to point to.
  ///
  /// PTR record content used for reverse DNS.
  ///
  ///
  /// **Example**:
  /// ```
  /// server.example.com
  /// ```
  final _i3.String dnsPtr;

  @_i3.override
  _i3.Object? toJson() => {r'ip': this.ip, r'dns_ptr': this.dnsPtr};

  PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel Function({
    _i3.String? ip,
    _i3.String? dnsPtr,
  })
  get copyWith {
    return ({_i3.String? ip, _i3.String? dnsPtr}) =>
        PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel(
          ip: ip ?? this.ip,
          dnsPtr: dnsPtr ?? this.dnsPtr,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel &&
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
      r'Cannot uriEncode PrimaryIpsIdGet200BodyPrimaryIpDnsPtrArrayModel: complex types cannot be URI-encoded',
    );
  }
}
