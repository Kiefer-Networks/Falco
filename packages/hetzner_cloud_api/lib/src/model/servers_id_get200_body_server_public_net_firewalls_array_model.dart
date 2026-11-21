// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_get200_body_server_public_net_firewalls_array_status_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersIdGet200BodyServerPublicNetFirewallsArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdGet200BodyServerPublicNetFirewallsArrayModel({
    this.id,
    this.status,
  });

  factory ServersIdGet200BodyServerPublicNetFirewallsArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'id', r'status'},
      listKeys: {},
      context: r'ServersIdGet200BodyServerPublicNetFirewallsArrayModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ServersIdGet200BodyServerPublicNetFirewallsArrayModel(
      id: _$values[r'id'].decodeSimpleNullableInt(
        context: r'ServersIdGet200BodyServerPublicNetFirewallsArrayModel.id',
      ),
      status: _$values[r'status'] == null
          ? null
          : _i4.ServersIdGet200BodyServerPublicNetFirewallsArrayStatusModel.fromSimple(
              _$values[r'status'],
              explode: explode,
            ),
    );
  }

  factory ServersIdGet200BodyServerPublicNetFirewallsArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ServersIdGet200BodyServerPublicNetFirewallsArrayModel',
    );
    return ServersIdGet200BodyServerPublicNetFirewallsArrayModel(
      id: _$map[r'id'].decodeJsonNullableInt(
        context: r'ServersIdGet200BodyServerPublicNetFirewallsArrayModel.id',
      ),
      status: _$map[r'status'] == null
          ? null
          : _i4.ServersIdGet200BodyServerPublicNetFirewallsArrayStatusModel.fromJson(
              _$map[r'status'],
            ),
    );
  }

  factory ServersIdGet200BodyServerPublicNetFirewallsArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'id', r'status'},
      listKeys: {},
      context: r'ServersIdGet200BodyServerPublicNetFirewallsArrayModel',
    );
    return ServersIdGet200BodyServerPublicNetFirewallsArrayModel(
      id: _$values[r'id'].decodeFormNullableInt(
        context: r'ServersIdGet200BodyServerPublicNetFirewallsArrayModel.id',
      ),
      status: _$values[r'status'] == null
          ? null
          : _i4.ServersIdGet200BodyServerPublicNetFirewallsArrayStatusModel.fromForm(
              _$values[r'status'],
              explode: explode,
            ),
    );
  }

  /// ID of the [Firewall](#tag/firewalls).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int? id;

  /// Status of the Firewall on the Server.
  ///
  /// **Example**:
  /// ```
  /// applied
  /// ```
  final _i4.ServersIdGet200BodyServerPublicNetFirewallsArrayStatusModel? status;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.id != null) r'id': this.id,
    if (this.status != null) r'status': this.status?.toJson(),
  };

  ServersIdGet200BodyServerPublicNetFirewallsArrayModel Function({
    _i3.int? id,
    _i4.ServersIdGet200BodyServerPublicNetFirewallsArrayStatusModel? status,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? id = _sentinel,
      _i3.Object? status = _sentinel,
    }) => ServersIdGet200BodyServerPublicNetFirewallsArrayModel(
      id: _i3.identical(id, _sentinel) ? this.id : (id as _i3.int?),
      status: _i3.identical(status, _sentinel)
          ? this.status
          : (status
                as _i4.ServersIdGet200BodyServerPublicNetFirewallsArrayStatusModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersIdGet200BodyServerPublicNetFirewallsArrayModel &&
        other.id == this.id &&
        other.status == this.status;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.id, this.status]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    if (this.id != null) {
      _$result[r'id'] = _i1.PropertyValue.scalar(this.id!.toString());
    }
    if (this.status != null) {
      _$result[r'status'] = _i1.PropertyValue.scalar(this.status!.toJson());
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
      r'Cannot uriEncode ServersIdGet200BodyServerPublicNetFirewallsArrayModel: complex types cannot be URI-encoded',
    );
  }
}
