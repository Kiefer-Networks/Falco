// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i7;

import 'package:dio/dio.dart' as _i10;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_parameters_array_model.dart'
    as _i11;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_post_body_body_model.dart'
    as _i13;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_snapshots_snapshot_id_put_body_body_model.dart'
    as _i16;
import 'package:hetzner_storage_box_api/src/operation/create_storage_box_snapshot.dart'
    as _i3;
import 'package:hetzner_storage_box_api/src/operation/delete_storage_box_snapshot.dart'
    as _i6;
import 'package:hetzner_storage_box_api/src/operation/get_storage_box_snapshot.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/operation/list_storage_box_snapshots.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/operation/update_storage_box_snapshot.dart'
    as _i5;
import 'package:hetzner_storage_box_api/src/response_wrapper/create_storage_box_snapshot_response.dart'
    as _i12;
import 'package:hetzner_storage_box_api/src/response_wrapper/delete_storage_box_snapshot_response.dart'
    as _i17;
import 'package:hetzner_storage_box_api/src/response_wrapper/get_storage_box_snapshot_response.dart'
    as _i14;
import 'package:hetzner_storage_box_api/src/response_wrapper/list_storage_box_snapshots_response.dart'
    as _i9;
import 'package:hetzner_storage_box_api/src/response_wrapper/update_storage_box_snapshot_response.dart'
    as _i15;
import 'package:hetzner_storage_box_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i8;

class StorageBoxSnapshotsApi {
  StorageBoxSnapshotsApi(_i1.Server server)
    : _listStorageBoxSnapshots = _i2.ListStorageBoxSnapshots(
        server.baseUrl,
        () => server.dio,
      ),
      _createStorageBoxSnapshot = _i3.CreateStorageBoxSnapshot(
        server.baseUrl,
        () => server.dio,
      ),
      _getStorageBoxSnapshot = _i4.GetStorageBoxSnapshot(
        server.baseUrl,
        () => server.dio,
      ),
      _updateStorageBoxSnapshot = _i5.UpdateStorageBoxSnapshot(
        server.baseUrl,
        () => server.dio,
      ),
      _deleteStorageBoxSnapshot = _i6.DeleteStorageBoxSnapshot(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListStorageBoxSnapshots _listStorageBoxSnapshots;

  final _i3.CreateStorageBoxSnapshot _createStorageBoxSnapshot;

  final _i4.GetStorageBoxSnapshot _getStorageBoxSnapshot;

  final _i5.UpdateStorageBoxSnapshot _updateStorageBoxSnapshot;

  final _i6.DeleteStorageBoxSnapshot _deleteStorageBoxSnapshot;

  /// List Snapshots
  /// Returns a list of [Storage Box Snapshot](#tag/storage-box-snapshots).
  ///
  /// Both snapshots created manually and by the snapshot plan are returned.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "snapshots": [
  ///     {
  ///       "id": 1,
  ///       "stats": {
  ///         "size": 2097152,
  ///         "size_filesystem": 1048576
  ///       },
  ///       "is_automatic": false,
  ///       "name": "2025-02-12T11-35-19",
  ///       "description": "my-description",
  ///       "created": "2025-02-12T11:35:19.000Z",
  ///       "storage_box": 42,
  ///       "labels": {
  ///         "environment": "prod",
  ///         "example.com/my": "label",
  ///         "just-a-key": ""
  ///       }
  ///     },
  ///     {
  ///       "id": 2,
  ///       "stats": {
  ///         "size": 2097152,
  ///         "size_filesystem": 1048576
  ///       },
  ///       "is_automatic": true,
  ///       "name": "snapshot-daily--2025-02-12T22-00-02",
  ///       "description": "",
  ///       "created": "2025-02-22T01:00:30Z",
  ///       "storage_box": 42,
  ///       "labels": {
  ///         "environment": "prod",
  ///         "example.com/my": "label",
  ///         "just-a-key": ""
  ///       }
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
      _i9.ListStorageBoxSnapshotsResponse,
      _i10.Response<_i7.Object?>
    >
  >
  listStorageBoxSnapshots({
    required _i7.int id,
    _i7.String? name,
    _i7.String? labelSelector,
    _i7.List<_i11.StorageBoxesIdSnapshotsParametersArrayModel>? sort,
    _i7.bool? isAutomatic,
    _i8.TonikCancellation? cancellation,
  }) async => this._listStorageBoxSnapshots(
    id: id,
    name: name,
    labelSelector: labelSelector,
    sort: sort,
    isAutomatic: isAutomatic,
    cancellation: cancellation,
  );

  /// Create a Snapshot
  /// Creates a [Storage Box Snapshot](#tag/storage-box-snapshots).
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
  ///   "snapshot": {
  ///     "id": 42,
  ///     "storage_box": 43
  ///   },
  ///   "action": {
  ///     "id": 13,
  ///     "command": "create_snapshot",
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
  ///         "type": "storage_box_snapshot"
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
      _i12.CreateStorageBoxSnapshotResponse,
      _i10.Response<_i7.Object?>
    >
  >
  createStorageBoxSnapshot({
    required _i13.StorageBoxesIdSnapshotsPostBodyBodyModel body,
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._createStorageBoxSnapshot(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Get a Snapshot
  /// Returns a specific [Storage Box Snapshot](#tag/storage-box-snapshots).
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
      _i14.GetStorageBoxSnapshotResponse,
      _i10.Response<_i7.Object?>
    >
  >
  getStorageBoxSnapshot({
    required _i7.int id,
    required _i7.int snapshotId,
    _i8.TonikCancellation? cancellation,
  }) async => this._getStorageBoxSnapshot(
    id: id,
    snapshotId: snapshotId,
    cancellation: cancellation,
  );

  /// Update a Snapshot
  /// Updates a [Storage Box Snapshot](#tag/storage-box-snapshots).
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
      _i15.UpdateStorageBoxSnapshotResponse,
      _i10.Response<_i7.Object?>
    >
  >
  updateStorageBoxSnapshot({
    required _i16.StorageBoxesIdSnapshotsSnapshotIdPutBodyBodyModel body,
    required _i7.int id,
    required _i7.int snapshotId,
    _i8.TonikCancellation? cancellation,
  }) async => this._updateStorageBoxSnapshot(
    body: body,
    id: id,
    snapshotId: snapshotId,
    cancellation: cancellation,
  );

  /// Delete a Snapshot
  /// Deletes a [Storage Box Snapshot](#tag/storage-box-snapshots).
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
  ///     "command": "delete_snapshot",
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
  ///         "type": "storage_box_snapshot"
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
      _i17.DeleteStorageBoxSnapshotResponse,
      _i10.Response<_i7.Object?>
    >
  >
  deleteStorageBoxSnapshot({
    required _i7.int id,
    required _i7.int snapshotId,
    _i8.TonikCancellation? cancellation,
  }) async => this._deleteStorageBoxSnapshot(
    id: id,
    snapshotId: snapshotId,
    cancellation: cancellation,
  );
}
