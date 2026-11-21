// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i7;

import 'package:dio/dio.dart' as _i10;
import 'package:hetzner_cloud_api/src/model/certificates_actions_parameters_array_model.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/model/certificates_actions_parameters_array_model2.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/model/certificates_id_actions_parameters_array_model.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/model/certificates_id_actions_parameters_array_model2.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/operation/get_certificate_action.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/operation/get_certificates_action.dart'
    as _i3;
import 'package:hetzner_cloud_api/src/operation/list_certificate_actions.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/operation/list_certificates_actions.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/operation/retry_certificate.dart' as _i5;
import 'package:hetzner_cloud_api/src/response_wrapper/get_certificate_action_response.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/response_wrapper/get_certificates_action_response.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/response_wrapper/list_certificate_actions_response.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/response_wrapper/list_certificates_actions_response.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/response_wrapper/retry_certificate_response.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i8;

class CertificateActionsApi {
  CertificateActionsApi(_i1.Server server)
    : _listCertificatesActions = _i2.ListCertificatesActions(
        server.baseUrl,
        () => server.dio,
      ),
      _getCertificatesAction = _i3.GetCertificatesAction(
        server.baseUrl,
        () => server.dio,
      ),
      _listCertificateActions = _i4.ListCertificateActions(
        server.baseUrl,
        () => server.dio,
      ),
      _retryCertificate = _i5.RetryCertificate(
        server.baseUrl,
        () => server.dio,
      ),
      _getCertificateAction = _i6.GetCertificateAction(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListCertificatesActions _listCertificatesActions;

  final _i3.GetCertificatesAction _getCertificatesAction;

  final _i4.ListCertificateActions _listCertificateActions;

  final _i5.RetryCertificate _retryCertificate;

  final _i6.GetCertificateAction _getCertificateAction;

  /// List Actions
  /// Returns all Action objects. You can `sort` the results by using the sort URI parameter, and filter them with the `status` and `id` parameter.
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
    _i8.TonikResult<
      _i9.ListCertificatesActionsResponse,
      _i10.Response<_i7.Object?>
    >
  >
  listCertificatesActions({
    _i7.List<_i7.int>? id,
    _i7.List<_i11.CertificatesActionsParametersArrayModel>? sort,
    _i7.List<_i12.CertificatesActionsParametersArrayModel2>? status,
    _i7.int page = _i2.ListCertificatesActions.pageDefault,
    _i7.int perPage = _i2.ListCertificatesActions.perPageDefault,
    _i8.TonikCancellation? cancellation,
  }) async => this._listCertificatesActions(
    id: id,
    sort: sort,
    status: status,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Get an Action
  /// Returns a specific Action object.
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
    _i8.TonikResult<
      _i13.GetCertificatesActionResponse,
      _i10.Response<_i7.Object?>
    >
  >
  getCertificatesAction({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._getCertificatesAction(id: id, cancellation: cancellation);

  /// List Actions for a Certificate
  /// Returns all Action objects for a Certificate. You can sort the results by using the `sort` URI parameter, and filter them with the `status` parameter.
  ///
  /// Only type `managed` Certificates can have Actions. For type `uploaded` Certificates the `actions` key will always contain an empty array.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "actions": [
  ///     {
  ///       "id": 14,
  ///       "command": "issue_certificate",
  ///       "status": "success",
  ///       "progress": 100,
  ///       "started": "2021-01-30T23:55:00Z",
  ///       "finished": "2021-01-30T23:57:00Z",
  ///       "resources": [
  ///         {
  ///           "id": 896,
  ///           "type": "certificate"
  ///         }
  ///       ],
  ///       "error": {
  ///         "code": "action_failed",
  ///         "message": "Action failed"
  ///       }
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
    _i8.TonikResult<
      _i14.ListCertificateActionsResponse,
      _i10.Response<_i7.Object?>
    >
  >
  listCertificateActions({
    required _i7.int id,
    _i7.List<_i15.CertificatesIdActionsParametersArrayModel>? sort,
    _i7.List<_i16.CertificatesIdActionsParametersArrayModel2>? status,
    _i7.int page = _i4.ListCertificateActions.pageDefault,
    _i7.int perPage = _i4.ListCertificateActions.perPageDefault,
    _i8.TonikCancellation? cancellation,
  }) async => this._listCertificateActions(
    id: id,
    sort: sort,
    status: status,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Retry Issuance or Renewal
  /// Retry a failed Certificate issuance or renewal.
  ///
  /// Only applicable if the type of the Certificate is `managed` and the issuance or renewal status is `failed`.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// |  | `caa_record_does_not_allow_ca` | CAA record does not allow certificate authority |
  /// |  | `ca_dns_validation_failed` | Certificate Authority: DNS validation failed |
  /// |  | `ca_too_many_authorizations_failed_recently` | Certificate Authority: Too many authorizations failed recently |
  /// |  | `ca_too_many_certificates_issued_for_registered_domain` | Certificate Authority: Too many certificates issued for registered domain |
  /// |  | `ca_too_many_duplicate_certificates` | Certificate Authority: Too many duplicate certificates |
  /// |  | `could_not_verify_domain_delegated_to_zone` | Could not verify domain delegated to zone |
  /// |  | `dns_zone_not_found` | DNS zone not found |
  /// |  | `dns_zone_is_secondary_zone` | DNS zone is a secondary zone |
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "action": {
  ///     "id": 14,
  ///     "command": "issue_certificate",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2021-01-30T23:55:00Z",
  ///     "finished": "2021-01-30T23:57:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 896,
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
    _i8.TonikResult<_i17.RetryCertificateResponse, _i10.Response<_i7.Object?>>
  >
  retryCertificate({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._retryCertificate(id: id, cancellation: cancellation);

  /// Get an Action for a Certificate
  /// **Deprecated**: This operation is deprecated, see our [changelog](https://docs.hetzner.cloud/changelog#2026-04-30-deprecate-get-resource-action-endpoints) for more details.
  ///
  /// Returns a specific Action for a Certificate. Only type `managed` Certificates have Actions.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "action": {
  ///     "id": 14,
  ///     "command": "issue_certificate",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2021-01-30T23:55:00Z",
  ///     "finished": "2021-01-30T23:57:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 896,
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
  @_i7.Deprecated('This operation is deprecated.')
  _i7.Future<
    _i8.TonikResult<
      _i18.GetCertificateActionResponse,
      _i10.Response<_i7.Object?>
    >
  >
  getCertificateAction({
    required _i7.int id,
    required _i7.int actionId,
    _i8.TonikCancellation? cancellation,
  }) async => this._getCertificateAction(
    id: id,
    actionId: actionId,
    cancellation: cancellation,
  );
}
