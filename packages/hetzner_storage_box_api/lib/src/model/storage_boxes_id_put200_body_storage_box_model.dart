// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i12;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i11;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_put200_body_storage_box_access_settings_model.dart'
    as _i6;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_put200_body_storage_box_location_model.dart'
    as _i5;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_put200_body_storage_box_protection_model.dart'
    as _i8;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_put200_body_storage_box_snapshot_plan_model.dart'
    as _i7;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_put200_body_storage_box_stats_model.dart'
    as _i10;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_put200_body_storage_box_status_model.dart'
    as _i9;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_put200_body_storage_box_storage_box_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesIdPut200BodyStorageBoxModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdPut200BodyStorageBoxModel({
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

  factory StorageBoxesIdPut200BodyStorageBoxModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for StorageBoxesIdPut200BodyStorageBoxModel: contains complex types',
    );
  }

  factory StorageBoxesIdPut200BodyStorageBoxModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdPut200BodyStorageBoxModel',
    );
    return StorageBoxesIdPut200BodyStorageBoxModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'StorageBoxesIdPut200BodyStorageBoxModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'StorageBoxesIdPut200BodyStorageBoxModel.name',
      ),
      storageBoxType:
          _i4.StorageBoxesIdPut200BodyStorageBoxStorageBoxTypeModel.fromJson(
            _$map[r'storage_box_type'],
          ),
      location: _i5.StorageBoxesIdPut200BodyStorageBoxLocationModel.fromJson(
        _$map[r'location'],
      ),
      accessSettings:
          _i6.StorageBoxesIdPut200BodyStorageBoxAccessSettingsModel.fromJson(
            _$map[r'access_settings'],
          ),
      snapshotPlan: _$map[r'snapshot_plan'] == null
          ? null
          : _i7.StorageBoxesIdPut200BodyStorageBoxSnapshotPlanModel.fromJson(
              _$map[r'snapshot_plan'],
            ),
      protection:
          _i8.StorageBoxesIdPut200BodyStorageBoxProtectionModel.fromJson(
            _$map[r'protection'],
          ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context: r'StorageBoxesIdPut200BodyStorageBoxModel.labels',
        ),
        context: r'StorageBoxesIdPut200BodyStorageBoxModel.labels',
      ),
      status: _i9.StorageBoxesIdPut200BodyStorageBoxStatusModel.fromJson(
        _$map[r'status'],
      ),
      username: _$map[r'username'].decodeJsonNullableString(
        context: r'StorageBoxesIdPut200BodyStorageBoxModel.username',
      ),
      server: _$map[r'server'].decodeJsonNullableString(
        context: r'StorageBoxesIdPut200BodyStorageBoxModel.server',
      ),
      system: _$map[r'system'].decodeJsonNullableString(
        context: r'StorageBoxesIdPut200BodyStorageBoxModel.system',
      ),
      stats: _i10.StorageBoxesIdPut200BodyStorageBoxStatsModel.fromJson(
        _$map[r'stats'],
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'StorageBoxesIdPut200BodyStorageBoxModel.created',
      ),
    );
  }

  factory StorageBoxesIdPut200BodyStorageBoxModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for StorageBoxesIdPut200BodyStorageBoxModel: contains complex types',
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
  final _i4.StorageBoxesIdPut200BodyStorageBoxStorageBoxTypeModel
  storageBoxType;

  /// Location of the [Storage Box](#tag/storage-boxes).
  final _i5.StorageBoxesIdPut200BodyStorageBoxLocationModel location;

  /// Access settings of the [Storage Box](#tag/storage-boxes).
  final _i6.StorageBoxesIdPut200BodyStorageBoxAccessSettingsModel
  accessSettings;

  /// Details of the active snapshot plan.
  ///
  /// Not available if the `status` is `initializing`.
  ///
  final _i7.StorageBoxesIdPut200BodyStorageBoxSnapshotPlanModel? snapshotPlan;

  /// Protection configuration for the Resource.
  final _i8.StorageBoxesIdPut200BodyStorageBoxProtectionModel protection;

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
  final _i9.StorageBoxesIdPut200BodyStorageBoxStatusModel status;

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
  final _i10.StorageBoxesIdPut200BodyStorageBoxStatsModel stats;

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

  StorageBoxesIdPut200BodyStorageBoxModel Function({
    _i3.int? id,
    _i3.String? name,
    _i4.StorageBoxesIdPut200BodyStorageBoxStorageBoxTypeModel? storageBoxType,
    _i5.StorageBoxesIdPut200BodyStorageBoxLocationModel? location,
    _i6.StorageBoxesIdPut200BodyStorageBoxAccessSettingsModel? accessSettings,
    _i7.StorageBoxesIdPut200BodyStorageBoxSnapshotPlanModel? snapshotPlan,
    _i8.StorageBoxesIdPut200BodyStorageBoxProtectionModel? protection,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i9.StorageBoxesIdPut200BodyStorageBoxStatusModel? status,
    _i3.String? username,
    _i3.String? server,
    _i3.String? system,
    _i10.StorageBoxesIdPut200BodyStorageBoxStatsModel? stats,
    _i3.DateTime? created,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.String? name,
      _i4.StorageBoxesIdPut200BodyStorageBoxStorageBoxTypeModel? storageBoxType,
      _i5.StorageBoxesIdPut200BodyStorageBoxLocationModel? location,
      _i6.StorageBoxesIdPut200BodyStorageBoxAccessSettingsModel? accessSettings,
      _i3.Object? snapshotPlan = _sentinel,
      _i8.StorageBoxesIdPut200BodyStorageBoxProtectionModel? protection,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i9.StorageBoxesIdPut200BodyStorageBoxStatusModel? status,
      _i3.Object? username = _sentinel,
      _i3.Object? server = _sentinel,
      _i3.Object? system = _sentinel,
      _i10.StorageBoxesIdPut200BodyStorageBoxStatsModel? stats,
      _i3.DateTime? created,
    }) => StorageBoxesIdPut200BodyStorageBoxModel(
      id: id ?? this.id,
      name: name ?? this.name,
      storageBoxType: storageBoxType ?? this.storageBoxType,
      location: location ?? this.location,
      accessSettings: accessSettings ?? this.accessSettings,
      snapshotPlan: _i3.identical(snapshotPlan, _sentinel)
          ? this.snapshotPlan
          : (snapshotPlan
                as _i7.StorageBoxesIdPut200BodyStorageBoxSnapshotPlanModel?),
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
    return other is StorageBoxesIdPut200BodyStorageBoxModel &&
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
    r'parameterProperties not supported for StorageBoxesIdPut200BodyStorageBoxModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i12.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StorageBoxesIdPut200BodyStorageBoxModel: complex types cannot be URI-encoded',
    );
  }
}
