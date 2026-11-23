// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i9;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i8;
import 'package:hetzner_cloud_api/src/model/load_balancers_post_body_body_algorithm_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_post_body_body_public_net_model.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/model/load_balancers_post_body_body_services_array_one_of_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/load_balancers_post_body_body_targets_array_all_of_model.dart'
    as _i6;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersPostBodyBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersPostBodyBodyModel({
    required this.name,
    required this.loadBalancerType,
    this.algorithm,
    this.services,
    this.targets,
    this.labels,
    this.publicInterface,
    this.publicNet,
    this.network,
    this.networkZone,
    this.location,
  });

  factory LoadBalancersPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancersPostBodyBodyModel: contains complex types',
    );
  }

  factory LoadBalancersPostBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'LoadBalancersPostBodyBodyModel');
    return LoadBalancersPostBodyBodyModel(
      name: _$map[r'name'].decodeJsonString(
        context: r'LoadBalancersPostBodyBodyModel.name',
      ),
      loadBalancerType: _$map[r'load_balancer_type'].decodeJsonString(
        context: r'LoadBalancersPostBodyBodyModel.load_balancer_type',
      ),
      algorithm: _$map.containsKey(r'algorithm')
          ? _i4.LoadBalancersPostBodyBodyAlgorithmModel.fromJson(
              _$map[r'algorithm'],
            )
          : algorithmDefault,
      services: _$map[r'services']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'LoadBalancersPostBodyBodyModel.services',
          )
          ?.map(_i5.LoadBalancersPostBodyBodyServicesArrayOneOfModel.fromJson)
          .toList(),
      targets: _$map[r'targets']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'LoadBalancersPostBodyBodyModel.targets',
          )
          ?.map(_i6.LoadBalancersPostBodyBodyTargetsArrayAllOfModel.fromJson)
          .toList(),
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(
          context: r'LoadBalancersPostBodyBodyModel.labels',
        ),
        context: r'LoadBalancersPostBodyBodyModel.labels',
      ),
      publicInterface: _$map[r'public_interface'].decodeJsonNullableBool(
        context: r'LoadBalancersPostBodyBodyModel.public_interface',
      ),
      publicNet: _$map[r'public_net'] == null
          ? null
          : _i7.LoadBalancersPostBodyBodyPublicNetModel.fromJson(
              _$map[r'public_net'],
            ),
      network: _$map[r'network'].decodeJsonNullableInt(
        context: r'LoadBalancersPostBodyBodyModel.network',
      ),
      networkZone: _$map[r'network_zone'].decodeJsonNullableString(
        context: r'LoadBalancersPostBodyBodyModel.network_zone',
      ),
      location: _$map[r'location'].decodeJsonNullableString(
        context: r'LoadBalancersPostBodyBodyModel.location',
      ),
    );
  }

  factory LoadBalancersPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancersPostBodyBodyModel: contains complex types',
    );
  }

  /// Name of the Load Balancer.
  ///
  /// **Example**:
  /// ```
  /// Web Frontend
  /// ```
  final _i3.String name;

  /// ID or name of the Load Balancer type this Load Balancer should be created with.
  ///
  /// **Example**:
  /// ```
  /// lb11
  /// ```
  final _i3.String loadBalancerType;

  /// Algorithm of the Load Balancer.
  final _i4.LoadBalancersPostBodyBodyAlgorithmModel? algorithm;

  /// Array of services.
  final _i3.List<_i5.LoadBalancersPostBodyBodyServicesArrayOneOfModel>?
  services;

  /// Array of targets.
  final _i3.List<_i6.LoadBalancersPostBodyBodyTargetsArrayAllOfModel>? targets;

  /// User-defined labels (`key/value` pairs) for the Resource.
  /// For more information, see "[Labels](#description/labels)".
  ///
  ///
  /// **Example**:
  /// ```json
  /// {
  ///   "environment": "prod",
  ///   "example.com/my": "label",
  ///   "just-a-key": ""
  /// }
  /// ```
  final _i3.Map<_i3.String, _i3.String>? labels;

  /// Enable or disable the public interface of the Load Balancer.
  ///
  /// **Example**:
  /// ```json
  /// true
  /// ```
  final _i3.bool? publicInterface;

  /// Public network options of the Load Balancer.
  ///
  /// Only allowed if the public interface is enabled.
  ///
  final _i7.LoadBalancersPostBodyBodyPublicNetModel? publicNet;

  /// ID of the network the Load Balancer should be attached to on creation.
  ///
  /// **Example**:
  /// ```json
  /// 123
  /// ```
  final _i3.int? network;

  /// Name of network zone.
  ///
  /// **Example**:
  /// ```
  /// eu-central
  /// ```
  final _i3.String? networkZone;

  /// ID or name of Location to create Load Balancer in.
  ///
  /// **Example**:
  /// ```
  /// fsn1
  /// ```
  final _i3.String? location;

  @_i3.override
  _i3.Object? toJson() => {
    r'name': this.name,
    r'load_balancer_type': this.loadBalancerType,
    if (this.algorithm != null) r'algorithm': this.algorithm?.toJson(),
    if (this.services != null)
      r'services': this.services?.map((e) => e.toJson()).toList(),
    if (this.targets != null)
      r'targets': this.targets?.map((e) => e.toJson()).toList(),
    if (this.labels != null) r'labels': this.labels,
    if (this.publicInterface != null) r'public_interface': this.publicInterface,
    if (this.publicNet != null) r'public_net': this.publicNet?.toJson(),
    if (this.network != null) r'network': this.network,
    if (this.networkZone != null) r'network_zone': this.networkZone,
    if (this.location != null) r'location': this.location,
  };

  LoadBalancersPostBodyBodyModel Function({
    _i3.String? name,
    _i3.String? loadBalancerType,
    _i4.LoadBalancersPostBodyBodyAlgorithmModel? algorithm,
    _i3.List<_i5.LoadBalancersPostBodyBodyServicesArrayOneOfModel>? services,
    _i3.List<_i6.LoadBalancersPostBodyBodyTargetsArrayAllOfModel>? targets,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i3.bool? publicInterface,
    _i7.LoadBalancersPostBodyBodyPublicNetModel? publicNet,
    _i3.int? network,
    _i3.String? networkZone,
    _i3.String? location,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.String? name,
      _i3.String? loadBalancerType,
      _i3.Object? algorithm = _sentinel,
      _i3.Object? services = _sentinel,
      _i3.Object? targets = _sentinel,
      _i3.Object? labels = _sentinel,
      _i3.Object? publicInterface = _sentinel,
      _i3.Object? publicNet = _sentinel,
      _i3.Object? network = _sentinel,
      _i3.Object? networkZone = _sentinel,
      _i3.Object? location = _sentinel,
    }) => LoadBalancersPostBodyBodyModel(
      name: name ?? this.name,
      loadBalancerType: loadBalancerType ?? this.loadBalancerType,
      algorithm: _i3.identical(algorithm, _sentinel)
          ? this.algorithm
          : (algorithm as _i4.LoadBalancersPostBodyBodyAlgorithmModel?),
      services: _i3.identical(services, _sentinel)
          ? this.services
          : (services
                as _i3.List<
                  _i5.LoadBalancersPostBodyBodyServicesArrayOneOfModel
                >?),
      targets: _i3.identical(targets, _sentinel)
          ? this.targets
          : (targets
                as _i3.List<
                  _i6.LoadBalancersPostBodyBodyTargetsArrayAllOfModel
                >?),
      labels: _i3.identical(labels, _sentinel)
          ? this.labels
          : (labels as _i3.Map<_i3.String, _i3.String>?),
      publicInterface: _i3.identical(publicInterface, _sentinel)
          ? this.publicInterface
          : (publicInterface as _i3.bool?),
      publicNet: _i3.identical(publicNet, _sentinel)
          ? this.publicNet
          : (publicNet as _i7.LoadBalancersPostBodyBodyPublicNetModel?),
      network: _i3.identical(network, _sentinel)
          ? this.network
          : (network as _i3.int?),
      networkZone: _i3.identical(networkZone, _sentinel)
          ? this.networkZone
          : (networkZone as _i3.String?),
      location: _i3.identical(location, _sentinel)
          ? this.location
          : (location as _i3.String?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i8.DeepCollectionEquality();
    return other is LoadBalancersPostBodyBodyModel &&
        other.name == this.name &&
        other.loadBalancerType == this.loadBalancerType &&
        other.algorithm == this.algorithm &&
        _$deepEquals.equals(other.services, this.services) &&
        _$deepEquals.equals(other.targets, this.targets) &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.publicInterface == this.publicInterface &&
        other.publicNet == this.publicNet &&
        other.network == this.network &&
        other.networkZone == this.networkZone &&
        other.location == this.location;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i8.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.name,
      this.loadBalancerType,
      this.algorithm,
      deepEquals.hash(this.services),
      deepEquals.hash(this.targets),
      deepEquals.hash(this.labels),
      this.publicInterface,
      this.publicNet,
      this.network,
      this.networkZone,
      this.location,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for LoadBalancersPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i9.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }

  static _i4.LoadBalancersPostBodyBodyAlgorithmModel get algorithmDefault =>
      _i4.LoadBalancersPostBodyBodyAlgorithmModel.fromJson(
        const <_i3.String, _i3.Object?>{r'type': r'round_robin'},
      );
}
