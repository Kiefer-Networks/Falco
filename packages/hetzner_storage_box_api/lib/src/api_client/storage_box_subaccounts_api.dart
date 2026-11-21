// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i7;

import 'package:dio/dio.dart' as _i10;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_parameters_array_model.dart'
    as _i11;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_post_body_body_model.dart'
    as _i13;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_put_body_body_model.dart'
    as _i16;
import 'package:hetzner_storage_box_api/src/operation/create_storage_box_subaccount.dart'
    as _i3;
import 'package:hetzner_storage_box_api/src/operation/delete_storage_box_subaccount.dart'
    as _i6;
import 'package:hetzner_storage_box_api/src/operation/get_storage_box_subaccount.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/operation/list_storage_box_subaccounts.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/operation/update_storage_box_subaccount.dart'
    as _i5;
import 'package:hetzner_storage_box_api/src/response_wrapper/create_storage_box_subaccount_response.dart'
    as _i12;
import 'package:hetzner_storage_box_api/src/response_wrapper/delete_storage_box_subaccount_response.dart'
    as _i17;
import 'package:hetzner_storage_box_api/src/response_wrapper/get_storage_box_subaccount_response.dart'
    as _i14;
import 'package:hetzner_storage_box_api/src/response_wrapper/list_storage_box_subaccounts_response.dart'
    as _i9;
import 'package:hetzner_storage_box_api/src/response_wrapper/update_storage_box_subaccount_response.dart'
    as _i15;
import 'package:hetzner_storage_box_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i8;

/// You can create additional users for a Storage Box. FTP, FTPS, SFTP, SCP, SMB/CIFS, HTTPS, and WebDAV are all available as protocols for these users. Additional Subaccounts can only access a sub-directory of the main user, and they use the storage space of the main user. The main user will have complete access to the directories of all Subaccounts.
///
/// To access a Subaccount, you use the Subaccount's username and the domain of the Subaccount (e.g `uXXXXX-subX.your-storagebox.de`) instead of the main account's username.
///
/// It is possible to grant a Subaccount only read-access to a directory which prevents it from uploading, deleting, and modifying files.
///
/// Please note that each Subaccount requires its own `authorized_keys` file. You can find more detailed instructions [here](https://docs.hetzner.com/storage/storage-box/backup-space-ssh-keys/).
///
/// The home directory of a Subaccount may only contain the following characters: `a‑z`, `A‑Z`, `0‑9`, dots (`.`), slashes (`/`), underscores (`_`) and minus signs (`-`). It must also not begin with a slash. Nested sub‑directories are supported. Any required directories are created automatically if they do not yet exist. Please note that you can only delete a Subaccount's home directory if you have already deleted the Subaccount itself.
///
class StorageBoxSubaccountsApi {
  StorageBoxSubaccountsApi(_i1.Server server)
    : _listStorageBoxSubaccounts = _i2.ListStorageBoxSubaccounts(
        server.baseUrl,
        () => server.dio,
      ),
      _createStorageBoxSubaccount = _i3.CreateStorageBoxSubaccount(
        server.baseUrl,
        () => server.dio,
      ),
      _getStorageBoxSubaccount = _i4.GetStorageBoxSubaccount(
        server.baseUrl,
        () => server.dio,
      ),
      _updateStorageBoxSubaccount = _i5.UpdateStorageBoxSubaccount(
        server.baseUrl,
        () => server.dio,
      ),
      _deleteStorageBoxSubaccount = _i6.DeleteStorageBoxSubaccount(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListStorageBoxSubaccounts _listStorageBoxSubaccounts;

  final _i3.CreateStorageBoxSubaccount _createStorageBoxSubaccount;

  final _i4.GetStorageBoxSubaccount _getStorageBoxSubaccount;

  final _i5.UpdateStorageBoxSubaccount _updateStorageBoxSubaccount;

  final _i6.DeleteStorageBoxSubaccount _deleteStorageBoxSubaccount;

  /// List Subaccounts
  /// Returns a list of [Storage Box Subaccount](#tag/storage-box-subaccounts).
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "subaccounts": [
  ///     {
  ///       "id": 42,
  ///       "name": "my-name",
  ///       "username": "u1337-sub1",
  ///       "server": "u1337-sub1.your-storagebox.de",
  ///       "home_directory": "my_backups/host01.my.company",
  ///       "access_settings": {
  ///         "samba_enabled": false,
  ///         "ssh_enabled": true,
  ///         "webdav_enabled": false,
  ///         "reachable_externally": true,
  ///         "readonly": false
  ///       },
  ///       "description": "host01 backup",
  ///       "created": "2025-02-22T00:02:00Z",
  ///       "labels": {
  ///         "environment": "prod",
  ///         "example.com/my": "label",
  ///         "just-a-key": ""
  ///       },
  ///       "storage_box": 42
  ///     }
  ///   ]
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
      _i9.ListStorageBoxSubaccountsResponse,
      _i10.Response<_i7.Object?>
    >
  >
  listStorageBoxSubaccounts({
    required _i7.int id,
    _i7.String? name,
    _i7.String? labelSelector,
    _i7.List<_i11.StorageBoxesIdSubaccountsParametersArrayModel>? sort,
    _i7.String? username,
    _i8.TonikCancellation? cancellation,
  }) async => this._listStorageBoxSubaccounts(
    id: id,
    name: name,
    labelSelector: labelSelector,
    sort: sort,
    username: username,
    cancellation: cancellation,
  );

  /// Create a Subaccount
  /// Creates a [Storage Box Subaccount](#tag/storage-box-subaccounts).
  ///
  /// A [Storage Box Subaccount](#tag/storage-box-subaccounts) will use a separate home directory.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// Action successfully created.
  ///
  /// ```json
  /// {
  ///   "subaccount": {
  ///     "id": 42,
  ///     "storage_box": 43
  ///   },
  ///   "action": {
  ///     "id": 13,
  ///     "command": "create_subaccount",
  ///     "status": "running",
  ///     "progress": 0,
  ///     "started": "2016-01-30T23:50:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 42,
  ///         "type": "storage_box"
  ///       },
  ///       {
  ///         "id": 43,
  ///         "type": "storage_box_subaccount"
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
    _i8.TonikResult<
      _i12.CreateStorageBoxSubaccountResponse,
      _i10.Response<_i7.Object?>
    >
  >
  createStorageBoxSubaccount({
    required _i13.StorageBoxesIdSubaccountsPostBodyBodyModel body,
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._createStorageBoxSubaccount(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Get a Subaccount
  /// Returns a specific [Storage Box Subaccount](#tag/storage-box-subaccounts).
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
      _i14.GetStorageBoxSubaccountResponse,
      _i10.Response<_i7.Object?>
    >
  >
  getStorageBoxSubaccount({
    required _i7.int id,
    required _i7.int subaccountId,
    _i8.TonikCancellation? cancellation,
  }) async => this._getStorageBoxSubaccount(
    id: id,
    subaccountId: subaccountId,
    cancellation: cancellation,
  );

  /// Update a Subaccount
  /// Updates a [Storage Box Subaccount](#tag/storage-box-subaccounts).
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
      _i15.UpdateStorageBoxSubaccountResponse,
      _i10.Response<_i7.Object?>
    >
  >
  updateStorageBoxSubaccount({
    required _i16.StorageBoxesIdSubaccountsSubaccountIdPutBodyBodyModel body,
    required _i7.int id,
    required _i7.int subaccountId,
    _i8.TonikCancellation? cancellation,
  }) async => this._updateStorageBoxSubaccount(
    body: body,
    id: id,
    subaccountId: subaccountId,
    cancellation: cancellation,
  );

  /// Delete a Subaccount
  /// Deletes a [Storage Box Subaccount](#tag/storage-box-subaccounts).
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// Action successfully created.
  ///
  /// ```json
  /// {
  ///   "action": {
  ///     "id": 13,
  ///     "command": "delete_subaccount",
  ///     "status": "running",
  ///     "progress": 0,
  ///     "started": "2016-01-30T23:50:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 42,
  ///         "type": "storage_box"
  ///       },
  ///       {
  ///         "id": 42,
  ///         "type": "storage_box_subaccount"
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
    _i8.TonikResult<
      _i17.DeleteStorageBoxSubaccountResponse,
      _i10.Response<_i7.Object?>
    >
  >
  deleteStorageBoxSubaccount({
    required _i7.int id,
    required _i7.int subaccountId,
    _i8.TonikCancellation? cancellation,
  }) async => this._deleteStorageBoxSubaccount(
    id: id,
    subaccountId: subaccountId,
    cancellation: cancellation,
  );
}
