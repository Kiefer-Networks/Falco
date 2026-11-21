// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel({
    this.readonly,
    this.reachableExternally,
    this.sambaEnabled,
    this.sshEnabled,
    this.webdavEnabled,
  });

  factory StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'readonly',
        r'reachable_externally',
        r'samba_enabled',
        r'ssh_enabled',
        r'webdav_enabled',
      },
      listKeys: {},
      context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel(
      readonly: _$values[r'readonly'].decodeSimpleNullableBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.readonly',
      ),
      reachableExternally: _$values[r'reachable_externally']
          .decodeSimpleNullableBool(
            context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.reachable_externally',
          ),
      sambaEnabled: _$values[r'samba_enabled'].decodeSimpleNullableBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.samba_enabled',
      ),
      sshEnabled: _$values[r'ssh_enabled'].decodeSimpleNullableBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.ssh_enabled',
      ),
      webdavEnabled: _$values[r'webdav_enabled'].decodeSimpleNullableBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.webdav_enabled',
      ),
    );
  }

  factory StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel',
    );
    return StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel(
      readonly: _$map[r'readonly'].decodeJsonNullableBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.readonly',
      ),
      reachableExternally: _$map[r'reachable_externally']
          .decodeJsonNullableBool(
            context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.reachable_externally',
          ),
      sambaEnabled: _$map[r'samba_enabled'].decodeJsonNullableBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.samba_enabled',
      ),
      sshEnabled: _$map[r'ssh_enabled'].decodeJsonNullableBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.ssh_enabled',
      ),
      webdavEnabled: _$map[r'webdav_enabled'].decodeJsonNullableBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.webdav_enabled',
      ),
    );
  }

  factory StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'readonly',
        r'reachable_externally',
        r'samba_enabled',
        r'ssh_enabled',
        r'webdav_enabled',
      },
      listKeys: {},
      context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel',
    );
    return StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel(
      readonly: _$values[r'readonly'].decodeFormNullableBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.readonly',
      ),
      reachableExternally: _$values[r'reachable_externally']
          .decodeFormNullableBool(
            context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.reachable_externally',
          ),
      sambaEnabled: _$values[r'samba_enabled'].decodeFormNullableBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.samba_enabled',
      ),
      sshEnabled: _$values[r'ssh_enabled'].decodeFormNullableBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.ssh_enabled',
      ),
      webdavEnabled: _$values[r'webdav_enabled'].decodeFormNullableBool(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel.webdav_enabled',
      ),
    );
  }

  /// Whether the [Subaccount](#tag/storage-box-subaccounts) is read-only.
  final _i3.bool? readonly;

  /// Whether access from outside the Hetzner network is allowed.
  final _i3.bool? reachableExternally;

  /// Whether the Samba subsystem is enabled.
  final _i3.bool? sambaEnabled;

  /// Whether the SSH subsystem is enabled.
  final _i3.bool? sshEnabled;

  /// Whether the WebDAV subsystem is enabled.
  final _i3.bool? webdavEnabled;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.readonly != null) r'readonly': this.readonly,
    if (this.reachableExternally != null)
      r'reachable_externally': this.reachableExternally,
    if (this.sambaEnabled != null) r'samba_enabled': this.sambaEnabled,
    if (this.sshEnabled != null) r'ssh_enabled': this.sshEnabled,
    if (this.webdavEnabled != null) r'webdav_enabled': this.webdavEnabled,
  };

  StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel
  Function({
    _i3.bool? readonly,
    _i3.bool? reachableExternally,
    _i3.bool? sambaEnabled,
    _i3.bool? sshEnabled,
    _i3.bool? webdavEnabled,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? readonly = _sentinel,
      _i3.Object? reachableExternally = _sentinel,
      _i3.Object? sambaEnabled = _sentinel,
      _i3.Object? sshEnabled = _sentinel,
      _i3.Object? webdavEnabled = _sentinel,
    }) =>
        StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel(
          readonly: _i3.identical(readonly, _sentinel)
              ? this.readonly
              : (readonly as _i3.bool?),
          reachableExternally: _i3.identical(reachableExternally, _sentinel)
              ? this.reachableExternally
              : (reachableExternally as _i3.bool?),
          sambaEnabled: _i3.identical(sambaEnabled, _sentinel)
              ? this.sambaEnabled
              : (sambaEnabled as _i3.bool?),
          sshEnabled: _i3.identical(sshEnabled, _sentinel)
              ? this.sshEnabled
              : (sshEnabled as _i3.bool?),
          webdavEnabled: _i3.identical(webdavEnabled, _sentinel)
              ? this.webdavEnabled
              : (webdavEnabled as _i3.bool?),
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel &&
        other.readonly == this.readonly &&
        other.reachableExternally == this.reachableExternally &&
        other.sambaEnabled == this.sambaEnabled &&
        other.sshEnabled == this.sshEnabled &&
        other.webdavEnabled == this.webdavEnabled;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.readonly,
      this.reachableExternally,
      this.sambaEnabled,
      this.sshEnabled,
      this.webdavEnabled,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (this.readonly != null) {
      _$result[r'readonly'] = _i1.PropertyValue.scalar(
        this.readonly!.toString(),
      );
    }
    if (this.reachableExternally != null) {
      _$result[r'reachable_externally'] = _i1.PropertyValue.scalar(
        this.reachableExternally!.toString(),
      );
    }
    if (this.sambaEnabled != null) {
      _$result[r'samba_enabled'] = _i1.PropertyValue.scalar(
        this.sambaEnabled!.toString(),
      );
    }
    if (this.sshEnabled != null) {
      _$result[r'ssh_enabled'] = _i1.PropertyValue.scalar(
        this.sshEnabled!.toString(),
      );
    }
    if (this.webdavEnabled != null) {
      _$result[r'webdav_enabled'] = _i1.PropertyValue.scalar(
        this.webdavEnabled!.toString(),
      );
    }
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
      r'Cannot uriEncode StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
