// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:falco/core/http/http.dart';

/// Answers requests from [handler] instead of the network; records them.
class FakeAdapter implements HttpClientAdapter {
  new(this.handler);

  /// Returns (status, JSON body) for a request.
  final (int, Object?) Function(RequestOptions options) handler;

  /// All requests seen.
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final (status, body) = handler(options);
    return ResponseBody.fromString(
      body == null ? '' : jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
        if (status == 429) 'retry-after': ['7'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
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
