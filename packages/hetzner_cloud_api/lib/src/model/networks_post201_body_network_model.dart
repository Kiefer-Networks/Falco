// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i8;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i7;
import 'package:hetzner_cloud_api/src/model/networks_post201_body_network_protection_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/networks_post201_body_network_routes_array_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/networks_post201_body_network_subnets_array_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class NetworksPost201BodyNetworkModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const NetworksPost201BodyNetworkModel({
    required this.id,
    required this.name,
    required this.ipRange,
    required this.subnets,
    required this.routes,
    required this.servers,
    required this.protection,
    required this.labels,
    required this.created,
    required this.exposeRoutesToVswitch,
    this.loadBalancers,
  });

  factory NetworksPost201BodyNetworkModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for NetworksPost201BodyNetworkModel: contains complex types',
    );
  }

  factory NetworksPost201BodyNetworkModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'NetworksPost201BodyNetworkModel');
    return NetworksPost201BodyNetworkModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'NetworksPost201BodyNetworkModel.id',
      ),
      name: _$map[r'name'].decodeJsonString(
        context: r'NetworksPost201BodyNetworkModel.name',
      ),
      ipRange: _$map[r'ip_range'].decodeJsonString(
        context: r'NetworksPost201BodyNetworkModel.ip_range',
      ),
      subnets: _$map[r'subnets']
          .decodeJsonList<_i3.Object?>(
            context: r'NetworksPost201BodyNetworkModel.subnets',
          )
          .map(_i4.NetworksPost201BodyNetworkSubnetsArrayModel.fromJson)
          .toList(),
      routes: _$map[r'routes']
          .decodeJsonList<_i3.Object?>(
            context: r'NetworksPost201BodyNetworkModel.routes',
          )
          .map(_i5.NetworksPost201BodyNetworkRoutesArrayModel.fromJson)
          .toList(),
      servers: _$map[r'servers'].decodeJsonList<_i3.int>(
        context: r'NetworksPost201BodyNetworkModel.servers',
      ),
      loadBalancers: _$map[r'load_balancers'].decodeJsonNullableList<_i3.int>(
        context: r'NetworksPost201BodyNetworkModel.load_balancers',
      ),
      protection: _i6.NetworksPost201BodyNetworkProtectionModel.fromJson(
        _$map[r'protection'],
      ),
      labels: _$map[r'labels'].decodeJsonMap(
        (v) => v.decodeJsonString(
          context: r'NetworksPost201BodyNetworkModel.labels',
        ),
        context: r'NetworksPost201BodyNetworkModel.labels',
      ),
      created: _$map[r'created'].decodeJsonDateTime(
        context: r'NetworksPost201BodyNetworkModel.created',
      ),
      exposeRoutesToVswitch: _$map[r'expose_routes_to_vswitch'].decodeJsonBool(
        context: r'NetworksPost201BodyNetworkModel.expose_routes_to_vswitch',
      ),
    );
  }

  factory NetworksPost201BodyNetworkModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for NetworksPost201BodyNetworkModel: contains complex types',
    );
  }

  /// ID of the [Network](#tag/networks).
  ///
  /// **Example**:
  /// ```json
  /// 4711
  /// ```
  final _i3.int id;

  /// Name of the [Network](#tag/networks).
  ///
  /// **Example**:
  /// ```
  /// mynet
  /// ```
  final _i3.String name;

  /// IP range of the [Network](#tag/networks).
  ///
  /// Uses CIDR notation.
  ///
  ///
  /// **Example**:
  /// ```
  /// 10.0.0.0/16
  /// ```
  final _i3.String ipRange;

  /// List of subnets allocated in this [Network](#tag/networks).
  final _i3.List<_i4.NetworksPost201BodyNetworkSubnetsArrayModel> subnets;

  /// Array of routes set in this [Network](#tag/networks).
  final _i3.List<_i5.NetworksPost201BodyNetworkRoutesArrayModel> routes;

  /// Array of IDs of [Servers](#tag/servers) attached to this [Network](#tag/networks).
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   42
  /// ]
  /// ```
  final _i3.List<_i3.int> servers;

  /// Array of IDs of [Load Balancers](#tag/load-balancers) attached to this [Network](#tag/networks).
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   42
  /// ]
  /// ```
  final _i3.List<_i3.int>? loadBalancers;

  /// Protection configuration for the Resource.
  final _i6.NetworksPost201BodyNetworkProtectionModel protection;

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

  /// Indicates if the routes from this [Network](#tag/networks) should be exposed to the vSwitch connection.
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool exposeRoutesToVswitch;

  @_i3.override
  _i3.Object? toJson() => {
    r'id': this.id,
    r'name': this.name,
    r'ip_range': this.ipRange,
    r'subnets': this.subnets.map((e) => e.toJson()).toList(),
    r'routes': this.routes.map((e) => e.toJson()).toList(),
    r'servers': this.servers,
    if (this.loadBalancers != null) r'load_balancers': this.loadBalancers,
    r'protection': this.protection.toJson(),
    r'labels': this.labels,
    r'created': this.created.toTimeZonedIso8601String(),
    r'expose_routes_to_vswitch': this.exposeRoutesToVswitch,
  };

  NetworksPost201BodyNetworkModel Function({
    _i3.int? id,
    _i3.String? name,
    _i3.String? ipRange,
    _i3.List<_i4.NetworksPost201BodyNetworkSubnetsArrayModel>? subnets,
    _i3.List<_i5.NetworksPost201BodyNetworkRoutesArrayModel>? routes,
    _i3.List<_i3.int>? servers,
    _i3.List<_i3.int>? loadBalancers,
    _i6.NetworksPost201BodyNetworkProtectionModel? protection,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i3.DateTime? created,
    _i3.bool? exposeRoutesToVswitch,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? id,
      _i3.String? name,
      _i3.String? ipRange,
      _i3.List<_i4.NetworksPost201BodyNetworkSubnetsArrayModel>? subnets,
      _i3.List<_i5.NetworksPost201BodyNetworkRoutesArrayModel>? routes,
      _i3.List<_i3.int>? servers,
      _i3.Object? loadBalancers = _sentinel,
      _i6.NetworksPost201BodyNetworkProtectionModel? protection,
      _i3.Map<_i3.String, _i3.String>? labels,
      _i3.DateTime? created,
      _i3.bool? exposeRoutesToVswitch,
    }) => NetworksPost201BodyNetworkModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ipRange: ipRange ?? this.ipRange,
      subnets: subnets ?? this.subnets,
      routes: routes ?? this.routes,
      servers: servers ?? this.servers,
      loadBalancers: _i3.identical(loadBalancers, _sentinel)
          ? this.loadBalancers
          : (loadBalancers as _i3.List<_i3.int>?),
      protection: protection ?? this.protection,
      labels: labels ?? this.labels,
      created: created ?? this.created,
      exposeRoutesToVswitch:
          exposeRoutesToVswitch ?? this.exposeRoutesToVswitch,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i7.DeepCollectionEquality();
    return other is NetworksPost201BodyNetworkModel &&
        other.id == this.id &&
        other.name == this.name &&
        other.ipRange == this.ipRange &&
        _$deepEquals.equals(other.subnets, this.subnets) &&
        _$deepEquals.equals(other.routes, this.routes) &&
        _$deepEquals.equals(other.servers, this.servers) &&
        _$deepEquals.equals(other.loadBalancers, this.loadBalancers) &&
        other.protection == this.protection &&
        _$deepEquals.equals(other.labels, this.labels) &&
        other.created == this.created &&
        other.exposeRoutesToVswitch == this.exposeRoutesToVswitch;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i7.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.id,
      this.name,
      this.ipRange,
      deepEquals.hash(this.subnets),
      deepEquals.hash(this.routes),
      deepEquals.hash(this.servers),
      deepEquals.hash(this.loadBalancers),
      this.protection,
      deepEquals.hash(this.labels),
      this.created,
      this.exposeRoutesToVswitch,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for NetworksPost201BodyNetworkModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i8.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode NetworksPost201BodyNetworkModel: complex types cannot be URI-encoded',
    );
  }
}
