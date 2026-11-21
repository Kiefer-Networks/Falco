// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesIdSubaccountsPost201BodySubaccountModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdSubaccountsPost201BodySubaccountModel({
    required this.id,
    required this.storageBox,
  });

  factory StorageBoxesIdSubaccountsPost201BodySubaccountModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'id', r'storage_box'},
      listKeys: {},
      context: r'StorageBoxesIdSubaccountsPost201BodySubaccountModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return StorageBoxesIdSubaccountsPost201BodySubaccountModel(
      id: _$values[r'id'].decodeSimpleInt(
        context: r'StorageBoxesIdSubaccountsPost201BodySubaccountModel.id',
      ),
      storageBox: _$values[r'storage_box'].decodeSimpleInt(
        context:
            r'StorageBoxesIdSubaccountsPost201BodySubaccountModel.storage_box',
      ),
    );
  }

  factory StorageBoxesIdSubaccountsPost201BodySubaccountModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdSubaccountsPost201BodySubaccountModel',
    );
    return StorageBoxesIdSubaccountsPost201BodySubaccountModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'StorageBoxesIdSubaccountsPost201BodySubaccountModel.id',
      ),
      storageBox: _$map[r'storage_box'].decodeJsonInt(
        context:
            r'StorageBoxesIdSubaccountsPost201BodySubaccountModel.storage_box',
      ),
    );
  }

  factory StorageBoxesIdSubaccountsPost201BodySubaccountModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'id', r'storage_box'},
      listKeys: {},
      context: r'StorageBoxesIdSubaccountsPost201BodySubaccountModel',
    );
    return StorageBoxesIdSubaccountsPost201BodySubaccountModel(
      id: _$values[r'id'].decodeFormInt(
        context: r'StorageBoxesIdSubaccountsPost201BodySubaccountModel.id',
      ),
      storageBox: _$values[r'storage_box'].decodeFormInt(
        context:
            r'StorageBoxesIdSubaccountsPost201BodySubaccountModel.storage_box',
      ),
    );
  }

  /// ID of the [Storage Box Subaccount](#tag/storage-box-subaccounts).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// ID of the [Storage Box](#tag/storage-boxes).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int storageBox;

  @_i3.override
  _i3.Object? toJson() => {r'id': this.id, r'storage_box': this.storageBox};

  StorageBoxesIdSubaccountsPost201BodySubaccountModel Function({
    _i3.int? id,
    _i3.int? storageBox,
  })
  get copyWith {
    return ({_i3.int? id, _i3.int? storageBox}) =>
        StorageBoxesIdSubaccountsPost201BodySubaccountModel(
          id: id ?? this.id,
          storageBox: storageBox ?? this.storageBox,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is StorageBoxesIdSubaccountsPost201BodySubaccountModel &&
        other.id == this.id &&
        other.storageBox == this.storageBox;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.id, this.storageBox]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'id'] = _i1.PropertyValue.scalar(this.id.toString());
    _$result[r'storage_box'] = _i1.PropertyValue.scalar(
      this.storageBox.toString(),
    );
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StorageBoxesIdSubaccountsPost201BodySubaccountModel: complex types cannot be URI-encoded',
    );
  }
}
