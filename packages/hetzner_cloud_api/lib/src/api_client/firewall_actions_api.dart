// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i9;

import 'package:dio/dio.dart' as _i12;
import 'package:hetzner_cloud_api/src/model/firewalls_actions_parameters_array_model.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/model/firewalls_actions_parameters_array_model2.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/model/firewalls_id_actions_apply_to_resources_post_body_body_model.dart'
    as _i20;
import 'package:hetzner_cloud_api/src/model/firewalls_id_actions_parameters_array_model.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/model/firewalls_id_actions_parameters_array_model2.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/model/firewalls_id_actions_remove_from_resources_post_body_body_model.dart'
    as _i22;
import 'package:hetzner_cloud_api/src/model/firewalls_id_actions_set_rules_post_body_body_model.dart'
    as _i24;
import 'package:hetzner_cloud_api/src/operation/apply_firewall_to_resources.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/operation/get_firewall_action.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/operation/get_firewalls_action.dart'
    as _i3;
import 'package:hetzner_cloud_api/src/operation/list_firewall_actions.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/operation/list_firewalls_actions.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/operation/remove_firewall_from_resources.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/operation/set_firewall_rules.dart' as _i7;
import 'package:hetzner_cloud_api/src/response_wrapper/apply_firewall_to_resources_response.dart'
    as _i19;
import 'package:hetzner_cloud_api/src/response_wrapper/get_firewall_action_response.dart'
    as _i25;
import 'package:hetzner_cloud_api/src/response_wrapper/get_firewalls_action_response.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/response_wrapper/list_firewall_actions_response.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/response_wrapper/list_firewalls_actions_response.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/response_wrapper/remove_firewall_from_resources_response.dart'
    as _i21;
import 'package:hetzner_cloud_api/src/response_wrapper/set_firewall_rules_response.dart'
    as _i23;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i10;

class FirewallActionsApi {
  FirewallActionsApi(_i1.Server server)
    : _listFirewallsActions = _i2.ListFirewallsActions(
        server.baseUrl,
        () => server.dio,
      ),
      _getFirewallsAction = _i3.GetFirewallsAction(
        server.baseUrl,
        () => server.dio,
      ),
      _listFirewallActions = _i4.ListFirewallActions(
        server.baseUrl,
        () => server.dio,
      ),
      _applyFirewallToResources = _i5.ApplyFirewallToResources(
        server.baseUrl,
        () => server.dio,
      ),
      _removeFirewallFromResources = _i6.RemoveFirewallFromResources(
        server.baseUrl,
        () => server.dio,
      ),
      _setFirewallRules = _i7.SetFirewallRules(
        server.baseUrl,
        () => server.dio,
      ),
      _getFirewallAction = _i8.GetFirewallAction(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListFirewallsActions _listFirewallsActions;

  final _i3.GetFirewallsAction _getFirewallsAction;

  final _i4.ListFirewallActions _listFirewallActions;

  final _i5.ApplyFirewallToResources _applyFirewallToResources;

  final _i6.RemoveFirewallFromResources _removeFirewallFromResources;

  final _i7.SetFirewallRules _setFirewallRules;

  final _i8.GetFirewallAction _getFirewallAction;

  /// List Actions
  /// Returns all [Actions](#tag/actions) for [Firewalls](#tag/firewalls).
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
  _i9.Future<
    _i10.TonikResult<
      _i11.ListFirewallsActionsResponse,
      _i12.Response<_i9.Object?>
    >
  >
  listFirewallsActions({
    _i9.List<_i9.int>? id,
    _i9.List<_i13.FirewallsActionsParametersArrayModel>? sort,
    _i9.List<_i14.FirewallsActionsParametersArrayModel2>? status,
    _i9.int page = _i2.ListFirewallsActions.pageDefault,
    _i9.int perPage = _i2.ListFirewallsActions.perPageDefault,
    _i10.TonikCancellation? cancellation,
  }) async => this._listFirewallsActions(
    id: id,
    sort: sort,
    status: status,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Get an Action
  /// Returns the specific [Action](#tag/actions).
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
  _i9.Future<
    _i10.TonikResult<
      _i15.GetFirewallsActionResponse,
      _i12.Response<_i9.Object?>
    >
  >
  getFirewallsAction({
    required _i9.int id,
    _i10.TonikCancellation? cancellation,
  }) async => this._getFirewallsAction(id: id, cancellation: cancellation);

  /// List Actions for a Firewall
  /// Returns all [Actions](#tag/actions) for the [Firewall](#tag/firewalls).
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
  ///       "command": "set_firewall_rules",
  ///       "status": "success",
  ///       "progress": 100,
  ///       "started": "2016-01-30T23:55:00Z",
  ///       "finished": "2016-01-30T23:56:00Z",
  ///       "resources": [
  ///         {
  ///           "id": 38,
  ///           "type": "firewall"
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
  _i9.Future<
    _i10.TonikResult<
      _i16.ListFirewallActionsResponse,
      _i12.Response<_i9.Object?>
    >
  >
  listFirewallActions({
    required _i9.int id,
    _i9.List<_i17.FirewallsIdActionsParametersArrayModel>? sort,
    _i9.List<_i18.FirewallsIdActionsParametersArrayModel2>? status,
    _i9.int page = _i4.ListFirewallActions.pageDefault,
    _i9.int perPage = _i4.ListFirewallActions.perPageDefault,
    _i10.TonikCancellation? cancellation,
  }) async => this._listFirewallActions(
    id: id,
    sort: sort,
    status: status,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Apply to Resources
  /// Applies a [Firewall](#tag/firewalls) to multiple resources.
  ///
  /// Supported resources:
  /// - [Servers](#tag/servers) (with a public network interface)
  /// - [Label Selectors](#description/label-selector)
  ///
  /// A [Server](#tag/servers) can be applied to [a maximum of 5 Firewalls](https://docs.hetzner.com/cloud/firewalls/overview#limits). This limit
  /// applies to [Servers](#tag/servers) applied via a matching [Label Selector](#description/label-selector) as well.
  ///
  /// Updates to resources matching or no longer matching a [Label Selector](#description/label-selector) can take up to a few seconds
  /// to be processed.
  ///
  /// A [Firewall](#tag/firewalls) is applied to a resource once the related [Action](#tag/actions) with command `apply_firewall` successfully finished.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `404` | `firewall_resource_not_found` | The resource the [Firewall](#tag/firewalls) should be applied to was not found |
  /// | `422` | `firewall_already_applied` | [Firewall](#tag/firewalls) is already applied to resource |
  /// | `422` | `incompatible_network_type` | The network type of the resource is not supported by [Firewalls](#tag/firewalls) |
  /// | `422` | `private_net_only_server` | The [Server](#tag/servers) the [Firewall](#tag/firewalls) should be applied to has no public interface |
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Request body (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "apply_to": [
  ///     {
  ///       "type": "server",
  ///       "server": {
  ///         "id": 42
  ///       }
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "actions": [
  ///     {
  ///       "id": 14,
  ///       "command": "apply_firewall",
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
  ///           "id": 38,
  ///           "type": "firewall"
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
  _i9.Future<
    _i10.TonikResult<
      _i19.ApplyFirewallToResourcesResponse,
      _i12.Response<_i9.Object?>
    >
  >
  applyFirewallToResources({
    required _i20.FirewallsIdActionsApplyToResourcesPostBodyBodyModel body,
    required _i9.int id,
    _i10.TonikCancellation? cancellation,
  }) async => this._applyFirewallToResources(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Remove from Resources
  /// Removes a [Firewall](#tag/firewalls) from multiple resources.
  ///
  /// Supported resources:
  /// - [Servers](#tag/servers) (with a public network interface)
  ///
  /// A [Firewall](#tag/firewalls) is removed from a resource once the related [Action](#tag/actions) with command `remove_firewall` successfully finished.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `404` | `firewall_resource_not_found` | The resource the [Firewall](#tag/firewalls) should be removed from was not found |
  /// | `422` | `firewall_managed_by_label_selector` | [Firewall](#tag/firewall) is applied via a [Label Selector](#description/label-selector) and cannot be removed manually |
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Request body (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "remove_from": [
  ///     {
  ///       "type": "server",
  ///       "server": {
  ///         "id": 42
  ///       }
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "actions": [
  ///     {
  ///       "id": 14,
  ///       "command": "remove_firewall",
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
  ///           "id": 38,
  ///           "type": "firewall"
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
  _i9.Future<
    _i10.TonikResult<
      _i21.RemoveFirewallFromResourcesResponse,
      _i12.Response<_i9.Object?>
    >
  >
  removeFirewallFromResources({
    required _i22.FirewallsIdActionsRemoveFromResourcesPostBodyBodyModel body,
    required _i9.int id,
    _i10.TonikCancellation? cancellation,
  }) async => this._removeFirewallFromResources(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Set Rules
  /// Set the rules of a [Firewall](#tag/firewalls).
  ///
  /// Overwrites the existing rules with the given ones. Pass an empty array to remove all rules.
  ///
  /// Rules are limited to 50 entries per [Firewall](#tag/firewalls) and [500 effective rules](https://docs.hetzner.com/cloud/firewalls/overview#limits).
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Request body (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "rules": [
  ///     {
  ///       "description": "Allow port 80",
  ///       "direction": "in",
  ///       "source_ips": [
  ///         "192.0.2.2/32",
  ///         "192.0.2.0/24",
  ///         "2001:0db8:9a3b:ee58:5ca:990c:8bc9:c03b/128"
  ///       ],
  ///       "protocol": "tcp",
  ///       "port": "80"
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "actions": [
  ///     {
  ///       "id": 13,
  ///       "command": "set_firewall_rules",
  ///       "status": "success",
  ///       "progress": 100,
  ///       "started": "2016-01-30T23:55:00Z",
  ///       "finished": "2016-01-30T23:56:00Z",
  ///       "resources": [
  ///         {
  ///           "id": 38,
  ///           "type": "firewall"
  ///         }
  ///       ],
  ///       "error": {
  ///         "code": "action_failed",
  ///         "message": "Action failed"
  ///       }
  ///     },
  ///     {
  ///       "id": 14,
  ///       "command": "apply_firewall",
  ///       "status": "success",
  ///       "progress": 100,
  ///       "started": "2016-01-30T23:55:00Z",
  ///       "finished": "2016-01-30T23:56:00Z",
  ///       "resources": [
  ///         {
  ///           "id": 38,
  ///           "type": "firewall"
  ///         },
  ///         {
  ///           "id": 42,
  ///           "type": "server"
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
  _i9.Future<
    _i10.TonikResult<_i23.SetFirewallRulesResponse, _i12.Response<_i9.Object?>>
  >
  setFirewallRules({
    required _i24.FirewallsIdActionsSetRulesPostBodyBodyModel body,
    required _i9.int id,
    _i10.TonikCancellation? cancellation,
  }) async =>
      this._setFirewallRules(body: body, id: id, cancellation: cancellation);

  /// Get an Action for a Firewall
  /// **Deprecated**: This operation is deprecated, see our [changelog](https://docs.hetzner.cloud/changelog#2026-04-30-deprecate-get-resource-action-endpoints) for more details.
  ///
  /// Returns a specific [Action](#tag/actions) for a [Firewall](#tag/firewalls).
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
  ///     "command": "set_firewall_rules",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": "2016-01-30T23:56:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 38,
  ///         "type": "firewall"
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
  @_i9.Deprecated('This operation is deprecated.')
  _i9.Future<
    _i10.TonikResult<_i25.GetFirewallActionResponse, _i12.Response<_i9.Object?>>
  >
  getFirewallAction({
    required _i9.int id,
    required _i9.int actionId,
    _i10.TonikCancellation? cancellation,
  }) async => this._getFirewallAction(
    id: id,
    actionId: actionId,
    cancellation: cancellation,
  );
}
