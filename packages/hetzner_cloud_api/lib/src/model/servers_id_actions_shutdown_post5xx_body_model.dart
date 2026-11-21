// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_shutdown_post5xx_body_error_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// **Example**:
/// ```json
/// {
///   "error": {
///     "code": "timeout",
///     "message": "request timeout",
///     "details": null
///   }
/// }
/// ```
@_i2.immutable
class ServersIdActionsShutdownPost5xxBodyModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdActionsShutdownPost5xxBodyModel({required this.error});

  factory ServersIdActionsShutdownPost5xxBodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServersIdActionsShutdownPost5xxBodyModel: contains complex types',
    );
  }

  factory ServersIdActionsShutdownPost5xxBodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'ServersIdActionsShutdownPost5xxBodyModel',
    );
    return ServersIdActionsShutdownPost5xxBodyModel(
      error: _i4.ServersIdActionsShutdownPost5xxBodyErrorModel.fromJson(
        _$map[r'error'],
      ),
    );
  }

  factory ServersIdActionsShutdownPost5xxBodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServersIdActionsShutdownPost5xxBodyModel: contains complex types',
    );
  }

  final _i4.ServersIdActionsShutdownPost5xxBodyErrorModel error;

  @_i3.override
  _i3.Object? toJson() => {r'error': this.error.toJson()};

  ServersIdActionsShutdownPost5xxBodyModel Function({
    _i4.ServersIdActionsShutdownPost5xxBodyErrorModel? error,
  })
  get copyWith {
    return ({_i4.ServersIdActionsShutdownPost5xxBodyErrorModel? error}) =>
        ServersIdActionsShutdownPost5xxBodyModel(error: error ?? this.error);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersIdActionsShutdownPost5xxBodyModel &&
        other.error == this.error;
  }

  @_i3.override
  _i3.int get hashCode => this.error.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServersIdActionsShutdownPost5xxBodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServersIdActionsShutdownPost5xxBodyModel: complex types cannot be URI-encoded',
    );
  }
}
