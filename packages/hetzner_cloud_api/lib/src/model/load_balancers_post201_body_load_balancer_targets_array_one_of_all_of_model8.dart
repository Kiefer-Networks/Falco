// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i8;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i7;
import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_targets_array_one_of_all_of_label_selector_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_targets_array_one_of_all_of_targets_array_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_targets_array_one_of_all_of_type_model5.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel8
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel8({
    required this.labelSelector,
    required this.targets,
    this.$type,
    this.usePrivateIp = usePrivateIpDefault,
  });

  factory LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel8.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel8: contains complex types',
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel8.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context:
          r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel8',
    );
    return LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel8(
      $type: _$map[r'type'] == null
          ? null
          : _i4.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTypeModel5.fromJson(
              _$map[r'type'],
            ),
      labelSelector:
          _i5.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfLabelSelectorModel.fromJson(
            _$map[r'label_selector'],
          ),
      targets: _$map[r'targets']
          .decodeJsonList<_i3.Object?>(
            context: r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel8.targets',
          )
          .map(
            _i6
                .LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayModel
                .fromJson,
          )
          .toList(),
      usePrivateIp: _$map.containsKey(r'use_private_ip')
          ? _$map[r'use_private_ip'].decodeJsonBool(
              context: r'LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel8.use_private_ip',
            )
          : usePrivateIpDefault,
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel8.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel8: contains complex types',
    );
  }

  static const _i3.bool usePrivateIpDefault = false;

  /// **Example**:
  /// ```
  /// label_selector
  /// ```
  final _i4.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTypeModel5?
  $type;

  /// Label selector used to determine targets. Only present for target type "label_selector".
  final _i5.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfLabelSelectorModel
  labelSelector;

  /// List of resolved label selector target Servers.
  final _i3.List<
    _i6.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayModel
  >
  targets;

  /// Use the private network IP instead of the public IP. Only present for target types "server" and "label_selector".
  final _i3.bool usePrivateIp;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.$type != null) r'type': this.$type?.toJson(),
    r'label_selector': this.labelSelector.toJson(),
    r'targets': this.targets.map((e) => e.toJson()).toList(),
    r'use_private_ip': this.usePrivateIp,
  };

  LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel8 Function({
    _i4.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTypeModel5?
    $type,
    _i5.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfLabelSelectorModel?
    labelSelector,
    _i3.List<
      _i6.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayModel
    >?
    targets,
    _i3.bool? usePrivateIp,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? $type = _sentinel,
      _i5.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfLabelSelectorModel?
      labelSelector,
      _i3.List<
        _i6.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTargetsArrayModel
      >?
      targets,
      _i3.bool? usePrivateIp,
    }) => LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel8(
      $type: _i3.identical($type, _sentinel)
          ? this.$type
          : ($type
                as _i4.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfTypeModel5?),
      labelSelector: labelSelector ?? this.labelSelector,
      targets: targets ?? this.targets,
      usePrivateIp: usePrivateIp ?? this.usePrivateIp,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i7.DeepCollectionEquality();
    return other
            is LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel8 &&
        other.$type == this.$type &&
        other.labelSelector == this.labelSelector &&
        _$deepEquals.equals(other.targets, this.targets) &&
        other.usePrivateIp == this.usePrivateIp;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i7.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.$type,
      this.labelSelector,
      deepEquals.hash(this.targets),
      this.usePrivateIp,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel8: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i8.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfAllOfModel8: complex types cannot be URI-encoded',
    );
  }
}
