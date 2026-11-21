// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:hetzner_cloud_api/src/model/networks_post_body_body_routes_array_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/networks_post_body_body_subnets_array_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class NetworksPostBodyBodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const NetworksPostBodyBodyModel({
    required this.name,
    required this.ipRange,
    this.labels,
    this.subnets,
    this.routes,
    this.exposeRoutesToVswitch,
  });

  factory NetworksPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for NetworksPostBodyBodyModel: contains complex types',
    );
  }

  factory NetworksPostBodyBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'NetworksPostBodyBodyModel');
    return NetworksPostBodyBodyModel(
      name: _$map[r'name'].decodeJsonString(
        context: r'NetworksPostBodyBodyModel.name',
      ),
      ipRange: _$map[r'ip_range'].decodeJsonString(
        context: r'NetworksPostBodyBodyModel.ip_range',
      ),
      labels: _$map[r'labels'].decodeJsonNullableMap(
        (v) => v.decodeJsonString(context: r'NetworksPostBodyBodyModel.labels'),
        context: r'NetworksPostBodyBodyModel.labels',
      ),
      subnets: _$map[r'subnets']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'NetworksPostBodyBodyModel.subnets',
          )
          ?.map(_i4.NetworksPostBodyBodySubnetsArrayModel.fromJson)
          .toList(),
      routes: _$map[r'routes']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'NetworksPostBodyBodyModel.routes',
          )
          ?.map(_i5.NetworksPostBodyBodyRoutesArrayModel.fromJson)
          .toList(),
      exposeRoutesToVswitch: _$map[r'expose_routes_to_vswitch']
          .decodeJsonNullableBool(
            context: r'NetworksPostBodyBodyModel.expose_routes_to_vswitch',
          ),
    );
  }

  factory NetworksPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for NetworksPostBodyBodyModel: contains complex types',
    );
  }

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
  /// Must span all included subnets. Must be one of the private IPv4 ranges of RFC1918.
  ///
  /// Minimum network size is /24. We highly recommend that you pick a larger [Network](#tag/networks) with a /16 netmask.
  ///
  ///
  /// **Example**:
  /// ```
  /// 10.0.0.0/16
  /// ```
  final _i3.String ipRange;

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

  /// Array of subnets to allocate.
  final _i3.List<_i4.NetworksPostBodyBodySubnetsArrayModel>? subnets;

  /// Array of routes set in this [Network](#tag/networks).
  final _i3.List<_i5.NetworksPostBodyBodyRoutesArrayModel>? routes;

  /// Toggle to expose routes to the [Networks](#tag/networks) vSwitch.
  ///
  /// Indicates if the routes from this [Network](#tag/networks) should be exposed to the vSwitch in this [Network](#tag/networks). Only takes effect if a [vSwitch is setup](https://docs.hetzner.com/cloud/networks/connect-dedi-vswitch) in this [Network](#tag/networks).
  ///
  ///
  /// **Example**:
  /// ```json
  /// false
  /// ```
  final _i3.bool? exposeRoutesToVswitch;

  @_i3.override
  _i3.Object? toJson() => {
    r'name': this.name,
    r'ip_range': this.ipRange,
    if (this.labels != null) r'labels': this.labels,
    if (this.subnets != null)
      r'subnets': this.subnets?.map((e) => e.toJson()).toList(),
    if (this.routes != null)
      r'routes': this.routes?.map((e) => e.toJson()).toList(),
    if (this.exposeRoutesToVswitch != null)
      r'expose_routes_to_vswitch': this.exposeRoutesToVswitch,
  };

  NetworksPostBodyBodyModel Function({
    _i3.String? name,
    _i3.String? ipRange,
    _i3.Map<_i3.String, _i3.String>? labels,
    _i3.List<_i4.NetworksPostBodyBodySubnetsArrayModel>? subnets,
    _i3.List<_i5.NetworksPostBodyBodyRoutesArrayModel>? routes,
    _i3.bool? exposeRoutesToVswitch,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.String? name,
      _i3.String? ipRange,
      _i3.Object? labels = _sentinel,
      _i3.Object? subnets = _sentinel,
      _i3.Object? routes = _sentinel,
      _i3.Object? exposeRoutesToVswitch = _sentinel,
    }) => NetworksPostBodyBodyModel(
      name: name ?? this.name,
      ipRange: ipRange ?? this.ipRange,
      labels: _i3.identical(labels, _sentinel)
          ? this.labels
          : (labels as _i3.Map<_i3.String, _i3.String>?),
      subnets: _i3.identical(subnets, _sentinel)
          ? this.subnets
          : (subnets as _i3.List<_i4.NetworksPostBodyBodySubnetsArrayModel>?),
      routes: _i3.identical(routes, _sentinel)
          ? this.routes
          : (routes as _i3.List<_i5.NetworksPostBodyBodyRoutesArrayModel>?),
      exposeRoutesToVswitch: _i3.identical(exposeRoutesToVswitch, _sentinel)
          ? this.exposeRoutesToVswitch
          : (exposeRoutesToVswitch as _i3.bool?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is NetworksPostBodyBodyModel &&
        other.name == this.name &&
        other.ipRange == this.ipRange &&
        _$deepEquals.equals(other.labels, this.labels) &&
        _$deepEquals.equals(other.subnets, this.subnets) &&
        _$deepEquals.equals(other.routes, this.routes) &&
        other.exposeRoutesToVswitch == this.exposeRoutesToVswitch;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.name,
      this.ipRange,
      deepEquals.hash(this.labels),
      deepEquals.hash(this.subnets),
      deepEquals.hash(this.routes),
      this.exposeRoutesToVswitch,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for NetworksPostBodyBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode NetworksPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
