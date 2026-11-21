// SPDX-License-Identifier: GPL-3.0-or-later
/// The one way Falco talks HTTP: a dio per API host with pinned TLS,
/// fixed timeouts, no automatic retries and errors mapped to [FalcoError].
library;

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/pins/pins.g.dart';
import 'package:falco/core/pins/x509.dart';
import 'package:tonik_util/tonik_util.dart';

/// App version; a test keeps it equal to the pubspec version.
const appVersion = '3.0.0';

/// User-Agent of every request: version and platform from the build
/// (BUG-009).
final falcoUserAgent = 'Falco/$appVersion (${Platform.operatingSystem})';

/// Connect timeout (QRS-020).
const connectTimeout = Duration(seconds: 15);

/// Read and write timeout (QRS-020).
const transferTimeout = Duration(seconds: 30);

/// Creates the dio for [baseUrl].
///
/// Only `https` is accepted (QRS-019) and only hosts with pins: TLS anchors
/// solely on the pinned roots of the host, so a foreign or intercepting CA
/// fails the handshake with [PinningFailed]. Nothing is retried, so a POST
/// is never sent twice (QRS-020). Nothing is logged.
Dio createDio({
  required String baseUrl,
  required String userAgent,
  Interceptor? auth,
  Map<String, List<String>> roots = pinnedRoots,
  Map<String, List<String>> spki = pinnedSpki,
}) {
  final uri = Uri.parse(baseUrl);
  if (uri.scheme != 'https') {
    throw ArgumentError.value(baseUrl, 'baseUrl', 'only https is allowed');
  }
  final context = pinnedContext(uri.host, roots: roots, spki: spki);
  return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: transferTimeout,
        sendTimeout: transferTimeout,
        headers: {HttpHeaders.userAgentHeader: userAgent},
      ),
    )
    ..httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () => HttpClient(context: context)
        ..connectionTimeout = connectTimeout
        ..userAgent = userAgent,
    )
    ..interceptors.addAll([?auth, const ErrorInterceptor()]);
}

/// A TLS context that trusts only the pinned roots of [host] (TLS 1.2+,
/// QRS-018). Each root must match its SPKI pin. Hosts without pins throw:
/// there is no unpinned fallback.
SecurityContext pinnedContext(
  String host, {
  Map<String, List<String>> roots = pinnedRoots,
  Map<String, List<String>> spki = pinnedSpki,
}) {
  final key = pinKey(host, roots.keys);
  if (key == null) throw ArgumentError.value(host, 'host', 'not pinned');
  final context = SecurityContext()
    ..minimumTlsProtocolVersion = TlsProtocolVersion.tls1_2;
  for (final b64 in roots[key]!) {
    final der = base64.decode(b64);
    if (!spki[key]!.contains(X509Parts.parse(der).spkiPin)) {
      throw StateError('Root for $key does not match its pin');
    }
    // PEM on every platform: the iOS embedder rejects raw DER here
    // (BAD_PKCS12_DATA, seen on the iOS simulator).
    context.setTrustedCertificatesBytes(
      utf8.encode(
        '-----BEGIN CERTIFICATE-----\n$b64\n-----END CERTIFICATE-----\n',
      ),
    );
  }
  return context;
}

/// The pinned host covering [host]: itself or a parent domain, so S3
/// virtual host buckets (`bucket.fsn1.your-objectstorage.com`) are covered.
String? pinKey(String host, Iterable<String> pinned) {
  for (final p in pinned) {
    if (host == p || host.endsWith('.$p')) return p;
  }
  return null;
}

/// Sends `Authorization: Bearer <token>` (Cloud and Storage Box API).
Interceptor bearerAuth(String token) => InterceptorsWrapper(
  onRequest: (options, handler) {
    options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    handler.next(options);
  },
);

/// Like [bearerAuth], but reads the token per request, so it never stays
/// in app state (SET-017). A missing token fails as [Unauthorized].
Interceptor storedBearerAuth(Future<String?> Function() token) =>
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final value = await token();
        if (value == null) {
          return handler.reject(
            DioException(requestOptions: options, error: const Unauthorized()),
          );
        }
        options.headers[HttpHeaders.authorizationHeader] = 'Bearer $value';
        handler.next(options);
      },
    );

/// Sends HTTP basic auth (Robot webservice).
Interceptor basicAuth(String user, String password) {
  final value = 'Basic ${base64.encode(utf8.encode('$user:$password'))}';
  return InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers[HttpHeaders.authorizationHeader] = value;
      handler.next(options);
    },
  );
}

/// Turns every error response into a [FalcoError] carried by the
/// [DioException]. Generated clients accept every status code, so the
/// mapping has to happen here, once, before they decode a body.
class ErrorInterceptor extends Interceptor {
  /// Creates the interceptor.
  const new();

  @override
  void onResponse(
    Response<Object?> response,
    ResponseInterceptorHandler handler,
  ) {
    final status = response.statusCode ?? 0;
    if (status < 400) return handler.next(response);
    handler.reject(
      DioException.badResponse(
        statusCode: status,
        requestOptions: response.requestOptions,
        response: response,
      ).copyWith(error: toFalcoError(_strip(response))),
    );
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err.copyWith(error: toFalcoError(_strip(err))));
  }

  // Only status, body and Retry-After are needed for the mapping.
  static Object _strip(Object e) => switch (e) {
    Response<Object?>(:final statusCode, :final data, :final headers) =>
      fromResponse(statusCode ?? 0, data, headers.value('retry-after')),
    DioException(:final response?) => _strip(response),
    DioException(type: DioExceptionType.badCertificate) =>
      const PinningFailed(),
    DioException(:final error?) => error,
    _ => const Network(),
  };
}

/// Returns the value of a generated call or throws its [FalcoError].
Future<T> unwrap<T>(Future<TonikResult<T, Response<Object?>>> result) async =>
    switch (await result) {
      TonikSuccess(:final value) => value,
      TonikError(:final error) => throw toFalcoError(error),
    };
