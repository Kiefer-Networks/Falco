// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersIdActionsChangeAliasIpsPostBodyBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdActionsChangeAliasIpsPostBodyBodyModel({
    required this.network,
    required this.aliasIps,
  });

  factory ServersIdActionsChangeAliasIpsPostBodyBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'network', r'alias_ips'},
      listKeys: {r'alias_ips'},
      context: r'ServersIdActionsChangeAliasIpsPostBodyBodyModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return ServersIdActionsChangeAliasIpsPostBodyBodyModel(
      network: _$values[r'network'].decodeSimpleInt(
        context: r'ServersIdActionsChangeAliasIpsPostBodyBodyModel.network',
      ),
      aliasIps: _$values[r'alias_ips'].decodeSimpleStringList(
        context: r'ServersIdActionsChangeAliasIpsPostBodyBodyModel.alias_ips',
        isHeader: isHeader,
      ),
    );
  }

  factory ServersIdActionsChangeAliasIpsPostBodyBodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ServersIdActionsChangeAliasIpsPostBodyBodyModel',
    );
    return ServersIdActionsChangeAliasIpsPostBodyBodyModel(
      network: _$map[r'network'].decodeJsonInt(
        context: r'ServersIdActionsChangeAliasIpsPostBodyBodyModel.network',
      ),
      aliasIps: _$map[r'alias_ips'].decodeJsonList<_i3.String>(
        context: r'ServersIdActionsChangeAliasIpsPostBodyBodyModel.alias_ips',
      ),
    );
  }

  factory ServersIdActionsChangeAliasIpsPostBodyBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'network', r'alias_ips'},
      listKeys: {r'alias_ips'},
      context: r'ServersIdActionsChangeAliasIpsPostBodyBodyModel',
    );
    return ServersIdActionsChangeAliasIpsPostBodyBodyModel(
      network: _$values[r'network'].decodeFormInt(
        context: r'ServersIdActionsChangeAliasIpsPostBodyBodyModel.network',
      ),
      aliasIps: _$values[r'alias_ips'].decodeFormStringList(
        context: r'ServersIdActionsChangeAliasIpsPostBodyBodyModel.alias_ips',
      ),
    );
  }

  /// ID of an existing Network already attached to the Server.
  ///
  /// **Example**:
  /// ```json
  /// 4711
  /// ```
  final _i3.int network;

  /// New alias IPs to set for this Server.
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   "10.0.1.2"
  /// ]
  /// ```
  final _i3.List<_i3.String> aliasIps;

  @_i3.override
  _i3.Object? toJson() => {
    r'network': this.network,
    r'alias_ips': this.aliasIps,
  };

  ServersIdActionsChangeAliasIpsPostBodyBodyModel Function({
    _i3.int? network,
    _i3.List<_i3.String>? aliasIps,
  })
  get copyWith {
    return ({_i3.int? network, _i3.List<_i3.String>? aliasIps}) =>
        ServersIdActionsChangeAliasIpsPostBodyBodyModel(
          network: network ?? this.network,
          aliasIps: aliasIps ?? this.aliasIps,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is ServersIdActionsChangeAliasIpsPostBodyBodyModel &&
        other.network == this.network &&
        _$deepEquals.equals(other.aliasIps, this.aliasIps);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([this.network, deepEquals.hash(this.aliasIps)]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'network'] = _i1.PropertyValue.scalar(this.network.toString());
    _$result[r'alias_ips'] = _i1.PropertyValue.array(this.aliasIps);
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
      r'Cannot uriEncode ServersIdActionsChangeAliasIpsPostBodyBodyModel: complex types cannot be URI-encoded',
    );
  }
}
