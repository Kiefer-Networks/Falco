// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/firewalls_get200_body_firewalls_array_applied_to_array_applied_to_resources_array_server_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/firewalls_get200_body_firewalls_array_applied_to_array_applied_to_resources_array_type_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayModel({
    this.$type,
    this.server,
  });

  factory FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayModel: contains complex types',
    );
  }

  factory FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayModel',
    );
    return FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayModel(
      $type: _$map[r'type'] == null
          ? null
          : _i4.FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayTypeModel.fromJson(
              _$map[r'type'],
            ),
      server: _$map[r'server'] == null
          ? null
          : _i5.FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayServerModel.fromJson(
              _$map[r'server'],
            ),
    );
  }

  factory FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayModel: contains complex types',
    );
  }

  /// Type of resource.
  ///
  /// **Example**:
  /// ```
  /// server
  /// ```
  final _i4.FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayTypeModel?
  $type;

  /// [Server](#tag/servers) the [Firewall](#tag/firewalls) is applied to.
  ///
  /// Only set for `type` `server`, otherwise `null`.
  ///
  final _i5.FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayServerModel?
  server;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.$type != null) r'type': this.$type?.toJson(),
    if (this.server != null) r'server': this.server?.toJson(),
  };

  FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayModel
  Function({
    _i4.FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayTypeModel?
    $type,
    _i5.FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayServerModel?
    server,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? $type = _sentinel,
      _i3.Object? server = _sentinel,
    }) => FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayModel(
      $type: _i3.identical($type, _sentinel)
          ? this.$type
          : ($type
                as _i4.FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayTypeModel?),
      server: _i3.identical(server, _sentinel)
          ? this.server
          : (server
                as _i5.FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayServerModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayModel &&
        other.$type == this.$type &&
        other.server == this.server;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.$type, this.server]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FirewallsGet200BodyFirewallsArrayAppliedToArrayAppliedToResourcesArrayModel: complex types cannot be URI-encoded',
    );
  }
}
