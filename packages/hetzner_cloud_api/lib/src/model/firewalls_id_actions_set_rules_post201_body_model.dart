// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/firewalls_id_actions_set_rules_post201_body_actions_array_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class FirewallsIdActionsSetRulesPost201BodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const FirewallsIdActionsSetRulesPost201BodyModel({required this.actions});

  factory FirewallsIdActionsSetRulesPost201BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for FirewallsIdActionsSetRulesPost201BodyModel: contains complex types',
    );
  }

  factory FirewallsIdActionsSetRulesPost201BodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'FirewallsIdActionsSetRulesPost201BodyModel',
    );
    return FirewallsIdActionsSetRulesPost201BodyModel(
      actions: _$map[r'actions']
          .decodeJsonList<_i3.Object?>(
            context: r'FirewallsIdActionsSetRulesPost201BodyModel.actions',
          )
          .map(
            _i4.FirewallsIdActionsSetRulesPost201BodyActionsArrayModel.fromJson,
          )
          .toList(),
    );
  }

  factory FirewallsIdActionsSetRulesPost201BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for FirewallsIdActionsSetRulesPost201BodyModel: contains complex types',
    );
  }

  final _i3.List<_i4.FirewallsIdActionsSetRulesPost201BodyActionsArrayModel>
  actions;

  @_i3.override
  _i3.Object? toJson() => {
    r'actions': this.actions.map((e) => e.toJson()).toList(),
  };

  FirewallsIdActionsSetRulesPost201BodyModel Function({
    _i3.List<_i4.FirewallsIdActionsSetRulesPost201BodyActionsArrayModel>?
    actions,
  })
  get copyWith {
    return ({
      _i3.List<_i4.FirewallsIdActionsSetRulesPost201BodyActionsArrayModel>?
      actions,
    }) => FirewallsIdActionsSetRulesPost201BodyModel(
      actions: actions ?? this.actions,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is FirewallsIdActionsSetRulesPost201BodyModel &&
        _$deepEquals.equals(other.actions, this.actions);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return deepEquals.hash(this.actions);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for FirewallsIdActionsSetRulesPost201BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode FirewallsIdActionsSetRulesPost201BodyModel: complex types cannot be URI-encoded',
    );
  }
}
