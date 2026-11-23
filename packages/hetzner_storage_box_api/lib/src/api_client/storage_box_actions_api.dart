// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i13;

import 'package:dio/dio.dart' as _i16;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_actions_parameters_array_model.dart'
    as _i17;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_actions_parameters_array_model2.dart'
    as _i18;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_change_protection_post_body_body_model.dart'
    as _i25;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_change_type_post_body_body_model.dart'
    as _i27;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_enable_snapshot_plan_post_body_body_model.dart'
    as _i36;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_parameters_array_model.dart'
    as _i21;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_parameters_array_model2.dart'
    as _i22;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_reset_password_post_body_body_model.dart'
    as _i29;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_rollback_snapshot_post_body_body_model.dart'
    as _i33;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_actions_update_access_settings_post_body_body_model.dart'
    as _i31;
import 'package:hetzner_storage_box_api/src/operation/change_storage_box_protection.dart'
    as _i6;
import 'package:hetzner_storage_box_api/src/operation/change_storage_box_type.dart'
    as _i7;
import 'package:hetzner_storage_box_api/src/operation/disable_storage_box_snapshot_plan.dart'
    as _i11;
import 'package:hetzner_storage_box_api/src/operation/enable_storage_box_snapshot_plan.dart'
    as _i12;
import 'package:hetzner_storage_box_api/src/operation/get_storage_box_action.dart'
    as _i5;
import 'package:hetzner_storage_box_api/src/operation/get_storage_boxes_action.dart'
    as _i3;
import 'package:hetzner_storage_box_api/src/operation/list_storage_box_actions.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/operation/list_storage_boxes_actions.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/operation/reset_storage_box_password.dart'
    as _i8;
import 'package:hetzner_storage_box_api/src/operation/rollback_storage_box_snapshot.dart'
    as _i10;
import 'package:hetzner_storage_box_api/src/operation/update_storage_box_access_settings.dart'
    as _i9;
import 'package:hetzner_storage_box_api/src/response_wrapper/change_storage_box_protection_response.dart'
    as _i24;
import 'package:hetzner_storage_box_api/src/response_wrapper/change_storage_box_type_response.dart'
    as _i26;
import 'package:hetzner_storage_box_api/src/response_wrapper/disable_storage_box_snapshot_plan_response.dart'
    as _i34;
import 'package:hetzner_storage_box_api/src/response_wrapper/enable_storage_box_snapshot_plan_response.dart'
    as _i35;
import 'package:hetzner_storage_box_api/src/response_wrapper/get_storage_box_action_response.dart'
    as _i23;
import 'package:hetzner_storage_box_api/src/response_wrapper/get_storage_boxes_action_response.dart'
    as _i19;
import 'package:hetzner_storage_box_api/src/response_wrapper/list_storage_box_actions_response.dart'
    as _i20;
import 'package:hetzner_storage_box_api/src/response_wrapper/list_storage_boxes_actions_response.dart'
    as _i15;
import 'package:hetzner_storage_box_api/src/response_wrapper/reset_storage_box_password_response.dart'
    as _i28;
import 'package:hetzner_storage_box_api/src/response_wrapper/rollback_storage_box_snapshot_response.dart'
    as _i32;
import 'package:hetzner_storage_box_api/src/response_wrapper/update_storage_box_access_settings_response.dart'
    as _i30;
import 'package:hetzner_storage_box_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i14;

class StorageBoxActionsApi {
  StorageBoxActionsApi(_i1.Server server)
    : _listStorageBoxesActions = _i2.ListStorageBoxesActions(
        server.baseUrl,
        () => server.dio,
      ),
      _getStorageBoxesAction = _i3.GetStorageBoxesAction(
        server.baseUrl,
        () => server.dio,
      ),
      _listStorageBoxActions = _i4.ListStorageBoxActions(
        server.baseUrl,
        () => server.dio,
      ),
      _getStorageBoxAction = _i5.GetStorageBoxAction(
        server.baseUrl,
        () => server.dio,
      ),
      _changeStorageBoxProtection = _i6.ChangeStorageBoxProtection(
        server.baseUrl,
        () => server.dio,
      ),
      _changeStorageBoxType = _i7.ChangeStorageBoxType(
        server.baseUrl,
        () => server.dio,
      ),
      _resetStorageBoxPassword = _i8.ResetStorageBoxPassword(
        server.baseUrl,
        () => server.dio,
      ),
      _updateStorageBoxAccessSettings = _i9.UpdateStorageBoxAccessSettings(
        server.baseUrl,
        () => server.dio,
      ),
      _rollbackStorageBoxSnapshot = _i10.RollbackStorageBoxSnapshot(
        server.baseUrl,
        () => server.dio,
      ),
      _disableStorageBoxSnapshotPlan = _i11.DisableStorageBoxSnapshotPlan(
        server.baseUrl,
        () => server.dio,
      ),
      _enableStorageBoxSnapshotPlan = _i12.EnableStorageBoxSnapshotPlan(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListStorageBoxesActions _listStorageBoxesActions;

  final _i3.GetStorageBoxesAction _getStorageBoxesAction;

  final _i4.ListStorageBoxActions _listStorageBoxActions;

  final _i5.GetStorageBoxAction _getStorageBoxAction;

  final _i6.ChangeStorageBoxProtection _changeStorageBoxProtection;

  final _i7.ChangeStorageBoxType _changeStorageBoxType;

  final _i8.ResetStorageBoxPassword _resetStorageBoxPassword;

  final _i9.UpdateStorageBoxAccessSettings _updateStorageBoxAccessSettings;

  final _i10.RollbackStorageBoxSnapshot _rollbackStorageBoxSnapshot;

  final _i11.DisableStorageBoxSnapshotPlan _disableStorageBoxSnapshotPlan;

  final _i12.EnableStorageBoxSnapshotPlan _enableStorageBoxSnapshotPlan;

  /// List Actions
  /// Returns all Action objects.
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
  _i13.Future<
    _i14.TonikResult<
      _i15.ListStorageBoxesActionsResponse,
      _i16.Response<_i13.Object?>
    >
  >
  listStorageBoxesActions({
    _i13.List<_i13.int>? id,
    _i13.List<_i17.StorageBoxesActionsParametersArrayModel>? sort,
    _i13.List<_i18.StorageBoxesActionsParametersArrayModel2>? status,
    _i13.int page = _i2.ListStorageBoxesActions.pageDefault,
    _i13.int perPage = _i2.ListStorageBoxesActions.perPageDefault,
    _i14.TonikCancellation? cancellation,
  }) async => this._listStorageBoxesActions(
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
  _i13.Future<
    _i14.TonikResult<
      _i19.GetStorageBoxesActionResponse,
      _i16.Response<_i13.Object?>
    >
  >
  getStorageBoxesAction({
    required _i13.int id,
    _i14.TonikCancellation? cancellation,
  }) async => this._getStorageBoxesAction(id: id, cancellation: cancellation);

  /// List Actions for a Storage Box
  /// List all Actions related to a specific Storage Box.
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
  _i13.Future<
    _i14.TonikResult<
      _i20.ListStorageBoxActionsResponse,
      _i16.Response<_i13.Object?>
    >
  >
  listStorageBoxActions({
    required _i13.int id,
    _i13.List<_i21.StorageBoxesIdActionsParametersArrayModel>? sort,
    _i13.List<_i22.StorageBoxesIdActionsParametersArrayModel2>? status,
    _i13.int page = _i4.ListStorageBoxActions.pageDefault,
    _i13.int perPage = _i4.ListStorageBoxActions.perPageDefault,
    _i14.TonikCancellation? cancellation,
  }) async => this._listStorageBoxActions(
    id: id,
    sort: sort,
    status: status,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Get an Action for a Storage Box
  /// **Deprecated**: This operation is deprecated, see our [changelog](https://docs.hetzner.cloud/changelog#2026-04-30-deprecate-get-resource-action-endpoints) for more details.
  ///
  /// Returns a specific Action object for a Storage Box.
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
  @_i13.Deprecated('This operation is deprecated.')
  _i13.Future<
    _i14.TonikResult<
      _i23.GetStorageBoxActionResponse,
      _i16.Response<_i13.Object?>
    >
  >
  getStorageBoxAction({
    required _i13.int id,
    required _i13.int actionId,
    _i14.TonikCancellation? cancellation,
  }) async => this._getStorageBoxAction(
    id: id,
    actionId: actionId,
    cancellation: cancellation,
  );

  /// Change Protection
  /// Changes the protection configuration of a [Storage Box](#tag/storage-boxes).
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
  ///     "command": "change_protection",
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
  _i13.Future<
    _i14.TonikResult<
      _i24.ChangeStorageBoxProtectionResponse,
      _i16.Response<_i13.Object?>
    >
  >
  changeStorageBoxProtection({
    required _i25.StorageBoxesIdActionsChangeProtectionPostBodyBodyModel body,
    required _i13.int id,
    _i14.TonikCancellation? cancellation,
  }) async => this._changeStorageBoxProtection(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Change Type
  /// Changes the type of a [Storage Box](#tag/storage-boxes).
  ///
  /// Upgrades or downgrades a [Storage Box](#tag/storage-boxes) to another [Storage Box Type](#tag/storage-box-types).
  ///
  /// It is not possible to downgrade to a [Storage Box Type](#tag/storage-box-types) that offers less disk space
  /// than you are currently using.
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
  ///     "command": "change_type",
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
  _i13.Future<
    _i14.TonikResult<
      _i26.ChangeStorageBoxTypeResponse,
      _i16.Response<_i13.Object?>
    >
  >
  changeStorageBoxType({
    required _i27.StorageBoxesIdActionsChangeTypePostBodyBodyModel body,
    required _i13.int id,
    _i14.TonikCancellation? cancellation,
  }) async => this._changeStorageBoxType(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Reset Password
  /// Reset the password of a [Storage Box](#tag/storage-boxes).
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
  ///     "command": "reset_password",
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
  _i13.Future<
    _i14.TonikResult<
      _i28.ResetStorageBoxPasswordResponse,
      _i16.Response<_i13.Object?>
    >
  >
  resetStorageBoxPassword({
    required _i29.StorageBoxesIdActionsResetPasswordPostBodyBodyModel body,
    required _i13.int id,
    _i14.TonikCancellation? cancellation,
  }) async => this._resetStorageBoxPassword(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Update Access Settings
  /// Update access settings of a primary [Storage Box](#tag/storage-boxes) account.
  ///
  /// This endpoints supports partial updates. Omitted optional parameters do not result in any changes to the respective properties.
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
  ///     "command": "update_access_settings",
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
  _i13.Future<
    _i14.TonikResult<
      _i30.UpdateStorageBoxAccessSettingsResponse,
      _i16.Response<_i13.Object?>
    >
  >
  updateStorageBoxAccessSettings({
    required _i31.StorageBoxesIdActionsUpdateAccessSettingsPostBodyBodyModel
    body,
    required _i13.int id,
    _i14.TonikCancellation? cancellation,
  }) async => this._updateStorageBoxAccessSettings(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Rollback Snapshot
  /// Rolls back a [Storage Box](#tag/storage-boxes) to the given [Storage Box Snapshot](#tag/storage-box-snapshots).
  ///
  /// This will remove all newer [Storage Box Snapshot](#tag/storage-box-snapshots) and
  /// irrevocably delete all data that was since written to the [Storage Box](#tag/storage-boxes).
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
  ///     "command": "rollback_snapshot",
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
  _i13.Future<
    _i14.TonikResult<
      _i32.RollbackStorageBoxSnapshotResponse,
      _i16.Response<_i13.Object?>
    >
  >
  rollbackStorageBoxSnapshot({
    required _i33.StorageBoxesIdActionsRollbackSnapshotPostBodyBodyModel body,
    required _i13.int id,
    _i14.TonikCancellation? cancellation,
  }) async => this._rollbackStorageBoxSnapshot(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Disable Snapshot Plan
  /// Disables the active Snapshot Plan of a [Storage Box](#tag/storage-boxes).
  ///
  /// Existing [Storage Box Snapshots](#tag/storage-box-snapshots) created by the Snapshot
  /// Plan will not be delete, they must be removed manually.
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
  ///     "command": "disable_snapshot_plan",
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
  _i13.Future<
    _i14.TonikResult<
      _i34.DisableStorageBoxSnapshotPlanResponse,
      _i16.Response<_i13.Object?>
    >
  >
  disableStorageBoxSnapshotPlan({
    required _i13.int id,
    _i14.TonikCancellation? cancellation,
  }) async =>
      this._disableStorageBoxSnapshotPlan(id: id, cancellation: cancellation);

  /// Enable Snapshot Plan
  /// Enables a Snapshot Plan for a [Storage Box](#tag/storage-boxes).
  ///
  /// Once enabled, a Snapshot Plan will create Snapshots at predefined intervals.
  /// There can only ever be one Snapshot Plan. The existing Snapshot Plan will be deleted before a new one is set up.
  ///
  /// Automatic Snapshots are retained until explicitly deleted by the user or the maximum snapshot count for the plan ("max_snapshots") is exceeded.
  ///
  /// You can choose the specific time (UTC timezone), day of the week, and day of the month. The time-related options are cron like. Some typical use cases include:
  ///
  /// | Interval                                   | Request body                                                  |
  /// | ------------------------------------------ | ------------------------------------------------------------- |
  /// | Every day at 3 o'clock                     | `{"max_snapshots":10,"minute":0,"hour":3}`                    |
  /// | Every Friday at 3 o'clock                  | `{"max_snapshots":10,"minute":0,"hour":3,"day_of_week": 5}`   |
  /// | On the first of every month at half past 6 | `{"max_snapshots":10,"minute":30,"hour":6,"day_of_month": 1}` |
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
  ///     "command": "enable_snapshot_plan",
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
  _i13.Future<
    _i14.TonikResult<
      _i35.EnableStorageBoxSnapshotPlanResponse,
      _i16.Response<_i13.Object?>
    >
  >
  enableStorageBoxSnapshotPlan({
    required _i36.StorageBoxesIdActionsEnableSnapshotPlanPostBodyBodyModel body,
    required _i13.int id,
    _i14.TonikCancellation? cancellation,
  }) async => this._enableStorageBoxSnapshotPlan(
    body: body,
    id: id,
    cancellation: cancellation,
  );
}
