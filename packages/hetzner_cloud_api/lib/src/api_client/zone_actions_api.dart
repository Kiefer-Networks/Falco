// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i10;

import 'package:dio/dio.dart' as _i13;
import 'package:hetzner_cloud_api/src/model/zones_actions_parameters_array_model.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/model/zones_actions_parameters_array_model2.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_change_primary_nameservers_post_body_body_model.dart'
    as _i22;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_change_protection_post_body_body_model.dart'
    as _i24;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_change_ttl_post_body_body_model.dart'
    as _i26;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_import_zonefile_post_body_body_model.dart'
    as _i28;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_parameters_array_model.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_actions_parameters_array_model2.dart'
    as _i19;
import 'package:hetzner_cloud_api/src/operation/change_zone_primary_nameservers.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/operation/change_zone_protection.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/operation/change_zone_ttl.dart' as _i8;
import 'package:hetzner_cloud_api/src/operation/get_zone_action.dart' as _i5;
import 'package:hetzner_cloud_api/src/operation/get_zones_action.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/import_zone_zonefile.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/operation/list_zone_actions.dart' as _i4;
import 'package:hetzner_cloud_api/src/operation/list_zones_actions.dart' as _i2;
import 'package:hetzner_cloud_api/src/response_wrapper/change_zone_primary_nameservers_response.dart'
    as _i21;
import 'package:hetzner_cloud_api/src/response_wrapper/change_zone_protection_response.dart'
    as _i23;
import 'package:hetzner_cloud_api/src/response_wrapper/change_zone_ttl_response.dart'
    as _i25;
import 'package:hetzner_cloud_api/src/response_wrapper/get_zone_action_response.dart'
    as _i20;
import 'package:hetzner_cloud_api/src/response_wrapper/get_zones_action_response.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/response_wrapper/import_zone_zonefile_response.dart'
    as _i27;
import 'package:hetzner_cloud_api/src/response_wrapper/list_zone_actions_response.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/response_wrapper/list_zones_actions_response.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i11;

class ZoneActionsApi {
  ZoneActionsApi(_i1.Server server)
    : _listZonesActions = _i2.ListZonesActions(
        server.baseUrl,
        () => server.dio,
      ),
      _getZonesAction = _i3.GetZonesAction(server.baseUrl, () => server.dio),
      _listZoneActions = _i4.ListZoneActions(server.baseUrl, () => server.dio),
      _getZoneAction = _i5.GetZoneAction(server.baseUrl, () => server.dio),
      _changeZonePrimaryNameservers = _i6.ChangeZonePrimaryNameservers(
        server.baseUrl,
        () => server.dio,
      ),
      _changeZoneProtection = _i7.ChangeZoneProtection(
        server.baseUrl,
        () => server.dio,
      ),
      _changeZoneTtl = _i8.ChangeZoneTtl(server.baseUrl, () => server.dio),
      _importZoneZonefile = _i9.ImportZoneZonefile(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListZonesActions _listZonesActions;

  final _i3.GetZonesAction _getZonesAction;

  final _i4.ListZoneActions _listZoneActions;

  final _i5.GetZoneAction _getZoneAction;

  final _i6.ChangeZonePrimaryNameservers _changeZonePrimaryNameservers;

  final _i7.ChangeZoneProtection _changeZoneProtection;

  final _i8.ChangeZoneTtl _changeZoneTtl;

  final _i9.ImportZoneZonefile _importZoneZonefile;

  /// List Actions
  /// Returns all [Zone](#tag/zones) [Actions](#tag/actions).
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
  _i10.Future<
    _i11.TonikResult<_i12.ListZonesActionsResponse, _i13.Response<_i10.Object?>>
  >
  listZonesActions({
    _i10.List<_i10.int>? id,
    _i10.List<_i14.ZonesActionsParametersArrayModel>? sort,
    _i10.List<_i15.ZonesActionsParametersArrayModel2>? status,
    _i10.int page = _i2.ListZonesActions.pageDefault,
    _i10.int perPage = _i2.ListZonesActions.perPageDefault,
    _i11.TonikCancellation? cancellation,
  }) async => this._listZonesActions(
    id: id,
    sort: sort,
    status: status,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Get an Action
  /// Returns a specific [Action](#tag/actions).
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
  _i10.Future<
    _i11.TonikResult<_i16.GetZonesActionResponse, _i13.Response<_i10.Object?>>
  >
  getZonesAction({
    required _i10.int id,
    _i11.TonikCancellation? cancellation,
  }) async => this._getZonesAction(id: id, cancellation: cancellation);

  /// List Actions for a Zone
  /// Returns all [Actions](#tag/actions) for a [Zone](#tag/zones).
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
  _i10.Future<
    _i11.TonikResult<_i17.ListZoneActionsResponse, _i13.Response<_i10.Object?>>
  >
  listZoneActions({
    required _i10.String idOrName,
    _i10.List<_i18.ZonesIdOrNameActionsParametersArrayModel>? sort,
    _i10.List<_i19.ZonesIdOrNameActionsParametersArrayModel2>? status,
    _i10.int page = _i4.ListZoneActions.pageDefault,
    _i10.int perPage = _i4.ListZoneActions.perPageDefault,
    _i11.TonikCancellation? cancellation,
  }) async => this._listZoneActions(
    idOrName: idOrName,
    sort: sort,
    status: status,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Get an Action for a Zone
  /// **Deprecated**: This operation is deprecated, see our [changelog](https://docs.hetzner.cloud/changelog#2026-04-30-deprecate-get-resource-action-endpoints) for more details.
  ///
  /// Returns a specific [Action](#tag/actions) for a [Zone](#tag/zones).
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
  ///     "id": 1,
  ///     "command": "import_zonefile",
  ///     "status": "running",
  ///     "progress": 50,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 42,
  ///         "type": "zone"
  ///       }
  ///     ],
  ///     "error": null
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
  @_i10.Deprecated('This operation is deprecated.')
  _i10.Future<
    _i11.TonikResult<_i20.GetZoneActionResponse, _i13.Response<_i10.Object?>>
  >
  getZoneAction({
    required _i10.String idOrName,
    required _i10.int actionId,
    _i11.TonikCancellation? cancellation,
  }) async => this._getZoneAction(
    idOrName: idOrName,
    actionId: actionId,
    cancellation: cancellation,
  );

  /// Change a Zone's Primary Nameservers
  /// Overwrites the primary nameservers of a [Zone](#tag/zones).
  ///
  /// Only applicable for [Zones](#tag/zones) in secondary mode.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `incorrect_zone_mode` | This operation is not supported for this Zone's `mode`. |
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
  ///     "id": 1,
  ///     "command": "change_primary_nameservers",
  ///     "status": "running",
  ///     "progress": 50,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 42,
  ///         "type": "zone"
  ///       }
  ///     ],
  ///     "error": null
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
  _i10.Future<
    _i11.TonikResult<
      _i21.ChangeZonePrimaryNameserversResponse,
      _i13.Response<_i10.Object?>
    >
  >
  changeZonePrimaryNameservers({
    required _i22.ZonesIdOrNameActionsChangePrimaryNameserversPostBodyBodyModel
    body,
    required _i10.String idOrName,
    _i11.TonikCancellation? cancellation,
  }) async => this._changeZonePrimaryNameservers(
    body: body,
    idOrName: idOrName,
    cancellation: cancellation,
  );

  /// Change a Zone's Protection
  /// Changes the protection configuration of a [Zone](#tag/zones).
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
  ///     "id": 1,
  ///     "command": "change_protection",
  ///     "status": "running",
  ///     "progress": 50,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 42,
  ///         "type": "zone"
  ///       }
  ///     ],
  ///     "error": null
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
  _i10.Future<
    _i11.TonikResult<
      _i23.ChangeZoneProtectionResponse,
      _i13.Response<_i10.Object?>
    >
  >
  changeZoneProtection({
    required _i24.ZonesIdOrNameActionsChangeProtectionPostBodyBodyModel body,
    required _i10.String idOrName,
    _i11.TonikCancellation? cancellation,
  }) async => this._changeZoneProtection(
    body: body,
    idOrName: idOrName,
    cancellation: cancellation,
  );

  /// Change a Zone's Default TTL
  /// Changes the default Time To Live (TTL) of a [Zone](#tag/zones).
  ///
  /// This TTL is used for [RRSets](#tag/zone-rrsets) that do not explicitly define a TTL.
  ///
  /// Only applicable for [Zones](#tag/zones) in primary mode.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `incorrect_zone_mode` | This operation is not supported for this Zone's `mode`. |
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
  ///     "id": 1,
  ///     "command": "change_ttl",
  ///     "status": "running",
  ///     "progress": 50,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 1,
  ///         "type": "zone"
  ///       }
  ///     ],
  ///     "error": null
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
  _i10.Future<
    _i11.TonikResult<_i25.ChangeZoneTtlResponse, _i13.Response<_i10.Object?>>
  >
  changeZoneTtl({
    required _i26.ZonesIdOrNameActionsChangeTtlPostBodyBodyModel body,
    required _i10.String idOrName,
    _i11.TonikCancellation? cancellation,
  }) async => this._changeZoneTtl(
    body: body,
    idOrName: idOrName,
    cancellation: cancellation,
  );

  /// Import a Zone file
  /// Imports a zone file, replacing all resource record sets ([RRSets](#tag/zone-rrsets)).
  ///
  /// The import will fail if existing [RRSet](#tag/zone-rrsets) are `change` protected.
  ///
  /// See [Zone file import](#tag/zones/zone-file-import) for more details.
  /// Only applicable for [Zones](#tag/zones) in primary mode.
  ///
  /// #### Operation specific errors
  ///
  /// | Status | Code | Description |
  /// | --- | --- | --- |
  /// | `422` | `incorrect_zone_mode` | This operation is not supported for this Zone's `mode`. |
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
  ///     "id": 1,
  ///     "command": "import_zonefile",
  ///     "status": "running",
  ///     "progress": 50,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": null,
  ///     "resources": [
  ///       {
  ///         "id": 42,
  ///         "type": "zone"
  ///       }
  ///     ],
  ///     "error": null
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
  _i10.Future<
    _i11.TonikResult<
      _i27.ImportZoneZonefileResponse,
      _i13.Response<_i10.Object?>
    >
  >
  importZoneZonefile({
    required _i28.ZonesIdOrNameActionsImportZonefilePostBodyBodyModel body,
    required _i10.String idOrName,
    _i11.TonikCancellation? cancellation,
  }) async => this._importZoneZonefile(
    body: body,
    idOrName: idOrName,
    cancellation: cancellation,
  );
}
