// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3({
    this.usePrivateIp = usePrivateIpDefault,
  });

  factory LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'use_private_ip'},
      listKeys: {},
      context: r'LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3(
      usePrivateIp: _$values.containsKey(r'use_private_ip')
          ? _$values[r'use_private_ip'].decodeSimpleBool(
              context: r'LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3.use_private_ip',
            )
          : usePrivateIpDefault,
    );
  }

  factory LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3',
    );
    return LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3(
      usePrivateIp: _$map.containsKey(r'use_private_ip')
          ? _$map[r'use_private_ip'].decodeJsonBool(
              context: r'LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3.use_private_ip',
            )
          : usePrivateIpDefault,
    );
  }

  factory LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'use_private_ip'},
      listKeys: {},
      context: r'LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3',
    );
    return LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3(
      usePrivateIp: _$values.containsKey(r'use_private_ip')
          ? _$values[r'use_private_ip'].decodeFormBool(
              context: r'LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3.use_private_ip',
            )
          : usePrivateIpDefault,
    );
  }

  static const _i3.bool usePrivateIpDefault = false;

  /// Use the private network IP instead of the public IP of the Server, requires the Server and Load Balancer to be in the same network. Only valid for target types `server` and `label_selector`.
  ///
  /// **Example**:
  /// ```json
  /// true
  /// ```
  final _i3.bool? usePrivateIp;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.usePrivateIp != null) r'use_private_ip': this.usePrivateIp,
  };

  LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3 Function({
    _i3.bool? usePrivateIp,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({_i3.Object? usePrivateIp = _sentinel}) =>
        LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3(
          usePrivateIp: _i3.identical(usePrivateIp, _sentinel)
              ? this.usePrivateIp
              : (usePrivateIp as _i3.bool?),
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3 &&
        other.usePrivateIp == this.usePrivateIp;
  }

  @_i3.override
  _i3.int get hashCode => this.usePrivateIp.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (this.usePrivateIp != null) {
      _$result[r'use_private_ip'] = _i1.PropertyValue.scalar(
        this.usePrivateIp!.toString(),
      );
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
      r'Cannot uriEncode LoadBalancersIdActionsAddTargetPostBodyBodyAllOfModel3: complex types cannot be URI-encoded',
    );
  }
}
