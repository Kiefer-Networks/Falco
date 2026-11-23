// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i4;

import 'package:dio/dio.dart' as _i7;
import 'package:hetzner_cloud_api/src/model/isos_parameters_model.dart' as _i8;
import 'package:hetzner_cloud_api/src/operation/get_iso.dart' as _i3;
import 'package:hetzner_cloud_api/src/operation/list_isos.dart' as _i2;
import 'package:hetzner_cloud_api/src/response_wrapper/get_iso_response.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/response_wrapper/list_isos_response.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i5;

/// ISOs are read-only Images of DVDs. While we recommend using our Image functionality to install your Servers we also provide some stock ISOs so you can install more exotic operating systems by yourself.
///
/// On request our support uploads a private ISO just for you. These are marked with type `private` and only visible in your Project.
///
/// To attach an ISO to your Server use `POST /servers/{id}/actions/attach_iso`.
///
class IsOsApi {
  IsOsApi(_i1.Server server)
    : _listIsos = _i2.ListIsos(server.baseUrl, () => server.dio),
      _getIso = _i3.GetIso(server.baseUrl, () => server.dio);

  final _i2.ListIsos _listIsos;

  final _i3.GetIso _getIso;

  /// List ISOs
  /// Returns all available ISO objects.
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
  _i4.Future<_i5.TonikResult<_i6.ListIsosResponse, _i7.Response<_i4.Object?>>>
  listIsos({
    _i4.String? name,
    _i8.IsosParametersModel? architecture,
    _i4.bool? includeArchitectureWildcard,
    _i4.int page = _i2.ListIsos.pageDefault,
    _i4.int perPage = _i2.ListIsos.perPageDefault,
    _i5.TonikCancellation? cancellation,
  }) async => this._listIsos(
    name: name,
    architecture: architecture,
    includeArchitectureWildcard: includeArchitectureWildcard,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Get an ISO
  /// Returns a specific ISO object.
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
  _i4.Future<_i5.TonikResult<_i9.GetIsoResponse, _i7.Response<_i4.Object?>>>
  getIso({required _i4.int id, _i5.TonikCancellation? cancellation}) async =>
      this._getIso(id: id, cancellation: cancellation);
}
