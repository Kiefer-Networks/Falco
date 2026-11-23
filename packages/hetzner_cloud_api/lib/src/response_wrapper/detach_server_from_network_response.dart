// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_detach_from_network_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_detach_from_network_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_detach_from_network_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class DetachServerFromNetworkResponse {
  const DetachServerFromNetworkResponse();
}

@_i1.immutable
class DetachServerFromNetworkResponse201
    extends DetachServerFromNetworkResponse {
  const DetachServerFromNetworkResponse201({required this.body});

  final _i2.ServersIdActionsDetachFromNetworkPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DetachServerFromNetworkResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DetachServerFromNetworkResponse4XX
    extends DetachServerFromNetworkResponse {
  const DetachServerFromNetworkResponse4XX({required this.body});

  final _i4.ServersIdActionsDetachFromNetworkPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DetachServerFromNetworkResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DetachServerFromNetworkResponse5XX
    extends DetachServerFromNetworkResponse {
  const DetachServerFromNetworkResponse5XX({required this.body});

  final _i5.ServersIdActionsDetachFromNetworkPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DetachServerFromNetworkResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
