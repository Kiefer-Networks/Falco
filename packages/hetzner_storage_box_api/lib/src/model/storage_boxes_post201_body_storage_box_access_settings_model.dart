// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Access settings of the [Storage Box](#tag/storage-boxes).
@_i2.immutable
class StorageBoxesPost201BodyStorageBoxAccessSettingsModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesPost201BodyStorageBoxAccessSettingsModel({
    required this.reachableExternally,
    required this.sambaEnabled,
    required this.sshEnabled,
    required this.webdavEnabled,
    required this.zfsEnabled,
  });

  factory StorageBoxesPost201BodyStorageBoxAccessSettingsModel.fromSimple(
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
        r'zfs_enabled',
      },
      listKeys: {},
      context: r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return StorageBoxesPost201BodyStorageBoxAccessSettingsModel(
      reachableExternally: _$values[r'reachable_externally'].decodeSimpleBool(
        context: r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel.reachable_externally',
      ),
      sambaEnabled: _$values[r'samba_enabled'].decodeSimpleBool(
        context: r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel.samba_enabled',
      ),
      sshEnabled: _$values[r'ssh_enabled'].decodeSimpleBool(
        context:
            r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel.ssh_enabled',
      ),
      webdavEnabled: _$values[r'webdav_enabled'].decodeSimpleBool(
        context: r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel.webdav_enabled',
      ),
      zfsEnabled: _$values[r'zfs_enabled'].decodeSimpleBool(
        context:
            r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel.zfs_enabled',
      ),
    );
  }

  factory StorageBoxesPost201BodyStorageBoxAccessSettingsModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel',
    );
    return StorageBoxesPost201BodyStorageBoxAccessSettingsModel(
      reachableExternally: _$map[r'reachable_externally'].decodeJsonBool(
        context: r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel.reachable_externally',
      ),
      sambaEnabled: _$map[r'samba_enabled'].decodeJsonBool(
        context: r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel.samba_enabled',
      ),
      sshEnabled: _$map[r'ssh_enabled'].decodeJsonBool(
        context:
            r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel.ssh_enabled',
      ),
      webdavEnabled: _$map[r'webdav_enabled'].decodeJsonBool(
        context: r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel.webdav_enabled',
      ),
      zfsEnabled: _$map[r'zfs_enabled'].decodeJsonBool(
        context:
            r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel.zfs_enabled',
      ),
    );
  }

  factory StorageBoxesPost201BodyStorageBoxAccessSettingsModel.fromForm(
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
        r'zfs_enabled',
      },
      listKeys: {},
      context: r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel',
    );
    return StorageBoxesPost201BodyStorageBoxAccessSettingsModel(
      reachableExternally: _$values[r'reachable_externally'].decodeFormBool(
        context: r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel.reachable_externally',
      ),
      sambaEnabled: _$values[r'samba_enabled'].decodeFormBool(
        context: r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel.samba_enabled',
      ),
      sshEnabled: _$values[r'ssh_enabled'].decodeFormBool(
        context:
            r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel.ssh_enabled',
      ),
      webdavEnabled: _$values[r'webdav_enabled'].decodeFormBool(
        context: r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel.webdav_enabled',
      ),
      zfsEnabled: _$values[r'zfs_enabled'].decodeFormBool(
        context:
            r'StorageBoxesPost201BodyStorageBoxAccessSettingsModel.zfs_enabled',
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

  /// Whether the ZFS snapshot folder is visible.
  final _i3.bool zfsEnabled;

  @_i3.override
  _i3.Object? toJson() => {
    r'reachable_externally': this.reachableExternally,
    r'samba_enabled': this.sambaEnabled,
    r'ssh_enabled': this.sshEnabled,
    r'webdav_enabled': this.webdavEnabled,
    r'zfs_enabled': this.zfsEnabled,
  };

  StorageBoxesPost201BodyStorageBoxAccessSettingsModel Function({
    _i3.bool? reachableExternally,
    _i3.bool? sambaEnabled,
    _i3.bool? sshEnabled,
    _i3.bool? webdavEnabled,
    _i3.bool? zfsEnabled,
  })
  get copyWith {
    return ({
      _i3.bool? reachableExternally,
      _i3.bool? sambaEnabled,
      _i3.bool? sshEnabled,
      _i3.bool? webdavEnabled,
      _i3.bool? zfsEnabled,
    }) => StorageBoxesPost201BodyStorageBoxAccessSettingsModel(
      reachableExternally: reachableExternally ?? this.reachableExternally,
      sambaEnabled: sambaEnabled ?? this.sambaEnabled,
      sshEnabled: sshEnabled ?? this.sshEnabled,
      webdavEnabled: webdavEnabled ?? this.webdavEnabled,
      zfsEnabled: zfsEnabled ?? this.zfsEnabled,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is StorageBoxesPost201BodyStorageBoxAccessSettingsModel &&
        other.reachableExternally == this.reachableExternally &&
        other.sambaEnabled == this.sambaEnabled &&
        other.sshEnabled == this.sshEnabled &&
        other.webdavEnabled == this.webdavEnabled &&
        other.zfsEnabled == this.zfsEnabled;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.reachableExternally,
      this.sambaEnabled,
      this.sshEnabled,
      this.webdavEnabled,
      this.zfsEnabled,
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
    _$result[r'zfs_enabled'] = _i1.PropertyValue.scalar(
      this.zfsEnabled.toString(),
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
      r'Cannot uriEncode StorageBoxesPost201BodyStorageBoxAccessSettingsModel: complex types cannot be URI-encoded',
    );
  }
}
