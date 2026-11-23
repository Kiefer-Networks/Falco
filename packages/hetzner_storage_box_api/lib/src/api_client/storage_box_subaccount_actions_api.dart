// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i5;

import 'package:dio/dio.dart' as _i8;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_actions_change_home_directory_post_body_body_model.dart'
    as _i9;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_actions_reset_subaccount_password_post_body_body_model.dart'
    as _i11;
import 'package:hetzner_storage_box_api/src/model/storage_boxes_id_subaccounts_subaccount_id_actions_update_access_settings_post_body_body_model.dart'
    as _i13;
import 'package:hetzner_storage_box_api/src/operation/change_storage_box_subaccount_home_directory.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/operation/reset_storage_box_subaccount_password.dart'
    as _i3;
import 'package:hetzner_storage_box_api/src/operation/update_storage_box_subaccount_access_settings.dart'
    as _i4;
import 'package:hetzner_storage_box_api/src/response_wrapper/change_storage_box_subaccount_home_directory_response.dart'
    as _i7;
import 'package:hetzner_storage_box_api/src/response_wrapper/reset_storage_box_subaccount_password_response.dart'
    as _i10;
import 'package:hetzner_storage_box_api/src/response_wrapper/update_storage_box_subaccount_access_settings_response.dart'
    as _i12;
import 'package:hetzner_storage_box_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i6;

class StorageBoxSubaccountActionsApi {
  StorageBoxSubaccountActionsApi(_i1.Server server)
    : _changeStorageBoxSubaccountHomeDirectory =
          _i2.ChangeStorageBoxSubaccountHomeDirectory(
            server.baseUrl,
            () => server.dio,
          ),
      _resetStorageBoxSubaccountPassword =
          _i3.ResetStorageBoxSubaccountPassword(
            server.baseUrl,
            () => server.dio,
          ),
      _updateStorageBoxSubaccountAccessSettings =
          _i4.UpdateStorageBoxSubaccountAccessSettings(
            server.baseUrl,
            () => server.dio,
          );

  final _i2.ChangeStorageBoxSubaccountHomeDirectory
  _changeStorageBoxSubaccountHomeDirectory;

  final _i3.ResetStorageBoxSubaccountPassword
  _resetStorageBoxSubaccountPassword;

  final _i4.UpdateStorageBoxSubaccountAccessSettings
  _updateStorageBoxSubaccountAccessSettings;

  /// Change Home Directory
  /// Change the home directory of a [Storage Box Subaccount](#tag/storage-box-subaccounts).
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
  ///     "command": "change_home_directory",
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
  _i5.Future<
    _i6.TonikResult<
      _i7.ChangeStorageBoxSubaccountHomeDirectoryResponse,
      _i8.Response<_i5.Object?>
    >
  >
  changeStorageBoxSubaccountHomeDirectory({
    required _i9.StorageBoxesIdSubaccountsSubaccountIdActionsChangeHomeDirectoryPostBodyBodyModel
    body,
    required _i5.int id,
    required _i5.int subaccountId,
    _i6.TonikCancellation? cancellation,
  }) async => this._changeStorageBoxSubaccountHomeDirectory(
    body: body,
    id: id,
    subaccountId: subaccountId,
    cancellation: cancellation,
  );

  /// Reset Password
  /// Reset the password of a [Storage Box Subaccount](#tag/storage-box-subaccounts).
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
  ///     "command": "reset_subaccount_password",
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
  _i5.Future<
    _i6.TonikResult<
      _i10.ResetStorageBoxSubaccountPasswordResponse,
      _i8.Response<_i5.Object?>
    >
  >
  resetStorageBoxSubaccountPassword({
    required _i11.StorageBoxesIdSubaccountsSubaccountIdActionsResetSubaccountPasswordPostBodyBodyModel
    body,
    required _i5.int id,
    required _i5.int subaccountId,
    _i6.TonikCancellation? cancellation,
  }) async => this._resetStorageBoxSubaccountPassword(
    body: body,
    id: id,
    subaccountId: subaccountId,
    cancellation: cancellation,
  );

  /// Update Access Settings
  /// Updates the access settings of a [Storage Box Subaccount](#tag/storage-box-subaccounts).
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
  _i5.Future<
    _i6.TonikResult<
      _i12.UpdateStorageBoxSubaccountAccessSettingsResponse,
      _i8.Response<_i5.Object?>
    >
  >
  updateStorageBoxSubaccountAccessSettings({
    required _i13.StorageBoxesIdSubaccountsSubaccountIdActionsUpdateAccessSettingsPostBodyBodyModel
    body,
    required _i5.int id,
    required _i5.int subaccountId,
    _i6.TonikCancellation? cancellation,
  }) async => this._updateStorageBoxSubaccountAccessSettings(
    body: body,
    id: id,
    subaccountId: subaccountId,
    cancellation: cancellation,
  );
}
