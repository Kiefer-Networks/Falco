// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Location of the [Storage Box](#tag/storage-boxes).
@_i2.immutable
class StorageBoxesIdGet200BodyStorageBoxLocationModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const StorageBoxesIdGet200BodyStorageBoxLocationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.country,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.networkZone,
  });

  factory StorageBoxesIdGet200BodyStorageBoxLocationModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'id',
        r'name',
        r'description',
        r'country',
        r'city',
        r'latitude',
        r'longitude',
        r'network_zone',
      },
      listKeys: {},
      context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return StorageBoxesIdGet200BodyStorageBoxLocationModel(
      id: _$values[r'id'].decodeSimpleInt(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.id',
      ),
      name: _$values[r'name'].decodeSimpleString(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.name',
      ),
      description: _$values[r'description'].decodeSimpleString(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.description',
      ),
      country: _$values[r'country'].decodeSimpleString(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.country',
      ),
      city: _$values[r'city'].decodeSimpleString(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.city',
      ),
      latitude: _$values[r'latitude'].decodeSimpleDouble(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.latitude',
      ),
      longitude: _$values[r'longitude'].decodeSimpleDouble(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.longitude',
      ),
      networkZone: _$values[r'network_zone'].decodeSimpleString(
        context:
            r'StorageBoxesIdGet200BodyStorageBoxLocationModel.network_zone',
      ),
    );
  }

  factory StorageBoxesIdGet200BodyStorageBoxLocationModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel',
    );
    return StorageBoxesIdGet200BodyStorageBoxLocationModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.name',
      ),
      description: _$map[r'description'].decodeJsonString(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.description',
      ),
      country: _$map[r'country'].decodeJsonString(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.country',
      ),
      city: _$map[r'city'].decodeJsonString(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.city',
      ),
      latitude: _$map[r'latitude'].decodeJsonDouble(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.latitude',
      ),
      longitude: _$map[r'longitude'].decodeJsonDouble(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.longitude',
      ),
      networkZone: _$map[r'network_zone'].decodeJsonString(
        context:
            r'StorageBoxesIdGet200BodyStorageBoxLocationModel.network_zone',
      ),
    );
  }

  factory StorageBoxesIdGet200BodyStorageBoxLocationModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'id',
        r'name',
        r'description',
        r'country',
        r'city',
        r'latitude',
        r'longitude',
        r'network_zone',
      },
      listKeys: {},
      context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel',
    );
    return StorageBoxesIdGet200BodyStorageBoxLocationModel(
      id: _$values[r'id'].decodeFormInt(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.id',
      ),
      name: _$values[r'name'].decodeFormString(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.name',
      ),
      description: _$values[r'description'].decodeFormString(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.description',
      ),
      country: _$values[r'country'].decodeFormString(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.country',
      ),
      city: _$values[r'city'].decodeFormString(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.city',
      ),
      latitude: _$values[r'latitude'].decodeFormDouble(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.latitude',
      ),
      longitude: _$values[r'longitude'].decodeFormDouble(
        context: r'StorageBoxesIdGet200BodyStorageBoxLocationModel.longitude',
      ),
      networkZone: _$values[r'network_zone'].decodeFormString(
        context:
            r'StorageBoxesIdGet200BodyStorageBoxLocationModel.network_zone',
      ),
    );
  }

  /// ID of the [Location](#tag/locations).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Unique identifier of the [Location](#tag/locations).
  ///
  /// **Example**:
  /// ```
  /// fsn1
  /// ```
  final _i3.String name;

  /// Human readable description of the [Location](#tag/locations).
  ///
  /// **Example**:
  /// ```
  /// Falkenstein DC Park 1
  /// ```
  final _i3.String description;

  /// Country the [Location](#tag/locations) resides in.
  ///
  /// ISO 3166-1 alpha-2 code of the country.
  ///
  ///
  /// **Example**:
  /// ```
  /// DE
  /// ```
  final _i3.String country;

  /// Name of the closest city to the [Location](#tag/locations).
  ///
  /// City name or city name and state in short form. E.g. `Falkenstein` or `Ashburn, VA`.
  ///
  ///
  /// **Example**:
  /// ```
  /// Falkenstein
  /// ```
  final _i3.String city;

  /// Latitude of the city closest to the [Location](#tag/locations).
  ///
  /// **Example**:
  /// ```json
  /// 50.47612
  /// ```
  final _i3.double latitude;

  /// Longitude of the city closest to the [Location](#tag/locations).
  ///
  /// **Example**:
  /// ```json
  /// 12.370071
  /// ```
  final _i3.double longitude;

  /// Name of the Network Zone this [Location](#tag/locations) resides in.
  ///
  /// **Example**:
  /// ```
  /// eu-central
  /// ```
  final _i3.String networkZone;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'description': this.description,
    r'country': this.country,
    r'city': this.city,
    r'latitude': this.latitude,
    r'longitude': this.longitude,
    r'network_zone': this.networkZone,
  };

  StorageBoxesIdGet200BodyStorageBoxLocationModel Function({
    _i3.int? id,
    _i3.String? name,
    _i3.String? description,
    _i3.String? country,
    _i3.String? city,
    _i3.double? latitude,
    _i3.double? longitude,
    _i3.String? networkZone,
  })
  get copyWith {
    return ({
      _i3.int? id,
      _i3.String? name,
      _i3.String? description,
      _i3.String? country,
      _i3.String? city,
      _i3.double? latitude,
      _i3.double? longitude,
      _i3.String? networkZone,
    }) => StorageBoxesIdGet200BodyStorageBoxLocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      country: country ?? this.country,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      networkZone: networkZone ?? this.networkZone,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is StorageBoxesIdGet200BodyStorageBoxLocationModel &&
        other.id == this.id &&
        other.name == this.name &&
        other.description == this.description &&
        other.country == this.country &&
        other.city == this.city &&
        other.latitude == this.latitude &&
        other.longitude == this.longitude &&
        other.networkZone == this.networkZone;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.id,
      this.name,
      this.description,
      this.country,
      this.city,
      this.latitude,
      this.longitude,
      this.networkZone,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'id'] = _i1.PropertyValue.scalar(this.id.toString());
    _$result[r'name'] = _i1.PropertyValue.scalar(this.name);
    _$result[r'description'] = _i1.PropertyValue.scalar(this.description);
    _$result[r'country'] = _i1.PropertyValue.scalar(this.country);
    _$result[r'city'] = _i1.PropertyValue.scalar(this.city);
    _$result[r'latitude'] = _i1.PropertyValue.scalar(this.latitude.toString());
    _$result[r'longitude'] = _i1.PropertyValue.scalar(
      this.longitude.toString(),
    );
    _$result[r'network_zone'] = _i1.PropertyValue.scalar(this.networkZone);
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode StorageBoxesIdGet200BodyStorageBoxLocationModel: complex types cannot be URI-encoded',
    );
  }
}
