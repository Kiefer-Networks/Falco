// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_post_body_body_access_settings_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesIdSubaccountsPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdSubaccountsPostBodyBodyModel({
    required this.homeDirectory,
    required this.password,
    this.accessSettings,
    this.name,
    this.description,
    this.labels,
  });

  factory StorageBoxesIdSubaccountsPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for StorageBoxesIdSubaccountsPostBodyBodyModel: contains complex types',
    );
  }

  factory StorageBoxesIdSubaccountsPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdSubaccountsPostBodyBodyModel',
    );
    return StorageBoxesIdSubaccountsPostBodyBodyModel(
      homeDirectory: _$map[r'home_directory'].decodeJsonString(
        context: r'StorageBoxesIdSubaccountsPostBodyBodyModel.home_directory',
      ),
      password: _$map[r'password'].decodeJsonString(
        context: r'StorageBoxesIdSubaccountsPostBodyBodyModel.password',
      ),
      accessSettings: _$map[r'access_settings'] == null
          ? null
          : _i4.StorageBoxesIdSubaccountsPostBodyBodyAccessSettingsModel.fromJson(
              _$map[r'access_settings'],
            ),
      name: _$map[r'name'].decodeJsonNullableString(
        context: r'StorageBoxesIdSubaccountsPostBodyBodyModel.name',
      ),
      description: _$map[r'description'].decodeJsonNullableString(
        context: r'StorageBoxesIdSubaccountsPostBodyBodyModel.description',
      ),
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(
          context: r'StorageBoxesIdSubaccountsPostBodyBodyModel.labels',
        ),
        context: r'StorageBoxesIdSubaccountsPostBodyBodyModel.labels',
      ),
    );
  }

  factory StorageBoxesIdSubaccountsPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for StorageBoxesIdSubaccountsPostBodyBodyModel: contains complex types',
    );
  }

  /// Home directory of the [Storage Box Subaccount](#tag/storage-box-subaccounts).
  ///
  /// The directory will be created if it doesn't exist yet.
  ///
  ///
  /// **Example**:
  /// ```
  /// my-backup/server01
  /// ```
  final _i3.String homeDirectory;

  /// Password of the [Storage Box Subaccount](#tag/storage-box-subaccounts).
  ///
  /// For more details, see the [Storage Boxes password policy](#tag/storage-boxes/password-policy).
  ///
  final _i3.String password;

  final _i4.StorageBoxesIdSubaccountsPostBodyBodyAccessSettingsModel?
  accessSettings;

  /// Name of the [Storage Box Subaccount](#tag/storage-box-subaccounts).
  ///
  /// Defaults to the [Storage Box Subaccount](#tag/storage-box-subaccounts) `username`.
  ///
  ///
  /// **Example**:
  /// ```
  /// my-name
  /// ```
  final _i3.String? name;

  /// A description of [Storage Box Subaccount](#tag/storage-box-subaccounts).
  ///
  ///
  /// **Example**:
  /// ```
  /// my-backup-server01
  /// ```
  final _i3.String? description;

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

  @_i3.override
  _i3.Object? toJson() => {
    r'home_directory': this.homeDirectory,
    r'password': this.password,
    if (this.accessSettings != null)
      r'access_settings': this.accessSettings?.toJson(),
    if (this.name != null) r'name': this.name,
    if (this.description != null) r'description': this.description,
    if (this.labels != null) r'labels': this.labels,
  };

  StorageBoxesIdSubaccountsPostBodyBodyModel Function({
    _i3.String? homeDirectory,
    _i3.String? password,
    _i4.StorageBoxesIdSubaccountsPostBodyBodyAccessSettingsModel?
    accessSettings,
    _i3.String? name,
    _i3.String? description,
    _i3.Map<_i3.String, _i3.String>? labels,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.String? homeDirectory,
      _i3.String? password,
      _i3.Object? accessSettings = _sentinel,
      _i3.Object? name = _sentinel,
      _i3.Object? description = _sentinel,
      _i3.Object? labels = _sentinel,
    }) => StorageBoxesIdSubaccountsPostBodyBodyModel(
      homeDirectory: homeDirectory ?? this.homeDirectory,
      password: password ?? this.password,
      accessSettings: _i3.identical(accessSettings, _sentinel)
          ? this.accessSettings
          : (accessSettings
                as _i4.StorageBoxesIdSubaccountsPostBodyBodyAccessSettingsModel?),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String?),
      description: _i3.identical(description, _sentinel)
          ? this.description
          : (description as _i3.String?),
      labels: _i3.identical(labels, _sentinel)
          ? this.labels
          : (labels as _i3.Map<_i3.String, _i3.String>?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is StorageBoxesIdSubaccountsPostBodyBodyModel &&
        other.homeDirectory == this.homeDirectory &&
        other.password == this.password &&
        other.accessSettings == this.accessSettings &&
        other.name == this.name &&
        other.description == this.description &&
        _$deepEquals.equals(other.labels, this.labels);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.homeDirectory,
      this.password,
      this.accessSettings,
      this.name,
      this.description,
      deepEquals.hash(this.labels),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for StorageBoxesIdSubaccountsPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StorageBoxesIdSubaccountsPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
