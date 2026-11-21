// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i7;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i6;
import 'package:hetzner_cloud_api/src/model/firewalls_post201_body_actions_array_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/firewalls_post201_body_firewall_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FirewallsPost201BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FirewallsPost201BodyModel({this.firewall, this.actions});

  factory FirewallsPost201BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for FirewallsPost201BodyModel: contains complex types',
    );
  }

  factory FirewallsPost201BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'FirewallsPost201BodyModel');
    return FirewallsPost201BodyModel(
      firewall: _$map[r'firewall'] == null
          ? null
          : _i4.FirewallsPost201BodyFirewallModel.fromJson(_$map[r'firewall']),
      actions: _$map[r'actions']
          .decodeJsonNullableList<_i3.Object?>(
            context: r'FirewallsPost201BodyModel.actions',
          )
          ?.map(_i5.FirewallsPost201BodyActionsArrayModel.fromJson)
          .toList(),
    );
  }

  factory FirewallsPost201BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for FirewallsPost201BodyModel: contains complex types',
    );
  }

  final _i4.FirewallsPost201BodyFirewallModel? firewall;

  /// **Example**:
  /// ```json
  /// [
  ///   {
  ///     "id": 13,
  ///     "command": "set_firewall_rules",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": "2016-01-30T23:56:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 38,
  ///         "type": "firewall"
  ///       }
  ///     ],
  ///     "error": {
  ///       "code": "action_failed",
  ///       "message": "Action failed"
  ///     }
  ///   },
  ///   {
  ///     "id": 14,
  ///     "command": "apply_firewall",
  ///     "status": "success",
  ///     "progress": 100,
  ///     "started": "2016-01-30T23:55:00Z",
  ///     "finished": "2016-01-30T23:56:00Z",
  ///     "resources": [
  ///       {
  ///         "id": 42,
  ///         "type": "server"
  ///       },
  ///       {
  ///         "id": 38,
  ///         "type": "firewall"
  ///       }
  ///     ],
  ///     "error": {
  ///       "code": "action_failed",
  ///       "message": "Action failed"
  ///     }
  ///   }
  /// ]
  /// ```
  final _i3.List<_i5.FirewallsPost201BodyActionsArrayModel>? actions;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.firewall != null) r'firewall': this.firewall?.toJson(),
    if (this.actions != null)
      r'actions': this.actions?.map((e) => e.toJson()).toList(),
  };

  FirewallsPost201BodyModel Function({
    _i4.FirewallsPost201BodyFirewallModel? firewall,
    _i3.List<_i5.FirewallsPost201BodyActionsArrayModel>? actions,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? firewall = _sentinel,
      _i3.Object? actions = _sentinel,
    }) => FirewallsPost201BodyModel(
      firewall: _i3.identical(firewall, _sentinel)
          ? this.firewall
          : (firewall as _i4.FirewallsPost201BodyFirewallModel?),
      actions: _i3.identical(actions, _sentinel)
          ? this.actions
          : (actions as _i3.List<_i5.FirewallsPost201BodyActionsArrayModel>?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i6.DeepCollectionEquality();
    return other is FirewallsPost201BodyModel &&
        other.firewall == this.firewall &&
        _$deepEquals.equals(other.actions, this.actions);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i6.DeepCollectionEquality();
    return _i3.Object.hashAll([this.firewall, deepEquals.hash(this.actions)]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for FirewallsPost201BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i7.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FirewallsPost201BodyModel: complex types cannot be URI-encoded',
    );
  }
}
