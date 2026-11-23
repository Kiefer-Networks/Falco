// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesIdActionsChangeTypePostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdActionsChangeTypePostBodyBodyModel({
    required this.storageBoxType,
  });

  factory StorageBoxesIdActionsChangeTypePostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'storage_box_type'},
      listKeys: {},
      context: r'StorageBoxesIdActionsChangeTypePostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return StorageBoxesIdActionsChangeTypePostBodyBodyModel(
      storageBoxType: _$values[r'storage_box_type'].decodeSimpleString(
        context: r'StorageBoxesIdActionsChangeTypePostBodyBodyModel.storage_box_type',
      ),
    );
  }

  factory StorageBoxesIdActionsChangeTypePostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdActionsChangeTypePostBodyBodyModel',
    );
    return StorageBoxesIdActionsChangeTypePostBodyBodyModel(
      storageBoxType: _$map[r'storage_box_type'].decodeJsonString(
        context: r'StorageBoxesIdActionsChangeTypePostBodyBodyModel.storage_box_type',
      ),
    );
  }

  factory StorageBoxesIdActionsChangeTypePostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'storage_box_type'},
      listKeys: {},
      context: r'StorageBoxesIdActionsChangeTypePostBodyBodyModel',
    );
    return StorageBoxesIdActionsChangeTypePostBodyBodyModel(
      storageBoxType: _$values[r'storage_box_type'].decodeFormString(
        context: r'StorageBoxesIdActionsChangeTypePostBodyBodyModel.storage_box_type',
      ),
    );
  }

  /// ID or Name of the [Storage Box Type](#tag/storage-box-types).
  ///
  /// **Example**:
  /// ```
  /// bx20
  /// ```
  final _i3.String storageBoxType;

  @_i3.override
  _i3.Object? toJson() => {r'storage_box_type': this.storageBoxType};

  StorageBoxesIdActionsChangeTypePostBodyBodyModel Function({
    _i3.String? storageBoxType,
  })
  get copyWith {
    return ({_i3.String? storageBoxType}) =>
        StorageBoxesIdActionsChangeTypePostBodyBodyModel(
          storageBoxType: storageBoxType ?? this.storageBoxType,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is StorageBoxesIdActionsChangeTypePostBodyBodyModel &&
        other.storageBoxType == this.storageBoxType;
  }

  @_i3.override
  _i3.int get hashCode => this.storageBoxType.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'storage_box_type'] = _i1.PropertyValue.scalar(
      this.storageBoxType,
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
      r'Cannot uriEncode StorageBoxesIdActionsChangeTypePostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
