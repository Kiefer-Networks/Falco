// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_put200_body_subaccount_access_settings_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel({
    required this.storageBox,
    required this.id,
    required this.name,
    required this.homeDirectory,
    required this.accessSettings,
    required this.description,
    required this.labels,
    required this.username,
    required this.server,
    required this.created,
  });

  factory StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel: contains complex types',
    );
  }

  factory StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context:
          r'StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel',
    );
    return StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel(
      storageBox: _$map[r'storage_box'].decodeJsonInt(
        context: r'StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel.storage_box',
      ),
      id: _$map[r'id'].decodeJsonInt(
        context: r'StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel.name',
      ),
      homeDirectory: _$map[r'home_directory'].decodeJsonString(
        context: r'StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel.home_directory',
      ),
      accessSettings:
          _i4.StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountAccessSettingsModel.fromJson(
            _$map[r'access_settings'],
          ),
      description: _$map[r'description'].decodeJsonString(
        context: r'StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel.description',
      ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context: r'StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel.labels',
        ),
        context: r'StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel.labels',
      ),
      username: _$map[r'username'].decodeJsonString(
        context: r'StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel.username',
      ),
      server: _$map[r'server'].decodeJsonString(
        context: r'StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel.server',
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel.created',
      ),
    );
  }

  factory StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel: contains complex types',
    );
  }

  /// ID of the [Storage Box](#tag/storage-boxes).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int storageBox;

  /// ID of the [Storage Box Subaccount](#tag/storage-box-subaccounts).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Name of the [Storage Box Subaccount](#tag/storage-box-subaccounts).
  ///
  ///
  /// **Example**:
  /// ```
  /// my-name
  /// ```
  final _i3.String name;

  /// Home directory of the [Storage Box Subaccount](#tag/storage-box-subaccounts).
  ///
  ///
  /// **Example**:
  /// ```
  /// my-backup/server01
  /// ```
  final _i3.String homeDirectory;

  /// Access settings for the [Subaccount](#tag/storage-box-subaccounts).
  ///
  final _i4.StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountAccessSettingsModel
  accessSettings;

  /// A description of [Storage Box Subaccount](#tag/storage-box-subaccounts).
  ///
  ///
  /// **Example**:
  /// ```
  /// my-backup-server01
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

  /// Username of the [Storage Box Subaccount](#tag/storage-box-subaccounts).
  ///
  /// **Example**:
  /// ```
  /// u1337-sub1
  /// ```
  final _i3.String username;

  /// FQDN of the [Storage Box Subaccount](#tag/storage-box-subaccounts).
  ///
  /// **Example**:
  /// ```
  /// u1337-sub1.your-storagebox.de
  /// ```
  final _i3.String server;

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
    r'home_directory': this.homeDirectory,
    r'access_settings': this.accessSettings.toJson(),
    r'description': this.description,
    r'labels': this.labels,
    r'username': this.username,
    r'server': this.server,
    r'created': this.created.toTimeZonedIso8601String(),
  };

  StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel Function({
    _i3.int? storageBox,
    _i3.int? id,
    _i3.String? name,
    _i3.String? homeDirectory,
    _i4.StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountAccessSettingsModel?
    accessSettings,
    _i3.String? description,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i3.String? username,
    _i3.String? server,
    _i3.DateTime? created,
  })
  get copyWith {
    return ({
      _i3.int? storageBox,
      _i3.int? id,
      _i3.String? name,
      _i3.String? homeDirectory,
      _i4.StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountAccessSettingsModel?
      accessSettings,
      _i3.String? description,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i3.String? username,
      _i3.String? server,
      _i3.DateTime? created,
    }) => StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel(
      storageBox: storageBox ?? this.storageBox,
      id: id ?? this.id,
      name: name ?? this.name,
      homeDirectory: homeDirectory ?? this.homeDirectory,
      accessSettings: accessSettings ?? this.accessSettings,
      description: description ?? this.description,
      labels: labels ?? this.labels,
      username: username ?? this.username,
      server: server ?? this.server,
      created: created ?? this.created,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other
            is StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel &&
        other.storageBox == this.storageBox &&
        other.id == this.id &&
        other.name == this.name &&
        other.homeDirectory == this.homeDirectory &&
        other.accessSettings == this.accessSettings &&
        other.description == this.description &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.username == this.username &&
        other.server == this.server &&
        other.created == this.created;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.storageBox,
      this.id,
      this.name,
      this.homeDirectory,
      this.accessSettings,
      this.description,
      deepEquals.hash(this.labels),
      this.username,
      this.server,
      this.created,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StorageBoxesIdSubaccountsSubaccountIdPut200BodySubaccountModel: complex types cannot be URI-encoded',
    );
  }
}
