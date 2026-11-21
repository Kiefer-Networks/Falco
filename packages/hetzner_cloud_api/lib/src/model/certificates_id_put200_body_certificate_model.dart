// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i8;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i7;
import 'package:hetzner_cloud_api/src/model/certificates_id_put200_body_certificate_status_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/certificates_id_put200_body_certificate_type_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/certificates_id_put200_body_certificate_used_by_array_model.dart'
    as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CertificatesIdPut200BodyCertificateModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CertificatesIdPut200BodyCertificateModel({
    required this.id,
    required this.name,
    required this.labels,
    required this.certificate,
    required this.created,
    required this.notValidBefore,
    required this.notValidAfter,
    required this.domainNames,
    required this.fingerprint,
    required this.usedBy,
    this.$type,
    this.status,
  });

  factory CertificatesIdPut200BodyCertificateModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for CertificatesIdPut200BodyCertificateModel: contains complex types',
    );
  }

  factory CertificatesIdPut200BodyCertificateModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'CertificatesIdPut200BodyCertificateModel',
    );
    return CertificatesIdPut200BodyCertificateModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'CertificatesIdPut200BodyCertificateModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'CertificatesIdPut200BodyCertificateModel.name',
      ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context: r'CertificatesIdPut200BodyCertificateModel.labels',
        ),
        context: r'CertificatesIdPut200BodyCertificateModel.labels',
      ),
      $type: _$map[r'type'] == null
          ? null
          : _i4.CertificatesIdPut200BodyCertificateTypeModel.fromJson(
              _$map[r'type'],
            ),
      certificate: _$map[r'certificate'].decodeJsonNullableString(
        context: r'CertificatesIdPut200BodyCertificateModel.certificate',
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'CertificatesIdPut200BodyCertificateModel.created',
      ),
      notValidBefore: _$map[r'not_valid_before'].decodeJsonNullableDateTime(
        context: r'CertificatesIdPut200BodyCertificateModel.not_valid_before',
      ),
      notValidAfter: _$map[r'not_valid_after'].decodeJsonNullableDateTime(
        context: r'CertificatesIdPut200BodyCertificateModel.not_valid_after',
      ),
      domainNames: _$map[r'domain_names'].decodeJsonList<_i3.String>(
        context: r'CertificatesIdPut200BodyCertificateModel.domain_names',
      ),
      fingerprint: _$map[r'fingerprint'].decodeJsonNullableString(
        context: r'CertificatesIdPut200BodyCertificateModel.fingerprint',
      ),
      status: _$map[r'status'] == null
          ? null
          : _i5.CertificatesIdPut200BodyCertificateStatusModel.fromJson(
              _$map[r'status'],
            ),
      usedBy: _$map[r'used_by']
          .decodeJsonList<_i3.Object?>(
            context: r'CertificatesIdPut200BodyCertificateModel.used_by',
          )
          .map(_i6.CertificatesIdPut200BodyCertificateUsedByArrayModel.fromJson)
          .toList(),
    );
  }

  factory CertificatesIdPut200BodyCertificateModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for CertificatesIdPut200BodyCertificateModel: contains complex types',
    );
  }

  /// ID of the [Certificate](#tag/certificates).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Name of the Resource. Must be unique per Project.
  ///
  /// **Example**:
  /// ```
  /// my-resource
  /// ```
  final _i3.String name;

  /// User-defined labels (`key/value` pairs) for the Resource.
  /// For more information, see "[Labels](#description/labels)".
  ///
  ///
  /// **Example**:
  /// ```json
  /// {
  ///   "environment": "prod",
  ///   "example.com/my": "label",
  ///   "just-a-key": ""
  /// }
  /// ```
  final _i3.Map<_i3.String, _i3.String> labels;

  /// Type of the Certificate.
  ///
  /// **Example**:
  /// ```
  /// uploaded
  /// ```
  final _i4.CertificatesIdPut200BodyCertificateTypeModel? $type;

  /// Certificate and chain in PEM format, in order so that each record directly certifies the one preceding.
  ///
  /// **Example**:
  /// ```
  /// -----BEGIN CERTIFICATE-----
  /// ...
  /// ```
  final _i3.String? certificate;

  /// Point in time when the Resource was created (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  /// **Example**:
  /// ```
  /// 2016-01-30T23:55:00Z
  /// ```
  final _i3.DateTime created;

  /// Point in time when the Certificate becomes valid (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  /// **Example**:
  /// ```
  /// 2019-01-08T10:00:00Z
  /// ```
  final _i3.DateTime? notValidBefore;

  /// Point in time when the Certificate stops being valid (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  ///
  /// **Example**:
  /// ```
  /// 2019-07-08T09:59:59Z
  /// ```
  final _i3.DateTime? notValidAfter;

  /// Domains and subdomains covered by the Certificate.
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   "example.com",
  ///   "webmail.example.com",
  ///   "www.example.com"
  /// ]
  /// ```
  final _i3.List<_i3.String> domainNames;

  /// SHA256 fingerprint of the Certificate.
  ///
  /// **Example**:
  /// ```
  /// 03:c7:55:9b:2a:d1:04:17:09:f6:d0:7f:18:34:63:d4:3e:5f
  /// ```
  final _i3.String? fingerprint;

  /// Current status of a type `managed` Certificate, always *null* for type `uploaded` Certificates.
  final _i5.CertificatesIdPut200BodyCertificateStatusModel? status;

  /// Resources currently using the Certificate.
  final _i3.List<_i6.CertificatesIdPut200BodyCertificateUsedByArrayModel>
  usedBy;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'labels': this.labels,
    if (this.$type != null) r'type': this.$type?.toJson(),
    r'certificate': this.certificate,
    r'created': this.created.toTimeZonedIso8601String(),
    r'not_valid_before': this.notValidBefore?.toTimeZonedIso8601String(),
    r'not_valid_after': this.notValidAfter?.toTimeZonedIso8601String(),
    r'domain_names': this.domainNames,
    r'fingerprint': this.fingerprint,
    r'status': this.status?.toJson(),
    r'used_by': this.usedBy.map((e) => e.toJson()).toList(),
  };

  CertificatesIdPut200BodyCertificateModel Function({
    _i3.int? id,
    _i3.String? name,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i4.CertificatesIdPut200BodyCertificateTypeModel? $type,
    _i3.String? certificate,
    _i3.DateTime? created,
    _i3.DateTime? notValidBefore,
    _i3.DateTime? notValidAfter,
    _i3.List<_i3.String>? domainNames,
    _i3.String? fingerprint,
    _i5.CertificatesIdPut200BodyCertificateStatusModel? status,
    _i3.List<_i6.CertificatesIdPut200BodyCertificateUsedByArrayModel>? usedBy,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.String? name,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i3.Object? $type = _sentinel,
      _i3.Object? certificate = _sentinel,
      _i3.DateTime? created,
      _i3.Object? notValidBefore = _sentinel,
      _i3.Object? notValidAfter = _sentinel,
      _i3.List<_i3.String>? domainNames,
      _i3.Object? fingerprint = _sentinel,
      _i3.Object? status = _sentinel,
      _i3.List<_i6.CertificatesIdPut200BodyCertificateUsedByArrayModel>? usedBy,
    }) => CertificatesIdPut200BodyCertificateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      labels: labels ?? this.labels,
      $type: _i3.identical($type, _sentinel)
          ? this.$type
          : ($type as _i4.CertificatesIdPut200BodyCertificateTypeModel?),
      certificate: _i3.identical(certificate, _sentinel)
          ? this.certificate
          : (certificate as _i3.String?),
      created: created ?? this.created,
      notValidBefore: _i3.identical(notValidBefore, _sentinel)
          ? this.notValidBefore
          : (notValidBefore as _i3.DateTime?),
      notValidAfter: _i3.identical(notValidAfter, _sentinel)
          ? this.notValidAfter
          : (notValidAfter as _i3.DateTime?),
      domainNames: domainNames ?? this.domainNames,
      fingerprint: _i3.identical(fingerprint, _sentinel)
          ? this.fingerprint
          : (fingerprint as _i3.String?),
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status as _i5.CertificatesIdPut200BodyCertificateStatusModel?),
      usedBy: usedBy ?? this.usedBy,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i7.DeepCollectionEquality();
    return other is CertificatesIdPut200BodyCertificateModel &&
        other.id == this.id &&
        other.name == this.name &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.$type == this.$type &&
        other.certificate == this.certificate &&
        other.created == this.created &&
        other.notValidBefore == this.notValidBefore &&
        other.notValidAfter == this.notValidAfter &&
        _$deepEquals.equals(other.domainNames, this.domainNames) &&
        other.fingerprint == this.fingerprint &&
        other.status == this.status &&
        _$deepEquals.equals(other.usedBy, this.usedBy);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i7.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.name,
      deepEquals.hash(this.labels),
      this.$type,
      this.certificate,
      this.created,
      this.notValidBefore,
      this.notValidAfter,
      deepEquals.hash(this.domainNames),
      this.fingerprint,
      this.status,
      deepEquals.hash(this.usedBy),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for CertificatesIdPut200BodyCertificateModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i8.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode CertificatesIdPut200BodyCertificateModel: complex types cannot be URI-encoded',
    );
  }
}
