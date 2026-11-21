// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i19;

import 'package:dio/dio.dart' as _i22;
import 'package:hetzner_cloud_api/src/model/load_balancers_actions_parameters_array_model.dart'
    as _i23;
import 'package:hetzner_cloud_api/src/model/load_balancers_actions_parameters_array_model2.dart'
    as _i24;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_add_service_post_body_body_all_of_model.dart'
    as _i30;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_add_target_post_body_body_all_of_model.dart'
    as _i32;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_attach_to_network_post_body_body_model.dart'
    as _i34;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_change_algorithm_post_body_body_model.dart'
    as _i36;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_change_dns_ptr_post_body_body_model.dart'
    as _i38;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_change_protection_post_body_body_model.dart'
    as _i40;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_change_type_post_body_body_model.dart'
    as _i42;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_delete_service_post_body_body_model.dart'
    as _i44;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_detach_from_network_post_body_body_model.dart'
    as _i46;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_parameters_array_model.dart'
    as _i27;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_parameters_array_model2.dart'
    as _i28;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_remove_target_post_body_body_model.dart'
    as _i50;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_update_service_post_body_body_all_of_model.dart'
    as _i52;
import 'package:hetzner_cloud_api/src/operation/add_load_balancer_service.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/operation/add_load_balancer_target.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/operation/attach_load_balancer_to_network.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/operation/change_load_balancer_algorithm.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/operation/change_load_balancer_dns_ptr.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/operation/change_load_balancer_protection.dart'
    as _i10;
import 'package:hetzner_cloud_api/src/operation/change_load_balancer_type.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/operation/delete_load_balancer_service.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/operation/detach_load_balancer_from_network.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/operation/disable_load_balancer_public_interface.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/operation/enable_load_balancer_public_interface.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/operation/get_load_balancer_action.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/operation/get_load_balancers_action.dart'
    as _i3;
import 'package:hetzner_cloud_api/src/operation/list_load_balancer_actions.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/operation/list_load_balancers_actions.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/operation/remove_load_balancer_target.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/operation/update_load_balancer_service.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/response_wrapper/add_load_balancer_service_response.dart'
    as _i29;
import 'package:hetzner_cloud_api/src/response_wrapper/add_load_balancer_target_response.dart'
    as _i31;
import 'package:hetzner_cloud_api/src/response_wrapper/attach_load_balancer_to_network_response.dart'
    as _i33;
import 'package:hetzner_cloud_api/src/response_wrapper/change_load_balancer_algorithm_response.dart'
    as _i35;
import 'package:hetzner_cloud_api/src/response_wrapper/change_load_balancer_dns_ptr_response.dart'
    as _i37;
import 'package:hetzner_cloud_api/src/response_wrapper/change_load_balancer_protection_response.dart'
    as _i39;
import 'package:hetzner_cloud_api/src/response_wrapper/change_load_balancer_type_response.dart'
    as _i41;
import 'package:hetzner_cloud_api/src/response_wrapper/delete_load_balancer_service_response.dart'
    as _i43;
import 'package:hetzner_cloud_api/src/response_wrapper/detach_load_balancer_from_network_response.dart'
    as _i45;
import 'package:hetzner_cloud_api/src/response_wrapper/disable_load_balancer_public_interface_response.dart'
    as _i47;
import 'package:hetzner_cloud_api/src/response_wrapper/enable_load_balancer_public_interface_response.dart'
    as _i48;
import 'package:hetzner_cloud_api/src/response_wrapper/get_load_balancer_action_response.dart'
    as _i53;
import 'package:hetzner_cloud_api/src/response_wrapper/get_load_balancers_action_response.dart'
    as _i25;
import 'package:hetzner_cloud_api/src/response_wrapper/list_load_balancer_actions_response.dart'
    as _i26;
import 'package:hetzner_cloud_api/src/response_wrapper/list_load_balancers_actions_response.dart'
    as _i21;
import 'package:hetzner_cloud_api/src/response_wrapper/remove_load_balancer_target_response.dart'
    as _i49;
import 'package:hetzner_cloud_api/src/response_wrapper/update_load_balancer_service_response.dart'
    as _i51;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i20;

class LoadBalancerActionsApi {
  LoadBalancerActionsApi(_i1.Server server)
    : _listLoadBalancersActions = _i2.ListLoadBalancersActions(
        server.baseUrl,
        () => server.dio,
      ),
      _getLoadBalancersAction = _i3.GetLoadBalancersAction(
        server.baseUrl,
        () => server.dio,
      ),
      _listLoadBalancerActions = _i4.ListLoadBalancerActions(
        server.baseUrl,
        () => server.dio,
      ),
      _addLoadBalancerService = _i5.AddLoadBalancerService(
        server.baseUrl,
        () => server.dio,
      ),
      _addLoadBalancerTarget = _i6.AddLoadBalancerTarget(
        server.baseUrl,
        () => server.dio,
      ),
      _attachLoadBalancerToNetwork = _i7.AttachLoadBalancerToNetwork(
        server.baseUrl,
        () => server.dio,
      ),
      _changeLoadBalancerAlgorithm = _i8.ChangeLoadBalancerAlgorithm(
        server.baseUrl,
        () => server.dio,
      ),
      _changeLoadBalancerDnsPtr = _i9.ChangeLoadBalancerDnsPtr(
        server.baseUrl,
        () => server.dio,
      ),
      _changeLoadBalancerProtection = _i10.ChangeLoadBalancerProtection(
        server.baseUrl,
        () => server.dio,
      ),
      _changeLoadBalancerType = _i11.ChangeLoadBalancerType(
        server.baseUrl,
        () => server.dio,
      ),
      _deleteLoadBalancerService = _i12.DeleteLoadBalancerService(
        server.baseUrl,
        () => server.dio,
      ),
      _detachLoadBalancerFromNetwork = _i13.DetachLoadBalancerFromNetwork(
        server.baseUrl,
        () => server.dio,
      ),
      _disableLoadBalancerPublicInterface =
          _i14.DisableLoadBalancerPublicInterface(
            server.baseUrl,
            () => server.dio,
          ),
      _enableLoadBalancerPublicInterface =
          _i15.EnableLoadBalancerPublicInterface(
            server.baseUrl,
            () => server.dio,
          ),
      _removeLoadBalancerTarget = _i16.RemoveLoadBalancerTarget(
        server.baseUrl,
        () => server.dio,
      ),
      _updateLoadBalancerService = _i17.UpdateLoadBalancerService(
        server.baseUrl,
        () => server.dio,
      ),
      _getLoadBalancerAction = _i18.GetLoadBalancerAction(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListLoadBalancersActions _listLoadBalancersActions;

  final _i3.GetLoadBalancersAction _getLoadBalancersAction;

  final _i4.ListLoadBalancerActions _listLoadBalancerActions;

  final _i5.AddLoadBalancerService _addLoadBalancerService;

  final _i6.AddLoadBalancerTarget _addLoadBalancerTarget;

  final _i7.AttachLoadBalancerToNetwork _attachLoadBalancerToNetwork;

  final _i8.ChangeLoadBalancerAlgorithm _changeLoadBalancerAlgorithm;

  final _i9.ChangeLoadBalancerDnsPtr _changeLoadBalancerDnsPtr;

  final _i10.ChangeLoadBalancerProtection _changeLoadBalancerProtection;

  final _i11.ChangeLoadBalancerType _changeLoadBalancerType;

  final _i12.DeleteLoadBalancerService _deleteLoadBalancerService;

  final _i13.DetachLoadBalancerFromNetwork _detachLoadBalancerFromNetwork;

  final _i14.DisableLoadBalancerPublicInterface
  _disableLoadBalancerPublicInterface;

  final _i15.EnableLoadBalancerPublicInterface
  _enableLoadBalancerPublicInterface;

  final _i16.RemoveLoadBalancerTarget _removeLoadBalancerTarget;

  final _i17.UpdateLoadBalancerService _updateLoadBalancerService;

  final _i18.GetLoadBalancerAction _getLoadBalancerAction;

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
  _i19.Future<
    _i20.TonikResult<
      _i21.ListLoadBalancersActionsResponse,
      _i22.Response<_i19.Object?>
    >
  >
  listLoadBalancersActions({
    _i19.List<_i19.int>? id,
    _i19.List<_i23.LoadBalancersActionsParametersArrayModel>? sort,
    _i19.List<_i24.LoadBalancersActionsParametersArrayModel2>? status,
    _i19.int page = _i2.ListLoadBalancersActions.pageDefault,
    _i19.int perPage = _i2.ListLoadBalancersActions.perPageDefault,
    _i20.TonikCancellation? cancellation,
  }) async => this._listLoadBalancersActions(
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
  _i19.Future<
    _i20.TonikResult<
      _i25.GetLoadBalancersActionResponse,
      _i22.Response<_i19.Object?>
    >
  >
  getLoadBalancersAction({
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => this._getLoadBalancersAction(id: id, cancellation: cancellation);

  /// List Actions for a Load Balancer
  /// Returns all Action objects for a Load Balancer. You can sort the results by using the `sort` URI parameter, and filter them with the `status` parameter.
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
  ///       "command": "add_service",
  ///       "status": "success",
  ///       "progress": 100,
  ///       "started": "2016-01-30T23:55:00Z",
  ///       "finished": "2016-01-30T23:56:00Z",
  ///       "resources": [
  ///         {
  ///           "id": 4711,
  ///           "type": "load_balancer"
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
  _i19.Future<
    _i20.TonikResult<
      _i26.ListLoadBalancerActionsResponse,
      _i22.Response<_i19.Object?>
    >
  >
  listLoadBalancerActions({
    required _i19.int id,
    _i19.List<_i27.LoadBalancersIdActionsParametersArrayModel>? sort,
    _i19.List<_i28.LoadBalancersIdActionsParametersArrayModel2>? status,
    _i19.int page = _i4.ListLoadBalancerActions.pageDefault,
    _i19.int perPage = _i4.ListLoadBalancerActions.perPageDefault,
    _i20.TonikCancellation? cancellation,
  }) async => this._listLoadBalancerActions(
    id: id,
    sort: sort,
    status: status,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Add Service
  /// Adds a service to a Load Balancer.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `412` | `source_port_already_used` | The source port you are trying to add is already in use |
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
  ///     "command": "add_service",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": "2016-01-30T23:56:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 4711,
  ///         "type": "load_balancer"
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
  _i19.Future<
    _i20.TonikResult<
      _i29.AddLoadBalancerServiceResponse,
      _i22.Response<_i19.Object?>
    >
  >
  addLoadBalancerService({
    required _i30.LoadBalancersIdActionsAddServicePostBodyBodyAllOfModel body,
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => this._addLoadBalancerService(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Add Target
  /// Adds a target to a Load Balancer.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `ip_not_in_vswitch_subnet` | The IP you are trying to add does not belong to the vswitch subnet of the attached network |
  /// | `422` | `ip_not_owned` | The IP you are trying to add as a target is not owned by the Project owner |
  /// | `422` | `ip_not_assigned_to_server` | The specified IP is neither the Primary IPv4 address nor in the IPv6 subnet of the given Server |
  /// | `422` | `load_balancer_public_interface_disabled` | The Load Balancer's public network interface is disabled |
  /// | `422` | `load_balancer_not_attached_to_network` | The Load Balancer is not attached to a network |
  /// | `422` | `network_has_no_vswitch_subnet` | The given IP is private but attached network does not have a vswitch subnet |
  /// | `422` | `resolve_cloud_private_targets_error` | The server you are trying to add as a target is not attached to the same network as the Load Balancer |
  /// | `422` | `resolve_cloud_public_targets_error` | The server that you are trying to add as a public target does not have a public IPv4 address |
  /// | `422` | `target_already_defined` | The Load Balancer target you are trying to define is already defined |
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
  ///     "command": "add_target",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": "2016-01-30T23:56:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 4711,
  ///         "type": "load_balancer"
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
  _i19.Future<
    _i20.TonikResult<
      _i31.AddLoadBalancerTargetResponse,
      _i22.Response<_i19.Object?>
    >
  >
  addLoadBalancerTarget({
    required _i32.LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel body,
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => this._addLoadBalancerTarget(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Attach a Load Balancer to a Network
  /// Attach a Load Balancer to a Network.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `load_balancer_already_attached` | The Load Balancer is already attached to a network |
  /// | `422` | `ip_not_available` | The provided Network IP is not available |
  /// | `422` | `no_subnet_available` | No Subnet or IP is available for the Load Balancer within the network |
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
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": "2016-01-30T23:56:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 4711,
  ///         "type": "load_balancer"
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
  _i19.Future<
    _i20.TonikResult<
      _i33.AttachLoadBalancerToNetworkResponse,
      _i22.Response<_i19.Object?>
    >
  >
  attachLoadBalancerToNetwork({
    required _i34.LoadBalancersIdActionsAttachToNetworkPostBodyBodyModel body,
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => this._attachLoadBalancerToNetwork(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Change Algorithm
  /// Change the algorithm that determines to which target new requests are sent.
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
  ///     "command": "change_algorithm",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": "2016-01-30T23:56:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 4711,
  ///         "type": "load_balancer"
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
  _i19.Future<
    _i20.TonikResult<
      _i35.ChangeLoadBalancerAlgorithmResponse,
      _i22.Response<_i19.Object?>
    >
  >
  changeLoadBalancerAlgorithm({
    required _i36.LoadBalancersIdActionsChangeAlgorithmPostBodyBodyModel body,
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => this._changeLoadBalancerAlgorithm(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Change reverse DNS entry for this Load Balancer
  /// Changes the hostname that will appear when getting the hostname belonging to the public IPs (IPv4 and IPv6) of this Load Balancer.
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
  ///         "type": "load_balancer"
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
  _i19.Future<
    _i20.TonikResult<
      _i37.ChangeLoadBalancerDnsPtrResponse,
      _i22.Response<_i19.Object?>
    >
  >
  changeLoadBalancerDnsPtr({
    required _i38.LoadBalancersIdActionsChangeDnsPtrPostBodyBodyModel body,
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => this._changeLoadBalancerDnsPtr(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Change Load Balancer Protection
  /// Changes the protection configuration of a Load Balancer.
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
  ///         "type": "load_balancer"
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
  _i19.Future<
    _i20.TonikResult<
      _i39.ChangeLoadBalancerProtectionResponse,
      _i22.Response<_i19.Object?>
    >
  >
  changeLoadBalancerProtection({
    required _i40.LoadBalancersIdActionsChangeProtectionPostBodyBodyModel body,
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => this._changeLoadBalancerProtection(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Change the Type of a Load Balancer
  /// Changes the type (Max Services, Max Targets and Max Connections) of a Load Balancer.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `invalid_load_balancer_type` | The Load Balancer type does not fit for the given Load Balancer |
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
  ///     "command": "change_load_balancer_type",
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
  _i19.Future<
    _i20.TonikResult<
      _i41.ChangeLoadBalancerTypeResponse,
      _i22.Response<_i19.Object?>
    >
  >
  changeLoadBalancerType({
    required _i42.LoadBalancersIdActionsChangeTypePostBodyBodyModel body,
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => this._changeLoadBalancerType(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Delete Service
  /// Delete a service of a Load Balancer.
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
  ///     "command": "delete_service",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": "2016-01-30T23:56:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 4711,
  ///         "type": "load_balancer"
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
  _i19.Future<
    _i20.TonikResult<
      _i43.DeleteLoadBalancerServiceResponse,
      _i22.Response<_i19.Object?>
    >
  >
  deleteLoadBalancerService({
    required _i44.LoadBalancersIdActionsDeleteServicePostBodyBodyModel body,
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => this._deleteLoadBalancerService(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Detach a Load Balancer from a Network
  /// Detaches a Load Balancer from a network.
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
  _i19.Future<
    _i20.TonikResult<
      _i45.DetachLoadBalancerFromNetworkResponse,
      _i22.Response<_i19.Object?>
    >
  >
  detachLoadBalancerFromNetwork({
    required _i46.LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel body,
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => this._detachLoadBalancerFromNetwork(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Disable the public interface of a Load Balancer
  /// Disable the public interface of a Load Balancer. The Load Balancer will be not accessible from the internet via its public IPs.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `load_balancer_not_attached_to_network` | The Load Balancer is not attached to a network |
  /// | `422` | `targets_without_use_private_ip` | The Load Balancer has targets that use the public IP instead of the private IP |
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
  ///     "command": "disable_public_interface",
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
  _i19.Future<
    _i20.TonikResult<
      _i47.DisableLoadBalancerPublicInterfaceResponse,
      _i22.Response<_i19.Object?>
    >
  >
  disableLoadBalancerPublicInterface({
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => this._disableLoadBalancerPublicInterface(
    id: id,
    cancellation: cancellation,
  );

  /// Enable the public interface of a Load Balancer
  /// Enable the public interface of a Load Balancer. The Load Balancer will be accessible from the internet via its public IPs.
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
  ///     "command": "enable_public_interface",
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
  _i19.Future<
    _i20.TonikResult<
      _i48.EnableLoadBalancerPublicInterfaceResponse,
      _i22.Response<_i19.Object?>
    >
  >
  enableLoadBalancerPublicInterface({
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => this._enableLoadBalancerPublicInterface(
    id: id,
    cancellation: cancellation,
  );

  /// Remove Target
  /// Removes a target from a Load Balancer.
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
  ///     "command": "remove_target",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": "2016-01-30T23:56:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 4711,
  ///         "type": "load_balancer"
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
  _i19.Future<
    _i20.TonikResult<
      _i49.RemoveLoadBalancerTargetResponse,
      _i22.Response<_i19.Object?>
    >
  >
  removeLoadBalancerTarget({
    required _i50.LoadBalancersIdActionsRemoveTargetPostBodyBodyModel body,
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => this._removeLoadBalancerTarget(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Update Service
  /// Updates a Load Balancer Service.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `source_port_already_used` | The source port you are trying to add is already in use |
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
  ///     "command": "update_service",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": "2016-01-30T23:56:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 4711,
  ///         "type": "load_balancer"
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
  _i19.Future<
    _i20.TonikResult<
      _i51.UpdateLoadBalancerServiceResponse,
      _i22.Response<_i19.Object?>
    >
  >
  updateLoadBalancerService({
    required _i52.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel
    body,
    required _i19.int id,
    _i20.TonikCancellation? cancellation,
  }) async => this._updateLoadBalancerService(
    body: body,
    id: id,
    cancellation: cancellation,
  );

  /// Get an Action for a Load Balancer
  /// **Deprecated**: This operation is deprecated, see our [changelog](https://docs.hetzner.cloud/changelog#2026-04-30-deprecate-get-resource-action-endpoints) for more details.
  ///
  /// Returns a specific Action for a Load Balancer.
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
  ///         "type": "load_balancer"
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
  @_i19.Deprecated('This operation is deprecated.')
  _i19.Future<
    _i20.TonikResult<
      _i53.GetLoadBalancerActionResponse,
      _i22.Response<_i19.Object?>
    >
  >
  getLoadBalancerAction({
    required _i19.int id,
    required _i19.int actionId,
    _i20.TonikCancellation? cancellation,
  }) async => this._getLoadBalancerAction(
    id: id,
    actionId: actionId,
    cancellation: cancellation,
  );
}
