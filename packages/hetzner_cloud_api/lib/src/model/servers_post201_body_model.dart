// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i8;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i7;
import 'package:hetzner_cloud_api/src/model/servers_post201_body_action_model.dart'
    as _i5;
import 'package:hetzner_cloud_api/src/model/servers_post201_body_next_actions_array_model.dart'
    as _i6;
import 'package:hetzner_cloud_api/src/model/servers_post201_body_server_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersPost201BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersPost201BodyModel({
    required this.server,
    required this.action,
    required this.nextActions,
    required this.rootPassword,
  });

  factory ServersPost201BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServersPost201BodyModel: contains complex types',
    );
  }

  factory ServersPost201BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ServersPost201BodyModel');
    return ServersPost201BodyModel(
      server: _i4.ServersPost201BodyServerModel.fromJson(_$map[r'server']),
      action: _i5.ServersPost201BodyActionModel.fromJson(_$map[r'action']),
      nextActions: _$map[r'next_actions']
          .decodeJsonList<_i3.Object?>(
            context: r'ServersPost201BodyModel.next_actions',
          )
          .map(_i6.ServersPost201BodyNextActionsArrayModel.fromJson)
          .toList(),
      rootPassword: _$map[r'root_password'].decodeJsonNullableString(
        context: r'ServersPost201BodyModel.root_password',
      ),
    );
  }

  factory ServersPost201BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServersPost201BodyModel: contains complex types',
    );
  }

  final _i4.ServersPost201BodyServerModel server;

  final _i5.ServersPost201BodyActionModel action;

  final _i3.List<_i6.ServersPost201BodyNextActionsArrayModel> nextActions;

  /// Root password when no SSH keys have been specified.
  ///
  /// **Example**:
  /// ```
  /// YItygq1v3GYjjMomLaKc
  /// ```
  final _i3.String? rootPassword;

  @_i3.override
  _i3.Object? toJson() => {
    r'server': this.server.toJson(),
    r'action': this.action.toJson(),
    r'next_actions': this.nextActions.map((e) => e.toJson()).toList(),
    r'root_password': this.rootPassword,
  };

  ServersPost201BodyModel Function({
    _i4.ServersPost201BodyServerModel? server,
    _i5.ServersPost201BodyActionModel? action,
    _i3.List<_i6.ServersPost201BodyNextActionsArrayModel>? nextActions,
    _i3.String? rootPassword,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i4.ServersPost201BodyServerModel? server,
      _i5.ServersPost201BodyActionModel? action,
      _i3.List<_i6.ServersPost201BodyNextActionsArrayModel>? nextActions,
      _i3.Object? rootPassword = _sentinel,
    }) => ServersPost201BodyModel(
      server: server ?? this.server,
      action: action ?? this.action,
      nextActions: nextActions ?? this.nextActions,
      rootPassword: _i3.identical(rootPassword, _sentinel)
          ? this.rootPassword
          : (rootPassword as _i3.String?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i7.DeepCollectionEquality();
    return other is ServersPost201BodyModel &&
        other.server == this.server &&
        other.action == this.action &&
        _$deepEquals.equals(other.nextActions, this.nextActions) &&
        other.rootPassword == this.rootPassword;
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i7.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.server,
      this.action,
      deepEquals.hash(this.nextActions),
      this.rootPassword,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServersPost201BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i8.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServersPost201BodyModel: complex types cannot be URI-encoded',
    );
  }
}
