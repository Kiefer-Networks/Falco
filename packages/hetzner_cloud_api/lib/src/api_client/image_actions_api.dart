// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i7;

import 'package:dio/dio.dart' as _i10;
import 'package:hetzner_cloud_api/src/model/images_actions_parameters_array_model.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/model/images_actions_parameters_array_model2.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/model/images_id_actions_change_protection_post_body_body_model.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/model/images_id_actions_parameters_array_model.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/model/images_id_actions_parameters_array_model2.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/operation/change_image_protection.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/operation/get_image_action.dart' as _i6;
import 'package:hetzner_cloud_api/src/operation/get_images_action.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/list_image_actions.dart' as _i4;
import 'package:hetzner_cloud_api/src/operation/list_images_actions.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/response_wrapper/change_image_protection_response.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/response_wrapper/get_image_action_response.dart'
    as _i19;
import 'package:hetzner_cloud_api/src/response_wrapper/get_images_action_response.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/response_wrapper/list_image_actions_response.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/response_wrapper/list_images_actions_response.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i8;

class ImageActionsApi {
  ImageActionsApi(_i1.Server server)
    : _listImagesActions = _i2.ListImagesActions(
        server.baseUrl,
        () => server.dio,
      ),
      _getImagesAction = _i3.GetImagesAction(server.baseUrl, () => server.dio),
      _listImageActions = _i4.ListImageActions(
        server.baseUrl,
        () => server.dio,
      ),
      _changeImageProtection = _i5.ChangeImageProtection(
        server.baseUrl,
        () => server.dio,
      ),
      _getImageAction = _i6.GetImageAction(server.baseUrl, () => server.dio);

  final _i2.ListImagesActions _listImagesActions;

  final _i3.GetImagesAction _getImagesAction;

  final _i4.ListImageActions _listImageActions;

  final _i5.ChangeImageProtection _changeImageProtection;

  final _i6.GetImageAction _getImageAction;

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
    _i8.TonikResult<_i9.ListImagesActionsResponse, _i10.Response<_i7.Object?>>
  >
  listImagesActions({
    _i7.List<_i7.int>? id,
    _i7.List<_i11.ImagesActionsParametersArrayModel>? sort,
    _i7.List<_i12.ImagesActionsParametersArrayModel2>? status,
    _i7.int page = _i2.ListImagesActions.pageDefault,
    _i7.int perPage = _i2.ListImagesActions.perPageDefault,
    _i8.TonikCancellation? cancellation,
  }) async => this._listImagesActions(
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
    _i8.TonikResult<_i13.GetImagesActionResponse, _i10.Response<_i7.Object?>>
  >
  getImagesAction({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._getImagesAction(id: id, cancellation: cancellation);

  /// List Actions for an Image
  /// Returns all Action objects for an Image. You can sort the results by using the `sort` URI parameter, and filter them with the `status` parameter.
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
  ///       "command": "change_protection",
  ///       "status": "success",
  ///       "progress": 100,
  ///       "started": "2016-01-30T23:55:00Z",
  ///       "finished": "2016-01-30T23:56:00Z",
  ///       "resources": [
  ///         {
  ///           "id": 4711,
  ///           "type": "image"
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
    _i8.TonikResult<_i14.ListImageActionsResponse, _i10.Response<_i7.Object?>>
  >
  listImageActions({
    required _i7.int id,
    _i7.List<_i15.ImagesIdActionsParametersArrayModel>? sort,
    _i7.List<_i16.ImagesIdActionsParametersArrayModel2>? status,
    _i7.int page = _i4.ListImageActions.pageDefault,
    _i7.int perPage = _i4.ListImageActions.perPageDefault,
    _i8.TonikCancellation? cancellation,
  }) async => this._listImageActions(
    id: id,
    sort: sort,
    status: status,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Change Image Protection
  /// Changes the protection configuration of the Image. Can only be used on snapshots.
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
  ///         "id": 4711,
  ///         "type": "image"
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
      _i17.ChangeImageProtectionResponse,
      _i10.Response<_i7.Object?>
    >
  >
  changeImageProtection({
    required _i18.ImagesIdActionsChangeProtectionPostBodyBodyModel body,
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._changeImageProtection(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Get an Action for an Image
  /// **Deprecated**: This operation is deprecated, see our [changelog](https://docs.hetzner.cloud/changelog#2026-04-30-deprecate-get-resource-action-endpoints) for more details.
  ///
  /// Returns a specific Action for an Image.
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
  ///     "command": "change_protection",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": "2016-01-30T23:56:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 4711,
  ///         "type": "image"
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
    _i8.TonikResult<_i19.GetImageActionResponse, _i10.Response<_i7.Object?>>
  >
  getImageAction({
    required _i7.int id,
    required _i7.int actionId,
    _i8.TonikCancellation? cancellation,
  }) async => this._getImageAction(
    id: id,
    actionId: actionId,
    cancellation: cancellation,
  );
}
