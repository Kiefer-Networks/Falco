// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i14;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i13;
import 'package:hetzner_cloud_api/src/model/servers_get200_body_servers_array_image_model.dart'
    as _i9;
import 'package:hetzner_cloud_api/src/model/servers_get200_body_servers_array_iso_model.dart'
    as _i10;
import 'package:hetzner_cloud_api/src/model/servers_get200_body_servers_array_location_model.dart'
    as _i8;
import 'package:hetzner_cloud_api/src/model/servers_get200_body_servers_array_placement_group_model.dart'
    as _i12;
import 'package:hetzner_cloud_api/src/model/servers_get200_body_servers_array_private_net_array_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/servers_get200_body_servers_array_protection_model.dart'
    as _i11;
import 'package:hetzner_cloud_api/src/model/servers_get200_body_servers_array_public_net_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/servers_get200_body_servers_array_server_type_model.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/model/servers_get200_body_servers_array_status_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersGet200BodyServersArrayModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersGet200BodyServersArrayModel({
    required this.id,
    required this.name,
    required this.status,
    required this.created,
    required this.publicNet,
    required this.privateNet,
    required this.serverType,
    required this.location,
    required this.image,
    required this.iso,
    required this.rescueEnabled,
    required this.locked,
    required this.backupWindow,
    required this.outgoingTraffic,
    required this.ingoingTraffic,
    required this.includedTraffic,
    required this.protection,
    required this.labels,
    required this.primaryDiskSize,
    this.volumes,
    this.loadBalancers,
    this.placementGroup,
  });

  factory ServersGet200BodyServersArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServersGet200BodyServersArrayModel: contains complex types',
    );
  }

  factory ServersGet200BodyServersArrayModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'ServersGet200BodyServersArrayModel',
    );
    return ServersGet200BodyServersArrayModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'ServersGet200BodyServersArrayModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'ServersGet200BodyServersArrayModel.name',
      ),
      status: _i4.ServersGet200BodyServersArrayStatusModel.fromJson(
        _$map[r'status'],
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'ServersGet200BodyServersArrayModel.created',
      ),
      publicNet: _i5.ServersGet200BodyServersArrayPublicNetModel.fromJson(
        _$map[r'public_net'],
      ),
      privateNet: _$map[r'private_net']
          .decodeJsonList<_i3.Object?>(
            context: r'ServersGet200BodyServersArrayModel.private_net',
          )
          .map(_i6.ServersGet200BodyServersArrayPrivateNetArrayModel.fromJson)
          .toList(),
      serverType: _i7.ServersGet200BodyServersArrayServerTypeModel.fromJson(
        _$map[r'server_type'],
      ),
      location: _i8.ServersGet200BodyServersArrayLocationModel.fromJson(
        _$map[r'location'],
      ),
      image: _$map[r'image'] == null
          ? null
          : _i9.ServersGet200BodyServersArrayImageModel.fromJson(
              _$map[r'image'],
            ),
      iso: _$map[r'iso'] == null
          ? null
          : _i10.ServersGet200BodyServersArrayIsoModel.fromJson(_$map[r'iso']),
      rescueEnabled: _$map[r'rescue_enabled'].decodeJsonBool(
        context: r'ServersGet200BodyServersArrayModel.rescue_enabled',
      ),
      locked: _$map[r'locked'].decodeJsonBool(
        context: r'ServersGet200BodyServersArrayModel.locked',
      ),
      backupWindow: _$map[r'backup_window'].decodeJsonNullableString(
        context: r'ServersGet200BodyServersArrayModel.backup_window',
      ),
      outgoingTraffic: _$map[r'outgoing_traffic'].decodeJsonNullableInt(
        context: r'ServersGet200BodyServersArrayModel.outgoing_traffic',
      ),
      ingoingTraffic: _$map[r'ingoing_traffic'].decodeJsonNullableInt(
        context: r'ServersGet200BodyServersArrayModel.ingoing_traffic',
      ),
      includedTraffic: _$map[r'included_traffic'].decodeJsonNullableInt(
        context: r'ServersGet200BodyServersArrayModel.included_traffic',
      ),
      protection: _i11.ServersGet200BodyServersArrayProtectionModel.fromJson(
        _$map[r'protection'],
      ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context: r'ServersGet200BodyServersArrayModel.labels',
        ),
        context: r'ServersGet200BodyServersArrayModel.labels',
      ),
      volumes: _$map[r'volumes'].decodeJsonNullableList<_i3.int>(
        context: r'ServersGet200BodyServersArrayModel.volumes',
      ),
      loadBalancers: _$map[r'load_balancers'].decodeJsonNullableList<_i3.int>(
        context: r'ServersGet200BodyServersArrayModel.load_balancers',
      ),
      primaryDiskSize: _$map[r'primary_disk_size'].decodeJsonNum(
        context: r'ServersGet200BodyServersArrayModel.primary_disk_size',
      ),
      placementGroup: _$map[r'placement_group'] == null
          ? null
          : _i12.ServersGet200BodyServersArrayPlacementGroupModel.fromJson(
              _$map[r'placement_group'],
            ),
    );
  }

  factory ServersGet200BodyServersArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServersGet200BodyServersArrayModel: contains complex types',
    );
  }

  /// ID of the [Server](#tag/servers).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// Name of the Server (must be unique per Project and a valid hostname as per RFC 1123).
  ///
  /// **Example**:
  /// ```
  /// my-resource
  /// ```
  final _i3.String name;

  /// Status of the Server.
  final _i4.ServersGet200BodyServersArrayStatusModel status;

  /// Point in time when the Resource was created (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  /// **Example**:
  /// ```
  /// 2016-01-30T23:55:00Z
  /// ```
  final _i3.DateTime created;

  /// Public network information. The Server's IPv4 address can be found in `public_net->ipv4->ip`.
  final _i5.ServersGet200BodyServersArrayPublicNetModel publicNet;

  /// Private networks information.
  final _i3.List<_i6.ServersGet200BodyServersArrayPrivateNetArrayModel>
  privateNet;

  final _i7.ServersGet200BodyServersArrayServerTypeModel serverType;

  /// Location this Resource is located at.
  ///
  final _i8.ServersGet200BodyServersArrayLocationModel location;

  /// Image the server is based on.
  final _i9.ServersGet200BodyServersArrayImageModel? image;

  /// ISO Image that is attached to this Server. Null if no ISO is attached.
  final _i10.ServersGet200BodyServersArrayIsoModel? iso;

  /// True if rescue mode is enabled. Server will then boot into rescue system on next reboot.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool rescueEnabled;

  /// True if Server has been locked and is not available to user.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool locked;

  /// Time window (UTC) in which the backup will run, or null if the backups are not enabled.
  ///
  /// **Example**:
  /// ```
  /// 22-02
  /// ```
  final _i3.String? backupWindow;

  /// Outbound Traffic for the current billing period in bytes.
  ///
  /// **Example**:
  /// ```json
  /// 123456
  /// ```
  final _i3.int? outgoingTraffic;

  /// Inbound Traffic for the current billing period in bytes.
  ///
  /// **Example**:
  /// ```json
  /// 123456
  /// ```
  final _i3.int? ingoingTraffic;

  /// Free Traffic for the current billing period in bytes.
  ///
  /// **Example**:
  /// ```json
  /// 654321
  /// ```
  final _i3.int? includedTraffic;

  /// Protection configuration for the Server.
  final _i11.ServersGet200BodyServersArrayProtectionModel protection;

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

  /// IDs of Volumes assigned to this Server.
  final _i3.List<_i3.int>? volumes;

  /// Load Balancer IDs assigned to the server.
  final _i3.List<_i3.int>? loadBalancers;

  /// Size of the primary Disk.
  ///
  /// **Example**:
  /// ```json
  /// 50
  /// ```
  final _i3.num primaryDiskSize;

  /// The placement group the server is assigned to.
  final _i12.ServersGet200BodyServersArrayPlacementGroupModel? placementGroup;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'status': this.status.toJson(),
    r'created': this.created.toTimeZonedIso8601String(),
    r'public_net': this.publicNet.toJson(),
    r'private_net': this.privateNet.map((e) => e.toJson()).toList(),
    r'server_type': this.serverType.toJson(),
    r'location': this.location.toJson(),
    r'image': this.image?.toJson(),
    r'iso': this.iso?.toJson(),
    r'rescue_enabled': this.rescueEnabled,
    r'locked': this.locked,
    r'backup_window': this.backupWindow,
    r'outgoing_traffic': this.outgoingTraffic,
    r'ingoing_traffic': this.ingoingTraffic,
    r'included_traffic': this.includedTraffic,
    r'protection': this.protection.toJson(),
    r'labels': this.labels,
    if (this.volumes != null) r'volumes': this.volumes,
    if (this.loadBalancers != null) r'load_balancers': this.loadBalancers,
    r'primary_disk_size': this.primaryDiskSize,
    r'placement_group': this.placementGroup?.toJson(),
  };

  ServersGet200BodyServersArrayModel Function({
    _i3.int? id,
    _i3.String? name,
    _i4.ServersGet200BodyServersArrayStatusModel? status,
    _i3.DateTime? created,
    _i5.ServersGet200BodyServersArrayPublicNetModel? publicNet,
    _i3.List<_i6.ServersGet200BodyServersArrayPrivateNetArrayModel>? privateNet,
    _i7.ServersGet200BodyServersArrayServerTypeModel? serverType,
    _i8.ServersGet200BodyServersArrayLocationModel? location,
    _i9.ServersGet200BodyServersArrayImageModel? image,
    _i10.ServersGet200BodyServersArrayIsoModel? iso,
    _i3.bool? rescueEnabled,
    _i3.bool? locked,
    _i3.String? backupWindow,
    _i3.int? outgoingTraffic,
    _i3.int? ingoingTraffic,
    _i3.int? includedTraffic,
    _i11.ServersGet200BodyServersArrayProtectionModel? protection,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i3.List<_i3.int>? volumes,
    _i3.List<_i3.int>? loadBalancers,
    _i3.num? primaryDiskSize,
    _i12.ServersGet200BodyServersArrayPlacementGroupModel? placementGroup,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.String? name,
      _i4.ServersGet200BodyServersArrayStatusModel? status,
      _i3.DateTime? created,
      _i5.ServersGet200BodyServersArrayPublicNetModel? publicNet,
      _i3.List<_i6.ServersGet200BodyServersArrayPrivateNetArrayModel>?
      privateNet,
      _i7.ServersGet200BodyServersArrayServerTypeModel? serverType,
      _i8.ServersGet200BodyServersArrayLocationModel? location,
      _i3.Object? image = _sentinel,
      _i3.Object? iso = _sentinel,
      _i3.bool? rescueEnabled,
      _i3.bool? locked,
      _i3.Object? backupWindow = _sentinel,
      _i3.Object? outgoingTraffic = _sentinel,
      _i3.Object? ingoingTraffic = _sentinel,
      _i3.Object? includedTraffic = _sentinel,
      _i11.ServersGet200BodyServersArrayProtectionModel? protection,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i3.Object? volumes = _sentinel,
      _i3.Object? loadBalancers = _sentinel,
      _i3.num? primaryDiskSize,
      _i3.Object? placementGroup = _sentinel,
    }) => ServersGet200BodyServersArrayModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      created: created ?? this.created,
      publicNet: publicNet ?? this.publicNet,
      privateNet: privateNet ?? this.privateNet,
      serverType: serverType ?? this.serverType,
      location: location ?? this.location,
      image: _i3.identical(image, _sentinel)
          ? this.image
          : (image as _i9.ServersGet200BodyServersArrayImageModel?),
      iso: _i3.identical(iso, _sentinel)
          ? this.iso
          : (iso as _i10.ServersGet200BodyServersArrayIsoModel?),
      rescueEnabled: rescueEnabled ?? this.rescueEnabled,
      locked: locked ?? this.locked,
      backupWindow: _i3.identical(backupWindow, _sentinel)
          ? this.backupWindow
          : (backupWindow as _i3.String?),
      outgoingTraffic: _i3.identical(outgoingTraffic, _sentinel)
          ? this.outgoingTraffic
          : (outgoingTraffic as _i3.int?),
      ingoingTraffic: _i3.identical(ingoingTraffic, _sentinel)
          ? this.ingoingTraffic
          : (ingoingTraffic as _i3.int?),
      includedTraffic: _i3.identical(includedTraffic, _sentinel)
          ? this.includedTraffic
          : (includedTraffic as _i3.int?),
      protection: protection ?? this.protection,
      labels: labels ?? this.labels,
      volumes: _i3.identical(volumes, _sentinel)
          ? this.volumes
          : (volumes as _i3.List<_i3.int>?),
      loadBalancers: _i3.identical(loadBalancers, _sentinel)
          ? this.loadBalancers
          : (loadBalancers as _i3.List<_i3.int>?),
      primaryDiskSize: primaryDiskSize ?? this.primaryDiskSize,
      placementGroup: _i3.identical(placementGroup, _sentinel)
          ? this.placementGroup
          : (placementGroup
                as _i12.ServersGet200BodyServersArrayPlacementGroupModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i13.DeepCollectionEquality();
    return other is ServersGet200BodyServersArrayModel &&
        other.id == this.id &&
        other.name == this.name &&
        other.status == this.status &&
        other.created == this.created &&
        other.publicNet == this.publicNet &&
        _$deepEquals.equals(other.privateNet, this.privateNet) &&
        other.serverType == this.serverType &&
        other.location == this.location &&
        other.image == this.image &&
        other.iso == this.iso &&
        other.rescueEnabled == this.rescueEnabled &&
        other.locked == this.locked &&
        other.backupWindow == this.backupWindow &&
        other.outgoingTraffic == this.outgoingTraffic &&
        other.ingoingTraffic == this.ingoingTraffic &&
        other.includedTraffic == this.includedTraffic &&
        other.protection == this.protection &&
        _$deepEquals.equals(other.labels, this.labels) &&
        _$deepEquals.equals(other.volumes, this.volumes) &&
        _$deepEquals.equals(other.loadBalancers, this.loadBalancers) &&
        other.primaryDiskSize == this.primaryDiskSize &&
        other.placementGroup == this.placementGroup;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i13.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.name,
      this.status,
      this.created,
      this.publicNet,
      deepEquals.hash(this.privateNet),
      this.serverType,
      this.location,
      this.image,
      this.iso,
      this.rescueEnabled,
      this.locked,
      this.backupWindow,
      this.outgoingTraffic,
      this.ingoingTraffic,
      this.includedTraffic,
      this.protection,
      deepEquals.hash(this.labels),
      deepEquals.hash(this.volumes),
      deepEquals.hash(this.loadBalancers),
      this.primaryDiskSize,
      this.placementGroup,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServersGet200BodyServersArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i14.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServersGet200BodyServersArrayModel: complex types cannot be URI-encoded',
    );
  }
}
