// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i2;

import 'package:hetzner_cloud_api/src/model/placement_groups_id_delete4xx_body_model.dart'
    as _i3;
import 'package:hetzner_cloud_api/src/model/placement_groups_id_delete5xx_body_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i1;

sealed class DeletePlacementGroupResponse {
  const DeletePlacementGroupResponse();
}

@_i1.immutable
class DeletePlacementGroupResponse204 extends DeletePlacementGroupResponse {
  const DeletePlacementGroupResponse204();

  @_i2.override
  _i2.bool operator ==(_i2.Object other) {
    if (_i2.identical(this, other)) return true;
    return other is DeletePlacementGroupResponse204;
  }

  @_i2.override
  _i2.int get hashCode => this.runtimeType.hashCode;
}

@_i1.immutable
class DeletePlacementGroupResponse4XX extends DeletePlacementGroupResponse {
  const DeletePlacementGroupResponse4XX({required this.body});

  final _i3.PlacementGroupsIdDelete4xxBodyModel body;

  @_i2.override
  _i2.bool operator ==(_i2.Object other) {
    if (_i2.identical(this, other)) return true;
    return other is DeletePlacementGroupResponse4XX && other.body == this.body;
  }

  @_i2.override
  _i2.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeletePlacementGroupResponse5XX extends DeletePlacementGroupResponse {
  const DeletePlacementGroupResponse5XX({required this.body});

  final _i4.PlacementGroupsIdDelete5xxBodyModel body;

  @_i2.override
  _i2.bool operator ==(_i2.Object other) {
    if (_i2.identical(this, other)) return true;
    return other is DeletePlacementGroupResponse5XX && other.body == this.body;
  }

  @_i2.override
  _i2.int get hashCode => this.body.hashCode;
}
