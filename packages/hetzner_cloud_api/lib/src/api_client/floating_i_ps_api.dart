// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i7;

import 'package:dio/dio.dart' as _i10;
import 'package:hetzner_cloud_api/src/model/floating_ips_id_put_body_body_model.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/model/floating_ips_parameters_array_model.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/model/floating_ips_post_body_body_model.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/operation/create_floating_ip.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/delete_floating_ip.dart' as _i6;
import 'package:hetzner_cloud_api/src/operation/get_floating_ip.dart' as _i4;
import 'package:hetzner_cloud_api/src/operation/list_floating_ips.dart' as _i2;
import 'package:hetzner_cloud_api/src/operation/update_floating_ip.dart' as _i5;
import 'package:hetzner_cloud_api/src/response_wrapper/create_floating_ip_response.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/response_wrapper/delete_floating_ip_response.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/response_wrapper/get_floating_ip_response.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/response_wrapper/list_floating_ips_response.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/response_wrapper/update_floating_ip_response.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i8;

/// Floating IPs help you to create highly available setups. You can assign a Floating IP to any Server. The Server can then use this IP. You can reassign it to a different Server at any time, or you can choose to unassign the IP from Servers all together.
///
/// Floating IPs can be used globally. This means you can assign a Floating IP to a Server in one Location and later reassign it to a Server in a different Location. For optimal routing and latency Floating IPs should be used in the Location they were created in.
///
/// For Floating IPs to work with your Server, you must configure them inside your operation system.
///
/// Floating IPs of type `ipv4` use a single IPv4 address as their `ip` property. Floating IPs of type `ipv6` use a /64 network such as `fc00::/64` as their `ip` property. Any IP address within that network can be used on your host.
///
/// Floating IPs are billed on a monthly basis.
///
class FloatingIPsApi {
  FloatingIPsApi(_i1.Server server)
    : _listFloatingIps = _i2.ListFloatingIps(server.baseUrl, () => server.dio),
      _createFloatingIp = _i3.CreateFloatingIp(
        server.baseUrl,
        () => server.dio,
      ),
      _getFloatingIp = _i4.GetFloatingIp(server.baseUrl, () => server.dio),
      _updateFloatingIp = _i5.UpdateFloatingIp(
        server.baseUrl,
        () => server.dio,
      ),
      _deleteFloatingIp = _i6.DeleteFloatingIp(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListFloatingIps _listFloatingIps;

  final _i3.CreateFloatingIp _createFloatingIp;

  final _i4.GetFloatingIp _getFloatingIp;

  final _i5.UpdateFloatingIp _updateFloatingIp;

  final _i6.DeleteFloatingIp _deleteFloatingIp;

  /// List Floating IPs
  /// List multiple [Floating IPs](#tag/floating-ips).
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
  _i7.Future<
    _i8.TonikResult<_i9.ListFloatingIpsResponse, _i10.Response<_i7.Object?>>
  >
  listFloatingIps({
    _i7.String? name,
    _i7.String? labelSelector,
    _i7.List<_i11.FloatingIpsParametersArrayModel>? sort,
    _i7.int page = _i2.ListFloatingIps.pageDefault,
    _i7.int perPage = _i2.ListFloatingIps.perPageDefault,
    _i8.TonikCancellation? cancellation,
  }) async => this._listFloatingIps(
    name: name,
    labelSelector: labelSelector,
    sort: sort,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Create a Floating IP
  /// Create a [Floating IP](#tag/floating-ips).
  ///
  /// Provide the `server` attribute to assign the [Floating IP](#tag/floating-ips) to that server or provide a `home_location` to locate the [Floating IP](#tag/floating-ips) at. Note that the [Floating IP](#tag/floating-ips) can be assigned to a [Server](#tag/servers) in any [Location](#tag/locations) later on. For optimal routing it is advised to use the [Floating IP](#tag/floating-ips) in the same [Location](#tag/locations) it was created in.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "floating_ip": {
  ///     "id": 4711,
  ///     "name": "Web Frontend",
  ///     "description": "Web Frontend",
  ///     "ip": "2001:db8::/64",
  ///     "type": "ipv6",
  ///     "server": 42,
  ///     "dns_ptr": [
  ///       {
  ///         "ip": "2001:db8::1",
  ///         "dns_ptr": "server.example.com"
  ///       }
  ///     ],
  ///     "home_location": {
  ///       "id": 1,
  ///       "name": "fsn1",
  ///       "description": "Falkenstein DC Park 1",
  ///       "country": "DE",
  ///       "city": "Falkenstein",
  ///       "latitude": 50.47612,
  ///       "longitude": 12.370071,
  ///       "network_zone": "eu-central"
  ///     },
  ///     "blocked": false,
  ///     "protection": {
  ///       "delete": false
  ///     },
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "created": "2016-01-30T23:50:00Z"
  ///   },
  ///   "action": {
  ///     "id": 13,
  ///     "command": "assign_floating_ip",
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
  _i7.Future<
    _i8.TonikResult<_i12.CreateFloatingIpResponse, _i10.Response<_i7.Object?>>
  >
  createFloatingIp({
    required _i13.FloatingIpsPostBodyBodyModel body,
    _i8.TonikCancellation? cancellation,
  }) async => this._createFloatingIp(body: body, cancellation: cancellation);

  /// Get a Floating IP
  /// Returns a single [Floating IP](#tag/floating-ips).
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
  _i7.Future<
    _i8.TonikResult<_i14.GetFloatingIpResponse, _i10.Response<_i7.Object?>>
  >
  getFloatingIp({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._getFloatingIp(id: id, cancellation: cancellation);

  /// Update a Floating IP
  /// Update a [Floating IP](#tag/floating-ips).
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "floating_ip": {
  ///     "id": 4711,
  ///     "name": "Web Frontend",
  ///     "description": "Web Frontend",
  ///     "ip": "2001:db8::/64",
  ///     "type": "ipv6",
  ///     "server": 42,
  ///     "dns_ptr": [
  ///       {
  ///         "ip": "2001:db8::1",
  ///         "dns_ptr": "server.example.com"
  ///       }
  ///     ],
  ///     "home_location": {
  ///       "id": 1,
  ///       "name": "fsn1",
  ///       "description": "Falkenstein DC Park 1",
  ///       "country": "DE",
  ///       "city": "Falkenstein",
  ///       "latitude": 50.47612,
  ///       "longitude": 12.370071,
  ///       "network_zone": "eu-central"
  ///     },
  ///     "blocked": false,
  ///     "protection": {
  ///       "delete": false
  ///     },
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "created": "2016-01-30T23:50:00Z"
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
  _i7.Future<
    _i8.TonikResult<_i15.UpdateFloatingIpResponse, _i10.Response<_i7.Object?>>
  >
  updateFloatingIp({
    required _i16.FloatingIpsIdPutBodyBodyModel body,
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async =>
      this._updateFloatingIp(body: body, id: id, cancellation: cancellation);

  /// Delete a Floating IP
  /// Deletes a [Floating IP](#tag/floating-ips).
  ///
  /// If assigned to a [Server](#tag/servers) the [Floating IP](#tag/floating-ips) will be unassigned automatically until 1 May 2026. After this date, the [Floating IP](#tag/floating-ips) needs to be unassigned before it can be deleted.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `must_be_unassigned` | Error when IP is still assigned to a Resource. This error will appear as of 1 May 2026. |
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
  _i7.Future<
    _i8.TonikResult<_i17.DeleteFloatingIpResponse, _i10.Response<_i7.Object?>>
  >
  deleteFloatingIp({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._deleteFloatingIp(id: id, cancellation: cancellation);
}
