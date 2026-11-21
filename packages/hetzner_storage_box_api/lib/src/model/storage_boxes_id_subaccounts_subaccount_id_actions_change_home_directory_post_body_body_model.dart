// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel({
    required this.homeDirectory,
  });

  factory StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'home_directory'},
      listKeys: {},
      context: r'StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel(
      homeDirectory: _$values[r'home_directory'].decodeSimpleString(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel.home_directory',
      ),
    );
  }

  factory StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel',
    );
    return StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel(
      homeDirectory: _$map[r'home_directory'].decodeJsonString(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel.home_directory',
      ),
    );
  }

  factory StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'home_directory'},
      listKeys: {},
      context: r'StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel',
    );
    return StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel(
      homeDirectory: _$values[r'home_directory'].decodeFormString(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel.home_directory',
      ),
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

  @_i3.override
  _i3.Object? toJson() => {r'home_directory': this.homeDirectory};

  StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel
  Function({_i3.String? homeDirectory})
  get copyWith {
    return ({_i3.String? homeDirectory}) =>
        StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel(
          homeDirectory: homeDirectory ?? this.homeDirectory,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel &&
        other.homeDirectory == this.homeDirectory;
  }

  @_i3.override
  _i3.int get hashCode => this.homeDirectory.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'home_directory'] = _i1.PropertyValue.scalar(this.homeDirectory);
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
      r'Cannot uriEncode StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
