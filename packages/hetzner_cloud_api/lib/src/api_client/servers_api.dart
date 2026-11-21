// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i8;

import 'package:dio/dio.dart' as _i11;
import 'package:hetzner_cloud_api/src/model/servers_id_metrics_parameters_array_model.dart'
    as _i21;
import 'package:hetzner_cloud_api/src/model/servers_id_put_body_body_model.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/model/servers_parameters_array_model.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/model/servers_parameters_array_model2.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/model/servers_post_body_body_model.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/operation/create_server.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/delete_server.dart' as _i6;
import 'package:hetzner_cloud_api/src/operation/get_server.dart' as _i4;
import 'package:hetzner_cloud_api/src/operation/get_server_metrics.dart' as _i7;
import 'package:hetzner_cloud_api/src/operation/list_servers.dart' as _i2;
import 'package:hetzner_cloud_api/src/operation/update_server.dart' as _i5;
import 'package:hetzner_cloud_api/src/response_wrapper/create_server_response.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/response_wrapper/delete_server_response.dart'
    as _i19;
import 'package:hetzner_cloud_api/src/response_wrapper/get_server_metrics_response.dart'
    as _i20;
import 'package:hetzner_cloud_api/src/response_wrapper/get_server_response.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/response_wrapper/list_servers_response.dart'
    as _i10;
import 'package:hetzner_cloud_api/src/response_wrapper/update_server_response.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i9;

/// Servers are virtual machines that can be provisioned.
///
class ServersApi {
  ServersApi(_i1.Server server)
    : _listServers = _i2.ListServers(server.baseUrl, () => server.dio),
      _createServer = _i3.CreateServer(server.baseUrl, () => server.dio),
      _getServer = _i4.GetServer(server.baseUrl, () => server.dio),
      _updateServer = _i5.UpdateServer(server.baseUrl, () => server.dio),
      _deleteServer = _i6.DeleteServer(server.baseUrl, () => server.dio),
      _getServerMetrics = _i7.GetServerMetrics(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListServers _listServers;

  final _i3.CreateServer _createServer;

  final _i4.GetServer _getServer;

  final _i5.UpdateServer _updateServer;

  final _i6.DeleteServer _deleteServer;

  final _i7.GetServerMetrics _getServerMetrics;

  /// List Servers
  /// Returns all existing Server objects.
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
    _i9.TonikResult<_i10.ListServersResponse, _i11.Response<_i8.Object?>>
  >
  listServers({
    _i8.String? name,
    _i8.String? labelSelector,
    _i8.List<_i12.ServersParametersArrayModel>? sort,
    _i8.List<_i13.ServersParametersArrayModel2>? status,
    _i8.int page = _i2.ListServers.pageDefault,
    _i8.int perPage = _i2.ListServers.perPageDefault,
    _i9.TonikCancellation? cancellation,
  }) async => this._listServers(
    name: name,
    labelSelector: labelSelector,
    sort: sort,
    status: status,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Create a Server
  /// Creates a new Server. Returns preliminary information about the Server as well as an Action that covers progress of creation.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `412` | `primary_ip_version_mismatch` | The specified Primary IP has the wrong IP Version |
  /// | `422` | `placement_error` | An error during the placement occurred |
  /// | `422` | `primary_ip_assigned` | The specified Primary IP is already assigned to a server |
  /// | `422` | `primary_ip_datacenter_mismatch` | The specified Primary IP is in a different location |
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "server": {
  ///     "id": 42,
  ///     "name": "my-server",
  ///     "status": "initializing",
  ///     "created": "2016-01-30T23:50:00Z",
  ///     "public_net": {
  ///       "ipv4": {
  ///         "ip": "1.2.3.4",
  ///         "blocked": false,
  ///         "dns_ptr": "server01.example.com"
  ///       },
  ///       "ipv6": {
  ///         "ip": "2001:db8::/64",
  ///         "blocked": false,
  ///         "dns_ptr": [
  ///           {
  ///             "ip": "2001:db8::1",
  ///             "dns_ptr": "server.example.com"
  ///           }
  ///         ]
  ///       },
  ///       "floating_ips": [
  ///         478
  ///       ],
  ///       "firewalls": [
  ///         {
  ///           "id": 38,
  ///           "status": "applied"
  ///         }
  ///       ]
  ///     },
  ///     "private_net": [
  ///       {
  ///         "network": 4711,
  ///         "ip": "10.0.0.2",
  ///         "alias_ips": [],
  ///         "mac_address": "86:00:ff:2a:7d:e1"
  ///       }
  ///     ],
  ///     "server_type": {
  ///       "id": 1,
  ///       "name": "cpx22",
  ///       "description": "CPX22",
  ///       "cores": 2,
  ///       "memory": 4,
  ///       "disk": 80,
  ///       "prices": [
  ///         {
  ///           "location": "fsn1",
  ///           "price_hourly": {
  ///             "net": "1.0000000000",
  ///             "gross": "1.1900000000000000"
  ///           },
  ///           "price_monthly": {
  ///             "net": "1.0000000000",
  ///             "gross": "1.1900000000000000"
  ///           },
  ///           "included_traffic": 21990232555520,
  ///           "price_per_tb_traffic": {
  ///             "net": "1.0000000000",
  ///             "gross": "1.1900000000000000"
  ///           }
  ///         }
  ///       ],
  ///       "storage_type": "local",
  ///       "cpu_type": "shared",
  ///       "architecture": "x86",
  ///       "locations": [
  ///         {
  ///           "id": 1,
  ///           "name": "fsn1",
  ///           "deprecation": null,
  ///           "available": true,
  ///           "recommended": true
  ///         },
  ///         {
  ///           "id": 2,
  ///           "name": "nbg1",
  ///           "deprecation": {
  ///             "announced": "2018-02-28T00:00:00Z",
  ///             "unavailable_after": "2018-05-31T00:00:00Z"
  ///           },
  ///           "available": false,
  ///           "recommended": false
  ///         }
  ///       ]
  ///     },
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
  ///     "image": {
  ///       "id": 4711,
  ///       "type": "snapshot",
  ///       "status": "available",
  ///       "name": "ubuntu-24.04",
  ///       "description": "Ubuntu 24.04 Standard 64 bit",
  ///       "image_size": 2.3,
  ///       "disk_size": 10,
  ///       "created": "2016-01-30T23:50:00Z",
  ///       "created_from": {
  ///         "id": 1,
  ///         "name": "Server"
  ///       },
  ///       "bound_to": null,
  ///       "os_flavor": "ubuntu",
  ///       "os_version": "24.04",
  ///       "rapid_deploy": false,
  ///       "protection": {
  ///         "delete": false
  ///       },
  ///       "deprecation": null,
  ///       "deleted": null,
  ///       "labels": {
  ///         "key": "value"
  ///       },
  ///       "architecture": "x86"
  ///     },
  ///     "iso": {
  ///       "id": 4711,
  ///       "name": "FreeBSD-11.0-RELEASE-amd64-dvd1",
  ///       "description": "FreeBSD 11.0 x64",
  ///       "type": "public",
  ///       "deprecation": {
  ///         "announced": "2018-02-28T00:00:00Z",
  ///         "unavailable_after": "2018-05-31T00:00:00Z"
  ///       },
  ///       "architecture": "x86"
  ///     },
  ///     "rescue_enabled": false,
  ///     "locked": false,
  ///     "backup_window": "22-02",
  ///     "outgoing_traffic": 123456,
  ///     "ingoing_traffic": 123456,
  ///     "included_traffic": 654321,
  ///     "protection": {
  ///       "delete": false,
  ///       "rebuild": false
  ///     },
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "volumes": [],
  ///     "load_balancers": [],
  ///     "primary_disk_size": 50
  ///   },
  ///   "action": {
  ///     "id": 1,
  ///     "command": "create_server",
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
  ///   "next_actions": [
  ///     {
  ///       "id": 13,
  ///       "command": "start_server",
  ///       "status": "running",
  ///       "progress": 0,
  ///       "started": "2016-01-30T23:50:00Z",
  ///       "finished": null,
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
  ///   "root_password": "YItygq1v3GYjjMomLaKc"
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
    _i9.TonikResult<_i14.CreateServerResponse, _i11.Response<_i8.Object?>>
  >
  createServer({
    required _i15.ServersPostBodyBodyModel body,
    _i9.TonikCancellation? cancellation,
  }) async => this._createServer(body: body, cancellation: cancellation);

  /// Get a Server
  /// Returns a specific Server object. The Server must exist inside the Project.
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
    _i9.TonikResult<_i16.GetServerResponse, _i11.Response<_i8.Object?>>
  >
  getServer({required _i8.int id, _i9.TonikCancellation? cancellation}) async =>
      this._getServer(id: id, cancellation: cancellation);

  /// Update a Server
  /// Updates a Server. You can update a Server’s name and a Server’s labels.
  ///
  /// Please note that Server names must be unique per Project and valid hostnames as per RFC 1123 (i.e. may only contain letters, digits, periods, and dashes).
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
    _i9.TonikResult<_i17.UpdateServerResponse, _i11.Response<_i8.Object?>>
  >
  updateServer({
    required _i18.ServersIdPutBodyBodyModel body,
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async =>
      this._updateServer(body: body, id: id, cancellation: cancellation);

  /// Delete a Server
  /// Deletes a Server.
  ///
  /// This immediately removes the Server from your account, and it is no longer
  /// accessible. Any resources attached to the server (like Volumes, Primary IPs,
  /// Floating IPs, Firewalls, Placement Groups) are detached while the server is deleted.
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
    _i9.TonikResult<_i19.DeleteServerResponse, _i11.Response<_i8.Object?>>
  >
  deleteServer({
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => this._deleteServer(id: id, cancellation: cancellation);

  /// Get Metrics for a Server
  /// Get Metrics for specified Server.
  ///
  /// You must specify the type of metric to get: cpu, disk or network. You can also specify more than one type by comma separation, e.g. cpu,disk.
  ///
  /// Depending on the type you will get different time series data
  ///
  /// | Type    | Timeseries              | Unit      | Description                                          |
  /// |---------|-------------------------|-----------|------------------------------------------------------|
  /// | cpu     | cpu                     | percent   | Percent CPU usage                                    |
  /// | disk    | disk.0.iops.read        | iop/s     | Number of read IO operations per second              |
  /// |         | disk.0.iops.write       | iop/s     | Number of write IO operations per second             |
  /// |         | disk.0.bandwidth.read   | bytes/s   | Bytes read per second                                |
  /// |         | disk.0.bandwidth.write  | bytes/s   | Bytes written per second                             |
  /// | network | network.0.pps.in        | packets/s | Public Network interface packets per second received |
  /// |         | network.0.pps.out       | packets/s | Public Network interface packets per second sent     |
  /// |         | network.0.bandwidth.in  | bytes/s   | Public Network interface bytes/s received            |
  /// |         | network.0.bandwidth.out | bytes/s   | Public Network interface bytes/s sent                |
  ///
  /// Note that the CPU value is not normalized to a fixed 0–100% scale. It is calculated per vCPU: a value of 100 represents full utilization on a 1-vCPU server, and 25% utilization on a 4-vCPU server. To calculate the overall CPU usage, divide the metric value by the number of vCPUs.
  ///
  /// Metrics are available for the last 30 days only.
  ///
  /// If you do not provide the step argument we will automatically adjust it so that a maximum of 200 samples are returned.
  ///
  /// We limit the number of samples returned to a maximum of 500 and will adjust the step parameter accordingly.
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
    _i9.TonikResult<_i20.GetServerMetricsResponse, _i11.Response<_i8.Object?>>
  >
  getServerMetrics({
    required _i8.int id,
    required _i8.List<_i21.ServersIdMetricsParametersArrayModel> $type,
    required _i8.String start,
    required _i8.String end,
    _i8.String? step,
    _i9.TonikCancellation? cancellation,
  }) async => this._getServerMetrics(
    id: id,
    $type: $type,
    start: start,
    end: end,
    step: step,
    cancellation: cancellation,
  );
}
