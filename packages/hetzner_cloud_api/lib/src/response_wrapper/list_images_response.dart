// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/images_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/images_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/images_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListImagesResponse {
  const ListImagesResponse();
}

@_i1.immutable
class ListImagesResponse200 extends ListImagesResponse {
  const ListImagesResponse200({required this.body});

  final _i2.ImagesGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListImagesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListImagesResponse4XX extends ListImagesResponse {
  const ListImagesResponse4XX({required this.body});

  final _i4.ImagesGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListImagesResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListImagesResponse5XX extends ListImagesResponse {
  const ListImagesResponse5XX({required this.body});

  final _i5.ImagesGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListImagesResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
