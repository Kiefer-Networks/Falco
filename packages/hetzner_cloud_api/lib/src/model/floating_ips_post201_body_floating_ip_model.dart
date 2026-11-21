// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i9;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i8;
import 'package:hetzner_cloud_api/src/model/floating_ips_post201_body_floating_ip_dns_ptr_array_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/floating_ips_post201_body_floating_ip_home_location_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/floating_ips_post201_body_floating_ip_protection_model.dart'
    as _i7;
import 'package:hetzner_cloud_api/src/model/floating_ips_post201_body_floating_ip_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FloatingIpsPost201BodyFloatingIpModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FloatingIpsPost201BodyFloatingIpModel({
    required this.id,
    required this.name,
    required this.description,
    required this.ip,
    required this.$type,
    required this.server,
    required this.dnsPtr,
    required this.homeLocation,
    required this.blocked,
    required this.protection,
    required this.labels,
    required this.created,
  });

  factory FloatingIpsPost201BodyFloatingIpModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for FloatingIpsPost201BodyFloatingIpModel: contains complex types',
    );
  }

  factory FloatingIpsPost201BodyFloatingIpModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'FloatingIpsPost201BodyFloatingIpModel',
    );
    return FloatingIpsPost201BodyFloatingIpModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'FloatingIpsPost201BodyFloatingIpModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'FloatingIpsPost201BodyFloatingIpModel.name',
      ),
      description: _$map[r'description'].decodeJsonNullableString(
        context: r'FloatingIpsPost201BodyFloatingIpModel.description',
      ),
      ip: _$map[r'ip'].decodeJsonString(
        context: r'FloatingIpsPost201BodyFloatingIpModel.ip',
      ),
      $type: _i4.FloatingIpsPost201BodyFloatingIpTypeModel.fromJson(
        _$map[r'type'],
      ),
      server: _$map[r'server'].decodeJsonNullableInt(
        context: r'FloatingIpsPost201BodyFloatingIpModel.server',
      ),
      dnsPtr: _$map[r'dns_ptr']
          .decodeJsonList<_i3.Object?>(
            context: r'FloatingIpsPost201BodyFloatingIpModel.dns_ptr',
          )
          .map(_i5.FloatingIpsPost201BodyFloatingIpDnsPtrArrayModel.fromJson)
          .toList(),
      homeLocation:
          _i6.FloatingIpsPost201BodyFloatingIpHomeLocationModel.fromJson(
            _$map[r'home_location'],
          ),
      blocked: _$map[r'blocked'].decodeJsonBool(
        context: r'FloatingIpsPost201BodyFloatingIpModel.blocked',
      ),
      protection: _i7.FloatingIpsPost201BodyFloatingIpProtectionModel.fromJson(
        _$map[r'protection'],
      ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context: r'FloatingIpsPost201BodyFloatingIpModel.labels',
        ),
        context: r'FloatingIpsPost201BodyFloatingIpModel.labels',
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'FloatingIpsPost201BodyFloatingIpModel.created',
      ),
    );
  }

  factory FloatingIpsPost201BodyFloatingIpModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for FloatingIpsPost201BodyFloatingIpModel: contains complex types',
    );
  }

  /// ID of the [Floating IP](#tag/floating-ips).
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

  /// Description of the Resource.
  ///
  /// **Example**:
  /// ```
  /// This describes my resource
  /// ```
  final _i3.String? description;

  /// IP address.
  ///
  /// **Example**:
  /// ```
  /// 2001:db8::/64
  /// ```
  final _i3.String ip;

  /// The Floating IP type.
  ///
  /// **Example**:
  /// ```
  /// ipv6
  /// ```
  final _i4.FloatingIpsPost201BodyFloatingIpTypeModel $type;

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

  /// List of reverse DNS entries for the [Floating IP](#tag/floating-ips).
  ///
  final _i3.List<_i5.FloatingIpsPost201BodyFloatingIpDnsPtrArrayModel> dnsPtr;

  /// [Location](#tag/locations) the for the [Floating IP](#tag/floating-ips) is located at.
  ///
  /// Routing is optimized for this [Location](#tag/locations).
  ///
  final _i6.FloatingIpsPost201BodyFloatingIpHomeLocationModel homeLocation;

  /// Indicates whether the [Floating IP](#tag/floating-ips) is blocked.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool blocked;

  /// Protection configuration for the Resource.
  final _i7.FloatingIpsPost201BodyFloatingIpProtectionModel protection;

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

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'description': this.description,
    r'ip': this.ip,
    r'type': this.$type.toJson(),
    r'server': this.server,
    r'dns_ptr': this.dnsPtr.map((e) => e.toJson()).toList(),
    r'home_location': this.homeLocation.toJson(),
    r'blocked': this.blocked,
    r'protection': this.protection.toJson(),
    r'labels': this.labels,
    r'created': this.created.toTimeZonedIso8601String(),
  };

  FloatingIpsPost201BodyFloatingIpModel Function({
    _i3.int? id,
    _i3.String? name,
    _i3.String? description,
    _i3.String? ip,
    _i4.FloatingIpsPost201BodyFloatingIpTypeModel? $type,
    _i3.int? server,
    _i3.List<_i5.FloatingIpsPost201BodyFloatingIpDnsPtrArrayModel>? dnsPtr,
    _i6.FloatingIpsPost201BodyFloatingIpHomeLocationModel? homeLocation,
    _i3.bool? blocked,
    _i7.FloatingIpsPost201BodyFloatingIpProtectionModel? protection,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i3.DateTime? created,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.String? name,
      _i3.Object? description = _sentinel,
      _i3.String? ip,
      _i4.FloatingIpsPost201BodyFloatingIpTypeModel? $type,
      _i3.Object? server = _sentinel,
      _i3.List<_i5.FloatingIpsPost201BodyFloatingIpDnsPtrArrayModel>? dnsPtr,
      _i6.FloatingIpsPost201BodyFloatingIpHomeLocationModel? homeLocation,
      _i3.bool? blocked,
      _i7.FloatingIpsPost201BodyFloatingIpProtectionModel? protection,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i3.DateTime? created,
    }) => FloatingIpsPost201BodyFloatingIpModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: _i3.identical(description, _sentinel)
          ? this.description
          : (description as _i3.String?),
      ip: ip ?? this.ip,
      $type: $type ?? this.$type,
      server: _i3.identical(server, _sentinel)
          ? this.server
          : (server as _i3.int?),
      dnsPtr: dnsPtr ?? this.dnsPtr,
      homeLocation: homeLocation ?? this.homeLocation,
      blocked: blocked ?? this.blocked,
      protection: protection ?? this.protection,
      labels: labels ?? this.labels,
      created: created ?? this.created,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i8.DeepCollectionEquality();
    return other is FloatingIpsPost201BodyFloatingIpModel &&
        other.id == this.id &&
        other.name == this.name &&
        other.description == this.description &&
        other.ip == this.ip &&
        other.$type == this.$type &&
        other.server == this.server &&
        _$deepEquals.equals(other.dnsPtr, this.dnsPtr) &&
        other.homeLocation == this.homeLocation &&
        other.blocked == this.blocked &&
        other.protection == this.protection &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.created == this.created;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i8.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.name,
      this.description,
      this.ip,
      this.$type,
      this.server,
      deepEquals.hash(this.dnsPtr),
      this.homeLocation,
      this.blocked,
      this.protection,
      deepEquals.hash(this.labels),
      this.created,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for FloatingIpsPost201BodyFloatingIpModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i9.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FloatingIpsPost201BodyFloatingIpModel: complex types cannot be URI-encoded',
    );
  }
}
