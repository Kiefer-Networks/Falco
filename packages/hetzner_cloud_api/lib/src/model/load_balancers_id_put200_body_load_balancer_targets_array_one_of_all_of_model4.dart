// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_put200_body_load_balancer_targets_array_one_of_all_of_type_model2.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfModel4
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfModel4({
    required this.$type,
  });

  factory LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfModel4.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'type'},
      listKeys: {},
      context:
          r'LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfModel4',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfModel4(
      $type:
          _i4.LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfTypeModel2.fromSimple(
            _$values[r'type'],
            explode: explode,
          ),
    );
  }

  factory LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfModel4.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context:
          r'LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfModel4',
    );
    return LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfModel4(
      $type:
          _i4.LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfTypeModel2.fromJson(
            _$map[r'type'],
          ),
    );
  }

  factory LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfModel4.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'type'},
      listKeys: {},
      context:
          r'LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfModel4',
    );
    return LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfModel4(
      $type:
          _i4.LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfTypeModel2.fromForm(
            _$values[r'type'],
            explode: explode,
          ),
    );
  }

  /// Type of the resource.
  final _i4.LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfTypeModel2
  $type;

  @_i3.override
  _i3.Object? toJson() => {r'type': this.$type.toJson()};

  LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfModel4 Function({
    _i4.LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfTypeModel2?
    $type,
  })
  get copyWith {
    return ({
      _i4.LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfTypeModel2?
      $type,
    }) => LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfModel4(
      $type: $type ?? this.$type,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfModel4 &&
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
      r'Cannot uriEncode LoadBalancersIdPut200BodyLoadBalancerTargetsArrayOneOfAllOfModel4: complex types cannot be URI-encoded',
    );
  }
}
