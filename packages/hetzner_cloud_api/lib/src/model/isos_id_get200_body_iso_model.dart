// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/isos_id_get200_body_iso_architecture_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/isos_id_get200_body_iso_deprecation_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/isos_id_get200_body_iso_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class IsosIdGet200BodyIsoModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const IsosIdGet200BodyIsoModel({
    required this.id,
    required this.name,
    required this.description,
    required this.$type,
    required this.deprecation,
    required this.architecture,
  });

  factory IsosIdGet200BodyIsoModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for IsosIdGet200BodyIsoModel: contains complex types',
    );
  }

  factory IsosIdGet200BodyIsoModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'IsosIdGet200BodyIsoModel');
    return IsosIdGet200BodyIsoModel(
      id: _$map[r'id'].decodeJsonInt(context: r'IsosIdGet200BodyIsoModel.id'),
      name: _$map[r'name'].decodeJsonNullableString(
        context: r'IsosIdGet200BodyIsoModel.name',
      ),
      description: _$map[r'description'].decodeJsonString(
        context: r'IsosIdGet200BodyIsoModel.description',
      ),
      $type: _$map[r'type'] == null
          ? null
          : _i4.IsosIdGet200BodyIsoTypeModel.fromJson(_$map[r'type']),
      deprecation: _$map[r'deprecation'] == null
          ? null
          : _i5.IsosIdGet200BodyIsoDeprecationModel.fromJson(
              _$map[r'deprecation'],
            ),
      architecture: _$map[r'architecture'] == null
          ? null
          : _i6.IsosIdGet200BodyIsoArchitectureModel.fromJson(
              _$map[r'architecture'],
            ),
    );
  }

  factory IsosIdGet200BodyIsoModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for IsosIdGet200BodyIsoModel: contains complex types',
    );
  }

  /// ID of the [ISO](#tag/isos).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Unique identifier of the ISO. Only set for public ISOs.
  ///
  /// **Example**:
  /// ```
  /// FreeBSD-11.0-RELEASE-amd64-dvd1
  /// ```
  final _i3.String? name;

  /// Description of the ISO.
  ///
  /// **Example**:
  /// ```
  /// FreeBSD 11.0 x64
  /// ```
  final _i3.String description;

  /// Type of the ISO.
  final _i4.IsosIdGet200BodyIsoTypeModel? $type;

  /// Describes if, when and how the resource is deprecated. If this field is
  /// set to `null` the resource is not deprecated. If a value is set, it is
  /// considered deprecated.
  ///
  final _i5.IsosIdGet200BodyIsoDeprecationModel? deprecation;

  /// CPU architecture compatible with the ISO.
  ///
  /// Null indicates no restriction on the architecture (wildcard).
  ///
  ///
  /// **Example**:
  /// ```
  /// x86
  /// ```
  final _i6.IsosIdGet200BodyIsoArchitectureModel? architecture;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'description': this.description,
    r'type': this.$type?.toJson(),
    r'deprecation': this.deprecation?.toJson(),
    r'architecture': this.architecture?.toJson(),
  };

  IsosIdGet200BodyIsoModel Function({
    _i3.int? id,
    _i3.String? name,
    _i3.String? description,
    _i4.IsosIdGet200BodyIsoTypeModel? $type,
    _i5.IsosIdGet200BodyIsoDeprecationModel? deprecation,
    _i6.IsosIdGet200BodyIsoArchitectureModel? architecture,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.Object? name = _sentinel,
      _i3.String? description,
      _i3.Object? $type = _sentinel,
      _i3.Object? deprecation = _sentinel,
      _i3.Object? architecture = _sentinel,
    }) => IsosIdGet200BodyIsoModel(
      id: id ?? this.id,
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String?),
      description: description ?? this.description,
      $type: _i3.identical($type, _sentinel)
          ? this.$type
          : ($type as _i4.IsosIdGet200BodyIsoTypeModel?),
      deprecation: _i3.identical(deprecation, _sentinel)
          ? this.deprecation
          : (deprecation as _i5.IsosIdGet200BodyIsoDeprecationModel?),
      architecture: _i3.identical(architecture, _sentinel)
          ? this.architecture
          : (architecture as _i6.IsosIdGet200BodyIsoArchitectureModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is IsosIdGet200BodyIsoModel &&
        other.id == this.id &&
        other.name == this.name &&
        other.description == this.description &&
        other.$type == this.$type &&
        other.deprecation == this.deprecation &&
        other.architecture == this.architecture;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.id,
      this.name,
      this.description,
      this.$type,
      this.deprecation,
      this.architecture,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for IsosIdGet200BodyIsoModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode IsosIdGet200BodyIsoModel: complex types cannot be URI-encoded',
    );
  }
}
