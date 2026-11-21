// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_targets_array_one_of_all_of_type_model3.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5({
    required this.$type,
  });

  factory LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5.fromSimple(
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
          r'LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5(
      $type:
          _i4.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfTypeModel3.fromSimple(
            _$values[r'type'],
            explode: explode,
          ),
    );
  }

  factory LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context:
          r'LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5',
    );
    return LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5(
      $type:
          _i4.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfTypeModel3.fromJson(
            _$map[r'type'],
          ),
    );
  }

  factory LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'type'},
      listKeys: {},
      context:
          r'LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5',
    );
    return LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5(
      $type:
          _i4.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfTypeModel3.fromForm(
            _$values[r'type'],
            explode: explode,
          ),
    );
  }

  /// Type of the resource.
  final _i4.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfTypeModel3
  $type;

  @_i3.override
  _i3.Object? toJson() => {r'type': this.$type.toJson()};

  LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5 Function({
    _i4.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfTypeModel3?
    $type,
  })
  get copyWith {
    return ({
      _i4.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfTypeModel3?
      $type,
    }) => LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5(
      $type: $type ?? this.$type,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5 &&
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
      r'Cannot uriEncode LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfAllOfModel5: complex types cannot be URI-encoded',
    );
  }
}
