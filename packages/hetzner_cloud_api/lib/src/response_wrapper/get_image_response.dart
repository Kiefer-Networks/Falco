// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/images_id_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/images_id_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/images_id_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetImageResponse {
  const GetImageResponse();
}

@_i1.immutable
class GetImageResponse200 extends GetImageResponse {
  const GetImageResponse200({required this.body});

  final _i2.ImagesIdGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetImageResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetImageResponse4XX extends GetImageResponse {
  const GetImageResponse4XX({required this.body});

  final _i4.ImagesIdGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetImageResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetImageResponse5XX extends GetImageResponse {
  const GetImageResponse5XX({required this.body});

  final _i5.ImagesIdGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetImageResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
