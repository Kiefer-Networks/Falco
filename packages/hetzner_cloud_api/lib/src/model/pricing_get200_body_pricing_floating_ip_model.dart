// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/pricing_get200_body_pricing_floating_ip_price_monthly_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Price of [Floating IPs](#tag/floating-ips).
///
/// **Deprecated**: This field is deprecated, please refer to the `floating_ips` field instead.
///
/// See the [Changelog](https://docs.hetzner.cloud/changelog#2024-08-29-field-floating_ip-in-pricing-response-is-now-deprecated) for more details.
///
@_i2.immutable
@_i3.Deprecated('This class is deprecated.')
class PricingGet200BodyPricingFloatingIpModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PricingGet200BodyPricingFloatingIpModel({required this.priceMonthly});

  factory PricingGet200BodyPricingFloatingIpModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for PricingGet200BodyPricingFloatingIpModel: contains complex types',
    );
  }

  factory PricingGet200BodyPricingFloatingIpModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'PricingGet200BodyPricingFloatingIpModel',
    );
    return PricingGet200BodyPricingFloatingIpModel(
      priceMonthly:
          _i4.PricingGet200BodyPricingFloatingIpPriceMonthlyModel.fromJson(
            _$map[r'price_monthly'],
          ),
    );
  }

  factory PricingGet200BodyPricingFloatingIpModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for PricingGet200BodyPricingFloatingIpModel: contains complex types',
    );
  }

  /// Price of one [Floating IP](#tag/floating-ips) per month.
  final _i4.PricingGet200BodyPricingFloatingIpPriceMonthlyModel priceMonthly;

  @_i3.override
  _i3.Object? toJson() => {r'price_monthly': this.priceMonthly.toJson()};

  PricingGet200BodyPricingFloatingIpModel Function({
    _i4.PricingGet200BodyPricingFloatingIpPriceMonthlyModel? priceMonthly,
  })
  get copyWith {
    return ({
      _i4.PricingGet200BodyPricingFloatingIpPriceMonthlyModel? priceMonthly,
    }) => PricingGet200BodyPricingFloatingIpModel(
      priceMonthly: priceMonthly ?? this.priceMonthly,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PricingGet200BodyPricingFloatingIpModel &&
        other.priceMonthly == this.priceMonthly;
  }

  @_i3.override
  _i3.int get hashCode => this.priceMonthly.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for PricingGet200BodyPricingFloatingIpModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PricingGet200BodyPricingFloatingIpModel: complex types cannot be URI-encoded',
    );
  }
}
