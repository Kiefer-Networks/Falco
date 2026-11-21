// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_get200_body_server_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersIdGet200BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdGet200BodyModel({this.server});

  factory ServersIdGet200BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServersIdGet200BodyModel: contains complex types',
    );
  }

  factory ServersIdGet200BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'ServersIdGet200BodyModel');
    return ServersIdGet200BodyModel(
      server: _$map[r'server'] == null
          ? null
          : _i4.ServersIdGet200BodyServerModel.fromJson(_$map[r'server']),
    );
  }

  factory ServersIdGet200BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServersIdGet200BodyModel: contains complex types',
    );
  }

  final _i4.ServersIdGet200BodyServerModel? server;

  @_i3.override
  _i3.Object? toJson() => {
    if (this.server != null) r'server': this.server?.toJson(),
  };

  ServersIdGet200BodyModel Function({
    _i4.ServersIdGet200BodyServerModel? server,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({_i3.Object? server = _sentinel}) => ServersIdGet200BodyModel(
      server: _i3.identical(server, _sentinel)
          ? this.server
          : (server as _i4.ServersIdGet200BodyServerModel?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ServersIdGet200BodyModel && other.server == this.server;
  }

  @_i3.override
  _i3.int get hashCode => this.server.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServersIdGet200BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServersIdGet200BodyModel: complex types cannot be URI-encoded',
    );
  }
}
