// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i10;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i9;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_get200_body_zone_one_of_all_of_authoritative_nameservers_model2.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_get200_body_zone_one_of_all_of_primary_nameservers_array_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_get200_body_zone_one_of_all_of_protection_model2.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_get200_body_zone_one_of_all_of_registrar_model2.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_get200_body_zone_one_of_all_of_status_model2.dart'
    as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3({
    required this.id,
    required this.name,
    required this.created,
    required this.labels,
    required this.protection,
    required this.status,
    required this.recordCount,
    required this.authoritativeNameservers,
    required this.registrar,
    this.primaryNameservers,
    this.ttl = ttlDefault,
  });

  factory ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3: contains complex types',
    );
  }

  factory ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3',
    );
    return ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3(
      id: _$map[r'id'].decodeJsonInt(
        context: r'ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3.name',
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3.created',
      ),
      primaryNameservers: _$map[r'primary_nameservers']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3.primary_nameservers',
          )
          ?.map(
            _i4
                .ZonesIdOrNameGet200BodyZoneOneOfAllOfPrimaryNameserversArrayModel
                .fromJson,
          )
          .toList(),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context: r'ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3.labels',
        ),
        context: r'ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3.labels',
      ),
      protection:
          _i5.ZonesIdOrNameGet200BodyZoneOneOfAllOfProtectionModel2.fromJson(
            _$map[r'protection'],
          ),
      ttl: _$map.containsKey(r'ttl')
          ? _$map[r'ttl'].decodeJsonInt(
              context: r'ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3.ttl',
            )
          : ttlDefault,
      status: _i6.ZonesIdOrNameGet200BodyZoneOneOfAllOfStatusModel2.fromJson(
        _$map[r'status'],
      ),
      recordCount: _$map[r'record_count'].decodeJsonInt(
        context: r'ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3.record_count',
      ),
      authoritativeNameservers:
          _i7.ZonesIdOrNameGet200BodyZoneOneOfAllOfAuthoritativeNameserversModel2.fromJson(
            _$map[r'authoritative_nameservers'],
          ),
      registrar:
          _i8.ZonesIdOrNameGet200BodyZoneOneOfAllOfRegistrarModel2.fromJson(
            _$map[r'registrar'],
          ),
    );
  }

  factory ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3: contains complex types',
    );
  }

  static const _i3.int ttlDefault = 3600;

  /// ID of the [Zone](#tag/zones).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

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

  /// Point in time when the Resource was created (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  /// **Example**:
  /// ```
  /// 2016-01-30T23:55:00Z
  /// ```
  final _i3.DateTime created;

  /// Primary nameservers of the [Zone](#tag/zones).
  ///
  /// Only set if [Zone](#tag/zones) is in [secondary mode](#tag/zones/zone-modes), otherwise empty.
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
  final _i3.List<
    _i4.ZonesIdOrNameGet200BodyZoneOneOfAllOfPrimaryNameserversArrayModel
  >?
  primaryNameservers;

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
  final _i3.Map<_i3.String, _i3.String> labels;

  /// Protection configuration for the Resource.
  final _i5.ZonesIdOrNameGet200BodyZoneOneOfAllOfProtectionModel2 protection;

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
  final _i3.int ttl;

  /// Status of the [Zone](#tag/zones).
  ///
  final _i6.ZonesIdOrNameGet200BodyZoneOneOfAllOfStatusModel2 status;

  /// Number of resource records (RR) within the [Zone](#tag/zones).
  final _i3.int recordCount;

  final _i7.ZonesIdOrNameGet200BodyZoneOneOfAllOfAuthoritativeNameserversModel2
  authoritativeNameservers;

  /// Registrar of the domain.
  final _i8.ZonesIdOrNameGet200BodyZoneOneOfAllOfRegistrarModel2 registrar;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'created': this.created.toTimeZonedIso8601String(),
    if (this.primaryNameservers != null)
      r'primary_nameservers': this.primaryNameservers
          ?.map((e) => e.toJson())
          .toList(),
    r'labels': this.labels,
    r'protection': this.protection.toJson(),
    r'ttl': this.ttl,
    r'status': this.status.toJson(),
    r'record_count': this.recordCount,
    r'authoritative_nameservers': this.authoritativeNameservers.toJson(),
    r'registrar': this.registrar.toJson(),
  };

  ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3 Function({
    _i3.int? id,
    _i3.String? name,
    _i3.DateTime? created,
    _i3.List<
      _i4.ZonesIdOrNameGet200BodyZoneOneOfAllOfPrimaryNameserversArrayModel
    >?
    primaryNameservers,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i5.ZonesIdOrNameGet200BodyZoneOneOfAllOfProtectionModel2? protection,
    _i3.int? ttl,
    _i6.ZonesIdOrNameGet200BodyZoneOneOfAllOfStatusModel2? status,
    _i3.int? recordCount,
    _i7.ZonesIdOrNameGet200BodyZoneOneOfAllOfAuthoritativeNameserversModel2?
    authoritativeNameservers,
    _i8.ZonesIdOrNameGet200BodyZoneOneOfAllOfRegistrarModel2? registrar,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.String? name,
      _i3.DateTime? created,
      _i3.Object? primaryNameservers = _sentinel,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i5.ZonesIdOrNameGet200BodyZoneOneOfAllOfProtectionModel2? protection,
      _i3.int? ttl,
      _i6.ZonesIdOrNameGet200BodyZoneOneOfAllOfStatusModel2? status,
      _i3.int? recordCount,
      _i7.ZonesIdOrNameGet200BodyZoneOneOfAllOfAuthoritativeNameserversModel2?
      authoritativeNameservers,
      _i8.ZonesIdOrNameGet200BodyZoneOneOfAllOfRegistrarModel2? registrar,
    }) => ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3(
      id: id ?? this.id,
      name: name ?? this.name,
      created: created ?? this.created,
      primaryNameservers: _i3.identical(primaryNameservers, _sentinel)
          ? this.primaryNameservers
          : (primaryNameservers
                as _i3.List<
                  _i4.ZonesIdOrNameGet200BodyZoneOneOfAllOfPrimaryNameserversArrayModel
                >?),
      labels: labels ?? this.labels,
      protection: protection ?? this.protection,
      ttl: ttl ?? this.ttl,
      status: status ?? this.status,
      recordCount: recordCount ?? this.recordCount,
      authoritativeNameservers:
          authoritativeNameservers ?? this.authoritativeNameservers,
      registrar: registrar ?? this.registrar,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i9.DeepCollectionEquality();
    return other is ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3 &&
        other.id == this.id &&
        other.name == this.name &&
        other.created == this.created &&
        _$deepEquals.equals(
          other.primaryNameservers,
          this.primaryNameservers,
        ) &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.protection == this.protection &&
        other.ttl == this.ttl &&
        other.status == this.status &&
        other.recordCount == this.recordCount &&
        other.authoritativeNameservers == this.authoritativeNameservers &&
        other.registrar == this.registrar;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i9.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.name,
      this.created,
      deepEquals.hash(this.primaryNameservers),
      deepEquals.hash(this.labels),
      this.protection,
      this.ttl,
      this.status,
      this.recordCount,
      this.authoritativeNameservers,
      this.registrar,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i10.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ZonesIdOrNameGet200BodyZoneOneOfAllOfModel3: complex types cannot be URI-encoded',
    );
  }
}
