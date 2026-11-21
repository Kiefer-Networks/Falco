// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:hetzner_cloud_api/src/model/servers_post_body_body_firewalls_array_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_post_body_body_public_net_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersPostBodyBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersPostBodyBodyModel({
    required this.name,
    required this.serverType,
    required this.image,
    this.location,
    this.startAfterCreate = startAfterCreateDefault,
    this.placementGroup,
    this.sshKeys,
    this.volumes,
    this.networks,
    this.firewalls,
    this.userData,
    this.labels,
    this.automount,
    this.publicNet,
  });

  factory ServersPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServersPostBodyBodyModel: contains complex types',
    );
  }

  factory ServersPostBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ServersPostBodyBodyModel');
    return ServersPostBodyBodyModel(
      name: _$map[r'name'].decodeJsonString(
        context: r'ServersPostBodyBodyModel.name',
      ),
      location: _$map[r'location'].decodeJsonNullableString(
        context: r'ServersPostBodyBodyModel.location',
      ),
      serverType: _$map[r'server_type'].decodeJsonString(
        context: r'ServersPostBodyBodyModel.server_type',
      ),
      startAfterCreate: _$map.containsKey(r'start_after_create')
          ? _$map[r'start_after_create'].decodeJsonBool(
              context: r'ServersPostBodyBodyModel.start_after_create',
            )
          : startAfterCreateDefault,
      image: _$map[r'image'].decodeJsonString(
        context: r'ServersPostBodyBodyModel.image',
      ),
      placementGroup: _$map[r'placement_group'].decodeJsonNullableInt(
        context: r'ServersPostBodyBodyModel.placement_group',
      ),
      sshKeys: _$map[r'ssh_keys'].decodeJsonNullableList<_i3.String>(
        context: r'ServersPostBodyBodyModel.ssh_keys',
      ),
      volumes: _$map[r'volumes'].decodeJsonNullableList<_i3.int>(
        context: r'ServersPostBodyBodyModel.volumes',
      ),
      networks: _$map[r'networks'].decodeJsonNullableList<_i3.int>(
        context: r'ServersPostBodyBodyModel.networks',
      ),
      firewalls: _$map[r'firewalls']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'ServersPostBodyBodyModel.firewalls',
          )
          ?.map(_i4.ServersPostBodyBodyFirewallsArrayModel.fromJson)
          .toList(),
      userData: _$map[r'user_data'].decodeJsonNullableString(
        context: r'ServersPostBodyBodyModel.user_data',
      ),
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(context: r'ServersPostBodyBodyModel.labels'),
        context: r'ServersPostBodyBodyModel.labels',
      ),
      automount: _$map[r'automount'].decodeJsonNullableBool(
        context: r'ServersPostBodyBodyModel.automount',
      ),
      publicNet: _$map[r'public_net'] == null
          ? null
          : _i5.ServersPostBodyBodyPublicNetModel.fromJson(
              _$map[r'public_net'],
            ),
    );
  }

  factory ServersPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServersPostBodyBodyModel: contains complex types',
    );
  }

  static const _i3.bool startAfterCreateDefault = true;

  /// Name of the Server to create (must be unique per Project and a valid hostname as per RFC 1123).
  ///
  /// **Example**:
  /// ```
  /// my-server
  /// ```
  final _i3.String name;

  /// ID or name of the Location to create the Server in.
  ///
  /// **Example**:
  /// ```
  /// nbg1
  /// ```
  final _i3.String? location;

  /// ID or name of the Server type this Server should be created with.
  ///
  /// **Example**:
  /// ```
  /// cpx22
  /// ```
  final _i3.String serverType;

  /// This automatically triggers a [Power on a Server-Server Action](#tag/server-actions/poweron_server) after the creation is finished and is returned in the `next_actions` response object.
  ///
  /// **Example**:
  /// ```json
  /// true
  /// ```
  final _i3.bool? startAfterCreate;

  /// ID or name of the Image the Server is created from.
  ///
  /// **Example**:
  /// ```
  /// ubuntu-24.04
  /// ```
  final _i3.String image;

  /// ID of the Placement Group the Server should be in.
  ///
  /// **Example**:
  /// ```json
  /// 1
  /// ```
  final _i3.int? placementGroup;

  /// SSH key IDs (`integer`) or names (`string`) which should be injected into the Server at creation time.
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   "my-ssh-key"
  /// ]
  /// ```
  final _i3.List<_i3.String>? sshKeys;

  /// Volume IDs which should be attached to the Server at the creation time. Volumes must be in the same Location.
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   123
  /// ]
  /// ```
  final _i3.List<_i3.int>? volumes;

  /// Network IDs which should be attached to the Server private network interface at the creation time.
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   456
  /// ]
  /// ```
  final _i3.List<_i3.int>? networks;

  /// Firewalls which should be applied on the Server's public network interface at creation time.
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   {
  ///     "firewall": 38
  ///   }
  /// ]
  /// ```
  final _i3.List<_i4.ServersPostBodyBodyFirewallsArrayModel>? firewalls;

  /// Cloud-Init user data to use during Server creation. This field is limited to 32KiB.
  ///
  /// **Example**:
  /// ```
  /// #cloud-config
  /// runcmd:
  /// - [touch, /root/cloud-init-worked]
  ///
  /// ```
  final _i3.String? userData;

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

  /// Auto-mount Volumes after attach.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool? automount;

  /// Public Network options.
  final _i5.ServersPostBodyBodyPublicNetModel? publicNet;

  @_i3.override
  _i3.Object? toJson() => {
    r'name': this.name,
    if (this.location != null) r'location': this.location,
    r'server_type': this.serverType,
    if (this.startAfterCreate != null)
      r'start_after_create': this.startAfterCreate,
    r'image': this.image,
    if (this.placementGroup != null) r'placement_group': this.placementGroup,
    if (this.sshKeys != null) r'ssh_keys': this.sshKeys,
    if (this.volumes != null) r'volumes': this.volumes,
    if (this.networks != null) r'networks': this.networks,
    if (this.firewalls != null)
      r'firewalls': this.firewalls?.map((e) => e.toJson()).toList(),
    if (this.userData != null) r'user_data': this.userData,
    if (this.labels != null) r'labels': this.labels,
    if (this.automount != null) r'automount': this.automount,
    if (this.publicNet != null) r'public_net': this.publicNet?.toJson(),
  };

  ServersPostBodyBodyModel Function({
    _i3.String? name,
    _i3.String? location,
    _i3.String? serverType,
    _i3.bool? startAfterCreate,
    _i3.String? image,
    _i3.int? placementGroup,
    _i3.List<_i3.String>? sshKeys,
    _i3.List<_i3.int>? volumes,
    _i3.List<_i3.int>? networks,
    _i3.List<_i4.ServersPostBodyBodyFirewallsArrayModel>? firewalls,
    _i3.String? userData,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i3.bool? automount,
    _i5.ServersPostBodyBodyPublicNetModel? publicNet,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.String? name,
      _i3.Object? location = _sentinel,
      _i3.String? serverType,
      _i3.Object? startAfterCreate = _sentinel,
      _i3.String? image,
      _i3.Object? placementGroup = _sentinel,
      _i3.Object? sshKeys = _sentinel,
      _i3.Object? volumes = _sentinel,
      _i3.Object? networks = _sentinel,
      _i3.Object? firewalls = _sentinel,
      _i3.Object? userData = _sentinel,
      _i3.Object? labels = _sentinel,
      _i3.Object? automount = _sentinel,
      _i3.Object? publicNet = _sentinel,
    }) => ServersPostBodyBodyModel(
      name: name ?? this.name,
      location: _i3.identical(location, _sentinel)
          ? this.location
          : (location as _i3.String?),
      serverType: serverType ?? this.serverType,
      startAfterCreate: _i3.identical(startAfterCreate, _sentinel)
          ? this.startAfterCreate
          : (startAfterCreate as _i3.bool?),
      image: image ?? this.image,
      placementGroup: _i3.identical(placementGroup, _sentinel)
          ? this.placementGroup
          : (placementGroup as _i3.int?),
      sshKeys: _i3.identical(sshKeys, _sentinel)
          ? this.sshKeys
          : (sshKeys as _i3.List<_i3.String>?),
      volumes: _i3.identical(volumes, _sentinel)
          ? this.volumes
          : (volumes as _i3.List<_i3.int>?),
      networks: _i3.identical(networks, _sentinel)
          ? this.networks
          : (networks as _i3.List<_i3.int>?),
      firewalls: _i3.identical(firewalls, _sentinel)
          ? this.firewalls
          : (firewalls
                as _i3.List<_i4.ServersPostBodyBodyFirewallsArrayModel>?),
      userData: _i3.identical(userData, _sentinel)
          ? this.userData
          : (userData as _i3.String?),
      labels: _i3.identical(labels, _sentinel)
          ? this.labels
          : (labels as _i3.Map<_i3.String, _i3.String>?),
      automount: _i3.identical(automount, _sentinel)
          ? this.automount
          : (automount as _i3.bool?),
      publicNet: _i3.identical(publicNet, _sentinel)
          ? this.publicNet
          : (publicNet as _i5.ServersPostBodyBodyPublicNetModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is ServersPostBodyBodyModel &&
        other.name == this.name &&
        other.location == this.location &&
        other.serverType == this.serverType &&
        other.startAfterCreate == this.startAfterCreate &&
        other.image == this.image &&
        other.placementGroup == this.placementGroup &&
        _$deepEquals.equals(other.sshKeys, this.sshKeys) &&
        _$deepEquals.equals(other.volumes, this.volumes) &&
        _$deepEquals.equals(other.networks, this.networks) &&
        _$deepEquals.equals(other.firewalls, this.firewalls) &&
        other.userData == this.userData &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.automount == this.automount &&
        other.publicNet == this.publicNet;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.name,
      this.location,
      this.serverType,
      this.startAfterCreate,
      this.image,
      this.placementGroup,
      deepEquals.hash(this.sshKeys),
      deepEquals.hash(this.volumes),
      deepEquals.hash(this.networks),
      deepEquals.hash(this.firewalls),
      this.userData,
      deepEquals.hash(this.labels),
      this.automount,
      this.publicNet,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServersPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServersPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
