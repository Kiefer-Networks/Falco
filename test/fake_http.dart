// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:falco/core/http/http.dart';

/// Answers requests from [handler] instead of the network; records them.
class FakeAdapter implements HttpClientAdapter {
  new(this.handler);

  /// Returns (status, JSON body) for a request.
  final (int, Object?) Function(RequestOptions options) handler;

  /// All requests seen.
  final requests = <RequestOptions>[];

  /// Body bytes as sent, per request in [requests].
  final bodies = <List<int>>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final sent = [
      if (requestStream != null)
        for (final chunk in await requestStream.toList()) ...chunk,
    ];
    bodies.add(sent);
    // Like S3: a signed body hash must match the bytes sent.
    final hash = options.headers['x-amz-content-sha256'];
    if (hash != null &&
        hash != 'UNSIGNED-PAYLOAD' &&
        hash != sha256.convert(sent).toString()) {
      return ResponseBody.fromString(
        '<Error><Code>XAmzContentSHA256Mismatch</Code></Error>',
        400,
        headers: {
          Headers.contentTypeHeader: ['application/xml'],
        },
      );
    }
    final (status, body) = handler(options);
    // S3 answers XML (a String), optionally with headers (HeadObject).
    final (text, headers) = switch (body) {
      FakeResponse(:final text, :final headers) => (text, headers),
      final String xml => (xml, const <String, List<String>>{}),
      null => ('', const <String, List<String>>{}),
      _ => (jsonEncode(body), const <String, List<String>>{}),
    };
    return ResponseBody.fromString(
      text,
      status,
      headers: {
        Headers.contentTypeHeader: [
          if (body is String || body is FakeResponse)
            'application/xml'
          else
            'application/json',
        ],
        if (status == 429) 'retry-after': ['7'],
        ...headers,
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// A raw response body with headers.
class FakeResponse {
  const new(this.text, [this.headers = const {}]);

  final String text;
  final Map<String, List<String>> headers;
}

/// A real [createDio] client whose transport is [adapter].
Dio fakeDio(
  FakeAdapter adapter, {
  String baseUrl = 'https://api.hetzner.cloud/v1',
  Interceptor? auth,
}) =>
    createDio(baseUrl: baseUrl, userAgent: 'Falco/test', auth: auth)
      ..httpClientAdapter = adapter;

/// Reads a fixture below test/fixtures.
Object? fixture(String path) =>
    jsonDecode(File('test/fixtures/$path').readAsStringSync());
