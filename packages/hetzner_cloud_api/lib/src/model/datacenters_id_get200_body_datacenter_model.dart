// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/datacenters_id_get200_body_datacenter_location_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/datacenters_id_get200_body_datacenter_server_types_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class DatacentersIdGet200BodyDatacenterModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DatacentersIdGet200BodyDatacenterModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.serverTypes,
  });

  factory DatacentersIdGet200BodyDatacenterModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for DatacentersIdGet200BodyDatacenterModel: contains complex types',
    );
  }

  factory DatacentersIdGet200BodyDatacenterModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'DatacentersIdGet200BodyDatacenterModel',
    );
    return DatacentersIdGet200BodyDatacenterModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'DatacentersIdGet200BodyDatacenterModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'DatacentersIdGet200BodyDatacenterModel.name',
      ),
      description: _$map[r'description'].decodeJsonString(
        context: r'DatacentersIdGet200BodyDatacenterModel.description',
      ),
      location: _i4.DatacentersIdGet200BodyDatacenterLocationModel.fromJson(
        _$map[r'location'],
      ),
      serverTypes:
          _i5.DatacentersIdGet200BodyDatacenterServerTypesModel.fromJson(
            _$map[r'server_types'],
          ),
    );
  }

  factory DatacentersIdGet200BodyDatacenterModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for DatacentersIdGet200BodyDatacenterModel: contains complex types',
    );
  }

  /// ID of the [Data Center](#tag/data-centers).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Unique name for the [Data Center](#tag/data-centers).
  ///
  /// May be used as a more descriptive identifier.
  ///
  ///
  /// **Example**:
  /// ```
  /// fsn1-dc8
  /// ```
  final _i3.String name;

  /// Descriptive name for the [Data Center](#tag/data-centers).
  ///
  /// Desired to be easy to understand for humans. May change for cosmetic reasons. Must not be used as an identifier.
  ///
  ///
  /// **Example**:
  /// ```
  /// Falkenstein DC Park 8
  /// ```
  final _i3.String description;

  /// [Location](#tag/locations) the [Data Center](#tag/data-centers) is located at.
  ///
  final _i4.DatacentersIdGet200BodyDatacenterLocationModel location;

  /// This field is deprecated, as all of it's properties are deprecated.
  ///
  /// [Server Types](#tag/server-types) supported and available in this [Data Center](#tag/data-centers).
  ///
  @_i3.Deprecated('This property is deprecated.')
  final _i5.DatacentersIdGet200BodyDatacenterServerTypesModel serverTypes;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'description': this.description,
    r'location': this.location.toJson(),
    r'server_types': this.serverTypes.toJson(),
  };

  DatacentersIdGet200BodyDatacenterModel Function({
    _i3.int? id,
    _i3.String? name,
    _i3.String? description,
    _i4.DatacentersIdGet200BodyDatacenterLocationModel? location,
    _i5.DatacentersIdGet200BodyDatacenterServerTypesModel? serverTypes,
  })
  get copyWith {
    return ({
      _i3.int? id,
      _i3.String? name,
      _i3.String? description,
      _i4.DatacentersIdGet200BodyDatacenterLocationModel? location,
      _i5.DatacentersIdGet200BodyDatacenterServerTypesModel? serverTypes,
    }) => DatacentersIdGet200BodyDatacenterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      serverTypes: serverTypes ?? this.serverTypes,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DatacentersIdGet200BodyDatacenterModel &&
        other.id == this.id &&
        other.name == this.name &&
        other.description == this.description &&
        other.location == this.location &&
        other.serverTypes == this.serverTypes;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.id,
      this.name,
      this.description,
      this.location,
      this.serverTypes,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for DatacentersIdGet200BodyDatacenterModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DatacentersIdGet200BodyDatacenterModel: complex types cannot be URI-encoded',
    );
  }
}
