// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_set_records_post_body_body_records_array_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel({
    required this.records,
  });

  factory ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel: contains complex types',
    );
  }

  factory ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context:
          r'ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel',
    );
    return ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel(
      records: _$map[r'records']
          .decodeJsonList<_i3.Object?>(
            context: r'ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel.records',
          )
          .map(
            _i4
                .ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyRecordsArrayModel
                .fromJson,
          )
          .toList(),
    );
  }

  factory ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel: contains complex types',
    );
  }

  /// Records to set in the [RRSet](#tag/zone-rrsets).
  ///
  /// Must not be empty and must only contain distinct record values.
  ///
  final _i3.List<
    _i4.ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyRecordsArrayModel
  >
  records;

  @_i3.override
  _i3.Object? toJson() => {
    r'records': this.records.map((e) => e.toJson()).toList(),
  };

  ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel Function({
    _i3.List<
      _i4.ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyRecordsArrayModel
    >?
    records,
  })
  get copyWith {
    return ({
      _i3.List<
        _i4.ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyRecordsArrayModel
      >?
      records,
    }) => ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel(
      records: records ?? this.records,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other
            is ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel &&
        _$deepEquals.equals(other.records, this.records);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return deepEquals.hash(this.records);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
