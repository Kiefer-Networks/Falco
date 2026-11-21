// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:hetzner_cloud_api/src/model/datacenters_get200_body_datacenters_array_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/datacenters_get200_body_meta_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DatacentersGet200BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DatacentersGet200BodyModel({
    required this.datacenters,
    required this.recommendation,
    required this.meta,
  });

  factory DatacentersGet200BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for DatacentersGet200BodyModel: contains complex types',
    );
  }

  factory DatacentersGet200BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'DatacentersGet200BodyModel');
    return DatacentersGet200BodyModel(
      datacenters: _$map[r'datacenters']
          .decodeJsonList<_i3.Object?>(
            context: r'DatacentersGet200BodyModel.datacenters',
          )
          .map(_i4.DatacentersGet200BodyDatacentersArrayModel.fromJson)
          .toList(),
      recommendation: _$map[r'recommendation'].decodeJsonInt(
        context: r'DatacentersGet200BodyModel.recommendation',
      ),
      meta: _i5.DatacentersGet200BodyMetaModel.fromJson(_$map[r'meta']),
    );
  }

  factory DatacentersGet200BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for DatacentersGet200BodyModel: contains complex types',
    );
  }

  /// List of [Data Centers](#tag/data-centers).
  final _i3.List<_i4.DatacentersGet200BodyDatacentersArrayModel> datacenters;

  /// This field is deprecated. Use the `recommended` flag in the [Server Type](#tag/server-types) `locations` field instead (`server_type.locations[].recommended`).
  ///
  /// Recommended [Data Center](#tag/data-centers) for creating new resources.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 1
  /// ```
  @_i3.Deprecated('This property is deprecated.')
  final _i3.int recommendation;

  final _i5.DatacentersGet200BodyMetaModel meta;

  @_i3.override
  _i3.Object? toJson() => {
    r'datacenters': this.datacenters.map((e) => e.toJson()).toList(),
    r'recommendation': this.recommendation,
    r'meta': this.meta.toJson(),
  };

  DatacentersGet200BodyModel Function({
    _i3.List<_i4.DatacentersGet200BodyDatacentersArrayModel>? datacenters,
    _i3.int? recommendation,
    _i5.DatacentersGet200BodyMetaModel? meta,
  })
  get copyWith {
    return ({
      _i3.List<_i4.DatacentersGet200BodyDatacentersArrayModel>? datacenters,
      _i3.int? recommendation,
      _i5.DatacentersGet200BodyMetaModel? meta,
    }) => DatacentersGet200BodyModel(
      datacenters: datacenters ?? this.datacenters,
      recommendation: recommendation ?? this.recommendation,
      meta: meta ?? this.meta,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is DatacentersGet200BodyModel &&
        _$deepEquals.equals(other.datacenters, this.datacenters) &&
        other.recommendation == this.recommendation &&
        other.meta == this.meta;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      deepEquals.hash(this.datacenters),
      this.recommendation,
      this.meta,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for DatacentersGet200BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DatacentersGet200BodyModel: complex types cannot be URI-encoded',
    );
  }
}
