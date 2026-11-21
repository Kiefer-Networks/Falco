// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/networks_post_body_body_subnets_array_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class NetworksPostBodyBodySubnetsArrayModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const NetworksPostBodyBodySubnetsArrayModel({
    required this.$type,
    required this.networkZone,
    this.ipRange,
    this.vswitchId,
  });

  factory NetworksPostBodyBodySubnetsArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'type', r'ip_range', r'network_zone', r'vswitch_id'},
      listKeys: {},
      context: r'NetworksPostBodyBodySubnetsArrayModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return NetworksPostBodyBodySubnetsArrayModel(
      $type: _i4.NetworksPostBodyBodySubnetsArrayTypeModel.fromSimple(
        _$values[r'type'],
        explode: explode,
      ),
      ipRange: _$values[r'ip_range'].decodeSimpleNullableString(
        context: r'NetworksPostBodyBodySubnetsArrayModel.ip_range',
      ),
      networkZone: _$values[r'network_zone'].decodeSimpleString(
        context: r'NetworksPostBodyBodySubnetsArrayModel.network_zone',
      ),
      vswitchId: _$values[r'vswitch_id'].decodeSimpleNullableInt(
        context: r'NetworksPostBodyBodySubnetsArrayModel.vswitch_id',
      ),
    );
  }

  factory NetworksPostBodyBodySubnetsArrayModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'NetworksPostBodyBodySubnetsArrayModel',
    );
    return NetworksPostBodyBodySubnetsArrayModel(
      $type: _i4.NetworksPostBodyBodySubnetsArrayTypeModel.fromJson(
        _$map[r'type'],
      ),
      ipRange: _$map[r'ip_range'].decodeJsonNullableString(
        context: r'NetworksPostBodyBodySubnetsArrayModel.ip_range',
      ),
      networkZone: _$map[r'network_zone'].decodeJsonString(
        context: r'NetworksPostBodyBodySubnetsArrayModel.network_zone',
      ),
      vswitchId: _$map[r'vswitch_id'].decodeJsonNullableInt(
        context: r'NetworksPostBodyBodySubnetsArrayModel.vswitch_id',
      ),
    );
  }

  factory NetworksPostBodyBodySubnetsArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'type', r'ip_range', r'network_zone', r'vswitch_id'},
      listKeys: {},
      context: r'NetworksPostBodyBodySubnetsArrayModel',
    );
    return NetworksPostBodyBodySubnetsArrayModel(
      $type: _i4.NetworksPostBodyBodySubnetsArrayTypeModel.fromForm(
        _$values[r'type'],
        explode: explode,
      ),
      ipRange: _$values[r'ip_range'].decodeFormNullableString(
        context: r'NetworksPostBodyBodySubnetsArrayModel.ip_range',
      ),
      networkZone: _$values[r'network_zone'].decodeFormString(
        context: r'NetworksPostBodyBodySubnetsArrayModel.network_zone',
      ),
      vswitchId: _$values[r'vswitch_id'].decodeFormNullableInt(
        context: r'NetworksPostBodyBodySubnetsArrayModel.vswitch_id',
      ),
    );
  }

  /// Type of subnet.
  ///
  final _i4.NetworksPostBodyBodySubnetsArrayTypeModel $type;

  /// IP range of the subnet.
  ///
  /// Uses CIDR notation.
  ///
  /// Must be a subnet of the parent [Networks](#tag/networks) `ip_range`.
  ///
  /// Must not overlap with any other subnets or with any destinations in routes.
  ///
  /// Minimum network size is /30. We highly recommend that you pick a larger subnet with a /24 netmask.
  ///
  ///
  /// **Example**:
  /// ```
  /// 10.0.1.0/24
  /// ```
  final _i3.String? ipRange;

  /// Name of the [Network Zone](#tag/network-zones).
  ///
  /// The [Location](#tag/locations) contains the `network_zone` property it belongs to.
  ///
  ///
  /// **Example**:
  /// ```
  /// eu-central
  /// ```
  final _i3.String networkZone;

  /// ID of the robot vSwitch.
  ///
  /// Must only be supplied for subnets of type `vswitch`.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 1000
  /// ```
  final _i3.int? vswitchId;

  @_i3.override
  _i3.Object? toJson() => {
    r'type': this.$type.toJson(),
    if (this.ipRange != null) r'ip_range': this.ipRange,
    r'network_zone': this.networkZone,
    if (this.vswitchId != null) r'vswitch_id': this.vswitchId,
  };

  NetworksPostBodyBodySubnetsArrayModel Function({
    _i4.NetworksPostBodyBodySubnetsArrayTypeModel? $type,
    _i3.String? ipRange,
    _i3.String? networkZone,
    _i3.int? vswitchId,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i4.NetworksPostBodyBodySubnetsArrayTypeModel? $type,
      _i3.Object? ipRange = _sentinel,
      _i3.String? networkZone,
      _i3.Object? vswitchId = _sentinel,
    }) => NetworksPostBodyBodySubnetsArrayModel(
      $type: $type ?? this.$type,
      ipRange: _i3.identical(ipRange, _sentinel)
          ? this.ipRange
          : (ipRange as _i3.String?),
      networkZone: networkZone ?? this.networkZone,
      vswitchId: _i3.identical(vswitchId, _sentinel)
          ? this.vswitchId
          : (vswitchId as _i3.int?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is NetworksPostBodyBodySubnetsArrayModel &&
        other.$type == this.$type &&
        other.ipRange == this.ipRange &&
        other.networkZone == this.networkZone &&
        other.vswitchId == this.vswitchId;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.$type,
      this.ipRange,
      this.networkZone,
      this.vswitchId,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'type'] = _i1.PropertyValue.scalar(this.$type.toJson());
    if (this.ipRange != null) {
      _$result[r'ip_range'] = _i1.PropertyValue.scalar(this.ipRange!);
    }
    _$result[r'network_zone'] = _i1.PropertyValue.scalar(this.networkZone);
    if (this.vswitchId != null) {
      _$result[r'vswitch_id'] = _i1.PropertyValue.scalar(
        this.vswitchId!.toString(),
      );
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode NetworksPostBodyBodySubnetsArrayModel: complex types cannot be URI-encoded',
    );
  }
}
