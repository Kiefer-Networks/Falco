// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i2;

import 'package:hetzner_cloud_api/src/model/ssh_keys_id_delete4xx_body_model.dart'
    as _i3;
import 'package:hetzner_cloud_api/src/model/ssh_keys_id_delete5xx_body_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i1;

sealed class DeleteSshKeyResponse {
  const DeleteSshKeyResponse();
}

@_i1.immutable
class DeleteSshKeyResponse204 extends DeleteSshKeyResponse {
  const DeleteSshKeyResponse204();

  @_i2.override
  _i2.bool operator ==(_i2.Object other) {
    if (_i2.identical(this, other)) return true;
    return other is DeleteSshKeyResponse204;
  }

  @_i2.override
  _i2.int get hashCode => this.runtimeType.hashCode;
}

@_i1.immutable
class DeleteSshKeyResponse4XX extends DeleteSshKeyResponse {
  const DeleteSshKeyResponse4XX({required this.body});

  final _i3.SshKeysIdDelete4xxBodyModel body;

  @_i2.override
  _i2.bool operator ==(_i2.Object other) {
    if (_i2.identical(this, other)) return true;
    return other is DeleteSshKeyResponse4XX && other.body == this.body;
  }

  @_i2.override
  _i2.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeleteSshKeyResponse5XX extends DeleteSshKeyResponse {
  const DeleteSshKeyResponse5XX({required this.body});

  final _i4.SshKeysIdDelete5xxBodyModel body;

  @_i2.override
  _i2.bool operator ==(_i2.Object other) {
    if (_i2.identical(this, other)) return true;
    return other is DeleteSshKeyResponse5XX && other.body == this.body;
  }

  @_i2.override
  _i2.int get hashCode => this.body.hashCode;
}
