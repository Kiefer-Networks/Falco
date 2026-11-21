// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i11;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i10;
import 'package:hetzner_cloud_api/src/model/server_types_get200_body_server_types_array_architecture_model.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/model/server_types_get200_body_server_types_array_cpu_type_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/server_types_get200_body_server_types_array_deprecation_model.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/model/server_types_get200_body_server_types_array_locations_array_model.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/model/server_types_get200_body_server_types_array_prices_array_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/server_types_get200_body_server_types_array_storage_type_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServerTypesGet200BodyServerTypesArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServerTypesGet200BodyServerTypesArrayModel({
    required this.id,
    required this.name,
    required this.description,
    required this.cores,
    required this.memory,
    required this.disk,
    required this.prices,
    required this.storageType,
    required this.cpuType,
    required this.architecture,
    required this.locations,
    this.category,
    this.deprecation,
  });

  factory ServerTypesGet200BodyServerTypesArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServerTypesGet200BodyServerTypesArrayModel: contains complex types',
    );
  }

  factory ServerTypesGet200BodyServerTypesArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ServerTypesGet200BodyServerTypesArrayModel',
    );
    return ServerTypesGet200BodyServerTypesArrayModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'ServerTypesGet200BodyServerTypesArrayModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'ServerTypesGet200BodyServerTypesArrayModel.name',
      ),
      description: _$map[r'description'].decodeJsonString(
        context: r'ServerTypesGet200BodyServerTypesArrayModel.description',
      ),
      cores: _$map[r'cores'].decodeJsonNum(
        context: r'ServerTypesGet200BodyServerTypesArrayModel.cores',
      ),
      memory: _$map[r'memory'].decodeJsonNum(
        context: r'ServerTypesGet200BodyServerTypesArrayModel.memory',
      ),
      disk: _$map[r'disk'].decodeJsonNum(
        context: r'ServerTypesGet200BodyServerTypesArrayModel.disk',
      ),
      prices: _$map[r'prices']
          .decodeJsonList<_i3.Object?>(
            context: r'ServerTypesGet200BodyServerTypesArrayModel.prices',
          )
          .map(
            _i4.ServerTypesGet200BodyServerTypesArrayPricesArrayModel.fromJson,
          )
          .toList(),
      storageType:
          _i5.ServerTypesGet200BodyServerTypesArrayStorageTypeModel.fromJson(
            _$map[r'storage_type'],
          ),
      cpuType: _i6.ServerTypesGet200BodyServerTypesArrayCpuTypeModel.fromJson(
        _$map[r'cpu_type'],
      ),
      category: _$map[r'category'].decodeJsonNullableString(
        context: r'ServerTypesGet200BodyServerTypesArrayModel.category',
      ),
      architecture:
          _i7.ServerTypesGet200BodyServerTypesArrayArchitectureModel.fromJson(
            _$map[r'architecture'],
          ),
      deprecation: _$map[r'deprecation'] == null
          ? null
          : _i8.ServerTypesGet200BodyServerTypesArrayDeprecationModel.fromJson(
              _$map[r'deprecation'],
            ),
      locations: _$map[r'locations']
          .decodeJsonList<_i3.Object?>(
            context: r'ServerTypesGet200BodyServerTypesArrayModel.locations',
          )
          .map(
            _i9
                .ServerTypesGet200BodyServerTypesArrayLocationsArrayModel
                .fromJson,
          )
          .toList(),
    );
  }

  factory ServerTypesGet200BodyServerTypesArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServerTypesGet200BodyServerTypesArrayModel: contains complex types',
    );
  }

  /// ID of the Server type.
  ///
  /// **Example**:
  /// ```json
  /// 1
  /// ```
  final _i3.int id;

  /// Unique identifier of the Server type.
  ///
  /// **Example**:
  /// ```
  /// cpx22
  /// ```
  final _i3.String name;

  /// Description of the Server type.
  ///
  /// **Example**:
  /// ```
  /// CPX22
  /// ```
  final _i3.String description;

  /// Number of cpu cores a Server of this type will have.
  ///
  /// **Example**:
  /// ```json
  /// 2
  /// ```
  final _i3.num cores;

  /// Memory a Server of this type will have in GB.
  ///
  /// **Example**:
  /// ```json
  /// 4
  /// ```
  final _i3.num memory;

  /// Disk size a Server of this type will have in GB.
  ///
  /// **Example**:
  /// ```json
  /// 80
  /// ```
  final _i3.num disk;

  /// Price per [Location](#tag/locations).
  final _i3.List<_i4.ServerTypesGet200BodyServerTypesArrayPricesArrayModel>
  prices;

  /// Type of Server boot drive. Local has higher speed. Network has better availability.
  final _i5.ServerTypesGet200BodyServerTypesArrayStorageTypeModel storageType;

  /// Type of cpu.
  ///
  /// **Example**:
  /// ```
  /// shared
  /// ```
  final _i6.ServerTypesGet200BodyServerTypesArrayCpuTypeModel cpuType;

  /// Category of Server Type.
  ///
  /// **Example**:
  /// ```
  /// Shared vCPU
  /// ```
  final _i3.String? category;

  /// CPU architecture of the Server Type.
  ///
  ///
  /// **Example**:
  /// ```
  /// x86
  /// ```
  final _i7.ServerTypesGet200BodyServerTypesArrayArchitectureModel architecture;

  /// This field is deprecated.
  ///
  /// Use the `deprecation` object in the `locations` field instead (`.locations[].deprecation`).
  ///
  @_i3.Deprecated('This property is deprecated.')
  final _i8.ServerTypesGet200BodyServerTypesArrayDeprecationModel? deprecation;

  /// Supported [Location](#tag/locations) and per [Location](#tag/locations) details for the [Server Type](#tag/server-types).
  ///
  /// A [Server Type](#tag/server-types) is:
  ///  - only supported in the [Location](#tag/locations) that are listed.
  ///  - deprecated in the [Location](#tag/locations) when the `deprecation` property is set.
  ///  - permanently unavailable in the [Location](#tag/locations) when the `deprecation.unavailable_after` date is in the past.
  ///  - temporarily unavailable in the [Location](#tag/locations) when the `deprecation.available` is false.
  ///
  final _i3.List<_i9.ServerTypesGet200BodyServerTypesArrayLocationsArrayModel>
  locations;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'description': this.description,
    r'cores': this.cores,
    r'memory': this.memory,
    r'disk': this.disk,
    r'prices': this.prices.map((e) => e.toJson()).toList(),
    r'storage_type': this.storageType.toJson(),
    r'cpu_type': this.cpuType.toJson(),
    if (this.category != null) r'category': this.category,
    r'architecture': this.architecture.toJson(),
    r'deprecation': this.deprecation?.toJson(),
    r'locations': this.locations.map((e) => e.toJson()).toList(),
  };

  ServerTypesGet200BodyServerTypesArrayModel Function({
    _i3.int? id,
    _i3.String? name,
    _i3.String? description,
    _i3.num? cores,
    _i3.num? memory,
    _i3.num? disk,
    _i3.List<_i4.ServerTypesGet200BodyServerTypesArrayPricesArrayModel>? prices,
    _i5.ServerTypesGet200BodyServerTypesArrayStorageTypeModel? storageType,
    _i6.ServerTypesGet200BodyServerTypesArrayCpuTypeModel? cpuType,
    _i3.String? category,
    _i7.ServerTypesGet200BodyServerTypesArrayArchitectureModel? architecture,
    _i8.ServerTypesGet200BodyServerTypesArrayDeprecationModel? deprecation,
    _i3.List<_i9.ServerTypesGet200BodyServerTypesArrayLocationsArrayModel>?
    locations,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.String? name,
      _i3.String? description,
      _i3.num? cores,
      _i3.num? memory,
      _i3.num? disk,
      _i3.List<_i4.ServerTypesGet200BodyServerTypesArrayPricesArrayModel>?
      prices,
      _i5.ServerTypesGet200BodyServerTypesArrayStorageTypeModel? storageType,
      _i6.ServerTypesGet200BodyServerTypesArrayCpuTypeModel? cpuType,
      _i3.Object? category = _sentinel,
      _i7.ServerTypesGet200BodyServerTypesArrayArchitectureModel? architecture,
      _i3.Object? deprecation = _sentinel,
      _i3.List<_i9.ServerTypesGet200BodyServerTypesArrayLocationsArrayModel>?
      locations,
    }) => ServerTypesGet200BodyServerTypesArrayModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cores: cores ?? this.cores,
      memory: memory ?? this.memory,
      disk: disk ?? this.disk,
      prices: prices ?? this.prices,
      storageType: storageType ?? this.storageType,
      cpuType: cpuType ?? this.cpuType,
      category: _i3.identical(category, _sentinel)
          ? this.category
          : (category as _i3.String?),
      architecture: architecture ?? this.architecture,
      deprecation: _i3.identical(deprecation, _sentinel)
          ? this.deprecation
          : (deprecation
                as _i8.ServerTypesGet200BodyServerTypesArrayDeprecationModel?),
      locations: locations ?? this.locations,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i10.DeepCollectionEquality();
    return other is ServerTypesGet200BodyServerTypesArrayModel &&
        other.id == this.id &&
        other.name == this.name &&
        other.description == this.description &&
        other.cores == this.cores &&
        other.memory == this.memory &&
        other.disk == this.disk &&
        _$deepEquals.equals(other.prices, this.prices) &&
        other.storageType == this.storageType &&
        other.cpuType == this.cpuType &&
        other.category == this.category &&
        other.architecture == this.architecture &&
        other.deprecation == this.deprecation &&
        _$deepEquals.equals(other.locations, this.locations);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i10.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.name,
      this.description,
      this.cores,
      this.memory,
      this.disk,
      deepEquals.hash(this.prices),
      this.storageType,
      this.cpuType,
      this.category,
      this.architecture,
      this.deprecation,
      deepEquals.hash(this.locations),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServerTypesGet200BodyServerTypesArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i11.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServerTypesGet200BodyServerTypesArrayModel: complex types cannot be URI-encoded',
    );
  }
}
