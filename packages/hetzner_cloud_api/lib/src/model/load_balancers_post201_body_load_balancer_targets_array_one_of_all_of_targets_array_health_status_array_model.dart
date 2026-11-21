// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_targets_array_one_of_all_of_targets_array_health_status_array_detail_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_targets_array_one_of_all_of_targets_array_health_status_array_status_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel({
    required this.listenPort,
    required this.status,
    this.detail,
    this.httpStatusCode,
  });

  factory LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'listen_port', r'status', r'detail', r'http_status_code'},
      listKeys: {},
      context: r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel(
      listenPort: _$values[r'listen_port'].decodeSimpleInt(
        context: r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel.listen_port',
      ),
      status:
          _i4.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayStatusModel.fromSimple(
            _$values[r'status'],
            explode: explode,
          ),
      detail: _$values[r'detail'] == null
          ? null
          : _i5.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayDetailModel.fromSimple(
              _$values[r'detail'],
              explode: explode,
            ),
      httpStatusCode: _$values[r'http_status_code'].decodeSimpleNullableInt(
        context: r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel.http_status_code',
      ),
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel',
    );
    return LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel(
      listenPort: _$map[r'listen_port'].decodeJsonInt(
        context: r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel.listen_port',
      ),
      status:
          _i4.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayStatusModel.fromJson(
            _$map[r'status'],
          ),
      detail: _$map[r'detail'] == null
          ? null
          : _i5.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayDetailModel.fromJson(
              _$map[r'detail'],
            ),
      httpStatusCode: _$map[r'http_status_code'].decodeJsonNullableInt(
        context: r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel.http_status_code',
      ),
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'listen_port', r'status', r'detail', r'http_status_code'},
      listKeys: {},
      context: r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel',
    );
    return LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel(
      listenPort: _$values[r'listen_port'].decodeFormInt(
        context: r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel.listen_port',
      ),
      status:
          _i4.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayStatusModel.fromForm(
            _$values[r'status'],
            explode: explode,
          ),
      detail: _$values[r'detail'] == null
          ? null
          : _i5.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayDetailModel.fromForm(
              _$values[r'detail'],
              explode: explode,
            ),
      httpStatusCode: _$values[r'http_status_code'].decodeFormNullableInt(
        context: r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel.http_status_code',
      ),
    );
  }

  /// **Example**:
  /// ```json
  /// 443
  /// ```
  final _i3.int listenPort;

  /// **Example**:
  /// ```
  /// healthy
  /// ```
  final _i4.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayStatusModel
  status;

  /// Additional details about why the health check failed. Only present when `status` is `unhealthy`.
  ///
  /// **Example**:
  /// ```
  /// unexpected_http_status
  /// ```
  final _i5.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayDetailModel?
  detail;

  /// HTTP status code returned by the target during the last health check. Only present when `status` is `unhealthy` and `detail` is `unexpected_http_status`.
  ///
  /// **Example**:
  /// ```json
  /// 503
  /// ```
  final _i3.int? httpStatusCode;

  @_i3.override
  _i3.Object? toJson() => {
    r'listen_port': this.listenPort,
    r'status': this.status.toJson(),
    if (this.detail != null) r'detail': this.detail?.toJson(),
    if (this.httpStatusCode != null) r'http_status_code': this.httpStatusCode,
  };

  LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel
  Function({
    _i3.int? listenPort,
    _i4.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayStatusModel?
    status,
    _i5.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayDetailModel?
    detail,
    _i3.int? httpStatusCode,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? listenPort,
      _i4.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayStatusModel?
      status,
      _i3.Object? detail = _sentinel,
      _i3.Object? httpStatusCode = _sentinel,
    }) => LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel(
      listenPort: listenPort ?? this.listenPort,
      status: status ?? this.status,
      detail: _i3.identical(detail, _sentinel)
          ? this.detail
          : (detail
                as _i5.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayDetailModel?),
      httpStatusCode: _i3.identical(httpStatusCode, _sentinel)
          ? this.httpStatusCode
          : (httpStatusCode as _i3.int?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel &&
        other.listenPort == this.listenPort &&
        other.status == this.status &&
        other.detail == this.detail &&
        other.httpStatusCode == this.httpStatusCode;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.listenPort,
      this.status,
      this.detail,
      this.httpStatusCode,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'listen_port'] = _i1.PropertyValue.scalar(
      this.listenPort.toString(),
    );
    _$result[r'status'] = _i1.PropertyValue.scalar(this.status.toJson());
    if (this.detail != null) {
      _$result[r'detail'] = _i1.PropertyValue.scalar(this.detail!.toJson());
    }
    if (this.httpStatusCode != null) {
      _$result[r'http_status_code'] = _i1.PropertyValue.scalar(
        this.httpStatusCode!.toString(),
      );
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayHealthStatusArrayModel: complex types cannot be URI-encoded',
    );
  }
}
