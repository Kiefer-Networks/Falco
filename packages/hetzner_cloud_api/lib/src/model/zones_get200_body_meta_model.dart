// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/zones_get200_body_meta_pagination_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ZonesGet200BodyMetaModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ZonesGet200BodyMetaModel({required this.pagination});

  factory ZonesGet200BodyMetaModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ZonesGet200BodyMetaModel: contains complex types',
    );
  }

  factory ZonesGet200BodyMetaModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ZonesGet200BodyMetaModel');
    return ZonesGet200BodyMetaModel(
      pagination: _i4.ZonesGet200BodyMetaPaginationModel.fromJson(
        _$map[r'pagination'],
      ),
    );
  }

  factory ZonesGet200BodyMetaModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ZonesGet200BodyMetaModel: contains complex types',
    );
  }

  /// See "[Pagination](#description/pagination)" for more information.
  final _i4.ZonesGet200BodyMetaPaginationModel pagination;

  @_i3.override
  _i3.Object? toJson() => {r'pagination': this.pagination.toJson()};

  ZonesGet200BodyMetaModel Function({
    _i4.ZonesGet200BodyMetaPaginationModel? pagination,
  })
  get copyWith {
    return ({_i4.ZonesGet200BodyMetaPaginationModel? pagination}) =>
        ZonesGet200BodyMetaModel(pagination: pagination ?? this.pagination);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ZonesGet200BodyMetaModel &&
        other.pagination == this.pagination;
  }

  @_i3.override
  _i3.int get hashCode => this.pagination.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ZonesGet200BodyMetaModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ZonesGet200BodyMetaModel: complex types cannot be URI-encoded',
    );
  }
}
