// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i8;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i7;
import 'package:hetzner_cloud_api/src/model/zones_post_body_body_mode_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_post_body_body_primary_nameservers_array_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/zones_post_body_body_rrsets_array_model.dart'
    as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesPostBodyBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesPostBodyBodyModel({
    required this.name,
    required this.mode,
    this.ttl = ttlDefault,
    this.labels,
    this.primaryNameservers,
    this.rrsets,
    this.zonefile,
  });

  factory ZonesPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ZonesPostBodyBodyModel: contains complex types',
    );
  }

  factory ZonesPostBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ZonesPostBodyBodyModel');
    return ZonesPostBodyBodyModel(
      name: _$map[r'name'].decodeJsonString(
        context: r'ZonesPostBodyBodyModel.name',
      ),
      mode: _i4.ZonesPostBodyBodyModeModel.fromJson(_$map[r'mode']),
      ttl: _$map.containsKey(r'ttl')
          ? _$map[r'ttl'].decodeJsonInt(context: r'ZonesPostBodyBodyModel.ttl')
          : ttlDefault,
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(context: r'ZonesPostBodyBodyModel.labels'),
        context: r'ZonesPostBodyBodyModel.labels',
      ),
      primaryNameservers: _$map[r'primary_nameservers']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'ZonesPostBodyBodyModel.primary_nameservers',
          )
          ?.map(_i5.ZonesPostBodyBodyPrimaryNameserversArrayModel.fromJson)
          .toList(),
      rrsets: _$map[r'rrsets']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'ZonesPostBodyBodyModel.rrsets',
          )
          ?.map(_i6.ZonesPostBodyBodyRrsetsArrayModel.fromJson)
          .toList(),
      zonefile: _$map[r'zonefile'].decodeJsonNullableString(
        context: r'ZonesPostBodyBodyModel.zonefile',
      ),
    );
  }

  factory ZonesPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ZonesPostBodyBodyModel: contains complex types',
    );
  }

  static const _i3.int ttlDefault = 3600;

  /// Name of the [Zone](#tag/zones).
  ///
  /// All names with [well-known public suffixes](https://publicsuffix.org/) (e.g. `.de`,
  /// `.com`, `.co.uk`) are supported. Subdomains are not supported.
  ///
  /// The name must be in lower case and must not end with a dot.
  /// [Internationalized domain
  /// names](https://en.wikipedia.org/wiki/Internationalized_domain_name) must be
  /// transcribed to [Punycode](https://wikipedia.org/wiki/Punycode) representation with
  /// ACE prefix, e.g. `xn--mnchen-3ya.de` (`münchen.de`).
  ///
  ///
  /// **Example**:
  /// ```
  /// example.com
  /// ```
  final _i3.String name;

  /// Mode of the [Zone](#tag/zones).
  ///
  /// For more information, see [Zone Modes](#tag/zones/zone-modes).
  ///
  ///
  /// **Example**:
  /// ```
  /// primary
  /// ```
  final _i4.ZonesPostBodyBodyModeModel mode;

  /// Default Time To Live (TTL) of the [Zone](#tag/zones).
  ///
  /// Must be in between 60s and 2147483647s.
  ///
  /// This TTL is used for [RRSets](#tag/zone-rrsets) that do not explicitly define a TTL.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 10800
  /// ```
  final _i3.int? ttl;

  /// User-defined labels (`key/value` pairs) for the Resource.
  /// For more information, see "[Labels](#description/labels)".
  ///
  ///
  /// **Example**:
  /// ```json
  /// {
  ///   "environment": "prod",
  ///   "example.com/my": "label",
  ///   "just-a-key": ""
  /// }
  /// ```
  final _i3.Map<_i3.String, _i3.String>? labels;

  /// Primary nameservers of the [Zone](#tag/zones).
  ///
  /// Only applicable for [Zones](#tag/zones) in secondary mode.
  /// Ignored for [Zones](#tag/zones) in primary mode.
  ///
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   {
  ///     "address": "198.51.100.1",
  ///     "port": 53
  ///   },
  ///   {
  ///     "address": "203.0.113.1",
  ///     "port": 53
  ///   }
  /// ]
  /// ```
  final _i3.List<_i5.ZonesPostBodyBodyPrimaryNameserversArrayModel>?
  primaryNameservers;

  /// [RRSets](#tag/zone-rrsets) to be added to the [Zone](#tag/zones).
  ///
  /// Only applicable for [Zones](#tag/zones) in primary mode.
  /// Ignored for [Zones](#tag/zones) in secondary mode.
  ///
  final _i3.List<_i6.ZonesPostBodyBodyRrsetsArrayModel>? rrsets;

  /// Zone file to import.
  ///
  /// Only applicable for [Zones](#tag/zones) in primary mode.
  /// Ignored for [Zones](#tag/zones) in secondary mode.
  ///
  /// If provided, `rrsets` must be empty.
  ///
  /// See [Zone file import](#tag/zones/zone-file-import) for more details.
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
  final _i3.String? zonefile;

  @_i3.override
  _i3.Object? toJson() => {
    r'name': this.name,
    r'mode': this.mode.toJson(),
    if (this.ttl != null) r'ttl': this.ttl,
    if (this.labels != null) r'labels': this.labels,
    if (this.primaryNameservers != null)
      r'primary_nameservers': this.primaryNameservers
          ?.map((e) => e.toJson())
          .toList(),
    if (this.rrsets != null)
      r'rrsets': this.rrsets?.map((e) => e.toJson()).toList(),
    if (this.zonefile != null) r'zonefile': this.zonefile,
  };

  ZonesPostBodyBodyModel Function({
    _i3.String? name,
    _i4.ZonesPostBodyBodyModeModel? mode,
    _i3.int? ttl,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i3.List<_i5.ZonesPostBodyBodyPrimaryNameserversArrayModel>?
    primaryNameservers,
    _i3.List<_i6.ZonesPostBodyBodyRrsetsArrayModel>? rrsets,
    _i3.String? zonefile,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.String? name,
      _i4.ZonesPostBodyBodyModeModel? mode,
      _i3.Object? ttl = _sentinel,
      _i3.Object? labels = _sentinel,
      _i3.Object? primaryNameservers = _sentinel,
      _i3.Object? rrsets = _sentinel,
      _i3.Object? zonefile = _sentinel,
    }) => ZonesPostBodyBodyModel(
      name: name ?? this.name,
      mode: mode ?? this.mode,
      ttl: _i3.identical(ttl, _sentinel) ? this.ttl : (ttl as _i3.int?),
      labels: _i3.identical(labels, _sentinel)
          ? this.labels
          : (labels as _i3.Map<_i3.String, _i3.String>?),
      primaryNameservers: _i3.identical(primaryNameservers, _sentinel)
          ? this.primaryNameservers
          : (primaryNameservers
                as _i3.List<
                  _i5.ZonesPostBodyBodyPrimaryNameserversArrayModel
                >?),
      rrsets: _i3.identical(rrsets, _sentinel)
          ? this.rrsets
          : (rrsets as _i3.List<_i6.ZonesPostBodyBodyRrsetsArrayModel>?),
      zonefile: _i3.identical(zonefile, _sentinel)
          ? this.zonefile
          : (zonefile as _i3.String?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i7.DeepCollectionEquality();
    return other is ZonesPostBodyBodyModel &&
        other.name == this.name &&
        other.mode == this.mode &&
        other.ttl == this.ttl &&
        _$deepEquals.equals(other.labels, this.labels) &&
        _$deepEquals.equals(
          other.primaryNameservers,
          this.primaryNameservers,
        ) &&
        _$deepEquals.equals(other.rrsets, this.rrsets) &&
        other.zonefile == this.zonefile;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i7.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.name,
      this.mode,
      this.ttl,
      deepEquals.hash(this.labels),
      deepEquals.hash(this.primaryNameservers),
      deepEquals.hash(this.rrsets),
      this.zonefile,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ZonesPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i8.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ZonesPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
