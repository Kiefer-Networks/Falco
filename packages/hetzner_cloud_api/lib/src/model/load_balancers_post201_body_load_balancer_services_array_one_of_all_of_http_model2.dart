// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Configuration option for protocol http.
@_i2.immutable
class LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2({
    this.cookieName = cookieNameDefault,
    this.cookieLifetime = cookieLifetimeDefault,
    this.timeoutIdle = timeoutIdleDefault,
    this.stickySessions = stickySessionsDefault,
  });

  factory LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'cookie_name',
        r'cookie_lifetime',
        r'timeout_idle',
        r'sticky_sessions',
      },
      listKeys: {},
      context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2(
      cookieName: _$values.containsKey(r'cookie_name')
          ? _$values[r'cookie_name'].decodeSimpleString(
              context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2.cookie_name',
            )
          : cookieNameDefault,
      cookieLifetime: _$values.containsKey(r'cookie_lifetime')
          ? _$values[r'cookie_lifetime'].decodeSimpleInt(
              context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2.cookie_lifetime',
            )
          : cookieLifetimeDefault,
      timeoutIdle: _$values.containsKey(r'timeout_idle')
          ? _$values[r'timeout_idle'].decodeSimpleInt(
              context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2.timeout_idle',
            )
          : timeoutIdleDefault,
      stickySessions: _$values.containsKey(r'sticky_sessions')
          ? _$values[r'sticky_sessions'].decodeSimpleBool(
              context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2.sticky_sessions',
            )
          : stickySessionsDefault,
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2',
    );
    return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2(
      cookieName: _$map.containsKey(r'cookie_name')
          ? _$map[r'cookie_name'].decodeJsonString(
              context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2.cookie_name',
            )
          : cookieNameDefault,
      cookieLifetime: _$map.containsKey(r'cookie_lifetime')
          ? _$map[r'cookie_lifetime'].decodeJsonInt(
              context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2.cookie_lifetime',
            )
          : cookieLifetimeDefault,
      timeoutIdle: _$map.containsKey(r'timeout_idle')
          ? _$map[r'timeout_idle'].decodeJsonInt(
              context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2.timeout_idle',
            )
          : timeoutIdleDefault,
      stickySessions: _$map.containsKey(r'sticky_sessions')
          ? _$map[r'sticky_sessions'].decodeJsonBool(
              context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2.sticky_sessions',
            )
          : stickySessionsDefault,
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'cookie_name',
        r'cookie_lifetime',
        r'timeout_idle',
        r'sticky_sessions',
      },
      listKeys: {},
      context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2',
    );
    return LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2(
      cookieName: _$values.containsKey(r'cookie_name')
          ? _$values[r'cookie_name'].decodeFormString(
              context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2.cookie_name',
            )
          : cookieNameDefault,
      cookieLifetime: _$values.containsKey(r'cookie_lifetime')
          ? _$values[r'cookie_lifetime'].decodeFormInt(
              context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2.cookie_lifetime',
            )
          : cookieLifetimeDefault,
      timeoutIdle: _$values.containsKey(r'timeout_idle')
          ? _$values[r'timeout_idle'].decodeFormInt(
              context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2.timeout_idle',
            )
          : timeoutIdleDefault,
      stickySessions: _$values.containsKey(r'sticky_sessions')
          ? _$values[r'sticky_sessions'].decodeFormBool(
              context: r'LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2.sticky_sessions',
            )
          : stickySessionsDefault,
    );
  }

  static const _i3.String cookieNameDefault = r'HCLBSTICKY';

  static const _i3.int cookieLifetimeDefault = 300;

  static const _i3.int timeoutIdleDefault = 50;

  static const _i3.bool stickySessionsDefault = false;

  /// Name of the cookie used for sticky sessions.
  ///
  /// **Example**:
  /// ```
  /// HCLBSTICKY
  /// ```
  final _i3.String cookieName;

  /// Lifetime of the cookie used for sticky sessions (in seconds).
  ///
  /// **Example**:
  /// ```json
  /// 300
  /// ```
  final _i3.int cookieLifetime;

  /// Idle timeout in seconds for the client and server side.
  ///
  /// **Example**:
  /// ```json
  /// 50
  /// ```
  final _i3.int timeoutIdle;

  /// Use sticky sessions.
  ///
  /// **Example**:
  /// ```json
  /// true
  /// ```
  final _i3.bool stickySessions;

  @_i3.override
  _i3.Object? toJson() => {
    r'cookie_name': this.cookieName,
    r'cookie_lifetime': this.cookieLifetime,
    r'timeout_idle': this.timeoutIdle,
    r'sticky_sessions': this.stickySessions,
  };

  LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2
  Function({
    _i3.String? cookieName,
    _i3.int? cookieLifetime,
    _i3.int? timeoutIdle,
    _i3.bool? stickySessions,
  })
  get copyWith {
    return ({
      _i3.String? cookieName,
      _i3.int? cookieLifetime,
      _i3.int? timeoutIdle,
      _i3.bool? stickySessions,
    }) => LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2(
      cookieName: cookieName ?? this.cookieName,
      cookieLifetime: cookieLifetime ?? this.cookieLifetime,
      timeoutIdle: timeoutIdle ?? this.timeoutIdle,
      stickySessions: stickySessions ?? this.stickySessions,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2 &&
        other.cookieName == this.cookieName &&
        other.cookieLifetime == this.cookieLifetime &&
        other.timeoutIdle == this.timeoutIdle &&
        other.stickySessions == this.stickySessions;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.cookieName,
      this.cookieLifetime,
      this.timeoutIdle,
      this.stickySessions,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'cookie_name'] = _i1.PropertyValue.scalar(this.cookieName);
    _$result[r'cookie_lifetime'] = _i1.PropertyValue.scalar(
      this.cookieLifetime.toString(),
    );
    _$result[r'timeout_idle'] = _i1.PropertyValue.scalar(
      this.timeoutIdle.toString(),
    );
    _$result[r'sticky_sessions'] = _i1.PropertyValue.scalar(
      this.stickySessions.toString(),
    );
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfAllOfHttpModel2: complex types cannot be URI-encoded',
    );
  }
}
