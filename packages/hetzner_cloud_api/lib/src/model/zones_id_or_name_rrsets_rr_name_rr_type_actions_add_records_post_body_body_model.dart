// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_add_records_post_body_body_records_array_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel({
    required this.records,
    this.ttl,
  });

  factory ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel: contains complex types',
    );
  }

  factory ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context:
          r'ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel',
    );
    return ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel(
      ttl: _$map[r'ttl'].decodeJsonNullableInt(
        context: r'ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel.ttl',
      ),
      records: _$map[r'records']
          .decodeJsonList<_i3.Object?>(
            context: r'ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel.records',
          )
          .map(
            _i4
                .ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyRecordsArrayModel
                .fromJson,
          )
          .toList(),
    );
  }

  factory ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel: contains complex types',
    );
  }

  /// Time To Live (TTL) of the [RRSet](#tag/zone-rrsets).
  ///
  /// If not set, the [Zone's](#tag/zones) Default TTL is used.
  /// If set, and the RRSet being updated already has a TTL, the values must be the same.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 3600
  /// ```
  final _i3.int? ttl;

  /// Records to add to the [RRSet](#tag/zone-rrsets).
  ///
  /// Must not be empty and must only contain distinct record values.
  ///
  final _i3.List<
    _i4.ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyRecordsArrayModel
  >
  records;

  @_i3.override
  _i3.Object? toJson() => {
    r'ttl': this.ttl,
    r'records': this.records.map((e) => e.toJson()).toList(),
  };

  ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel Function({
    _i3.int? ttl,
    _i3.List<
      _i4.ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyRecordsArrayModel
    >?
    records,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? ttl = _sentinel,
      _i3.List<
        _i4.ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyRecordsArrayModel
      >?
      records,
    }) => ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel(
      ttl: _i3.identical(ttl, _sentinel) ? this.ttl : (ttl as _i3.int?),
      records: records ?? this.records,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other
            is ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel &&
        other.ttl == this.ttl &&
        _$deepEquals.equals(other.records, this.records);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([this.ttl, deepEquals.hash(this.records)]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
