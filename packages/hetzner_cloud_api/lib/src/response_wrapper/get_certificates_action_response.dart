// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/certificates_actions_id_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/certificates_actions_id_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/certificates_actions_id_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetCertificatesActionResponse {
  const GetCertificatesActionResponse();
}

@_i1.immutable
class GetCertificatesActionResponse200 extends GetCertificatesActionResponse {
  const GetCertificatesActionResponse200({required this.body});

  final _i2.CertificatesActionsIdGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCertificatesActionResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetCertificatesActionResponse4XX extends GetCertificatesActionResponse {
  const GetCertificatesActionResponse4XX({required this.body});

  final _i4.CertificatesActionsIdGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCertificatesActionResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetCertificatesActionResponse5XX extends GetCertificatesActionResponse {
  const GetCertificatesActionResponse5XX({required this.body});

  final _i5.CertificatesActionsIdGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCertificatesActionResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
