// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:big_decimal/big_decimal.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Price of [Server](#tag/servers) backups.
@_i2.immutable
class PricingGet200BodyPricingServerBackupModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PricingGet200BodyPricingServerBackupModel({required this.percentage});

  factory PricingGet200BodyPricingServerBackupModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'percentage'},
      listKeys: {},
      context: r'PricingGet200BodyPricingServerBackupModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return PricingGet200BodyPricingServerBackupModel(
      percentage: _$values[r'percentage'].decodeSimpleBigDecimal(
        context: r'PricingGet200BodyPricingServerBackupModel.percentage',
      ),
    );
  }

  factory PricingGet200BodyPricingServerBackupModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'PricingGet200BodyPricingServerBackupModel',
    );
    return PricingGet200BodyPricingServerBackupModel(
      percentage: _$map[r'percentage'].decodeJsonBigDecimal(
        context: r'PricingGet200BodyPricingServerBackupModel.percentage',
      ),
    );
  }

  factory PricingGet200BodyPricingServerBackupModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'percentage'},
      listKeys: {},
      context: r'PricingGet200BodyPricingServerBackupModel',
    );
    return PricingGet200BodyPricingServerBackupModel(
      percentage: _$values[r'percentage'].decodeFormBigDecimal(
        context: r'PricingGet200BodyPricingServerBackupModel.percentage',
      ),
    );
  }

  /// Price increase of the [Server](#tag/servers) base price in percentage.
  ///
  /// **Example**:
  /// ```
  /// 20.00
  /// ```
  final _i4.BigDecimal percentage;

  @_i3.override
  _i3.Object? toJson() => {r'percentage': this.percentage.toPlainString()};

  PricingGet200BodyPricingServerBackupModel Function({
    _i4.BigDecimal? percentage,
  })
  get copyWith {
    return ({_i4.BigDecimal? percentage}) =>
        PricingGet200BodyPricingServerBackupModel(
          percentage: percentage ?? this.percentage,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is PricingGet200BodyPricingServerBackupModel &&
        other.percentage == this.percentage;
  }

  @_i3.override
  _i3.int get hashCode => this.percentage.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'percentage'] = _i1.PropertyValue.scalar(
      this.percentage.toPlainString(),
    );
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
      r'Cannot uriEncode PricingGet200BodyPricingServerBackupModel: complex types cannot be URI-encoded',
    );
  }
}
