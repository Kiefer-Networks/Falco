// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/ssh_keys_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/ssh_keys_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/ssh_keys_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListSshKeysResponse {
  const ListSshKeysResponse();
}

@_i1.immutable
class ListSshKeysResponse200 extends ListSshKeysResponse {
  const ListSshKeysResponse200({required this.body});

  final _i2.SshKeysGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListSshKeysResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListSshKeysResponse4XX extends ListSshKeysResponse {
  const ListSshKeysResponse4XX({required this.body});

  final _i4.SshKeysGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListSshKeysResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListSshKeysResponse5XX extends ListSshKeysResponse {
  const ListSshKeysResponse5XX({required this.body});

  final _i5.SshKeysGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListSshKeysResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
