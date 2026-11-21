// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i4;

import 'package:dio/dio.dart' as _i7;
import 'package:hetzner_cloud_api/src/model/datacenters_parameters_array_model.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/operation/get_datacenter.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/list_datacenters.dart' as _i2;
import 'package:hetzner_cloud_api/src/response_wrapper/get_datacenter_response.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/response_wrapper/list_datacenters_response.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i5;

/// Each Datacenter represents a _virtual_ Datacenter which may consist of possibly many physical Datacenters. A physical Datacenter is where [Servers](#tag/servers) are hosted.
///
/// See the [Hetzner Locations Docs](https://docs.hetzner.com/cloud/general/locations/#what-datacenters-are-there) for more details about Datacenters.
///
/// **Note**: This functionality and endpoints were deprecated in June 2026 and removed on 01 October 2026.
///
/// - Announcement: https://docs.hetzner.cloud/changelog#2026-06-02-datacenters-deprecated
/// - Removal: https://docs.hetzner.cloud/changelog#2026-10-01-datacenters-removed
///
class DataCentersApi {
  DataCentersApi(_i1.Server server)
    : _listDatacenters = _i2.ListDatacenters(server.baseUrl, () => server.dio),
      _getDatacenter = _i3.GetDatacenter(server.baseUrl, () => server.dio);

  final _i2.ListDatacenters _listDatacenters;

  final _i3.GetDatacenter _getDatacenter;

  /// List Data Centers
  /// **Deprecated:** This endpoint was deprecated on 01 June 2026 and removed on 01 October 2026. It now returns `410 Gone`.
  ///
  /// Returns all [Data Centers](#tag/data-centers).
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
  @_i4.Deprecated('This operation is deprecated.')
  _i4.Future<
    _i5.TonikResult<_i6.ListDatacentersResponse, _i7.Response<_i4.Object?>>
  >
  listDatacenters({
    _i4.String? name,
    _i4.List<_i8.DatacentersParametersArrayModel>? sort,
    _i4.int page = _i2.ListDatacenters.pageDefault,
    _i4.int perPage = _i2.ListDatacenters.perPageDefault,
    _i5.TonikCancellation? cancellation,
  }) async => this._listDatacenters(
    name: name,
    sort: sort,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Get a Data Center
  /// **Deprecated:** This endpoint was deprecated on 01 June 2026 and removed on 01 October 2026. It now returns `410 Gone`.
  ///
  /// Returns a single [Data Center](#tag/data-centers).
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
  @_i4.Deprecated('This operation is deprecated.')
  _i4.Future<
    _i5.TonikResult<_i9.GetDatacenterResponse, _i7.Response<_i4.Object?>>
  >
  getDatacenter({
    required _i4.int id,
    _i5.TonikCancellation? cancellation,
  }) async => this._getDatacenter(id: id, cancellation: cancellation);
}
