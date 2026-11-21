// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Additional configuration for protocol http.
@_i2.immutable
class LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel({
    required this.domain,
    required this.path,
    this.response,
    this.statusCodes = statusCodesDefault,
    this.tls,
  });

  factory LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'domain', r'path', r'response', r'status_codes', r'tls'},
      listKeys: {r'status_codes'},
      context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel(
      domain: _$values[r'domain'].decodeSimpleNullableString(
        context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.domain',
      ),
      path: _$values[r'path'].decodeSimpleString(
        context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.path',
      ),
      response: _$values[r'response'].decodeSimpleNullableString(
        context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.response',
      ),
      statusCodes: _$values.containsKey(r'status_codes')
          ? _$values[r'status_codes'].decodeSimpleStringList(
              context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.status_codes',
              isHeader: isHeader,
            )
          : statusCodesDefault,
      tls: _$values[r'tls'].decodeSimpleNullableBool(
        context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.tls',
      ),
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel',
    );
    return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel(
      domain: _$map[r'domain'].decodeJsonNullableString(
        context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.domain',
      ),
      path: _$map[r'path'].decodeJsonString(
        context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.path',
      ),
      response: _$map[r'response'].decodeJsonNullableString(
        context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.response',
      ),
      statusCodes: _$map.containsKey(r'status_codes')
          ? _$map[r'status_codes'].decodeJsonList<_i3.String>(
              context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.status_codes',
            )
          : statusCodesDefault,
      tls: _$map[r'tls'].decodeJsonNullableBool(
        context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.tls',
      ),
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'domain', r'path', r'response', r'status_codes', r'tls'},
      listKeys: {r'status_codes'},
      context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel',
    );
    return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel(
      domain: _$values[r'domain'].decodeFormNullableString(
        context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.domain',
      ),
      path: _$values[r'path'].decodeFormString(
        context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.path',
      ),
      response: _$values[r'response'].decodeFormNullableString(
        context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.response',
      ),
      statusCodes: _$values.containsKey(r'status_codes')
          ? _$values[r'status_codes'].decodeFormStringList(
              context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.status_codes',
            )
          : statusCodesDefault,
      tls: _$values[r'tls'].decodeFormNullableBool(
        context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel.tls',
      ),
    );
  }

  static const _i3.List<_i3.String> statusCodesDefault = <_i3.String>[
    r'2??',
    r'3??',
  ];

  /// Host header to send in the HTTP request. May not contain spaces, percent or backslash symbols. Can be null, in that case no host header is sent.
  ///
  /// **Example**:
  /// ```
  /// example.com
  /// ```
  final _i3.String? domain;

  /// HTTP path to use for health checks. May not contain literal spaces, use percent-encoding instead.
  ///
  /// **Example**:
  /// ```
  /// /
  /// ```
  final _i3.String path;

  /// String that must be contained in HTTP response in order to pass the health check.
  ///
  /// **Example**:
  /// ```
  /// {"status": "ok"}
  /// ```
  final _i3.String? response;

  /// List of returned HTTP status codes in order to pass the health check. Supports the wildcards `?` for exactly one character and `*` for multiple ones.
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   "2??",
  ///   "3??"
  /// ]
  /// ```
  final _i3.List<_i3.String>? statusCodes;

  /// Use HTTPS for health check.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool? tls;

  @_i3.override
  _i3.Object? toJson() => {
    r'domain': this.domain,
    r'path': this.path,
    if (this.response != null) r'response': this.response,
    if (this.statusCodes != null) r'status_codes': this.statusCodes,
    if (this.tls != null) r'tls': this.tls,
  };

  LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel
  Function({
    _i3.String? domain,
    _i3.String? path,
    _i3.String? response,
    _i3.List<_i3.String>? statusCodes,
    _i3.bool? tls,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? domain = _sentinel,
      _i3.String? path,
      _i3.Object? response = _sentinel,
      _i3.Object? statusCodes = _sentinel,
      _i3.Object? tls = _sentinel,
    }) =>
        LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel(
          domain: _i3.identical(domain, _sentinel)
              ? this.domain
              : (domain as _i3.String?),
          path: path ?? this.path,
          response: _i3.identical(response, _sentinel)
              ? this.response
              : (response as _i3.String?),
          statusCodes: _i3.identical(statusCodes, _sentinel)
              ? this.statusCodes
              : (statusCodes as _i3.List<_i3.String>?),
          tls: _i3.identical(tls, _sentinel) ? this.tls : (tls as _i3.bool?),
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other
            is LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel &&
        other.domain == this.domain &&
        other.path == this.path &&
        other.response == this.response &&
        _$deepEquals.equals(other.statusCodes, this.statusCodes) &&
        other.tls == this.tls;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.domain,
      this.path,
      this.response,
      deepEquals.hash(this.statusCodes),
      this.tls,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (this.domain != null) {
      _$result[r'domain'] = _i1.PropertyValue.scalar(this.domain!);
    }
    _$result[r'path'] = _i1.PropertyValue.scalar(this.path);
    if (this.response != null) {
      _$result[r'response'] = _i1.PropertyValue.scalar(this.response!);
    }
    if (this.statusCodes != null) {
      _$result[r'status_codes'] = _i1.PropertyValue.array(this.statusCodes!);
    }
    if (this.tls != null) {
      _$result[r'tls'] = _i1.PropertyValue.scalar(this.tls!.toString());
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHealthCheckHttpModel: complex types cannot be URI-encoded',
    );
  }
}
