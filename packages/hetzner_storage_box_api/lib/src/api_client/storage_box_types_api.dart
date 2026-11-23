// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i4;

import 'package:dio/dio.dart' as _i7;
import 'package:hetzner_storage_box_api/src/operation/get_storage_box_type.dart'
    as _i3;
import 'package:hetzner_storage_box_api/src/operation/list_storage_box_types.dart'
    as _i2;
import 'package:hetzner_storage_box_api/src/response_wrapper/get_storage_box_type_response.dart'
    as _i8;
import 'package:hetzner_storage_box_api/src/response_wrapper/list_storage_box_types_response.dart'
    as _i6;
import 'package:hetzner_storage_box_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i5;

/// Storage Box Types define storage products of different sizes. Each type has an hourly and a monthly cost. You will pay whichever cost is lower for your usage of this specific Storage Box. Costs may differ between Locations.
///
/// All prices are displayed in the currency of the project owner's account.
///
class StorageBoxTypesApi {
  StorageBoxTypesApi(_i1.Server server)
    : _listStorageBoxTypes = _i2.ListStorageBoxTypes(
        server.baseUrl,
        () => server.dio,
      ),
      _getStorageBoxType = _i3.GetStorageBoxType(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListStorageBoxTypes _listStorageBoxTypes;

  final _i3.GetStorageBoxType _getStorageBoxType;

  /// List Storage Box Types
  /// Returns a paginated list of [Storage Box Types](#tag/storage-box-types).
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
    _i5.TonikResult<_i6.ListStorageBoxTypesResponse, _i7.Response<_i4.Object?>>
  >
  listStorageBoxTypes({
    _i4.String? name,
    _i4.int page = _i2.ListStorageBoxTypes.pageDefault,
    _i4.int perPage = _i2.ListStorageBoxTypes.perPageDefault,
    _i5.TonikCancellation? cancellation,
  }) async => this._listStorageBoxTypes(
    name: name,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Get a Storage Box Type
  /// Returns a specific [Storage Box Type](#tag/storage-box-types).
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
    _i5.TonikResult<_i8.GetStorageBoxTypeResponse, _i7.Response<_i4.Object?>>
  >
  getStorageBoxType({
    required _i4.int id,
    _i5.TonikCancellation? cancellation,
  }) async => this._getStorageBoxType(id: id, cancellation: cancellation);
}
