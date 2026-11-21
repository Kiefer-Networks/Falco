// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i8;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i7;
import 'package:hetzner_cloud_api/src/model/primary_ips_post_body_body_assignee_type_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/primary_ips_post_body_body_location_one_of_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/primary_ips_post_body_body_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PrimaryIpsPostBodyBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PrimaryIpsPostBodyBodyModel({
    required this.name,
    required this.$type,
    this.labels,
    this.location,
    this.assigneeType,
    this.assigneeId,
    this.autoDelete = autoDeleteDefault,
  });

  factory PrimaryIpsPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for PrimaryIpsPostBodyBodyModel: contains complex types',
    );
  }

  factory PrimaryIpsPostBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'PrimaryIpsPostBodyBodyModel');
    return PrimaryIpsPostBodyBodyModel(
      name: _$map[r'name'].decodeJsonString(
        context: r'PrimaryIpsPostBodyBodyModel.name',
      ),
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) =>
            v.decodeJsonString(context: r'PrimaryIpsPostBodyBodyModel.labels'),
        context: r'PrimaryIpsPostBodyBodyModel.labels',
      ),
      $type: _i4.PrimaryIpsPostBodyBodyTypeModel.fromJson(_$map[r'type']),
      location: _$map[r'location'] == null
          ? null
          : _i5.PrimaryIpsPostBodyBodyLocationOneOfModel.fromJson(
              _$map[r'location'],
            ),
      assigneeType: _$map[r'assignee_type'] == null
          ? null
          : _i6.PrimaryIpsPostBodyBodyAssigneeTypeModel.fromJson(
              _$map[r'assignee_type'],
            ),
      assigneeId: _$map[r'assignee_id'].decodeJsonNullableInt(
        context: r'PrimaryIpsPostBodyBodyModel.assignee_id',
      ),
      autoDelete: _$map.containsKey(r'auto_delete')
          ? _$map[r'auto_delete'].decodeJsonBool(
              context: r'PrimaryIpsPostBodyBodyModel.auto_delete',
            )
          : autoDeleteDefault,
    );
  }

  factory PrimaryIpsPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for PrimaryIpsPostBodyBodyModel: contains complex types',
    );
  }

  static const _i3.bool autoDeleteDefault = false;

  /// Name of the Resource. Must be unique per Project.
  ///
  /// **Example**:
  /// ```
  /// my-resource
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

  /// [Primary IP](#tag/primary-ips) type.
  ///
  /// **Example**:
  /// ```
  /// ipv6
  /// ```
  final _i4.PrimaryIpsPostBodyBodyTypeModel $type;

  /// [Location](#tag/locations) ID or name the [Primary IP](#tag/primary-ips) will be bound to.
  ///
  /// Omit if `assignee_id`/`assignee_type` or `datacenter` are provided.
  ///
  final _i5.PrimaryIpsPostBodyBodyLocationOneOfModel? location;

  /// Type of resource to assign the [Primary IP](#tag/primary-ips) to.
  ///
  /// Omitted if the [Primary IP](#tag/primary-ips) should not get assigned.
  ///
  ///
  /// **Example**:
  /// ```
  /// server
  /// ```
  final _i6.PrimaryIpsPostBodyBodyAssigneeTypeModel? assigneeType;

  /// ID of resource to assign the [Primary IP](#tag/primary-ips) to.
  ///
  /// Omitted if the [Primary IP](#tag/primary-ips) should not get assigned.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 17
  /// ```
  final _i3.int? assigneeId;

  /// Auto deletion state.
  ///
  /// If enabled the [Primary IP](#tag/primary-ips) will be deleted once the assigned resource gets deleted.
  ///
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool? autoDelete;

  @_i3.override
  _i3.Object? toJson() => {
    r'name': this.name,
    if (this.labels != null) r'labels': this.labels,
    r'type': this.$type.toJson(),
    if (this.location != null) r'location': this.location?.toJson(),
    if (this.assigneeType != null)
      r'assignee_type': this.assigneeType?.toJson(),
    r'assignee_id': this.assigneeId,
    if (this.autoDelete != null) r'auto_delete': this.autoDelete,
  };

  PrimaryIpsPostBodyBodyModel Function({
    _i3.String? name,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i4.PrimaryIpsPostBodyBodyTypeModel? $type,
    _i5.PrimaryIpsPostBodyBodyLocationOneOfModel? location,
    _i6.PrimaryIpsPostBodyBodyAssigneeTypeModel? assigneeType,
    _i3.int? assigneeId,
    _i3.bool? autoDelete,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.String? name,
      _i3.Object? labels = _sentinel,
      _i4.PrimaryIpsPostBodyBodyTypeModel? $type,
      _i3.Object? location = _sentinel,
      _i3.Object? assigneeType = _sentinel,
      _i3.Object? assigneeId = _sentinel,
      _i3.Object? autoDelete = _sentinel,
    }) => PrimaryIpsPostBodyBodyModel(
      name: name ?? this.name,
      labels: _i3.identical(labels, _sentinel)
          ? this.labels
          : (labels as _i3.Map<_i3.String, _i3.String>?),
      $type: $type ?? this.$type,
      location: _i3.identical(location, _sentinel)
          ? this.location
          : (location as _i5.PrimaryIpsPostBodyBodyLocationOneOfModel?),
      assigneeType: _i3.identical(assigneeType, _sentinel)
          ? this.assigneeType
          : (assigneeType as _i6.PrimaryIpsPostBodyBodyAssigneeTypeModel?),
      assigneeId: _i3.identical(assigneeId, _sentinel)
          ? this.assigneeId
          : (assigneeId as _i3.int?),
      autoDelete: _i3.identical(autoDelete, _sentinel)
          ? this.autoDelete
          : (autoDelete as _i3.bool?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i7.DeepCollectionEquality();
    return other is PrimaryIpsPostBodyBodyModel &&
        other.name == this.name &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.$type == this.$type &&
        other.location == this.location &&
        other.assigneeType == this.assigneeType &&
        other.assigneeId == this.assigneeId &&
        other.autoDelete == this.autoDelete;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i7.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.name,
      deepEquals.hash(this.labels),
      this.$type,
      this.location,
      this.assigneeType,
      this.assigneeId,
      this.autoDelete,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for PrimaryIpsPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i8.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PrimaryIpsPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
