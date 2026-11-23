// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/certificates_id_actions_action_id_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/certificates_id_actions_action_id_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/certificates_id_actions_action_id_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class GetCertificateActionResponse {
  const GetCertificateActionResponse();
}

@_i1.immutable
class GetCertificateActionResponse200 extends GetCertificateActionResponse {
  const GetCertificateActionResponse200({required this.body});

  final _i2.CertificatesIdActionsActionIdGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCertificateActionResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetCertificateActionResponse4XX extends GetCertificateActionResponse {
  const GetCertificateActionResponse4XX({required this.body});

  final _i4.CertificatesIdActionsActionIdGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCertificateActionResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class GetCertificateActionResponse5XX extends GetCertificateActionResponse {
  const GetCertificateActionResponse5XX({required this.body});

  final _i5.CertificatesIdActionsActionIdGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is GetCertificateActionResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
