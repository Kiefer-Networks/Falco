// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancer_types_get200_body_load_balancer_types_array_prices_array_price_hourly_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancer_types_get200_body_load_balancer_types_array_prices_array_price_monthly_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/load_balancer_types_get200_body_load_balancer_types_array_prices_array_price_per_tb_traffic_model.dart'
    as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayModel({
    required this.location,
    required this.priceHourly,
    required this.priceMonthly,
    required this.includedTraffic,
    required this.pricePerTbTraffic,
  });

  factory LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayModel: contains complex types',
    );
  }

  factory LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context:
          r'LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayModel',
    );
    return LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayModel(
      location: _$map[r'location'].decodeJsonString(
        context: r'LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayModel.location',
      ),
      priceHourly:
          _i4.LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayPriceHourlyModel.fromJson(
            _$map[r'price_hourly'],
          ),
      priceMonthly:
          _i5.LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayPriceMonthlyModel.fromJson(
            _$map[r'price_monthly'],
          ),
      includedTraffic: _$map[r'included_traffic'].decodeJsonInt(
        context: r'LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayModel.included_traffic',
      ),
      pricePerTbTraffic:
          _i6.LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayPricePerTbTrafficModel.fromJson(
            _$map[r'price_per_tb_traffic'],
          ),
    );
  }

  factory LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayModel: contains complex types',
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
  final _i4.LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayPriceHourlyModel
  priceHourly;

  /// Monthly price in this [Location](#tag/locations).
  final _i5.LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayPriceMonthlyModel
  priceMonthly;

  /// Free traffic per month in bytes in this [Location](#tag/locations).
  ///
  /// **Example**:
  /// ```json
  /// 654321
  /// ```
  final _i3.int includedTraffic;

  /// Additional traffic price per TB in this [Location](#tag/locations).
  final _i6.LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayPricePerTbTrafficModel
  pricePerTbTraffic;

  @_i3.override
  _i3.Object? toJson() => {
    r'location': this.location,
    r'price_hourly': this.priceHourly.toJson(),
    r'price_monthly': this.priceMonthly.toJson(),
    r'included_traffic': this.includedTraffic,
    r'price_per_tb_traffic': this.pricePerTbTraffic.toJson(),
  };

  LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayModel Function({
    _i3.String? location,
    _i4.LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayPriceHourlyModel?
    priceHourly,
    _i5.LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayPriceMonthlyModel?
    priceMonthly,
    _i3.int? includedTraffic,
    _i6.LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayPricePerTbTrafficModel?
    pricePerTbTraffic,
  })
  get copyWith {
    return ({
      _i3.String? location,
      _i4.LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayPriceHourlyModel?
      priceHourly,
      _i5.LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayPriceMonthlyModel?
      priceMonthly,
      _i3.int? includedTraffic,
      _i6.LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayPricePerTbTrafficModel?
      pricePerTbTraffic,
    }) => LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayModel(
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
    return other
            is LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayModel &&
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
    r'parameterProperties not supported for LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancerTypesGet200BodyLoadBalancerTypesArrayPricesArrayModel: complex types cannot be URI-encoded',
    );
  }
}
