// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i2;

import 'package:hetzner_cloud_api/src/model/certificates_id_delete4xx_body_model.dart'
    as _i3;
import 'package:hetzner_cloud_api/src/model/certificates_id_delete5xx_body_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i1;

sealed class DeleteCertificateResponse {
  const DeleteCertificateResponse();
}

@_i1.immutable
class DeleteCertificateResponse204 extends DeleteCertificateResponse {
  const DeleteCertificateResponse204();

  @_i2.override
  _i2.bool operator ==(_i2.Object other) {
    if (_i2.identical(this, other)) return true;
    return other is DeleteCertificateResponse204;
  }

  @_i2.override
  _i2.int get hashCode => this.runtimeType.hashCode;
}

@_i1.immutable
class DeleteCertificateResponse4XX extends DeleteCertificateResponse {
  const DeleteCertificateResponse4XX({required this.body});

  final _i3.CertificatesIdDelete4xxBodyModel body;

  @_i2.override
  _i2.bool operator ==(_i2.Object other) {
    if (_i2.identical(this, other)) return true;
    return other is DeleteCertificateResponse4XX && other.body == this.body;
  }

  @_i2.override
  _i2.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class DeleteCertificateResponse5XX extends DeleteCertificateResponse {
  const DeleteCertificateResponse5XX({required this.body});

  final _i4.CertificatesIdDelete5xxBodyModel body;

  @_i2.override
  _i2.bool operator ==(_i2.Object other) {
    if (_i2.identical(this, other)) return true;
    return other is DeleteCertificateResponse5XX && other.body == this.body;
  }

  @_i2.override
  _i2.int get hashCode => this.body.hashCode;
}
