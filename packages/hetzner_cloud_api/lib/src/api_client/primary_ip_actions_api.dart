// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i10;

import 'package:dio/dio.dart' as _i13;
import 'package:hetzner_cloud_api/src/model/primary_ips_actions_parameters_array_model.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/model/primary_ips_actions_parameters_array_model2.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_assign_post_body_body_model.dart'
    as _i22;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_change_dns_ptr_post_body_body_model.dart'
    as _i24;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_change_protection_post_body_body_model.dart'
    as _i26;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_parameters_array_model.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_actions_parameters_array_model2.dart'
    as _i19;
import 'package:hetzner_cloud_api/src/operation/assign_primary_ip.dart' as _i6;
import 'package:hetzner_cloud_api/src/operation/change_primary_ip_dns_ptr.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/operation/change_primary_ip_protection.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/operation/get_primary_ip_action.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/operation/get_primary_ips_action.dart'
    as _i3;
import 'package:hetzner_cloud_api/src/operation/list_primary_ip_actions.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/operation/list_primary_ips_actions.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/operation/unassign_primary_ip.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/response_wrapper/assign_primary_ip_response.dart'
    as _i21;
import 'package:hetzner_cloud_api/src/response_wrapper/change_primary_ip_dns_ptr_response.dart'
    as _i23;
import 'package:hetzner_cloud_api/src/response_wrapper/change_primary_ip_protection_response.dart'
    as _i25;
import 'package:hetzner_cloud_api/src/response_wrapper/get_primary_ip_action_response.dart'
    as _i20;
import 'package:hetzner_cloud_api/src/response_wrapper/get_primary_ips_action_response.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/response_wrapper/list_primary_ip_actions_response.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/response_wrapper/list_primary_ips_actions_response.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/response_wrapper/unassign_primary_ip_response.dart'
    as _i27;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i11;

class PrimaryIpActionsApi {
  PrimaryIpActionsApi(_i1.Server server)
    : _listPrimaryIpsActions = _i2.ListPrimaryIpsActions(
        server.baseUrl,
        () => server.dio,
      ),
      _getPrimaryIpsAction = _i3.GetPrimaryIpsAction(
        server.baseUrl,
        () => server.dio,
      ),
      _listPrimaryIpActions = _i4.ListPrimaryIpActions(
        server.baseUrl,
        () => server.dio,
      ),
      _getPrimaryIpAction = _i5.GetPrimaryIpAction(
        server.baseUrl,
        () => server.dio,
      ),
      _assignPrimaryIp = _i6.AssignPrimaryIp(server.baseUrl, () => server.dio),
      _changePrimaryIpDnsPtr = _i7.ChangePrimaryIpDnsPtr(
        server.baseUrl,
        () => server.dio,
      ),
      _changePrimaryIpProtection = _i8.ChangePrimaryIpProtection(
        server.baseUrl,
        () => server.dio,
      ),
      _unassignPrimaryIp = _i9.UnassignPrimaryIp(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListPrimaryIpsActions _listPrimaryIpsActions;

  final _i3.GetPrimaryIpsAction _getPrimaryIpsAction;

  final _i4.ListPrimaryIpActions _listPrimaryIpActions;

  final _i5.GetPrimaryIpAction _getPrimaryIpAction;

  final _i6.AssignPrimaryIp _assignPrimaryIp;

  final _i7.ChangePrimaryIpDnsPtr _changePrimaryIpDnsPtr;

  final _i8.ChangePrimaryIpProtection _changePrimaryIpProtection;

  final _i9.UnassignPrimaryIp _unassignPrimaryIp;

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
      _i12.ListPrimaryIpsActionsResponse,
      _i13.Response<_i10.Object?>
    >
  >
  listPrimaryIpsActions({
    _i10.List<_i10.int>? id,
    _i10.List<_i14.PrimaryIpsActionsParametersArrayModel>? sort,
    _i10.List<_i15.PrimaryIpsActionsParametersArrayModel2>? status,
    _i10.int page = _i2.ListPrimaryIpsActions.pageDefault,
    _i10.int perPage = _i2.ListPrimaryIpsActions.perPageDefault,
    _i11.TonikCancellation? cancellation,
  }) async => this._listPrimaryIpsActions(
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
      _i16.GetPrimaryIpsActionResponse,
      _i13.Response<_i10.Object?>
    >
  >
  getPrimaryIpsAction({
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async => this._getPrimaryIpsAction(id: id, cancellation: cancellation);

  /// List Actions for a Primary IP
  /// Returns all [Actions](#tag/actions) for a [Primary IP](#tag/primary-ips).
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
      _i17.ListPrimaryIpActionsResponse,
      _i13.Response<_i10.Object?>
    >
  >
  listPrimaryIpActions({
    required _i10.int id,
    _i10.List<_i18.PrimaryIpsIdActionsParametersArrayModel>? sort,
    _i10.List<_i19.PrimaryIpsIdActionsParametersArrayModel2>? status,
    _i10.int page = _i4.ListPrimaryIpActions.pageDefault,
    _i10.int perPage = _i4.ListPrimaryIpActions.perPageDefault,
    _i11.TonikCancellation? cancellation,
  }) async => this._listPrimaryIpActions(
    id: id,
    sort: sort,
    status: status,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Get an Action for a Primary IP
  /// **Deprecated**: This operation is deprecated, see our [changelog](https://docs.hetzner.cloud/changelog#2026-04-30-deprecate-get-resource-action-endpoints) for more details.
  ///
  /// Returns a specific [Action](#tag/actions) for a [Primary IP](#tag/primary-ips).
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
  @_i10.Deprecated('This operation is deprecated.')
  _i10.Future<
    _i11.TonikResult<
      _i20.GetPrimaryIpActionResponse,
      _i13.Response<_i10.Object?>
    >
  >
  getPrimaryIpAction({
    required _i10.int id,
    required _i10.int actionId,
    _i11.TonikCancellation? cancellation,
  }) async => this._getPrimaryIpAction(
    id: id,
    actionId: actionId,
    cancellation: cancellation,
  );

  /// Assign a Primary IP to a resource
  /// Assign a [Primary IP](#tag/primary-ips) to a resource.
  ///
  /// A [Server](#tag/servers) can only have one [Primary IP](#tag/primary-ips) of type `ipv4` and one of type `ipv6` assigned. If you need more IPs use [Floating IPs](#tag/floating-ips).
  ///
  /// A [Server](#tag/servers) must be powered off (status `off`) in order for this operation to succeed.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `server_not_stopped` | The [Server](#tag/servers) is running, but needs to be powered off |
  /// | `422` | `primary_ip_already_assigned` | [Primary IP](#tag/primary-ips) is already assigned to a different [Server](#tag/servers) |
  /// | `422` | `server_has_ipv4` | The [Server](#tag/servers) already has an IPv4 address |
  /// | `422` | `server_has_ipv6` | The [Server](#tag/servers) already has an IPv6 address |
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
  ///     "command": "assign_primary_ip",
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
  ///         "id": 4711,
  ///         "type": "primary_ip"
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
    _i11.TonikResult<_i21.AssignPrimaryIpResponse, _i13.Response<_i10.Object?>>
  >
  assignPrimaryIp({
    required _i22.PrimaryIpsIdActionsAssignPostBodyBodyModel body,
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async =>
      this._assignPrimaryIp(body: body, id: id, cancellation: cancellation);

  /// Change reverse DNS records for a Primary IP
  /// Change the reverse DNS records for this [Primary IP](#tag/primary-ips).
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
  ///         "type": "primary_ip"
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
      _i23.ChangePrimaryIpDnsPtrResponse,
      _i13.Response<_i10.Object?>
    >
  >
  changePrimaryIpDnsPtr({
    required _i24.PrimaryIpsIdActionsChangeDnsPtrPostBodyBodyModel body,
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async => this._changePrimaryIpDnsPtr(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Change Primary IP Protection
  /// Changes the protection configuration of a [Primary IP](#tag/primary-ips).
  ///
  /// A [Primary IPs](#tag/primary-ips) deletion protection can only be enabled if its `auto_delete` property is set to `false`.
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
  ///         "type": "primary_ip"
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
      _i25.ChangePrimaryIpProtectionResponse,
      _i13.Response<_i10.Object?>
    >
  >
  changePrimaryIpProtection({
    required _i26.PrimaryIpsIdActionsChangeProtectionPostBodyBodyModel body,
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async => this._changePrimaryIpProtection(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Unassign a Primary IP from a resource
  /// Unassign a [Primary IP](#tag/primary-ips) from a resource.
  ///
  /// A [Server](#tag/servers) must be powered off (status `off`) in order for this operation to succeed.
  ///
  /// A [Server](#tag/servers) requires at least one network interface (public or private) to be powered on.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `server_not_stopped` | The [Server](#tag/servers) is running, but needs to be powered off |
  /// | `422` | `server_is_load_balancer_target` | The [Server](#tag/servers) IPv4 address is a loadbalancer target |
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
  ///     "command": "unassign_primary_ip",
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
  ///         "id": 4711,
  ///         "type": "primary_ip"
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
      _i27.UnassignPrimaryIpResponse,
      _i13.Response<_i10.Object?>
    >
  >
  unassignPrimaryIp({
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async => this._unassignPrimaryIp(id: id, cancellation: cancellation);
}
