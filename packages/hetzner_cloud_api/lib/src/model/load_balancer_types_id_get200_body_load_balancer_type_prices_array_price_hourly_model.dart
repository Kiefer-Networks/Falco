// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:big_decimal/big_decimal.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Hourly price in this [Location](#tag/locations).
@_i2.immutable
class LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel({
    required this.net,
    required this.gross,
  });

  factory LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'net', r'gross'},
      listKeys: {},
      context: r'LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel(
      net: _$values[r'net'].decodeSimpleBigDecimal(
        context: r'LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel.net',
      ),
      gross: _$values[r'gross'].decodeSimpleBigDecimal(
        context: r'LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel.gross',
      ),
    );
  }

  factory LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel',
    );
    return LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel(
      net: _$map[r'net'].decodeJsonBigDecimal(
        context: r'LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel.net',
      ),
      gross: _$map[r'gross'].decodeJsonBigDecimal(
        context: r'LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel.gross',
      ),
    );
  }

  factory LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'net', r'gross'},
      listKeys: {},
      context: r'LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel',
    );
    return LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel(
      net: _$values[r'net'].decodeFormBigDecimal(
        context: r'LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel.net',
      ),
      gross: _$values[r'gross'].decodeFormBigDecimal(
        context: r'LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel.gross',
      ),
    );
  }

  /// Price without VAT.
  ///
  /// **Example**:
  /// ```
  /// 1.0000
  /// ```
  final _i4.BigDecimal net;

  /// Price with VAT added.
  ///
  /// **Example**:
  /// ```
  /// 1.1900
  /// ```
  final _i4.BigDecimal gross;

  @_i3.override
  _i3.Object? toJson() => {
    r'net': this.net.toPlainString(),
    r'gross': this.gross.toPlainString(),
  };

  LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel
  Function({_i4.BigDecimal? net, _i4.BigDecimal? gross})
  get copyWith {
    return ({_i4.BigDecimal? net, _i4.BigDecimal? gross}) =>
        LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel(
          net: net ?? this.net,
          gross: gross ?? this.gross,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel &&
        other.net == this.net &&
        other.gross == this.gross;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.net, this.gross]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'net'] = _i1.PropertyValue.scalar(this.net.toPlainString());
    _$result[r'gross'] = _i1.PropertyValue.scalar(this.gross.toPlainString());
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancerTypesIdGet200BodyLoadBalancerTypePricesArrayPriceHourlyModel: complex types cannot be URI-encoded',
    );
  }
}
