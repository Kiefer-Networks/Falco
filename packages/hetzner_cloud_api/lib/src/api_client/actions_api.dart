// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i4;

import 'package:dio/dio.dart' as _i7;
import 'package:hetzner_cloud_api/src/operation/get_action.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/get_actions.dart' as _i2;
import 'package:hetzner_cloud_api/src/response_wrapper/get_action_response.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/response_wrapper/get_actions_response.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i5;

/// Actions represent asynchronous tasks within the API, targeting one or more resources.
///
/// See [Actions](#description/actions) for more details.
///
class ActionsApi {
  ActionsApi(_i1.Server server)
    : _getActions = _i2.GetActions(server.baseUrl, () => server.dio),
      _getAction = _i3.GetAction(server.baseUrl, () => server.dio);

  final _i2.GetActions _getActions;

  final _i3.GetAction _getAction;

  /// Get multiple Actions
  /// Returns multiple Action objects specified by the `id` parameter.
  ///
  /// **Note**: This endpoint previously allowed listing all actions in the project. This functionality was deprecated in July 2023 and removed on 30 January 2025.
  ///
  /// - Announcement: https://docs.hetzner.cloud/changelog#2023-07-20-actions-list-endpoint-is-deprecated
  /// - Removal: https://docs.hetzner.cloud/changelog#2025-01-30-listing-arbitrary-actions-in-the-actions-list-endpoint-is-removed
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
  _i4.Future<_i5.TonikResult<_i6.GetActionsResponse, _i7.Response<_i4.Object?>>>
  getActions({
    required _i4.List<_i4.int> id,
    _i5.TonikCancellation? cancellation,
  }) async => this._getActions(id: id, cancellation: cancellation);

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
  _i4.Future<_i5.TonikResult<_i8.GetActionResponse, _i7.Response<_i4.Object?>>>
  getAction({required _i4.int id, _i5.TonikCancellation? cancellation}) async =>
      this._getAction(id: id, cancellation: cancellation);
}
