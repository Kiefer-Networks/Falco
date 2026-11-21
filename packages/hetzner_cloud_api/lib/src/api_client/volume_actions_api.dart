// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i10;

import 'package:dio/dio.dart' as _i13;
import 'package:hetzner_cloud_api/src/model/volumes_actions_parameters_array_model.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/model/volumes_actions_parameters_array_model2.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/model/volumes_id_actions_attach_post_body_body_model.dart'
    as _i21;
import 'package:hetzner_cloud_api/src/model/volumes_id_actions_change_protection_post_body_body_model.dart'
    as _i23;
import 'package:hetzner_cloud_api/src/model/volumes_id_actions_parameters_array_model.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/model/volumes_id_actions_parameters_array_model2.dart'
    as _i19;
import 'package:hetzner_cloud_api/src/model/volumes_id_actions_resize_post_body_body_model.dart'
    as _i26;
import 'package:hetzner_cloud_api/src/operation/attach_volume.dart' as _i5;
import 'package:hetzner_cloud_api/src/operation/change_volume_protection.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/operation/detach_volume.dart' as _i7;
import 'package:hetzner_cloud_api/src/operation/get_volume_action.dart' as _i9;
import 'package:hetzner_cloud_api/src/operation/get_volumes_action.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/list_volume_actions.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/operation/list_volumes_actions.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/operation/resize_volume.dart' as _i8;
import 'package:hetzner_cloud_api/src/response_wrapper/attach_volume_response.dart'
    as _i20;
import 'package:hetzner_cloud_api/src/response_wrapper/change_volume_protection_response.dart'
    as _i22;
import 'package:hetzner_cloud_api/src/response_wrapper/detach_volume_response.dart'
    as _i24;
import 'package:hetzner_cloud_api/src/response_wrapper/get_volume_action_response.dart'
    as _i27;
import 'package:hetzner_cloud_api/src/response_wrapper/get_volumes_action_response.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/response_wrapper/list_volume_actions_response.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/response_wrapper/list_volumes_actions_response.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/response_wrapper/resize_volume_response.dart'
    as _i25;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i11;

class VolumeActionsApi {
  VolumeActionsApi(_i1.Server server)
    : _listVolumesActions = _i2.ListVolumesActions(
        server.baseUrl,
        () => server.dio,
      ),
      _getVolumesAction = _i3.GetVolumesAction(
        server.baseUrl,
        () => server.dio,
      ),
      _listVolumeActions = _i4.ListVolumeActions(
        server.baseUrl,
        () => server.dio,
      ),
      _attachVolume = _i5.AttachVolume(server.baseUrl, () => server.dio),
      _changeVolumeProtection = _i6.ChangeVolumeProtection(
        server.baseUrl,
        () => server.dio,
      ),
      _detachVolume = _i7.DetachVolume(server.baseUrl, () => server.dio),
      _resizeVolume = _i8.ResizeVolume(server.baseUrl, () => server.dio),
      _getVolumeAction = _i9.GetVolumeAction(server.baseUrl, () => server.dio);

  final _i2.ListVolumesActions _listVolumesActions;

  final _i3.GetVolumesAction _getVolumesAction;

  final _i4.ListVolumeActions _listVolumeActions;

  final _i5.AttachVolume _attachVolume;

  final _i6.ChangeVolumeProtection _changeVolumeProtection;

  final _i7.DetachVolume _detachVolume;

  final _i8.ResizeVolume _resizeVolume;

  final _i9.GetVolumeAction _getVolumeAction;

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
  _i10.Future<
    _i11.TonikResult<
      _i12.ListVolumesActionsResponse,
      _i13.Response<_i10.Object?>
    >
  >
  listVolumesActions({
    _i10.List<_i10.int>? id,
    _i10.List<_i14.VolumesActionsParametersArrayModel>? sort,
    _i10.List<_i15.VolumesActionsParametersArrayModel2>? status,
    _i10.int page = _i2.ListVolumesActions.pageDefault,
    _i10.int perPage = _i2.ListVolumesActions.perPageDefault,
    _i11.TonikCancellation? cancellation,
  }) async => this._listVolumesActions(
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
  _i10.Future<
    _i11.TonikResult<_i16.GetVolumesActionResponse, _i13.Response<_i10.Object?>>
  >
  getVolumesAction({
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async => this._getVolumesAction(id: id, cancellation: cancellation);

  /// List Actions for a Volume
  /// Returns all Action objects for a Volume. You can `sort` the results by using the sort URI parameter, and filter them with the `status` parameter.
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
  ///       "id": 13,
  ///       "command": "attach_volume",
  ///       "status": "success",
  ///       "progress": 100,
  ///       "started": "2016-01-30T23:55:00Z",
  ///       "finished": "2016-01-30T23:56:00Z",
  ///       "resources": [
  ///         {
  ///           "id": 42,
  ///           "type": "server"
  ///         },
  ///         {
  ///           "id": 13,
  ///           "type": "volume"
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
  _i10.Future<
    _i11.TonikResult<
      _i17.ListVolumeActionsResponse,
      _i13.Response<_i10.Object?>
    >
  >
  listVolumeActions({
    required _i10.int id,
    _i10.List<_i18.VolumesIdActionsParametersArrayModel>? sort,
    _i10.List<_i19.VolumesIdActionsParametersArrayModel2>? status,
    _i10.int page = _i4.ListVolumeActions.pageDefault,
    _i10.int perPage = _i4.ListVolumeActions.perPageDefault,
    _i11.TonikCancellation? cancellation,
  }) async => this._listVolumeActions(
    id: id,
    sort: sort,
    status: status,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Attach Volume to a Resource
  /// Attaches a Volume to a Resource. Works only if the Resource is in the same Location as the Volume.
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
  ///     "id": 13,
  ///     "command": "attach_volume",
  ///     "status": "running",
  ///     "progress": 0,
  ///     "started": "2016-01-30T23:50:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 43,
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
  _i10.Future<
    _i11.TonikResult<_i20.AttachVolumeResponse, _i13.Response<_i10.Object?>>
  >
  attachVolume({
    required _i21.VolumesIdActionsAttachPostBodyBodyModel body,
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async =>
      this._attachVolume(body: body, id: id, cancellation: cancellation);

  /// Change Volume Protection
  /// Changes the protection configuration of a Volume.
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
  ///     "id": 13,
  ///     "command": "change_protection",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": "2016-01-30T23:56:00Z",
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
  _i10.Future<
    _i11.TonikResult<
      _i22.ChangeVolumeProtectionResponse,
      _i13.Response<_i10.Object?>
    >
  >
  changeVolumeProtection({
    required _i23.VolumesIdActionsChangeProtectionPostBodyBodyModel body,
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async => this._changeVolumeProtection(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Detach Volume
  /// Detaches a Volume from the Resource it’s attached to. You may attach it to a Resource again at a later time.
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
  ///     "id": 13,
  ///     "command": "detach_volume",
  ///     "status": "running",
  ///     "progress": 0,
  ///     "started": "2016-01-30T23:50:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 42,
  ///         "type": "server"
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
  _i10.Future<
    _i11.TonikResult<_i24.DetachVolumeResponse, _i13.Response<_i10.Object?>>
  >
  detachVolume({
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async => this._detachVolume(id: id, cancellation: cancellation);

  /// Resize Volume
  /// Changes the size of a Volume. Note that downsizing a Volume is not possible.
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
  ///     "id": 13,
  ///     "command": "resize_volume",
  ///     "status": "running",
  ///     "progress": 0,
  ///     "started": "2016-01-30T23:50:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 554,
  ///         "type": "volume"
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
  _i10.Future<
    _i11.TonikResult<_i25.ResizeVolumeResponse, _i13.Response<_i10.Object?>>
  >
  resizeVolume({
    required _i26.VolumesIdActionsResizePostBodyBodyModel body,
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async =>
      this._resizeVolume(body: body, id: id, cancellation: cancellation);

  /// Get an Action for a Volume
  /// **Deprecated**: This operation is deprecated, see our [changelog](https://docs.hetzner.cloud/changelog#2026-04-30-deprecate-get-resource-action-endpoints) for more details.
  ///
  /// Returns a specific Action for a Volume.
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
  ///     "id": 13,
  ///     "command": "attach_volume",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": "2016-01-30T23:56:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 42,
  ///         "type": "server"
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
  @_i10.Deprecated('This operation is deprecated.')
  _i10.Future<
    _i11.TonikResult<_i27.GetVolumeActionResponse, _i13.Response<_i10.Object?>>
  >
  getVolumeAction({
    required _i10.int id,
    required _i10.int actionId,
    _i11.TonikCancellation? cancellation,
  }) async => this._getVolumeAction(
    id: id,
    actionId: actionId,
    cancellation: cancellation,
  );
}
