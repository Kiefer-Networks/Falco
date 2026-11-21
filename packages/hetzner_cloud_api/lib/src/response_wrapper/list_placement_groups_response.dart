// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/placement_groups_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/placement_groups_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/placement_groups_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListPlacementGroupsResponse {
  const ListPlacementGroupsResponse();
}

@_i1.immutable
class ListPlacementGroupsResponse200 extends ListPlacementGroupsResponse {
  const ListPlacementGroupsResponse200({required this.body});

  final _i2.PlacementGroupsGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPlacementGroupsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListPlacementGroupsResponse4XX extends ListPlacementGroupsResponse {
  const ListPlacementGroupsResponse4XX({required this.body});

  final _i4.PlacementGroupsGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPlacementGroupsResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListPlacementGroupsResponse5XX extends ListPlacementGroupsResponse {
  const ListPlacementGroupsResponse5XX({required this.body});

  final _i5.PlacementGroupsGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListPlacementGroupsResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
