// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i10;

import 'package:dio/dio.dart' as _i13;
import 'package:hetzner_cloud_api/src/model/floating_ips_actions_parameters_array_model.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/model/floating_ips_actions_parameters_array_model2.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/model/floating_ips_id_actions_assign_post_body_body_model.dart'
    as _i21;
import 'package:hetzner_cloud_api/src/model/floating_ips_id_actions_change_dns_ptr_post_body_body_model.dart'
    as _i23;
import 'package:hetzner_cloud_api/src/model/floating_ips_id_actions_change_protection_post_body_body_model.dart'
    as _i25;
import 'package:hetzner_cloud_api/src/model/floating_ips_id_actions_parameters_array_model.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/model/floating_ips_id_actions_parameters_array_model2.dart'
    as _i19;
import 'package:hetzner_cloud_api/src/operation/assign_floating_ip.dart' as _i5;
import 'package:hetzner_cloud_api/src/operation/change_floating_ip_dns_ptr.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/operation/change_floating_ip_protection.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/operation/get_floating_ip_action.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/operation/get_floating_ips_action.dart'
    as _i3;
import 'package:hetzner_cloud_api/src/operation/list_floating_ip_actions.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/operation/list_floating_ips_actions.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/operation/unassign_floating_ip.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/response_wrapper/assign_floating_ip_response.dart'
    as _i20;
import 'package:hetzner_cloud_api/src/response_wrapper/change_floating_ip_dns_ptr_response.dart'
    as _i22;
import 'package:hetzner_cloud_api/src/response_wrapper/change_floating_ip_protection_response.dart'
    as _i24;
import 'package:hetzner_cloud_api/src/response_wrapper/get_floating_ip_action_response.dart'
    as _i27;
import 'package:hetzner_cloud_api/src/response_wrapper/get_floating_ips_action_response.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/response_wrapper/list_floating_ip_actions_response.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/response_wrapper/list_floating_ips_actions_response.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/response_wrapper/unassign_floating_ip_response.dart'
    as _i26;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i11;

class FloatingIpActionsApi {
  FloatingIpActionsApi(_i1.Server server)
    : _listFloatingIpsActions = _i2.ListFloatingIpsActions(
        server.baseUrl,
        () => server.dio,
      ),
      _getFloatingIpsAction = _i3.GetFloatingIpsAction(
        server.baseUrl,
        () => server.dio,
      ),
      _listFloatingIpActions = _i4.ListFloatingIpActions(
        server.baseUrl,
        () => server.dio,
      ),
      _assignFloatingIp = _i5.AssignFloatingIp(
        server.baseUrl,
        () => server.dio,
      ),
      _changeFloatingIpDnsPtr = _i6.ChangeFloatingIpDnsPtr(
        server.baseUrl,
        () => server.dio,
      ),
      _changeFloatingIpProtection = _i7.ChangeFloatingIpProtection(
        server.baseUrl,
        () => server.dio,
      ),
      _unassignFloatingIp = _i8.UnassignFloatingIp(
        server.baseUrl,
        () => server.dio,
      ),
      _getFloatingIpAction = _i9.GetFloatingIpAction(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListFloatingIpsActions _listFloatingIpsActions;

  final _i3.GetFloatingIpsAction _getFloatingIpsAction;

  final _i4.ListFloatingIpActions _listFloatingIpActions;

  final _i5.AssignFloatingIp _assignFloatingIp;

  final _i6.ChangeFloatingIpDnsPtr _changeFloatingIpDnsPtr;

  final _i7.ChangeFloatingIpProtection _changeFloatingIpProtection;

  final _i8.UnassignFloatingIp _unassignFloatingIp;

  final _i9.GetFloatingIpAction _getFloatingIpAction;

  /// List Actions
  /// Lists multiple [Actions](#tag/actions).
  ///
  /// Use the provided URI parameters to modify the result.
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
      _i12.ListFloatingIpsActionsResponse,
      _i13.Response<_i10.Object?>
    >
  >
  listFloatingIpsActions({
    _i10.List<_i10.int>? id,
    _i10.List<_i14.FloatingIpsActionsParametersArrayModel>? sort,
    _i10.List<_i15.FloatingIpsActionsParametersArrayModel2>? status,
    _i10.int page = _i2.ListFloatingIpsActions.pageDefault,
    _i10.int perPage = _i2.ListFloatingIpsActions.perPageDefault,
    _i11.TonikCancellation? cancellation,
  }) async => this._listFloatingIpsActions(
    id: id,
    sort: sort,
    status: status,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Get an Action
  /// Returns a single [Action](#tag/actions).
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
      _i16.GetFloatingIpsActionResponse,
      _i13.Response<_i10.Object?>
    >
  >
  getFloatingIpsAction({
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async => this._getFloatingIpsAction(id: id, cancellation: cancellation);

  /// List Actions for a Floating IP
  /// Lists [Actions](#tag/actions) for a [Floating IP](#tag/floating-ips).
  ///
  /// Use the provided URI parameters to modify the result.
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
  ///       "command": "assign_floating_ip",
  ///       "status": "success",
  ///       "progress": 100,
  ///       "started": "2016-01-30T23:55:00Z",
  ///       "finished": "2016-01-30T23:56:00Z",
  ///       "resources": [
  ///         {
  ///           "id": 4711,
  ///           "type": "server"
  ///         },
  ///         {
  ///           "id": 4712,
  ///           "type": "floating_ip"
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
      _i17.ListFloatingIpActionsResponse,
      _i13.Response<_i10.Object?>
    >
  >
  listFloatingIpActions({
    required _i10.int id,
    _i10.List<_i18.FloatingIpsIdActionsParametersArrayModel>? sort,
    _i10.List<_i19.FloatingIpsIdActionsParametersArrayModel2>? status,
    _i10.int page = _i4.ListFloatingIpActions.pageDefault,
    _i10.int perPage = _i4.ListFloatingIpActions.perPageDefault,
    _i11.TonikCancellation? cancellation,
  }) async => this._listFloatingIpActions(
    id: id,
    sort: sort,
    status: status,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Assign a Floating IP to a Server
  /// Assigns a [Floating IP](#tag/floating-ips) to a [Server](#tag/servers).
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `floating_ip_assigned` | The [Floating IP](#tag/floating-ips) is already assigned |
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
  ///     "command": "assign_floating_ip",
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
  ///         "id": 4711,
  ///         "type": "floating_ip"
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
    _i11.TonikResult<_i20.AssignFloatingIpResponse, _i13.Response<_i10.Object?>>
  >
  assignFloatingIp({
    required _i21.FloatingIpsIdActionsAssignPostBodyBodyModel body,
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async =>
      this._assignFloatingIp(body: body, id: id, cancellation: cancellation);

  /// Change reverse DNS records for a Floating IP
  /// Change the reverse DNS records for this [Floating IP](#tag/floating-ips).
  ///
  /// Allows to modify the PTR records set for the IP address.
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
  ///     "command": "change_dns_ptr",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": "2016-01-30T23:56:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 4711,
  ///         "type": "floating_ip"
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
      _i22.ChangeFloatingIpDnsPtrResponse,
      _i13.Response<_i10.Object?>
    >
  >
  changeFloatingIpDnsPtr({
    required _i23.FloatingIpsIdActionsChangeDnsPtrPostBodyBodyModel body,
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async => this._changeFloatingIpDnsPtr(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Change Floating IP Protection
  /// Changes the protection settings configured for the [Floating IP](#tag/floating-ips).
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
  ///         "type": "floating_ip"
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
      _i24.ChangeFloatingIpProtectionResponse,
      _i13.Response<_i10.Object?>
    >
  >
  changeFloatingIpProtection({
    required _i25.FloatingIpsIdActionsChangeProtectionPostBodyBodyModel body,
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async => this._changeFloatingIpProtection(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Unassign a Floating IP
  /// Unassigns a [Floating IP](#tag/floating-ips).
  ///
  /// Results in the IP being unreachable. Can be assigned to another resource again.
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
  ///     "command": "unassign_floating_ip",
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
  ///         "id": 4711,
  ///         "type": "floating_ip"
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
      _i26.UnassignFloatingIpResponse,
      _i13.Response<_i10.Object?>
    >
  >
  unassignFloatingIp({
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async => this._unassignFloatingIp(id: id, cancellation: cancellation);

  /// Get an Action for a Floating IP
  /// **Deprecated**: This operation is deprecated, see our [changelog](https://docs.hetzner.cloud/changelog#2026-04-30-deprecate-get-resource-action-endpoints) for more details.
  ///
  /// Returns a specific [Action](#tag/actions) for a [Floating IP](#tag/floating-ips).
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
  ///     "command": "assign_floating_ip",
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
  ///         "id": 4711,
  ///         "type": "floating_ip"
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
    _i11.TonikResult<
      _i27.GetFloatingIpActionResponse,
      _i13.Response<_i10.Object?>
    >
  >
  getFloatingIpAction({
    required _i10.int id,
    required _i10.int actionId,
    _i11.TonikCancellation? cancellation,
  }) async => this._getFloatingIpAction(
    id: id,
    actionId: actionId,
    cancellation: cancellation,
  );
}
