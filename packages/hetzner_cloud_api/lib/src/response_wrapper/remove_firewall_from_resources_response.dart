// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/firewalls_id_actions_remove_from_resources_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/firewalls_id_actions_remove_from_resources_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/firewalls_id_actions_remove_from_resources_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class RemoveFirewallFromResourcesResponse {
  const RemoveFirewallFromResourcesResponse();
}

@_i1.immutable
class RemoveFirewallFromResourcesResponse201
    extends RemoveFirewallFromResourcesResponse {
  const RemoveFirewallFromResourcesResponse201({required this.body});

  final _i2.FirewallsIdActionsRemoveFromResourcesPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFirewallFromResourcesResponse201 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class RemoveFirewallFromResourcesResponse4XX
    extends RemoveFirewallFromResourcesResponse {
  const RemoveFirewallFromResourcesResponse4XX({required this.body});

  final _i4.FirewallsIdActionsRemoveFromResourcesPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFirewallFromResourcesResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class RemoveFirewallFromResourcesResponse5XX
    extends RemoveFirewallFromResourcesResponse {
  const RemoveFirewallFromResourcesResponse5XX({required this.body});

  final _i5.FirewallsIdActionsRemoveFromResourcesPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is RemoveFirewallFromResourcesResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
