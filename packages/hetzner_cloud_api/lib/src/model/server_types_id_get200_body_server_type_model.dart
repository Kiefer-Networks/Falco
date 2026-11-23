// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i11;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i10;
import 'package:hetzner_cloud_api/src/model/server_types_id_get200_body_server_type_architecture_model.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/model/server_types_id_get200_body_server_type_cpu_type_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/server_types_id_get200_body_server_type_deprecation_model.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/model/server_types_id_get200_body_server_type_locations_array_model.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/model/server_types_id_get200_body_server_type_prices_array_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/server_types_id_get200_body_server_type_storage_type_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServerTypesIdGet200BodyServerTypeModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServerTypesIdGet200BodyServerTypeModel({
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

  factory ServerTypesIdGet200BodyServerTypeModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServerTypesIdGet200BodyServerTypeModel: contains complex types',
    );
  }

  factory ServerTypesIdGet200BodyServerTypeModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'ServerTypesIdGet200BodyServerTypeModel',
    );
    return ServerTypesIdGet200BodyServerTypeModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'ServerTypesIdGet200BodyServerTypeModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'ServerTypesIdGet200BodyServerTypeModel.name',
      ),
      description: _$map[r'description'].decodeJsonString(
        context: r'ServerTypesIdGet200BodyServerTypeModel.description',
      ),
      cores: _$map[r'cores'].decodeJsonNum(
        context: r'ServerTypesIdGet200BodyServerTypeModel.cores',
      ),
      memory: _$map[r'memory'].decodeJsonNum(
        context: r'ServerTypesIdGet200BodyServerTypeModel.memory',
      ),
      disk: _$map[r'disk'].decodeJsonNum(
        context: r'ServerTypesIdGet200BodyServerTypeModel.disk',
      ),
      prices: _$map[r'prices']
          .decodeJsonList<_i3.Object?>(
            context: r'ServerTypesIdGet200BodyServerTypeModel.prices',
          )
          .map(_i4.ServerTypesIdGet200BodyServerTypePricesArrayModel.fromJson)
          .toList(),
      storageType:
          _i5.ServerTypesIdGet200BodyServerTypeStorageTypeModel.fromJson(
            _$map[r'storage_type'],
          ),
      cpuType: _i6.ServerTypesIdGet200BodyServerTypeCpuTypeModel.fromJson(
        _$map[r'cpu_type'],
      ),
      category: _$map[r'category'].decodeJsonNullableString(
        context: r'ServerTypesIdGet200BodyServerTypeModel.category',
      ),
      architecture:
          _i7.ServerTypesIdGet200BodyServerTypeArchitectureModel.fromJson(
            _$map[r'architecture'],
          ),
      deprecation: _$map[r'deprecation'] == null
          ? null
          : _i8.ServerTypesIdGet200BodyServerTypeDeprecationModel.fromJson(
              _$map[r'deprecation'],
            ),
      locations: _$map[r'locations']
          .decodeJsonList<_i3.Object?>(
            context: r'ServerTypesIdGet200BodyServerTypeModel.locations',
          )
          .map(
            _i9.ServerTypesIdGet200BodyServerTypeLocationsArrayModel.fromJson,
          )
          .toList(),
    );
  }

  factory ServerTypesIdGet200BodyServerTypeModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServerTypesIdGet200BodyServerTypeModel: contains complex types',
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
  final _i3.List<_i4.ServerTypesIdGet200BodyServerTypePricesArrayModel> prices;

  /// Type of Server boot drive. Local has higher speed. Network has better availability.
  final _i5.ServerTypesIdGet200BodyServerTypeStorageTypeModel storageType;

  /// Type of cpu.
  ///
  /// **Example**:
  /// ```
  /// shared
  /// ```
  final _i6.ServerTypesIdGet200BodyServerTypeCpuTypeModel cpuType;

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
  final _i7.ServerTypesIdGet200BodyServerTypeArchitectureModel architecture;

  /// This field is deprecated.
  ///
  /// Use the `deprecation` object in the `locations` field instead (`.locations[].deprecation`).
  ///
  @_i3.Deprecated('This property is deprecated.')
  final _i8.ServerTypesIdGet200BodyServerTypeDeprecationModel? deprecation;

  /// Supported [Location](#tag/locations) and per [Location](#tag/locations) details for the [Server Type](#tag/server-types).
  ///
  /// A [Server Type](#tag/server-types) is:
  ///  - only supported in the [Location](#tag/locations) that are listed.
  ///  - deprecated in the [Location](#tag/locations) when the `deprecation` property is set.
  ///  - permanently unavailable in the [Location](#tag/locations) when the `deprecation.unavailable_after` date is in the past.
  ///  - temporarily unavailable in the [Location](#tag/locations) when the `deprecation.available` is false.
  ///
  final _i3.List<_i9.ServerTypesIdGet200BodyServerTypeLocationsArrayModel>
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

  ServerTypesIdGet200BodyServerTypeModel Function({
    _i3.int? id,
    _i3.String? name,
    _i3.String? description,
    _i3.num? cores,
    _i3.num? memory,
    _i3.num? disk,
    _i3.List<_i4.ServerTypesIdGet200BodyServerTypePricesArrayModel>? prices,
    _i5.ServerTypesIdGet200BodyServerTypeStorageTypeModel? storageType,
    _i6.ServerTypesIdGet200BodyServerTypeCpuTypeModel? cpuType,
    _i3.String? category,
    _i7.ServerTypesIdGet200BodyServerTypeArchitectureModel? architecture,
    _i8.ServerTypesIdGet200BodyServerTypeDeprecationModel? deprecation,
    _i3.List<_i9.ServerTypesIdGet200BodyServerTypeLocationsArrayModel>?
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
      _i3.List<_i4.ServerTypesIdGet200BodyServerTypePricesArrayModel>? prices,
      _i5.ServerTypesIdGet200BodyServerTypeStorageTypeModel? storageType,
      _i6.ServerTypesIdGet200BodyServerTypeCpuTypeModel? cpuType,
      _i3.Object? category = _sentinel,
      _i7.ServerTypesIdGet200BodyServerTypeArchitectureModel? architecture,
      _i3.Object? deprecation = _sentinel,
      _i3.List<_i9.ServerTypesIdGet200BodyServerTypeLocationsArrayModel>?
      locations,
    }) => ServerTypesIdGet200BodyServerTypeModel(
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
                as _i8.ServerTypesIdGet200BodyServerTypeDeprecationModel?),
      locations: locations ?? this.locations,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i10.DeepCollectionEquality();
    return other is ServerTypesIdGet200BodyServerTypeModel &&
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
    r'parameterProperties not supported for ServerTypesIdGet200BodyServerTypeModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i11.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServerTypesIdGet200BodyServerTypeModel: complex types cannot be URI-encoded',
    );
  }
}
