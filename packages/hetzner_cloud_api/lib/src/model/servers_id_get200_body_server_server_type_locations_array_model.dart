// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_get200_body_server_server_type_locations_array_deprecation_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// A [Location](#tag/locations) (containing only id and name) and Server Type specific metadata.
///
@_i2.immutable
class ServersIdGet200BodyServerServerTypeLocationsArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdGet200BodyServerServerTypeLocationsArrayModel({
    required this.id,
    required this.name,
    required this.deprecation,
    required this.recommended,
    required this.available,
  });

  factory ServersIdGet200BodyServerServerTypeLocationsArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServersIdGet200BodyServerServerTypeLocationsArrayModel: contains complex types',
    );
  }

  factory ServersIdGet200BodyServerServerTypeLocationsArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ServersIdGet200BodyServerServerTypeLocationsArrayModel',
    );
    return ServersIdGet200BodyServerServerTypeLocationsArrayModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'ServersIdGet200BodyServerServerTypeLocationsArrayModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'ServersIdGet200BodyServerServerTypeLocationsArrayModel.name',
      ),
      deprecation: _$map[r'deprecation'] == null
          ? null
          : _i4.ServersIdGet200BodyServerServerTypeLocationsArrayDeprecationModel.fromJson(
              _$map[r'deprecation'],
            ),
      recommended: _$map[r'recommended'].decodeJsonBool(
        context: r'ServersIdGet200BodyServerServerTypeLocationsArrayModel.recommended',
      ),
      available: _$map[r'available'].decodeJsonBool(
        context:
            r'ServersIdGet200BodyServerServerTypeLocationsArrayModel.available',
      ),
    );
  }

  factory ServersIdGet200BodyServerServerTypeLocationsArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServersIdGet200BodyServerServerTypeLocationsArrayModel: contains complex types',
    );
  }

  /// ID of the [Location](#tag/locations).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Name of the [Location](#tag/locations).
  ///
  /// **Example**:
  /// ```
  /// fsn1
  /// ```
  final _i3.String name;

  /// Describes if, when and how the resource is deprecated. If this field is
  /// set to `null` the resource is not deprecated. If a value is set, it is
  /// considered deprecated.
  ///
  final _i4.ServersIdGet200BodyServerServerTypeLocationsArrayDeprecationModel?
  deprecation;

  /// Whether the [Server Type](#tag/server-types) is recommended in this [Location](#tag/locations).
  ///
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool recommended;

  /// Whether the [Server Type](#tag/server-types) is temporarily unavailable in this [Location](#tag/locations).
  ///
  ///
  /// **Example**:
  /// ```json
  /// true
  /// ```
  final _i3.bool available;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'deprecation': this.deprecation?.toJson(),
    r'recommended': this.recommended,
    r'available': this.available,
  };

  ServersIdGet200BodyServerServerTypeLocationsArrayModel Function({
    _i3.int? id,
    _i3.String? name,
    _i4.ServersIdGet200BodyServerServerTypeLocationsArrayDeprecationModel?
    deprecation,
    _i3.bool? recommended,
    _i3.bool? available,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.String? name,
      _i3.Object? deprecation = _sentinel,
      _i3.bool? recommended,
      _i3.bool? available,
    }) => ServersIdGet200BodyServerServerTypeLocationsArrayModel(
      id: id ?? this.id,
      name: name ?? this.name,
      deprecation: _i3.identical(deprecation, _sentinel)
          ? this.deprecation
          : (deprecation
                as _i4.ServersIdGet200BodyServerServerTypeLocationsArrayDeprecationModel?),
      recommended: recommended ?? this.recommended,
      available: available ?? this.available,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersIdGet200BodyServerServerTypeLocationsArrayModel &&
        other.id == this.id &&
        other.name == this.name &&
        other.deprecation == this.deprecation &&
        other.recommended == this.recommended &&
        other.available == this.available;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.id,
      this.name,
      this.deprecation,
      this.recommended,
      this.available,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServersIdGet200BodyServerServerTypeLocationsArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServersIdGet200BodyServerServerTypeLocationsArrayModel: complex types cannot be URI-encoded',
    );
  }
}
