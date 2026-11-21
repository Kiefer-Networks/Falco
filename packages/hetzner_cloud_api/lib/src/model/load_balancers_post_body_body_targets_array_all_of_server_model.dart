// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Configuration for type Server, only valid and required if type is `server`.
@_i2.immutable
class LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel({
    required this.id,
    this.ip,
  });

  factory LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'id', r'ip'},
      listKeys: {},
      context: r'LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel(
      id: _$values[r'id'].decodeSimpleInt(
        context: r'LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel.id',
      ),
      ip: _$values[r'ip'].decodeSimpleNullableString(
        context: r'LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel.ip',
      ),
    );
  }

  factory LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel',
    );
    return LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel.id',
      ),
      ip: _$map[r'ip'].decodeJsonNullableString(
        context: r'LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel.ip',
      ),
    );
  }

  factory LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'id', r'ip'},
      listKeys: {},
      context: r'LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel',
    );
    return LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel(
      id: _$values[r'id'].decodeFormInt(
        context: r'LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel.id',
      ),
      ip: _$values[r'ip'].decodeFormNullableString(
        context: r'LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel.ip',
      ),
    );
  }

  /// ID of the Server.
  ///
  /// **Example**:
  /// ```json
  /// 80
  /// ```
  final _i3.int id;

  /// Optional public IP of the Server to use as target.
  /// Must be the Primary IPv4 of the Server, or an IPv6 host address within IPv6 /64 subnet of the Server. If omitted, the Primary IPv4 of the Server is used. Must not be a private IP and is only valid for public targets.
  ///
  /// **Example**:
  /// ```
  /// 2001:db8::1
  /// ```
  final _i3.String? ip;

  @_i3.override
  _i3.Object? toJson() => {r'id': this.id, if (this.ip != null) r'ip': this.ip};

  LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel Function({
    _i3.int? id,
    _i3.String? ip,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({_i3.int? id, _i3.Object? ip = _sentinel}) =>
        LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel(
          id: id ?? this.id,
          ip: _i3.identical(ip, _sentinel) ? this.ip : (ip as _i3.String?),
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel &&
        other.id == this.id &&
        other.ip == this.ip;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.id, this.ip]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'id'] = _i1.PropertyValue.scalar(this.id.toString());
    if (this.ip != null) {
      _$result[r'ip'] = _i1.PropertyValue.scalar(this.ip!);
    }
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
      r'Cannot uriEncode LoadBalancersPostBodyBodyTargetsArrayAllOfServerModel: complex types cannot be URI-encoded',
    );
  }
}
