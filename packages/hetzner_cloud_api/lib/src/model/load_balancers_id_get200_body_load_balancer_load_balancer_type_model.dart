// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_load_balancer_type_deprecation_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/load_balancers_id_get200_body_load_balancer_load_balancer_type_prices_array_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.maxConnections,
    required this.maxServices,
    required this.maxTargets,
    required this.maxAssignedCertificates,
    required this.deprecation,
    required this.prices,
  });

  factory LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel: contains complex types',
    );
  }

  factory LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel',
    );
    return LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel(
      id: _$map[r'id'].decodeJsonInt(
        context:
            r'LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context:
            r'LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel.name',
      ),
      description: _$map[r'description'].decodeJsonString(
        context: r'LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel.description',
      ),
      maxConnections: _$map[r'max_connections'].decodeJsonInt(
        context: r'LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel.max_connections',
      ),
      maxServices: _$map[r'max_services'].decodeJsonInt(
        context: r'LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel.max_services',
      ),
      maxTargets: _$map[r'max_targets'].decodeJsonInt(
        context: r'LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel.max_targets',
      ),
      maxAssignedCertificates: _$map[r'max_assigned_certificates']
          .decodeJsonInt(
            context: r'LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel.max_assigned_certificates',
          ),
      deprecation: _$map[r'deprecation'] == null
          ? null
          : _i4.LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeDeprecationModel.fromJson(
              _$map[r'deprecation'],
            ),
      prices: _$map[r'prices']
          .decodeJsonList<_i3.Object?>(
            context: r'LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel.prices',
          )
          .map(
            _i5
                .LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypePricesArrayModel
                .fromJson,
          )
          .toList(),
    );
  }

  factory LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel: contains complex types',
    );
  }

  /// ID of the Load Balancer type.
  ///
  /// **Example**:
  /// ```json
  /// 1
  /// ```
  final _i3.int id;

  /// Unique identifier of the Load Balancer type.
  ///
  /// **Example**:
  /// ```
  /// lb11
  /// ```
  final _i3.String name;

  /// Description of the Load Balancer type.
  ///
  /// **Example**:
  /// ```
  /// LB11
  /// ```
  final _i3.String description;

  /// Number of maximum simultaneous open connections.
  ///
  /// **Example**:
  /// ```json
  /// 20000
  /// ```
  final _i3.int maxConnections;

  /// Number of services a Load Balancer of this type can have.
  ///
  /// **Example**:
  /// ```json
  /// 5
  /// ```
  final _i3.int maxServices;

  /// Number of targets a single Load Balancer can have.
  ///
  /// **Example**:
  /// ```json
  /// 25
  /// ```
  final _i3.int maxTargets;

  /// Number of SSL Certificates that can be assigned to a single Load Balancer.
  ///
  /// **Example**:
  /// ```json
  /// 10
  /// ```
  final _i3.int maxAssignedCertificates;

  /// Describes if, when and how the resource is deprecated. If this field is
  /// set to `null` the resource is not deprecated. If a value is set, it is
  /// considered deprecated.
  ///
  final _i4.LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeDeprecationModel?
  deprecation;

  /// Price per [Location](#tag/locations).
  final _i3.List<
    _i5.LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypePricesArrayModel
  >
  prices;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'description': this.description,
    r'max_connections': this.maxConnections,
    r'max_services': this.maxServices,
    r'max_targets': this.maxTargets,
    r'max_assigned_certificates': this.maxAssignedCertificates,
    r'deprecation': this.deprecation?.toJson(),
    r'prices': this.prices.map((e) => e.toJson()).toList(),
  };

  LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel Function({
    _i3.int? id,
    _i3.String? name,
    _i3.String? description,
    _i3.int? maxConnections,
    _i3.int? maxServices,
    _i3.int? maxTargets,
    _i3.int? maxAssignedCertificates,
    _i4.LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeDeprecationModel?
    deprecation,
    _i3.List<
      _i5.LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypePricesArrayModel
    >?
    prices,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.String? name,
      _i3.String? description,
      _i3.int? maxConnections,
      _i3.int? maxServices,
      _i3.int? maxTargets,
      _i3.int? maxAssignedCertificates,
      _i3.Object? deprecation = _sentinel,
      _i3.List<
        _i5.LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypePricesArrayModel
      >?
      prices,
    }) => LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      maxConnections: maxConnections ?? this.maxConnections,
      maxServices: maxServices ?? this.maxServices,
      maxTargets: maxTargets ?? this.maxTargets,
      maxAssignedCertificates:
          maxAssignedCertificates ?? this.maxAssignedCertificates,
      deprecation: _i3.identical(deprecation, _sentinel)
          ? this.deprecation
          : (deprecation
                as _i4.LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeDeprecationModel?),
      prices: prices ?? this.prices,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other
            is LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel &&
        other.id == this.id &&
        other.name == this.name &&
        other.description == this.description &&
        other.maxConnections == this.maxConnections &&
        other.maxServices == this.maxServices &&
        other.maxTargets == this.maxTargets &&
        other.maxAssignedCertificates == this.maxAssignedCertificates &&
        other.deprecation == this.deprecation &&
        _$deepEquals.equals(other.prices, this.prices);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.name,
      this.description,
      this.maxConnections,
      this.maxServices,
      this.maxTargets,
      this.maxAssignedCertificates,
      this.deprecation,
      deepEquals.hash(this.prices),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LoadBalancersIdGet200BodyLoadBalancerLoadBalancerTypeModel: complex types cannot be URI-encoded',
    );
  }
}
