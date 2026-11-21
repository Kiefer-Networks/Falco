// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:hetzner_storage_box_api/src/model/storage_boxes_get200_body_storage_boxes_array_storage_box_type_prices_array_price_hourly_model.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_get200_body_storage_boxes_array_storage_box_type_prices_array_price_monthly_model.dart'
    as _i5;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_get200_body_storage_boxes_array_storage_box_type_prices_array_setup_fee_model.dart'
    as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayModel({
    required this.location,
    required this.priceHourly,
    required this.priceMonthly,
    required this.setupFee,
  });

  factory StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayModel: contains complex types',
    );
  }

  factory StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayModel',
    );
    return StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayModel(
      location: _$map[r'location'].decodeJsonString(
        context: r'StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayModel.location',
      ),
      priceHourly:
          _i4.StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayPriceHourlyModel.fromJson(
            _$map[r'price_hourly'],
          ),
      priceMonthly:
          _i5.StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayPriceMonthlyModel.fromJson(
            _$map[r'price_monthly'],
          ),
      setupFee:
          _i6.StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArraySetupFeeModel.fromJson(
            _$map[r'setup_fee'],
          ),
    );
  }

  factory StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayModel: contains complex types',
    );
  }

  /// Name of the [Location](#tag/locations) the price is for.
  ///
  /// **Example**:
  /// ```
  /// fsn1
  /// ```
  final _i3.String location;

  /// Hourly price in this [Location](#tag/locations).
  final _i4.StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayPriceHourlyModel
  priceHourly;

  /// Monthly price in this [Location](#tag/locations).
  final _i5.StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayPriceMonthlyModel
  priceMonthly;

  /// Setup fee in this [Location](#tag/locations).
  final _i6.StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArraySetupFeeModel
  setupFee;

  @_i3.override
  _i3.Object? toJson() => {
    r'location': this.location,
    r'price_hourly': this.priceHourly.toJson(),
    r'price_monthly': this.priceMonthly.toJson(),
    r'setup_fee': this.setupFee.toJson(),
  };

  StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayModel
  Function({
    _i3.String? location,
    _i4.StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayPriceHourlyModel?
    priceHourly,
    _i5.StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayPriceMonthlyModel?
    priceMonthly,
    _i6.StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArraySetupFeeModel?
    setupFee,
  })
  get copyWith {
    return ({
      _i3.String? location,
      _i4.StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayPriceHourlyModel?
      priceHourly,
      _i5.StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayPriceMonthlyModel?
      priceMonthly,
      _i6.StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArraySetupFeeModel?
      setupFee,
    }) => StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayModel(
      location: location ?? this.location,
      priceHourly: priceHourly ?? this.priceHourly,
      priceMonthly: priceMonthly ?? this.priceMonthly,
      setupFee: setupFee ?? this.setupFee,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayModel &&
        other.location == this.location &&
        other.priceHourly == this.priceHourly &&
        other.priceMonthly == this.priceMonthly &&
        other.setupFee == this.setupFee;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.location,
      this.priceHourly,
      this.priceMonthly,
      this.setupFee,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StorageBoxesGet200BodyStorageBoxesArrayStorageBoxTypePricesArrayModel: complex types cannot be URI-encoded',
    );
  }
}
