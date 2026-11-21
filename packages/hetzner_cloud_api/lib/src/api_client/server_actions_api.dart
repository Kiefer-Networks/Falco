// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i29;

import 'package:dio/dio.dart' as _i32;
import 'package:hetzner_cloud_api/src/model/servers_actions_parameters_array_model.dart'
    as _i33;
import 'package:hetzner_cloud_api/src/model/servers_actions_parameters_array_model2.dart'
    as _i34;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_add_to_placement_group_post_body_body_model.dart'
    as _i40;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_attach_iso_post_body_body_model.dart'
    as _i42;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_attach_to_network_post_body_body_model.dart'
    as _i44;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_change_alias_ips_post_body_body_model.dart'
    as _i46;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_change_dns_ptr_post_body_body_model.dart'
    as _i48;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_change_protection_post_body_body_model.dart'
    as _i50;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_change_type_post_body_body_model.dart'
    as _i52;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_create_image_post_body_body_model.dart'
    as _i54;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_detach_from_network_post_body_body_model.dart'
    as _i56;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_enable_rescue_post_body_body_model.dart'
    as _i62;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_parameters_array_model.dart'
    as _i37;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_parameters_array_model2.dart'
    as _i38;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_rebuild_post_body_body_model.dart'
    as _i67;
import 'package:hetzner_cloud_api/src/operation/add_server_to_placement_group.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/operation/attach_server_iso.dart' as _i6;
import 'package:hetzner_cloud_api/src/operation/attach_server_to_network.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/operation/change_server_alias_ips.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/operation/change_server_dns_ptr.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/operation/change_server_protection.dart'
    as _i10;
import 'package:hetzner_cloud_api/src/operation/change_server_type.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/operation/create_server_image.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/operation/detach_server_from_network.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/operation/detach_server_iso.dart' as _i14;
import 'package:hetzner_cloud_api/src/operation/disable_server_backup.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/operation/disable_server_rescue.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/operation/enable_server_backup.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/operation/enable_server_rescue.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/operation/get_server_action.dart' as _i28;
import 'package:hetzner_cloud_api/src/operation/get_servers_action.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/list_server_actions.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/operation/list_servers_actions.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/operation/poweroff_server.dart' as _i19;
import 'package:hetzner_cloud_api/src/operation/poweron_server.dart' as _i20;
import 'package:hetzner_cloud_api/src/operation/reboot_server.dart' as _i21;
import 'package:hetzner_cloud_api/src/operation/rebuild_server.dart' as _i22;
import 'package:hetzner_cloud_api/src/operation/remove_server_from_placement_group.dart'
    as _i23;
import 'package:hetzner_cloud_api/src/operation/request_server_console.dart'
    as _i24;
import 'package:hetzner_cloud_api/src/operation/reset_server.dart' as _i25;
import 'package:hetzner_cloud_api/src/operation/reset_server_password.dart'
    as _i26;
import 'package:hetzner_cloud_api/src/operation/shutdown_server.dart' as _i27;
import 'package:hetzner_cloud_api/src/response_wrapper/add_server_to_placement_group_response.dart'
    as _i39;
import 'package:hetzner_cloud_api/src/response_wrapper/attach_server_iso_response.dart'
    as _i41;
import 'package:hetzner_cloud_api/src/response_wrapper/attach_server_to_network_response.dart'
    as _i43;
import 'package:hetzner_cloud_api/src/response_wrapper/change_server_alias_ips_response.dart'
    as _i45;
import 'package:hetzner_cloud_api/src/response_wrapper/change_server_dns_ptr_response.dart'
    as _i47;
import 'package:hetzner_cloud_api/src/response_wrapper/change_server_protection_response.dart'
    as _i49;
import 'package:hetzner_cloud_api/src/response_wrapper/change_server_type_response.dart'
    as _i51;
import 'package:hetzner_cloud_api/src/response_wrapper/create_server_image_response.dart'
    as _i53;
import 'package:hetzner_cloud_api/src/response_wrapper/detach_server_from_network_response.dart'
    as _i55;
import 'package:hetzner_cloud_api/src/response_wrapper/detach_server_iso_response.dart'
    as _i57;
import 'package:hetzner_cloud_api/src/response_wrapper/disable_server_backup_response.dart'
    as _i58;
import 'package:hetzner_cloud_api/src/response_wrapper/disable_server_rescue_response.dart'
    as _i59;
import 'package:hetzner_cloud_api/src/response_wrapper/enable_server_backup_response.dart'
    as _i60;
import 'package:hetzner_cloud_api/src/response_wrapper/enable_server_rescue_response.dart'
    as _i61;
import 'package:hetzner_cloud_api/src/response_wrapper/get_server_action_response.dart'
    as _i73;
import 'package:hetzner_cloud_api/src/response_wrapper/get_servers_action_response.dart'
    as _i35;
import 'package:hetzner_cloud_api/src/response_wrapper/list_server_actions_response.dart'
    as _i36;
import 'package:hetzner_cloud_api/src/response_wrapper/list_servers_actions_response.dart'
    as _i31;
import 'package:hetzner_cloud_api/src/response_wrapper/poweroff_server_response.dart'
    as _i63;
import 'package:hetzner_cloud_api/src/response_wrapper/poweron_server_response.dart'
    as _i64;
import 'package:hetzner_cloud_api/src/response_wrapper/reboot_server_response.dart'
    as _i65;
import 'package:hetzner_cloud_api/src/response_wrapper/rebuild_server_response.dart'
    as _i66;
import 'package:hetzner_cloud_api/src/response_wrapper/remove_server_from_placement_group_response.dart'
    as _i68;
import 'package:hetzner_cloud_api/src/response_wrapper/request_server_console_response.dart'
    as _i69;
import 'package:hetzner_cloud_api/src/response_wrapper/reset_server_password_response.dart'
    as _i71;
import 'package:hetzner_cloud_api/src/response_wrapper/reset_server_response.dart'
    as _i70;
import 'package:hetzner_cloud_api/src/response_wrapper/shutdown_server_response.dart'
    as _i72;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i30;

class ServerActionsApi {
  ServerActionsApi(_i1.Server server)
    : _listServersActions = _i2.ListServersActions(
        server.baseUrl,
        () => server.dio,
      ),
      _getServersAction = _i3.GetServersAction(
        server.baseUrl,
        () => server.dio,
      ),
      _listServerActions = _i4.ListServerActions(
        server.baseUrl,
        () => server.dio,
      ),
      _addServerToPlacementGroup = _i5.AddServerToPlacementGroup(
        server.baseUrl,
        () => server.dio,
      ),
      _attachServerIso = _i6.AttachServerIso(server.baseUrl, () => server.dio),
      _attachServerToNetwork = _i7.AttachServerToNetwork(
        server.baseUrl,
        () => server.dio,
      ),
      _changeServerAliasIps = _i8.ChangeServerAliasIps(
        server.baseUrl,
        () => server.dio,
      ),
      _changeServerDnsPtr = _i9.ChangeServerDnsPtr(
        server.baseUrl,
        () => server.dio,
      ),
      _changeServerProtection = _i10.ChangeServerProtection(
        server.baseUrl,
        () => server.dio,
      ),
      _changeServerType = _i11.ChangeServerType(
        server.baseUrl,
        () => server.dio,
      ),
      _createServerImage = _i12.CreateServerImage(
        server.baseUrl,
        () => server.dio,
      ),
      _detachServerFromNetwork = _i13.DetachServerFromNetwork(
        server.baseUrl,
        () => server.dio,
      ),
      _detachServerIso = _i14.DetachServerIso(server.baseUrl, () => server.dio),
      _disableServerBackup = _i15.DisableServerBackup(
        server.baseUrl,
        () => server.dio,
      ),
      _disableServerRescue = _i16.DisableServerRescue(
        server.baseUrl,
        () => server.dio,
      ),
      _enableServerBackup = _i17.EnableServerBackup(
        server.baseUrl,
        () => server.dio,
      ),
      _enableServerRescue = _i18.EnableServerRescue(
        server.baseUrl,
        () => server.dio,
      ),
      _poweroffServer = _i19.PoweroffServer(server.baseUrl, () => server.dio),
      _poweronServer = _i20.PoweronServer(server.baseUrl, () => server.dio),
      _rebootServer = _i21.RebootServer(server.baseUrl, () => server.dio),
      _rebuildServer = _i22.RebuildServer(server.baseUrl, () => server.dio),
      _removeServerFromPlacementGroup = _i23.RemoveServerFromPlacementGroup(
        server.baseUrl,
        () => server.dio,
      ),
      _requestServerConsole = _i24.RequestServerConsole(
        server.baseUrl,
        () => server.dio,
      ),
      _resetServer = _i25.ResetServer(server.baseUrl, () => server.dio),
      _resetServerPassword = _i26.ResetServerPassword(
        server.baseUrl,
        () => server.dio,
      ),
      _shutdownServer = _i27.ShutdownServer(server.baseUrl, () => server.dio),
      _getServerAction = _i28.GetServerAction(server.baseUrl, () => server.dio);

  final _i2.ListServersActions _listServersActions;

  final _i3.GetServersAction _getServersAction;

  final _i4.ListServerActions _listServerActions;

  final _i5.AddServerToPlacementGroup _addServerToPlacementGroup;

  final _i6.AttachServerIso _attachServerIso;

  final _i7.AttachServerToNetwork _attachServerToNetwork;

  final _i8.ChangeServerAliasIps _changeServerAliasIps;

  final _i9.ChangeServerDnsPtr _changeServerDnsPtr;

  final _i10.ChangeServerProtection _changeServerProtection;

  final _i11.ChangeServerType _changeServerType;

  final _i12.CreateServerImage _createServerImage;

  final _i13.DetachServerFromNetwork _detachServerFromNetwork;

  final _i14.DetachServerIso _detachServerIso;

  final _i15.DisableServerBackup _disableServerBackup;

  final _i16.DisableServerRescue _disableServerRescue;

  final _i17.EnableServerBackup _enableServerBackup;

  final _i18.EnableServerRescue _enableServerRescue;

  final _i19.PoweroffServer _poweroffServer;

  final _i20.PoweronServer _poweronServer;

  final _i21.RebootServer _rebootServer;

  final _i22.RebuildServer _rebuildServer;

  final _i23.RemoveServerFromPlacementGroup _removeServerFromPlacementGroup;

  final _i24.RequestServerConsole _requestServerConsole;

  final _i25.ResetServer _resetServer;

  final _i26.ResetServerPassword _resetServerPassword;

  final _i27.ShutdownServer _shutdownServer;

  final _i28.GetServerAction _getServerAction;

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
  _i29.Future<
    _i30.TonikResult<
      _i31.ListServersActionsResponse,
      _i32.Response<_i29.Object?>
    >
  >
  listServersActions({
    _i29.List<_i29.int>? id,
    _i29.List<_i33.ServersActionsParametersArrayModel>? sort,
    _i29.List<_i34.ServersActionsParametersArrayModel2>? status,
    _i29.int page = _i2.ListServersActions.pageDefault,
    _i29.int perPage = _i2.ListServersActions.perPageDefault,
    _i30.TonikCancellation? cancellation,
  }) async => this._listServersActions(
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
  _i29.Future<
    _i30.TonikResult<_i35.GetServersActionResponse, _i32.Response<_i29.Object?>>
  >
  getServersAction({
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._getServersAction(id: id, cancellation: cancellation);

  /// List Actions for a Server
  /// Returns all Action objects for a Server. You can `sort` the results by using the sort URI parameter, and filter them with the `status` parameter.
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
  ///       "command": "start_server",
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
  _i29.Future<
    _i30.TonikResult<
      _i36.ListServerActionsResponse,
      _i32.Response<_i29.Object?>
    >
  >
  listServerActions({
    required _i29.int id,
    _i29.List<_i37.ServersIdActionsParametersArrayModel>? sort,
    _i29.List<_i38.ServersIdActionsParametersArrayModel2>? status,
    _i29.int page = _i4.ListServerActions.pageDefault,
    _i29.int perPage = _i4.ListServerActions.perPageDefault,
    _i30.TonikCancellation? cancellation,
  }) async => this._listServerActions(
    id: id,
    sort: sort,
    status: status,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Add a Server to a Placement Group
  /// Adds a Server to a Placement Group.
  ///
  /// Server must be powered off for this command to succeed.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `server_not_stopped` | The action requires a stopped server |
  /// | `422` | `already_in_placement_group` | The server is already part of a placement group |
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
  ///     "command": "add_to_placement_group",
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
  _i29.Future<
    _i30.TonikResult<
      _i39.AddServerToPlacementGroupResponse,
      _i32.Response<_i29.Object?>
    >
  >
  addServerToPlacementGroup({
    required _i40.ServersIdActionsAddToPlacementGroupPostBodyBodyModel body,
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._addServerToPlacementGroup(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Attach an ISO to a Server
  /// Attaches an ISO to a Server. The Server will immediately see it as a new disk. An already attached ISO will automatically be detached before the new ISO is attached.
  ///
  /// Servers with attached ISOs have a modified boot order: They will try to boot from the ISO first before falling back to hard disk.
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
  ///     "command": "attach_iso",
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
  _i29.Future<
    _i30.TonikResult<_i41.AttachServerIsoResponse, _i32.Response<_i29.Object?>>
  >
  attachServerIso({
    required _i42.ServersIdActionsAttachIsoPostBodyBodyModel body,
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async =>
      this._attachServerIso(body: body, id: id, cancellation: cancellation);

  /// Attach a Server to a Network
  /// Attaches a Server to a network. This will complement the fixed public Server interface by adding an additional ethernet interface to the Server which is connected to the specified network.
  ///
  /// The Server will get an IP auto assigned from a subnet of type `server` in the same `network_zone`.
  ///
  /// Using the `alias_ips` attribute you can also define one or more additional IPs to the Servers. Please note that you will have to configure these IPs by hand on your Server since only the primary IP will be given out by DHCP.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `server_already_attached` | The server is already attached to the network |
  /// | `422` | `ip_not_available` | The provided Network IP is not available |
  /// | `422` | `no_subnet_available` | No Subnet or IP is available for the Server within the network |
  /// | `422` | `networks_overlap` | The network IP range overlaps with one of the server networks |
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
  ///     "command": "attach_to_network",
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
  _i29.Future<
    _i30.TonikResult<
      _i43.AttachServerToNetworkResponse,
      _i32.Response<_i29.Object?>
    >
  >
  attachServerToNetwork({
    required _i44.ServersIdActionsAttachToNetworkPostBodyBodyModel body,
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._attachServerToNetwork(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Change alias IPs of a Network
  /// Changes the alias IPs of an already attached Network. Note that the existing aliases for the specified Network will be replaced with these provided in the request body. So if you want to add an alias IP, you have to provide the existing ones from the Network plus the new alias IP in the request body.
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
  ///     "command": "change_alias_ips",
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
  _i29.Future<
    _i30.TonikResult<
      _i45.ChangeServerAliasIpsResponse,
      _i32.Response<_i29.Object?>
    >
  >
  changeServerAliasIps({
    required _i46.ServersIdActionsChangeAliasIpsPostBodyBodyModel body,
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._changeServerAliasIps(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Change reverse DNS entry for this Server
  /// Changes the hostname that will appear when getting the hostname belonging to the primary IPs (IPv4 and IPv6) of this Server.
  ///
  /// Floating IPs assigned to the Server are not affected by this.
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
  _i29.Future<
    _i30.TonikResult<
      _i47.ChangeServerDnsPtrResponse,
      _i32.Response<_i29.Object?>
    >
  >
  changeServerDnsPtr({
    required _i48.ServersIdActionsChangeDnsPtrPostBodyBodyModel body,
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async =>
      this._changeServerDnsPtr(body: body, id: id, cancellation: cancellation);

  /// Change Server Protection
  /// Changes the protection configuration of the Server.
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
  _i29.Future<
    _i30.TonikResult<
      _i49.ChangeServerProtectionResponse,
      _i32.Response<_i29.Object?>
    >
  >
  changeServerProtection({
    required _i50.ServersIdActionsChangeProtectionPostBodyBodyModel body,
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._changeServerProtection(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Change the Type of a Server
  /// Changes the type (Cores, RAM and disk sizes) of a Server.
  ///
  /// Server must be powered off for this command to succeed.
  ///
  /// This copies the content of its disk, and starts it again.
  ///
  /// You can only migrate to Server types with the same `storage_type` and equal or bigger disks. Shrinking disks is not possible as it might destroy data.
  ///
  /// If the disk gets upgraded, the Server type can not be downgraded any more. If you plan to downgrade the Server type, set `upgrade_disk` to `false`.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `invalid_server_type` | The server type does not fit for the given server or is deprecated |
  /// | `422` | `server_not_stopped` | The action requires a stopped server |
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
  ///     "command": "change_server_type",
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
  _i29.Future<
    _i30.TonikResult<_i51.ChangeServerTypeResponse, _i32.Response<_i29.Object?>>
  >
  changeServerType({
    required _i52.ServersIdActionsChangeTypePostBodyBodyModel body,
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async =>
      this._changeServerType(body: body, id: id, cancellation: cancellation);

  /// Create Image from a Server
  /// Creates an Image (snapshot) from a Server by copying the contents of its disks. This creates a snapshot of the current state of the disk and copies it into an Image. If the Server is currently running you must make sure that its disk content is consistent. Otherwise, the created Image may not be readable.
  ///
  /// To make sure disk content is consistent, we recommend to shut down the Server prior to creating an Image.
  ///
  /// You can either create a `backup` Image that is bound to the Server and therefore will be deleted when the Server is deleted, or you can create a `snapshot` Image which is completely independent of the Server it was created from and will survive Server deletion. Backup Images are only available when the backup option is enabled for the Server. Snapshot Images are billed on a per GB basis.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "image": {
  ///     "id": 4711,
  ///     "type": "snapshot",
  ///     "status": "creating",
  ///     "name": null,
  ///     "description": "my image",
  ///     "image_size": 2.3,
  ///     "disk_size": 10,
  ///     "created": "2016-01-30T23:50:00Z",
  ///     "created_from": {
  ///       "id": 1,
  ///       "name": "Server"
  ///     },
  ///     "bound_to": null,
  ///     "os_flavor": "ubuntu",
  ///     "os_version": "20.04",
  ///     "rapid_deploy": false,
  ///     "protection": {
  ///       "delete": false
  ///     },
  ///     "deprecation": null,
  ///     "deleted": null,
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "architecture": "x86"
  ///   },
  ///   "action": {
  ///     "id": 13,
  ///     "command": "create_image",
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
  _i29.Future<
    _i30.TonikResult<
      _i53.CreateServerImageResponse,
      _i32.Response<_i29.Object?>
    >
  >
  createServerImage({
    required _i54.ServersIdActionsCreateImagePostBodyBodyModel body,
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async =>
      this._createServerImage(body: body, id: id, cancellation: cancellation);

  /// Detach a Server from a Network
  /// Detaches a Server from a network. The interface for this network will vanish.
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
  ///     "command": "detach_from_network",
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
  _i29.Future<
    _i30.TonikResult<
      _i55.DetachServerFromNetworkResponse,
      _i32.Response<_i29.Object?>
    >
  >
  detachServerFromNetwork({
    required _i56.ServersIdActionsDetachFromNetworkPostBodyBodyModel body,
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._detachServerFromNetwork(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Detach an ISO from a Server
  /// Detaches an ISO from a Server. In case no ISO Image is attached to the Server, the status of the returned Action is immediately set to `success`.
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
  ///     "command": "detach_iso",
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
  _i29.Future<
    _i30.TonikResult<_i57.DetachServerIsoResponse, _i32.Response<_i29.Object?>>
  >
  detachServerIso({
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._detachServerIso(id: id, cancellation: cancellation);

  /// Disable Backups for a Server
  /// Disables the automatic backup option and deletes all existing Backups for a Server. No more additional charges for backups will be made.
  ///
  /// Caution: This immediately removes all existing backups for the Server!
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
  ///     "command": "disable_backup",
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
  _i29.Future<
    _i30.TonikResult<
      _i58.DisableServerBackupResponse,
      _i32.Response<_i29.Object?>
    >
  >
  disableServerBackup({
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._disableServerBackup(id: id, cancellation: cancellation);

  /// Disable Rescue Mode for a Server
  /// Disables the Hetzner Rescue System for a Server. This makes a Server start from its disks on next reboot.
  ///
  /// Rescue Mode is automatically disabled when you first boot into it or if you do not use it for 60 minutes.
  ///
  /// Disabling rescue mode will not reboot your Server — you will have to do this yourself.
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
  ///     "command": "disable_rescue",
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
  _i29.Future<
    _i30.TonikResult<
      _i59.DisableServerRescueResponse,
      _i32.Response<_i29.Object?>
    >
  >
  disableServerRescue({
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._disableServerRescue(id: id, cancellation: cancellation);

  /// Enable and Configure Backups for a Server
  /// Enables and configures the automatic daily backup option for the Server. Enabling automatic backups will increase the price of the Server by 20%. In return, you will get seven slots where Images of type backup can be stored.
  ///
  /// Backups are automatically created daily.
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
  ///     "command": "enable_backup",
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
  _i29.Future<
    _i30.TonikResult<
      _i60.EnableServerBackupResponse,
      _i32.Response<_i29.Object?>
    >
  >
  enableServerBackup({
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._enableServerBackup(id: id, cancellation: cancellation);

  /// Enable Rescue Mode for a Server
  /// Enable the Hetzner Rescue System for this Server. The next time a Server with enabled rescue mode boots it will start a special minimal Linux distribution designed for repair and reinstall.
  ///
  /// In case a Server cannot boot on its own you can use this to access a Server’s disks.
  ///
  /// Rescue Mode is automatically disabled when you first boot into it or if you do not use it for 60 minutes.
  ///
  /// Enabling rescue mode will not [reboot](https://docs.hetzner.cloud/#server-actions-soft-reboot-a-server) your Server — you will have to do this yourself.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "root_password": "zCWbFhnu950dUTko5f40",
  ///   "action": {
  ///     "id": 13,
  ///     "command": "enable_rescue",
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
  _i29.Future<
    _i30.TonikResult<
      _i61.EnableServerRescueResponse,
      _i32.Response<_i29.Object?>
    >
  >
  enableServerRescue({
    required _i62.ServersIdActionsEnableRescuePostBodyBodyModel body,
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async =>
      this._enableServerRescue(body: body, id: id, cancellation: cancellation);

  /// Power off a Server
  /// Cuts power to the Server. This forcefully stops it without giving the Server operating system time to gracefully stop. May lead to data loss, equivalent to pulling the power cord. Power off should only be used when shutdown does not work.
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
  ///     "command": "stop_server",
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
  _i29.Future<
    _i30.TonikResult<_i63.PoweroffServerResponse, _i32.Response<_i29.Object?>>
  >
  poweroffServer({
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._poweroffServer(id: id, cancellation: cancellation);

  /// Power on a Server
  /// Starts a Server by turning its power on.
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
  ///     "command": "start_server",
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
  _i29.Future<
    _i30.TonikResult<_i64.PoweronServerResponse, _i32.Response<_i29.Object?>>
  >
  poweronServer({
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._poweronServer(id: id, cancellation: cancellation);

  /// Soft-reboot a Server
  /// Reboots a Server gracefully by sending an ACPI request. The Server operating system must support ACPI and react to the request, otherwise the Server will not reboot.
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
  ///     "command": "reboot_server",
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
  _i29.Future<
    _i30.TonikResult<_i65.RebootServerResponse, _i32.Response<_i29.Object?>>
  >
  rebootServer({
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._rebootServer(id: id, cancellation: cancellation);

  /// Rebuild a Server from an Image
  /// Rebuilds a Server overwriting its disk with the content of an Image, thereby **destroying all data** on the target Server
  ///
  /// The Image can either be one you have created earlier (`backup` or `snapshot` Image) or it can be a completely fresh `system` Image provided by us. You can get a list of all available Images with `GET /images`.
  ///
  /// Your Server will automatically be powered off before the rebuild command executes.
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
  ///     "command": "rebuild_server",
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
  ///   },
  ///   "root_password": null
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
  _i29.Future<
    _i30.TonikResult<_i66.RebuildServerResponse, _i32.Response<_i29.Object?>>
  >
  rebuildServer({
    required _i67.ServersIdActionsRebuildPostBodyBodyModel body,
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async =>
      this._rebuildServer(body: body, id: id, cancellation: cancellation);

  /// Remove from Placement Group
  /// Removes a Server from a Placement Group.
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
  ///     "command": "remove_from_placement_group",
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
  _i29.Future<
    _i30.TonikResult<
      _i68.RemoveServerFromPlacementGroupResponse,
      _i32.Response<_i29.Object?>
    >
  >
  removeServerFromPlacementGroup({
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async =>
      this._removeServerFromPlacementGroup(id: id, cancellation: cancellation);

  /// Request Console for a Server
  /// Requests credentials for remote access via VNC over websocket to keyboard, monitor, and mouse for a Server. The provided URL is valid for 1 minute, after this period a new url needs to be created to connect to the Server. How long the connection is open after the initial connect is not subject to this timeout.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "wss_url": "wss://console.hetzner.cloud/?server_id=1&token=3db32d15-af2f-459c-8bf8-dee1fd05f49c",
  ///   "password": "9MQaTg2VAGI0FIpc10k3UpRXcHj2wQ6x",
  ///   "action": {
  ///     "id": 13,
  ///     "command": "request_console",
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
  _i29.Future<
    _i30.TonikResult<
      _i69.RequestServerConsoleResponse,
      _i32.Response<_i29.Object?>
    >
  >
  requestServerConsole({
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._requestServerConsole(id: id, cancellation: cancellation);

  /// Reset a Server
  /// Cuts power to a Server and starts it again. This forcefully stops it without giving the Server operating system time to gracefully stop. This may lead to data loss, it’s equivalent to pulling the power cord and plugging it in again. Reset should only be used when reboot does not work.
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
  ///     "command": "reset_server",
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
  _i29.Future<
    _i30.TonikResult<_i70.ResetServerResponse, _i32.Response<_i29.Object?>>
  >
  resetServer({
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._resetServer(id: id, cancellation: cancellation);

  /// Reset root Password of a Server
  /// Resets the root password. Only works for Linux systems that are running the qemu guest agent. Server must be powered on (status `running`) in order for this operation to succeed.
  ///
  /// This will generate a new password for this Server and return it.
  ///
  /// If this does not succeed you can use the rescue system to netboot the Server and manually change your Server password by hand.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "root_password": "zCWbFhnu950dUTko5f40",
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
  _i29.Future<
    _i30.TonikResult<
      _i71.ResetServerPasswordResponse,
      _i32.Response<_i29.Object?>
    >
  >
  resetServerPassword({
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._resetServerPassword(id: id, cancellation: cancellation);

  /// Shutdown a Server
  /// Shuts down a Server gracefully by sending an ACPI shutdown request. The Server operating system must support ACPI
  /// and react to the request, otherwise the Server will not shut down. Please note that the `action` status in this case
  /// only reflects whether the action was sent to the server. It does not mean that the server actually shut down
  /// successfully. If you need to ensure that the server is off, use the `poweroff` action.
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
  ///     "command": "shutdown_server",
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
  _i29.Future<
    _i30.TonikResult<_i72.ShutdownServerResponse, _i32.Response<_i29.Object?>>
  >
  shutdownServer({
    required _i29.int id,
    _i30.TonikCancellation? cancellation,
  }) async => this._shutdownServer(id: id, cancellation: cancellation);

  /// Get an Action for a Server
  /// **Deprecated**: This operation is deprecated, see our [changelog](https://docs.hetzner.cloud/changelog#2026-04-30-deprecate-get-resource-action-endpoints) for more details.
  ///
  /// Returns a specific Action object for a Server.
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
  ///     "command": "start_server",
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
  @_i29.Deprecated('This operation is deprecated.')
  _i29.Future<
    _i30.TonikResult<_i73.GetServerActionResponse, _i32.Response<_i29.Object?>>
  >
  getServerAction({
    required _i29.int id,
    required _i29.int actionId,
    _i30.TonikCancellation? cancellation,
  }) async => this._getServerAction(
    id: id,
    actionId: actionId,
    cancellation: cancellation,
  );
}
