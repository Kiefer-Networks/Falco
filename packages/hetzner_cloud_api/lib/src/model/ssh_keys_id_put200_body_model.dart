// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/ssh_keys_id_put200_body_ssh_key_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class SshKeysIdPut200BodyModel extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const SshKeysIdPut200BodyModel({required this.sshKey});

  factory SshKeysIdPut200BodyModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for SshKeysIdPut200BodyModel: contains complex types',
    );
  }

  factory SshKeysIdPut200BodyModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(context: r'SshKeysIdPut200BodyModel');
    return SshKeysIdPut200BodyModel(
      sshKey: _i4.SshKeysIdPut200BodySshKeyModel.fromJson(_$map[r'ssh_key']),
    );
  }

  factory SshKeysIdPut200BodyModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for SshKeysIdPut200BodyModel: contains complex types',
    );
  }

  final _i4.SshKeysIdPut200BodySshKeyModel sshKey;

  @_i3.override
  _i3.Object? toJson() => {r'ssh_key': this.sshKey.toJson()};

  SshKeysIdPut200BodyModel Function({
    _i4.SshKeysIdPut200BodySshKeyModel? sshKey,
  })
  get copyWith {
    return ({_i4.SshKeysIdPut200BodySshKeyModel? sshKey}) =>
        SshKeysIdPut200BodyModel(sshKey: sshKey ?? this.sshKey);
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SshKeysIdPut200BodyModel && other.sshKey == this.sshKey;
  }

  @_i3.override
  _i3.int get hashCode => this.sshKey.hashCode;

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for SshKeysIdPut200BodyModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode SshKeysIdPut200BodyModel: complex types cannot be URI-encoded',
    );
  }
}
