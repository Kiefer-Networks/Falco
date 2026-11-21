// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i12;

import 'package:dio/dio.dart' as _i15;
import 'package:hetzner_cloud_api/src/model/networks_actions_parameters_array_model.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/model/networks_actions_parameters_array_model2.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_add_route_post_body_body_model.dart'
    as _i23;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_add_subnet_post_body_body_model.dart'
    as _i25;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_change_ip_range_post_body_body_model.dart'
    as _i27;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_change_protection_post_body_body_model.dart'
    as _i29;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_delete_route_post_body_body_model.dart'
    as _i31;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_delete_subnet_post_body_body_model.dart'
    as _i33;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_parameters_array_model.dart'
    as _i20;
import 'package:hetzner_cloud_api/src/model/networks_id_actions_parameters_array_model2.dart'
    as _i21;
import 'package:hetzner_cloud_api/src/operation/add_network_route.dart' as _i5;
import 'package:hetzner_cloud_api/src/operation/add_network_subnet.dart' as _i6;
import 'package:hetzner_cloud_api/src/operation/change_network_ip_range.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/operation/change_network_protection.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/operation/delete_network_route.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/operation/delete_network_subnet.dart'
    as _i10;
import 'package:hetzner_cloud_api/src/operation/get_network_action.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/operation/get_networks_action.dart'
    as _i3;
import 'package:hetzner_cloud_api/src/operation/list_network_actions.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/operation/list_networks_actions.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/response_wrapper/add_network_route_response.dart'
    as _i22;
import 'package:hetzner_cloud_api/src/response_wrapper/add_network_subnet_response.dart'
    as _i24;
import 'package:hetzner_cloud_api/src/response_wrapper/change_network_ip_range_response.dart'
    as _i26;
import 'package:hetzner_cloud_api/src/response_wrapper/change_network_protection_response.dart'
    as _i28;
import 'package:hetzner_cloud_api/src/response_wrapper/delete_network_route_response.dart'
    as _i30;
import 'package:hetzner_cloud_api/src/response_wrapper/delete_network_subnet_response.dart'
    as _i32;
import 'package:hetzner_cloud_api/src/response_wrapper/get_network_action_response.dart'
    as _i34;
import 'package:hetzner_cloud_api/src/response_wrapper/get_networks_action_response.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/response_wrapper/list_network_actions_response.dart'
    as _i19;
import 'package:hetzner_cloud_api/src/response_wrapper/list_networks_actions_response.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i13;

class NetworkActionsApi {
  NetworkActionsApi(_i1.Server server)
    : _listNetworksActions = _i2.ListNetworksActions(
        server.baseUrl,
        () => server.dio,
      ),
      _getNetworksAction = _i3.GetNetworksAction(
        server.baseUrl,
        () => server.dio,
      ),
      _listNetworkActions = _i4.ListNetworkActions(
        server.baseUrl,
        () => server.dio,
      ),
      _addNetworkRoute = _i5.AddNetworkRoute(server.baseUrl, () => server.dio),
      _addNetworkSubnet = _i6.AddNetworkSubnet(
        server.baseUrl,
        () => server.dio,
      ),
      _changeNetworkIpRange = _i7.ChangeNetworkIpRange(
        server.baseUrl,
        () => server.dio,
      ),
      _changeNetworkProtection = _i8.ChangeNetworkProtection(
        server.baseUrl,
        () => server.dio,
      ),
      _deleteNetworkRoute = _i9.DeleteNetworkRoute(
        server.baseUrl,
        () => server.dio,
      ),
      _deleteNetworkSubnet = _i10.DeleteNetworkSubnet(
        server.baseUrl,
        () => server.dio,
      ),
      _getNetworkAction = _i11.GetNetworkAction(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListNetworksActions _listNetworksActions;

  final _i3.GetNetworksAction _getNetworksAction;

  final _i4.ListNetworkActions _listNetworkActions;

  final _i5.AddNetworkRoute _addNetworkRoute;

  final _i6.AddNetworkSubnet _addNetworkSubnet;

  final _i7.ChangeNetworkIpRange _changeNetworkIpRange;

  final _i8.ChangeNetworkProtection _changeNetworkProtection;

  final _i9.DeleteNetworkRoute _deleteNetworkRoute;

  final _i10.DeleteNetworkSubnet _deleteNetworkSubnet;

  final _i11.GetNetworkAction _getNetworkAction;

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
  _i12.Future<
    _i13.TonikResult<
      _i14.ListNetworksActionsResponse,
      _i15.Response<_i12.Object?>
    >
  >
  listNetworksActions({
    _i12.List<_i12.int>? id,
    _i12.List<_i16.NetworksActionsParametersArrayModel>? sort,
    _i12.List<_i17.NetworksActionsParametersArrayModel2>? status,
    _i12.int page = _i2.ListNetworksActions.pageDefault,
    _i12.int perPage = _i2.ListNetworksActions.perPageDefault,
    _i13.TonikCancellation? cancellation,
  }) async => this._listNetworksActions(
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
  _i12.Future<
    _i13.TonikResult<
      _i18.GetNetworksActionResponse,
      _i15.Response<_i12.Object?>
    >
  >
  getNetworksAction({
    required _i12.int id,
    _i13.TonikCancellation? cancellation,
  }) async => this._getNetworksAction(id: id, cancellation: cancellation);

  /// List Actions for a Network
  /// Lists [Actions](#tag/actions) for a [Network](#tag/networks).
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
  ///       "command": "add_subnet",
  ///       "status": "success",
  ///       "progress": 100,
  ///       "started": "2016-01-30T23:55:00Z",
  ///       "finished": "2016-01-30T23:56:00Z",
  ///       "resources": [
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
  _i12.Future<
    _i13.TonikResult<
      _i19.ListNetworkActionsResponse,
      _i15.Response<_i12.Object?>
    >
  >
  listNetworkActions({
    required _i12.int id,
    _i12.List<_i20.NetworksIdActionsParametersArrayModel>? sort,
    _i12.List<_i21.NetworksIdActionsParametersArrayModel2>? status,
    _i12.int page = _i4.ListNetworkActions.pageDefault,
    _i12.int perPage = _i4.ListNetworkActions.perPageDefault,
    _i13.TonikCancellation? cancellation,
  }) async => this._listNetworkActions(
    id: id,
    sort: sort,
    status: status,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Add a route to a Network
  /// Adds a route entry to a [Network](#tag/networks).
  ///
  /// If a change is currently being performed on this [Network](#tag/networks), a error response with code `conflict` will be returned.
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
  ///     "command": "add_route",
  ///     "status": "running",
  ///     "progress": 0,
  ///     "started": "2016-01-30T23:50:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 4711,
  ///         "type": "network"
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
  _i12.Future<
    _i13.TonikResult<_i22.AddNetworkRouteResponse, _i15.Response<_i12.Object?>>
  >
  addNetworkRoute({
    required _i23.NetworksIdActionsAddRoutePostBodyBodyModel body,
    required _i12.int id,
    _i13.TonikCancellation? cancellation,
  }) async =>
      this._addNetworkRoute(body: body, id: id, cancellation: cancellation);

  /// Add a subnet to a Network
  /// Adds a new subnet to the [Network](#tag/networks).
  ///
  /// If the subnet `ip_range` is not provided, the first available `/24` IP range will be used.
  ///
  /// If a change is currently being performed on this [Network](#tag/networks), a error response with code `conflict` will be returned.
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
  ///     "command": "add_subnet",
  ///     "status": "running",
  ///     "progress": 0,
  ///     "started": "2016-01-30T23:50:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 4711,
  ///         "type": "network"
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
  _i12.Future<
    _i13.TonikResult<_i24.AddNetworkSubnetResponse, _i15.Response<_i12.Object?>>
  >
  addNetworkSubnet({
    required _i25.NetworksIdActionsAddSubnetPostBodyBodyModel body,
    required _i12.int id,
    _i13.TonikCancellation? cancellation,
  }) async =>
      this._addNetworkSubnet(body: body, id: id, cancellation: cancellation);

  /// Change IP range of a Network
  /// Changes the IP range of a [Network](#tag/networks).
  ///
  /// The following restrictions apply to changing the IP range:
  /// - IP ranges can only be extended and never shrunk.
  /// - IPs can only be added to the end of the existing range, therefore only the netmask is allowed to be changed.
  /// - The Network must not have any attached members.
  ///
  /// To update the routes on the connected [Servers](#tag/servers), they need to be rebooted or the routes to be updated manually.
  ///
  /// For example if the [Network](#tag/networks) has a range of `10.0.0.0/16` to extend it the new range has to start with the IP `10.0.0.0` as well. The netmask `/16` can be changed to a smaller one then `16` therefore increasing the IP range. A valid entry would be `10.0.0.0/15`, `10.0.0.0/14` or `10.0.0.0/13` and so on.
  ///
  /// If a change is currently being performed on this [Network](#tag/networks), an error response with code `conflict` will be returned. If the Network has any attached members, an error response with code `service_error` will be returned.
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
  ///     "command": "change_ip_range",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": "2016-01-30T23:56:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 4711,
  ///         "type": "network"
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
  _i12.Future<
    _i13.TonikResult<
      _i26.ChangeNetworkIpRangeResponse,
      _i15.Response<_i12.Object?>
    >
  >
  changeNetworkIpRange({
    required _i27.NetworksIdActionsChangeIpRangePostBodyBodyModel body,
    required _i12.int id,
    _i13.TonikCancellation? cancellation,
  }) async => this._changeNetworkIpRange(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Change Network Protection
  /// Changes the protection settings of a [Network](#tag/networks).
  ///
  /// If a change is currently being performed on this [Network](#tag/networks), a error response with code `conflict` will be returned.
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
  ///         "type": "network"
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
  _i12.Future<
    _i13.TonikResult<
      _i28.ChangeNetworkProtectionResponse,
      _i15.Response<_i12.Object?>
    >
  >
  changeNetworkProtection({
    required _i29.NetworksIdActionsChangeProtectionPostBodyBodyModel body,
    required _i12.int id,
    _i13.TonikCancellation? cancellation,
  }) async => this._changeNetworkProtection(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Delete a route from a Network
  /// Delete a route entry from a [Network](#tag/networks).
  ///
  /// If a change is currently being performed on this [Network](#tag/networks), a error response with code `conflict` will be returned.
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
  ///     "command": "delete_route",
  ///     "status": "running",
  ///     "progress": 0,
  ///     "started": "2016-01-30T23:50:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 4711,
  ///         "type": "network"
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
  _i12.Future<
    _i13.TonikResult<
      _i30.DeleteNetworkRouteResponse,
      _i15.Response<_i12.Object?>
    >
  >
  deleteNetworkRoute({
    required _i31.NetworksIdActionsDeleteRoutePostBodyBodyModel body,
    required _i12.int id,
    _i13.TonikCancellation? cancellation,
  }) async =>
      this._deleteNetworkRoute(body: body, id: id, cancellation: cancellation);

  /// Delete a subnet from a Network
  /// Deletes a single subnet entry from a [Network](#tag/networks).
  ///
  /// Subnets containing attached resources can not be deleted, they must be detached beforehand.
  ///
  /// If a change is currently being performed on this [Network](#tag/networks), a error response with code `conflict` will be returned.
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
  ///     "command": "delete_subnet",
  ///     "status": "running",
  ///     "progress": 0,
  ///     "started": "2016-01-30T23:50:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 4711,
  ///         "type": "network"
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
  _i12.Future<
    _i13.TonikResult<
      _i32.DeleteNetworkSubnetResponse,
      _i15.Response<_i12.Object?>
    >
  >
  deleteNetworkSubnet({
    required _i33.NetworksIdActionsDeleteSubnetPostBodyBodyModel body,
    required _i12.int id,
    _i13.TonikCancellation? cancellation,
  }) async =>
      this._deleteNetworkSubnet(body: body, id: id, cancellation: cancellation);

  /// Get an Action for a Network
  /// **Deprecated**: This operation is deprecated, see our [changelog](https://docs.hetzner.cloud/changelog#2026-04-30-deprecate-get-resource-action-endpoints) for more details.
  ///
  /// Returns a specific [Action](#tag/actions) for a [Network](#tag/networks).
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
  ///     "command": "add_subnet",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": "2016-01-30T23:56:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 4711,
  ///         "type": "network"
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
  @_i12.Deprecated('This operation is deprecated.')
  _i12.Future<
    _i13.TonikResult<_i34.GetNetworkActionResponse, _i15.Response<_i12.Object?>>
  >
  getNetworkAction({
    required _i12.int id,
    required _i12.int actionId,
    _i13.TonikCancellation? cancellation,
  }) async => this._getNetworkAction(
    id: id,
    actionId: actionId,
    cancellation: cancellation,
  );
}
