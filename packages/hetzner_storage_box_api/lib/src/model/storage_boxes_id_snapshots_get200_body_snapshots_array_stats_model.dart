// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Statistics of the [Storage Box Snapshot](#tag/storage-box-snapshots).
///
@_i2.immutable
class StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel({
    required this.size,
    required this.sizeFilesystem,
  });

  factory StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'size', r'size_filesystem'},
      listKeys: {},
      context: r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel(
      size: _$values[r'size'].decodeSimpleInt(
        context:
            r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel.size',
      ),
      sizeFilesystem: _$values[r'size_filesystem'].decodeSimpleInt(
        context: r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel.size_filesystem',
      ),
    );
  }

  factory StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel',
    );
    return StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel(
      size: _$map[r'size'].decodeJsonInt(
        context:
            r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel.size',
      ),
      sizeFilesystem: _$map[r'size_filesystem'].decodeJsonInt(
        context: r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel.size_filesystem',
      ),
    );
  }

  factory StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'size', r'size_filesystem'},
      listKeys: {},
      context: r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel',
    );
    return StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel(
      size: _$values[r'size'].decodeFormInt(
        context:
            r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel.size',
      ),
      sizeFilesystem: _$values[r'size_filesystem'].decodeFormInt(
        context: r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel.size_filesystem',
      ),
    );
  }

  /// Current storage requirements of the Snapshot in bytes.
  final _i3.int size;

  /// Size of the compressed file system contained in the Snapshot in bytes.
  final _i3.int sizeFilesystem;

  @_i3.override
  _i3.Object? toJson() => {
    r'size': this.size,
    r'size_filesystem': this.sizeFilesystem,
  };

  StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel Function({
    _i3.int? size,
    _i3.int? sizeFilesystem,
  })
  get copyWith {
    return ({_i3.int? size, _i3.int? sizeFilesystem}) =>
        StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel(
          size: size ?? this.size,
          sizeFilesystem: sizeFilesystem ?? this.sizeFilesystem,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel &&
        other.size == this.size &&
        other.sizeFilesystem == this.sizeFilesystem;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.size, this.sizeFilesystem]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'size'] = _i1.PropertyValue.scalar(this.size.toString());
    _$result[r'size_filesystem'] = _i1.PropertyValue.scalar(
      this.sizeFilesystem.toString(),
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
      r'Cannot uriEncode StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel: complex types cannot be URI-encoded',
    );
  }
}
