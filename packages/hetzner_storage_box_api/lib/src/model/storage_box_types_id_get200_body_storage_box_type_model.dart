// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:hetzner_storage_box_api/src/model/storage_box_types_id_get200_body_storage_box_type_deprecation_model.dart'
    as _i5;
import 'package:hetzner_storage_box_api/src/model/storage_box_types_id_get200_body_storage_box_type_prices_array_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxTypesIdGet200BodyStorageBoxTypeModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxTypesIdGet200BodyStorageBoxTypeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.snapshotLimit,
    required this.automaticSnapshotLimit,
    required this.subaccountsLimit,
    required this.size,
    required this.prices,
    required this.deprecation,
  });

  factory StorageBoxTypesIdGet200BodyStorageBoxTypeModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for StorageBoxTypesIdGet200BodyStorageBoxTypeModel: contains complex types',
    );
  }

  factory StorageBoxTypesIdGet200BodyStorageBoxTypeModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxTypesIdGet200BodyStorageBoxTypeModel',
    );
    return StorageBoxTypesIdGet200BodyStorageBoxTypeModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'StorageBoxTypesIdGet200BodyStorageBoxTypeModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'StorageBoxTypesIdGet200BodyStorageBoxTypeModel.name',
      ),
      description: _$map[r'description'].decodeJsonString(
        context: r'StorageBoxTypesIdGet200BodyStorageBoxTypeModel.description',
      ),
      snapshotLimit: _$map[r'snapshot_limit'].decodeJsonNullableInt(
        context:
            r'StorageBoxTypesIdGet200BodyStorageBoxTypeModel.snapshot_limit',
      ),
      automaticSnapshotLimit: _$map[r'automatic_snapshot_limit']
          .decodeJsonNullableInt(
            context: r'StorageBoxTypesIdGet200BodyStorageBoxTypeModel.automatic_snapshot_limit',
          ),
      subaccountsLimit: _$map[r'subaccounts_limit'].decodeJsonInt(
        context:
            r'StorageBoxTypesIdGet200BodyStorageBoxTypeModel.subaccounts_limit',
      ),
      size: _$map[r'size'].decodeJsonInt(
        context: r'StorageBoxTypesIdGet200BodyStorageBoxTypeModel.size',
      ),
      prices: _$map[r'prices']
          .decodeJsonList<_i3.Object?>(
            context: r'StorageBoxTypesIdGet200BodyStorageBoxTypeModel.prices',
          )
          .map(
            _i4
                .StorageBoxTypesIdGet200BodyStorageBoxTypePricesArrayModel
                .fromJson,
          )
          .toList(),
      deprecation: _$map[r'deprecation'] == null
          ? null
          : _i5.StorageBoxTypesIdGet200BodyStorageBoxTypeDeprecationModel.fromJson(
              _$map[r'deprecation'],
            ),
    );
  }

  factory StorageBoxTypesIdGet200BodyStorageBoxTypeModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for StorageBoxTypesIdGet200BodyStorageBoxTypeModel: contains complex types',
    );
  }

  /// ID of the [Storage Box Type](#tag/storage-box-types).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Name of the [Storage Box Type](#tag/storage-box-types).
  ///
  /// **Example**:
  /// ```
  /// bx11
  /// ```
  final _i3.String name;

  /// Description of the [Storage Box Type](#tag/storage-box-types).
  ///
  /// **Example**:
  /// ```
  /// BX11
  /// ```
  final _i3.String description;

  /// Maximum number of allowed manual snapshots.
  ///
  /// **Example**:
  /// ```json
  /// 10
  /// ```
  final _i3.int? snapshotLimit;

  /// Maximum number of snapshots created automatically by a snapshot plan.
  ///
  /// **Example**:
  /// ```json
  /// 10
  /// ```
  final _i3.int? automaticSnapshotLimit;

  /// Maximum number of subaccounts.
  ///
  /// **Example**:
  /// ```json
  /// 200
  /// ```
  final _i3.int subaccountsLimit;

  /// Available storage in bytes.
  ///
  /// **Example**:
  /// ```json
  /// 1073741824
  /// ```
  final _i3.int size;

  /// Price per [Location](#tag/locations).
  final _i3.List<_i4.StorageBoxTypesIdGet200BodyStorageBoxTypePricesArrayModel>
  prices;

  /// Describes if, when and how the resource is deprecated. If this field is
  /// set to `null` the resource is not deprecated. If a value is set, it is
  /// considered deprecated.
  ///
  final _i5.StorageBoxTypesIdGet200BodyStorageBoxTypeDeprecationModel?
  deprecation;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'description': this.description,
    r'snapshot_limit': this.snapshotLimit,
    r'automatic_snapshot_limit': this.automaticSnapshotLimit,
    r'subaccounts_limit': this.subaccountsLimit,
    r'size': this.size,
    r'prices': this.prices.map((e) => e.toJson()).toList(),
    r'deprecation': this.deprecation?.toJson(),
  };

  StorageBoxTypesIdGet200BodyStorageBoxTypeModel Function({
    _i3.int? id,
    _i3.String? name,
    _i3.String? description,
    _i3.int? snapshotLimit,
    _i3.int? automaticSnapshotLimit,
    _i3.int? subaccountsLimit,
    _i3.int? size,
    _i3.List<_i4.StorageBoxTypesIdGet200BodyStorageBoxTypePricesArrayModel>?
    prices,
    _i5.StorageBoxTypesIdGet200BodyStorageBoxTypeDeprecationModel? deprecation,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.String? name,
      _i3.String? description,
      _i3.Object? snapshotLimit = _sentinel,
      _i3.Object? automaticSnapshotLimit = _sentinel,
      _i3.int? subaccountsLimit,
      _i3.int? size,
      _i3.List<_i4.StorageBoxTypesIdGet200BodyStorageBoxTypePricesArrayModel>?
      prices,
      _i3.Object? deprecation = _sentinel,
    }) => StorageBoxTypesIdGet200BodyStorageBoxTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      snapshotLimit: _i3.identical(snapshotLimit, _sentinel)
          ? this.snapshotLimit
          : (snapshotLimit as _i3.int?),
      automaticSnapshotLimit: _i3.identical(automaticSnapshotLimit, _sentinel)
          ? this.automaticSnapshotLimit
          : (automaticSnapshotLimit as _i3.int?),
      subaccountsLimit: subaccountsLimit ?? this.subaccountsLimit,
      size: size ?? this.size,
      prices: prices ?? this.prices,
      deprecation: _i3.identical(deprecation, _sentinel)
          ? this.deprecation
          : (deprecation
                as _i5.StorageBoxTypesIdGet200BodyStorageBoxTypeDeprecationModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is StorageBoxTypesIdGet200BodyStorageBoxTypeModel &&
        other.id == this.id &&
        other.name == this.name &&
        other.description == this.description &&
        other.snapshotLimit == this.snapshotLimit &&
        other.automaticSnapshotLimit == this.automaticSnapshotLimit &&
        other.subaccountsLimit == this.subaccountsLimit &&
        other.size == this.size &&
        _$deepEquals.equals(other.prices, this.prices) &&
        other.deprecation == this.deprecation;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.name,
      this.description,
      this.snapshotLimit,
      this.automaticSnapshotLimit,
      this.subaccountsLimit,
      this.size,
      deepEquals.hash(this.prices),
      this.deprecation,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for StorageBoxTypesIdGet200BodyStorageBoxTypeModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StorageBoxTypesIdGet200BodyStorageBoxTypeModel: complex types cannot be URI-encoded',
    );
  }
}
