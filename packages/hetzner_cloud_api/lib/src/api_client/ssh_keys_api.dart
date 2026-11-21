// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i7;

import 'package:dio/dio.dart' as _i10;
import 'package:hetzner_cloud_api/src/model/ssh_keys_id_put_body_body_model.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/model/ssh_keys_parameters_array_model.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/model/ssh_keys_post_body_body_model.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/operation/create_ssh_key.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/delete_ssh_key.dart' as _i6;
import 'package:hetzner_cloud_api/src/operation/get_ssh_key.dart' as _i4;
import 'package:hetzner_cloud_api/src/operation/list_ssh_keys.dart' as _i2;
import 'package:hetzner_cloud_api/src/operation/update_ssh_key.dart' as _i5;
import 'package:hetzner_cloud_api/src/response_wrapper/create_ssh_key_response.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/response_wrapper/delete_ssh_key_response.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/response_wrapper/get_ssh_key_response.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/response_wrapper/list_ssh_keys_response.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/response_wrapper/update_ssh_key_response.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i8;

/// SSH keys are public keys you provide to the cloud system. They can be injected into Servers at creation time. We highly recommend that you use keys instead of passwords to manage your Servers.
///
class SshKeysApi {
  SshKeysApi(_i1.Server server)
    : _listSshKeys = _i2.ListSshKeys(server.baseUrl, () => server.dio),
      _createSshKey = _i3.CreateSshKey(server.baseUrl, () => server.dio),
      _getSshKey = _i4.GetSshKey(server.baseUrl, () => server.dio),
      _updateSshKey = _i5.UpdateSshKey(server.baseUrl, () => server.dio),
      _deleteSshKey = _i6.DeleteSshKey(server.baseUrl, () => server.dio);

  final _i2.ListSshKeys _listSshKeys;

  final _i3.CreateSshKey _createSshKey;

  final _i4.GetSshKey _getSshKey;

  final _i5.UpdateSshKey _updateSshKey;

  final _i6.DeleteSshKey _deleteSshKey;

  /// List SSH keys
  /// Returns all SSH key objects.
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
    _i8.TonikResult<_i9.ListSshKeysResponse, _i10.Response<_i7.Object?>>
  >
  listSshKeys({
    _i7.List<_i11.SshKeysParametersArrayModel>? sort,
    _i7.String? name,
    _i7.String? fingerprint,
    _i7.String? labelSelector,
    _i7.int page = _i2.ListSshKeys.pageDefault,
    _i7.int perPage = _i2.ListSshKeys.perPageDefault,
    _i8.TonikCancellation? cancellation,
  }) async => this._listSshKeys(
    sort: sort,
    name: name,
    fingerprint: fingerprint,
    labelSelector: labelSelector,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Create an SSH key
  /// Creates a new SSH key with the given `name` and `public_key`. Once an SSH key is created, it can be used in other calls such as creating Servers.
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
    _i8.TonikResult<_i12.CreateSshKeyResponse, _i10.Response<_i7.Object?>>
  >
  createSshKey({
    required _i13.SshKeysPostBodyBodyModel body,
    _i8.TonikCancellation? cancellation,
  }) async => this._createSshKey(body: body, cancellation: cancellation);

  /// Get a SSH key
  /// Returns a specific SSH key object.
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
    _i8.TonikResult<_i14.GetSshKeyResponse, _i10.Response<_i7.Object?>>
  >
  getSshKey({required _i7.int id, _i8.TonikCancellation? cancellation}) async =>
      this._getSshKey(id: id, cancellation: cancellation);

  /// Update an SSH key
  /// Updates an SSH key. You can update an SSH key name and an SSH key labels.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "ssh_key": {
  ///     "id": 2323,
  ///     "name": "My ssh key",
  ///     "fingerprint": "b7:2f:30:a0:2f:6c:58:6c:21:04:58:61:ba:06:3b:2f",
  ///     "public_key": "ssh-rsa AAAjjk76kgf...Xt",
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "created": "2016-01-30T23:50:00Z"
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
    _i8.TonikResult<_i15.UpdateSshKeyResponse, _i10.Response<_i7.Object?>>
  >
  updateSshKey({
    required _i16.SshKeysIdPutBodyBodyModel body,
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async =>
      this._updateSshKey(body: body, id: id, cancellation: cancellation);

  /// Delete an SSH key
  /// Deletes an SSH key. It cannot be used anymore.
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
    _i8.TonikResult<_i17.DeleteSshKeyResponse, _i10.Response<_i7.Object?>>
  >
  deleteSshKey({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._deleteSshKey(id: id, cancellation: cancellation);
}
