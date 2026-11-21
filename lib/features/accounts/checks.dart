// SPDX-License-Identifier: GPL-3.0-or-later
/// Credential checks run before anything is stored (ONB-017): one small
/// read call per access, nothing is kept from it.
library;

import 'package:dio/dio.dart';
import 'package:falco/api/robot/robot_client.dart';
import 'package:falco/api/s3/s3.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'checks.g.dart';

/// Object Storage locations; each has its own endpoint (ONB-038).
const s3Locations = ['fsn1', 'nbg1', 'hel1'];

/// Endpoint of Object Storage [location].
String s3Endpoint(String location) =>
    'https://$location.your-objectstorage.com';

/// Whether [endpoint] is one of the Hetzner Object Storage endpoints:
/// https only, a known location, no path, port or credentials (ONB-038).
bool isS3Endpoint(String endpoint) {
  final uri = Uri.tryParse(endpoint);
  return uri != null &&
      uri.scheme == 'https' &&
      uri.userInfo.isEmpty &&
      !uri.hasPort &&
      (uri.path.isEmpty || uri.path == '/') &&
      !uri.hasQuery &&
      !uri.hasFragment &&
      s3Locations.any((l) => uri.host == '$l.your-objectstorage.com');
}

/// S3 credentials for [location]; region and endpoint follow from it.
S3Credentials s3Credentials({
  required String location,
  required String accessKey,
  required String secretKey,
}) => S3Credentials(
  accessKey: accessKey.trim(),
  secretKey: secretKey.trim(),
  endpoint: s3Endpoint(location),
  region: location,
);

/// Creates the pinned Robot dio with an auth interceptor. Tests override
/// this with a fake transport.
@Riverpod(keepAlive: true)
Dio Function(Interceptor auth) robotDio(Ref ref) =>
    (auth) =>
        createDio(baseUrl: robotBaseUrl, userAgent: falcoUserAgent, auth: auth);

/// Creates the signing S3 dio for given credentials. Tests override this.
@Riverpod(keepAlive: true)
Dio Function(S3Credentials c) s3Dio(Ref ref) =>
    (c) => createS3Dio(
      endpoint: c.endpoint,
      region: c.region,
      accessKey: c.accessKey,
      secretKey: c.secretKey,
      userAgent: falcoUserAgent,
    );

/// Checks Robot credentials with `GET /server` (ONB-039). Robot answers
/// 404 when the account has no servers; the login is valid then.
Future<void> checkRobot(Dio dio) async {
  try {
    await RobotClient(dio).servers();
  } on NotFound {
    // No servers: the login is valid.
  }
}

/// Checks S3 keys with ListBuckets (`GET /`). S3 rejects unknown keys
/// with 403; that is reported as rejected access data.
Future<void> checkS3(Dio dio) async {
  try {
    await dio.get<Object?>('/');
  } on DioException catch (e) {
    final error = toFalcoError(e);
    throw error is Forbidden ? Unauthorized(code: error.code) : error;
  }
}
