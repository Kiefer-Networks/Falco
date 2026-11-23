// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/certificates_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/certificates_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/certificates_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListCertificatesResponse {
  const ListCertificatesResponse();
}

@_i1.immutable
class ListCertificatesResponse200 extends ListCertificatesResponse {
  const ListCertificatesResponse200({required this.body});

  final _i2.CertificatesGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCertificatesResponse200 && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListCertificatesResponse4XX extends ListCertificatesResponse {
  const ListCertificatesResponse4XX({required this.body});

  final _i4.CertificatesGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCertificatesResponse4XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListCertificatesResponse5XX extends ListCertificatesResponse {
  const ListCertificatesResponse5XX({required this.body});

  final _i5.CertificatesGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCertificatesResponse5XX && other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
