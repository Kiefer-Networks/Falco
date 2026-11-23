// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i8;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i7;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_get200_body_rrset_protection_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_get200_body_rrset_records_array_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_get200_body_rrset_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel({
    required this.id,
    required this.name,
    required this.$type,
    required this.ttl,
    required this.labels,
    required this.protection,
    required this.records,
    required this.zone,
  });

  factory ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel: contains complex types',
    );
  }

  factory ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel',
    );
    return ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel(
      id: _$map[r'id'].decodeJsonString(
        context: r'ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel.name',
      ),
      $type:
          _i4.ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetTypeModel.fromJson(
            _$map[r'type'],
          ),
      ttl: _$map[r'ttl'].decodeJsonNullableInt(
        context: r'ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel.ttl',
      ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context:
              r'ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel.labels',
        ),
        context: r'ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel.labels',
      ),
      protection:
          _i5.ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetProtectionModel.fromJson(
            _$map[r'protection'],
          ),
      records: _$map[r'records']
          .decodeJsonList<_i3.Object?>(
            context:
                r'ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel.records',
          )
          .map(
            _i6
                .ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetRecordsArrayModel
                .fromJson,
          )
          .toList(),
      zone: _$map[r'zone'].decodeJsonInt(
        context: r'ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel.zone',
      ),
    );
  }

  factory ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel: contains complex types',
    );
  }

  /// ID of the RRSet.
  ///
  /// The ID is composed of the name and type, joined with a slash (e.g. `www/AAAA`).
  ///
  final _i3.String id;

  /// Name of the [RRSet](#tag/zone-rrsets).
  ///
  /// The name must be in lower case, and must not end with a dot or the [Zone](#tag/zones)
  /// name. Names containing non-ASCII characters must be transcribed to
  /// [Punycode](https://wikipedia.org/wiki/Punycode) representation with ACE prefix, e.g.
  /// `xn--4bi` (✉️).
  ///
  /// For the [Zone](#tag/zones) apex, use `@`.
  ///
  ///
  /// **Example**:
  /// ```
  /// www
  /// ```
  final _i3.String name;

  /// Type of the [RRSet](#tag/zone-rrsets).
  ///
  ///
  /// **Example**:
  /// ```
  /// A
  /// ```
  final _i4.ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetTypeModel $type;

  /// Time To Live (TTL) of the [RRSet](#tag/zone-rrsets).
  ///
  /// Must be in between 60s and 2147483647s.
  ///
  /// If not set, the [Zone's](#tag/zones) Default TTL is used.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 3600
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
  final _i3.Map<_i3.String, _i3.String> labels;

  /// Protection of the [RRSet](#tag/zone-rrsets).
  ///
  final _i5.ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetProtectionModel
  protection;

  /// Records of the [RRSet](#tag/zone-rrsets).
  ///
  /// Must not be empty and must only contain distinct record values.
  /// The order of records returned in responses is not guaranteed to be consistent.
  ///
  final _i3.List<
    _i6.ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetRecordsArrayModel
  >
  records;

  /// ID of the [Zone](#tag/zones).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int zone;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'type': this.$type.toJson(),
    r'ttl': this.ttl,
    r'labels': this.labels,
    r'protection': this.protection.toJson(),
    r'records': this.records.map((e) => e.toJson()).toList(),
    r'zone': this.zone,
  };

  ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel Function({
    _i3.String? id,
    _i3.String? name,
    _i4.ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetTypeModel? $type,
    _i3.int? ttl,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i5.ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetProtectionModel?
    protection,
    _i3.List<
      _i6.ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetRecordsArrayModel
    >?
    records,
    _i3.int? zone,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.String? id,
      _i3.String? name,
      _i4.ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetTypeModel? $type,
      _i3.Object? ttl = _sentinel,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i5.ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetProtectionModel?
      protection,
      _i3.List<
        _i6.ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetRecordsArrayModel
      >?
      records,
      _i3.int? zone,
    }) => ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      $type: $type ?? this.$type,
      ttl: _i3.identical(ttl, _sentinel) ? this.ttl : (ttl as _i3.int?),
      labels: labels ?? this.labels,
      protection: protection ?? this.protection,
      records: records ?? this.records,
      zone: zone ?? this.zone,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i7.DeepCollectionEquality();
    return other is ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel &&
        other.id == this.id &&
        other.name == this.name &&
        other.$type == this.$type &&
        other.ttl == this.ttl &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.protection == this.protection &&
        _$deepEquals.equals(other.records, this.records) &&
        other.zone == this.zone;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i7.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.name,
      this.$type,
      this.ttl,
      deepEquals.hash(this.labels),
      this.protection,
      deepEquals.hash(this.records),
      this.zone,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i8.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyRrsetModel: complex types cannot be URI-encoded',
    );
  }
}
