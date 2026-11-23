// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// If issuance or renewal reports `failed`, this property contains information about what happened.
@_i2.immutable
class $RawCertificatesGet200BodyCertificatesArrayStatusErrorModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const $RawCertificatesGet200BodyCertificatesArrayStatusErrorModel({
    this.code,
    this.message,
  });

  factory $RawCertificatesGet200BodyCertificatesArrayStatusErrorModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'code', r'message'},
      listKeys: {},
      context: r'$RawCertificatesGet200BodyCertificatesArrayStatusErrorModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return $RawCertificatesGet200BodyCertificatesArrayStatusErrorModel(
      code: _$values[r'code'].decodeSimpleNullableString(
        context:
            r'$RawCertificatesGet200BodyCertificatesArrayStatusErrorModel.code',
      ),
      message: _$values[r'message'].decodeSimpleNullableString(
        context: r'$RawCertificatesGet200BodyCertificatesArrayStatusErrorModel.message',
      ),
    );
  }

  factory $RawCertificatesGet200BodyCertificatesArrayStatusErrorModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'$RawCertificatesGet200BodyCertificatesArrayStatusErrorModel',
    );
    return $RawCertificatesGet200BodyCertificatesArrayStatusErrorModel(
      code: _$map[r'code'].decodeJsonNullableString(
        context:
            r'$RawCertificatesGet200BodyCertificatesArrayStatusErrorModel.code',
      ),
      message: _$map[r'message'].decodeJsonNullableString(
        context: r'$RawCertificatesGet200BodyCertificatesArrayStatusErrorModel.message',
      ),
    );
  }

  factory $RawCertificatesGet200BodyCertificatesArrayStatusErrorModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'code', r'message'},
      listKeys: {},
      context: r'$RawCertificatesGet200BodyCertificatesArrayStatusErrorModel',
    );
    return $RawCertificatesGet200BodyCertificatesArrayStatusErrorModel(
      code: _$values[r'code'].decodeFormNullableString(
        context:
            r'$RawCertificatesGet200BodyCertificatesArrayStatusErrorModel.code',
      ),
      message: _$values[r'message'].decodeFormNullableString(
        context: r'$RawCertificatesGet200BodyCertificatesArrayStatusErrorModel.message',
      ),
    );
  }

  final _i3.String? code;

  final _i3.String? message;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.code != null) r'code': this.code,
    if (this.message != null) r'message': this.message,
  };

  $RawCertificatesGet200BodyCertificatesArrayStatusErrorModel Function({
    _i3.String? code,
    _i3.String? message,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({_i3.Object? code = _sentinel, _i3.Object? message = _sentinel}) =>
        $RawCertificatesGet200BodyCertificatesArrayStatusErrorModel(
          code: _i3.identical(code, _sentinel)
              ? this.code
              : (code as _i3.String?),
          message: _i3.identical(message, _sentinel)
              ? this.message
              : (message as _i3.String?),
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is $RawCertificatesGet200BodyCertificatesArrayStatusErrorModel &&
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
    if (this.code != null) {
      _$result[r'code'] = _i1.PropertyValue.scalar(this.code!);
    }
    if (this.message != null) {
      _$result[r'message'] = _i1.PropertyValue.scalar(this.message!);
    }
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
      r'Cannot uriEncode $RawCertificatesGet200BodyCertificatesArrayStatusErrorModel: complex types cannot be URI-encoded',
    );
  }
}

typedef CertificatesGet200BodyCertificatesArrayStatusErrorModel =
    $RawCertificatesGet200BodyCertificatesArrayStatusErrorModel?;
