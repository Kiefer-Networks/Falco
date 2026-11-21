// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/pricing_get200_body_pricing_primary_ips_array_prices_array_price_hourly_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/pricing_get200_body_pricing_primary_ips_array_prices_array_price_monthly_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel({
    required this.location,
    required this.priceHourly,
    required this.priceMonthly,
  });

  factory PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel: contains complex types',
    );
  }

  factory PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel',
    );
    return PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel(
      location: _$map[r'location'].decodeJsonString(
        context:
            r'PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel.location',
      ),
      priceHourly:
          _i4.PricingGet200BodyPricingPrimaryIpsArrayPricesArrayPriceHourlyModel.fromJson(
            _$map[r'price_hourly'],
          ),
      priceMonthly:
          _i5.PricingGet200BodyPricingPrimaryIpsArrayPricesArrayPriceMonthlyModel.fromJson(
            _$map[r'price_monthly'],
          ),
    );
  }

  factory PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel: contains complex types',
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
  final _i4.PricingGet200BodyPricingPrimaryIpsArrayPricesArrayPriceHourlyModel
  priceHourly;

  /// Monthly price in this [Location](#tag/locations).
  final _i5.PricingGet200BodyPricingPrimaryIpsArrayPricesArrayPriceMonthlyModel
  priceMonthly;

  @_i3.override
  _i3.Object? toJson() => {
    r'location': this.location,
    r'price_hourly': this.priceHourly.toJson(),
    r'price_monthly': this.priceMonthly.toJson(),
  };

  PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel Function({
    _i3.String? location,
    _i4.PricingGet200BodyPricingPrimaryIpsArrayPricesArrayPriceHourlyModel?
    priceHourly,
    _i5.PricingGet200BodyPricingPrimaryIpsArrayPricesArrayPriceMonthlyModel?
    priceMonthly,
  })
  get copyWith {
    return ({
      _i3.String? location,
      _i4.PricingGet200BodyPricingPrimaryIpsArrayPricesArrayPriceHourlyModel?
      priceHourly,
      _i5.PricingGet200BodyPricingPrimaryIpsArrayPricesArrayPriceMonthlyModel?
      priceMonthly,
    }) => PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel(
      location: location ?? this.location,
      priceHourly: priceHourly ?? this.priceHourly,
      priceMonthly: priceMonthly ?? this.priceMonthly,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel &&
        other.location == this.location &&
        other.priceHourly == this.priceHourly &&
        other.priceMonthly == this.priceMonthly;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.location,
      this.priceHourly,
      this.priceMonthly,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel: complex types cannot be URI-encoded',
    );
  }
}
