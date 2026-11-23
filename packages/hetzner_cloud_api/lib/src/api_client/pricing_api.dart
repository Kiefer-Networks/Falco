// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:dio/dio.dart' as _i6;
import 'package:hetzner_cloud_api/src/operation/get_pricing.dart' as _i2;
import 'package:hetzner_cloud_api/src/response_wrapper/get_pricing_response.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/server/server.dart' as _i1;
import 'package:tonik_util/tonik_util.dart' as _i4;

/// Returns prices for resources.
///
class PricingApi {
  PricingApi(_i1.Server server)
    : _getPricing = _i2.GetPricing(server.baseUrl, () => server.dio);

  final _i2.GetPricing _getPricing;

  /// Get all prices
  /// Returns prices for all resources available on the platform. VAT and currency of the Project owner are used for calculations.
  ///
  /// Both net and gross prices are included in the response.
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
  _i3.Future<_i4.TonikResult<_i5.GetPricingResponse, _i6.Response<_i3.Object?>>>
  getPricing({_i4.TonikCancellation? cancellation}) async =>
      this._getPricing(cancellation: cancellation);
}
