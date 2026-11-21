// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/volumes_id_actions_attach_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/volumes_id_actions_attach_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/volumes_id_actions_attach_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class AttachVolumeResponse {
  const AttachVolumeResponse();
}

@_i1.immutable
class AttachVolumeResponse201 extends AttachVolumeResponse {
  const AttachVolumeResponse201({required this.body});

  final _i2.VolumesIdActionsAttachPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AttachVolumeResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class AttachVolumeResponse4XX extends AttachVolumeResponse {
  const AttachVolumeResponse4XX({required this.body});

  final _i4.VolumesIdActionsAttachPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AttachVolumeResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class AttachVolumeResponse5XX extends AttachVolumeResponse {
  const AttachVolumeResponse5XX({required this.body});

  final _i5.VolumesIdActionsAttachPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is AttachVolumeResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
