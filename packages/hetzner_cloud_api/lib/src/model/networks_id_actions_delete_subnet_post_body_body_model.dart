// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class NetworksIdActionsDeleteSubnetPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const NetworksIdActionsDeleteSubnetPostBodyBodyModel({required this.ipRange});

  factory NetworksIdActionsDeleteSubnetPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'ip_range'},
      listKeys: {},
      context: r'NetworksIdActionsDeleteSubnetPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return NetworksIdActionsDeleteSubnetPostBodyBodyModel(
      ipRange: _$values[r'ip_range'].decodeSimpleString(
        context: r'NetworksIdActionsDeleteSubnetPostBodyBodyModel.ip_range',
      ),
    );
  }

  factory NetworksIdActionsDeleteSubnetPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'NetworksIdActionsDeleteSubnetPostBodyBodyModel',
    );
    return NetworksIdActionsDeleteSubnetPostBodyBodyModel(
      ipRange: _$map[r'ip_range'].decodeJsonString(
        context: r'NetworksIdActionsDeleteSubnetPostBodyBodyModel.ip_range',
      ),
    );
  }

  factory NetworksIdActionsDeleteSubnetPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'ip_range'},
      listKeys: {},
      context: r'NetworksIdActionsDeleteSubnetPostBodyBodyModel',
    );
    return NetworksIdActionsDeleteSubnetPostBodyBodyModel(
      ipRange: _$values[r'ip_range'].decodeFormString(
        context: r'NetworksIdActionsDeleteSubnetPostBodyBodyModel.ip_range',
      ),
    );
  }

  /// IP range in CIDR block notation of the subnet to delete.
  ///
  /// **Example**:
  /// ```
  /// 10.0.1.0/24
  /// ```
  final _i3.String ipRange;

  @_i3.override
  _i3.Object? toJson() => {r'ip_range': this.ipRange};

  NetworksIdActionsDeleteSubnetPostBodyBodyModel Function({_i3.String? ipRange})
  get copyWith {
    return ({_i3.String? ipRange}) =>
        NetworksIdActionsDeleteSubnetPostBodyBodyModel(
          ipRange: ipRange ?? this.ipRange,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is NetworksIdActionsDeleteSubnetPostBodyBodyModel &&
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
      r'Cannot uriEncode NetworksIdActionsDeleteSubnetPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
