// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i9;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i8;
import 'package:hetzner_cloud_api/src/model/volumes_get200_body_volumes_array_assignee_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/volumes_get200_body_volumes_array_location_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/volumes_get200_body_volumes_array_protection_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/volumes_get200_body_volumes_array_status_model.dart'
    as _i7;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class VolumesGet200BodyVolumesArrayModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const VolumesGet200BodyVolumesArrayModel({
    required this.id,
    required this.created,
    required this.name,
    required this.server,
    required this.assignee,
    required this.location,
    required this.size,
    required this.linuxDevice,
    required this.protection,
    required this.labels,
    required this.status,
    required this.format,
  });

  factory VolumesGet200BodyVolumesArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for VolumesGet200BodyVolumesArrayModel: contains complex types',
    );
  }

  factory VolumesGet200BodyVolumesArrayModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'VolumesGet200BodyVolumesArrayModel',
    );
    return VolumesGet200BodyVolumesArrayModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'VolumesGet200BodyVolumesArrayModel.id',
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'VolumesGet200BodyVolumesArrayModel.created',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'VolumesGet200BodyVolumesArrayModel.name',
      ),
      server: _$map[r'server'].decodeJsonNullableInt(
        context: r'VolumesGet200BodyVolumesArrayModel.server',
      ),
      assignee: _$map[r'assignee'] == null
          ? null
          : _i4.VolumesGet200BodyVolumesArrayAssigneeModel.fromJson(
              _$map[r'assignee'],
            ),
      location: _i5.VolumesGet200BodyVolumesArrayLocationModel.fromJson(
        _$map[r'location'],
      ),
      size: _$map[r'size'].decodeJsonNum(
        context: r'VolumesGet200BodyVolumesArrayModel.size',
      ),
      linuxDevice: _$map[r'linux_device'].decodeJsonString(
        context: r'VolumesGet200BodyVolumesArrayModel.linux_device',
      ),
      protection: _i6.VolumesGet200BodyVolumesArrayProtectionModel.fromJson(
        _$map[r'protection'],
      ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context: r'VolumesGet200BodyVolumesArrayModel.labels',
        ),
        context: r'VolumesGet200BodyVolumesArrayModel.labels',
      ),
      status: _i7.VolumesGet200BodyVolumesArrayStatusModel.fromJson(
        _$map[r'status'],
      ),
      format: _$map[r'format'].decodeJsonNullableString(
        context: r'VolumesGet200BodyVolumesArrayModel.format',
      ),
    );
  }

  factory VolumesGet200BodyVolumesArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for VolumesGet200BodyVolumesArrayModel: contains complex types',
    );
  }

  /// ID of the [Volume](#tag/volumes).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Point in time when the Resource was created (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  /// **Example**:
  /// ```
  /// 2016-01-30T23:55:00Z
  /// ```
  final _i3.DateTime created;

  /// Name of the Resource. Must be unique per Project.
  ///
  /// **Example**:
  /// ```
  /// my-resource
  /// ```
  final _i3.String name;

  /// This field is deprecated, use the `assignee` field instead.
  ///
  /// ID of the Server the Volume is attached to, null if it is not attached at all.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 12
  /// ```
  @_i3.Deprecated('This property is deprecated.')
  final _i3.int? server;

  /// Resource the Volume is attached to, null if it is not attached at all.
  final _i4.VolumesGet200BodyVolumesArrayAssigneeModel? assignee;

  /// Location of the Volume. Volume can only be attached to Servers in the same Location.
  final _i5.VolumesGet200BodyVolumesArrayLocationModel location;

  /// Size in GB of the Volume.
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.num size;

  /// Device path on the file system for the Volume.
  ///
  /// **Example**:
  /// ```
  /// /dev/disk/by-id/scsi-0HC_Volume_4711
  /// ```
  final _i3.String linuxDevice;

  /// Protection configuration for the Resource.
  final _i6.VolumesGet200BodyVolumesArrayProtectionModel protection;

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
  final _i3.Map<_i3.String, _i3.String> labels;

  /// Status of the Volume.
  ///
  /// **Example**:
  /// ```
  /// available
  /// ```
  final _i7.VolumesGet200BodyVolumesArrayStatusModel status;

  /// Filesystem of the Volume if formatted on creation, null if not formatted on creation.
  ///
  /// **Example**:
  /// ```
  /// xfs
  /// ```
  final _i3.String? format;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'created': this.created.toTimeZonedIso8601String(),
    r'name': this.name,
    r'server': this.server,
    r'assignee': this.assignee?.toJson(),
    r'location': this.location.toJson(),
    r'size': this.size,
    r'linux_device': this.linuxDevice,
    r'protection': this.protection.toJson(),
    r'labels': this.labels,
    r'status': this.status.toJson(),
    r'format': this.format,
  };

  VolumesGet200BodyVolumesArrayModel Function({
    _i3.int? id,
    _i3.DateTime? created,
    _i3.String? name,
    _i3.int? server,
    _i4.VolumesGet200BodyVolumesArrayAssigneeModel? assignee,
    _i5.VolumesGet200BodyVolumesArrayLocationModel? location,
    _i3.num? size,
    _i3.String? linuxDevice,
    _i6.VolumesGet200BodyVolumesArrayProtectionModel? protection,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i7.VolumesGet200BodyVolumesArrayStatusModel? status,
    _i3.String? format,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.DateTime? created,
      _i3.String? name,
      _i3.Object? server = _sentinel,
      _i3.Object? assignee = _sentinel,
      _i5.VolumesGet200BodyVolumesArrayLocationModel? location,
      _i3.num? size,
      _i3.String? linuxDevice,
      _i6.VolumesGet200BodyVolumesArrayProtectionModel? protection,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i7.VolumesGet200BodyVolumesArrayStatusModel? status,
      _i3.Object? format = _sentinel,
    }) => VolumesGet200BodyVolumesArrayModel(
      id: id ?? this.id,
      created: created ?? this.created,
      name: name ?? this.name,
      server: _i3.identical(server, _sentinel)
          ? this.server
          : (server as _i3.int?),
      assignee: _i3.identical(assignee, _sentinel)
          ? this.assignee
          : (assignee as _i4.VolumesGet200BodyVolumesArrayAssigneeModel?),
      location: location ?? this.location,
      size: size ?? this.size,
      linuxDevice: linuxDevice ?? this.linuxDevice,
      protection: protection ?? this.protection,
      labels: labels ?? this.labels,
      status: status ?? this.status,
      format: _i3.identical(format, _sentinel)
          ? this.format
          : (format as _i3.String?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i8.DeepCollectionEquality();
    return other is VolumesGet200BodyVolumesArrayModel &&
        other.id == this.id &&
        other.created == this.created &&
        other.name == this.name &&
        other.server == this.server &&
        other.assignee == this.assignee &&
        other.location == this.location &&
        other.size == this.size &&
        other.linuxDevice == this.linuxDevice &&
        other.protection == this.protection &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.status == this.status &&
        other.format == this.format;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i8.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.created,
      this.name,
      this.server,
      this.assignee,
      this.location,
      this.size,
      this.linuxDevice,
      this.protection,
      deepEquals.hash(this.labels),
      this.status,
      this.format,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for VolumesGet200BodyVolumesArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i9.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode VolumesGet200BodyVolumesArrayModel: complex types cannot be URI-encoded',
    );
  }
}
