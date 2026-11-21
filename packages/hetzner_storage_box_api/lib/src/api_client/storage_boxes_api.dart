// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i8;

import 'package:dio/dio.dart' as _i11;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_put_body_body_model.dart'
    as _i17;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_parameters_array_model.dart'
    as _i12;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_post_body_body_model.dart'
    as _i14;
import 'package:hetzner_storage_box_api/src/operation/create_storage_box.dart'
    as _i3;
import 'package:hetzner_storage_box_api/src/operation/delete_storage_box.dart'
    as _i6;
import 'package:hetzner_storage_box_api/src/operation/get_storage_box.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/operation/list_storage_box_folders.dart'
    as _i7;
import 'package:hetzner_storage_box_api/src/operation/list_storage_boxes.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/operation/update_storage_box.dart'
    as _i5;
import 'package:hetzner_storage_box_api/src/response_wrapper/create_storage_box_response.dart'
    as _i13;
import 'package:hetzner_storage_box_api/src/response_wrapper/delete_storage_box_response.dart'
    as _i18;
import 'package:hetzner_storage_box_api/src/response_wrapper/get_storage_box_response.dart'
    as _i15;
import 'package:hetzner_storage_box_api/src/response_wrapper/list_storage_box_folders_response.dart'
    as _i19;
import 'package:hetzner_storage_box_api/src/response_wrapper/list_storage_boxes_response.dart'
    as _i10;
import 'package:hetzner_storage_box_api/src/response_wrapper/update_storage_box_response.dart'
    as _i16;
import 'package:hetzner_storage_box_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i9;

/// Storage Boxes offer storage capacity for both small and large amounts of data. Any data you save in your Storage Box is saved on several disks configured in a RAID array, increasing redundancy and fault tolerance.
///
/// Please see [Hetzner Docs](https://docs.hetzner.com/storage/storage-box) for more details about Storage Boxes.
///
/// <h3 id="tag/storage-boxes/password-policy">Password policy</h3>
///
/// This policy applies to both Storage Boxes and Storage Box Subaccounts.
///
/// - The password must be between 12 and 128 characters long
/// - The password can only contain these characters: `a-z A-Z Ä Ö Ü ä ö ü ß 0-9 ^ ° ! § $ % / ( ) = ? + # - . , ; : ~ * @ { } _ &`
/// - The password must contain at least one upper case letter, one lower case letter, one number, and a special character
/// - The password must not have appeared in any known data breach
///
class StorageBoxesApi {
  StorageBoxesApi(_i1.Server server)
    : _listStorageBoxes = _i2.ListStorageBoxes(
        server.baseUrl,
        () => server.dio,
      ),
      _createStorageBox = _i3.CreateStorageBox(
        server.baseUrl,
        () => server.dio,
      ),
      _getStorageBox = _i4.GetStorageBox(server.baseUrl, () => server.dio),
      _updateStorageBox = _i5.UpdateStorageBox(
        server.baseUrl,
        () => server.dio,
      ),
      _deleteStorageBox = _i6.DeleteStorageBox(
        server.baseUrl,
        () => server.dio,
      ),
      _listStorageBoxFolders = _i7.ListStorageBoxFolders(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListStorageBoxes _listStorageBoxes;

  final _i3.CreateStorageBox _createStorageBox;

  final _i4.GetStorageBox _getStorageBox;

  final _i5.UpdateStorageBox _updateStorageBox;

  final _i6.DeleteStorageBox _deleteStorageBox;

  final _i7.ListStorageBoxFolders _listStorageBoxFolders;

  /// List Storage Boxes
  /// Returns a paginated list of [Storage Boxes](#tag/storage-boxes).
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
  _i8.Future<
    _i9.TonikResult<_i10.ListStorageBoxesResponse, _i11.Response<_i8.Object?>>
  >
  listStorageBoxes({
    _i8.String? name,
    _i8.String? labelSelector,
    _i8.List<_i12.StorageBoxesParametersArrayModel>? sort,
    _i8.int page = _i2.ListStorageBoxes.pageDefault,
    _i8.int perPage = _i2.ListStorageBoxes.perPageDefault,
    _i9.TonikCancellation? cancellation,
  }) async => this._listStorageBoxes(
    name: name,
    labelSelector: labelSelector,
    sort: sort,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Create a Storage Box
  /// Creates a [Storage Box](#tag/storage-boxes).
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
  ///   "storage_box": {
  ///     "id": 42,
  ///     "status": "initializing",
  ///     "name": "my-resource",
  ///     "username": "u45321",
  ///     "storage_box_type": {
  ///       "id": 1,
  ///       "name": "bx20",
  ///       "description": "BX20",
  ///       "snapshot_limit": 10,
  ///       "automatic_snapshot_limit": 10,
  ///       "subaccounts_limit": 100,
  ///       "size": 1073741824,
  ///       "prices": [
  ///         {
  ///           "location": "fsn1",
  ///           "price_hourly": {
  ///             "gross": "0.0061",
  ///             "net": "0.0051"
  ///           },
  ///           "price_monthly": {
  ///             "gross": "3.8080",
  ///             "net": "3.2000"
  ///           },
  ///           "setup_fee": {
  ///             "gross": "0.0000",
  ///             "net": "0.0000"
  ///           }
  ///         }
  ///       ],
  ///       "deprecation": null
  ///     },
  ///     "location": {
  ///       "id": 1,
  ///       "country": "DE",
  ///       "city": "Falkenstein",
  ///       "name": "fsn1",
  ///       "network_zone": "eu-central",
  ///       "latitude": 50.476119,
  ///       "longitude": 12.370071,
  ///       "description": "Falkenstein DC Park 1"
  ///     },
  ///     "access_settings": {
  ///       "reachable_externally": false,
  ///       "samba_enabled": false,
  ///       "ssh_enabled": false,
  ///       "webdav_enabled": false,
  ///       "zfs_enabled": false
  ///     },
  ///     "server": null,
  ///     "system": null,
  ///     "stats": {
  ///       "size": 0,
  ///       "size_data": 0,
  ///       "size_snapshots": 0
  ///     },
  ///     "labels": {
  ///       "environment": "prod",
  ///       "example.com/my": "label",
  ///       "just-a-key": ""
  ///     },
  ///     "protection": {
  ///       "delete": false
  ///     },
  ///     "snapshot_plan": null,
  ///     "created": "2016-01-30T23:50:00Z"
  ///   },
  ///   "action": {
  ///     "id": 13,
  ///     "command": "create",
  ///     "status": "running",
  ///     "progress": 0,
  ///     "started": "2016-01-30T23:50:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 42,
  ///         "type": "storage_box"
  ///       }
  ///     ],
  ///     "error": null
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
  _i8.Future<
    _i9.TonikResult<_i13.CreateStorageBoxResponse, _i11.Response<_i8.Object?>>
  >
  createStorageBox({
    required _i14.StorageBoxesPostBodyBodyModel body,
    _i9.TonikCancellation? cancellation,
  }) async => this._createStorageBox(body: body, cancellation: cancellation);

  /// Get a Storage Box
  /// Returns a specific [Storage Box](#tag/storage-boxes).
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
  _i8.Future<
    _i9.TonikResult<_i15.GetStorageBoxResponse, _i11.Response<_i8.Object?>>
  >
  getStorageBox({
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => this._getStorageBox(id: id, cancellation: cancellation);

  /// Update a Storage Box
  /// Updates a [Storage Box](#tag/storage-boxes).
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
  _i8.Future<
    _i9.TonikResult<_i16.UpdateStorageBoxResponse, _i11.Response<_i8.Object?>>
  >
  updateStorageBox({
    required _i17.StorageBoxesIdPutBodyBodyModel body,
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async =>
      this._updateStorageBox(body: body, id: id, cancellation: cancellation);

  /// Delete a Storage Box
  /// Deletes a [Storage Box](#tag/storage-boxes).
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
  ///     "command": "delete",
  ///     "status": "success",
  ///     "progress": 0,
  ///     "started": "2016-01-30T23:50:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 42,
  ///         "type": "storage_box"
  ///       }
  ///     ],
  ///     "error": null
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
  _i8.Future<
    _i9.TonikResult<_i18.DeleteStorageBoxResponse, _i11.Response<_i8.Object?>>
  >
  deleteStorageBox({
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => this._deleteStorageBox(id: id, cancellation: cancellation);

  /// List folders of a Storage Box
  /// Returns a list of (sub)folders in a [Storage Box](#tag/storage-boxes).
  ///
  /// The folder location is specified by the `path` query parameter.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// A list of directories the Storage Box contains.
  ///
  /// ```json
  /// {
  ///   "folders": [
  ///     "offsite-backup",
  ///     "photos"
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
  _i8.Future<
    _i9.TonikResult<
      _i19.ListStorageBoxFoldersResponse,
      _i11.Response<_i8.Object?>
    >
  >
  listStorageBoxFolders({
    required _i8.int id,
    _i8.String path = _i7.ListStorageBoxFolders.pathDefault,
    _i9.TonikCancellation? cancellation,
  }) async => this._listStorageBoxFolders(
    id: id,
    path: path,
    cancellation: cancellation,
  );
}
