// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class NetworksIdActionsChangeIpRangePostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const NetworksIdActionsChangeIpRangePostBodyBodyModel({
    required this.ipRange,
  });

  factory NetworksIdActionsChangeIpRangePostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'ip_range'},
      listKeys: {},
      context: r'NetworksIdActionsChangeIpRangePostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return NetworksIdActionsChangeIpRangePostBodyBodyModel(
      ipRange: _$values[r'ip_range'].decodeSimpleString(
        context: r'NetworksIdActionsChangeIpRangePostBodyBodyModel.ip_range',
      ),
    );
  }

  factory NetworksIdActionsChangeIpRangePostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'NetworksIdActionsChangeIpRangePostBodyBodyModel',
    );
    return NetworksIdActionsChangeIpRangePostBodyBodyModel(
      ipRange: _$map[r'ip_range'].decodeJsonString(
        context: r'NetworksIdActionsChangeIpRangePostBodyBodyModel.ip_range',
      ),
    );
  }

  factory NetworksIdActionsChangeIpRangePostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'ip_range'},
      listKeys: {},
      context: r'NetworksIdActionsChangeIpRangePostBodyBodyModel',
    );
    return NetworksIdActionsChangeIpRangePostBodyBodyModel(
      ipRange: _$values[r'ip_range'].decodeFormString(
        context: r'NetworksIdActionsChangeIpRangePostBodyBodyModel.ip_range',
      ),
    );
  }

  /// IP range of the [Network](#tag/networks).
  ///
  /// Uses CIDR notation.
  ///
  /// Must span all included subnets. Must be one of the private IPv4 ranges of RFC1918.
  ///
  /// Minimum network size is /24. We highly recommend that you pick a larger [Network](#tag/networks) with a /16 netmask.
  ///
  ///
  /// **Example**:
  /// ```
  /// 10.0.0.0/16
  /// ```
  final _i3.String ipRange;

  @_i3.override
  _i3.Object? toJson() => {r'ip_range': this.ipRange};

  NetworksIdActionsChangeIpRangePostBodyBodyModel Function({
    _i3.String? ipRange,
  })
  get copyWith {
    return ({_i3.String? ipRange}) =>
        NetworksIdActionsChangeIpRangePostBodyBodyModel(
          ipRange: ipRange ?? this.ipRange,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is NetworksIdActionsChangeIpRangePostBodyBodyModel &&
        other.ipRange == this.ipRange;
  }

  @_i3.override
  _i3.int get hashCode => this.ipRange.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'ip_range'] = _i1.PropertyValue.scalar(this.ipRange);
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
      r'Cannot uriEncode NetworksIdActionsChangeIpRangePostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
