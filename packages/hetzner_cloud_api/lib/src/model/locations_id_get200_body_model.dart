// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/locations_id_get200_body_location_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class LocationsIdGet200BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const LocationsIdGet200BodyModel({required this.location});

  factory LocationsIdGet200BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for LocationsIdGet200BodyModel: contains complex types',
    );
  }

  factory LocationsIdGet200BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'LocationsIdGet200BodyModel');
    return LocationsIdGet200BodyModel(
      location: _i4.LocationsIdGet200BodyLocationModel.fromJson(
        _$map[r'location'],
      ),
    );
  }

  factory LocationsIdGet200BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for LocationsIdGet200BodyModel: contains complex types',
    );
  }

  final _i4.LocationsIdGet200BodyLocationModel location;

  @_i3.override
  _i3.Object? toJson() => {r'location': this.location.toJson()};

  LocationsIdGet200BodyModel Function({
    _i4.LocationsIdGet200BodyLocationModel? location,
  })
  get copyWith {
    return ({_i4.LocationsIdGet200BodyLocationModel? location}) =>
        LocationsIdGet200BodyModel(location: location ?? this.location);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is LocationsIdGet200BodyModel &&
        other.location == this.location;
  }

  @_i3.override
  _i3.int get hashCode => this.location.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for LocationsIdGet200BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode LocationsIdGet200BodyModel: complex types cannot be URI-encoded',
    );
  }
}
