// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i12;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i11;
import 'package:hetzner_cloud_api/src/model/servers_post201_body_server_image_architecture_model.dart'
    as _i10;
import 'package:hetzner_cloud_api/src/model/servers_post201_body_server_image_created_from_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/servers_post201_body_server_image_deprecation_model.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/model/servers_post201_body_server_image_os_flavor_model.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/model/servers_post201_body_server_image_protection_model.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/model/servers_post201_body_server_image_status_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/servers_post201_body_server_image_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Image the server is based on.
@_i2.immutable
class $RawServersPost201BodyServerImageModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const $RawServersPost201BodyServerImageModel({
    required this.id,
    required this.$type,
    required this.status,
    required this.name,
    required this.description,
    required this.imageSize,
    required this.diskSize,
    required this.created,
    required this.createdFrom,
    required this.boundTo,
    required this.osFlavor,
    required this.osVersion,
    required this.protection,
    required this.deprecation,
    required this.deleted,
    required this.labels,
    required this.architecture,
    this.rapidDeploy,
  });

  factory $RawServersPost201BodyServerImageModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for $RawServersPost201BodyServerImageModel: contains complex types',
    );
  }

  factory $RawServersPost201BodyServerImageModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'$RawServersPost201BodyServerImageModel',
    );
    return $RawServersPost201BodyServerImageModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'$RawServersPost201BodyServerImageModel.id',
      ),
      $type: _i4.ServersPost201BodyServerImageTypeModel.fromJson(
        _$map[r'type'],
      ),
      status: _i5.ServersPost201BodyServerImageStatusModel.fromJson(
        _$map[r'status'],
      ),
      name: _$map[r'name'].decodeJsonNullableString(
        context: r'$RawServersPost201BodyServerImageModel.name',
      ),
      description: _$map[r'description'].decodeJsonString(
        context: r'$RawServersPost201BodyServerImageModel.description',
      ),
      imageSize: _$map[r'image_size'].decodeJsonNullableNum(
        context: r'$RawServersPost201BodyServerImageModel.image_size',
      ),
      diskSize: _$map[r'disk_size'].decodeJsonNum(
        context: r'$RawServersPost201BodyServerImageModel.disk_size',
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'$RawServersPost201BodyServerImageModel.created',
      ),
      createdFrom: _$map[r'created_from'] == null
          ? null
          : _i6.ServersPost201BodyServerImageCreatedFromModel.fromJson(
              _$map[r'created_from'],
            ),
      boundTo: _$map[r'bound_to'].decodeJsonNullableInt(
        context: r'$RawServersPost201BodyServerImageModel.bound_to',
      ),
      osFlavor: _i7.ServersPost201BodyServerImageOsFlavorModel.fromJson(
        _$map[r'os_flavor'],
      ),
      osVersion: _$map[r'os_version'].decodeJsonNullableString(
        context: r'$RawServersPost201BodyServerImageModel.os_version',
      ),
      rapidDeploy: _$map[r'rapid_deploy'].decodeJsonNullableBool(
        context: r'$RawServersPost201BodyServerImageModel.rapid_deploy',
      ),
      protection: _i8.ServersPost201BodyServerImageProtectionModel.fromJson(
        _$map[r'protection'],
      ),
      deprecation: _$map[r'deprecation'] == null
          ? null
          : _i9.ServersPost201BodyServerImageDeprecationModel.fromJson(
              _$map[r'deprecation'],
            ),
      deleted: _$map[r'deleted'].decodeJsonNullableString(
        context: r'$RawServersPost201BodyServerImageModel.deleted',
      ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context: r'$RawServersPost201BodyServerImageModel.labels',
        ),
        context: r'$RawServersPost201BodyServerImageModel.labels',
      ),
      architecture:
          _i10.ServersPost201BodyServerImageArchitectureModel.fromJson(
            _$map[r'architecture'],
          ),
    );
  }

  factory $RawServersPost201BodyServerImageModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for $RawServersPost201BodyServerImageModel: contains complex types',
    );
  }

  /// ID of the [Image](#tag/images).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Type of the Image.
  ///
  /// **Example**:
  /// ```
  /// snapshot
  /// ```
  final _i4.ServersPost201BodyServerImageTypeModel $type;

  /// Status of the Image.
  ///
  /// **Example**:
  /// ```
  /// available
  /// ```
  final _i5.ServersPost201BodyServerImageStatusModel status;

  /// Unique identifier of the Image. This value is only set for system Images.
  ///
  /// **Example**:
  /// ```
  /// ubuntu-24.04
  /// ```
  final _i3.String? name;

  /// Description of the Image.
  ///
  /// **Example**:
  /// ```
  /// Ubuntu 24.04 Standard 64 bit
  /// ```
  final _i3.String description;

  /// Size of the Image file in our storage in GB. For snapshot Images this is the value relevant for calculating costs for the Image.
  ///
  /// **Example**:
  /// ```json
  /// 2.3
  /// ```
  final _i3.num? imageSize;

  /// Size of the disk contained in the Image in GB.
  ///
  /// **Example**:
  /// ```json
  /// 10
  /// ```
  final _i3.num diskSize;

  /// Point in time when the Resource was created (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  /// **Example**:
  /// ```
  /// 2016-01-30T23:55:00Z
  /// ```
  final _i3.DateTime created;

  /// Information about the Server the Image was created from.
  final _i6.ServersPost201BodyServerImageCreatedFromModel? createdFrom;

  /// ID of Server the Image is bound to. Only set for Images of type `backup`.
  final _i3.int? boundTo;

  /// Flavor of operating system contained in the Image.
  ///
  /// **Example**:
  /// ```
  /// ubuntu
  /// ```
  final _i7.ServersPost201BodyServerImageOsFlavorModel osFlavor;

  /// Operating system version.
  ///
  /// **Example**:
  /// ```
  /// 24.04
  /// ```
  final _i3.String? osVersion;

  /// Indicates that rapid deploy of the Image is available.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool? rapidDeploy;

  /// Protection configuration for the Resource.
  final _i8.ServersPost201BodyServerImageProtectionModel protection;

  /// Describes if, when and how the resource is deprecated. If this field is
  /// set to `null` the resource is not deprecated. If a value is set, it is
  /// considered deprecated.
  ///
  final _i9.ServersPost201BodyServerImageDeprecationModel? deprecation;

  /// Point in time where the Image was deleted (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  final _i3.String? deleted;

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

  /// CPU architecture compatible with the Image.
  ///
  ///
  /// **Example**:
  /// ```
  /// x86
  /// ```
  final _i10.ServersPost201BodyServerImageArchitectureModel architecture;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'type': this.$type.toJson(),
    r'status': this.status.toJson(),
    r'name': this.name,
    r'description': this.description,
    r'image_size': this.imageSize,
    r'disk_size': this.diskSize,
    r'created': this.created.toTimeZonedIso8601String(),
    r'created_from': this.createdFrom?.toJson(),
    r'bound_to': this.boundTo,
    r'os_flavor': this.osFlavor.toJson(),
    r'os_version': this.osVersion,
    if (this.rapidDeploy != null) r'rapid_deploy': this.rapidDeploy,
    r'protection': this.protection.toJson(),
    r'deprecation': this.deprecation?.toJson(),
    r'deleted': this.deleted,
    r'labels': this.labels,
    r'architecture': this.architecture.toJson(),
  };

  $RawServersPost201BodyServerImageModel Function({
    _i3.int? id,
    _i4.ServersPost201BodyServerImageTypeModel? $type,
    _i5.ServersPost201BodyServerImageStatusModel? status,
    _i3.String? name,
    _i3.String? description,
    _i3.num? imageSize,
    _i3.num? diskSize,
    _i3.DateTime? created,
    _i6.ServersPost201BodyServerImageCreatedFromModel? createdFrom,
    _i3.int? boundTo,
    _i7.ServersPost201BodyServerImageOsFlavorModel? osFlavor,
    _i3.String? osVersion,
    _i3.bool? rapidDeploy,
    _i8.ServersPost201BodyServerImageProtectionModel? protection,
    _i9.ServersPost201BodyServerImageDeprecationModel? deprecation,
    _i3.String? deleted,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i10.ServersPost201BodyServerImageArchitectureModel? architecture,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i4.ServersPost201BodyServerImageTypeModel? $type,
      _i5.ServersPost201BodyServerImageStatusModel? status,
      _i3.Object? name = _sentinel,
      _i3.String? description,
      _i3.Object? imageSize = _sentinel,
      _i3.num? diskSize,
      _i3.DateTime? created,
      _i3.Object? createdFrom = _sentinel,
      _i3.Object? boundTo = _sentinel,
      _i7.ServersPost201BodyServerImageOsFlavorModel? osFlavor,
      _i3.Object? osVersion = _sentinel,
      _i3.Object? rapidDeploy = _sentinel,
      _i8.ServersPost201BodyServerImageProtectionModel? protection,
      _i3.Object? deprecation = _sentinel,
      _i3.Object? deleted = _sentinel,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i10.ServersPost201BodyServerImageArchitectureModel? architecture,
    }) => $RawServersPost201BodyServerImageModel(
      id: id ?? this.id,
      $type: $type ?? this.$type,
      status: status ?? this.status,
      name: _i3.identical(name, _sentinel) ? this.name : (name as _i3.String?),
      description: description ?? this.description,
      imageSize: _i3.identical(imageSize, _sentinel)
          ? this.imageSize
          : (imageSize as _i3.num?),
      diskSize: diskSize ?? this.diskSize,
      created: created ?? this.created,
      createdFrom: _i3.identical(createdFrom, _sentinel)
          ? this.createdFrom
          : (createdFrom as _i6.ServersPost201BodyServerImageCreatedFromModel?),
      boundTo: _i3.identical(boundTo, _sentinel)
          ? this.boundTo
          : (boundTo as _i3.int?),
      osFlavor: osFlavor ?? this.osFlavor,
      osVersion: _i3.identical(osVersion, _sentinel)
          ? this.osVersion
          : (osVersion as _i3.String?),
      rapidDeploy: _i3.identical(rapidDeploy, _sentinel)
          ? this.rapidDeploy
          : (rapidDeploy as _i3.bool?),
      protection: protection ?? this.protection,
      deprecation: _i3.identical(deprecation, _sentinel)
          ? this.deprecation
          : (deprecation as _i9.ServersPost201BodyServerImageDeprecationModel?),
      deleted: _i3.identical(deleted, _sentinel)
          ? this.deleted
          : (deleted as _i3.String?),
      labels: labels ?? this.labels,
      architecture: architecture ?? this.architecture,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i11.DeepCollectionEquality();
    return other is $RawServersPost201BodyServerImageModel &&
        other.id == this.id &&
        other.$type == this.$type &&
        other.status == this.status &&
        other.name == this.name &&
        other.description == this.description &&
        other.imageSize == this.imageSize &&
        other.diskSize == this.diskSize &&
        other.created == this.created &&
        other.createdFrom == this.createdFrom &&
        other.boundTo == this.boundTo &&
        other.osFlavor == this.osFlavor &&
        other.osVersion == this.osVersion &&
        other.rapidDeploy == this.rapidDeploy &&
        other.protection == this.protection &&
        other.deprecation == this.deprecation &&
        other.deleted == this.deleted &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.architecture == this.architecture;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i11.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.$type,
      this.status,
      this.name,
      this.description,
      this.imageSize,
      this.diskSize,
      this.created,
      this.createdFrom,
      this.boundTo,
      this.osFlavor,
      this.osVersion,
      this.rapidDeploy,
      this.protection,
      this.deprecation,
      this.deleted,
      deepEquals.hash(this.labels),
      this.architecture,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServersPost201BodyServerImageModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i12.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode $RawServersPost201BodyServerImageModel: complex types cannot be URI-encoded',
    );
  }
}

typedef ServersPost201BodyServerImageModel =
    $RawServersPost201BodyServerImageModel?;
