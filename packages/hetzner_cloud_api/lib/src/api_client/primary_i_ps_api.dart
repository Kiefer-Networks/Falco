// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i7;

import 'package:dio/dio.dart' as _i10;
import 'package:hetzner_cloud_api/src/model/primary_ips_id_put_body_body_model.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/model/primary_ips_parameters_array_model.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/model/primary_ips_post_body_body_model.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/operation/create_primary_ip.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/delete_primary_ip.dart' as _i6;
import 'package:hetzner_cloud_api/src/operation/get_primary_ip.dart' as _i4;
import 'package:hetzner_cloud_api/src/operation/list_primary_ips.dart' as _i2;
import 'package:hetzner_cloud_api/src/operation/update_primary_ip.dart' as _i5;
import 'package:hetzner_cloud_api/src/response_wrapper/create_primary_ip_response.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/response_wrapper/delete_primary_ip_response.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/response_wrapper/get_primary_ip_response.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/response_wrapper/list_primary_ips_response.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/response_wrapper/update_primary_ip_response.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i8;

/// Primary IPs help you to create more flexible networking setups. You can assign at most one Primary IP of type `ipv4` and one of type `ipv6` per Server. This Server then uses these IPs.
///
/// You can only unassign a Primary IP from a Server when it's powered off. This Primary IP can then be assigned to a different powered off Server, or you can keep it around for later use.
///
/// Primary IPs are bound to a specific Location. You can not assign a Primary IP from one Location to a Server in a different Location. If you need this capability use Floating IPs instead.
///
/// If your Server's operating system supports cloud-init there is no further configuration needed to make Primary IPs work.
///
/// Primary IPs of type `ipv4` use a single IPv4 address as their `ip` property. Primary IPs of type `ipv6` use a /64 network such as `fc00::/64` as their `ip` property. Any IP address within that network can be used on your host.
///
/// Primary IPs are billed on an hourly basis.
///
class PrimaryIPsApi {
  PrimaryIPsApi(_i1.Server server)
    : _listPrimaryIps = _i2.ListPrimaryIps(server.baseUrl, () => server.dio),
      _createPrimaryIp = _i3.CreatePrimaryIp(server.baseUrl, () => server.dio),
      _getPrimaryIp = _i4.GetPrimaryIp(server.baseUrl, () => server.dio),
      _updatePrimaryIp = _i5.UpdatePrimaryIp(server.baseUrl, () => server.dio),
      _deletePrimaryIp = _i6.DeletePrimaryIp(server.baseUrl, () => server.dio);

  final _i2.ListPrimaryIps _listPrimaryIps;

  final _i3.CreatePrimaryIp _createPrimaryIp;

  final _i4.GetPrimaryIp _getPrimaryIp;

  final _i5.UpdatePrimaryIp _updatePrimaryIp;

  final _i6.DeletePrimaryIp _deletePrimaryIp;

  /// List Primary IPs
  /// List multiple [Primary IPs](#tag/primary-ips).
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
    _i8.TonikResult<_i9.ListPrimaryIpsResponse, _i10.Response<_i7.Object?>>
  >
  listPrimaryIps({
    _i7.String? name,
    _i7.String? labelSelector,
    _i7.String? ip,
    _i7.int page = _i2.ListPrimaryIps.pageDefault,
    _i7.int perPage = _i2.ListPrimaryIps.perPageDefault,
    _i7.List<_i11.PrimaryIpsParametersArrayModel>? sort,
    _i8.TonikCancellation? cancellation,
  }) async => this._listPrimaryIps(
    name: name,
    labelSelector: labelSelector,
    ip: ip,
    page: page,
    perPage: perPage,
    sort: sort,
    cancellation: cancellation,
  );

  /// Create a Primary IP
  /// Create a new [Primary IP](#tag/primary-ips).
  ///
  /// Can optionally be assigned to a resource by providing an `assignee_id` and `assignee_type`.
  ///
  /// If not assigned to a resource the `location` key needs to be provided. This can be either the ID or the name of the [Location](#tag/locations) this [Primary IP](#tag/primary-ips) shall be created in.
  ///
  /// A [Primary IP](#tag/primary-ips) can only be assigned to resource in the same [Location](#tag/locations) later on.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `server_not_stopped` | The specified [Server](#tag/servers) is running, but needs to be powered off |
  /// | `422` | `server_has_ipv4` | The [Server](#tag/servers) already has an ipv4 address |
  /// | `422` | `server_has_ipv6` | The [Server](#tag/servers) already has an ipv6 address |
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "primary_ip": {
  ///     "id": 42,
  ///     "name": "my-ip",
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "created": "2016-01-30T23:50:00Z",
  ///     "blocked": false,
  ///     "location": {
  ///       "id": 1,
  ///       "name": "fsn1",
  ///       "description": "Falkenstein DC Park 1",
  ///       "country": "DE",
  ///       "city": "Falkenstein",
  ///       "latitude": 50.47612,
  ///       "longitude": 12.370071,
  ///       "network_zone": "eu-central"
  ///     },
  ///     "ip": "2001:db8::/64",
  ///     "dns_ptr": [
  ///       {
  ///         "ip": "2001:db8::1",
  ///         "dns_ptr": "server.example.com"
  ///       }
  ///     ],
  ///     "protection": {
  ///       "delete": false
  ///     },
  ///     "type": "ipv6",
  ///     "auto_delete": true,
  ///     "assignee_type": "server",
  ///     "assignee_id": 17
  ///   },
  ///   "action": {
  ///     "id": 13,
  ///     "command": "assign_primary_ip",
  ///     "status": "running",
  ///     "progress": 0,
  ///     "started": "2016-01-30T23:50:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 17,
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
    _i8.TonikResult<_i12.CreatePrimaryIpResponse, _i10.Response<_i7.Object?>>
  >
  createPrimaryIp({
    required _i13.PrimaryIpsPostBodyBodyModel body,
    _i8.TonikCancellation? cancellation,
  }) async => this._createPrimaryIp(body: body, cancellation: cancellation);

  /// Get a Primary IP
  /// Returns a [Primary IP](#tag/primary-ips).
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
    _i8.TonikResult<_i14.GetPrimaryIpResponse, _i10.Response<_i7.Object?>>
  >
  getPrimaryIp({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._getPrimaryIp(id: id, cancellation: cancellation);

  /// Update a Primary IP
  /// Update a [Primary IP](#tag/primary-ips).
  ///
  /// If another change is concurrently performed on this [Primary IP](#tag/primary-ips), a error response with code `conflict` will be returned.
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
    _i8.TonikResult<_i15.UpdatePrimaryIpResponse, _i10.Response<_i7.Object?>>
  >
  updatePrimaryIp({
    required _i16.PrimaryIpsIdPutBodyBodyModel body,
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async =>
      this._updatePrimaryIp(body: body, id: id, cancellation: cancellation);

  /// Delete a Primary IP
  /// Deletes a [Primary IP](#tag/primary-ips).
  ///
  /// The [Server](#tag/servers) must be powered off (status `off`) in order for this operation to succeed.
  /// If assigned to a [Server](#tag/servers) the [Primary IP](#tag/primary-ips) will be unassigned automatically until 1 May 2026. After this date, the [Primary IP](#tag/primary-ips) needs to be unassigned before it can be deleted.
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
    _i8.TonikResult<_i17.DeletePrimaryIpResponse, _i10.Response<_i7.Object?>>
  >
  deletePrimaryIp({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._deletePrimaryIp(id: id, cancellation: cancellation);
}
