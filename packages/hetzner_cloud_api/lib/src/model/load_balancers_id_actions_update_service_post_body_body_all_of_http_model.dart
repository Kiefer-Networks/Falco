// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Configuration option for protocols http and https.
@_i2.immutable
class LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel({
    this.cookieName,
    this.cookieLifetime,
    this.timeoutIdle,
    this.certificates,
    this.redirectHttp = redirectHttpDefault,
    this.stickySessions = stickySessionsDefault,
  });

  factory LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.fromSimple(
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
        r'certificates',
        r'redirect_http',
        r'sticky_sessions',
      },
      listKeys: {r'certificates'},
      context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel(
      cookieName: _$values[r'cookie_name'].decodeSimpleNullableString(
        context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.cookie_name',
      ),
      cookieLifetime: _$values[r'cookie_lifetime'].decodeSimpleNullableInt(
        context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.cookie_lifetime',
      ),
      timeoutIdle: _$values[r'timeout_idle'].decodeSimpleNullableInt(
        context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.timeout_idle',
      ),
      certificates: _$values[r'certificates']
          .decodeSimpleNullableStringList(
            context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.certificates',
            isHeader: isHeader,
          )
          ?.map(
            (e) => e.decodeSimpleInt(
              context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.certificates',
            ),
          )
          .toList(),
      redirectHttp: _$values.containsKey(r'redirect_http')
          ? _$values[r'redirect_http'].decodeSimpleBool(
              context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.redirect_http',
            )
          : redirectHttpDefault,
      stickySessions: _$values.containsKey(r'sticky_sessions')
          ? _$values[r'sticky_sessions'].decodeSimpleBool(
              context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.sticky_sessions',
            )
          : stickySessionsDefault,
    );
  }

  factory LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel',
    );
    return LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel(
      cookieName: _$map[r'cookie_name'].decodeJsonNullableString(
        context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.cookie_name',
      ),
      cookieLifetime: _$map[r'cookie_lifetime'].decodeJsonNullableInt(
        context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.cookie_lifetime',
      ),
      timeoutIdle: _$map[r'timeout_idle'].decodeJsonNullableInt(
        context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.timeout_idle',
      ),
      certificates: _$map[r'certificates'].decodeJsonNullableList<_i3.int>(
        context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.certificates',
      ),
      redirectHttp: _$map.containsKey(r'redirect_http')
          ? _$map[r'redirect_http'].decodeJsonBool(
              context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.redirect_http',
            )
          : redirectHttpDefault,
      stickySessions: _$map.containsKey(r'sticky_sessions')
          ? _$map[r'sticky_sessions'].decodeJsonBool(
              context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.sticky_sessions',
            )
          : stickySessionsDefault,
    );
  }

  factory LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.fromForm(
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
        r'certificates',
        r'redirect_http',
        r'sticky_sessions',
      },
      listKeys: {r'certificates'},
      context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel',
    );
    return LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel(
      cookieName: _$values[r'cookie_name'].decodeFormNullableString(
        context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.cookie_name',
      ),
      cookieLifetime: _$values[r'cookie_lifetime'].decodeFormNullableInt(
        context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.cookie_lifetime',
      ),
      timeoutIdle: _$values[r'timeout_idle'].decodeFormNullableInt(
        context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.timeout_idle',
      ),
      certificates: _$values[r'certificates']
          .decodeSimpleNullableStringList(
            context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.certificates',
          )
          ?.map(
            (e) => e.decodeFormInt(
              context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.certificates',
            ),
          )
          .toList(),
      redirectHttp: _$values.containsKey(r'redirect_http')
          ? _$values[r'redirect_http'].decodeFormBool(
              context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.redirect_http',
            )
          : redirectHttpDefault,
      stickySessions: _$values.containsKey(r'sticky_sessions')
          ? _$values[r'sticky_sessions'].decodeFormBool(
              context: r'LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel.sticky_sessions',
            )
          : stickySessionsDefault,
    );
  }

  static const _i3.bool redirectHttpDefault = false;

  static const _i3.bool stickySessionsDefault = false;

  /// Name of the cookie used for sticky sessions.
  ///
  /// **Example**:
  /// ```
  /// HCLBSTICKY
  /// ```
  final _i3.String? cookieName;

  /// Lifetime of the cookie used for sticky sessions (in seconds).
  ///
  /// **Example**:
  /// ```json
  /// 300
  /// ```
  final _i3.int? cookieLifetime;

  /// Idle timeout in seconds for the client and server side.
  ///
  /// **Example**:
  /// ```json
  /// 50
  /// ```
  final _i3.int? timeoutIdle;

  /// IDs of the Certificates to use for TLS/SSL termination by the Load Balancer; empty for TLS/SSL passthrough or if `protocol` is `http`.
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   897
  /// ]
  /// ```
  final _i3.List<_i3.int>? certificates;

  /// Redirect HTTP requests to HTTPS. Only available if `protocol` is `https`.
  ///
  /// **Example**:
  /// ```json
  /// true
  /// ```
  final _i3.bool? redirectHttp;

  /// Use sticky sessions. Only available if `protocol` is `http` or `https`.
  ///
  /// **Example**:
  /// ```json
  /// true
  /// ```
  final _i3.bool? stickySessions;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.cookieName != null) r'cookie_name': this.cookieName,
    if (this.cookieLifetime != null) r'cookie_lifetime': this.cookieLifetime,
    if (this.timeoutIdle != null) r'timeout_idle': this.timeoutIdle,
    if (this.certificates != null) r'certificates': this.certificates,
    if (this.redirectHttp != null) r'redirect_http': this.redirectHttp,
    if (this.stickySessions != null) r'sticky_sessions': this.stickySessions,
  };

  LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel Function({
    _i3.String? cookieName,
    _i3.int? cookieLifetime,
    _i3.int? timeoutIdle,
    _i3.List<_i3.int>? certificates,
    _i3.bool? redirectHttp,
    _i3.bool? stickySessions,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? cookieName = _sentinel,
      _i3.Object? cookieLifetime = _sentinel,
      _i3.Object? timeoutIdle = _sentinel,
      _i3.Object? certificates = _sentinel,
      _i3.Object? redirectHttp = _sentinel,
      _i3.Object? stickySessions = _sentinel,
    }) => LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel(
      cookieName: _i3.identical(cookieName, _sentinel)
          ? this.cookieName
          : (cookieName as _i3.String?),
      cookieLifetime: _i3.identical(cookieLifetime, _sentinel)
          ? this.cookieLifetime
          : (cookieLifetime as _i3.int?),
      timeoutIdle: _i3.identical(timeoutIdle, _sentinel)
          ? this.timeoutIdle
          : (timeoutIdle as _i3.int?),
      certificates: _i3.identical(certificates, _sentinel)
          ? this.certificates
          : (certificates as _i3.List<_i3.int>?),
      redirectHttp: _i3.identical(redirectHttp, _sentinel)
          ? this.redirectHttp
          : (redirectHttp as _i3.bool?),
      stickySessions: _i3.identical(stickySessions, _sentinel)
          ? this.stickySessions
          : (stickySessions as _i3.bool?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other
            is LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel &&
        other.cookieName == this.cookieName &&
        other.cookieLifetime == this.cookieLifetime &&
        other.timeoutIdle == this.timeoutIdle &&
        _$deepEquals.equals(other.certificates, this.certificates) &&
        other.redirectHttp == this.redirectHttp &&
        other.stickySessions == this.stickySessions;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.cookieName,
      this.cookieLifetime,
      this.timeoutIdle,
      deepEquals.hash(this.certificates),
      this.redirectHttp,
      this.stickySessions,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (this.cookieName != null) {
      _$result[r'cookie_name'] = _i1.PropertyValue.scalar(this.cookieName!);
    }
    if (this.cookieLifetime != null) {
      _$result[r'cookie_lifetime'] = _i1.PropertyValue.scalar(
        this.cookieLifetime!.toString(),
      );
    }
    if (this.timeoutIdle != null) {
      _$result[r'timeout_idle'] = _i1.PropertyValue.scalar(
        this.timeoutIdle!.toString(),
      );
    }
    if (this.certificates != null) {
      _$result[r'certificates'] = _i1.PropertyValue.array(
        this.certificates!.map((e) => e.toString()).toList(),
      );
    }
    if (this.redirectHttp != null) {
      _$result[r'redirect_http'] = _i1.PropertyValue.scalar(
        this.redirectHttp!.toString(),
      );
    }
    if (this.stickySessions != null) {
      _$result[r'sticky_sessions'] = _i1.PropertyValue.scalar(
        this.stickySessions!.toString(),
      );
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
      r'Cannot uriEncode LoadBalancersIdActionsUpdateServicePostBodyBodyAllOfHttpModel: complex types cannot be URI-encoded',
    );
  }
}
