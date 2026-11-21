// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_post_body_body_access_settings_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesPostBodyBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesPostBodyBodyModel({
    required this.name,
    required this.location,
    required this.storageBoxType,
    required this.password,
    this.labels,
    this.sshKeys,
    this.accessSettings,
  });

  factory StorageBoxesPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for StorageBoxesPostBodyBodyModel: contains complex types',
    );
  }

  factory StorageBoxesPostBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'StorageBoxesPostBodyBodyModel');
    return StorageBoxesPostBodyBodyModel(
      name: _$map[r'name'].decodeJsonString(
        context: r'StorageBoxesPostBodyBodyModel.name',
      ),
      location: _$map[r'location'].decodeJsonString(
        context: r'StorageBoxesPostBodyBodyModel.location',
      ),
      storageBoxType: _$map[r'storage_box_type'].decodeJsonString(
        context: r'StorageBoxesPostBodyBodyModel.storage_box_type',
      ),
      password: _$map[r'password'].decodeJsonString(
        context: r'StorageBoxesPostBodyBodyModel.password',
      ),
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(
          context: r'StorageBoxesPostBodyBodyModel.labels',
        ),
        context: r'StorageBoxesPostBodyBodyModel.labels',
      ),
      sshKeys: _$map[r'ssh_keys'].decodeJsonNullableList<_i3.String>(
        context: r'StorageBoxesPostBodyBodyModel.ssh_keys',
      ),
      accessSettings: _$map[r'access_settings'] == null
          ? null
          : _i4.StorageBoxesPostBodyBodyAccessSettingsModel.fromJson(
              _$map[r'access_settings'],
            ),
    );
  }

  factory StorageBoxesPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for StorageBoxesPostBodyBodyModel: contains complex types',
    );
  }

  /// Name of the [Storage Box](#tag/storage-boxes).
  ///
  final _i3.String name;

  /// ID or Name of [Location](#tag/locations).
  ///
  /// **Example**:
  /// ```
  /// fsn1
  /// ```
  final _i3.String location;

  /// ID or Name of the [Storage Box Type](#tag/storage-box-types).
  ///
  /// **Example**:
  /// ```
  /// bx20
  /// ```
  final _i3.String storageBoxType;

  /// Password of the [Storage Box](#tag/storage-boxes).
  ///
  /// For more details, see the [Storage Boxes password policy](#tag/storage-boxes/password-policy).
  ///
  final _i3.String password;

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
  final _i3.Map<_i3.String, _i3.String>? labels;

  /// SSH public keys in OpenSSH format to inject into the [Storage Box](#tag/storage-boxes).
  final _i3.List<_i3.String>? sshKeys;

  /// Access settings of the [Storage Box](#tag/storage-boxes).
  final _i4.StorageBoxesPostBodyBodyAccessSettingsModel? accessSettings;

  @_i3.override
  _i3.Object? toJson() => {
    r'name': this.name,
    r'location': this.location,
    r'storage_box_type': this.storageBoxType,
    r'password': this.password,
    if (this.labels != null) r'labels': this.labels,
    if (this.sshKeys != null) r'ssh_keys': this.sshKeys,
    if (this.accessSettings != null)
      r'access_settings': this.accessSettings?.toJson(),
  };

  StorageBoxesPostBodyBodyModel Function({
    _i3.String? name,
    _i3.String? location,
    _i3.String? storageBoxType,
    _i3.String? password,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i3.List<_i3.String>? sshKeys,
    _i4.StorageBoxesPostBodyBodyAccessSettingsModel? accessSettings,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.String? name,
      _i3.String? location,
      _i3.String? storageBoxType,
      _i3.String? password,
      _i3.Object? labels = _sentinel,
      _i3.Object? sshKeys = _sentinel,
      _i3.Object? accessSettings = _sentinel,
    }) => StorageBoxesPostBodyBodyModel(
      name: name ?? this.name,
      location: location ?? this.location,
      storageBoxType: storageBoxType ?? this.storageBoxType,
      password: password ?? this.password,
      labels: _i3.identical(labels, _sentinel)
          ? this.labels
          : (labels as _i3.Map<_i3.String, _i3.String>?),
      sshKeys: _i3.identical(sshKeys, _sentinel)
          ? this.sshKeys
          : (sshKeys as _i3.List<_i3.String>?),
      accessSettings: _i3.identical(accessSettings, _sentinel)
          ? this.accessSettings
          : (accessSettings
                as _i4.StorageBoxesPostBodyBodyAccessSettingsModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is StorageBoxesPostBodyBodyModel &&
        other.name == this.name &&
        other.location == this.location &&
        other.storageBoxType == this.storageBoxType &&
        other.password == this.password &&
        _$deepEquals.equals(other.labels, this.labels) &&
        _$deepEquals.equals(other.sshKeys, this.sshKeys) &&
        other.accessSettings == this.accessSettings;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.name,
      this.location,
      this.storageBoxType,
      this.password,
      deepEquals.hash(this.labels),
      deepEquals.hash(this.sshKeys),
      this.accessSettings,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for StorageBoxesPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StorageBoxesPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
