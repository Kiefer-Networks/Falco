// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:hetzner_cloud_api/src/model/floating_ips_post_body_body_home_location_one_of_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/floating_ips_post_body_body_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FloatingIpsPostBodyBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FloatingIpsPostBodyBodyModel({
    required this.$type,
    this.server,
    this.homeLocation,
    this.description,
    this.name,
    this.labels,
  });

  factory FloatingIpsPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for FloatingIpsPostBodyBodyModel: contains complex types',
    );
  }

  factory FloatingIpsPostBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'FloatingIpsPostBodyBodyModel');
    return FloatingIpsPostBodyBodyModel(
      $type: _i4.FloatingIpsPostBodyBodyTypeModel.fromJson(_$map[r'type']),
      server: _$map[r'server'].decodeJsonNullableInt(
        context: r'FloatingIpsPostBodyBodyModel.server',
      ),
      homeLocation: _$map[r'home_location'] == null
          ? null
          : _i5.FloatingIpsPostBodyBodyHomeLocationOneOfModel.fromJson(
              _$map[r'home_location'],
            ),
      description: _$map[r'description'].decodeJsonNullableString(
        context: r'FloatingIpsPostBodyBodyModel.description',
      ),
      name: _$map[r'name'].decodeJsonNullableString(
        context: r'FloatingIpsPostBodyBodyModel.name',
      ),
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) =>
            v.decodeJsonString(context: r'FloatingIpsPostBodyBodyModel.labels'),
        context: r'FloatingIpsPostBodyBodyModel.labels',
      ),
    );
  }

  factory FloatingIpsPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for FloatingIpsPostBodyBodyModel: contains complex types',
    );
  }

  /// The Floating IP type.
  ///
  /// **Example**:
  /// ```
  /// ipv6
  /// ```
  final _i4.FloatingIpsPostBodyBodyTypeModel $type;

  /// [Server](#tag/servers) the [Floating IP](#tag/floating-ips) is assigned to.
  ///
  /// `null` if not assigned.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int? server;

  /// Home [Location](#tag/locations) for the [Floating IP](#tag/floating-ips).
  ///
  /// Either the ID or the name of the [Location](#tag/locations).
  ///
  /// Only optional if no [Server](#tag/servers) is provided. Routing is optimized for this [Locations](#tag/locations).
  ///
  final _i5.FloatingIpsPostBodyBodyHomeLocationOneOfModel? homeLocation;

  /// Description of the Resource.
  ///
  /// **Example**:
  /// ```
  /// This describes my resource
  /// ```
  final _i3.String? description;

  /// Name of the Resource. Must be unique per Project.
  ///
  /// A name will be generated if none is given.
  ///
  ///
  /// **Example**:
  /// ```
  /// my-resource
  /// ```
  final _i3.String? name;

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
  final _i3.Map<_i3.String, _i3.String>? labels;

  @_i3.override
  _i3.Object? toJson() => {
    r'type': this.$type.toJson(),
    r'server': this.server,
    if (this.homeLocation != null)
      r'home_location': this.homeLocation?.toJson(),
    r'description': this.description,
    if (this.name != null) r'name': this.name,
    if (this.labels != null) r'labels': this.labels,
  };

  FloatingIpsPostBodyBodyModel Function({
    _i4.FloatingIpsPostBodyBodyTypeModel? $type,
    _i3.int? server,
    _i5.FloatingIpsPostBodyBodyHomeLocationOneOfModel? homeLocation,
    _i3.String? description,
    _i3.String? name,
    _i3.Map<_i3.String, _i3.String>? labels,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i4.FloatingIpsPostBodyBodyTypeModel? $type,
      _i3.Object? server = _sentinel,
      _i3.Object? homeLocation = _sentinel,
      _i3.Object? description = _sentinel,
      _i3.Object? name = _sentinel,
      _i3.Object? labels = _sentinel,
    }) => FloatingIpsPostBodyBodyModel(
      $type: $type ?? this.$type,
      server: _i3.identical(server, _sentinel)
          ? this.server
          : (server as _i3.int?),
      homeLocation: _i3.identical(homeLocation, _sentinel)
          ? this.homeLocation
          : (homeLocation
                as _i5.FloatingIpsPostBodyBodyHomeLocationOneOfModel?),
      description: _i3.identical(description, _sentinel)
          ? this.description
          : (description as _i3.String?),
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String?),
      labels: _i3.identical(labels, _sentinel)
          ? this.labels
          : (labels as _i3.Map<_i3.String, _i3.String>?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is FloatingIpsPostBodyBodyModel &&
        other.$type == this.$type &&
        other.server == this.server &&
        other.homeLocation == this.homeLocation &&
        other.description == this.description &&
        other.name == this.name &&
        _$deepEquals.equals(other.labels, this.labels);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.$type,
      this.server,
      this.homeLocation,
      this.description,
      this.name,
      deepEquals.hash(this.labels),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for FloatingIpsPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FloatingIpsPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
