// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:hetzner_cloud_api/src/model/networks_id_members_get200_body_members_array_status_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/networks_id_members_get200_body_members_array_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class NetworksIdMembersGet200BodyMembersArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const NetworksIdMembersGet200BodyMembersArrayModel({
    required this.$type,
    required this.id,
    required this.ip,
    required this.status,
    required this.aliasIps,
    required this.subnet,
  });

  factory NetworksIdMembersGet200BodyMembersArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'type', r'id', r'ip', r'status', r'alias_ips', r'subnet'},
      listKeys: {r'alias_ips'},
      context: r'NetworksIdMembersGet200BodyMembersArrayModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return NetworksIdMembersGet200BodyMembersArrayModel(
      $type: _i4.NetworksIdMembersGet200BodyMembersArrayTypeModel.fromSimple(
        _$values[r'type'],
        explode: explode,
      ),
      id: _$values[r'id'].decodeSimpleInt(
        context: r'NetworksIdMembersGet200BodyMembersArrayModel.id',
      ),
      ip: _$values[r'ip'].decodeSimpleString(
        context: r'NetworksIdMembersGet200BodyMembersArrayModel.ip',
      ),
      status: _i5.NetworksIdMembersGet200BodyMembersArrayStatusModel.fromSimple(
        _$values[r'status'],
        explode: explode,
      ),
      aliasIps: _$values[r'alias_ips'].decodeSimpleStringList(
        context: r'NetworksIdMembersGet200BodyMembersArrayModel.alias_ips',
        isHeader: isHeader,
      ),
      subnet: _$values[r'subnet'].decodeSimpleString(
        context: r'NetworksIdMembersGet200BodyMembersArrayModel.subnet',
      ),
    );
  }

  factory NetworksIdMembersGet200BodyMembersArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'NetworksIdMembersGet200BodyMembersArrayModel',
    );
    return NetworksIdMembersGet200BodyMembersArrayModel(
      $type: _i4.NetworksIdMembersGet200BodyMembersArrayTypeModel.fromJson(
        _$map[r'type'],
      ),
      id: _$map[r'id'].decodeJsonInt(
        context: r'NetworksIdMembersGet200BodyMembersArrayModel.id',
      ),
      ip: _$map[r'ip'].decodeJsonString(
        context: r'NetworksIdMembersGet200BodyMembersArrayModel.ip',
      ),
      status: _i5.NetworksIdMembersGet200BodyMembersArrayStatusModel.fromJson(
        _$map[r'status'],
      ),
      aliasIps: _$map[r'alias_ips'].decodeJsonList<_i3.String>(
        context: r'NetworksIdMembersGet200BodyMembersArrayModel.alias_ips',
      ),
      subnet: _$map[r'subnet'].decodeJsonString(
        context: r'NetworksIdMembersGet200BodyMembersArrayModel.subnet',
      ),
    );
  }

  factory NetworksIdMembersGet200BodyMembersArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'type', r'id', r'ip', r'status', r'alias_ips', r'subnet'},
      listKeys: {r'alias_ips'},
      context: r'NetworksIdMembersGet200BodyMembersArrayModel',
    );
    return NetworksIdMembersGet200BodyMembersArrayModel(
      $type: _i4.NetworksIdMembersGet200BodyMembersArrayTypeModel.fromForm(
        _$values[r'type'],
        explode: explode,
      ),
      id: _$values[r'id'].decodeFormInt(
        context: r'NetworksIdMembersGet200BodyMembersArrayModel.id',
      ),
      ip: _$values[r'ip'].decodeFormString(
        context: r'NetworksIdMembersGet200BodyMembersArrayModel.ip',
      ),
      status: _i5.NetworksIdMembersGet200BodyMembersArrayStatusModel.fromForm(
        _$values[r'status'],
        explode: explode,
      ),
      aliasIps: _$values[r'alias_ips'].decodeFormStringList(
        context: r'NetworksIdMembersGet200BodyMembersArrayModel.alias_ips',
      ),
      subnet: _$values[r'subnet'].decodeFormString(
        context: r'NetworksIdMembersGet200BodyMembersArrayModel.subnet',
      ),
    );
  }

  /// Type of the resource attached to the [Network](#tag/networks).
  ///
  final _i4.NetworksIdMembersGet200BodyMembersArrayTypeModel $type;

  /// ID of the attached resource.
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  /// IP address of the resource within the [Network](#tag/networks).
  ///
  /// **Example**:
  /// ```
  /// 10.0.1.2
  /// ```
  final _i3.String ip;

  /// Status of the resource within the [Network](#tag/networks).
  ///
  final _i5.NetworksIdMembersGet200BodyMembersArrayStatusModel status;

  /// Additional IP addresses of the resource within the [Network](#tag/networks).
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   "10.0.1.20"
  /// ]
  /// ```
  final _i3.List<_i3.String> aliasIps;

  /// IP range of the subnet the resource is attached to.
  ///
  /// Uses CIDR notation.
  ///
  ///
  /// **Example**:
  /// ```
  /// 10.0.1.0/24
  /// ```
  final _i3.String subnet;

  @_i3.override
  _i3.Object? toJson() => {
    r'type': this.$type.toJson(),
    r'id': this.id,
    r'ip': this.ip,
    r'status': this.status.toJson(),
    r'alias_ips': this.aliasIps,
    r'subnet': this.subnet,
  };

  NetworksIdMembersGet200BodyMembersArrayModel Function({
    _i4.NetworksIdMembersGet200BodyMembersArrayTypeModel? $type,
    _i3.int? id,
    _i3.String? ip,
    _i5.NetworksIdMembersGet200BodyMembersArrayStatusModel? status,
    _i3.List<_i3.String>? aliasIps,
    _i3.String? subnet,
  })
  get copyWith {
    return ({
      _i4.NetworksIdMembersGet200BodyMembersArrayTypeModel? $type,
      _i3.int? id,
      _i3.String? ip,
      _i5.NetworksIdMembersGet200BodyMembersArrayStatusModel? status,
      _i3.List<_i3.String>? aliasIps,
      _i3.String? subnet,
    }) => NetworksIdMembersGet200BodyMembersArrayModel(
      $type: $type ?? this.$type,
      id: id ?? this.id,
      ip: ip ?? this.ip,
      status: status ?? this.status,
      aliasIps: aliasIps ?? this.aliasIps,
      subnet: subnet ?? this.subnet,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is NetworksIdMembersGet200BodyMembersArrayModel &&
        other.$type == this.$type &&
        other.id == this.id &&
        other.ip == this.ip &&
        other.status == this.status &&
        _$deepEquals.equals(other.aliasIps, this.aliasIps) &&
        other.subnet == this.subnet;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.$type,
      this.id,
      this.ip,
      this.status,
      deepEquals.hash(this.aliasIps),
      this.subnet,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'type'] = _i1.PropertyValue.scalar(this.$type.toJson());
    _$result[r'id'] = _i1.PropertyValue.scalar(this.id.toString());
    _$result[r'ip'] = _i1.PropertyValue.scalar(this.ip);
    _$result[r'status'] = _i1.PropertyValue.scalar(this.status.toJson());
    _$result[r'alias_ips'] = _i1.PropertyValue.array(this.aliasIps);
    _$result[r'subnet'] = _i1.PropertyValue.scalar(this.subnet);
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode NetworksIdMembersGet200BodyMembersArrayModel: complex types cannot be URI-encoded',
    );
  }
}
