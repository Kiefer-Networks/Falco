// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_remove_from_placement_group_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_remove_from_placement_group_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_remove_from_placement_group_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class RemoveServerFromPlacementGroupResponse {
  const RemoveServerFromPlacementGroupResponse();
}

@_i1.immutable
class RemoveServerFromPlacementGroupResponse201
    extends RemoveServerFromPlacementGroupResponse {
  const RemoveServerFromPlacementGroupResponse201({required this.body});

  final _i2.ServersIdActionsRemoveFromPlacementGroupPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveServerFromPlacementGroupResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class RemoveServerFromPlacementGroupResponse4XX
    extends RemoveServerFromPlacementGroupResponse {
  const RemoveServerFromPlacementGroupResponse4XX({required this.body});

  final _i4.ServersIdActionsRemoveFromPlacementGroupPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveServerFromPlacementGroupResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class RemoveServerFromPlacementGroupResponse5XX
    extends RemoveServerFromPlacementGroupResponse {
  const RemoveServerFromPlacementGroupResponse5XX({required this.body});

  final _i5.ServersIdActionsRemoveFromPlacementGroupPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveServerFromPlacementGroupResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
