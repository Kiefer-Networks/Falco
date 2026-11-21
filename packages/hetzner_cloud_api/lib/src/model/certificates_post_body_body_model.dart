// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/certificates_post_body_body_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class CertificatesPostBodyBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CertificatesPostBodyBodyModel({
    required this.name,
    this.labels,
    this.$type = $typeDefault,
    this.certificate,
    this.privateKey,
    this.domainNames,
  });

  factory CertificatesPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for CertificatesPostBodyBodyModel: contains complex types',
    );
  }

  factory CertificatesPostBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'CertificatesPostBodyBodyModel');
    return CertificatesPostBodyBodyModel(
      name: _$map[r'name'].decodeJsonString(
        context: r'CertificatesPostBodyBodyModel.name',
      ),
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(
          context: r'CertificatesPostBodyBodyModel.labels',
        ),
        context: r'CertificatesPostBodyBodyModel.labels',
      ),
      $type: _$map.containsKey(r'type')
          ? _i4.CertificatesPostBodyBodyTypeModel.fromJson(_$map[r'type'])
          : $typeDefault,
      certificate: _$map[r'certificate'].decodeJsonNullableString(
        context: r'CertificatesPostBodyBodyModel.certificate',
      ),
      privateKey: _$map[r'private_key'].decodeJsonNullableString(
        context: r'CertificatesPostBodyBodyModel.private_key',
      ),
      domainNames: _$map[r'domain_names'].decodeJsonNullableList<_i3.String>(
        context: r'CertificatesPostBodyBodyModel.domain_names',
      ),
    );
  }

  factory CertificatesPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for CertificatesPostBodyBodyModel: contains complex types',
    );
  }

  static const _i4.CertificatesPostBodyBodyTypeModel $typeDefault =
      _i4.CertificatesPostBodyBodyTypeModel.uploaded;

  /// Name of the Certificate.
  ///
  /// **Example**:
  /// ```
  /// my website cert
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
  final _i3.Map<_i3.String, _i3.String>? labels;

  /// Choose between uploading a Certificate in PEM format or requesting a managed *Let's Encrypt* Certificate.
  ///
  /// **Example**:
  /// ```
  /// uploaded
  /// ```
  final _i4.CertificatesPostBodyBodyTypeModel? $type;

  /// Certificate and chain in PEM format, in order so that each record directly certifies the one preceding. Required for type `uploaded` Certificates.
  ///
  /// **Example**:
  /// ```
  /// -----BEGIN CERTIFICATE-----
  /// ...
  /// ```
  final _i3.String? certificate;

  /// Certificate key in PEM format. Required for type `uploaded` Certificates.
  ///
  /// **Example**:
  /// ```
  /// -----BEGIN PRIVATE KEY-----
  /// ...
  /// ```
  final _i3.String? privateKey;

  /// Domains and subdomains that should be contained in the Certificate issued by *Let's Encrypt*. Required for type `managed` Certificates.
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   "example.com",
  ///   "www.example.com"
  /// ]
  /// ```
  final _i3.List<_i3.String>? domainNames;

  @_i3.override
  _i3.Object? toJson() => {
    r'name': this.name,
    if (this.labels != null) r'labels': this.labels,
    if (this.$type != null) r'type': this.$type?.toJson(),
    if (this.certificate != null) r'certificate': this.certificate,
    if (this.privateKey != null) r'private_key': this.privateKey,
    if (this.domainNames != null) r'domain_names': this.domainNames,
  };

  CertificatesPostBodyBodyModel Function({
    _i3.String? name,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i4.CertificatesPostBodyBodyTypeModel? $type,
    _i3.String? certificate,
    _i3.String? privateKey,
    _i3.List<_i3.String>? domainNames,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.String? name,
      _i3.Object? labels = _sentinel,
      _i3.Object? $type = _sentinel,
      _i3.Object? certificate = _sentinel,
      _i3.Object? privateKey = _sentinel,
      _i3.Object? domainNames = _sentinel,
    }) => CertificatesPostBodyBodyModel(
      name: name ?? this.name,
      labels: _i3.identical(labels, _sentinel)
          ? this.labels
          : (labels as _i3.Map<_i3.String, _i3.String>?),
      $type: _i3.identical($type, _sentinel)
          ? this.$type
          : ($type as _i4.CertificatesPostBodyBodyTypeModel?),
      certificate: _i3.identical(certificate, _sentinel)
          ? this.certificate
          : (certificate as _i3.String?),
      privateKey: _i3.identical(privateKey, _sentinel)
          ? this.privateKey
          : (privateKey as _i3.String?),
      domainNames: _i3.identical(domainNames, _sentinel)
          ? this.domainNames
          : (domainNames as _i3.List<_i3.String>?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is CertificatesPostBodyBodyModel &&
        other.name == this.name &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.$type == this.$type &&
        other.certificate == this.certificate &&
        other.privateKey == this.privateKey &&
        _$deepEquals.equals(other.domainNames, this.domainNames);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.name,
      deepEquals.hash(this.labels),
      this.$type,
      this.certificate,
      this.privateKey,
      deepEquals.hash(this.domainNames),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for CertificatesPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode CertificatesPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
