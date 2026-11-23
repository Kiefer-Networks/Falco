// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i8;

import 'package:dio/dio.dart' as _i11;
import 'package:hetzner_cloud_api/src/model/zones_id_or_name_put_body_body_model.dart'
    as _i18;
import 'package:hetzner_cloud_api/src/model/zones_parameters_array_model.dart'
    as _i13;
import 'package:hetzner_cloud_api/src/model/zones_parameters_model.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/model/zones_post_body_body_model.dart'
    as _i15;
import 'package:hetzner_cloud_api/src/operation/create_zone.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/delete_zone.dart' as _i6;
import 'package:hetzner_cloud_api/src/operation/get_zone.dart' as _i4;
import 'package:hetzner_cloud_api/src/operation/get_zone_zonefile.dart' as _i7;
import 'package:hetzner_cloud_api/src/operation/list_zones.dart' as _i2;
import 'package:hetzner_cloud_api/src/operation/update_zone.dart' as _i5;
import 'package:hetzner_cloud_api/src/response_wrapper/create_zone_response.dart'
    as _i14;
import 'package:hetzner_cloud_api/src/response_wrapper/delete_zone_response.dart'
    as _i19;
import 'package:hetzner_cloud_api/src/response_wrapper/get_zone_response.dart'
    as _i16;
import 'package:hetzner_cloud_api/src/response_wrapper/get_zone_zonefile_response.dart'
    as _i20;
import 'package:hetzner_cloud_api/src/response_wrapper/list_zones_response.dart'
    as _i10;
import 'package:hetzner_cloud_api/src/response_wrapper/update_zone_response.dart'
    as _i17;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i9;

/// A Zone represents a [Domain Name System (DNS) zone](https://wikipedia.org/wiki/DNS_zone) managed by Hetzner authoritative nameservers.
/// Please see [Hetzner Docs](https://docs.hetzner.com/dns-console/dns/general/dns-overview#the-difference-between-domain-and-zone) for the difference between zones and domains.
///
/// This API supports all zone names with [well-known public suffixes](https://publicsuffix.org/) (e.g. `.de`, `.com`, `.co.uk`).
/// Subdomains are not supported.
///
/// <h3 id="tag/zones/zone-modes">Zone Modes</h3>
///
/// This API supports two types of zone modes.
///
/// - In _primary_ mode, resource record sets ([RRSets](#tag/zone-rrsets)) and resource records (RRs) are managed via the Cloud API or Hetzner Console.
/// - In _secondary_ mode, Hetzner's nameservers query [RRSets](#tag/zone-rrsets) and RRs from given primary nameservers via [AXFR](https://en.wikipedia.org/wiki/DNS_zone_transfer).
///
/// The zone mode cannot be changed, the zone must be deleted and re-created with a new mode.
///
/// ### SOA Serial
///
/// For zones in primary mode, Hetzner automatically increases the `SOA` record serial number.
/// As convention, a `YYYYMMDDnn` format with incrementing `nn` is used.
///
/// <h3 id="tag/zones/zone-file-import">Zone file import</h3>
///
/// This API supports importing a zone file in BIND (RFC [1034](https://datatracker.ietf.org/doc/html/rfc1034)/[1035](https://datatracker.ietf.org/doc/html/rfc1035)) format.
///
/// Importing a zone file is only applicable for [Zones](#tag/zones) in primary mode.
///
/// During an import:
///
/// - An `$ORIGIN` directive may be present, it must match the [Zone](#tag/zones)'s name with an ending dot
/// - A `$TTL` directive may be present, it is used as new default [Zone](#tag/zones) Time To Live (TTL)
/// - Only `IN` (internet) class records are allowed
/// - The assigned authoritative Hetzner nameservers must be present as `NS` records
/// - A `SOA` record must be present
/// - Comments are discarded
///
/// Zone file example:
///
/// ```dns
/// $ORIGIN	example.com.
/// $TTL	3600
///
/// @	IN	SOA	hydrogen.ns.hetzner.com. dns.hetzner.com. 2024010100 86400 10800 3600000 3600
///
/// @	IN	10800	NS	hydrogen.ns.hetzner.com. ; Some comment.
/// @	IN	10800	NS	oxygen.ns.hetzner.com.
/// @	IN	10800	NS	helium.ns.hetzner.de.
/// ```
///
class ZonesApi {
  ZonesApi(_i1.Server server)
    : _listZones = _i2.ListZones(server.baseUrl, () => server.dio),
      _createZone = _i3.CreateZone(server.baseUrl, () => server.dio),
      _getZone = _i4.GetZone(server.baseUrl, () => server.dio),
      _updateZone = _i5.UpdateZone(server.baseUrl, () => server.dio),
      _deleteZone = _i6.DeleteZone(server.baseUrl, () => server.dio),
      _getZoneZonefile = _i7.GetZoneZonefile(server.baseUrl, () => server.dio);

  final _i2.ListZones _listZones;

  final _i3.CreateZone _createZone;

  final _i4.GetZone _getZone;

  final _i5.UpdateZone _updateZone;

  final _i6.DeleteZone _deleteZone;

  final _i7.GetZoneZonefile _getZoneZonefile;

  /// List Zones
  /// Returns all [Zones](#tag/zones).
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
    _i9.TonikResult<_i10.ListZonesResponse, _i11.Response<_i8.Object?>>
  >
  listZones({
    _i8.String? name,
    _i12.ZonesParametersModel? mode,
    _i8.String? labelSelector,
    _i8.List<_i13.ZonesParametersArrayModel>? sort,
    _i8.int page = _i2.ListZones.pageDefault,
    _i8.int perPage = _i2.ListZones.perPageDefault,
    _i9.TonikCancellation? cancellation,
  }) async => this._listZones(
    name: name,
    mode: mode,
    labelSelector: labelSelector,
    sort: sort,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Create a Zone
  /// Creates a [Zone](#tag/zones).
  ///
  /// A default `SOA` and three `NS` resource records with the assigned Hetzner
  /// nameservers are created automatically.
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Request body (application/json):
  /// **Example** "primary":
  /// ```json
  /// {
  ///   "name": "example.com",
  ///   "mode": "primary",
  ///   "ttl": 10800,
  ///   "labels": {
  ///     "key": "value"
  ///   },
  ///   "rrsets": [
  ///     {
  ///       "name": "www",
  ///       "type": "A",
  ///       "records": [
  ///         {
  ///           "value": "198.51.100.1",
  ///           "comment": "My web server at Hetzner Cloud."
  ///         }
  ///       ]
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// **Example** "primary from zone file":
  /// ```json
  /// {
  ///   "name": "example.com",
  ///   "mode": "primary",
  ///   "ttl": 10800,
  ///   "labels": {
  ///     "key": "value"
  ///   },
  ///   "zonefile": "$ORIGIN\texample.com.\n$TTL\t10800\n\n@\tIN\tA\t198.51.100.1 ; My web server at Hetzner Cloud.\n"
  /// }
  /// ```
  ///
  /// **Example** "secondary":
  /// ```json
  /// {
  ///   "name": "example.com",
  ///   "mode": "secondary",
  ///   "ttl": 10800,
  ///   "labels": {
  ///     "key": "value"
  ///   },
  ///   "primary_nameservers": [
  ///     {
  ///       "address": "198.51.100.1",
  ///       "port": 53
  ///     },
  ///     {
  ///       "address": "203.0.113.1",
  ///       "port": 53
  ///     }
  ///   ]
  /// }
  /// ```
  ///
  /// Response 201 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "zone": {
  ///     "id": 42,
  ///     "name": "example.com",
  ///     "mode": "primary",
  ///     "status": "ok",
  ///     "ttl": 3600,
  ///     "record_count": 4,
  ///     "protection": {
  ///       "delete": false
  ///     },
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "created": "2016-01-30T23:50:00Z",
  ///     "registrar": "hetzner",
  ///     "authoritative_nameservers": {
  ///       "assigned": [
  ///         "hydrogen.ns.hetzner.com.",
  ///         "oxygen.ns.hetzner.com.",
  ///         "helium.ns.hetzner.de."
  ///       ],
  ///       "delegated": [
  ///         "hydrogen.ns.hetzner.com.",
  ///         "oxygen.ns.hetzner.com.",
  ///         "helium.ns.hetzner.de."
  ///       ],
  ///       "delegation_last_check": "2016-01-30T23:50:00Z",
  ///       "delegation_status": "valid"
  ///     }
  ///   },
  ///   "action": {
  ///     "id": 1,
  ///     "command": "create_zone",
  ///     "status": "running",
  ///     "progress": 50,
  ///     "started": "2016-01-30T23:50:00Z",
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
    _i9.TonikResult<_i14.CreateZoneResponse, _i11.Response<_i8.Object?>>
  >
  createZone({
    required _i15.ZonesPostBodyBodyModel body,
    _i9.TonikCancellation? cancellation,
  }) async => this._createZone(body: body, cancellation: cancellation);

  /// Get a Zone
  /// Returns a single [Zone](#tag/zones).
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
  _i8.Future<_i9.TonikResult<_i16.GetZoneResponse, _i11.Response<_i8.Object?>>>
  getZone({
    required _i8.String idOrName,
    _i9.TonikCancellation? cancellation,
  }) async => this._getZone(idOrName: idOrName, cancellation: cancellation);

  /// Update a Zone
  /// Updates a [Zone](#tag/zones).
  ///
  /// To modify resource record sets ([RRSets](#tag/zone-rrsets)), use the [RRSet Actions
  /// endpoints](#tag/zone-rrset-actions).
  ///
  ///
  /// Security:
  /// - HTTP Bearer
  ///
  /// Response 200 (application/json):
  /// **Example** "default":
  /// ```json
  /// {
  ///   "zone": {
  ///     "id": 42,
  ///     "name": "example.com",
  ///     "mode": "primary",
  ///     "status": "ok",
  ///     "ttl": 3600,
  ///     "record_count": 4,
  ///     "protection": {
  ///       "delete": false
  ///     },
  ///     "labels": {
  ///       "key": "value"
  ///     },
  ///     "created": "2016-01-30T23:50:00Z",
  ///     "registrar": "hetzner",
  ///     "authoritative_nameservers": {
  ///       "assigned": [
  ///         "hydrogen.ns.hetzner.com.",
  ///         "oxygen.ns.hetzner.com.",
  ///         "helium.ns.hetzner.de."
  ///       ],
  ///       "delegated": [
  ///         "hydrogen.ns.hetzner.com.",
  ///         "oxygen.ns.hetzner.com.",
  ///         "helium.ns.hetzner.de."
  ///       ],
  ///       "delegation_last_check": "2016-01-30T23:50:00Z",
  ///       "delegation_status": "valid"
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
    _i9.TonikResult<_i17.UpdateZoneResponse, _i11.Response<_i8.Object?>>
  >
  updateZone({
    required _i18.ZonesIdOrNamePutBodyBodyModel body,
    required _i8.String idOrName,
    _i9.TonikCancellation? cancellation,
  }) async => this._updateZone(
    body: body,
    idOrName: idOrName,
    cancellation: cancellation,
  );

  /// Delete a Zone
  /// Deletes a [Zone](#tag/zones).
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
  ///     "command": "delete_zone",
  ///     "status": "running",
  ///     "progress": 50,
  ///     "started": "2016-01-30T23:50:00Z",
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
    _i9.TonikResult<_i19.DeleteZoneResponse, _i11.Response<_i8.Object?>>
  >
  deleteZone({
    required _i8.String idOrName,
    _i9.TonikCancellation? cancellation,
  }) async => this._deleteZone(idOrName: idOrName, cancellation: cancellation);

  /// Export a Zone file
  /// Returns a generated [Zone](#tag/zones) file in BIND (RFC [1034](https://datatracker.ietf.org/doc/html/rfc1034)/[1035](https://datatracker.ietf.org/doc/html/rfc1035)) format.
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
  _i8.Future<
    _i9.TonikResult<_i20.GetZoneZonefileResponse, _i11.Response<_i8.Object?>>
  >
  getZoneZonefile({
    required _i8.String idOrName,
    _i9.TonikCancellation? cancellation,
  }) async =>
      this._getZoneZonefile(idOrName: idOrName, cancellation: cancellation);
}
