// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i7;

import 'package:dio/dio.dart' as _i10;
import 'package:hetzner_cloud_api/src/model/certificates_id_put_body_body_model.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/model/certificates_parameters_array_model.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/model/certificates_parameters_array_model2.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/model/certificates_post_body_body_model.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/operation/create_certificate.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/delete_certificate.dart' as _i6;
import 'package:hetzner_cloud_api/src/operation/get_certificate.dart' as _i4;
import 'package:hetzner_cloud_api/src/operation/list_certificates.dart' as _i2;
import 'package:hetzner_cloud_api/src/operation/update_certificate.dart' as _i5;
import 'package:hetzner_cloud_api/src/response_wrapper/create_certificate_response.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/response_wrapper/delete_certificate_response.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/response_wrapper/get_certificate_response.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/response_wrapper/list_certificates_response.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/response_wrapper/update_certificate_response.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i8;

/// TLS/SSL Certificates prove the identity of a Server and are used to encrypt client traffic.
///
class CertificatesApi {
  CertificatesApi(_i1.Server server)
    : _listCertificates = _i2.ListCertificates(
        server.baseUrl,
        () => server.dio,
      ),
      _createCertificate = _i3.CreateCertificate(
        server.baseUrl,
        () => server.dio,
      ),
      _getCertificate = _i4.GetCertificate(server.baseUrl, () => server.dio),
      _updateCertificate = _i5.UpdateCertificate(
        server.baseUrl,
        () => server.dio,
      ),
      _deleteCertificate = _i6.DeleteCertificate(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListCertificates _listCertificates;

  final _i3.CreateCertificate _createCertificate;

  final _i4.GetCertificate _getCertificate;

  final _i5.UpdateCertificate _updateCertificate;

  final _i6.DeleteCertificate _deleteCertificate;

  /// List Certificates
  /// Returns all Certificate objects.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "certificates": [
  ///     {
  ///       "id": 897,
  ///       "name": "my website cert",
  ///       "labels": {
  ///         "key": "value"
  ///       },
  ///       "type": "uploaded",
  ///       "certificate": "-----BEGIN CERTIFICATE-----\n...",
  ///       "created": "2019-01-08T12:10:00Z",
  ///       "not_valid_before": "2019-01-08T10:00:00Z",
  ///       "not_valid_after": "2019-07-08T09:59:59Z",
  ///       "domain_names": [
  ///         "example.com",
  ///         "webmail.example.com",
  ///         "www.example.com"
  ///       ],
  ///       "fingerprint": "03:c7:55:9b:2a:d1:04:17:09:f6:d0:7f:18:34:63:d4:3e:5f",
  ///       "status": null,
  ///       "used_by": [
  ///         {
  ///           "id": 4711,
  ///           "type": "load_balancer"
  ///         }
  ///       ]
  ///     }
  ///   ],
  ///   "meta": {
  ///     "pagination": {
  ///       "page": 1,
  ///       "per_page": 25,
  ///       "previous_page": null,
  ///       "next_page": null,
  ///       "last_page": 1,
  ///       "total_entries": 21
  ///     }
  ///   }
  /// }
  /// ```
  ///
  /// Response 400–499 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "unable to authenticate",
  ///     "details": null
  ///   }
  /// }
  /// ```
  ///
  /// Response 500–599 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "timeout",
  ///     "message": "request timeout",
  ///     "details": null
  ///   }
  /// }
  /// ```
  _i7.Future<
    _i8.TonikResult<_i9.ListCertificatesResponse, _i10.Response<_i7.Object?>>
  >
  listCertificates({
    _i7.List<_i11.CertificatesParametersArrayModel>? sort,
    _i7.String? name,
    _i7.String? labelSelector,
    _i7.List<_i12.CertificatesParametersArrayModel2>? $type,
    _i7.int page = _i2.ListCertificates.pageDefault,
    _i7.int perPage = _i2.ListCertificates.perPageDefault,
    _i8.TonikCancellation? cancellation,
  }) async => this._listCertificates(
    sort: sort,
    name: name,
    labelSelector: labelSelector,
    $type: $type,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Create a Certificate
  /// Creates a new Certificate.
  ///
  /// The default type **uploaded** allows for uploading your existing `certificate` and `private_key` in PEM format. You have to monitor its expiration date and handle renewal yourself.
  ///
  /// In contrast, type **managed** requests a new Certificate from *Let's Encrypt* for the specified `domain_names`. Only domains managed by *Hetzner DNS* are supported. We handle renewal and timely alert the project owner via email if problems occur.
  ///
  /// For type `managed` Certificates the `action` key of the response contains the Action that allows for tracking the issuance process. For type `uploaded` Certificates the `action` is always null.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Request body (application/json):
  /// **Example** "uploaded" — Creating a type `uploaded` Certificate:
  /// ```json
  /// {
  ///   "name": "my website cert",
  ///   "type": "uploaded",
  ///   "certificate": "-----BEGIN CERTIFICATE-----\n...",
  ///   "private_key": "-----BEGIN PRIVATE KEY-----\n..."
  /// }
  /// ```
  ///
  /// **Example** "managed" — Creating a type `managed` Certificate:
  /// ```json
  /// {
  ///   "name": "my website cert",
  ///   "type": "managed",
  ///   "domain_names": [
  ///     "example.com",
  ///     "webmail.example.com",
  ///     "www.example.com"
  ///   ]
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "uploaded" — Response when creating a type `uploaded` Certificate:
  /// ```json
  /// {
  ///   "certificate": {
  ///     "id": 897,
  ///     "name": "my website cert",
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "type": "uploaded",
  ///     "certificate": "-----BEGIN CERTIFICATE-----\n...",
  ///     "created": "2019-01-08T12:10:00Z",
  ///     "not_valid_before": "2019-01-08T10:00:00Z",
  ///     "not_valid_after": "2019-07-08T09:59:59Z",
  ///     "domain_names": [
  ///       "example.com",
  ///       "webmail.example.com",
  ///       "www.example.com"
  ///     ],
  ///     "fingerprint": "03:c7:55:9b:2a:d1:04:17:09:f6:d0:7f:18:34:63:d4:3e:5f",
  ///     "status": null,
  ///     "used_by": [
  ///       {
  ///         "id": 4711,
  ///         "type": "load_balancer"
  ///       }
  ///     ]
  ///   },
  ///   "action": null
  /// }
  /// ```
  ///
  /// **Example** "managed" — Response when creating a type `managed` Certificate:
  /// ```json
  /// {
  ///   "certificate": {
  ///     "id": 897,
  ///     "name": "my website cert",
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "type": "managed",
  ///     "certificate": null,
  ///     "created": "2019-01-08T12:10:00Z",
  ///     "not_valid_before": null,
  ///     "not_valid_after": null,
  ///     "domain_names": [
  ///       "example.com",
  ///       "webmail.example.com",
  ///       "www.example.com"
  ///     ],
  ///     "fingerprint": null,
  ///     "status": {
  ///       "issuance": "pending",
  ///       "renewal": "unavailable",
  ///       "error": null
  ///     },
  ///     "used_by": [
  ///       {
  ///         "id": 4711,
  ///         "type": "load_balancer"
  ///       }
  ///     ]
  ///   },
  ///   "action": {
  ///     "id": 13,
  ///     "command": "create_certificate",
  ///     "status": "running",
  ///     "progress": 0,
  ///     "started": "2019-01-08T12:10:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 879,
  ///         "type": "certificate"
  ///       }
  ///     ],
  ///     "error": {
  ///       "code": "action_failed",
  ///       "message": "Action failed"
  ///     }
  ///   }
  /// }
  /// ```
  ///
  /// Response 400–499 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "unable to authenticate",
  ///     "details": null
  ///   }
  /// }
  /// ```
  ///
  /// Response 500–599 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "timeout",
  ///     "message": "request timeout",
  ///     "details": null
  ///   }
  /// }
  /// ```
  _i7.Future<
    _i8.TonikResult<_i13.CreateCertificateResponse, _i10.Response<_i7.Object?>>
  >
  createCertificate({
    required _i14.CertificatesPostBodyBodyModel body,
    _i8.TonikCancellation? cancellation,
  }) async => this._createCertificate(body: body, cancellation: cancellation);

  /// Get a Certificate
  /// Gets a specific Certificate object.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "certificate": {
  ///     "id": 897,
  ///     "name": "my website cert",
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "type": "uploaded",
  ///     "certificate": "-----BEGIN CERTIFICATE-----\n...",
  ///     "created": "2019-01-08T12:10:00Z",
  ///     "not_valid_before": "2019-01-08T10:00:00Z",
  ///     "not_valid_after": "2019-07-08T09:59:59Z",
  ///     "domain_names": [
  ///       "example.com",
  ///       "webmail.example.com",
  ///       "www.example.com"
  ///     ],
  ///     "fingerprint": "03:c7:55:9b:2a:d1:04:17:09:f6:d0:7f:18:34:63:d4:3e:5f",
  ///     "status": null,
  ///     "used_by": [
  ///       {
  ///         "id": 4711,
  ///         "type": "load_balancer"
  ///       }
  ///     ]
  ///   }
  /// }
  /// ```
  ///
  /// Response 400–499 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "unable to authenticate",
  ///     "details": null
  ///   }
  /// }
  /// ```
  ///
  /// Response 500–599 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "timeout",
  ///     "message": "request timeout",
  ///     "details": null
  ///   }
  /// }
  /// ```
  _i7.Future<
    _i8.TonikResult<_i15.GetCertificateResponse, _i10.Response<_i7.Object?>>
  >
  getCertificate({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._getCertificate(id: id, cancellation: cancellation);

  /// Update a Certificate
  /// Updates the Certificate properties.
  ///
  /// Note: if the Certificate object changes during the request, the response will be a “conflict” error.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "certificate": {
  ///     "id": 897,
  ///     "name": "my website cert",
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "type": "uploaded",
  ///     "certificate": "-----BEGIN CERTIFICATE-----\n...",
  ///     "created": "2019-01-08T12:10:00Z",
  ///     "not_valid_before": "2019-01-08T10:00:00Z",
  ///     "not_valid_after": "2019-07-08T09:59:59Z",
  ///     "domain_names": [
  ///       "example.com",
  ///       "webmail.example.com",
  ///       "www.example.com"
  ///     ],
  ///     "fingerprint": "03:c7:55:9b:2a:d1:04:17:09:f6:d0:7f:18:34:63:d4:3e:5f",
  ///     "status": null,
  ///     "used_by": [
  ///       {
  ///         "id": 4711,
  ///         "type": "load_balancer"
  ///       }
  ///     ]
  ///   }
  /// }
  /// ```
  ///
  /// Response 400–499 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "unable to authenticate",
  ///     "details": null
  ///   }
  /// }
  /// ```
  ///
  /// Response 500–599 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "timeout",
  ///     "message": "request timeout",
  ///     "details": null
  ///   }
  /// }
  /// ```
  _i7.Future<
    _i8.TonikResult<_i16.UpdateCertificateResponse, _i10.Response<_i7.Object?>>
  >
  updateCertificate({
    required _i17.CertificatesIdPutBodyBodyModel body,
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async =>
      this._updateCertificate(body: body, id: id, cancellation: cancellation);

  /// Delete a Certificate
  /// Deletes a Certificate.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 400–499 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "unauthorized",
  ///     "message": "unable to authenticate",
  ///     "details": null
  ///   }
  /// }
  /// ```
  ///
  /// Response 500–599 (application/json):
  /// **Example**:
  /// ```json
  /// {
  ///   "error": {
  ///     "code": "timeout",
  ///     "message": "request timeout",
  ///     "details": null
  ///   }
  /// }
  /// ```
  _i7.Future<
    _i8.TonikResult<_i18.DeleteCertificateResponse, _i10.Response<_i7.Object?>>
  >
  deleteCertificate({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._deleteCertificate(id: id, cancellation: cancellation);
}
