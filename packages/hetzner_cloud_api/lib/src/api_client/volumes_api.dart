// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i7;

import 'package:dio/dio.dart' as _i10;
import 'package:hetzner_cloud_api/src/model/volumes_id_put_body_body_model.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/model/volumes_parameters_array_model.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/model/volumes_parameters_array_model2.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/model/volumes_post_body_body_model.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/operation/create_volume.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/delete_volume.dart' as _i6;
import 'package:hetzner_cloud_api/src/operation/get_volume.dart' as _i4;
import 'package:hetzner_cloud_api/src/operation/list_volumes.dart' as _i2;
import 'package:hetzner_cloud_api/src/operation/update_volume.dart' as _i5;
import 'package:hetzner_cloud_api/src/response_wrapper/create_volume_response.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/response_wrapper/delete_volume_response.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/response_wrapper/get_volume_response.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/response_wrapper/list_volumes_response.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/response_wrapper/update_volume_response.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i8;

/// A Volume is a highly-available, scalable, and SSD-based block storage for Servers.
///
/// Pricing for Volumes depends on the Volume size and Location, not the actual used storage.
///
/// Please see [Hetzner Docs](https://docs.hetzner.com/cloud/#Volumes) for more details about Volumes.
///
class VolumesApi {
  VolumesApi(_i1.Server server)
    : _listVolumes = _i2.ListVolumes(server.baseUrl, () => server.dio),
      _createVolume = _i3.CreateVolume(server.baseUrl, () => server.dio),
      _getVolume = _i4.GetVolume(server.baseUrl, () => server.dio),
      _updateVolume = _i5.UpdateVolume(server.baseUrl, () => server.dio),
      _deleteVolume = _i6.DeleteVolume(server.baseUrl, () => server.dio);

  final _i2.ListVolumes _listVolumes;

  final _i3.CreateVolume _createVolume;

  final _i4.GetVolume _getVolume;

  final _i5.UpdateVolume _updateVolume;

  final _i6.DeleteVolume _deleteVolume;

  /// List Volumes
  /// Gets all existing Volumes that you have available.
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
    _i8.TonikResult<_i9.ListVolumesResponse, _i10.Response<_i7.Object?>>
  >
  listVolumes({
    _i7.List<_i11.VolumesParametersArrayModel>? status,
    _i7.List<_i12.VolumesParametersArrayModel2>? sort,
    _i7.String? name,
    _i7.String? labelSelector,
    _i7.int page = _i2.ListVolumes.pageDefault,
    _i7.int perPage = _i2.ListVolumes.perPageDefault,
    _i8.TonikCancellation? cancellation,
  }) async => this._listVolumes(
    status: status,
    sort: sort,
    name: name,
    labelSelector: labelSelector,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Create a Volume
  /// Creates a new Volume attached to a Server. If you want to create a Volume that is not attached to a Server, you need to provide the `location` key instead of `server`. This can be either the ID or the name of the Location this Volume will be created in. Note that a Volume can be attached to a Server only in the same Location as the Volume itself.
  ///
  /// Specifying the Server during Volume creation will automatically attach the Volume to that Server after it has been initialized. In that case, the `next_actions` key in the response is an array which contains a single `attach_volume` action.
  ///
  /// The minimum Volume size is 10GB and the maximum size is 10TB (10240GB).
  ///
  /// A volume’s name can consist of alphanumeric characters, dashes, underscores, and dots, but has to start and end with an alphanumeric character. The total length is limited to 64 characters. Volume names must be unique per Project.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `no_space_left_in_location` | There is no volume space left in the given location |
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Request body (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "size": 42,
  ///   "name": "test-database",
  ///   "labels": {
  ///     "key": "value"
  ///   },
  ///   "location": "nbg1",
  ///   "automount": false,
  ///   "format": "xfs"
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "volume": {
  ///     "id": 4711,
  ///     "created": "2016-01-30T23:50:11Z",
  ///     "name": "database-storage",
  ///     "server": 12,
  ///     "assignee": {
  ///       "id": 12,
  ///       "type": "server"
  ///     },
  ///     "location": {
  ///       "id": 1,
  ///       "name": "fsn1",
  ///       "description": "Falkenstein DC Park 1",
  ///       "country": "DE",
  ///       "city": "Falkenstein",
  ///       "latitude": 50.47612,
  ///       "longitude": 12.370071,
  ///       "network_zone": "eu-central"
  ///     },
  ///     "size": 42,
  ///     "linux_device": "/dev/disk/by-id/scsi-0HC_Volume_4711",
  ///     "protection": {
  ///       "delete": false
  ///     },
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "status": "available",
  ///     "format": "xfs"
  ///   },
  ///   "action": {
  ///     "id": 13,
  ///     "command": "create_volume",
  ///     "status": "running",
  ///     "progress": 0,
  ///     "started": "2016-01-30T23:50:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 42,
  ///         "type": "server"
  ///       },
  ///       {
  ///         "id": 554,
  ///         "type": "volume"
  ///       }
  ///     ],
  ///     "error": {
  ///       "code": "action_failed",
  ///       "message": "Action failed"
  ///     }
  ///   },
  ///   "next_actions": [
  ///     {
  ///       "id": 13,
  ///       "command": "attach_volume",
  ///       "status": "running",
  ///       "progress": 0,
  ///       "started": "2016-01-30T23:50:00Z",
  ///       "finished": null,
  ///       "resources": [
  ///         {
  ///           "id": 42,
  ///           "type": "server"
  ///         },
  ///         {
  ///           "id": 554,
  ///           "type": "volume"
  ///         }
  ///       ],
  ///       "error": {
  ///         "code": "action_failed",
  ///         "message": "Action failed"
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
    _i8.TonikResult<_i13.CreateVolumeResponse, _i10.Response<_i7.Object?>>
  >
  createVolume({
    required _i14.VolumesPostBodyBodyModel body,
    _i8.TonikCancellation? cancellation,
  }) async => this._createVolume(body: body, cancellation: cancellation);

  /// Get a Volume
  /// Gets a specific Volume object.
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
    _i8.TonikResult<_i15.GetVolumeResponse, _i10.Response<_i7.Object?>>
  >
  getVolume({required _i7.int id, _i8.TonikCancellation? cancellation}) async =>
      this._getVolume(id: id, cancellation: cancellation);

  /// Update a Volume
  /// Updates the Volume properties.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "volume": {
  ///     "id": 4711,
  ///     "created": "2016-01-30T23:50:11Z",
  ///     "name": "database-storage",
  ///     "server": 12,
  ///     "assignee": {
  ///       "id": 12,
  ///       "type": "server"
  ///     },
  ///     "location": {
  ///       "id": 1,
  ///       "name": "fsn1",
  ///       "description": "Falkenstein DC Park 1",
  ///       "country": "DE",
  ///       "city": "Falkenstein",
  ///       "latitude": 50.47612,
  ///       "longitude": 12.370071,
  ///       "network_zone": "eu-central"
  ///     },
  ///     "size": 42,
  ///     "linux_device": "/dev/disk/by-id/scsi-0HC_Volume_4711",
  ///     "protection": {
  ///       "delete": false
  ///     },
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "status": "available",
  ///     "format": "xfs"
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
    _i8.TonikResult<_i16.UpdateVolumeResponse, _i10.Response<_i7.Object?>>
  >
  updateVolume({
    required _i17.VolumesIdPutBodyBodyModel body,
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async =>
      this._updateVolume(body: body, id: id, cancellation: cancellation);

  /// Delete a Volume
  /// Deletes a volume. All Volume data is irreversibly destroyed. The Volume must not be attached to a Server and it must not have delete protection enabled.
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
    _i8.TonikResult<_i18.DeleteVolumeResponse, _i10.Response<_i7.Object?>>
  >
  deleteVolume({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._deleteVolume(id: id, cancellation: cancellation);
}
