// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/actions_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/actions_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/actions_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetActionsResponse {
  const GetActionsResponse();
}

@_i1.immutable
class GetActionsResponse200 extends GetActionsResponse {
  const GetActionsResponse200({required this.body});

  final _i2.ActionsGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetActionsResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetActionsResponse4XX extends GetActionsResponse {
  const GetActionsResponse4XX({required this.body});

  final _i4.ActionsGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetActionsResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetActionsResponse5XX extends GetActionsResponse {
  const GetActionsResponse5XX({required this.body});

  final _i5.ActionsGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetActionsResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
