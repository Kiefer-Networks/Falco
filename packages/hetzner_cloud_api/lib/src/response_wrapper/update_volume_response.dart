// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/volumes_id_put200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/volumes_id_put4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/volumes_id_put5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class UpdateVolumeResponse {
  const UpdateVolumeResponse();
}

@_i1.immutable
class UpdateVolumeResponse200 extends UpdateVolumeResponse {
  const UpdateVolumeResponse200({required this.body});

  final _i2.VolumesIdPut200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateVolumeResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdateVolumeResponse4XX extends UpdateVolumeResponse {
  const UpdateVolumeResponse4XX({required this.body});

  final _i4.VolumesIdPut4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateVolumeResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class UpdateVolumeResponse5XX extends UpdateVolumeResponse {
  const UpdateVolumeResponse5XX({required this.body});

  final _i5.VolumesIdPut5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is UpdateVolumeResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
