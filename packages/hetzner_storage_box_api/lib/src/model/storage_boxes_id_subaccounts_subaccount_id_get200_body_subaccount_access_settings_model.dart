// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Access settings for the [Subaccount](#tag/storage-box-subaccounts).
///
@_i2.immutable
class StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel({
    required this.reachableExternally,
    required this.sambaEnabled,
    required this.sshEnabled,
    required this.webdavEnabled,
    required this.readonly,
  });

  factory StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'reachable_externally',
        r'samba_enabled',
        r'ssh_enabled',
        r'webdav_enabled',
        r'readonly',
      },
      listKeys: {},
      context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel(
      reachableExternally: _$values[r'reachable_externally'].decodeSimpleBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.reachable_externally',
      ),
      sambaEnabled: _$values[r'samba_enabled'].decodeSimpleBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.samba_enabled',
      ),
      sshEnabled: _$values[r'ssh_enabled'].decodeSimpleBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.ssh_enabled',
      ),
      webdavEnabled: _$values[r'webdav_enabled'].decodeSimpleBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.webdav_enabled',
      ),
      readonly: _$values[r'readonly'].decodeSimpleBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.readonly',
      ),
    );
  }

  factory StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel',
    );
    return StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel(
      reachableExternally: _$map[r'reachable_externally'].decodeJsonBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.reachable_externally',
      ),
      sambaEnabled: _$map[r'samba_enabled'].decodeJsonBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.samba_enabled',
      ),
      sshEnabled: _$map[r'ssh_enabled'].decodeJsonBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.ssh_enabled',
      ),
      webdavEnabled: _$map[r'webdav_enabled'].decodeJsonBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.webdav_enabled',
      ),
      readonly: _$map[r'readonly'].decodeJsonBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.readonly',
      ),
    );
  }

  factory StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'reachable_externally',
        r'samba_enabled',
        r'ssh_enabled',
        r'webdav_enabled',
        r'readonly',
      },
      listKeys: {},
      context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel',
    );
    return StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel(
      reachableExternally: _$values[r'reachable_externally'].decodeFormBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.reachable_externally',
      ),
      sambaEnabled: _$values[r'samba_enabled'].decodeFormBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.samba_enabled',
      ),
      sshEnabled: _$values[r'ssh_enabled'].decodeFormBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.ssh_enabled',
      ),
      webdavEnabled: _$values[r'webdav_enabled'].decodeFormBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.webdav_enabled',
      ),
      readonly: _$values[r'readonly'].decodeFormBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel.readonly',
      ),
    );
  }

  /// Whether access from outside the Hetzner network is allowed.
  final _i3.bool reachableExternally;

  /// Whether the Samba subsystem is enabled.
  final _i3.bool sambaEnabled;

  /// Whether the SSH subsystem is enabled.
  final _i3.bool sshEnabled;

  /// Whether the WebDAV subsystem is enabled.
  final _i3.bool webdavEnabled;

  /// Whether the [Subaccount](#tag/storage-box-subaccounts) is read-only.
  final _i3.bool readonly;

  @_i3.override
  _i3.Object? toJson() => {
    r'reachable_externally': this.reachableExternally,
    r'samba_enabled': this.sambaEnabled,
    r'ssh_enabled': this.sshEnabled,
    r'webdav_enabled': this.webdavEnabled,
    r'readonly': this.readonly,
  };

  StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel
  Function({
    _i3.bool? reachableExternally,
    _i3.bool? sambaEnabled,
    _i3.bool? sshEnabled,
    _i3.bool? webdavEnabled,
    _i3.bool? readonly,
  })
  get copyWith {
    return ({
      _i3.bool? reachableExternally,
      _i3.bool? sambaEnabled,
      _i3.bool? sshEnabled,
      _i3.bool? webdavEnabled,
      _i3.bool? readonly,
    }) =>
        StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel(
          reachableExternally: reachableExternally ?? this.reachableExternally,
          sambaEnabled: sambaEnabled ?? this.sambaEnabled,
          sshEnabled: sshEnabled ?? this.sshEnabled,
          webdavEnabled: webdavEnabled ?? this.webdavEnabled,
          readonly: readonly ?? this.readonly,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel &&
        other.reachableExternally == this.reachableExternally &&
        other.sambaEnabled == this.sambaEnabled &&
        other.sshEnabled == this.sshEnabled &&
        other.webdavEnabled == this.webdavEnabled &&
        other.readonly == this.readonly;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.reachableExternally,
      this.sambaEnabled,
      this.sshEnabled,
      this.webdavEnabled,
      this.readonly,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'reachable_externally'] = _i1.PropertyValue.scalar(
      this.reachableExternally.toString(),
    );
    _$result[r'samba_enabled'] = _i1.PropertyValue.scalar(
      this.sambaEnabled.toString(),
    );
    _$result[r'ssh_enabled'] = _i1.PropertyValue.scalar(
      this.sshEnabled.toString(),
    );
    _$result[r'webdav_enabled'] = _i1.PropertyValue.scalar(
      this.webdavEnabled.toString(),
    );
    _$result[r'readonly'] = _i1.PropertyValue.scalar(this.readonly.toString());
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
      r'Cannot uriEncode StorageBoxesIdSubaccountsSubaccountIdGet200BodySubaccountAccessSettingsModel: complex types cannot be URI-encoded',
    );
  }
}
