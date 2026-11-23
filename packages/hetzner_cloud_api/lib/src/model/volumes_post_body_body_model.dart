// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/volumes_post_body_body_assignee_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class VolumesPostBodyBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const VolumesPostBodyBodyModel({
    required this.size,
    required this.name,
    this.labels,
    this.automount,
    this.format,
    this.location,
    this.server,
    this.assignee,
  });

  factory VolumesPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for VolumesPostBodyBodyModel: contains complex types',
    );
  }

  factory VolumesPostBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'VolumesPostBodyBodyModel');
    return VolumesPostBodyBodyModel(
      size: _$map[r'size'].decodeJsonInt(
        context: r'VolumesPostBodyBodyModel.size',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'VolumesPostBodyBodyModel.name',
      ),
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(context: r'VolumesPostBodyBodyModel.labels'),
        context: r'VolumesPostBodyBodyModel.labels',
      ),
      automount: _$map[r'automount'].decodeJsonNullableBool(
        context: r'VolumesPostBodyBodyModel.automount',
      ),
      format: _$map[r'format'].decodeJsonNullableString(
        context: r'VolumesPostBodyBodyModel.format',
      ),
      location: _$map[r'location'].decodeJsonNullableString(
        context: r'VolumesPostBodyBodyModel.location',
      ),
      server: _$map[r'server'].decodeJsonNullableInt(
        context: r'VolumesPostBodyBodyModel.server',
      ),
      assignee: _$map[r'assignee'] == null
          ? null
          : _i4.VolumesPostBodyBodyAssigneeModel.fromJson(_$map[r'assignee']),
    );
  }

  factory VolumesPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for VolumesPostBodyBodyModel: contains complex types',
    );
  }

  /// Size of the Volume in GB.
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int size;

  /// Name of the volume.
  ///
  /// **Example**:
  /// ```
  /// databases-storage
  /// ```
  final _i3.String name;

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

  /// Auto-mount Volume after attach. `server` must be provided.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool? automount;

  /// Format Volume after creation. One of: `xfs`, `ext4`.
  ///
  /// **Example**:
  /// ```
  /// xfs
  /// ```
  final _i3.String? format;

  /// Location to create the Volume in (can be omitted if Server is specified).
  ///
  /// **Example**:
  /// ```
  /// nbg1
  /// ```
  final _i3.String? location;

  /// This field is deprecated, use the `assignee` field with `server` as the `type` instead.
  ///
  /// Server to which to attach the Volume once it's created (Volume will be created in the same Location as the server).
  ///
  @_i3.Deprecated('This property is deprecated.')
  final _i3.int? server;

  /// Resource to which to attach the Volume once it's created (Volume will be created in the same Location as the resource).
  final _i4.VolumesPostBodyBodyAssigneeModel? assignee;

  @_i3.override
  _i3.Object? toJson() => {
    r'size': this.size,
    r'name': this.name,
    if (this.labels != null) r'labels': this.labels,
    if (this.automount != null) r'automount': this.automount,
    if (this.format != null) r'format': this.format,
    if (this.location != null) r'location': this.location,
    if (this.server != null) r'server': this.server,
    if (this.assignee != null) r'assignee': this.assignee?.toJson(),
  };

  VolumesPostBodyBodyModel Function({
    _i3.int? size,
    _i3.String? name,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i3.bool? automount,
    _i3.String? format,
    _i3.String? location,
    _i3.int? server,
    _i4.VolumesPostBodyBodyAssigneeModel? assignee,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? size,
      _i3.String? name,
      _i3.Object? labels = _sentinel,
      _i3.Object? automount = _sentinel,
      _i3.Object? format = _sentinel,
      _i3.Object? location = _sentinel,
      _i3.Object? server = _sentinel,
      _i3.Object? assignee = _sentinel,
    }) => VolumesPostBodyBodyModel(
      size: size ?? this.size,
      name: name ?? this.name,
      labels: _i3.identical(labels, _sentinel)
          ? this.labels
          : (labels as _i3.Map<_i3.String, _i3.String>?),
      automount: _i3.identical(automount, _sentinel)
          ? this.automount
          : (automount as _i3.bool?),
      format: _i3.identical(format, _sentinel)
          ? this.format
          : (format as _i3.String?),
      location: _i3.identical(location, _sentinel)
          ? this.location
          : (location as _i3.String?),
      server: _i3.identical(server, _sentinel)
          ? this.server
          : (server as _i3.int?),
      assignee: _i3.identical(assignee, _sentinel)
          ? this.assignee
          : (assignee as _i4.VolumesPostBodyBodyAssigneeModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is VolumesPostBodyBodyModel &&
        other.size == this.size &&
        other.name == this.name &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.automount == this.automount &&
        other.format == this.format &&
        other.location == this.location &&
        other.server == this.server &&
        other.assignee == this.assignee;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.size,
      this.name,
      deepEquals.hash(this.labels),
      this.automount,
      this.format,
      this.location,
      this.server,
      this.assignee,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for VolumesPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode VolumesPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
