// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i4;

import 'package:dio/dio.dart' as _i7;
import 'package:hetzner_cloud_api/src/operation/get_load_balancer_type.dart'
    as _i3;
import 'package:hetzner_cloud_api/src/operation/list_load_balancer_types.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/response_wrapper/get_load_balancer_type_response.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/response_wrapper/list_load_balancer_types_response.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i5;

/// Load Balancer types define kinds of Load Balancers offered. Each type has an hourly and a monthly cost. You will pay whichever amount is lower for your usage of this specific Load Balancer. Costs may differ between Locations.
///
/// All prices are displayed in the currency of the project owner's account.
///
class LoadBalancerTypesApi {
  LoadBalancerTypesApi(_i1.Server server)
    : _listLoadBalancerTypes = _i2.ListLoadBalancerTypes(
        server.baseUrl,
        () => server.dio,
      ),
      _getLoadBalancerType = _i3.GetLoadBalancerType(
        server.baseUrl,
        () => server.dio,
      );

  final _i2.ListLoadBalancerTypes _listLoadBalancerTypes;

  final _i3.GetLoadBalancerType _getLoadBalancerType;

  /// List Load Balancer Types
  /// Gets all Load Balancer type objects.
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
    _i5.TonikResult<
      _i6.ListLoadBalancerTypesResponse,
      _i7.Response<_i4.Object?>
    >
  >
  listLoadBalancerTypes({
    _i4.String? name,
    _i4.int page = _i2.ListLoadBalancerTypes.pageDefault,
    _i4.int perPage = _i2.ListLoadBalancerTypes.perPageDefault,
    _i5.TonikCancellation? cancellation,
  }) async => this._listLoadBalancerTypes(
    name: name,
    page: page,
    perPage: perPage,
    cancellation: cancellation,
  );

  /// Get a Load Balancer Type
  /// Gets a specific Load Balancer type object.
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
    _i5.TonikResult<_i8.GetLoadBalancerTypeResponse, _i7.Response<_i4.Object?>>
  >
  getLoadBalancerType({
    required _i4.int id,
    _i5.TonikCancellation? cancellation,
  }) async => this._getLoadBalancerType(id: id, cancellation: cancellation);
}
