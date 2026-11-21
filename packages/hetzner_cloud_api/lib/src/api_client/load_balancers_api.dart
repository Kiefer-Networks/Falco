// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i8;

import 'package:dio/dio.dart' as _i11;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_metrics_parameters_array_model.dart'
    as _i20;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_put_body_body_model.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/model/load_balancers_parameters_array_model.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/model/load_balancers_post_body_body_model.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/operation/create_load_balancer.dart'
    as _i3;
import 'package:hetzner_cloud_api/src/operation/delete_load_balancer.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/operation/get_load_balancer.dart' as _i4;
import 'package:hetzner_cloud_api/src/operation/get_load_balancer_metrics.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/operation/list_load_balancers.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/operation/update_load_balancer.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/response_wrapper/create_load_balancer_response.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/response_wrapper/delete_load_balancer_response.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/response_wrapper/get_load_balancer_metrics_response.dart'
    as _i19;
import 'package:hetzner_cloud_api/src/response_wrapper/get_load_balancer_response.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/response_wrapper/list_load_balancers_response.dart'
    as _i10;
import 'package:hetzner_cloud_api/src/response_wrapper/update_load_balancer_response.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i9;

class LoadBalancersApi {
  LoadBalancersApi(_i1.Server server)
    : _listLoadBalancers = _i2.ListLoadBalancers(
        server.baseUrl,
        () => server.dio,
      ),
      _createLoadBalancer = _i3.CreateLoadBalancer(
        server.baseUrl,
        () => server.dio,
      ),
      _getLoadBalancer = _i4.GetLoadBalancer(server.baseUrl, () => server.dio),
      _updateLoadBalancer = _i5.UpdateLoadBalancer(
        server.baseUrl,
        () => server.dio,
      ),
      _deleteLoadBalancer = _i6.DeleteLoadBalancer(
        server.baseUrl,
        () => server.dio,
      ),
      _getLoadBalancerMetrics = _i7.GetLoadBalancerMetrics(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListLoadBalancers _listLoadBalancers;

  final _i3.CreateLoadBalancer _createLoadBalancer;

  final _i4.GetLoadBalancer _getLoadBalancer;

  final _i5.UpdateLoadBalancer _updateLoadBalancer;

  final _i6.DeleteLoadBalancer _deleteLoadBalancer;

  final _i7.GetLoadBalancerMetrics _getLoadBalancerMetrics;

  /// List Load Balancers
  /// Gets all existing Load Balancers that you have available.
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
    _i9.TonikResult<_i10.ListLoadBalancersResponse, _i11.Response<_i8.Object?>>
  >
  listLoadBalancers({
    _i8.List<_i12.LoadBalancersParametersArrayModel>? sort,
    _i8.String? name,
    _i8.String? labelSelector,
    _i8.int page = _i2.ListLoadBalancers.pageDefault,
    _i8.int perPage = _i2.ListLoadBalancers.perPageDefault,
    _i9.TonikCancellation? cancellation,
  }) async => this._listLoadBalancers(
    sort: sort,
    name: name,
    labelSelector: labelSelector,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Create a Load Balancer
  /// Creates a Load Balancer.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `412` | `source_port_already_used` | The source port you are trying to add is already in use |
  /// | `412` | `primary_ip_version_mismatch` | The specified Primary IP has the wrong IP version |
  /// | `422` | `ip_not_owned` | The IP is not owned by the owner of the project of the Load Balancer |
  /// | `422` | `load_balancer_not_attached_to_network` | The Load Balancer is not attached to a network |
  /// | `422` | `resolve_cloud_private_targets_error` | The server you are trying to add as a target is not attached to the same network as the Load Balancer |
  /// | `422` | `resolve_cloud_public_targets_error` | The server that you are trying to add as a public target does not have a public IPv4 address |
  /// | `422` | `target_already_defined` | The Load Balancer target you are trying to define is already defined |
  /// | `422` | `primary_ip_assigned` | The specified Primary IP is already assigned to a resource |
  /// | `422` | `primary_ip_blocked` | The specified Primary IP is blocked |
  /// | `422` | `primary_ip_location_mismatch` | The specified Primary IP is bound to a different Location than the Load Balancer |
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "load_balancer": {
  ///     "id": 4711,
  ///     "name": "Web Frontend",
  ///     "public_net": {
  ///       "enabled": false,
  ///       "ipv4": {
  ///         "id": 42,
  ///         "ip": "1.2.3.4",
  ///         "blocked": false,
  ///         "dns_ptr": "lb1.example.com"
  ///       },
  ///       "ipv6": {
  ///         "id": 43,
  ///         "ip": "2001:db8::1",
  ///         "blocked": false,
  ///         "dns_ptr": "lb1.example.com"
  ///       }
  ///     },
  ///     "private_net": [
  ///       {
  ///         "network": 4711,
  ///         "ip": "10.0.0.2"
  ///       }
  ///     ],
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
  ///     "load_balancer_type": {
  ///       "id": 1,
  ///       "name": "lb11",
  ///       "description": "LB11",
  ///       "max_connections": 20000,
  ///       "max_services": 5,
  ///       "max_targets": 25,
  ///       "max_assigned_certificates": 10,
  ///       "deprecation": null,
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
  ///           "included_traffic": 654321,
  ///           "price_per_tb_traffic": {
  ///             "net": "1.0000000000",
  ///             "gross": "1.1900000000000000"
  ///           }
  ///         }
  ///       ]
  ///     },
  ///     "protection": {
  ///       "delete": false
  ///     },
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "created": "2016-01-30T23:50:00Z",
  ///     "services": [
  ///       {
  ///         "protocol": "https",
  ///         "listen_port": 443,
  ///         "destination_port": 80,
  ///         "proxyprotocol": false,
  ///         "health_check": {
  ///           "protocol": "http",
  ///           "port": 4711,
  ///           "interval": 15,
  ///           "timeout": 10,
  ///           "retries": 3,
  ///           "http": {
  ///             "domain": "example.com",
  ///             "path": "/",
  ///             "response": "{\"status\": \"ok\"}",
  ///             "status_codes": [
  ///               "2??,3??"
  ///             ],
  ///             "tls": false
  ///           }
  ///         },
  ///         "http": {
  ///           "cookie_name": "HCLBSTICKY",
  ///           "cookie_lifetime": 300,
  ///           "certificates": [
  ///             897
  ///           ],
  ///           "redirect_http": true,
  ///           "sticky_sessions": true,
  ///           "timeout_idle": 50
  ///         }
  ///       }
  ///     ],
  ///     "targets": [
  ///       {
  ///         "type": "server",
  ///         "server": {
  ///           "id": 80,
  ///           "ip": "2001:db8::1"
  ///         },
  ///         "health_status": [
  ///           {
  ///             "listen_port": 443,
  ///             "status": "healthy"
  ///           }
  ///         ],
  ///         "use_private_ip": true,
  ///         "targets": [
  ///           {
  ///             "type": "server",
  ///             "server": {
  ///               "id": 80,
  ///               "ip": "2001:db8::1"
  ///             },
  ///             "health_status": [
  ///               {
  ///                 "listen_port": 443,
  ///                 "status": "healthy"
  ///               }
  ///             ],
  ///             "use_private_ip": true
  ///           }
  ///         ]
  ///       }
  ///     ],
  ///     "algorithm": {
  ///       "type": "round_robin"
  ///     },
  ///     "outgoing_traffic": 123456,
  ///     "ingoing_traffic": 123456,
  ///     "included_traffic": 654321
  ///   },
  ///   "action": {
  ///     "id": 13,
  ///     "command": "create_load_balancer",
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
  _i8.Future<
    _i9.TonikResult<_i13.CreateLoadBalancerResponse, _i11.Response<_i8.Object?>>
  >
  createLoadBalancer({
    required _i14.LoadBalancersPostBodyBodyModel body,
    _i9.TonikCancellation? cancellation,
  }) async => this._createLoadBalancer(body: body, cancellation: cancellation);

  /// Get a Load Balancer
  /// Gets a specific Load Balancer object.
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
    _i9.TonikResult<_i15.GetLoadBalancerResponse, _i11.Response<_i8.Object?>>
  >
  getLoadBalancer({
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => this._getLoadBalancer(id: id, cancellation: cancellation);

  /// Update a Load Balancer
  /// Updates a Load Balancer. You can update a Load Balancer’s name and a Load Balancer’s labels.
  ///
  /// Note: if the Load Balancer object changes during the request, the response will be a “conflict” error.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "load_balancer": {
  ///     "id": 4711,
  ///     "name": "new-name",
  ///     "public_net": {
  ///       "enabled": false,
  ///       "ipv4": {
  ///         "id": 42,
  ///         "ip": "1.2.3.4",
  ///         "blocked": false,
  ///         "dns_ptr": "lb1.example.com"
  ///       },
  ///       "ipv6": {
  ///         "id": 43,
  ///         "ip": "2001:db8::1",
  ///         "blocked": false,
  ///         "dns_ptr": "lb1.example.com"
  ///       }
  ///     },
  ///     "private_net": [
  ///       {
  ///         "network": 4711,
  ///         "ip": "10.0.0.2"
  ///       }
  ///     ],
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
  ///     "load_balancer_type": {
  ///       "id": 1,
  ///       "name": "lb11",
  ///       "description": "LB11",
  ///       "max_connections": 20000,
  ///       "max_services": 5,
  ///       "max_targets": 25,
  ///       "max_assigned_certificates": 10,
  ///       "deprecation": null,
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
  ///           "included_traffic": 654321,
  ///           "price_per_tb_traffic": {
  ///             "net": "1.0000000000",
  ///             "gross": "1.1900000000000000"
  ///           }
  ///         }
  ///       ]
  ///     },
  ///     "protection": {
  ///       "delete": false
  ///     },
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "created": "2016-01-30T23:50:00Z",
  ///     "services": [
  ///       {
  ///         "protocol": "https",
  ///         "listen_port": 443,
  ///         "destination_port": 80,
  ///         "proxyprotocol": false,
  ///         "health_check": {
  ///           "protocol": "http",
  ///           "port": 4711,
  ///           "interval": 15,
  ///           "timeout": 10,
  ///           "retries": 3,
  ///           "http": {
  ///             "domain": "example.com",
  ///             "path": "/",
  ///             "response": "{\"status\": \"ok\"}",
  ///             "status_codes": [
  ///               "2??,3??"
  ///             ],
  ///             "tls": false
  ///           }
  ///         },
  ///         "http": {
  ///           "cookie_name": "HCLBSTICKY",
  ///           "cookie_lifetime": 300,
  ///           "certificates": [
  ///             897
  ///           ],
  ///           "redirect_http": true,
  ///           "sticky_sessions": true,
  ///           "timeout_idle": 50
  ///         }
  ///       }
  ///     ],
  ///     "targets": [
  ///       {
  ///         "type": "server",
  ///         "server": {
  ///           "id": 80,
  ///           "ip": "2001:db8::1"
  ///         },
  ///         "health_status": [
  ///           {
  ///             "listen_port": 443,
  ///             "status": "healthy"
  ///           }
  ///         ],
  ///         "use_private_ip": true,
  ///         "label_selector": {
  ///           "selector": "env=prod"
  ///         },
  ///         "ip": {
  ///           "ip": "203.0.113.1"
  ///         },
  ///         "targets": [
  ///           {
  ///             "type": "server",
  ///             "server": {
  ///               "id": 80,
  ///               "ip": "2001:db8::1"
  ///             },
  ///             "health_status": [
  ///               {
  ///                 "listen_port": 443,
  ///                 "status": "healthy"
  ///               }
  ///             ],
  ///             "use_private_ip": true
  ///           }
  ///         ]
  ///       }
  ///     ],
  ///     "algorithm": {
  ///       "type": "round_robin"
  ///     },
  ///     "outgoing_traffic": 123456,
  ///     "ingoing_traffic": 123456,
  ///     "included_traffic": 654321
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
    _i9.TonikResult<_i16.UpdateLoadBalancerResponse, _i11.Response<_i8.Object?>>
  >
  updateLoadBalancer({
    required _i17.LoadBalancersIdPutBodyBodyModel body,
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async =>
      this._updateLoadBalancer(body: body, id: id, cancellation: cancellation);

  /// Delete a Load Balancer
  /// Deletes a Load Balancer.
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
    _i9.TonikResult<_i18.DeleteLoadBalancerResponse, _i11.Response<_i8.Object?>>
  >
  deleteLoadBalancer({
    required _i8.int id,
    _i9.TonikCancellation? cancellation,
  }) async => this._deleteLoadBalancer(id: id, cancellation: cancellation);

  /// Get Metrics for a LoadBalancer
  /// You must specify the type of metric to get: `open_connections`, `connections_per_second`, `requests_per_second` or `bandwidth`. You can also specify more than one type by comma separation, e.g. `requests_per_second,bandwidth`.
  ///
  /// Depending on the type you will get different time series data:
  ///
  /// |Type | Timeseries | Unit | Description |
  /// |---- |------------|------|-------------|
  /// | open_connections | open_connections | number | Open connections |
  /// | connections_per_second | connections_per_second | connections/s | Connections per second |
  /// | requests_per_second | requests_per_second | requests/s | Requests per second |
  /// | bandwidth | bandwidth.in | bytes/s | Ingress bandwidth |
  /// || bandwidth.out | bytes/s | Egress bandwidth |
  ///
  /// Metrics are available for the last 30 days only.
  ///
  /// If you do not provide the step argument we will automatically adjust it so that 200 samples are returned.
  ///
  /// We limit the number of samples to a maximum of 500 and will adjust the step parameter accordingly.
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
    _i9.TonikResult<
      _i19.GetLoadBalancerMetricsResponse,
      _i11.Response<_i8.Object?>
    >
  >
  getLoadBalancerMetrics({
    required _i8.int id,
    required _i8.List<_i20.LoadBalancersIdMetricsParametersArrayModel> $type,
    required _i8.String start,
    required _i8.String end,
    _i8.String? step,
    _i9.TonikCancellation? cancellation,
  }) async => this._getLoadBalancerMetrics(
    id: id,
    $type: $type,
    start: start,
    end: end,
    step: step,
    cancellation: cancellation,
  );
}
