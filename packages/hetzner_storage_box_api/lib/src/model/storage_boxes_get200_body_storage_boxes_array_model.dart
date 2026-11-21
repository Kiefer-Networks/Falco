// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i12;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i11;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_get200_body_storage_boxes_array_access_settings_model.dart'
    as _i6;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_get200_body_storage_boxes_array_location_model.dart'
    as _i5;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_get200_body_storage_boxes_array_protection_model.dart'
    as _i8;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_get200_body_storage_boxes_array_snapshot_plan_model.dart'
    as _i7;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_get200_body_storage_boxes_array_stats_model.dart'
    as _i10;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_get200_body_storage_boxes_array_status_model.dart'
    as _i9;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_get200_body_storage_boxes_array_storage_box_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesGet200BodyStorageBoxesArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesGet200BodyStorageBoxesArrayModel({
    required this.id,
    required this.name,
    required this.storageBoxType,
    required this.location,
    required this.accessSettings,
    required this.snapshotPlan,
    required this.protection,
    required this.labels,
    required this.status,
    required this.username,
    required this.server,
    required this.system,
    required this.stats,
    required this.created,
  });

  factory StorageBoxesGet200BodyStorageBoxesArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for StorageBoxesGet200BodyStorageBoxesArrayModel: contains complex types',
    );
  }

  factory StorageBoxesGet200BodyStorageBoxesArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesGet200BodyStorageBoxesArrayModel',
    );
    return StorageBoxesGet200BodyStorageBoxesArrayModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'StorageBoxesGet200BodyStorageBoxesArrayModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'StorageBoxesGet200BodyStorageBoxesArrayModel.name',
      ),
      storageBoxType:
          _i4.StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypeModel.fromJson(
            _$map[r'storage_box_type'],
          ),
      location:
          _i5.StorageBoxesGet200BodyStorageBoxesArrayLocationModel.fromJson(
            _$map[r'location'],
          ),
      accessSettings:
          _i6.StorageBoxesGet200BodyStorageBoxesArrayAccessSettingsModel.fromJson(
            _$map[r'access_settings'],
          ),
      snapshotPlan: _$map[r'snapshot_plan'] == null
          ? null
          : _i7.StorageBoxesGet200BodyStorageBoxesArraySnapshotPlanModel.fromJson(
              _$map[r'snapshot_plan'],
            ),
      protection:
          _i8.StorageBoxesGet200BodyStorageBoxesArrayProtectionModel.fromJson(
            _$map[r'protection'],
          ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context: r'StorageBoxesGet200BodyStorageBoxesArrayModel.labels',
        ),
        context: r'StorageBoxesGet200BodyStorageBoxesArrayModel.labels',
      ),
      status: _i9.StorageBoxesGet200BodyStorageBoxesArrayStatusModel.fromJson(
        _$map[r'status'],
      ),
      username: _$map[r'username'].decodeJsonNullableString(
        context: r'StorageBoxesGet200BodyStorageBoxesArrayModel.username',
      ),
      server: _$map[r'server'].decodeJsonNullableString(
        context: r'StorageBoxesGet200BodyStorageBoxesArrayModel.server',
      ),
      system: _$map[r'system'].decodeJsonNullableString(
        context: r'StorageBoxesGet200BodyStorageBoxesArrayModel.system',
      ),
      stats: _i10.StorageBoxesGet200BodyStorageBoxesArrayStatsModel.fromJson(
        _$map[r'stats'],
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'StorageBoxesGet200BodyStorageBoxesArrayModel.created',
      ),
    );
  }

  factory StorageBoxesGet200BodyStorageBoxesArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for StorageBoxesGet200BodyStorageBoxesArrayModel: contains complex types',
    );
  }

  /// ID of the [Storage Box](#tag/storage-boxes).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Name of the [Storage Box](#tag/storage-boxes).
  ///
  final _i3.String name;

  /// Type of the [Storage Box](#tag/storage-boxes).
  final _i4.StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypeModel
  storageBoxType;

  /// Location of the [Storage Box](#tag/storage-boxes).
  final _i5.StorageBoxesGet200BodyStorageBoxesArrayLocationModel location;

  /// Access settings of the [Storage Box](#tag/storage-boxes).
  final _i6.StorageBoxesGet200BodyStorageBoxesArrayAccessSettingsModel
  accessSettings;

  /// Details of the active snapshot plan.
  ///
  /// Not available if the `status` is `initializing`.
  ///
  final _i7.StorageBoxesGet200BodyStorageBoxesArraySnapshotPlanModel?
  snapshotPlan;

  /// Protection configuration for the Resource.
  final _i8.StorageBoxesGet200BodyStorageBoxesArrayProtectionModel protection;

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

  /// Status of the [Storage Box](#tag/storage-boxes).
  final _i9.StorageBoxesGet200BodyStorageBoxesArrayStatusModel status;

  /// Primary username of the [Storage Box](#tag/storage-boxes).
  ///
  /// Not available if the `status` is `initializing`.
  ///
  ///
  /// **Example**:
  /// ```
  /// u12345
  /// ```
  final _i3.String? username;

  /// FQDN of the [Storage Box](#tag/storage-boxes).
  ///
  /// Not available if the `status` is `initializing`.
  ///
  ///
  /// **Example**:
  /// ```
  /// u1337.your-storagebox.de
  /// ```
  final _i3.String? server;

  /// Host system of the [Storage Box](#tag/storage-boxes).
  ///
  /// Not available if the `status` is `initializing`.
  ///
  ///
  /// **Example**:
  /// ```
  /// FSN1-BX355
  /// ```
  final _i3.String? system;

  /// Statistics of the [Storage Box](#tag/storage-boxes).
  ///
  final _i10.StorageBoxesGet200BodyStorageBoxesArrayStatsModel stats;

  /// Point in time when the Resource was created (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  /// **Example**:
  /// ```
  /// 2016-01-30T23:55:00Z
  /// ```
  final _i3.DateTime created;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'storage_box_type': this.storageBoxType.toJson(),
    r'location': this.location.toJson(),
    r'access_settings': this.accessSettings.toJson(),
    r'snapshot_plan': this.snapshotPlan?.toJson(),
    r'protection': this.protection.toJson(),
    r'labels': this.labels,
    r'status': this.status.toJson(),
    r'username': this.username,
    r'server': this.server,
    r'system': this.system,
    r'stats': this.stats.toJson(),
    r'created': this.created.toTimeZonedIso8601String(),
  };

  StorageBoxesGet200BodyStorageBoxesArrayModel Function({
    _i3.int? id,
    _i3.String? name,
    _i4.StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypeModel?
    storageBoxType,
    _i5.StorageBoxesGet200BodyStorageBoxesArrayLocationModel? location,
    _i6.StorageBoxesGet200BodyStorageBoxesArrayAccessSettingsModel?
    accessSettings,
    _i7.StorageBoxesGet200BodyStorageBoxesArraySnapshotPlanModel? snapshotPlan,
    _i8.StorageBoxesGet200BodyStorageBoxesArrayProtectionModel? protection,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i9.StorageBoxesGet200BodyStorageBoxesArrayStatusModel? status,
    _i3.String? username,
    _i3.String? server,
    _i3.String? system,
    _i10.StorageBoxesGet200BodyStorageBoxesArrayStatsModel? stats,
    _i3.DateTime? created,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.String? name,
      _i4.StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypeModel?
      storageBoxType,
      _i5.StorageBoxesGet200BodyStorageBoxesArrayLocationModel? location,
      _i6.StorageBoxesGet200BodyStorageBoxesArrayAccessSettingsModel?
      accessSettings,
      _i3.Object? snapshotPlan = _sentinel,
      _i8.StorageBoxesGet200BodyStorageBoxesArrayProtectionModel? protection,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i9.StorageBoxesGet200BodyStorageBoxesArrayStatusModel? status,
      _i3.Object? username = _sentinel,
      _i3.Object? server = _sentinel,
      _i3.Object? system = _sentinel,
      _i10.StorageBoxesGet200BodyStorageBoxesArrayStatsModel? stats,
      _i3.DateTime? created,
    }) => StorageBoxesGet200BodyStorageBoxesArrayModel(
      id: id ?? this.id,
      name: name ?? this.name,
      storageBoxType: storageBoxType ?? this.storageBoxType,
      location: location ?? this.location,
      accessSettings: accessSettings ?? this.accessSettings,
      snapshotPlan: _i3.identical(snapshotPlan, _sentinel)
          ? this.snapshotPlan
          : (snapshotPlan
                as _i7.StorageBoxesGet200BodyStorageBoxesArraySnapshotPlanModel?),
      protection: protection ?? this.protection,
      labels: labels ?? this.labels,
      status: status ?? this.status,
      username: _i3.identical(username, _sentinel)
          ? this.username
          : (username as _i3.String?),
      server: _i3.identical(server, _sentinel)
          ? this.server
          : (server as _i3.String?),
      system: _i3.identical(system, _sentinel)
          ? this.system
          : (system as _i3.String?),
      stats: stats ?? this.stats,
      created: created ?? this.created,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i11.DeepCollectionEquality();
    return other is StorageBoxesGet200BodyStorageBoxesArrayModel &&
        other.id == this.id &&
        other.name == this.name &&
        other.storageBoxType == this.storageBoxType &&
        other.location == this.location &&
        other.accessSettings == this.accessSettings &&
        other.snapshotPlan == this.snapshotPlan &&
        other.protection == this.protection &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.status == this.status &&
        other.username == this.username &&
        other.server == this.server &&
        other.system == this.system &&
        other.stats == this.stats &&
        other.created == this.created;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i11.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.name,
      this.storageBoxType,
      this.location,
      this.accessSettings,
      this.snapshotPlan,
      this.protection,
      deepEquals.hash(this.labels),
      this.status,
      this.username,
      this.server,
      this.system,
      this.stats,
      this.created,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for StorageBoxesGet200BodyStorageBoxesArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i12.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StorageBoxesGet200BodyStorageBoxesArrayModel: complex types cannot be URI-encoded',
    );
  }
}
