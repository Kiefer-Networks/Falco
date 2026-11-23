// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_update_service_post_body_body_all_of_health_check_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_actions_update_service_post_body_body_all_of_http_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2({
    this.healthCheck,
    this.http,
  });

  factory LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2: contains complex types',
    );
  }

  factory LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2',
    );
    return LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2(
      healthCheck: _$map[r'health_check'] == null
          ? null
          : _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckModel.fromJson(
              _$map[r'health_check'],
            ),
      http: _$map[r'http'] == null
          ? null
          : _i5.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.fromJson(
              _$map[r'http'],
            ),
    );
  }

  factory LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2: contains complex types',
    );
  }

  /// Service health check.
  final _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckModel?
  healthCheck;

  /// Configuration option for protocols http and https.
  final _i5.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel? http;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.healthCheck != null) r'health_check': this.healthCheck?.toJson(),
    if (this.http != null) r'http': this.http?.toJson(),
  };

  LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2 Function({
    _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckModel?
    healthCheck,
    _i5.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel? http,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? healthCheck = _sentinel,
      _i3.Object? http = _sentinel,
    }) => LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2(
      healthCheck: _i3.identical(healthCheck, _sentinel)
          ? this.healthCheck
          : (healthCheck
                as _i4.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHealthCheckModel?),
      http: _i3.identical(http, _sentinel)
          ? this.http
          : (http
                as _i5.LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2 &&
        other.healthCheck == this.healthCheck &&
        other.http == this.http;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.healthCheck, this.http]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfModel2: complex types cannot be URI-encoded',
    );
  }
}
