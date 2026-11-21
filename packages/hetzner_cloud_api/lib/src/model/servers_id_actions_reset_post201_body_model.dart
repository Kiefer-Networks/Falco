// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_reset_post201_body_action_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Response for a created [Action](#description/actions).
///
/// Make sure to wait for the [Action](#description/actions) completion to ensure your changes are applied.
///
@_i2.immutable
class ServersIdActionsResetPost201BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdActionsResetPost201BodyModel({required this.action});

  factory ServersIdActionsResetPost201BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServersIdActionsResetPost201BodyModel: contains complex types',
    );
  }

  factory ServersIdActionsResetPost201BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'ServersIdActionsResetPost201BodyModel',
    );
    return ServersIdActionsResetPost201BodyModel(
      action: _i4.ServersIdActionsResetPost201BodyActionModel.fromJson(
        _$map[r'action'],
      ),
    );
  }

  factory ServersIdActionsResetPost201BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServersIdActionsResetPost201BodyModel: contains complex types',
    );
  }

  final _i4.ServersIdActionsResetPost201BodyActionModel action;

  @_i3.override
  _i3.Object? toJson() => {r'action': this.action.toJson()};

  ServersIdActionsResetPost201BodyModel Function({
    _i4.ServersIdActionsResetPost201BodyActionModel? action,
  })
  get copyWith {
    return ({_i4.ServersIdActionsResetPost201BodyActionModel? action}) =>
        ServersIdActionsResetPost201BodyModel(action: action ?? this.action);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersIdActionsResetPost201BodyModel &&
        other.action == this.action;
  }

  @_i3.override
  _i3.int get hashCode => this.action.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServersIdActionsResetPost201BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServersIdActionsResetPost201BodyModel: complex types cannot be URI-encoded',
    );
  }
}
