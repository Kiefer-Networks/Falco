// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:core' as _i3;

import 'package:hetzner_cloud_api/src/model/certificates_actions_get200_body_model.dart'
    as _i2;
import 'package:hetzner_cloud_api/src/model/certificates_actions_get4xx_body_model.dart'
    as _i4;
import 'package:hetzner_cloud_api/src/model/certificates_actions_get5xx_body_model.dart'
    as _i5;
import 'package:meta/meta.dart' as _i1;

sealed class ListCertificatesActionsResponse {
  const ListCertificatesActionsResponse();
}

@_i1.immutable
class ListCertificatesActionsResponse200
    extends ListCertificatesActionsResponse {
  const ListCertificatesActionsResponse200({required this.body});

  final _i2.CertificatesActionsGet200BodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCertificatesActionsResponse200 &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListCertificatesActionsResponse4XX
    extends ListCertificatesActionsResponse {
  const ListCertificatesActionsResponse4XX({required this.body});

  final _i4.CertificatesActionsGet4xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCertificatesActionsResponse4XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}

@_i1.immutable
class ListCertificatesActionsResponse5XX
    extends ListCertificatesActionsResponse {
  const ListCertificatesActionsResponse5XX({required this.body});

  final _i5.CertificatesActionsGet5xxBodyModel body;

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is ListCertificatesActionsResponse5XX &&
        other.body == this.body;
  }

  @_i3.override
  _i3.int get hashCode => this.body.hashCode;
}
