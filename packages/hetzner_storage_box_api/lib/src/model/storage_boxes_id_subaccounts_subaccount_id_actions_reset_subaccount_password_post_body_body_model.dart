// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel({
    required this.password,
  });

  factory StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'password'},
      listKeys: {},
      context: r'StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel(
      password: _$values[r'password'].decodeSimpleString(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel.password',
      ),
    );
  }

  factory StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel',
    );
    return StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel(
      password: _$map[r'password'].decodeJsonString(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel.password',
      ),
    );
  }

  factory StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'password'},
      listKeys: {},
      context: r'StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel',
    );
    return StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel(
      password: _$values[r'password'].decodeFormString(
        context: r'StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel.password',
      ),
    );
  }

  /// Password of the [Storage Box Subaccount](#tag/storage-box-subaccounts).
  ///
  /// For more details, see the [Storage Boxes password policy](#tag/storage-boxes/password-policy).
  ///
  final _i3.String password;

  @_i3.override
  _i3.Object? toJson() => {r'password': this.password};

  StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel
  Function({_i3.String? password})
  get copyWith {
    return ({_i3.String? password}) =>
        StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel(
          password: password ?? this.password,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel &&
        other.password == this.password;
  }

  @_i3.override
  _i3.int get hashCode => this.password.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'password'] = _i1.PropertyValue.scalar(this.password);
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
      r'Cannot uriEncode StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
