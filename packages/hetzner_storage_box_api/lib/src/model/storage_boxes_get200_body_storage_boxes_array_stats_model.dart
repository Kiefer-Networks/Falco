// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Statistics of the [Storage Box](#tag/storage-boxes).
///
@_i2.immutable
class StorageBoxesGet200BodyStorageBoxesArrayStatsModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesGet200BodyStorageBoxesArrayStatsModel({
    required this.size,
    required this.sizeData,
    required this.sizeSnapshots,
  });

  factory StorageBoxesGet200BodyStorageBoxesArrayStatsModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'size', r'size_data', r'size_snapshots'},
      listKeys: {},
      context: r'StorageBoxesGet200BodyStorageBoxesArrayStatsModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return StorageBoxesGet200BodyStorageBoxesArrayStatsModel(
      size: _$values[r'size'].decodeSimpleInt(
        context: r'StorageBoxesGet200BodyStorageBoxesArrayStatsModel.size',
      ),
      sizeData: _$values[r'size_data'].decodeSimpleInt(
        context: r'StorageBoxesGet200BodyStorageBoxesArrayStatsModel.size_data',
      ),
      sizeSnapshots: _$values[r'size_snapshots'].decodeSimpleInt(
        context:
            r'StorageBoxesGet200BodyStorageBoxesArrayStatsModel.size_snapshots',
      ),
    );
  }

  factory StorageBoxesGet200BodyStorageBoxesArrayStatsModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesGet200BodyStorageBoxesArrayStatsModel',
    );
    return StorageBoxesGet200BodyStorageBoxesArrayStatsModel(
      size: _$map[r'size'].decodeJsonInt(
        context: r'StorageBoxesGet200BodyStorageBoxesArrayStatsModel.size',
      ),
      sizeData: _$map[r'size_data'].decodeJsonInt(
        context: r'StorageBoxesGet200BodyStorageBoxesArrayStatsModel.size_data',
      ),
      sizeSnapshots: _$map[r'size_snapshots'].decodeJsonInt(
        context:
            r'StorageBoxesGet200BodyStorageBoxesArrayStatsModel.size_snapshots',
      ),
    );
  }

  factory StorageBoxesGet200BodyStorageBoxesArrayStatsModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'size', r'size_data', r'size_snapshots'},
      listKeys: {},
      context: r'StorageBoxesGet200BodyStorageBoxesArrayStatsModel',
    );
    return StorageBoxesGet200BodyStorageBoxesArrayStatsModel(
      size: _$values[r'size'].decodeFormInt(
        context: r'StorageBoxesGet200BodyStorageBoxesArrayStatsModel.size',
      ),
      sizeData: _$values[r'size_data'].decodeFormInt(
        context: r'StorageBoxesGet200BodyStorageBoxesArrayStatsModel.size_data',
      ),
      sizeSnapshots: _$values[r'size_snapshots'].decodeFormInt(
        context:
            r'StorageBoxesGet200BodyStorageBoxesArrayStatsModel.size_snapshots',
      ),
    );
  }

  /// Current disk usage in bytes.
  final _i3.int size;

  /// Current disk usage for data in bytes.
  final _i3.int sizeData;

  /// Current disk usage for snapshots in bytes.
  final _i3.int sizeSnapshots;

  @_i3.override
  _i3.Object? toJson() => {
    r'size': this.size,
    r'size_data': this.sizeData,
    r'size_snapshots': this.sizeSnapshots,
  };

  StorageBoxesGet200BodyStorageBoxesArrayStatsModel Function({
    _i3.int? size,
    _i3.int? sizeData,
    _i3.int? sizeSnapshots,
  })
  get copyWith {
    return ({_i3.int? size, _i3.int? sizeData, _i3.int? sizeSnapshots}) =>
        StorageBoxesGet200BodyStorageBoxesArrayStatsModel(
          size: size ?? this.size,
          sizeData: sizeData ?? this.sizeData,
          sizeSnapshots: sizeSnapshots ?? this.sizeSnapshots,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is StorageBoxesGet200BodyStorageBoxesArrayStatsModel &&
        other.size == this.size &&
        other.sizeData == this.sizeData &&
        other.sizeSnapshots == this.sizeSnapshots;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.size, this.sizeData, this.sizeSnapshots]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'size'] = _i1.PropertyValue.scalar(this.size.toString());
    _$result[r'size_data'] = _i1.PropertyValue.scalar(this.sizeData.toString());
    _$result[r'size_snapshots'] = _i1.PropertyValue.scalar(
      this.sizeSnapshots.toString(),
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
      r'Cannot uriEncode StorageBoxesGet200BodyStorageBoxesArrayStatsModel: complex types cannot be URI-encoded',
    );
  }
}
