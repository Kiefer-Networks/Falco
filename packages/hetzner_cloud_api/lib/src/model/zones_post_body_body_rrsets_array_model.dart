// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:hetzner_cloud_api/src/model/zones_post_body_body_rrsets_array_records_array_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/zones_post_body_body_rrsets_array_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesPostBodyBodyRrsetsArrayModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesPostBodyBodyRrsetsArrayModel({
    required this.name,
    required this.$type,
    required this.records,
    this.ttl,
    this.labels,
  });

  factory ZonesPostBodyBodyRrsetsArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ZonesPostBodyBodyRrsetsArrayModel: contains complex types',
    );
  }

  factory ZonesPostBodyBodyRrsetsArrayModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ZonesPostBodyBodyRrsetsArrayModel');
    return ZonesPostBodyBodyRrsetsArrayModel(
      name: _$map[r'name'].decodeJsonString(
        context: r'ZonesPostBodyBodyRrsetsArrayModel.name',
      ),
      $type: _i4.ZonesPostBodyBodyRrsetsArrayTypeModel.fromJson(_$map[r'type']),
      ttl: _$map[r'ttl'].decodeJsonNullableInt(
        context: r'ZonesPostBodyBodyRrsetsArrayModel.ttl',
      ),
      records: _$map[r'records']
          .decodeJsonList<_i3.Object?>(
            context: r'ZonesPostBodyBodyRrsetsArrayModel.records',
          )
          .map(_i5.ZonesPostBodyBodyRrsetsArrayRecordsArrayModel.fromJson)
          .toList(),
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(
          context: r'ZonesPostBodyBodyRrsetsArrayModel.labels',
        ),
        context: r'ZonesPostBodyBodyRrsetsArrayModel.labels',
      ),
    );
  }

  factory ZonesPostBodyBodyRrsetsArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ZonesPostBodyBodyRrsetsArrayModel: contains complex types',
    );
  }

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
  final _i4.ZonesPostBodyBodyRrsetsArrayTypeModel $type;

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

  /// Records of the [RRSet](#tag/zone-rrsets).
  ///
  /// Must not be empty and must only contain distinct record values.
  /// The order of records returned in responses is not guaranteed to be consistent.
  ///
  final _i3.List<_i5.ZonesPostBodyBodyRrsetsArrayRecordsArrayModel> records;

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

  @_i3.override
  _i3.Object? toJson() => {
    r'name': this.name,
    r'type': this.$type.toJson(),
    r'ttl': this.ttl,
    r'records': this.records.map((e) => e.toJson()).toList(),
    if (this.labels != null) r'labels': this.labels,
  };

  ZonesPostBodyBodyRrsetsArrayModel Function({
    _i3.String? name,
    _i4.ZonesPostBodyBodyRrsetsArrayTypeModel? $type,
    _i3.int? ttl,
    _i3.List<_i5.ZonesPostBodyBodyRrsetsArrayRecordsArrayModel>? records,
    _i3.Map<_i3.String, _i3.String>? labels,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.String? name,
      _i4.ZonesPostBodyBodyRrsetsArrayTypeModel? $type,
      _i3.Object? ttl = _sentinel,
      _i3.List<_i5.ZonesPostBodyBodyRrsetsArrayRecordsArrayModel>? records,
      _i3.Object? labels = _sentinel,
    }) => ZonesPostBodyBodyRrsetsArrayModel(
      name: name ?? this.name,
      $type: $type ?? this.$type,
      ttl: _i3.identical(ttl, _sentinel) ? this.ttl : (ttl as _i3.int?),
      records: records ?? this.records,
      labels: _i3.identical(labels, _sentinel)
          ? this.labels
          : (labels as _i3.Map<_i3.String, _i3.String>?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is ZonesPostBodyBodyRrsetsArrayModel &&
        other.name == this.name &&
        other.$type == this.$type &&
        other.ttl == this.ttl &&
        _$deepEquals.equals(other.records, this.records) &&
        _$deepEquals.equals(other.labels, this.labels);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.name,
      this.$type,
      this.ttl,
      deepEquals.hash(this.records),
      deepEquals.hash(this.labels),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ZonesPostBodyBodyRrsetsArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ZonesPostBodyBodyRrsetsArrayModel: complex types cannot be URI-encoded',
    );
  }
}
