// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_add_to_placement_group_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_add_to_placement_group_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_add_to_placement_group_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class AddServerToPlacementGroupResponse {
  const AddServerToPlacementGroupResponse();
}

@_i1.immutable
class AddServerToPlacementGroupResponse201
    extends AddServerToPlacementGroupResponse {
  const AddServerToPlacementGroupResponse201({required this.body});

  final _i2.ServersIdActionsAddToPlacementGroupPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddServerToPlacementGroupResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class AddServerToPlacementGroupResponse4XX
    extends AddServerToPlacementGroupResponse {
  const AddServerToPlacementGroupResponse4XX({required this.body});

  final _i4.ServersIdActionsAddToPlacementGroupPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddServerToPlacementGroupResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class AddServerToPlacementGroupResponse5XX
    extends AddServerToPlacementGroupResponse {
  const AddServerToPlacementGroupResponse5XX({required this.body});

  final _i5.ServersIdActionsAddToPlacementGroupPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AddServerToPlacementGroupResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
