// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i7;

import 'package:dio/dio.dart' as _i10;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_parameters_array_model.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_parameters_array_model2.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_post_body_body_model.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_parameters_model.dart'
    as _i19;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_parameters_model2.dart'
    as _i21;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_parameters_model3.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_put_body_body_model.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/operation/create_zone_rrset.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/delete_zone_rrset.dart' as _i6;
import 'package:hetzner_cloud_api/src/operation/get_zone_rrset.dart' as _i4;
import 'package:hetzner_cloud_api/src/operation/list_zone_rrsets.dart' as _i2;
import 'package:hetzner_cloud_api/src/operation/update_zone_rrset.dart' as _i5;
import 'package:hetzner_cloud_api/src/response_wrapper/create_zone_rrset_response.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/response_wrapper/delete_zone_rrset_response.dart'
    as _i20;
import 'package:hetzner_cloud_api/src/response_wrapper/get_zone_rrset_response.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/response_wrapper/list_zone_rrsets_response.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/response_wrapper/update_zone_rrset_response.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i8;

/// This API operates on resource record sets (RRSets) instead of individual resource records (RRs).
/// An RRSet is identified by a name and type. For example, the two RRs
///
/// - (name: `@`, type: `MX`, value: `10 smtp.example.com.`) and
/// - (name: `@`, type: `MX`, value: `20 smtp-backup.example.com.`)
///
/// are part of the RRSet identified by (name: `@`, type: `MX`).
///
/// Please see [Hetzner Docs](https://docs.hetzner.com/networking/dns/record-types/overview) for more information on types.
///
class ZoneRrSetsApi {
  ZoneRrSetsApi(_i1.Server server)
    : _listZoneRrsets = _i2.ListZoneRrsets(server.baseUrl, () => server.dio),
      _createZoneRrset = _i3.CreateZoneRrset(server.baseUrl, () => server.dio),
      _getZoneRrset = _i4.GetZoneRrset(server.baseUrl, () => server.dio),
      _updateZoneRrset = _i5.UpdateZoneRrset(server.baseUrl, () => server.dio),
      _deleteZoneRrset = _i6.DeleteZoneRrset(server.baseUrl, () => server.dio);

  final _i2.ListZoneRrsets _listZoneRrsets;

  final _i3.CreateZoneRrset _createZoneRrset;

  final _i4.GetZoneRrset _getZoneRrset;

  final _i5.UpdateZoneRrset _updateZoneRrset;

  final _i6.DeleteZoneRrset _deleteZoneRrset;

  /// List RRSets
  /// Returns all [RRSets](#tag/zone-rrsets) in the [Zone](#tag/zones).
  ///
  /// Use the provided URI parameters to modify the result.
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
    _i8.TonikResult<_i9.ListZoneRrsetsResponse, _i10.Response<_i7.Object?>>
  >
  listZoneRrsets({
    required _i7.String idOrName,
    _i7.String? name,
    _i7.List<_i11.ZonesIdOrNameRrsetsParametersArrayModel>? $type,
    _i7.String? labelSelector,
    _i7.List<_i12.ZonesIdOrNameRrsetsParametersArrayModel2>? sort,
    _i7.int page = _i2.ListZoneRrsets.pageDefault,
    _i7.int perPage = _i2.ListZoneRrsets.perPageDefault,
    _i8.TonikCancellation? cancellation,
  }) async => this._listZoneRrsets(
    idOrName: idOrName,
    name: name,
    $type: $type,
    labelSelector: labelSelector,
    sort: sort,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Create an RRSet
  /// Create an [RRSet](#tag/zone-rrsets) in the [Zone](#tag/zones).
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
  ///   "rrset": {
  ///     "id": "www/A",
  ///     "name": "www",
  ///     "type": "A",
  ///     "ttl": 3600,
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "protection": {
  ///       "change": false
  ///     },
  ///     "records": [
  ///       {
  ///         "value": "198.51.100.1",
  ///         "comment": "My web server at Hetzner Cloud."
  ///       }
  ///     ],
  ///     "zone": 42
  ///   },
  ///   "action": {
  ///     "id": 1,
  ///     "command": "create_rrset",
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
  _i7.Future<
    _i8.TonikResult<_i13.CreateZoneRrsetResponse, _i10.Response<_i7.Object?>>
  >
  createZoneRrset({
    required _i14.ZonesIdOrNameRrsetsPostBodyBodyModel body,
    required _i7.String idOrName,
    _i8.TonikCancellation? cancellation,
  }) async => this._createZoneRrset(
    body: body,
    idOrName: idOrName,
    cancellation: cancellation,
  );

  /// Get an RRSet
  /// Returns a single [RRSet](#tag/zone-rrsets) from the [Zone](#tag/zones).
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
    _i8.TonikResult<_i15.GetZoneRrsetResponse, _i10.Response<_i7.Object?>>
  >
  getZoneRrset({
    required _i7.String idOrName,
    required _i7.String rrName,
    required _i16.ZonesIdOrNameRrsetsRrNameRrTypeParametersModel3 rrType,
    _i8.TonikCancellation? cancellation,
  }) async => this._getZoneRrset(
    idOrName: idOrName,
    rrName: rrName,
    rrType: rrType,
    cancellation: cancellation,
  );

  /// Update an RRSet
  /// Updates an [RRSet](#tag/zone-rrsets) in the [Zone](#tag/zones).
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
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "rrset": {
  ///     "id": "www/A",
  ///     "name": "www",
  ///     "type": "A",
  ///     "ttl": null,
  ///     "records": [
  ///       {
  ///         "value": "198.51.100.1",
  ///         "comment": "My web server at Hetzner Cloud."
  ///       }
  ///     ],
  ///     "labels": {
  ///       "environment": "prod",
  ///       "example.com/my": "label",
  ///       "just-a-key": ""
  ///     },
  ///     "protection": {
  ///       "change": false
  ///     },
  ///     "zone": 42
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
    _i8.TonikResult<_i17.UpdateZoneRrsetResponse, _i10.Response<_i7.Object?>>
  >
  updateZoneRrset({
    required _i18.ZonesIdOrNameRrsetsRrNameRrTypePutBodyBodyModel body,
    required _i7.String idOrName,
    required _i7.String rrName,
    required _i19.ZonesIdOrNameRrsetsRrNameRrTypeParametersModel rrType,
    _i8.TonikCancellation? cancellation,
  }) async => this._updateZoneRrset(
    body: body,
    idOrName: idOrName,
    rrName: rrName,
    rrType: rrType,
    cancellation: cancellation,
  );

  /// Delete an RRSet
  /// Deletes an [RRSet](#tag/zone-rrsets) from the [Zone](#tag/zones).
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
  ///     "command": "delete_rrset",
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
  _i7.Future<
    _i8.TonikResult<_i20.DeleteZoneRrsetResponse, _i10.Response<_i7.Object?>>
  >
  deleteZoneRrset({
    required _i7.String idOrName,
    required _i7.String rrName,
    required _i21.ZonesIdOrNameRrsetsRrNameRrTypeParametersModel2 rrType,
    _i8.TonikCancellation? cancellation,
  }) async => this._deleteZoneRrset(
    idOrName: idOrName,
    rrName: rrName,
    rrType: rrType,
    cancellation: cancellation,
  );
}
