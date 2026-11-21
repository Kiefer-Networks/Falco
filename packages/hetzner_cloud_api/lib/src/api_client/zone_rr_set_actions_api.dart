// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i8;

import 'package:dio/dio.dart' as _i11;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_add_records_parameters_model.dart'
    as _i22;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_add_records_post_body_body_model.dart'
    as _i21;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_change_protection_parameters_model.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_change_protection_post_body_body_model.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_change_ttl_parameters_model.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_change_ttl_post_body_body_model.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_remove_records_parameters_model.dart'
    as _i25;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_remove_records_post_body_body_model.dart'
    as _i24;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_set_records_parameters_model.dart'
    as _i19;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_set_records_post_body_body_model.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_update_records_parameters_model.dart'
    as _i28;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_rrsets_rr_name_rr_type_actions_update_records_post_body_body_model.dart'
    as _i27;
import 'package:hetzner_cloud_api/src/operation/add_zone_rrset_records.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/operation/change_zone_rrset_protection.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/operation/change_zone_rrset_ttl.dart'
    as _i3;
import 'package:hetzner_cloud_api/src/operation/remove_zone_rrset_records.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/operation/set_zone_rrset_records.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/operation/update_zone_rrset_records.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/response_wrapper/add_zone_rrset_records_response.dart'
    as _i20;
import 'package:hetzner_cloud_api/src/response_wrapper/change_zone_rrset_protection_response.dart'
    as _i10;
import 'package:hetzner_cloud_api/src/response_wrapper/change_zone_rrset_ttl_response.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/response_wrapper/remove_zone_rrset_records_response.dart'
    as _i23;
import 'package:hetzner_cloud_api/src/response_wrapper/set_zone_rrset_records_response.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/response_wrapper/update_zone_rrset_records_response.dart'
    as _i26;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i9;

class ZoneRrSetActionsApi {
  ZoneRrSetActionsApi(_i1.Server server)
    : _changeZoneRrsetProtection = _i2.ChangeZoneRrsetProtection(
        server.baseUrl,
        () => server.dio,
      ),
      _changeZoneRrsetTtl = _i3.ChangeZoneRrsetTtl(
        server.baseUrl,
        () => server.dio,
      ),
      _setZoneRrsetRecords = _i4.SetZoneRrsetRecords(
        server.baseUrl,
        () => server.dio,
      ),
      _addZoneRrsetRecords = _i5.AddZoneRrsetRecords(
        server.baseUrl,
        () => server.dio,
      ),
      _removeZoneRrsetRecords = _i6.RemoveZoneRrsetRecords(
        server.baseUrl,
        () => server.dio,
      ),
      _updateZoneRrsetRecords = _i7.UpdateZoneRrsetRecords(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ChangeZoneRrsetProtection _changeZoneRrsetProtection;

  final _i3.ChangeZoneRrsetTtl _changeZoneRrsetTtl;

  final _i4.SetZoneRrsetRecords _setZoneRrsetRecords;

  final _i5.AddZoneRrsetRecords _addZoneRrsetRecords;

  final _i6.RemoveZoneRrsetRecords _removeZoneRrsetRecords;

  final _i7.UpdateZoneRrsetRecords _updateZoneRrsetRecords;

  /// Change an RRSet's Protection
  /// Changes the protection of an [RRSet](#tag/zone-rrsets) in the [Zone](#tag/zones).
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
  ///     "command": "change_rrset_protection",
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
  _i8.Future<
    _i9.TonikResult<
      _i10.ChangeZoneRrsetProtectionResponse,
      _i11.Response<_i8.Object?>
    >
  >
  changeZoneRrsetProtection({
    required _i12.ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeProtectionPostBodyBodyModel
    body,
    required _i8.String idOrName,
    required _i8.String rrName,
    required _i13.ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeProtectionParametersModel
    rrType,
    _i9.TonikCancellation? cancellation,
  }) async => this._changeZoneRrsetProtection(
    body: body,
    idOrName: idOrName,
    rrName: rrName,
    rrType: rrType,
    cancellation: cancellation,
  );

  /// Change an RRSet's TTL
  /// Changes the Time To Live (TTL) of an [RRSet](#tag/zone-rrsets) in the [Zone](#tag/zones).
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
  ///     "command": "change_rrset_ttl",
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
  _i8.Future<
    _i9.TonikResult<_i14.ChangeZoneRrsetTtlResponse, _i11.Response<_i8.Object?>>
  >
  changeZoneRrsetTtl({
    required _i15.ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlPostBodyBodyModel
    body,
    required _i8.String idOrName,
    required _i8.String rrName,
    required _i16.ZonesIdOrNameRrsetsRrNameRrTypeActionsChangeTtlParametersModel
    rrType,
    _i9.TonikCancellation? cancellation,
  }) async => this._changeZoneRrsetTtl(
    body: body,
    idOrName: idOrName,
    rrName: rrName,
    rrType: rrType,
    cancellation: cancellation,
  );

  /// Set Records of an RRSet
  /// Overwrites the resource records (RRs) of an existing [RRSet](#tag/zone-rrsets) in the [Zone](#tag/zones).
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
  ///     "command": "set_rrset_records",
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
  _i8.Future<
    _i9.TonikResult<
      _i17.SetZoneRrsetRecordsResponse,
      _i11.Response<_i8.Object?>
    >
  >
  setZoneRrsetRecords({
    required _i18.ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsPostBodyBodyModel
    body,
    required _i8.String idOrName,
    required _i8.String rrName,
    required _i19.ZonesIdOrNameRrsetsRrNameRrTypeActionsSetRecordsParametersModel
    rrType,
    _i9.TonikCancellation? cancellation,
  }) async => this._setZoneRrsetRecords(
    body: body,
    idOrName: idOrName,
    rrName: rrName,
    rrType: rrType,
    cancellation: cancellation,
  );

  /// Add Records to an RRSet
  /// Adds resource records (RRs) to an [RRSet](#tag/zone-rrsets) in the [Zone](#tag/zones).
  ///
  /// For convenience, the [RRSet](#tag/zone-rrsets) will be automatically created if it doesn't exist. Otherwise, the new
  /// records are appended to the existing [RRSet](#tag/zone-rrsets).
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
  ///     "command": "add_rrset_records",
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
  _i8.Future<
    _i9.TonikResult<
      _i20.AddZoneRrsetRecordsResponse,
      _i11.Response<_i8.Object?>
    >
  >
  addZoneRrsetRecords({
    required _i21.ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsPostBodyBodyModel
    body,
    required _i8.String idOrName,
    required _i8.String rrName,
    required _i22.ZonesIdOrNameRrsetsRrNameRrTypeActionsAddRecordsParametersModel
    rrType,
    _i9.TonikCancellation? cancellation,
  }) async => this._addZoneRrsetRecords(
    body: body,
    idOrName: idOrName,
    rrName: rrName,
    rrType: rrType,
    cancellation: cancellation,
  );

  /// Remove Records from an RRSet
  /// Removes resource records (RRs) from an existing [RRSet](#tag/zone-rrsets) in the [Zone](#tag/zones).
  ///
  /// For convenience, the [RRSet](#tag/zone-rrsets) will be automatically deleted if it doesn't contain any RRs afterwards.
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
  ///     "command": "remove_rrset_records",
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
  _i8.Future<
    _i9.TonikResult<
      _i23.RemoveZoneRrsetRecordsResponse,
      _i11.Response<_i8.Object?>
    >
  >
  removeZoneRrsetRecords({
    required _i24.ZonesIdOrNameRrsetsRrNameRrTypeActionsRemoveRecordsPostBodyBodyModel
    body,
    required _i8.String idOrName,
    required _i8.String rrName,
    required _i25.ZonesIdOrNameRrsetsRrNameRrTypeActionsRemoveRecordsParametersModel
    rrType,
    _i9.TonikCancellation? cancellation,
  }) async => this._removeZoneRrsetRecords(
    body: body,
    idOrName: idOrName,
    rrName: rrName,
    rrType: rrType,
    cancellation: cancellation,
  );

  /// Update Records of an RRSet
  /// Updates resource records' (RRs) comments of an existing [RRSet](#tag/zone-rrsets) in the [Zone](#tag/zones).
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
  ///   "action": {
  ///     "id": 1,
  ///     "command": "update_rrset_records",
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
  _i8.Future<
    _i9.TonikResult<
      _i26.UpdateZoneRrsetRecordsResponse,
      _i11.Response<_i8.Object?>
    >
  >
  updateZoneRrsetRecords({
    required _i27.ZonesIdOrNameRrsetsRrNameRrTypeActionsUpdateRecordsPostBodyBodyModel
    body,
    required _i8.String idOrName,
    required _i8.String rrName,
    required _i28.ZonesIdOrNameRrsetsRrNameRrTypeActionsUpdateRecordsParametersModel
    rrType,
    _i9.TonikCancellation? cancellation,
  }) async => this._updateZoneRrsetRecords(
    body: body,
    idOrName: idOrName,
    rrName: rrName,
    rrType: rrType,
    cancellation: cancellation,
  );
}
