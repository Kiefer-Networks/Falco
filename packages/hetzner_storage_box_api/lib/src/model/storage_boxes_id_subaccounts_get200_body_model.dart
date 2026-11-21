// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_get200_body_subaccounts_array_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesIdSubaccountsGet200BodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdSubaccountsGet200BodyModel({required this.subaccounts});

  factory StorageBoxesIdSubaccountsGet200BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for StorageBoxesIdSubaccountsGet200BodyModel: contains complex types',
    );
  }

  factory StorageBoxesIdSubaccountsGet200BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdSubaccountsGet200BodyModel',
    );
    return StorageBoxesIdSubaccountsGet200BodyModel(
      subaccounts: _$map[r'subaccounts']
          .decodeJsonList<_i3.Object?>(
            context: r'StorageBoxesIdSubaccountsGet200BodyModel.subaccounts',
          )
          .map(
            _i4
                .StorageBoxesIdSubaccountsGet200BodySubaccountsArrayModel
                .fromJson,
          )
          .toList(),
    );
  }

  factory StorageBoxesIdSubaccountsGet200BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for StorageBoxesIdSubaccountsGet200BodyModel: contains complex types',
    );
  }

  final _i3.List<_i4.StorageBoxesIdSubaccountsGet200BodySubaccountsArrayModel>
  subaccounts;

  @_i3.override
  _i3.Object? toJson() => {
    r'subaccounts': this.subaccounts.map((e) => e.toJson()).toList(),
  };

  StorageBoxesIdSubaccountsGet200BodyModel Function({
    _i3.List<_i4.StorageBoxesIdSubaccountsGet200BodySubaccountsArrayModel>?
    subaccounts,
  })
  get copyWith {
    return ({
      _i3.List<_i4.StorageBoxesIdSubaccountsGet200BodySubaccountsArrayModel>?
      subaccounts,
    }) => StorageBoxesIdSubaccountsGet200BodyModel(
      subaccounts: subaccounts ?? this.subaccounts,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is StorageBoxesIdSubaccountsGet200BodyModel &&
        _$deepEquals.equals(other.subaccounts, this.subaccounts);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return deepEquals.hash(this.subaccounts);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for StorageBoxesIdSubaccountsGet200BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StorageBoxesIdSubaccountsGet200BodyModel: complex types cannot be URI-encoded',
    );
  }
}
