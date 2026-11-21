// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// If issuance or renewal reports `failed`, this property contains information about what happened.
@_i2.immutable
class $RawCertificatesIdPut200BodyCertificateStatusErrorModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const $RawCertificatesIdPut200BodyCertificateStatusErrorModel({
    this.code,
    this.message,
  });

  factory $RawCertificatesIdPut200BodyCertificateStatusErrorModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'code', r'message'},
      listKeys: {},
      context: r'$RawCertificatesIdPut200BodyCertificateStatusErrorModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return $RawCertificatesIdPut200BodyCertificateStatusErrorModel(
      code: _$values[r'code'].decodeSimpleNullableString(
        context:
            r'$RawCertificatesIdPut200BodyCertificateStatusErrorModel.code',
      ),
      message: _$values[r'message'].decodeSimpleNullableString(
        context:
            r'$RawCertificatesIdPut200BodyCertificateStatusErrorModel.message',
      ),
    );
  }

  factory $RawCertificatesIdPut200BodyCertificateStatusErrorModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'$RawCertificatesIdPut200BodyCertificateStatusErrorModel',
    );
    return $RawCertificatesIdPut200BodyCertificateStatusErrorModel(
      code: _$map[r'code'].decodeJsonNullableString(
        context:
            r'$RawCertificatesIdPut200BodyCertificateStatusErrorModel.code',
      ),
      message: _$map[r'message'].decodeJsonNullableString(
        context:
            r'$RawCertificatesIdPut200BodyCertificateStatusErrorModel.message',
      ),
    );
  }

  factory $RawCertificatesIdPut200BodyCertificateStatusErrorModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'code', r'message'},
      listKeys: {},
      context: r'$RawCertificatesIdPut200BodyCertificateStatusErrorModel',
    );
    return $RawCertificatesIdPut200BodyCertificateStatusErrorModel(
      code: _$values[r'code'].decodeFormNullableString(
        context:
            r'$RawCertificatesIdPut200BodyCertificateStatusErrorModel.code',
      ),
      message: _$values[r'message'].decodeFormNullableString(
        context:
            r'$RawCertificatesIdPut200BodyCertificateStatusErrorModel.message',
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

  $RawCertificatesIdPut200BodyCertificateStatusErrorModel Function({
    _i3.String? code,
    _i3.String? message,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({_i3.Object? code = _sentinel, _i3.Object? message = _sentinel}) =>
        $RawCertificatesIdPut200BodyCertificateStatusErrorModel(
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
    return other is $RawCertificatesIdPut200BodyCertificateStatusErrorModel &&
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
      r'Cannot uriEncode $RawCertificatesIdPut200BodyCertificateStatusErrorModel: complex types cannot be URI-encoded',
    );
  }
}

typedef CertificatesIdPut200BodyCertificateStatusErrorModel =
    $RawCertificatesIdPut200BodyCertificateStatusErrorModel?;
