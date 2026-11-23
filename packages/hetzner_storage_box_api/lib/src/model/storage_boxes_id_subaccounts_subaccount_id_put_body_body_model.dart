// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel({
    this.name,
    this.description,
    this.labels,
  });

  factory StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel: contains complex types',
    );
  }

  factory StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel',
    );
    return StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel(
      name: _$map[r'name'].decodeJsonNullableString(
        context: r'StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel.name',
      ),
      description: _$map[r'description'].decodeJsonNullableString(
        context: r'StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel.description',
      ),
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(
          context:
              r'StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel.labels',
        ),
        context:
            r'StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel.labels',
      ),
    );
  }

  factory StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel: contains complex types',
    );
  }

  /// Name of the [Storage Box Subaccount](#tag/storage-box-subaccounts).
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
  ///
  /// Note that the set of [Labels](#description/labels) provided in the request will overwrite the
  /// existing one.
  ///
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
    if (this.name != null) r'name': this.name,
    if (this.description != null) r'description': this.description,
    if (this.labels != null) r'labels': this.labels,
  };

  StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel Function({
    _i3.String? name,
    _i3.String? description,
    _i3.Map<_i3.String, _i3.String>? labels,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? name = _sentinel,
      _i3.Object? description = _sentinel,
      _i3.Object? labels = _sentinel,
    }) => StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel(
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
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel &&
        other.name == this.name &&
        other.description == this.description &&
        _$deepEquals.equals(other.labels, this.labels);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
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
    r'parameterProperties not supported for StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
