// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/ssh_keys_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/ssh_keys_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/ssh_keys_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class CreateSshKeyResponse {
  const CreateSshKeyResponse();
}

@_i1.immutable
class CreateSshKeyResponse201 extends CreateSshKeyResponse {
  const CreateSshKeyResponse201({required this.body});

  final _i2.SshKeysPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateSshKeyResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateSshKeyResponse4XX extends CreateSshKeyResponse {
  const CreateSshKeyResponse4XX({required this.body});

  final _i4.SshKeysPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateSshKeyResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateSshKeyResponse5XX extends CreateSshKeyResponse {
  const CreateSshKeyResponse5XX({required this.body});

  final _i5.SshKeysPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateSshKeyResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
