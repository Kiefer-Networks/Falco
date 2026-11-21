// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/volumes_id_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/volumes_id_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/volumes_id_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetVolumeResponse {
  const GetVolumeResponse();
}

@_i1.immutable
class GetVolumeResponse200 extends GetVolumeResponse {
  const GetVolumeResponse200({required this.body});

  final _i2.VolumesIdGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetVolumeResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetVolumeResponse4XX extends GetVolumeResponse {
  const GetVolumeResponse4XX({required this.body});

  final _i4.VolumesIdGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetVolumeResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetVolumeResponse5XX extends GetVolumeResponse {
  const GetVolumeResponse5XX({required this.body});

  final _i5.VolumesIdGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetVolumeResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
