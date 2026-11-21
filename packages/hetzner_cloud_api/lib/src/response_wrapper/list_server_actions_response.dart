// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/servers_id_actions_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/servers_id_actions_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListServerActionsResponse {
  const ListServerActionsResponse();
}

@_i1.immutable
class ListServerActionsResponse200 extends ListServerActionsResponse {
  const ListServerActionsResponse200({required this.body});

  final _i2.ServersIdActionsGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListServerActionsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListServerActionsResponse4XX extends ListServerActionsResponse {
  const ListServerActionsResponse4XX({required this.body});

  final _i4.ServersIdActionsGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListServerActionsResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListServerActionsResponse5XX extends ListServerActionsResponse {
  const ListServerActionsResponse5XX({required this.body});

  final _i5.ServersIdActionsGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListServerActionsResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
