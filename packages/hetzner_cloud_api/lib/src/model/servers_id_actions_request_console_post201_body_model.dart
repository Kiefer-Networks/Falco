// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_request_console_post201_body_action_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersIdActionsRequestConsolePost201BodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdActionsRequestConsolePost201BodyModel({
    required this.wssUrl,
    required this.password,
    required this.action,
  });

  factory ServersIdActionsRequestConsolePost201BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServersIdActionsRequestConsolePost201BodyModel: contains complex types',
    );
  }

  factory ServersIdActionsRequestConsolePost201BodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ServersIdActionsRequestConsolePost201BodyModel',
    );
    return ServersIdActionsRequestConsolePost201BodyModel(
      wssUrl: _$map[r'wss_url'].decodeJsonString(
        context: r'ServersIdActionsRequestConsolePost201BodyModel.wss_url',
      ),
      password: _$map[r'password'].decodeJsonString(
        context: r'ServersIdActionsRequestConsolePost201BodyModel.password',
      ),
      action: _i4.ServersIdActionsRequestConsolePost201BodyActionModel.fromJson(
        _$map[r'action'],
      ),
    );
  }

  factory ServersIdActionsRequestConsolePost201BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServersIdActionsRequestConsolePost201BodyModel: contains complex types',
    );
  }

  /// URL of websocket proxy to use; this includes a token which is valid for a limited time only.
  ///
  /// **Example**:
  /// ```
  /// wss://console.hetzner.cloud/?server_id=1&token=3db32d15-af2f-459c-8bf8-dee1fd05f49c
  /// ```
  final _i3.String wssUrl;

  /// VNC password to use for this connection (this password only works in combination with a wss_url with valid token).
  ///
  /// **Example**:
  /// ```
  /// 9MQaTg2VAGI0FIpc10k3UpRXcHj2wQ6x
  /// ```
  final _i3.String password;

  final _i4.ServersIdActionsRequestConsolePost201BodyActionModel action;

  @_i3.override
  _i3.Object? toJson() => {
    r'wss_url': this.wssUrl,
    r'password': this.password,
    r'action': this.action.toJson(),
  };

  ServersIdActionsRequestConsolePost201BodyModel Function({
    _i3.String? wssUrl,
    _i3.String? password,
    _i4.ServersIdActionsRequestConsolePost201BodyActionModel? action,
  })
  get copyWith {
    return ({
      _i3.String? wssUrl,
      _i3.String? password,
      _i4.ServersIdActionsRequestConsolePost201BodyActionModel? action,
    }) => ServersIdActionsRequestConsolePost201BodyModel(
      wssUrl: wssUrl ?? this.wssUrl,
      password: password ?? this.password,
      action: action ?? this.action,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersIdActionsRequestConsolePost201BodyModel &&
        other.wssUrl == this.wssUrl &&
        other.password == this.password &&
        other.action == this.action;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.wssUrl, this.password, this.action]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServersIdActionsRequestConsolePost201BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServersIdActionsRequestConsolePost201BodyModel: complex types cannot be URI-encoded',
    );
  }
}
