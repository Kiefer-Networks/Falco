// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesIdOrNameZonefileGet200BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesIdOrNameZonefileGet200BodyModel({required this.zonefile});

  factory ZonesIdOrNameZonefileGet200BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'zonefile'},
      listKeys: {},
      context: r'ZonesIdOrNameZonefileGet200BodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ZonesIdOrNameZonefileGet200BodyModel(
      zonefile: _$values[r'zonefile'].decodeSimpleString(
        context: r'ZonesIdOrNameZonefileGet200BodyModel.zonefile',
      ),
    );
  }

  factory ZonesIdOrNameZonefileGet200BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'ZonesIdOrNameZonefileGet200BodyModel',
    );
    return ZonesIdOrNameZonefileGet200BodyModel(
      zonefile: _$map[r'zonefile'].decodeJsonString(
        context: r'ZonesIdOrNameZonefileGet200BodyModel.zonefile',
      ),
    );
  }

  factory ZonesIdOrNameZonefileGet200BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'zonefile'},
      listKeys: {},
      context: r'ZonesIdOrNameZonefileGet200BodyModel',
    );
    return ZonesIdOrNameZonefileGet200BodyModel(
      zonefile: _$values[r'zonefile'].decodeFormString(
        context: r'ZonesIdOrNameZonefileGet200BodyModel.zonefile',
      ),
    );
  }

  /// Generated zone file.
  ///
  /// Example:
  ///
  /// ```dns
  /// $ORIGIN	example.com.
  /// $TTL	3600
  ///
  /// @	IN	SOA	hydrogen.ns.hetzner.com. dns.hetzner.com. 2024010100 86400 10800 3600000 3600
  ///
  /// @	IN	10800	NS	hydrogen.ns.hetzner.com. ; Some comment.
  /// @	IN	10800	NS	oxygen.ns.hetzner.com.
  /// @	IN	10800	NS	helium.ns.hetzner.de.
  /// ```
  ///
  ///
  /// **Example**:
  /// ```
  /// $ORIGIN	example.com.
  /// $TTL	3600
  ///
  /// @	IN	SOA	hydrogen.ns.hetzner.com. dns.hetzner.com. 2024010100 86400 10800 3600000 3600
  ///
  /// @	IN	10800	NS	hydrogen.ns.hetzner.com. ; Some comment.
  /// @	IN	10800	NS	oxygen.ns.hetzner.com.
  /// @	IN	10800	NS	helium.ns.hetzner.de.
  ///
  /// ```
  final _i3.String zonefile;

  @_i3.override
  _i3.Object? toJson() => {r'zonefile': this.zonefile};

  ZonesIdOrNameZonefileGet200BodyModel Function({_i3.String? zonefile})
  get copyWith {
    return ({_i3.String? zonefile}) => ZonesIdOrNameZonefileGet200BodyModel(
      zonefile: zonefile ?? this.zonefile,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesIdOrNameZonefileGet200BodyModel &&
        other.zonefile == this.zonefile;
  }

  @_i3.override
  _i3.int get hashCode => this.zonefile.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'zonefile'] = _i1.PropertyValue.scalar(this.zonefile);
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
      r'Cannot uriEncode ZonesIdOrNameZonefileGet200BodyModel: complex types cannot be URI-encoded',
    );
  }
}
