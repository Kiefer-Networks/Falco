// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/volumes_id_actions_detach_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/volumes_id_actions_detach_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/volumes_id_actions_detach_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class DetachVolumeResponse {
  const DetachVolumeResponse();
}

@_i1.immutable
class DetachVolumeResponse201 extends DetachVolumeResponse {
  const DetachVolumeResponse201({required this.body});

  final _i2.VolumesIdActionsDetachPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DetachVolumeResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DetachVolumeResponse4XX extends DetachVolumeResponse {
  const DetachVolumeResponse4XX({required this.body});

  final _i4.VolumesIdActionsDetachPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DetachVolumeResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DetachVolumeResponse5XX extends DetachVolumeResponse {
  const DetachVolumeResponse5XX({required this.body});

  final _i5.VolumesIdActionsDetachPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is DetachVolumeResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
