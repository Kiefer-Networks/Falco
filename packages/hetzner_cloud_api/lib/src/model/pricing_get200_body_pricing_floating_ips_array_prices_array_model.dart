// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/pricing_get200_body_pricing_floating_ips_array_prices_array_price_monthly_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PricingGet200BodyPricingFloatingIpsArrayPricesArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PricingGet200BodyPricingFloatingIpsArrayPricesArrayModel({
    required this.location,
    required this.priceMonthly,
  });

  factory PricingGet200BodyPricingFloatingIpsArrayPricesArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for PricingGet200BodyPricingFloatingIpsArrayPricesArrayModel: contains complex types',
    );
  }

  factory PricingGet200BodyPricingFloatingIpsArrayPricesArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'PricingGet200BodyPricingFloatingIpsArrayPricesArrayModel',
    );
    return PricingGet200BodyPricingFloatingIpsArrayPricesArrayModel(
      location: _$map[r'location'].decodeJsonString(
        context: r'PricingGet200BodyPricingFloatingIpsArrayPricesArrayModel.location',
      ),
      priceMonthly:
          _i4.PricingGet200BodyPricingFloatingIpsArrayPricesArrayPriceMonthlyModel.fromJson(
            _$map[r'price_monthly'],
          ),
    );
  }

  factory PricingGet200BodyPricingFloatingIpsArrayPricesArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for PricingGet200BodyPricingFloatingIpsArrayPricesArrayModel: contains complex types',
    );
  }

  /// Name of the [Location](#tag/locations) the price is for.
  ///
  /// **Example**:
  /// ```
  /// fsn1
  /// ```
  final _i3.String location;

  /// Monthly price in this [Location](#tag/locations).
  final _i4.PricingGet200BodyPricingFloatingIpsArrayPricesArrayPriceMonthlyModel
  priceMonthly;

  @_i3.override
  _i3.Object? toJson() => {
    r'location': this.location,
    r'price_monthly': this.priceMonthly.toJson(),
  };

  PricingGet200BodyPricingFloatingIpsArrayPricesArrayModel Function({
    _i3.String? location,
    _i4.PricingGet200BodyPricingFloatingIpsArrayPricesArrayPriceMonthlyModel?
    priceMonthly,
  })
  get copyWith {
    return ({
      _i3.String? location,
      _i4.PricingGet200BodyPricingFloatingIpsArrayPricesArrayPriceMonthlyModel?
      priceMonthly,
    }) => PricingGet200BodyPricingFloatingIpsArrayPricesArrayModel(
      location: location ?? this.location,
      priceMonthly: priceMonthly ?? this.priceMonthly,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PricingGet200BodyPricingFloatingIpsArrayPricesArrayModel &&
        other.location == this.location &&
        other.priceMonthly == this.priceMonthly;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.location, this.priceMonthly]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for PricingGet200BodyPricingFloatingIpsArrayPricesArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PricingGet200BodyPricingFloatingIpsArrayPricesArrayModel: complex types cannot be URI-encoded',
    );
  }
}
