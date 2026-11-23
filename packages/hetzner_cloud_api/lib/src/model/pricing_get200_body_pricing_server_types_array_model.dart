// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/pricing_get200_body_pricing_server_types_array_prices_array_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PricingGet200BodyPricingServerTypesArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PricingGet200BodyPricingServerTypesArrayModel({
    required this.id,
    required this.name,
    required this.prices,
  });

  factory PricingGet200BodyPricingServerTypesArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for PricingGet200BodyPricingServerTypesArrayModel: contains complex types',
    );
  }

  factory PricingGet200BodyPricingServerTypesArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'PricingGet200BodyPricingServerTypesArrayModel',
    );
    return PricingGet200BodyPricingServerTypesArrayModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'PricingGet200BodyPricingServerTypesArrayModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'PricingGet200BodyPricingServerTypesArrayModel.name',
      ),
      prices: _$map[r'prices']
          .decodeJsonList<_i3.Object?>(
            context: r'PricingGet200BodyPricingServerTypesArrayModel.prices',
          )
          .map(
            _i4
                .PricingGet200BodyPricingServerTypesArrayPricesArrayModel
                .fromJson,
          )
          .toList(),
    );
  }

  factory PricingGet200BodyPricingServerTypesArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for PricingGet200BodyPricingServerTypesArrayModel: contains complex types',
    );
  }

  /// ID of the [Server Types](#tag/server-types) the price is for.
  ///
  /// **Example**:
  /// ```json
  /// 104
  /// ```
  final _i3.int id;

  /// Name of the [Server Types](#tag/server-types) the price is for.
  ///
  /// **Example**:
  /// ```
  /// cpx22
  /// ```
  final _i3.String name;

  /// Price of the [Server Types](#tag/server-types) per [Location](#tag/locations).
  final _i3.List<_i4.PricingGet200BodyPricingServerTypesArrayPricesArrayModel>
  prices;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'prices': this.prices.map((e) => e.toJson()).toList(),
  };

  PricingGet200BodyPricingServerTypesArrayModel Function({
    _i3.int? id,
    _i3.String? name,
    _i3.List<_i4.PricingGet200BodyPricingServerTypesArrayPricesArrayModel>?
    prices,
  })
  get copyWith {
    return ({
      _i3.int? id,
      _i3.String? name,
      _i3.List<_i4.PricingGet200BodyPricingServerTypesArrayPricesArrayModel>?
      prices,
    }) => PricingGet200BodyPricingServerTypesArrayModel(
      id: id ?? this.id,
      name: name ?? this.name,
      prices: prices ?? this.prices,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is PricingGet200BodyPricingServerTypesArrayModel &&
        other.id == this.id &&
        other.name == this.name &&
        _$deepEquals.equals(other.prices, this.prices);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.name,
      deepEquals.hash(this.prices),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for PricingGet200BodyPricingServerTypesArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PricingGet200BodyPricingServerTypesArrayModel: complex types cannot be URI-encoded',
    );
  }
}
