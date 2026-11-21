// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/certificates_post201_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/certificates_post4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/certificates_post5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class CreateCertificateResponse {
  const CreateCertificateResponse();
}

@_i1.immutable
class CreateCertificateResponse201 extends CreateCertificateResponse {
  const CreateCertificateResponse201({required this.body});

  final _i2.CertificatesPost201BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCertificateResponse201 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateCertificateResponse4XX extends CreateCertificateResponse {
  const CreateCertificateResponse4XX({required this.body});

  final _i4.CertificatesPost4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCertificateResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class CreateCertificateResponse5XX extends CreateCertificateResponse {
  const CreateCertificateResponse5XX({required this.body});

  final _i5.CertificatesPost5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CreateCertificateResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
