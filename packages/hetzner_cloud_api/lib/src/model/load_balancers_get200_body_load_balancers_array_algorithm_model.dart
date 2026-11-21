// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_get200_body_load_balancers_array_algorithm_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Algorithm of the Load Balancer.
@_i2.immutable
class LoadBalancersGet200BodyLoadBalancersArrayAlgorithmModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersGet200BodyLoadBalancersArrayAlgorithmModel({
    required this.$type,
  });

  factory LoadBalancersGet200BodyLoadBalancersArrayAlgorithmModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'type'},
      listKeys: {},
      context: r'LoadBalancersGet200BodyLoadBalancersArrayAlgorithmModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersGet200BodyLoadBalancersArrayAlgorithmModel(
      $type:
          _i4.LoadBalancersGet200BodyLoadBalancersArrayAlgorithmTypeModel.fromSimple(
            _$values[r'type'],
            explode: explode,
          ),
    );
  }

  factory LoadBalancersGet200BodyLoadBalancersArrayAlgorithmModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersGet200BodyLoadBalancersArrayAlgorithmModel',
    );
    return LoadBalancersGet200BodyLoadBalancersArrayAlgorithmModel(
      $type:
          _i4.LoadBalancersGet200BodyLoadBalancersArrayAlgorithmTypeModel.fromJson(
            _$map[r'type'],
          ),
    );
  }

  factory LoadBalancersGet200BodyLoadBalancersArrayAlgorithmModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'type'},
      listKeys: {},
      context: r'LoadBalancersGet200BodyLoadBalancersArrayAlgorithmModel',
    );
    return LoadBalancersGet200BodyLoadBalancersArrayAlgorithmModel(
      $type:
          _i4.LoadBalancersGet200BodyLoadBalancersArrayAlgorithmTypeModel.fromForm(
            _$values[r'type'],
            explode: explode,
          ),
    );
  }

  /// Type of the algorithm.
  final _i4.LoadBalancersGet200BodyLoadBalancersArrayAlgorithmTypeModel $type;

  @_i3.override
  _i3.Object? toJson() => {r'type': this.$type.toJson()};

  LoadBalancersGet200BodyLoadBalancersArrayAlgorithmModel Function({
    _i4.LoadBalancersGet200BodyLoadBalancersArrayAlgorithmTypeModel? $type,
  })
  get copyWith {
    return ({
      _i4.LoadBalancersGet200BodyLoadBalancersArrayAlgorithmTypeModel? $type,
    }) => LoadBalancersGet200BodyLoadBalancersArrayAlgorithmModel(
      $type: $type ?? this.$type,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LoadBalancersGet200BodyLoadBalancersArrayAlgorithmModel &&
        other.$type == this.$type;
  }

  @_i3.override
  _i3.int get hashCode => this.$type.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'type'] = _i1.PropertyValue.scalar(this.$type.toJson());
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
      r'Cannot uriEncode LoadBalancersGet200BodyLoadBalancersArrayAlgorithmModel: complex types cannot be URI-encoded',
    );
  }
}
