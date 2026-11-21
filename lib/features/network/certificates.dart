// SPDX-License-Identifier: GPL-3.0-or-later
/// TLS certificates for load balancers, uploaded or managed by Let's
/// Encrypt (NET-079 to NET-085, NET-090).
library;

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/http/pagination.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'certificates.g.dart';

/// A certificate as Falco shows it.
@immutable
class Certificate {
  const new({
    required this.id,
    required this.projectId,
    required this.name,
    required this.created,
    this.managed = false,
    this.domains = const [],
    this.validFrom,
    this.validUntil,
    this.fingerprint,
    this.issuance,
    this.renewal,
    this.error,
    this.usedBy = const [],
    this.labels = const {},
  });

  factory fromJson(Json c, String projectId) {
    final status = json(c['status']);
    DateTime? date(String key) => switch (c[key]) {
      final String s => DateTime.parse(s),
      _ => null,
    };
    return Certificate(
      id: c['id']! as int,
      projectId: projectId,
      name: c['name']! as String,
      created: DateTime.parse(c['created']! as String),
      managed: c['type'] == 'managed',
      domains: [...?(c['domain_names'] as List?)?.cast<String>()],
      validFrom: date('not_valid_before'),
      validUntil: date('not_valid_after'),
      fingerprint: c['fingerprint'] as String?,
      issuance: status['issuance'] as String?,
      renewal: status['renewal'] as String?,
      error: json(status['error'])['message'] as String?,
      usedBy: [for (final u in jsonList(c['used_by'])) u['id']! as int],
      labels: json(c['labels']).cast<String, String>(),
    );
  }

  final int id;
  final String projectId;
  final String name;
  final DateTime created;
  final bool managed;
  final List<String> domains;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final String? fingerprint;

  /// `pending`, `completed` or `failed` (managed only).
  final String? issuance;

  /// `scheduled`, `pending`, `failed` or `unavailable` (managed only).
  final String? renewal;
  final String? error;

  /// Load balancer ids.
  final List<int> usedBy;
  final Map<String, String> labels;

  /// A failed managed certificate can be retried (NET-085).
  bool get failed => issuance == 'failed' || renewal == 'failed';

  ResourceStatus status(DateTime now) => switch (this) {
    _ when failed => ResourceStatus.error,
    Certificate(issuance: 'pending') => ResourceStatus.inProgress,
    Certificate(validUntil: final u?) when u.isBefore(now) =>
      ResourceStatus.unavailable,
    _ => ResourceStatus.available,
  };
}

/// All certificates of [scope] (NET-079).
@riverpod
Future<List<Certificate>> certificates(Ref ref, Scope scope) => perProject(
  ref,
  scope,
  (api, projectId) => fetchAllJson(
    (page) =>
        cloud.CertificatesApi(api)
            .listCertificates(page: page, perPage: maxPerPage),
    'certificates',
    (j) => Certificate.fromJson(j, projectId),
  ),
);

/// One certificate (NET-082).
@riverpod
Future<Certificate> certificate(
  Ref ref,
  ProjectScope scope,
  int certificateId,
) async {
  final api = ref.watch(cloudApiProvider(scope.projectId));
  final body = await cloudJson(
    cloud.CertificatesApi(api).getCertificate(id: certificateId),
  );
  return Certificate.fromJson(json(body['certificate']), scope.projectId);
}

/// Uploads a certificate with its key (NET-080), or orders a managed one
/// for [domains] (NET-081). Returns its id and the issuing action.
Future<({int id, int? action})> createCertificate(
  cloud.Server api, {
  required String name,
  String certificate = '',
  String privateKey = '',
  List<String> domains = const [],
  Map<String, String> labels = const {},
}) async {
  final managed = domains.isNotEmpty;
  final body = await cloudJson(
    cloud.CertificatesApi(api).createCertificate(
      body: cloud.CertificatesPostBodyBodyModel.fromJson({
        'name': name,
        'type': managed ? 'managed' : 'uploaded',
        if (managed)
          'domain_names': domains
        else ...{
          'certificate': certificate.trim(),
          'private_key': privateKey.trim(),
        },
        'labels': labels,
      }),
    ),
  );
  return (
    id: json(body['certificate'])['id']! as int,
    action: json(body['action'])['id'] as int?,
  );
}

/// Renames or relabels a certificate (NET-083, NET-090).
Future<void> updateCertificate(
  cloud.Server api,
  int id, {
  String? name,
  Map<String, String>? labels,
}) => unwrap(
  cloud.CertificatesApi(api).updateCertificate(
    id: id,
    body: cloud.CertificatesIdPutBodyBodyModel.fromJson({
      'name': ?name,
      'labels': ?labels,
    }),
  ),
);

/// Deletes a certificate (NET-084).
Future<void> deleteCertificate(cloud.Server api, int id) =>
    unwrap(cloud.CertificatesApi(api).deleteCertificate(id: id));

/// Retries issuing a failed managed certificate (NET-085).
Future<int> retryCertificate(cloud.Server api, int id) =>
    cloudAction(cloud.CertificateActionsApi(api).retryCertificate(id: id));

/// Domain names of a managed certificate, comma separated (NET-081).
List<String> splitDomains(String text) => [
  for (final d in text.split(RegExp(r'[\s,]+')))
    if (d.isNotEmpty) d,
];

/// A PEM certificate, or with [key] a private key of any kind.
bool looksLikePem(String text, {bool key = false}) {
  final t = text.trim();
  return key
      ? RegExp('^-----BEGIN [A-Z ]*PRIVATE KEY-----').hasMatch(t)
      : t.startsWith('-----BEGIN CERTIFICATE-----');
}
