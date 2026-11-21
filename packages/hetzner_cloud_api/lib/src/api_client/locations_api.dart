// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i4;

import 'package:dio/dio.dart' as _i7;
import 'package:hetzner_cloud_api/src/model/locations_parameters_array_model.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/operation/get_location.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/list_locations.dart' as _i2;
import 'package:hetzner_cloud_api/src/response_wrapper/get_location_response.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/response_wrapper/list_locations_response.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i5;

/// Locations are geographic sites where resources are hosted at. A Location belongs to a Network Zone.
///
class LocationsApi {
  LocationsApi(_i1.Server server)
    : _listLocations = _i2.ListLocations(server.baseUrl, () => server.dio),
      _getLocation = _i3.GetLocation(server.baseUrl, () => server.dio);

  final _i2.ListLocations _listLocations;

  final _i3.GetLocation _getLocation;

  /// List Locations
  /// Returns all [Locations](#tag/locations).
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
  _i4.Future<
    _i5.TonikResult<_i6.ListLocationsResponse, _i7.Response<_i4.Object?>>
  >
  listLocations({
    _i4.String? name,
    _i4.List<_i8.LocationsParametersArrayModel>? sort,
    _i4.int page = _i2.ListLocations.pageDefault,
    _i4.int perPage = _i2.ListLocations.perPageDefault,
    _i5.TonikCancellation? cancellation,
  }) async => this._listLocations(
    name: name,
    sort: sort,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Get a Location
  /// Returns a [Location](#tag/locations).
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
  _i4.Future<
    _i5.TonikResult<_i9.GetLocationResponse, _i7.Response<_i4.Object?>>
  >
  getLocation({
    required _i4.int id,
    _i5.TonikCancellation? cancellation,
  }) async => this._getLocation(id: id, cancellation: cancellation);
}
