// SPDX-License-Identifier: GPL-3.0-or-later
/// Cloud SSH keys: model, providers, validation and operations
/// (CMP-070 to CMP-076, CMP-099).
library;

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/http/pagination.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:flutter/foundation.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ssh_keys.g.dart';

/// An SSH key of a project.
@immutable
class SshKey {
  const new({
    required this.id,
    required this.projectId,
    required this.name,
    required this.fingerprint,
    required this.publicKey,
    required this.created,
    this.labels = const {},
  });

  factory fromModel(cloud.SshKeysGet200BodySshKeysArrayModel k, String p) =>
      SshKey(
        id: k.id,
        projectId: p,
        name: k.name,
        fingerprint: k.fingerprint,
        publicKey: k.publicKey,
        labels: k.labels,
        created: k.created,
      );

  final int id;
  final String projectId;
  final String name;
  final String fingerprint;
  final String publicKey;
  final Map<String, String> labels;
  final DateTime created;
}

/// Why a pasted key is refused.
enum SshKeyProblem { empty, privateKey, unknownType }

// Markers of private keys and certificates (CMP-072).
const _privateMarkers = [
  '-----BEGIN',
  'PuTTY-User-Key-File',
  '---- BEGIN SSH2',
  '-cert-v01@openssh.com',
];

// Public key types the Cloud accepts (CMP-073).
const _publicPrefixes = [
  'ssh-rsa ',
  'ssh-ed25519 ',
  'ssh-dss ',
  'ecdsa-sha2-nistp256 ',
  'ecdsa-sha2-nistp384 ',
  'ecdsa-sha2-nistp521 ',
  'sk-ecdsa-sha2-nistp256@openssh.com ',
  'sk-ssh-ed25519@openssh.com ',
];

/// Checks a pasted public key; null when it can be added.
SshKeyProblem? sshKeyProblem(String key) {
  final k = key.trim();
  if (k.isEmpty) return SshKeyProblem.empty;
  if (_privateMarkers.any(k.contains)) return SshKeyProblem.privateKey;
  if (!_publicPrefixes.any(k.startsWith)) return SshKeyProblem.unknownType;
  return null;
}

/// All SSH keys of [scope] (CMP-070).
@riverpod
Future<List<SshKey>> sshKeys(Ref ref, Scope scope) => perProject(
  ref,
  scope,
  (api, projectId) => fetchAll((page) async {
    final r = await unwrap(
      cloud.SshKeysApi(api).listSshKeys(page: page, perPage: maxPerPage),
    );
    if (r is! cloud.ListSshKeysResponse200) throw const Server();
    return (
      items: [for (final k in r.body.sshKeys) SshKey.fromModel(k, projectId)],
      nextPage: r.body.meta.pagination.nextPage,
    );
  }),
);

/// One SSH key (CMP-099).
@riverpod
Future<SshKey> sshKey(Ref ref, ProjectScope scope, int keyId) async {
  final api = cloud.SshKeysApi(ref.watch(cloudApiProvider(scope.projectId)));
  final r = await unwrap(api.getSshKey(id: keyId));
  if (r is! cloud.GetSshKeyResponse200) throw const NotFound();
  return SshKey.fromModel(
    cloud.SshKeysGet200BodySshKeysArrayModel.fromJson(r.body.sshKey.toJson()),
    scope.projectId,
  );
}

/// Adds an SSH key (CMP-071).
Future<int> createSshKey(
  cloud.Server api, {
  required String name,
  required String publicKey,
  Map<String, String> labels = const {},
}) async {
  final r = await unwrap(
    cloud.SshKeysApi(api).createSshKey(
      body: cloud.SshKeysPostBodyBodyModel.fromJson({
        'name': name,
        'public_key': publicKey.trim(),
        'labels': labels,
      }),
    ),
  );
  if (r is! cloud.CreateSshKeyResponse201) throw const Server();
  return r.body.sshKey.id;
}

/// Renames or relabels an SSH key (CMP-076).
Future<void> updateSshKey(
  cloud.Server api,
  int id, {
  String? name,
  Map<String, String>? labels,
}) => unwrap(
  cloud.SshKeysApi(api).updateSshKey(
    id: id,
    body: cloud.SshKeysIdPutBodyBodyModel.fromJson({
      'name': ?name,
      'labels': ?labels,
    }),
  ),
);

/// Deletes an SSH key (CMP-075).
Future<void> deleteSshKey(cloud.Server api, int id) =>
    unwrap(cloud.SshKeysApi(api).deleteSshKey(id: id));
