// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i8;

import 'package:dio/dio.dart' as _i11;
import 'package:hetzner_cloud_api/src/model/networks_id_members_parameters_array_model.dart'
    as _i21;
import 'package:hetzner_cloud_api/src/model/networks_id_members_parameters_array_model2.dart'
    as _i22;
import 'package:hetzner_cloud_api/src/model/networks_id_members_parameters_array_model3.dart'
    as _i20;
import 'package:hetzner_cloud_api/src/model/networks_id_put_body_body_model.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/model/networks_parameters_array_model.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/model/networks_post_body_body_model.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/operation/create_network.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/delete_network.dart' as _i6;
import 'package:hetzner_cloud_api/src/operation/get_network.dart' as _i4;
import 'package:hetzner_cloud_api/src/operation/list_network_members.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/operation/list_networks.dart' as _i2;
import 'package:hetzner_cloud_api/src/operation/update_network.dart' as _i5;
import 'package:hetzner_cloud_api/src/response_wrapper/create_network_response.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/response_wrapper/delete_network_response.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/response_wrapper/get_network_response.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/response_wrapper/list_network_members_response.dart'
    as _i19;
import 'package:hetzner_cloud_api/src/response_wrapper/list_networks_response.dart'
    as _i10;
import 'package:hetzner_cloud_api/src/response_wrapper/update_network_response.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i9;

/// Networks is a private networks feature. These Networks are optional and they coexist with the public network that every Server has by default.
///
/// They allow Servers to talk to each other over a dedicated network interface using private IP addresses not available publicly.
///
/// The IP addresses are allocated and managed via the API, they must conform to [RFC1918](https://tools.ietf.org/html/rfc1918#section-3) standard. IPs and network interfaces defined under Networks do not provide public internet connectivity, you will need to use the already existing public network interface for that.
///
/// Each network has a user selected `ip_range` which defines all available IP addresses which can be used for Subnets within the Network.
///
/// To assign individual IPs to Servers you will need to create Network Subnets, described below.
///
/// Currently Networks support IPv4 only.
///
/// ### Subnets
///
/// Subnets divide the `ip_range` from the parent Network object into multiple Subnetworks that you can use for different specific purposes.
///
/// For each subnet you need to specify its own `ip_range` which must be contained within the parent Network’s `ip_range`. Additionally each subnet must belong to one of the available Network Zones described below. Subnets can not have overlapping IP ranges.
///
/// Currently there are three types of subnet:
///
/// - type `cloud` is used to connect cloud Resources into your Network.
/// - type `server` was used to connect only cloud Servers into your Network. This type is deprecated and is replaced by type cloud.
/// - type `vswitch` allows you to connect [Dedicated Server vSwitch](https://docs.hetzner.com/robot/dedicated-server/network/vswitch) - and all Dedicated Servers attached to it - into your Network
///
/// Subnets of type `vswitch` must set a `vswitch_id` which is the ID of the existing vSwitch in Hetzner Robot that should be coupled.
///
/// ### Network Zones
///
/// Network Zones are groups of Locations which have special high-speed network connections between them. The [Location object](https://docs.hetzner.cloud/reference/cloud#locations-get-a-location) contains the `network_zone` property each Location belongs to. Currently these network zones exist:
///
/// | Network Zone | Contains Locations |
/// | ------------ | ------------------ |
/// | eu-central   | nbg1, fsn1, hel1   |
/// | us-east      | ash                |
/// | us-west      | hil                |
/// | ap-southeast | sin                |
///
/// ### IP address management
///
/// When a cloud Server is attached to a network without the user specifying an IP it automatically gets an IP address assigned from a subnet of type `server` in the same network zone. If you specify the optional `ip` parameter when attaching then we will try to assign that IP. Keep in mind that the Server’s location must be covered by the Subnet’s Network Zone if you specify an IP, or that at least one Subnet with the zone covering Server’s location must exist.
///
/// A cloud Server can also have more than one IP address in a Network by specifying aliases. For details see the [attach to network action](https://docs.hetzner.cloud/reference/cloud#server-actions-attach-a-server-to-a-network).
///
/// The following IP addresses are reserved in networks and can not be used:
///
/// - the first IP of the network `ip_range` as it will be used as a default gateway for the private Network interface.
/// - `172.31.1.1` as it is being used as default gateway for our public Network interfaces.
///
/// ### Coupling Dedicated Servers
///
/// By using subnets of type `vswitch` you can couple the Cloud Networks with an existing [Dedicated Server vSwitch](https://docs.hetzner.com/robot/dedicated-server/network/vswitch) and enable dedicated and cloud servers to
/// talk to each other over the Network.
/// In order for this to work the dedicated servers may only use IPs from the subnet and must have a special network configuration. Please refer to [FAQ](https://docs.hetzner.com/cloud/networks/connect-dedi-vswitch). vSwitch Layer 2 features are not supported.
///
/// ### Routes
///
/// Networks also support the notion of routes which are automatically applied to private traffic. A route makes sure that all packets for a given `destination` IP prefix will be sent to the address specified in its `gateway`.
///
class NetworksApi {
  NetworksApi(_i1.Server server)
    : _listNetworks = _i2.ListNetworks(server.baseUrl, () => server.dio),
      _createNetwork = _i3.CreateNetwork(server.baseUrl, () => server.dio),
      _getNetwork = _i4.GetNetwork(server.baseUrl, () => server.dio),
      _updateNetwork = _i5.UpdateNetwork(server.baseUrl, () => server.dio),
      _deleteNetwork = _i6.DeleteNetwork(server.baseUrl, () => server.dio),
      _listNetworkMembers = _i7.ListNetworkMembers(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListNetworks _listNetworks;

  final _i3.CreateNetwork _createNetwork;

  final _i4.GetNetwork _getNetwork;

  final _i5.UpdateNetwork _updateNetwork;

  final _i6.DeleteNetwork _deleteNetwork;

  final _i7.ListNetworkMembers _listNetworkMembers;

  /// List Networks
  /// List multiple [Networks](#tag/networks).
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
  _i8.Future<
    _i9.TonikResult<_i10.ListNetworksResponse, _i11.Response<_i8.Object?>>
  >
  listNetworks({
    _i8.List<_i12.NetworksParametersArrayModel>? sort,
    _i8.String? name,
    _i8.String? labelSelector,
    _i8.int page = _i2.ListNetworks.pageDefault,
    _i8.int perPage = _i2.ListNetworks.perPageDefault,
    _i9.TonikCancellation? cancellation,
  }) async => this._listNetworks(
    sort: sort,
    name: name,
    labelSelector: labelSelector,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Create a Network
  /// Creates a [Network](#tag/networks).
  ///
  /// The provided `ip_range` can only be extended later on, but not reduced.
  ///
  /// Subnets can be added now or later on using the [add subnet action](#tag/network-actions/add_network_subnet). If you do not specify an `ip_range` for the subnet the first available /24 range will be used.
  ///
  /// Routes can be added now or later by using the [add route action](#tag/network-actions/add_network_route).
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
  _i8.Future<
    _i9.TonikResult<_i13.CreateNetworkResponse, _i11.Response<_i8.Object?>>
  >
  createNetwork({
    required _i14.NetworksPostBodyBodyModel body,
    _i9.TonikCancellation? cancellation,
  }) async => this._createNetwork(body: body, cancellation: cancellation);

  /// Get a Network
  /// Get a specific [Network](#tag/networks).
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
  _i8.Future<
    _i9.TonikResult<_i15.GetNetworkResponse, _i11.Response<_i8.Object?>>
  >
  getNetwork({
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => this._getNetwork(id: id, cancellation: cancellation);

  /// Update a Network
  /// Update a [Network](#tag/networks).
  ///
  /// If a change is currently being performed on this [Network](#tag/networks), a error response with code `conflict` will be returned.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "network": {
  ///     "id": 4711,
  ///     "name": "new-name",
  ///     "ip_range": "10.0.0.0/16",
  ///     "subnets": [
  ///       {
  ///         "type": "cloud",
  ///         "ip_range": "10.0.1.0/24",
  ///         "network_zone": "eu-central",
  ///         "gateway": "10.0.0.1"
  ///       }
  ///     ],
  ///     "routes": [
  ///       {
  ///         "destination": "10.100.1.0/24",
  ///         "gateway": "10.0.1.1"
  ///       }
  ///     ],
  ///     "servers": [
  ///       42
  ///     ],
  ///     "load_balancers": [
  ///       42
  ///     ],
  ///     "protection": {
  ///       "delete": false
  ///     },
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "created": "2016-01-30T23:50:00Z",
  ///     "expose_routes_to_vswitch": true
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
  _i8.Future<
    _i9.TonikResult<_i16.UpdateNetworkResponse, _i11.Response<_i8.Object?>>
  >
  updateNetwork({
    required _i17.NetworksIdPutBodyBodyModel body,
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async =>
      this._updateNetwork(body: body, id: id, cancellation: cancellation);

  /// Delete a Network
  /// Deletes a [Network](#tag/networks).
  ///
  /// Attached resources will be detached automatically.
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
  _i8.Future<
    _i9.TonikResult<_i18.DeleteNetworkResponse, _i11.Response<_i8.Object?>>
  >
  deleteNetwork({
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => this._deleteNetwork(id: id, cancellation: cancellation);

  /// List Members of a Network
  /// List the resources attached to a specific [Network](#tag/networks).
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
  ///   "members": [
  ///     {
  ///       "type": "server",
  ///       "id": 123,
  ///       "ip": "10.0.1.2",
  ///       "status": "attaching",
  ///       "alias_ips": [
  ///         "10.0.1.20"
  ///       ],
  ///       "subnet": "10.0.1.0/24"
  ///     },
  ///     {
  ///       "type": "load_balancer",
  ///       "id": 43,
  ///       "ip": "10.0.1.3",
  ///       "status": "updating",
  ///       "alias_ips": [],
  ///       "subnet": "10.0.1.0/24"
  ///     }
  ///   ],
  ///   "meta": {
  ///     "pagination": {
  ///       "page": 1,
  ///       "per_page": 25,
  ///       "previous_page": null,
  ///       "next_page": 2,
  ///       "last_page": 4,
  ///       "total_entries": 100
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
  _i8.Future<
    _i9.TonikResult<_i19.ListNetworkMembersResponse, _i11.Response<_i8.Object?>>
  >
  listNetworkMembers({
    required _i8.int id,
    _i8.List<_i20.NetworksIdMembersParametersArrayModel3>? $type,
    _i8.List<_i8.String>? subnet,
    _i8.List<_i21.NetworksIdMembersParametersArrayModel>? status,
    _i8.List<_i22.NetworksIdMembersParametersArrayModel2>? sort,
    _i8.int page = _i7.ListNetworkMembers.pageDefault,
    _i8.int perPage = _i7.ListNetworkMembers.perPageDefault,
    _i9.TonikCancellation? cancellation,
  }) async => this._listNetworkMembers(
    id: id,
    $type: $type,
    subnet: subnet,
    status: status,
    sort: sort,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );
}
