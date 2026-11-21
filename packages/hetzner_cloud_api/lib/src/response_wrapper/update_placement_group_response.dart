// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/placement_groups_id_put200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/placement_groups_id_put4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/placement_groups_id_put5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class UpdatePlacementGroupResponse {
  const UpdatePlacementGroupResponse();
}

@_i1.immutable
class UpdatePlacementGroupResponse200 extends UpdatePlacementGroupResponse {
  const UpdatePlacementGroupResponse200({required this.body});

  final _i2.PlacementGroupsIdPut200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdatePlacementGroupResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdatePlacementGroupResponse4XX extends UpdatePlacementGroupResponse {
  const UpdatePlacementGroupResponse4XX({required this.body});

  final _i4.PlacementGroupsIdPut4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdatePlacementGroupResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdatePlacementGroupResponse5XX extends UpdatePlacementGroupResponse {
  const UpdatePlacementGroupResponse5XX({required this.body});

  final _i5.PlacementGroupsIdPut5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdatePlacementGroupResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
