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
class FirewallsPost201BodyFirewallAppliedToArrayServerModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FirewallsPost201BodyFirewallAppliedToArrayServerModel({
    required this.id,
  });

  factory FirewallsPost201BodyFirewallAppliedToArrayServerModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'id'},
      listKeys: {},
      context: r'FirewallsPost201BodyFirewallAppliedToArrayServerModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return FirewallsPost201BodyFirewallAppliedToArrayServerModel(
      id: _$values[r'id'].decodeSimpleInt(
        context: r'FirewallsPost201BodyFirewallAppliedToArrayServerModel.id',
      ),
    );
  }

  factory FirewallsPost201BodyFirewallAppliedToArrayServerModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'FirewallsPost201BodyFirewallAppliedToArrayServerModel',
    );
    return FirewallsPost201BodyFirewallAppliedToArrayServerModel(
      id: _$map[r'id'].decodeJsonInt(
        context: r'FirewallsPost201BodyFirewallAppliedToArrayServerModel.id',
      ),
    );
  }

  factory FirewallsPost201BodyFirewallAppliedToArrayServerModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'id'},
      listKeys: {},
      context: r'FirewallsPost201BodyFirewallAppliedToArrayServerModel',
    );
    return FirewallsPost201BodyFirewallAppliedToArrayServerModel(
      id: _$values[r'id'].decodeFormInt(
        context: r'FirewallsPost201BodyFirewallAppliedToArrayServerModel.id',
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

  FirewallsPost201BodyFirewallAppliedToArrayServerModel Function({_i3.int? id})
  get copyWith {
    return ({_i3.int? id}) =>
        FirewallsPost201BodyFirewallAppliedToArrayServerModel(
          id: id ?? this.id,
        );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is FirewallsPost201BodyFirewallAppliedToArrayServerModel &&
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
      r'Cannot uriEncode FirewallsPost201BodyFirewallAppliedToArrayServerModel: complex types cannot be URI-encoded',
    );
  }
}
