// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_id_or_name_put200_body_zone_one_of_all_of_primary_nameservers_array_tsig_algorithm_model2.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Primary nameserver that returns [Zones](#tag/zones) via `AXFR`.
///
/// Must allow queries from and may send `NOTIFY` queries to [Hetzner's secondary
/// nameservers](https://docs.hetzner.com/dns-console/dns/general/authoritative-name-servers#secondary-dns-servers-old-name-servers-for-robot-customers).
///
@_i2.immutable
class ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2({
    required this.address,
    this.port = portDefault,
    this.tsigKey,
    this.tsigAlgorithm,
  });

  factory ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'address', r'port', r'tsig_key', r'tsig_algorithm'},
      listKeys: {},
      context:
          r'ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2(
      address: _$values[r'address'].decodeSimpleString(
        context: r'ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2.address',
      ),
      port: _$values.containsKey(r'port')
          ? _$values[r'port'].decodeSimpleInt(
              context: r'ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2.port',
            )
          : portDefault,
      tsigKey: _$values[r'tsig_key'].decodeSimpleNullableString(
        context: r'ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2.tsig_key',
      ),
      tsigAlgorithm: _$values[r'tsig_algorithm'] == null
          ? null
          : _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayTsigAlgorithmModel2.fromSimple(
              _$values[r'tsig_algorithm'],
              explode: explode,
            ),
    );
  }

  factory ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context:
          r'ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2',
    );
    return ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2(
      address: _$map[r'address'].decodeJsonString(
        context: r'ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2.address',
      ),
      port: _$map.containsKey(r'port')
          ? _$map[r'port'].decodeJsonInt(
              context: r'ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2.port',
            )
          : portDefault,
      tsigKey: _$map[r'tsig_key'].decodeJsonNullableString(
        context: r'ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2.tsig_key',
      ),
      tsigAlgorithm: _$map[r'tsig_algorithm'] == null
          ? null
          : _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayTsigAlgorithmModel2.fromJson(
              _$map[r'tsig_algorithm'],
            ),
    );
  }

  factory ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'address', r'port', r'tsig_key', r'tsig_algorithm'},
      listKeys: {},
      context:
          r'ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2',
    );
    return ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2(
      address: _$values[r'address'].decodeFormString(
        context: r'ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2.address',
      ),
      port: _$values.containsKey(r'port')
          ? _$values[r'port'].decodeFormInt(
              context: r'ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2.port',
            )
          : portDefault,
      tsigKey: _$values[r'tsig_key'].decodeFormNullableString(
        context: r'ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2.tsig_key',
      ),
      tsigAlgorithm: _$values[r'tsig_algorithm'] == null
          ? null
          : _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayTsigAlgorithmModel2.fromForm(
              _$values[r'tsig_algorithm'],
              explode: explode,
            ),
    );
  }

  static const _i3.int portDefault = 53;

  /// Public IPv4 or IPv6 address of the primary nameserver.
  ///
  /// Must be unique across all primary nameservers of this zone.
  ///
  ///
  /// **Example**:
  /// ```
  /// 198.51.100.1
  /// ```
  final _i3.String address;

  /// Port of the primary nameserver.
  ///
  /// **Example**:
  /// ```json
  /// 5353
  /// ```
  final _i3.int? port;

  /// [Transaction signature (TSIG)](https://en.wikipedia.org/wiki/TSIG) key to use
  /// for the zone transfer. Must be base64 encoded.
  ///
  final _i3.String? tsigKey;

  /// [Transaction signature (TSIG)](https://en.wikipedia.org/wiki/TSIG) algorithm
  /// used to generate the TSIG key.
  ///
  final _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayTsigAlgorithmModel2?
  tsigAlgorithm;

  @_i3.override
  _i3.Object? toJson() => {
    r'address': this.address,
    if (this.port != null) r'port': this.port,
    if (this.tsigKey != null) r'tsig_key': this.tsigKey,
    if (this.tsigAlgorithm != null)
      r'tsig_algorithm': this.tsigAlgorithm?.toJson(),
  };

  ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2 Function({
    _i3.String? address,
    _i3.int? port,
    _i3.String? tsigKey,
    _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayTsigAlgorithmModel2?
    tsigAlgorithm,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.String? address,
      _i3.Object? port = _sentinel,
      _i3.Object? tsigKey = _sentinel,
      _i3.Object? tsigAlgorithm = _sentinel,
    }) => ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2(
      address: address ?? this.address,
      port: _i3.identical(port, _sentinel) ? this.port : (port as _i3.int?),
      tsigKey: _i3.identical(tsigKey, _sentinel)
          ? this.tsigKey
          : (tsigKey as _i3.String?),
      tsigAlgorithm: _i3.identical(tsigAlgorithm, _sentinel)
          ? this.tsigAlgorithm
          : (tsigAlgorithm
                as _i4.ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayTsigAlgorithmModel2?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2 &&
        other.address == this.address &&
        other.port == this.port &&
        other.tsigKey == this.tsigKey &&
        other.tsigAlgorithm == this.tsigAlgorithm;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.address,
      this.port,
      this.tsigKey,
      this.tsigAlgorithm,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'address'] = _i1.PropertyValue.scalar(this.address);
    if (this.port != null) {
      _$result[r'port'] = _i1.PropertyValue.scalar(this.port!.toString());
    }
    if (this.tsigKey != null) {
      _$result[r'tsig_key'] = _i1.PropertyValue.scalar(this.tsigKey!);
    }
    if (this.tsigAlgorithm != null) {
      _$result[r'tsig_algorithm'] = _i1.PropertyValue.scalar(
        this.tsigAlgorithm!.toJson(),
      );
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
      r'Cannot uriEncode ZonesIdOrNamePut200BodyZoneOneOfAllOfPrimaryNameserversArrayModel2: complex types cannot be URI-encoded',
    );
  }
}
