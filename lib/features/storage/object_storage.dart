// SPDX-License-Identifier: GPL-3.0-or-later
/// Object Storage of a project: the project's S3 keys at every location,
/// buckets, listings, versions and the input rules (OBJ-001 to OBJ-025).
library;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/api/s3/s3.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/accounts/checks.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'object_storage.g.dart';

/// S3 of one project at one location. The keys are read from the
/// SecretStore per use and never kept (SET-017); one key pair serves all
/// locations of the project (OBJ-019, OBJ-020).
class S3Access {
  const new(this._secrets, this._dio, [this._now = DateTime.now]);

  final SecretStore _secrets;
  final Dio Function(S3Credentials c) _dio;
  final DateTime Function() _now;

  Future<S3Credentials> _keys(String projectId, String location) async {
    final k = await _secrets.s3(projectId) ?? (throw const Unauthorized());
    return s3Credentials(
      location: location,
      accessKey: k.accessKey,
      secretKey: k.secretKey,
    );
  }

  /// Runs [f] with a client for [location] of [projectId]; failures
  /// arrive as [FalcoError].
  Future<T> run<T>(
    String projectId,
    String location,
    Future<T> Function(S3Client s3) f,
  ) async {
    final dio = _dio(await _keys(projectId, location));
    try {
      return await f(S3Client(dio));
    } on DioException catch (e) {
      throw toFalcoError(e);
    } finally {
      dio.close();
    }
  }

  /// A presigned [method] link to [key] in [bucket], valid for [expires]
  /// (OBJ-011, OBJ-025, background transfers).
  Future<Uri> presign(
    String projectId,
    String location,
    String method,
    String bucket,
    String key, {
    required Duration expires,
    Map<String, String>? query,
  }) async {
    final c = await _keys(projectId, location);
    return presignV4(
      method: method,
      uri: Uri.parse('${c.endpoint}${s3Path(bucket, key, query)}'),
      accessKey: c.accessKey,
      secretKey: c.secretKey,
      region: c.region,
      now: _now(),
      expires: expires,
    );
  }
}

/// S3 access of the app.
@Riverpod(keepAlive: true)
S3Access s3Access(Ref ref) =>
    S3Access(ref.watch(secretStoreProvider), ref.watch(s3DioProvider));

/// A bucket at its location.
typedef Bucket = ({
  String name,
  String location,
  String projectId,
  DateTime? created,
});

/// Buckets of every project of [scope] with S3 keys, at all locations
/// (OBJ-001, OBJ-020). Null when no project has keys. A location that
/// fails leaves the others standing: the result is then a [PartialList]
/// naming it with its project.
@riverpod
Future<List<Bucket>?> buckets(Ref ref, Scope scope) async {
  final s3 = ref.watch(s3AccessProvider);
  var keys = false;
  final failed = <Project>[];
  // The keys are watched, so adding or deleting them reaches the list.
  final list = await forProjects(ref, scope, (p) async {
    if (await ref.watch(projectS3Provider(p.id).future) == null) {
      return const <Bucket>[];
    }
    keys = true;
    return await _projectBuckets(s3, p, failed);
  });
  if (!keys) return null;
  if (failed.isEmpty) return list;
  return PartialList(list, [
    if (list case PartialList(failed: final projects)) ...projects,
    ...failed,
  ]);
}

/// Buckets of [project]; adds locations that fail to [failed], unless
/// all fail, and buckets whose location stays unknown.
Future<List<Bucket>> _projectBuckets(
  S3Access s3,
  Project project,
  List<Project> failed,
) async {
  final projectId = project.id;
  final errors = <String, FalcoError>{};
  final found = await Future.wait([
    for (final l in s3Locations)
      s3.run(projectId, l, (c) => c.buckets()).catchError((Object e) {
        errors[l] = toFalcoError(e);
        return <({String name, DateTime? created})>[];
      }),
  ]);
  if (errors.length == s3Locations.length) throw errors.values.first;
  failed.addAll([
    for (final l in errors.keys)
      Project(id: projectId, name: '${project.name} $l'),
  ]);
  final seen = <String, List<String>>{};
  final created = <String, DateTime?>{};
  for (final (i, list) in found.indexed) {
    for (final b in list) {
      (seen[b.name] ??= []).add(s3Locations[i]);
      created[b.name] ??= b.created;
    }
  }
  // An endpoint listing buckets of other locations too: ask the bucket.
  // One seen by a single endpoint is there only when every endpoint
  // answered; a failed one may be its own.
  final located = await Future.wait([
    for (final MapEntry(key: name, value: at) in seen.entries)
      if (at.length == 1 && errors.isEmpty)
        Future.value(at.single)
      else
        s3
            .run(projectId, at.first, (c) => c.location(name))
            // No answer for good (refused, or none given): where it was
            // listed, as before. A transient error names it as failed
            // and keeps the project standing.
            .then<String?>((l) => l ?? at.first)
            .catchError(
              (Object e) => toFalcoError(e) is Forbidden ? at.first : null,
            ),
  ]);
  final buckets = <Bucket>[];
  for (final (i, name) in seen.keys.indexed) {
    // Not guessed: a wrong location sends every call to another endpoint.
    if (located[i] case final l? when s3Locations.contains(l)) {
      buckets.add((
        name: name,
        location: l,
        projectId: projectId,
        created: created[name],
      ));
    } else {
      failed.add(Project(id: projectId, name: '${project.name} $name'));
    }
  }
  return buckets;
}

/// Versioning (`Enabled`, `Suspended` or null) and visibility of a bucket
/// (OBJ-004).
@riverpod
Future<({String? versioning, bool public})> bucketSettings(
  Ref ref,
  String projectId,
  String location,
  String bucket,
) => ref
    .watch(s3AccessProvider)
    .run(
      projectId,
      location,
      (c) async => (
        versioning: await c.versioning(bucket),
        public: await c.isPublic(bucket),
      ),
    );

/// Folders and objects below [prefix] (OBJ-006).
@riverpod
Future<({List<String> folders, List<S3Object> objects})> objects(
  Ref ref,
  String projectId,
  String location,
  String bucket,
  String prefix,
) => ref
    .watch(s3AccessProvider)
    .run(projectId, location, (c) => c.list(bucket, prefix));

/// Versions of one object (OBJ-023).
@riverpod
Future<List<S3Version>> objectVersions(
  Ref ref,
  String projectId,
  String location,
  String bucket,
  String key,
) => ref
    .watch(s3AccessProvider)
    .run(projectId, location, (c) => c.versions(bucket, key));

/// Size, date, type and ETag of one object (OBJ-010).
@riverpod
Future<S3Object> objectInfo(
  Ref ref,
  String projectId,
  String location,
  String bucket,
  String key,
) => ref
    .watch(s3AccessProvider)
    .run(projectId, location, (c) => c.head(bucket, key));

/// S3 bucket naming rules: 3 to 63 lower case letters, digits, dots and
/// hyphens, starting and ending with a letter or digit, no `..`, not an IP
/// address (OBJ-002, OBJ-008, BUG-016).
bool validBucketName(String name) =>
    RegExp(r'^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$').hasMatch(name) &&
    !name.contains('..') &&
    !RegExp(r'^\d+\.\d+\.\d+\.\d+$').hasMatch(name);

/// An object key: 1 to 1024 bytes of UTF-8, not starting with `/`, no
/// `.` or `..` segment (OBJ-008).
bool validKey(String key) {
  final n = utf8.encode(key).length;
  return n > 0 && n <= 1024 && !key.startsWith('/') && !hasDotSegment(key);
}

/// A MIME type of the form `type/subtype` (OBJ-008).
bool validMime(String mime) => RegExp(r'^[\w.+-]+/[\w.+-]+$').hasMatch(mime);

/// MIME type of a file name by its extension.
// ponytail: common types only; everything else is octet-stream.
String mimeOf(String name) =>
    const {
      'txt': 'text/plain',
      'html': 'text/html',
      'css': 'text/css',
      'csv': 'text/csv',
      'js': 'text/javascript',
      'json': 'application/json',
      'xml': 'application/xml',
      'pdf': 'application/pdf',
      'zip': 'application/zip',
      'gz': 'application/gzip',
      'tar': 'application/x-tar',
      'png': 'image/png',
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'gif': 'image/gif',
      'webp': 'image/webp',
      'svg': 'image/svg+xml',
      'mp4': 'video/mp4',
      'mov': 'video/quicktime',
      'mp3': 'audio/mpeg',
    }[name.contains('.') ? name.split('.').last.toLowerCase() : ''] ??
    'application/octet-stream';

/// The last part of [key] (`a/b/c.txt` is `c.txt`, `a/b/` is `b`).
String baseName(String key) {
  final parts = key.split('/')..removeWhere((p) => p.isEmpty);
  return parts.lastOrNull ?? key;
}
