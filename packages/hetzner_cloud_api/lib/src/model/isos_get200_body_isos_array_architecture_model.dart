// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i3;
import 'dart:core' as _i2;

import 'package:tonik_util/tonik_util.dart' as _i1;

typedef IsosGet200BodyIsosArrayArchitectureModel =
    $RawIsosGet200BodyIsosArrayArchitectureModel?;

/// CPU architecture compatible with the ISO.
///
/// Null indicates no restriction on the architecture (wildcard).
///
///
/// **Example**:
/// ```
/// x86
/// ```
enum $RawIsosGet200BodyIsosArrayArchitectureModel
    implements
        _i1.MatrixEncodable,
        _i1.LabelEncodable,
        _i1.SimpleEncodable,
        _i1.FormEncodable,
        _i1.JsonEncodable,
        _i1.UriEncodable {
  x86(r'x86'),
  arm(r'arm'),
  unknown(r'unknown');

  const $RawIsosGet200BodyIsosArrayArchitectureModel(this._$rawValue);

  factory $RawIsosGet200BodyIsosArrayArchitectureModel.fromJson(
    _i2.dynamic value,
  ) {
    if (value is! _i2.String) {
      throw _i1.JsonDecodingException(
        r'Expected String for IsosGet200BodyIsosArrayArchitectureModel, got '
        '${value.runtimeType}',
      );
    }
    return values.firstWhere(
      (e) => e._$rawValue == value,
      orElse: () => $RawIsosGet200BodyIsosArrayArchitectureModel.unknown,
    );
  }

  factory $RawIsosGet200BodyIsosArrayArchitectureModel.fromSimple(
    _i2.String? value, {
    required _i2.bool explode,
    _i2.String? context,
  }) {
    return $RawIsosGet200BodyIsosArrayArchitectureModel.fromJson(
      value.decodeSimpleString(context: context),
    );
  }

  factory $RawIsosGet200BodyIsosArrayArchitectureModel.fromForm(
    _i2.String? value, {
    required _i2.bool explode,
    _i2.String? context,
  }) {
    return $RawIsosGet200BodyIsosArrayArchitectureModel.fromJson(
      value.decodeFormString(context: context),
    );
  }

  final _i2.String _$rawValue;

  @_i2.override
  _i2.String toJson() {
    if (this == $RawIsosGet200BodyIsosArrayArchitectureModel.unknown) {
      throw _i1.EncodingException(r'Cannot encode unknown enum value');
    }
    return this._$rawValue;
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.simple;

  @_i2.override
  _i2.String toSimple({
    required _i2.bool explode,
    required _i2.bool allowEmpty,
    _i2.bool literal = false,
  }) {
    if (this == $RawIsosGet200BodyIsosArrayArchitectureModel.unknown) {
      throw _i1.EncodingException(r'Cannot encode unknown enum value');
    }
    return this._$rawValue.toSimple(
      explode: explode,
      allowEmpty: allowEmpty,
      literal: literal,
    );
  }

  @_i2.override
  _i2.List<_i1.ParameterEntry> toForm(
    _i2.String paramName, {
    required _i2.bool explode,
    required _i2.bool allowEmpty,
    required _i3.Encoding textEncoding,
    _i2.bool useQueryComponent = false,
    _i2.bool allowReserved = false,
    _i2.Map<_i2.String, _i1.FormFieldEncoding> fieldEncodings = const {},
  }) {
    if (this == $RawIsosGet200BodyIsosArrayArchitectureModel.unknown) {
      throw _i1.EncodingException(r'Cannot encode unknown enum value');
    }
    return this._$rawValue.toForm(
      paramName,
      explode: explode,
      allowEmpty: allowEmpty,
      useQueryComponent: useQueryComponent,
      allowReserved: allowReserved,
      textEncoding: textEncoding,
    );
  }

  @_i2.override
  _i2.String toLabel({
    required _i2.bool explode,
    required _i2.bool allowEmpty,
  }) {
    if (this == $RawIsosGet200BodyIsosArrayArchitectureModel.unknown) {
      throw _i1.EncodingException(r'Cannot encode unknown enum value');
    }
    return this._$rawValue.toLabel(explode: explode, allowEmpty: allowEmpty);
  }

  @_i2.override
  _i2.String uriEncode({
    required _i2.bool allowEmpty,
    required _i3.Encoding textEncoding,
    _i2.bool useQueryComponent = false,
    _i2.bool allowReserved = false,
  }) {
    if (this == $RawIsosGet200BodyIsosArrayArchitectureModel.unknown) {
      throw _i1.EncodingException(r'Cannot encode unknown enum value');
    }
    return this._$rawValue.uriEncode(
      allowEmpty: allowEmpty,
      textEncoding: textEncoding,
      useQueryComponent: useQueryComponent,
      allowReserved: allowReserved,
    );
  }

  @_i2.override
  _i2.String toMatrix(
    _i2.String paramName, {
    required _i2.bool explode,
    required _i2.bool allowEmpty,
  }) {
    if (this == $RawIsosGet200BodyIsosArrayArchitectureModel.unknown) {
      throw _i1.EncodingException(r'Cannot encode unknown enum value');
    }
    return this._$rawValue.toMatrix(
      paramName,
      explode: explode,
      allowEmpty: allowEmpty,
    );
  }
}
