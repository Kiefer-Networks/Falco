// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i13;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i12;
import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_algorithm_model.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_load_balancer_type_model.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_location_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_private_net_array_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_protection_model.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_public_net_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_services_array_one_of_model.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/model/load_balancers_post201_body_load_balancer_targets_array_one_of_model.dart'
    as _i10;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersPost201BodyLoadBalancerModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersPost201BodyLoadBalancerModel({
    required this.id,
    required this.name,
    required this.publicNet,
    required this.privateNet,
    required this.location,
    required this.loadBalancerType,
    required this.protection,
    required this.labels,
    required this.created,
    required this.services,
    required this.targets,
    required this.algorithm,
    required this.outgoingTraffic,
    required this.ingoingTraffic,
    required this.includedTraffic,
  });

  factory LoadBalancersPost201BodyLoadBalancerModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancersPost201BodyLoadBalancerModel: contains complex types',
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersPost201BodyLoadBalancerModel',
    );
    return LoadBalancersPost201BodyLoadBalancerModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'LoadBalancersPost201BodyLoadBalancerModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'LoadBalancersPost201BodyLoadBalancerModel.name',
      ),
      publicNet:
          _i4.LoadBalancersPost201BodyLoadBalancerPublicNetModel.fromJson(
            _$map[r'public_net'],
          ),
      privateNet: _$map[r'private_net']
          .decodeJsonList<_i3.Object?>(
            context: r'LoadBalancersPost201BodyLoadBalancerModel.private_net',
          )
          .map(
            _i5
                .LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel
                .fromJson,
          )
          .toList(),
      location: _i6.LoadBalancersPost201BodyLoadBalancerLocationModel.fromJson(
        _$map[r'location'],
      ),
      loadBalancerType:
          _i7.LoadBalancersPost201BodyLoadBalancerLoadBalancerTypeModel.fromJson(
            _$map[r'load_balancer_type'],
          ),
      protection:
          _i8.LoadBalancersPost201BodyLoadBalancerProtectionModel.fromJson(
            _$map[r'protection'],
          ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context: r'LoadBalancersPost201BodyLoadBalancerModel.labels',
        ),
        context: r'LoadBalancersPost201BodyLoadBalancerModel.labels',
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'LoadBalancersPost201BodyLoadBalancerModel.created',
      ),
      services: _$map[r'services']
          .decodeJsonList<_i3.Object?>(
            context: r'LoadBalancersPost201BodyLoadBalancerModel.services',
          )
          .map(
            _i9
                .LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel
                .fromJson,
          )
          .toList(),
      targets: _$map[r'targets']
          .decodeJsonList<_i3.Object?>(
            context: r'LoadBalancersPost201BodyLoadBalancerModel.targets',
          )
          .map(
            _i10
                .LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfModel
                .fromJson,
          )
          .toList(),
      algorithm:
          _i11.LoadBalancersPost201BodyLoadBalancerAlgorithmModel.fromJson(
            _$map[r'algorithm'],
          ),
      outgoingTraffic: _$map[r'outgoing_traffic'].decodeJsonNullableInt(
        context: r'LoadBalancersPost201BodyLoadBalancerModel.outgoing_traffic',
      ),
      ingoingTraffic: _$map[r'ingoing_traffic'].decodeJsonNullableInt(
        context: r'LoadBalancersPost201BodyLoadBalancerModel.ingoing_traffic',
      ),
      includedTraffic: _$map[r'included_traffic'].decodeJsonInt(
        context: r'LoadBalancersPost201BodyLoadBalancerModel.included_traffic',
      ),
    );
  }

  factory LoadBalancersPost201BodyLoadBalancerModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancersPost201BodyLoadBalancerModel: contains complex types',
    );
  }

  /// ID of the [Load Balancer](#tag/load-balancers).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Name of the Resource. Must be unique per Project.
  ///
  /// **Example**:
  /// ```
  /// my-resource
  /// ```
  final _i3.String name;

  /// Public network information.
  final _i4.LoadBalancersPost201BodyLoadBalancerPublicNetModel publicNet;

  /// Private networks information.
  final _i3.List<_i5.LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel>
  privateNet;

  final _i6.LoadBalancersPost201BodyLoadBalancerLocationModel location;

  final _i7.LoadBalancersPost201BodyLoadBalancerLoadBalancerTypeModel
  loadBalancerType;

  /// Protection configuration for the Resource.
  final _i8.LoadBalancersPost201BodyLoadBalancerProtectionModel protection;

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
  final _i3.Map<_i3.String, _i3.String> labels;

  /// Point in time when the Resource was created (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  /// **Example**:
  /// ```
  /// 2016-01-30T23:55:00Z
  /// ```
  final _i3.DateTime created;

  /// List of services that belong to this Load Balancer.
  final _i3.List<
    _i9.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel
  >
  services;

  /// List of targets that belong to this Load Balancer.
  final _i3.List<
    _i10.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfModel
  >
  targets;

  /// Algorithm of the Load Balancer.
  final _i11.LoadBalancersPost201BodyLoadBalancerAlgorithmModel algorithm;

  /// Outbound Traffic for the current billing period in bytes.
  final _i3.int? outgoingTraffic;

  /// Inbound Traffic for the current billing period in bytes.
  final _i3.int? ingoingTraffic;

  /// Free Traffic for the current billing period in bytes.
  ///
  /// **Example**:
  /// ```json
  /// 10000
  /// ```
  final _i3.int includedTraffic;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'public_net': this.publicNet.toJson(),
    r'private_net': this.privateNet.map((e) => e.toJson()).toList(),
    r'location': this.location.toJson(),
    r'load_balancer_type': this.loadBalancerType.toJson(),
    r'protection': this.protection.toJson(),
    r'labels': this.labels,
    r'created': this.created.toTimeZonedIso8601String(),
    r'services': this.services.map((e) => e.toJson()).toList(),
    r'targets': this.targets.map((e) => e.toJson()).toList(),
    r'algorithm': this.algorithm.toJson(),
    r'outgoing_traffic': this.outgoingTraffic,
    r'ingoing_traffic': this.ingoingTraffic,
    r'included_traffic': this.includedTraffic,
  };

  LoadBalancersPost201BodyLoadBalancerModel Function({
    _i3.int? id,
    _i3.String? name,
    _i4.LoadBalancersPost201BodyLoadBalancerPublicNetModel? publicNet,
    _i3.List<_i5.LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel>?
    privateNet,
    _i6.LoadBalancersPost201BodyLoadBalancerLocationModel? location,
    _i7.LoadBalancersPost201BodyLoadBalancerLoadBalancerTypeModel?
    loadBalancerType,
    _i8.LoadBalancersPost201BodyLoadBalancerProtectionModel? protection,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i3.DateTime? created,
    _i3.List<_i9.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel>?
    services,
    _i3.List<_i10.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfModel>?
    targets,
    _i11.LoadBalancersPost201BodyLoadBalancerAlgorithmModel? algorithm,
    _i3.int? outgoingTraffic,
    _i3.int? ingoingTraffic,
    _i3.int? includedTraffic,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.String? name,
      _i4.LoadBalancersPost201BodyLoadBalancerPublicNetModel? publicNet,
      _i3.List<_i5.LoadBalancersPost201BodyLoadBalancerPrivateNetArrayModel>?
      privateNet,
      _i6.LoadBalancersPost201BodyLoadBalancerLocationModel? location,
      _i7.LoadBalancersPost201BodyLoadBalancerLoadBalancerTypeModel?
      loadBalancerType,
      _i8.LoadBalancersPost201BodyLoadBalancerProtectionModel? protection,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i3.DateTime? created,
      _i3.List<_i9.LoadBalancersPost201BodyLoadBalancerServicesArrayOneOfModel>?
      services,
      _i3.List<_i10.LoadBalancersPost201BodyLoadBalancerTargetsArrayOneOfModel>?
      targets,
      _i11.LoadBalancersPost201BodyLoadBalancerAlgorithmModel? algorithm,
      _i3.Object? outgoingTraffic = _sentinel,
      _i3.Object? ingoingTraffic = _sentinel,
      _i3.int? includedTraffic,
    }) => LoadBalancersPost201BodyLoadBalancerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      publicNet: publicNet ?? this.publicNet,
      privateNet: privateNet ?? this.privateNet,
      location: location ?? this.location,
      loadBalancerType: loadBalancerType ?? this.loadBalancerType,
      protection: protection ?? this.protection,
      labels: labels ?? this.labels,
      created: created ?? this.created,
      services: services ?? this.services,
      targets: targets ?? this.targets,
      algorithm: algorithm ?? this.algorithm,
      outgoingTraffic: _i3.identical(outgoingTraffic, _sentinel)
          ? this.outgoingTraffic
          : (outgoingTraffic as _i3.int?),
      ingoingTraffic: _i3.identical(ingoingTraffic, _sentinel)
          ? this.ingoingTraffic
          : (ingoingTraffic as _i3.int?),
      includedTraffic: includedTraffic ?? this.includedTraffic,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i12.DeepCollectionEquality();
    return other is LoadBalancersPost201BodyLoadBalancerModel &&
        other.id == this.id &&
        other.name == this.name &&
        other.publicNet == this.publicNet &&
        _$deepEquals.equals(other.privateNet, this.privateNet) &&
        other.location == this.location &&
        other.loadBalancerType == this.loadBalancerType &&
        other.protection == this.protection &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.created == this.created &&
        _$deepEquals.equals(other.services, this.services) &&
        _$deepEquals.equals(other.targets, this.targets) &&
        other.algorithm == this.algorithm &&
        other.outgoingTraffic == this.outgoingTraffic &&
        other.ingoingTraffic == this.ingoingTraffic &&
        other.includedTraffic == this.includedTraffic;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i12.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.name,
      this.publicNet,
      deepEquals.hash(this.privateNet),
      this.location,
      this.loadBalancerType,
      this.protection,
      deepEquals.hash(this.labels),
      this.created,
      deepEquals.hash(this.services),
      deepEquals.hash(this.targets),
      this.algorithm,
      this.outgoingTraffic,
      this.ingoingTraffic,
      this.includedTraffic,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for LoadBalancersPost201BodyLoadBalancerModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i13.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersPost201BodyLoadBalancerModel: complex types cannot be URI-encoded',
    );
  }
}
