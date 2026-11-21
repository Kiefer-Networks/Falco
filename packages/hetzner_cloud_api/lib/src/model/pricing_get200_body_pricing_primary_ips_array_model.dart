// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:hetzner_cloud_api/src/model/pricing_get200_body_pricing_primary_ips_array_prices_array_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/pricing_get200_body_pricing_primary_ips_array_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PricingGet200BodyPricingPrimaryIpsArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PricingGet200BodyPricingPrimaryIpsArrayModel({
    required this.$type,
    required this.prices,
  });

  factory PricingGet200BodyPricingPrimaryIpsArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for PricingGet200BodyPricingPrimaryIpsArrayModel: contains complex types',
    );
  }

  factory PricingGet200BodyPricingPrimaryIpsArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'PricingGet200BodyPricingPrimaryIpsArrayModel',
    );
    return PricingGet200BodyPricingPrimaryIpsArrayModel(
      $type: _i4.PricingGet200BodyPricingPrimaryIpsArrayTypeModel.fromJson(
        _$map[r'type'],
      ),
      prices: _$map[r'prices']
          .decodeJsonList<_i3.Object?>(
            context: r'PricingGet200BodyPricingPrimaryIpsArrayModel.prices',
          )
          .map(
            _i5
                .PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel
                .fromJson,
          )
          .toList(),
    );
  }

  factory PricingGet200BodyPricingPrimaryIpsArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for PricingGet200BodyPricingPrimaryIpsArrayModel: contains complex types',
    );
  }

  /// Type of [Primary IP](#tag/primary-ips) the price is for.
  ///
  /// **Example**:
  /// ```
  /// ipv4
  /// ```
  final _i4.PricingGet200BodyPricingPrimaryIpsArrayTypeModel $type;

  /// Price of the [Primary IP](#tag/primary-ips) type per [Location](#tag/locations).
  final _i3.List<_i5.PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel>
  prices;

  @_i3.override
  _i3.Object? toJson() => {
    r'type': this.$type.toJson(),
    r'prices': this.prices.map((e) => e.toJson()).toList(),
  };

  PricingGet200BodyPricingPrimaryIpsArrayModel Function({
    _i4.PricingGet200BodyPricingPrimaryIpsArrayTypeModel? $type,
    _i3.List<_i5.PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel>?
    prices,
  })
  get copyWith {
    return ({
      _i4.PricingGet200BodyPricingPrimaryIpsArrayTypeModel? $type,
      _i3.List<_i5.PricingGet200BodyPricingPrimaryIpsArrayPricesArrayModel>?
      prices,
    }) => PricingGet200BodyPricingPrimaryIpsArrayModel(
      $type: $type ?? this.$type,
      prices: prices ?? this.prices,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is PricingGet200BodyPricingPrimaryIpsArrayModel &&
        other.$type == this.$type &&
        _$deepEquals.equals(other.prices, this.prices);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([this.$type, deepEquals.hash(this.prices)]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for PricingGet200BodyPricingPrimaryIpsArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PricingGet200BodyPricingPrimaryIpsArrayModel: complex types cannot be URI-encoded',
    );
  }
}
