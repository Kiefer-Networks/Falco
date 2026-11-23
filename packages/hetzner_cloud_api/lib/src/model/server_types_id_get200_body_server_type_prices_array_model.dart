// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/server_types_id_get200_body_server_type_prices_array_price_hourly_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/server_types_id_get200_body_server_type_prices_array_price_monthly_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/server_types_id_get200_body_server_type_prices_array_price_per_tb_traffic_model.dart'
    as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServerTypesIdGet200BodyServerTypePricesArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServerTypesIdGet200BodyServerTypePricesArrayModel({
    required this.location,
    required this.priceHourly,
    required this.priceMonthly,
    required this.includedTraffic,
    required this.pricePerTbTraffic,
  });

  factory ServerTypesIdGet200BodyServerTypePricesArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServerTypesIdGet200BodyServerTypePricesArrayModel: contains complex types',
    );
  }

  factory ServerTypesIdGet200BodyServerTypePricesArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ServerTypesIdGet200BodyServerTypePricesArrayModel',
    );
    return ServerTypesIdGet200BodyServerTypePricesArrayModel(
      location: _$map[r'location'].decodeJsonString(
        context: r'ServerTypesIdGet200BodyServerTypePricesArrayModel.location',
      ),
      priceHourly:
          _i4.ServerTypesIdGet200BodyServerTypePricesArrayPriceHourlyModel.fromJson(
            _$map[r'price_hourly'],
          ),
      priceMonthly:
          _i5.ServerTypesIdGet200BodyServerTypePricesArrayPriceMonthlyModel.fromJson(
            _$map[r'price_monthly'],
          ),
      includedTraffic: _$map[r'included_traffic'].decodeJsonInt(
        context: r'ServerTypesIdGet200BodyServerTypePricesArrayModel.included_traffic',
      ),
      pricePerTbTraffic:
          _i6.ServerTypesIdGet200BodyServerTypePricesArrayPricePerTbTrafficModel.fromJson(
            _$map[r'price_per_tb_traffic'],
          ),
    );
  }

  factory ServerTypesIdGet200BodyServerTypePricesArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServerTypesIdGet200BodyServerTypePricesArrayModel: contains complex types',
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
  final _i4.ServerTypesIdGet200BodyServerTypePricesArrayPriceHourlyModel
  priceHourly;

  /// Monthly price in this [Location](#tag/locations).
  final _i5.ServerTypesIdGet200BodyServerTypePricesArrayPriceMonthlyModel
  priceMonthly;

  /// Free traffic per month in bytes in this [Location](#tag/locations).
  ///
  /// **Example**:
  /// ```json
  /// 654321
  /// ```
  final _i3.int includedTraffic;

  /// Additional traffic price per TB in this [Location](#tag/locations).
  final _i6.ServerTypesIdGet200BodyServerTypePricesArrayPricePerTbTrafficModel
  pricePerTbTraffic;

  @_i3.override
  _i3.Object? toJson() => {
    r'location': this.location,
    r'price_hourly': this.priceHourly.toJson(),
    r'price_monthly': this.priceMonthly.toJson(),
    r'included_traffic': this.includedTraffic,
    r'price_per_tb_traffic': this.pricePerTbTraffic.toJson(),
  };

  ServerTypesIdGet200BodyServerTypePricesArrayModel Function({
    _i3.String? location,
    _i4.ServerTypesIdGet200BodyServerTypePricesArrayPriceHourlyModel?
    priceHourly,
    _i5.ServerTypesIdGet200BodyServerTypePricesArrayPriceMonthlyModel?
    priceMonthly,
    _i3.int? includedTraffic,
    _i6.ServerTypesIdGet200BodyServerTypePricesArrayPricePerTbTrafficModel?
    pricePerTbTraffic,
  })
  get copyWith {
    return ({
      _i3.String? location,
      _i4.ServerTypesIdGet200BodyServerTypePricesArrayPriceHourlyModel?
      priceHourly,
      _i5.ServerTypesIdGet200BodyServerTypePricesArrayPriceMonthlyModel?
      priceMonthly,
      _i3.int? includedTraffic,
      _i6.ServerTypesIdGet200BodyServerTypePricesArrayPricePerTbTrafficModel?
      pricePerTbTraffic,
    }) => ServerTypesIdGet200BodyServerTypePricesArrayModel(
      location: location ?? this.location,
      priceHourly: priceHourly ?? this.priceHourly,
      priceMonthly: priceMonthly ?? this.priceMonthly,
      includedTraffic: includedTraffic ?? this.includedTraffic,
      pricePerTbTraffic: pricePerTbTraffic ?? this.pricePerTbTraffic,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServerTypesIdGet200BodyServerTypePricesArrayModel &&
        other.location == this.location &&
        other.priceHourly == this.priceHourly &&
        other.priceMonthly == this.priceMonthly &&
        other.includedTraffic == this.includedTraffic &&
        other.pricePerTbTraffic == this.pricePerTbTraffic;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.location,
      this.priceHourly,
      this.priceMonthly,
      this.includedTraffic,
      this.pricePerTbTraffic,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServerTypesIdGet200BodyServerTypePricesArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServerTypesIdGet200BodyServerTypePricesArrayModel: complex types cannot be URI-encoded',
    );
  }
}
