// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PrimaryIpsIdActionsAssignPost4xxBodyErrorModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PrimaryIpsIdActionsAssignPost4xxBodyErrorModel({
    required this.code,
    required this.message,
    this.details,
  });

  factory PrimaryIpsIdActionsAssignPost4xxBodyErrorModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for PrimaryIpsIdActionsAssignPost4xxBodyErrorModel: contains complex types',
    );
  }

  factory PrimaryIpsIdActionsAssignPost4xxBodyErrorModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'PrimaryIpsIdActionsAssignPost4xxBodyErrorModel',
    );
    return PrimaryIpsIdActionsAssignPost4xxBodyErrorModel(
      code: _$map[r'code'].decodeJsonString(
        context: r'PrimaryIpsIdActionsAssignPost4xxBodyErrorModel.code',
      ),
      message: _$map[r'message'].decodeJsonString(
        context: r'PrimaryIpsIdActionsAssignPost4xxBodyErrorModel.message',
      ),
      details: _$map[r'details'].decodeJsonNullableMap(
        (v) => v,
        context: r'PrimaryIpsIdActionsAssignPost4xxBodyErrorModel.details',
      ),
    );
  }

  factory PrimaryIpsIdActionsAssignPost4xxBodyErrorModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for PrimaryIpsIdActionsAssignPost4xxBodyErrorModel: contains complex types',
    );
  }

  /// Error code for machines.
  final _i3.String code;

  /// Error message for humans.
  final _i3.String message;

  /// Details about the error.
  final _i3.Map<_i3.String, _i3.Object?>? details;

  @_i3.override
  _i3.Object? toJson() => {
    r'code': this.code,
    r'message': this.message,
    r'details': this.details?.map(
      (k, v) => _i3.MapEntry(
        k,
        _i1.encodeUnknownJson(
          v,
          context: r'PrimaryIpsIdActionsAssignPost4xxBodyErrorModel.details',
        ),
      ),
    ),
  };

  PrimaryIpsIdActionsAssignPost4xxBodyErrorModel Function({
    _i3.String? code,
    _i3.String? message,
    _i3.Map<_i3.String, _i3.Object?>? details,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.String? code,
      _i3.String? message,
      _i3.Object? details = _sentinel,
    }) => PrimaryIpsIdActionsAssignPost4xxBodyErrorModel(
      code: code ?? this.code,
      message: message ?? this.message,
      details: _i3.identical(details, _sentinel)
          ? this.details
          : (details as _i3.Map<_i3.String, _i3.Object?>?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is PrimaryIpsIdActionsAssignPost4xxBodyErrorModel &&
        other.code == this.code &&
        other.message == this.message &&
        _$deepEquals.equals(other.details, this.details);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.code,
      this.message,
      deepEquals.hash(this.details),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for PrimaryIpsIdActionsAssignPost4xxBodyErrorModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PrimaryIpsIdActionsAssignPost4xxBodyErrorModel: complex types cannot be URI-encoded',
    );
  }
}
