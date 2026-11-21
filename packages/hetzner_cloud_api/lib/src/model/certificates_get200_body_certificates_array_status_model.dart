// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/certificates_get200_body_certificates_array_status_error_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/certificates_get200_body_certificates_array_status_issuance_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/certificates_get200_body_certificates_array_status_renewal_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Current status of a type `managed` Certificate, always *null* for type `uploaded` Certificates.
@_i2.immutable
class $RawCertificatesGet200BodyCertificatesArrayStatusModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const $RawCertificatesGet200BodyCertificatesArrayStatusModel({
    this.issuance,
    this.renewal,
    this.error,
  });

  factory $RawCertificatesGet200BodyCertificatesArrayStatusModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for $RawCertificatesGet200BodyCertificatesArrayStatusModel: contains complex types',
    );
  }

  factory $RawCertificatesGet200BodyCertificatesArrayStatusModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'$RawCertificatesGet200BodyCertificatesArrayStatusModel',
    );
    return $RawCertificatesGet200BodyCertificatesArrayStatusModel(
      issuance: _$map[r'issuance'] == null
          ? null
          : _i4.CertificatesGet200BodyCertificatesArrayStatusIssuanceModel.fromJson(
              _$map[r'issuance'],
            ),
      renewal: _$map[r'renewal'] == null
          ? null
          : _i5.CertificatesGet200BodyCertificatesArrayStatusRenewalModel.fromJson(
              _$map[r'renewal'],
            ),
      error: _$map[r'error'] == null
          ? null
          : _i6.CertificatesGet200BodyCertificatesArrayStatusErrorModel.fromJson(
              _$map[r'error'],
            ),
    );
  }

  factory $RawCertificatesGet200BodyCertificatesArrayStatusModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for $RawCertificatesGet200BodyCertificatesArrayStatusModel: contains complex types',
    );
  }

  /// Status of the issuance process of the Certificate.
  ///
  /// **Example**:
  /// ```
  /// completed
  /// ```
  final _i4.CertificatesGet200BodyCertificatesArrayStatusIssuanceModel?
  issuance;

  /// Status of the renewal process of the Certificate.
  ///
  /// **Example**:
  /// ```
  /// scheduled
  /// ```
  final _i5.CertificatesGet200BodyCertificatesArrayStatusRenewalModel? renewal;

  /// If issuance or renewal reports `failed`, this property contains information about what happened.
  final _i6.CertificatesGet200BodyCertificatesArrayStatusErrorModel? error;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.issuance != null) r'issuance': this.issuance?.toJson(),
    if (this.renewal != null) r'renewal': this.renewal?.toJson(),
    r'error': this.error?.toJson(),
  };

  $RawCertificatesGet200BodyCertificatesArrayStatusModel Function({
    _i4.CertificatesGet200BodyCertificatesArrayStatusIssuanceModel? issuance,
    _i5.CertificatesGet200BodyCertificatesArrayStatusRenewalModel? renewal,
    _i6.CertificatesGet200BodyCertificatesArrayStatusErrorModel? error,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? issuance = _sentinel,
      _i3.Object? renewal = _sentinel,
      _i3.Object? error = _sentinel,
    }) => $RawCertificatesGet200BodyCertificatesArrayStatusModel(
      issuance: _i3.identical(issuance, _sentinel)
          ? this.issuance
          : (issuance
                as _i4.CertificatesGet200BodyCertificatesArrayStatusIssuanceModel?),
      renewal: _i3.identical(renewal, _sentinel)
          ? this.renewal
          : (renewal
                as _i5.CertificatesGet200BodyCertificatesArrayStatusRenewalModel?),
      error: _i3.identical(error, _sentinel)
          ? this.error
          : (error
                as _i6.CertificatesGet200BodyCertificatesArrayStatusErrorModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is $RawCertificatesGet200BodyCertificatesArrayStatusModel &&
        other.issuance == this.issuance &&
        other.renewal == this.renewal &&
        other.error == this.error;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.issuance, this.renewal, this.error]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for CertificatesGet200BodyCertificatesArrayStatusModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode $RawCertificatesGet200BodyCertificatesArrayStatusModel: complex types cannot be URI-encoded',
    );
  }
}

typedef CertificatesGet200BodyCertificatesArrayStatusModel =
    $RawCertificatesGet200BodyCertificatesArrayStatusModel?;
