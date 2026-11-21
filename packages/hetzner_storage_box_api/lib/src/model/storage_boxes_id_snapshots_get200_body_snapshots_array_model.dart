// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_get200_body_snapshots_array_stats_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel({
    required this.storageBox,
    required this.id,
    required this.name,
    required this.description,
    required this.labels,
    required this.stats,
    required this.isAutomatic,
    required this.created,
  });

  factory StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel: contains complex types',
    );
  }

  factory StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel',
    );
    return StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel(
      storageBox: _$map[r'storage_box'].decodeJsonInt(
        context:
            r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel.storage_box',
      ),
      id: _$map[r'id'].decodeJsonInt(
        context: r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel.name',
      ),
      description: _$map[r'description'].decodeJsonString(
        context:
            r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel.description',
      ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context:
              r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel.labels',
        ),
        context: r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel.labels',
      ),
      stats:
          _i4.StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel.fromJson(
            _$map[r'stats'],
          ),
      isAutomatic: _$map[r'is_automatic'].decodeJsonBool(
        context: r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel.is_automatic',
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context:
            r'StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel.created',
      ),
    );
  }

  factory StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel: contains complex types',
    );
  }

  /// ID of the [Storage Box](#tag/storage-boxes).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int storageBox;

  /// ID of the [Storage Box Snapshot](#tag/storage-box-snapshots).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Name of the [Storage Box Snapshot](#tag/storage-box-snapshots).
  ///
  /// **Example**:
  /// ```
  /// my-snapshot
  /// ```
  final _i3.String name;

  /// Description of the [Storage Box Snapshot](#tag/storage-box-snapshots).
  ///
  /// **Example**:
  /// ```
  /// snapshot-0001
  /// ```
  final _i3.String description;

  /// User-defined labels (`key/value` pairs) for the Resource.
  /// For more information, see "[Labels](#description/labels)".
  ///
  ///
  /// **Example**:
  /// ```json
  /// {
  ///   "environment": "prod",
  ///   "example.com/my": "label",
  ///   "just-a-key": ""
  /// }
  /// ```
  final _i3.Map<_i3.String, _i3.String> labels;

  /// Statistics of the [Storage Box Snapshot](#tag/storage-box-snapshots).
  ///
  final _i4.StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel stats;

  /// Whether the [Storage Box Snapshot](#tag/storage-box-snapshots) was created automatically.
  final _i3.bool isAutomatic;

  /// Point in time when the Resource was created (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  /// **Example**:
  /// ```
  /// 2016-01-30T23:55:00Z
  /// ```
  final _i3.DateTime created;

  @_i3.override
  _i3.Object? toJson() => {
    r'storage_box': this.storageBox,
    r'id': this.id,
    r'name': this.name,
    r'description': this.description,
    r'labels': this.labels,
    r'stats': this.stats.toJson(),
    r'is_automatic': this.isAutomatic,
    r'created': this.created.toTimeZonedIso8601String(),
  };

  StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel Function({
    _i3.int? storageBox,
    _i3.int? id,
    _i3.String? name,
    _i3.String? description,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i4.StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel? stats,
    _i3.bool? isAutomatic,
    _i3.DateTime? created,
  })
  get copyWith {
    return ({
      _i3.int? storageBox,
      _i3.int? id,
      _i3.String? name,
      _i3.String? description,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i4.StorageBoxesIdSnapshotsGet200BodySnapshotsArrayStatsModel? stats,
      _i3.bool? isAutomatic,
      _i3.DateTime? created,
    }) => StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel(
      storageBox: storageBox ?? this.storageBox,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      labels: labels ?? this.labels,
      stats: stats ?? this.stats,
      isAutomatic: isAutomatic ?? this.isAutomatic,
      created: created ?? this.created,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel &&
        other.storageBox == this.storageBox &&
        other.id == this.id &&
        other.name == this.name &&
        other.description == this.description &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.stats == this.stats &&
        other.isAutomatic == this.isAutomatic &&
        other.created == this.created;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.storageBox,
      this.id,
      this.name,
      this.description,
      deepEquals.hash(this.labels),
      this.stats,
      this.isAutomatic,
      this.created,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StorageBoxesIdSnapshotsGet200BodySnapshotsArrayModel: complex types cannot be URI-encoded',
    );
  }
}
