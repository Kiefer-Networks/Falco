// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_get200_body_zones_array_one_of_all_of_primary_nameservers_array_tsig_algorithm_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Primary nameserver that returns [Zones](#tag/zones) via `AXFR`.
///
/// Must allow queries from and may send `NOTIFY` queries to [Hetzner's secondary
/// nameservers](https://docs.hetzner.com/dns-console/dns/general/authoritative-name-servers#secondary-dns-servers-old-name-servers-for-robot-customers).
///
@_i2.immutable
class ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel({
    required this.address,
    this.port = portDefault,
    this.tsigKey,
    this.tsigAlgorithm,
  });

  factory ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel.fromSimple(
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
          r'ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel(
      address: _$values[r'address'].decodeSimpleString(
        context: r'ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel.address',
      ),
      port: _$values.containsKey(r'port')
          ? _$values[r'port'].decodeSimpleInt(
              context: r'ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel.port',
            )
          : portDefault,
      tsigKey: _$values[r'tsig_key'].decodeSimpleNullableString(
        context: r'ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel.tsig_key',
      ),
      tsigAlgorithm: _$values[r'tsig_algorithm'] == null
          ? null
          : _i4.ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayTsigAlgorithmModel.fromSimple(
              _$values[r'tsig_algorithm'],
              explode: explode,
            ),
    );
  }

  factory ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context:
          r'ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel',
    );
    return ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel(
      address: _$map[r'address'].decodeJsonString(
        context: r'ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel.address',
      ),
      port: _$map.containsKey(r'port')
          ? _$map[r'port'].decodeJsonInt(
              context: r'ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel.port',
            )
          : portDefault,
      tsigKey: _$map[r'tsig_key'].decodeJsonNullableString(
        context: r'ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel.tsig_key',
      ),
      tsigAlgorithm: _$map[r'tsig_algorithm'] == null
          ? null
          : _i4.ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayTsigAlgorithmModel.fromJson(
              _$map[r'tsig_algorithm'],
            ),
    );
  }

  factory ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'address', r'port', r'tsig_key', r'tsig_algorithm'},
      listKeys: {},
      context:
          r'ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel',
    );
    return ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel(
      address: _$values[r'address'].decodeFormString(
        context: r'ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel.address',
      ),
      port: _$values.containsKey(r'port')
          ? _$values[r'port'].decodeFormInt(
              context: r'ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel.port',
            )
          : portDefault,
      tsigKey: _$values[r'tsig_key'].decodeFormNullableString(
        context: r'ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel.tsig_key',
      ),
      tsigAlgorithm: _$values[r'tsig_algorithm'] == null
          ? null
          : _i4.ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayTsigAlgorithmModel.fromForm(
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
  final _i4.ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayTsigAlgorithmModel?
  tsigAlgorithm;

  @_i3.override
  _i3.Object? toJson() => {
    r'address': this.address,
    if (this.port != null) r'port': this.port,
    if (this.tsigKey != null) r'tsig_key': this.tsigKey,
    if (this.tsigAlgorithm != null)
      r'tsig_algorithm': this.tsigAlgorithm?.toJson(),
  };

  ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel Function({
    _i3.String? address,
    _i3.int? port,
    _i3.String? tsigKey,
    _i4.ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayTsigAlgorithmModel?
    tsigAlgorithm,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.String? address,
      _i3.Object? port = _sentinel,
      _i3.Object? tsigKey = _sentinel,
      _i3.Object? tsigAlgorithm = _sentinel,
    }) => ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel(
      address: address ?? this.address,
      port: _i3.identical(port, _sentinel) ? this.port : (port as _i3.int?),
      tsigKey: _i3.identical(tsigKey, _sentinel)
          ? this.tsigKey
          : (tsigKey as _i3.String?),
      tsigAlgorithm: _i3.identical(tsigAlgorithm, _sentinel)
          ? this.tsigAlgorithm
          : (tsigAlgorithm
                as _i4.ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayTsigAlgorithmModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel &&
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
      r'Cannot uriEncode ZonesGet200BodyZonesArrayOneOfAllOfPrimaryNameserversArrayModel: complex types cannot be URI-encoded',
    );
  }
}
