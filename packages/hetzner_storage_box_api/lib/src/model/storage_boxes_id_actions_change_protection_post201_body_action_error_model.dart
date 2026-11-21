// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Error message for the Action if an error occurred, otherwise null.
@_i2.immutable
class $RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const $RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel({
    required this.code,
    required this.message,
  });

  factory $RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'code', r'message'},
      listKeys: {},
      context: r'$RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return $RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel(
      code: _$values[r'code'].decodeSimpleString(
        context: r'$RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel.code',
      ),
      message: _$values[r'message'].decodeSimpleString(
        context: r'$RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel.message',
      ),
    );
  }

  factory $RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'$RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel',
    );
    return $RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel(
      code: _$map[r'code'].decodeJsonString(
        context: r'$RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel.code',
      ),
      message: _$map[r'message'].decodeJsonString(
        context: r'$RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel.message',
      ),
    );
  }

  factory $RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'code', r'message'},
      listKeys: {},
      context: r'$RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel',
    );
    return $RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel(
      code: _$values[r'code'].decodeFormString(
        context: r'$RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel.code',
      ),
      message: _$values[r'message'].decodeFormString(
        context: r'$RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel.message',
      ),
    );
  }

  /// Fixed error code for machines.
  ///
  /// **Example**:
  /// ```
  /// action_failed
  /// ```
  final _i3.String code;

  /// Error message for humans.
  ///
  /// **Example**:
  /// ```
  /// Action failed
  /// ```
  final _i3.String message;

  @_i3.override
  _i3.Object? toJson() => {r'code': this.code, r'message': this.message};

  $RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel
  Function({_i3.String? code, _i3.String? message})
  get copyWith {
    return ({_i3.String? code, _i3.String? message}) =>
        $RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel(
          code: code ?? this.code,
          message: message ?? this.message,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is $RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel &&
        other.code == this.code &&
        other.message == this.message;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.code, this.message]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'code'] = _i1.PropertyValue.scalar(this.code);
    _$result[r'message'] = _i1.PropertyValue.scalar(this.message);
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode $RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel: complex types cannot be URI-encoded',
    );
  }
}

typedef StorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel =
    $RawStorageBoxesIdActionsChangeProtectionPost201BodyActionErrorModel?;
