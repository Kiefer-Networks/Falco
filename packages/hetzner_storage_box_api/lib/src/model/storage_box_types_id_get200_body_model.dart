// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_box_types_id_get200_body_storage_box_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxTypesIdGet200BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxTypesIdGet200BodyModel({required this.storageBoxType});

  factory StorageBoxTypesIdGet200BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for StorageBoxTypesIdGet200BodyModel: contains complex types',
    );
  }

  factory StorageBoxTypesIdGet200BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'StorageBoxTypesIdGet200BodyModel');
    return StorageBoxTypesIdGet200BodyModel(
      storageBoxType:
          _i4.StorageBoxTypesIdGet200BodyStorageBoxTypeModel.fromJson(
            _$map[r'storage_box_type'],
          ),
    );
  }

  factory StorageBoxTypesIdGet200BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for StorageBoxTypesIdGet200BodyModel: contains complex types',
    );
  }

  final _i4.StorageBoxTypesIdGet200BodyStorageBoxTypeModel storageBoxType;

  @_i3.override
  _i3.Object? toJson() => {r'storage_box_type': this.storageBoxType.toJson()};

  StorageBoxTypesIdGet200BodyModel Function({
    _i4.StorageBoxTypesIdGet200BodyStorageBoxTypeModel? storageBoxType,
  })
  get copyWith {
    return ({
      _i4.StorageBoxTypesIdGet200BodyStorageBoxTypeModel? storageBoxType,
    }) => StorageBoxTypesIdGet200BodyModel(
      storageBoxType: storageBoxType ?? this.storageBoxType,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is StorageBoxTypesIdGet200BodyModel &&
        other.storageBoxType == this.storageBoxType;
  }

  @_i3.override
  _i3.int get hashCode => this.storageBoxType.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for StorageBoxTypesIdGet200BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StorageBoxTypesIdGet200BodyModel: complex types cannot be URI-encoded',
    );
  }
}
