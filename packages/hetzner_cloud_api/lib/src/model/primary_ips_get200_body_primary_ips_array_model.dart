// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i10;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i9;
import 'package:hetzner_cloud_api/src/model/primary_ips_get200_body_primary_ips_array_assignee_type_model.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/model/primary_ips_get200_body_primary_ips_array_dns_ptr_array_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/primary_ips_get200_body_primary_ips_array_location_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/primary_ips_get200_body_primary_ips_array_protection_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/primary_ips_get200_body_primary_ips_array_type_model.dart'
    as _i7;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class PrimaryIpsGet200BodyPrimaryIpsArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const PrimaryIpsGet200BodyPrimaryIpsArrayModel({
    required this.id,
    required this.name,
    required this.labels,
    required this.created,
    required this.blocked,
    required this.location,
    required this.ip,
    required this.dnsPtr,
    required this.protection,
    required this.$type,
    required this.assigneeType,
    required this.assigneeId,
    this.autoDelete = autoDeleteDefault,
  });

  factory PrimaryIpsGet200BodyPrimaryIpsArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for PrimaryIpsGet200BodyPrimaryIpsArrayModel: contains complex types',
    );
  }

  factory PrimaryIpsGet200BodyPrimaryIpsArrayModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'PrimaryIpsGet200BodyPrimaryIpsArrayModel',
    );
    return PrimaryIpsGet200BodyPrimaryIpsArrayModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'PrimaryIpsGet200BodyPrimaryIpsArrayModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'PrimaryIpsGet200BodyPrimaryIpsArrayModel.name',
      ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context: r'PrimaryIpsGet200BodyPrimaryIpsArrayModel.labels',
        ),
        context: r'PrimaryIpsGet200BodyPrimaryIpsArrayModel.labels',
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'PrimaryIpsGet200BodyPrimaryIpsArrayModel.created',
      ),
      blocked: _$map[r'blocked'].decodeJsonBool(
        context: r'PrimaryIpsGet200BodyPrimaryIpsArrayModel.blocked',
      ),
      location: _i4.PrimaryIpsGet200BodyPrimaryIpsArrayLocationModel.fromJson(
        _$map[r'location'],
      ),
      ip: _$map[r'ip'].decodeJsonString(
        context: r'PrimaryIpsGet200BodyPrimaryIpsArrayModel.ip',
      ),
      dnsPtr: _$map[r'dns_ptr']
          .decodeJsonList<_i3.Object?>(
            context: r'PrimaryIpsGet200BodyPrimaryIpsArrayModel.dns_ptr',
          )
          .map(_i5.PrimaryIpsGet200BodyPrimaryIpsArrayDnsPtrArrayModel.fromJson)
          .toList(),
      protection:
          _i6.PrimaryIpsGet200BodyPrimaryIpsArrayProtectionModel.fromJson(
            _$map[r'protection'],
          ),
      $type: _i7.PrimaryIpsGet200BodyPrimaryIpsArrayTypeModel.fromJson(
        _$map[r'type'],
      ),
      autoDelete: _$map.containsKey(r'auto_delete')
          ? _$map[r'auto_delete'].decodeJsonBool(
              context: r'PrimaryIpsGet200BodyPrimaryIpsArrayModel.auto_delete',
            )
          : autoDeleteDefault,
      assigneeType:
          _i8.PrimaryIpsGet200BodyPrimaryIpsArrayAssigneeTypeModel.fromJson(
            _$map[r'assignee_type'],
          ),
      assigneeId: _$map[r'assignee_id'].decodeJsonNullableInt(
        context: r'PrimaryIpsGet200BodyPrimaryIpsArrayModel.assignee_id',
      ),
    );
  }

  factory PrimaryIpsGet200BodyPrimaryIpsArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for PrimaryIpsGet200BodyPrimaryIpsArrayModel: contains complex types',
    );
  }

  static const _i3.bool autoDeleteDefault = false;

  /// ID of the [Primary IP](#tag/primary-ips).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

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
  final _i3.Map<_i3.String, _i3.String> labels;

  /// Point in time when the Resource was created (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  /// **Example**:
  /// ```
  /// 2016-01-30T23:55:00Z
  /// ```
  final _i3.DateTime created;

  /// Blocked state of the [Primary IP](#tag/primary-ips).
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool blocked;

  /// [Location](#tag/locations) of the [Primary IP](#tag/primary-ips).
  ///
  final _i4.PrimaryIpsGet200BodyPrimaryIpsArrayLocationModel location;

  /// IP address.
  ///
  /// **Example**:
  /// ```
  /// 2001:db8::/64
  /// ```
  final _i3.String ip;

  /// List of reverse DNS records.
  final _i3.List<_i5.PrimaryIpsGet200BodyPrimaryIpsArrayDnsPtrArrayModel>
  dnsPtr;

  /// Protection configuration for the Resource.
  final _i6.PrimaryIpsGet200BodyPrimaryIpsArrayProtectionModel protection;

  /// [Primary IP](#tag/primary-ips) type.
  ///
  /// **Example**:
  /// ```
  /// ipv6
  /// ```
  final _i7.PrimaryIpsGet200BodyPrimaryIpsArrayTypeModel $type;

  /// Auto deletion state.
  ///
  /// If enabled the [Primary IP](#tag/primary-ips) will be deleted once the assigned resource gets deleted.
  ///
  ///
  /// **Example**:
  /// ```json
  /// true
  /// ```
  final _i3.bool autoDelete;

  /// Type of resource the [Primary IP](#tag/primary-ips) is assigned to.
  ///
  /// As of 23 September 2026 `unassigned` is returned if the [Primary IP](#tag/primary-ips) is not assigned.
  ///
  ///
  /// **Example**:
  /// ```
  /// server
  /// ```
  final _i8.PrimaryIpsGet200BodyPrimaryIpsArrayAssigneeTypeModel assigneeType;

  /// ID of resource the [Primary IP](#tag/primary-ips) is assigned to.
  ///
  /// `null` if the [Primary IP](#tag/primary-ips) is not assigned.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 17
  /// ```
  final _i3.int? assigneeId;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'labels': this.labels,
    r'created': this.created.toTimeZonedIso8601String(),
    r'blocked': this.blocked,
    r'location': this.location.toJson(),
    r'ip': this.ip,
    r'dns_ptr': this.dnsPtr.map((e) => e.toJson()).toList(),
    r'protection': this.protection.toJson(),
    r'type': this.$type.toJson(),
    r'auto_delete': this.autoDelete,
    r'assignee_type': this.assigneeType.toJson(),
    r'assignee_id': this.assigneeId,
  };

  PrimaryIpsGet200BodyPrimaryIpsArrayModel Function({
    _i3.int? id,
    _i3.String? name,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i3.DateTime? created,
    _i3.bool? blocked,
    _i4.PrimaryIpsGet200BodyPrimaryIpsArrayLocationModel? location,
    _i3.String? ip,
    _i3.List<_i5.PrimaryIpsGet200BodyPrimaryIpsArrayDnsPtrArrayModel>? dnsPtr,
    _i6.PrimaryIpsGet200BodyPrimaryIpsArrayProtectionModel? protection,
    _i7.PrimaryIpsGet200BodyPrimaryIpsArrayTypeModel? $type,
    _i3.bool? autoDelete,
    _i8.PrimaryIpsGet200BodyPrimaryIpsArrayAssigneeTypeModel? assigneeType,
    _i3.int? assigneeId,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.String? name,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i3.DateTime? created,
      _i3.bool? blocked,
      _i4.PrimaryIpsGet200BodyPrimaryIpsArrayLocationModel? location,
      _i3.String? ip,
      _i3.List<_i5.PrimaryIpsGet200BodyPrimaryIpsArrayDnsPtrArrayModel>? dnsPtr,
      _i6.PrimaryIpsGet200BodyPrimaryIpsArrayProtectionModel? protection,
      _i7.PrimaryIpsGet200BodyPrimaryIpsArrayTypeModel? $type,
      _i3.bool? autoDelete,
      _i8.PrimaryIpsGet200BodyPrimaryIpsArrayAssigneeTypeModel? assigneeType,
      _i3.Object? assigneeId = _sentinel,
    }) => PrimaryIpsGet200BodyPrimaryIpsArrayModel(
      id: id ?? this.id,
      name: name ?? this.name,
      labels: labels ?? this.labels,
      created: created ?? this.created,
      blocked: blocked ?? this.blocked,
      location: location ?? this.location,
      ip: ip ?? this.ip,
      dnsPtr: dnsPtr ?? this.dnsPtr,
      protection: protection ?? this.protection,
      $type: $type ?? this.$type,
      autoDelete: autoDelete ?? this.autoDelete,
      assigneeType: assigneeType ?? this.assigneeType,
      assigneeId: _i3.identical(assigneeId, _sentinel)
          ? this.assigneeId
          : (assigneeId as _i3.int?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i9.DeepCollectionEquality();
    return other is PrimaryIpsGet200BodyPrimaryIpsArrayModel &&
        other.id == this.id &&
        other.name == this.name &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.created == this.created &&
        other.blocked == this.blocked &&
        other.location == this.location &&
        other.ip == this.ip &&
        _$deepEquals.equals(other.dnsPtr, this.dnsPtr) &&
        other.protection == this.protection &&
        other.$type == this.$type &&
        other.autoDelete == this.autoDelete &&
        other.assigneeType == this.assigneeType &&
        other.assigneeId == this.assigneeId;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i9.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.name,
      deepEquals.hash(this.labels),
      this.created,
      this.blocked,
      this.location,
      this.ip,
      deepEquals.hash(this.dnsPtr),
      this.protection,
      this.$type,
      this.autoDelete,
      this.assigneeType,
      this.assigneeId,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for PrimaryIpsGet200BodyPrimaryIpsArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i10.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode PrimaryIpsGet200BodyPrimaryIpsArrayModel: complex types cannot be URI-encoded',
    );
  }
}
