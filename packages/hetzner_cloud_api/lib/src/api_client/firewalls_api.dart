// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i7;

import 'package:dio/dio.dart' as _i10;
import 'package:hetzner_cloud_api/src/model/firewalls_id_put_body_body_model.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/model/firewalls_parameters_array_model.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/model/firewalls_post_body_body_model.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/operation/create_firewall.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/delete_firewall.dart' as _i6;
import 'package:hetzner_cloud_api/src/operation/get_firewall.dart' as _i4;
import 'package:hetzner_cloud_api/src/operation/list_firewalls.dart' as _i2;
import 'package:hetzner_cloud_api/src/operation/update_firewall.dart' as _i5;
import 'package:hetzner_cloud_api/src/response_wrapper/create_firewall_response.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/response_wrapper/delete_firewall_response.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/response_wrapper/get_firewall_response.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/response_wrapper/list_firewalls_response.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/response_wrapper/update_firewall_response.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i8;

/// Firewalls can limit the network access to or from your resources.
///
/// - When applying a firewall with no `in` rule all inbound traffic will be dropped. The default for `in` is `DROP`.
/// - When applying a firewall with no `out` rule all outbound traffic will be accepted. The default for `out` is `ACCEPT`.
///
class FirewallsApi {
  FirewallsApi(_i1.Server server)
    : _listFirewalls = _i2.ListFirewalls(server.baseUrl, () => server.dio),
      _createFirewall = _i3.CreateFirewall(server.baseUrl, () => server.dio),
      _getFirewall = _i4.GetFirewall(server.baseUrl, () => server.dio),
      _updateFirewall = _i5.UpdateFirewall(server.baseUrl, () => server.dio),
      _deleteFirewall = _i6.DeleteFirewall(server.baseUrl, () => server.dio);

  final _i2.ListFirewalls _listFirewalls;

  final _i3.CreateFirewall _createFirewall;

  final _i4.GetFirewall _getFirewall;

  final _i5.UpdateFirewall _updateFirewall;

  final _i6.DeleteFirewall _deleteFirewall;

  /// List Firewalls
  /// Returns all [Firewalls](#tag/firewalls).
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
    _i8.TonikResult<_i9.ListFirewallsResponse, _i10.Response<_i7.Object?>>
  >
  listFirewalls({
    _i7.List<_i11.FirewallsParametersArrayModel>? sort,
    _i7.String? name,
    _i7.String? labelSelector,
    _i7.int page = _i2.ListFirewalls.pageDefault,
    _i7.int perPage = _i2.ListFirewalls.perPageDefault,
    _i8.TonikCancellation? cancellation,
  }) async => this._listFirewalls(
    sort: sort,
    name: name,
    labelSelector: labelSelector,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Create a Firewall
  /// Create a [Firewall](#tag/firewalls).
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `server_already_added` | The [Server](#tag/servers) was applied more than once. |
  /// | `422` | `incompatible_network_type` | The resources network type is not supported by [Firewalls](#tag/firewalls). |
  /// | `422` | `firewall_resource_not_found` | The resource the [Firewall](#tag/firewalls) should be attached to was not found. |
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Request body (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "name": "Corporate Intranet Protection",
  ///   "labels": {
  ///     "key": "value"
  ///   },
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
  ///   ],
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
    _i8.TonikResult<_i12.CreateFirewallResponse, _i10.Response<_i7.Object?>>
  >
  createFirewall({
    required _i13.FirewallsPostBodyBodyModel body,
    _i8.TonikCancellation? cancellation,
  }) async => this._createFirewall(body: body, cancellation: cancellation);

  /// Get a Firewall
  /// Returns a single [Firewall](#tag/firewalls).
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
    _i8.TonikResult<_i14.GetFirewallResponse, _i10.Response<_i7.Object?>>
  >
  getFirewall({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._getFirewall(id: id, cancellation: cancellation);

  /// Update a Firewall
  /// Update a [Firewall](#tag/firewalls).
  ///
  /// In case of a parallel running change on the [Firewall](#tag/firewalls) a `conflict` error will be returned.
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
    _i8.TonikResult<_i15.UpdateFirewallResponse, _i10.Response<_i7.Object?>>
  >
  updateFirewall({
    required _i16.FirewallsIdPutBodyBodyModel body,
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async =>
      this._updateFirewall(body: body, id: id, cancellation: cancellation);

  /// Delete a Firewall
  /// Deletes the [Firewall](#tag/firewalls).
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `resource_in_use` | [Firewall](#tag/firewalls) still applied to a resource |
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
    _i8.TonikResult<_i17.DeleteFirewallResponse, _i10.Response<_i7.Object?>>
  >
  deleteFirewall({
    required _i7.int id,
    _i8.TonikCancellation? cancellation,
  }) async => this._deleteFirewall(id: id, cancellation: cancellation);
}
