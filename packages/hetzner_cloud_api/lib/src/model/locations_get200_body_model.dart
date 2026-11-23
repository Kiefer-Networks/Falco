// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:hetzner_cloud_api/src/model/locations_get200_body_locations_array_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/locations_get200_body_meta_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LocationsGet200BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LocationsGet200BodyModel({required this.locations, required this.meta});

  factory LocationsGet200BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LocationsGet200BodyModel: contains complex types',
    );
  }

  factory LocationsGet200BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'LocationsGet200BodyModel');
    return LocationsGet200BodyModel(
      locations: _$map[r'locations']
          .decodeJsonList<_i3.Object?>(
            context: r'LocationsGet200BodyModel.locations',
          )
          .map(_i4.LocationsGet200BodyLocationsArrayModel.fromJson)
          .toList(),
      meta: _i5.LocationsGet200BodyMetaModel.fromJson(_$map[r'meta']),
    );
  }

  factory LocationsGet200BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LocationsGet200BodyModel: contains complex types',
    );
  }

  /// List of [Locations](#tag/locations).
  final _i3.List<_i4.LocationsGet200BodyLocationsArrayModel> locations;

  final _i5.LocationsGet200BodyMetaModel meta;

  @_i3.override
  _i3.Object? toJson() => {
    r'locations': this.locations.map((e) => e.toJson()).toList(),
    r'meta': this.meta.toJson(),
  };

  LocationsGet200BodyModel Function({
    _i3.List<_i4.LocationsGet200BodyLocationsArrayModel>? locations,
    _i5.LocationsGet200BodyMetaModel? meta,
  })
  get copyWith {
    return ({
      _i3.List<_i4.LocationsGet200BodyLocationsArrayModel>? locations,
      _i5.LocationsGet200BodyMetaModel? meta,
    }) => LocationsGet200BodyModel(
      locations: locations ?? this.locations,
      meta: meta ?? this.meta,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is LocationsGet200BodyModel &&
        _$deepEquals.equals(other.locations, this.locations) &&
        other.meta == this.meta;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([deepEquals.hash(this.locations), this.meta]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for LocationsGet200BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LocationsGet200BodyModel: complex types cannot be URI-encoded',
    );
  }
}
