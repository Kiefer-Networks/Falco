// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_reset_password_post201_body_action_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// The `root_password` key in the reply contains the new root password that will be active if the Action succeeds.
///
@_i2.immutable
class ServersIdActionsResetPasswordPost201BodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdActionsResetPasswordPost201BodyModel({
    this.rootPassword,
    this.action,
  });

  factory ServersIdActionsResetPasswordPost201BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServersIdActionsResetPasswordPost201BodyModel: contains complex types',
    );
  }

  factory ServersIdActionsResetPasswordPost201BodyModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'ServersIdActionsResetPasswordPost201BodyModel',
    );
    return ServersIdActionsResetPasswordPost201BodyModel(
      rootPassword: _$map[r'root_password'].decodeJsonNullableString(
        context: r'ServersIdActionsResetPasswordPost201BodyModel.root_password',
      ),
      action: _$map[r'action'] == null
          ? null
          : _i4.ServersIdActionsResetPasswordPost201BodyActionModel.fromJson(
              _$map[r'action'],
            ),
    );
  }

  factory ServersIdActionsResetPasswordPost201BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServersIdActionsResetPasswordPost201BodyModel: contains complex types',
    );
  }

  /// Password that will be set for this Server once the Action succeeds.
  ///
  /// **Example**:
  /// ```
  /// zCWbFhnu950dUTko5f40
  /// ```
  final _i3.String? rootPassword;

  final _i4.ServersIdActionsResetPasswordPost201BodyActionModel? action;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.rootPassword != null) r'root_password': this.rootPassword,
    if (this.action != null) r'action': this.action?.toJson(),
  };

  ServersIdActionsResetPasswordPost201BodyModel Function({
    _i3.String? rootPassword,
    _i4.ServersIdActionsResetPasswordPost201BodyActionModel? action,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.Object? rootPassword = _sentinel,
      _i3.Object? action = _sentinel,
    }) => ServersIdActionsResetPasswordPost201BodyModel(
      rootPassword: _i3.identical(rootPassword, _sentinel)
          ? this.rootPassword
          : (rootPassword as _i3.String?),
      action: _i3.identical(action, _sentinel)
          ? this.action
          : (action
                as _i4.ServersIdActionsResetPasswordPost201BodyActionModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersIdActionsResetPasswordPost201BodyModel &&
        other.rootPassword == this.rootPassword &&
        other.action == this.action;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([this.rootPassword, this.action]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServersIdActionsResetPasswordPost201BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServersIdActionsResetPasswordPost201BodyModel: complex types cannot be URI-encoded',
    );
  }
}
