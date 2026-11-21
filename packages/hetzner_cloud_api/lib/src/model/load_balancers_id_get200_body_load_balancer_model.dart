// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i13;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i12;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_algorithm_model.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_load_balancer_type_model.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_location_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_private_net_array_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_protection_model.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_public_net_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_services_array_one_of_model.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_targets_array_one_of_model.dart'
    as _i10;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdGet200BodyLoadBalancerModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdGet200BodyLoadBalancerModel({
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

  factory LoadBalancersIdGet200BodyLoadBalancerModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancersIdGet200BodyLoadBalancerModel: contains complex types',
    );
  }

  factory LoadBalancersIdGet200BodyLoadBalancerModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersIdGet200BodyLoadBalancerModel',
    );
    return LoadBalancersIdGet200BodyLoadBalancerModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'LoadBalancersIdGet200BodyLoadBalancerModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'LoadBalancersIdGet200BodyLoadBalancerModel.name',
      ),
      publicNet:
          _i4.LoadBalancersIdGet200BodyLoadBalancerPublicNetModel.fromJson(
            _$map[r'public_net'],
          ),
      privateNet: _$map[r'private_net']
          .decodeJsonList<_i3.Object?>(
            context: r'LoadBalancersIdGet200BodyLoadBalancerModel.private_net',
          )
          .map(
            _i5
                .LoadBalancersIdGet200BodyLoadBalancerPrivateNetArrayModel
                .fromJson,
          )
          .toList(),
      location: _i6.LoadBalancersIdGet200BodyLoadBalancerLocationModel.fromJson(
        _$map[r'location'],
      ),
      loadBalancerType:
          _i7.LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel.fromJson(
            _$map[r'load_balancer_type'],
          ),
      protection:
          _i8.LoadBalancersIdGet200BodyLoadBalancerProtectionModel.fromJson(
            _$map[r'protection'],
          ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context: r'LoadBalancersIdGet200BodyLoadBalancerModel.labels',
        ),
        context: r'LoadBalancersIdGet200BodyLoadBalancerModel.labels',
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'LoadBalancersIdGet200BodyLoadBalancerModel.created',
      ),
      services: _$map[r'services']
          .decodeJsonList<_i3.Object?>(
            context: r'LoadBalancersIdGet200BodyLoadBalancerModel.services',
          )
          .map(
            _i9
                .LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel
                .fromJson,
          )
          .toList(),
      targets: _$map[r'targets']
          .decodeJsonList<_i3.Object?>(
            context: r'LoadBalancersIdGet200BodyLoadBalancerModel.targets',
          )
          .map(
            _i10
                .LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfModel
                .fromJson,
          )
          .toList(),
      algorithm:
          _i11.LoadBalancersIdGet200BodyLoadBalancerAlgorithmModel.fromJson(
            _$map[r'algorithm'],
          ),
      outgoingTraffic: _$map[r'outgoing_traffic'].decodeJsonNullableInt(
        context: r'LoadBalancersIdGet200BodyLoadBalancerModel.outgoing_traffic',
      ),
      ingoingTraffic: _$map[r'ingoing_traffic'].decodeJsonNullableInt(
        context: r'LoadBalancersIdGet200BodyLoadBalancerModel.ingoing_traffic',
      ),
      includedTraffic: _$map[r'included_traffic'].decodeJsonInt(
        context: r'LoadBalancersIdGet200BodyLoadBalancerModel.included_traffic',
      ),
    );
  }

  factory LoadBalancersIdGet200BodyLoadBalancerModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancersIdGet200BodyLoadBalancerModel: contains complex types',
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
  final _i4.LoadBalancersIdGet200BodyLoadBalancerPublicNetModel publicNet;

  /// Private networks information.
  final _i3.List<_i5.LoadBalancersIdGet200BodyLoadBalancerPrivateNetArrayModel>
  privateNet;

  final _i6.LoadBalancersIdGet200BodyLoadBalancerLocationModel location;

  final _i7.LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel
  loadBalancerType;

  /// Protection configuration for the Resource.
  final _i8.LoadBalancersIdGet200BodyLoadBalancerProtectionModel protection;

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
    _i9.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel
  >
  services;

  /// List of targets that belong to this Load Balancer.
  final _i3.List<
    _i10.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfModel
  >
  targets;

  /// Algorithm of the Load Balancer.
  final _i11.LoadBalancersIdGet200BodyLoadBalancerAlgorithmModel algorithm;

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

  LoadBalancersIdGet200BodyLoadBalancerModel Function({
    _i3.int? id,
    _i3.String? name,
    _i4.LoadBalancersIdGet200BodyLoadBalancerPublicNetModel? publicNet,
    _i3.List<_i5.LoadBalancersIdGet200BodyLoadBalancerPrivateNetArrayModel>?
    privateNet,
    _i6.LoadBalancersIdGet200BodyLoadBalancerLocationModel? location,
    _i7.LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel?
    loadBalancerType,
    _i8.LoadBalancersIdGet200BodyLoadBalancerProtectionModel? protection,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i3.DateTime? created,
    _i3.List<_i9.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel>?
    services,
    _i3.List<_i10.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfModel>?
    targets,
    _i11.LoadBalancersIdGet200BodyLoadBalancerAlgorithmModel? algorithm,
    _i3.int? outgoingTraffic,
    _i3.int? ingoingTraffic,
    _i3.int? includedTraffic,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.String? name,
      _i4.LoadBalancersIdGet200BodyLoadBalancerPublicNetModel? publicNet,
      _i3.List<_i5.LoadBalancersIdGet200BodyLoadBalancerPrivateNetArrayModel>?
      privateNet,
      _i6.LoadBalancersIdGet200BodyLoadBalancerLocationModel? location,
      _i7.LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel?
      loadBalancerType,
      _i8.LoadBalancersIdGet200BodyLoadBalancerProtectionModel? protection,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i3.DateTime? created,
      _i3.List<
        _i9.LoadBalancersIdGet200BodyLoadBalancerServicesArrayOneOfModel
      >?
      services,
      _i3.List<
        _i10.LoadBalancersIdGet200BodyLoadBalancerTargetsArrayOneOfModel
      >?
      targets,
      _i11.LoadBalancersIdGet200BodyLoadBalancerAlgorithmModel? algorithm,
      _i3.Object? outgoingTraffic = _sentinel,
      _i3.Object? ingoingTraffic = _sentinel,
      _i3.int? includedTraffic,
    }) => LoadBalancersIdGet200BodyLoadBalancerModel(
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
    return other is LoadBalancersIdGet200BodyLoadBalancerModel &&
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
    r'parameterProperties not supported for LoadBalancersIdGet200BodyLoadBalancerModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i13.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersIdGet200BodyLoadBalancerModel: complex types cannot be URI-encoded',
    );
  }
}
