// SPDX-License-Identifier: GPL-3.0-or-later
/// S3 (Object Storage) on dio: AWS Signature Version 4 and the pinned dio.
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:falco/core/http/http.dart';

/// SHA-256 of an empty body.
const emptyPayloadHash =
    'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';

/// Signs a request with AWS SigV4 and returns the headers to add
/// (`x-amz-date`, `Authorization`). [headers] are signed as given; `host`
/// is taken from [uri].
Map<String, String> signV4({
  required String method,
  required Uri uri,
  required Map<String, String> headers,
  required String payloadHash,
  required String accessKey,
  required String secretKey,
  required String region,
  required DateTime now,
  String service = 's3',
}) {
  final amzDate = _amzDate(now.toUtc());
  final day = amzDate.substring(0, 8);
  final signed = <String, String>{
    for (final MapEntry(:key, :value) in headers.entries)
      key.toLowerCase(): value.trim().replaceAll(RegExp(r'\s+'), ' '),
    'host': uri.hasPort && !_defaultPort(uri)
        ? '${uri.host}:${uri.port}'
        : uri.host,
    'x-amz-date': amzDate,
  };
  final names = signed.keys.toList()..sort();
  final query = [
    for (final MapEntry(:key, :value) in uri.queryParametersAll.entries)
      for (final v in value) '${_encode(key)}=${_encode(v)}',
  ]..sort();
  final canonical = [
    method.toUpperCase(),
    '/${uri.pathSegments.map(_encode).join('/')}',
    query.join('&'),
    for (final n in names) '$n:${signed[n]}',
    '',
    names.join(';'),
    payloadHash,
  ].join('\n');
  final scope = '$day/$region/$service/aws4_request';
  final toSign = [
    'AWS4-HMAC-SHA256',
    amzDate,
    scope,
    sha256.convert(utf8.encode(canonical)).toString(),
  ].join('\n');
  List<int> key = utf8.encode('AWS4$secretKey');
  for (final part in [day, region, service, 'aws4_request']) {
    key = Hmac(sha256, key).convert(utf8.encode(part)).bytes;
  }
  final signature = Hmac(sha256, key).convert(utf8.encode(toSign)).toString();
  return {
    'x-amz-date': amzDate,
    'Authorization':
        'AWS4-HMAC-SHA256 Credential=$accessKey/$scope, '
        'SignedHeaders=${names.join(';')}, Signature=$signature',
  };
}

/// Creates a pinned dio for an S3 [endpoint] (e.g.
/// `https://fsn1.your-objectstorage.com`) that signs every request.
/// Plain `http` endpoints are rejected (QRS-019).
Dio createS3Dio({
  required String endpoint,
  required String region,
  required String accessKey,
  required String secretKey,
  required String userAgent,
}) {
  final dio = createDio(baseUrl: endpoint, userAgent: userAgent);
  dio.interceptors.insert(
    0,
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final data = options.data;
        final hash = switch (data) {
          null => emptyPayloadHash,
          List<int>() => sha256.convert(data).toString(),
          String() => sha256.convert(utf8.encode(data)).toString(),
          _ => 'UNSIGNED-PAYLOAD',
        };
        options.headers['x-amz-content-sha256'] = hash;
        options.headers.addAll(
          signV4(
            method: options.method,
            uri: options.uri,
            headers: {'x-amz-content-sha256': hash},
            payloadHash: hash,
            accessKey: accessKey,
            secretKey: secretKey,
            region: region,
            now: DateTime.now(),
          ),
        );
        handler.next(options);
      },
    ),
  );
  return dio;
}

String _amzDate(DateTime t) =>
    '${t.toIso8601String().replaceAll(RegExp('[-:]'), '').split('.').first}Z';

bool _defaultPort(Uri uri) =>
    (uri.scheme == 'https' && uri.port == 443) ||
    (uri.scheme == 'http' && uri.port == 80);

/// RFC 3986 encoding as SigV4 wants it: only `A-Za-z0-9-_.~` stay.
String _encode(String s) => Uri.encodeComponent(s).replaceAllMapped(
  RegExp("[!*'()]"),
  (m) => '%${m[0]!.codeUnitAt(0).toRadixString(16).toUpperCase()}',
);
