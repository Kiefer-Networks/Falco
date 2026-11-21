// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel({
    required this.network,
  });

  factory LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'network'},
      listKeys: {},
      context: r'LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel(
      network: _$values[r'network'].decodeSimpleInt(
        context:
            r'LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel.network',
      ),
    );
  }

  factory LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel',
    );
    return LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel(
      network: _$map[r'network'].decodeJsonInt(
        context:
            r'LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel.network',
      ),
    );
  }

  factory LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'network'},
      listKeys: {},
      context: r'LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel',
    );
    return LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel(
      network: _$values[r'network'].decodeFormInt(
        context:
            r'LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel.network',
      ),
    );
  }

  /// ID of an existing network to detach the Load Balancer from.
  ///
  /// **Example**:
  /// ```json
  /// 4711
  /// ```
  final _i3.int network;

  @_i3.override
  _i3.Object? toJson() => {r'network': this.network};

  LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel Function({
    _i3.int? network,
  })
  get copyWith {
    return ({_i3.int? network}) =>
        LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel(
          network: network ?? this.network,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel &&
        other.network == this.network;
  }

  @_i3.override
  _i3.int get hashCode => this.network.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'network'] = _i1.PropertyValue.scalar(this.network.toString());
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
      r'Cannot uriEncode LoadBalancersIdActionsDetachFromNetworkPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
