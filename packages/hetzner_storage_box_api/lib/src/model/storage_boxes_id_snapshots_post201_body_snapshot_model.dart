// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesIdSnapshotsPost201BodySnapshotModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdSnapshotsPost201BodySnapshotModel({
    required this.id,
    required this.storageBox,
  });

  factory StorageBoxesIdSnapshotsPost201BodySnapshotModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'id', r'storage_box'},
      listKeys: {},
      context: r'StorageBoxesIdSnapshotsPost201BodySnapshotModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return StorageBoxesIdSnapshotsPost201BodySnapshotModel(
      id: _$values[r'id'].decodeSimpleInt(
        context: r'StorageBoxesIdSnapshotsPost201BodySnapshotModel.id',
      ),
      storageBox: _$values[r'storage_box'].decodeSimpleInt(
        context: r'StorageBoxesIdSnapshotsPost201BodySnapshotModel.storage_box',
      ),
    );
  }

  factory StorageBoxesIdSnapshotsPost201BodySnapshotModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdSnapshotsPost201BodySnapshotModel',
    );
    return StorageBoxesIdSnapshotsPost201BodySnapshotModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'StorageBoxesIdSnapshotsPost201BodySnapshotModel.id',
      ),
      storageBox: _$map[r'storage_box'].decodeJsonInt(
        context: r'StorageBoxesIdSnapshotsPost201BodySnapshotModel.storage_box',
      ),
    );
  }

  factory StorageBoxesIdSnapshotsPost201BodySnapshotModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'id', r'storage_box'},
      listKeys: {},
      context: r'StorageBoxesIdSnapshotsPost201BodySnapshotModel',
    );
    return StorageBoxesIdSnapshotsPost201BodySnapshotModel(
      id: _$values[r'id'].decodeFormInt(
        context: r'StorageBoxesIdSnapshotsPost201BodySnapshotModel.id',
      ),
      storageBox: _$values[r'storage_box'].decodeFormInt(
        context: r'StorageBoxesIdSnapshotsPost201BodySnapshotModel.storage_box',
      ),
    );
  }

  /// ID of the [Storage Box Snapshot](#tag/storage-box-snapshots).
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

  StorageBoxesIdSnapshotsPost201BodySnapshotModel Function({
    _i3.int? id,
    _i3.int? storageBox,
  })
  get copyWith {
    return ({_i3.int? id, _i3.int? storageBox}) =>
        StorageBoxesIdSnapshotsPost201BodySnapshotModel(
          id: id ?? this.id,
          storageBox: storageBox ?? this.storageBox,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is StorageBoxesIdSnapshotsPost201BodySnapshotModel &&
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
      r'Cannot uriEncode StorageBoxesIdSnapshotsPost201BodySnapshotModel: complex types cannot be URI-encoded',
    );
  }
}
