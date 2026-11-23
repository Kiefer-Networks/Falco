// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/firewalls_id_actions_set_rules_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/firewalls_id_actions_set_rules_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/firewalls_id_actions_set_rules_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class SetFirewallRulesResponse {
  const SetFirewallRulesResponse();
}

@_i1.immutable
class SetFirewallRulesResponse201 extends SetFirewallRulesResponse {
  const SetFirewallRulesResponse201({required this.body});

  final _i2.FirewallsIdActionsSetRulesPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetFirewallRulesResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class SetFirewallRulesResponse4XX extends SetFirewallRulesResponse {
  const SetFirewallRulesResponse4XX({required this.body});

  final _i4.FirewallsIdActionsSetRulesPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetFirewallRulesResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class SetFirewallRulesResponse5XX extends SetFirewallRulesResponse {
  const SetFirewallRulesResponse5XX({required this.body});

  final _i5.FirewallsIdActionsSetRulesPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is SetFirewallRulesResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
