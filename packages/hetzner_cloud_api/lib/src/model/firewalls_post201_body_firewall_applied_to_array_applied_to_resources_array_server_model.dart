// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// [Server](#tag/servers) the [Firewall](#tag/firewalls) is applied to.
///
/// Only set for `type` `server`, otherwise `null`.
///
@_i2.immutable
class FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel({
    required this.id,
  });

  factory FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'id'},
      listKeys: {},
      context: r'FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel(
      id: _$values[r'id'].decodeSimpleInt(
        context: r'FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel.id',
      ),
    );
  }

  factory FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel',
    );
    return FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel.id',
      ),
    );
  }

  factory FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'id'},
      listKeys: {},
      context: r'FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel',
    );
    return FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel(
      id: _$values[r'id'].decodeFormInt(
        context: r'FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel.id',
      ),
    );
  }

  /// ID of the [Server](#tag/servers).
  ///
  /// **Example**:
  /// ```json
  /// 42
  /// ```
  final _i3.int id;

  @_i3.override
  _i3.Object? toJson() => {r'id': this.id};

  FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel
  Function({_i3.int? id})
  get copyWith {
    return ({_i3.int? id}) =>
        FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel(
          id: id ?? this.id,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other
            is FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel &&
        other.id == this.id;
  }

  @_i3.override
  _i3.int get hashCode => this.id.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'id'] = _i1.PropertyValue.scalar(this.id.toString());
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FirewallsPost201BodyFirewallAppliedToArrayAppliedToResourcesArrayServerModel: complex types cannot be URI-encoded',
    );
  }
}
