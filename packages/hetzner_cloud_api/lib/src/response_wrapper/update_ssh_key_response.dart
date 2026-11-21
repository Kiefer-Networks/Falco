// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/ssh_keys_id_put200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/ssh_keys_id_put4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/ssh_keys_id_put5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class UpdateSshKeyResponse {
  const UpdateSshKeyResponse();
}

@_i1.immutable
class UpdateSshKeyResponse200 extends UpdateSshKeyResponse {
  const UpdateSshKeyResponse200({required this.body});

  final _i2.SshKeysIdPut200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateSshKeyResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdateSshKeyResponse4XX extends UpdateSshKeyResponse {
  const UpdateSshKeyResponse4XX({required this.body});

  final _i4.SshKeysIdPut4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateSshKeyResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdateSshKeyResponse5XX extends UpdateSshKeyResponse {
  const UpdateSshKeyResponse5XX({required this.body});

  final _i5.SshKeysIdPut5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateSshKeyResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
