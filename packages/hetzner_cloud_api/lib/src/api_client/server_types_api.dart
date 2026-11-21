// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i4;

import 'package:dio/dio.dart' as _i7;
import 'package:hetzner_cloud_api/src/operation/get_server_type.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/list_server_types.dart' as _i2;
import 'package:hetzner_cloud_api/src/response_wrapper/get_server_type_response.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/response_wrapper/list_server_types_response.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i5;

/// Server types define kinds of Servers offered. Each type has an hourly and a monthly cost. You will pay whichever cost is lower for your usage of this specific Server. Costs may differ between Locations.
///
/// All prices are displayed in the currency of the project owner's account.
///
class ServerTypesApi {
  ServerTypesApi(_i1.Server server)
    : _listServerTypes = _i2.ListServerTypes(server.baseUrl, () => server.dio),
      _getServerType = _i3.GetServerType(server.baseUrl, () => server.dio);

  final _i2.ListServerTypes _listServerTypes;

  final _i3.GetServerType _getServerType;

  /// List Server Types
  /// Gets all Server type objects.
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
    _i5.TonikResult<_i6.ListServerTypesResponse, _i7.Response<_i4.Object?>>
  >
  listServerTypes({
    _i4.String? name,
    _i4.int page = _i2.ListServerTypes.pageDefault,
    _i4.int perPage = _i2.ListServerTypes.perPageDefault,
    _i5.TonikCancellation? cancellation,
  }) async => this._listServerTypes(
    name: name,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Get a Server Type
  /// Gets a specific Server type object.
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
    _i5.TonikResult<_i8.GetServerTypeResponse, _i7.Response<_i4.Object?>>
  >
  getServerType({
    required _i4.int id,
    _i5.TonikCancellation? cancellation,
  }) async => this._getServerType(id: id, cancellation: cancellation);
}
