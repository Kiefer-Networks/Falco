// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_enable_backup_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_enable_backup_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_enable_backup_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class EnableServerBackupResponse {
  const EnableServerBackupResponse();
}

@_i1.immutable
class EnableServerBackupResponse201 extends EnableServerBackupResponse {
  const EnableServerBackupResponse201({required this.body});

  final _i2.ServersIdActionsEnableBackupPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnableServerBackupResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class EnableServerBackupResponse4XX extends EnableServerBackupResponse {
  const EnableServerBackupResponse4XX({required this.body});

  final _i4.ServersIdActionsEnableBackupPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnableServerBackupResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class EnableServerBackupResponse5XX extends EnableServerBackupResponse {
  const EnableServerBackupResponse5XX({required this.body});

  final _i5.ServersIdActionsEnableBackupPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is EnableServerBackupResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
