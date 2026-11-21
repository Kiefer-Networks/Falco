// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:big_decimal/big_decimal.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Hourly price in this [Location](#tag/locations).
@_i2.immutable
class StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel({
    required this.net,
    required this.gross,
  });

  factory StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'net', r'gross'},
      listKeys: {},
      context: r'StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel(
      net: _$values[r'net'].decodeSimpleBigDecimal(
        context: r'StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel.net',
      ),
      gross: _$values[r'gross'].decodeSimpleBigDecimal(
        context: r'StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel.gross',
      ),
    );
  }

  factory StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel',
    );
    return StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel(
      net: _$map[r'net'].decodeJsonBigDecimal(
        context: r'StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel.net',
      ),
      gross: _$map[r'gross'].decodeJsonBigDecimal(
        context: r'StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel.gross',
      ),
    );
  }

  factory StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'net', r'gross'},
      listKeys: {},
      context: r'StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel',
    );
    return StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel(
      net: _$values[r'net'].decodeFormBigDecimal(
        context: r'StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel.net',
      ),
      gross: _$values[r'gross'].decodeFormBigDecimal(
        context: r'StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel.gross',
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

  StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel
  Function({_i4.BigDecimal? net, _i4.BigDecimal? gross})
  get copyWith {
    return ({_i4.BigDecimal? net, _i4.BigDecimal? gross}) =>
        StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel(
          net: net ?? this.net,
          gross: gross ?? this.gross,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel &&
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
      r'Cannot uriEncode StorageBoxesIdGet200BodyStorageBoxStorageBoxTypePricesArrayPriceHourlyModel: complex types cannot be URI-encoded',
    );
  }
}
