// SPDX-License-Identifier: GPL-3.0-or-later
/// The one error model of Falco. Every failure of an API call ends up as a
/// [FalcoError]; texts live in the UI (l10n), never here.
///
/// Instances carry no URLs, headers, bodies or tokens, so they are safe to
/// log and to show (SET-022).
library;

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

/// Base of all API failures.
sealed class FalcoError implements Exception {
  const new({this.code});

  /// Machine readable error code from the API (e.g. `protected`), if any.
  final String? code;

  @override
  String toString() {
    final name = switch (this) {
      Unauthorized() => 'Unauthorized',
      Forbidden() => 'Forbidden',
      NotFound() => 'NotFound',
      Conflict() => 'Conflict',
      RateLimited() => 'RateLimited',
      Invalid() => 'Invalid',
      Network() => 'Network',
      PinningFailed() => 'PinningFailed',
      Server() => 'Server',
    };
    return code == null ? name : '$name($code)';
  }
}

/// Credentials missing, wrong or revoked (401).
final class Unauthorized extends FalcoError {
  /// Creates the error.
  const new({super.code});
}

/// The token lacks the permission, e.g. a read only token (403, QRS-021).
final class Forbidden extends FalcoError {
  /// Creates the error.
  const new({super.code});
}

/// The resource does not exist (any more) (404).
final class NotFound extends FalcoError {
  /// Creates the error.
  const new({super.code});
}

/// The resource is protected, locked or in a conflicting state (409, 423).
final class Conflict extends FalcoError {
  /// Creates the error.
  const new({super.code});
}

/// Too many requests. [retryAfter] comes from the response, if sent.
final class RateLimited extends FalcoError {
  /// Creates the error.
  const new({this.retryAfter, super.code});

  /// Time to wait before the next request.
  final Duration? retryAfter;
}

/// The request was rejected as invalid; [fields] maps field names to the
/// messages of the API.
final class Invalid extends FalcoError {
  /// Creates the error.
  const new({this.fields = const {}, super.code});

  /// Field name to validation messages.
  final Map<String, List<String>> fields;
}

/// No connection, timeout or broken transport.
final class Network extends FalcoError {
  /// Creates the error.
  const new();
}

/// TLS failed: the server certificate does not chain to a pinned root.
/// Never silently retried without pinning.
final class PinningFailed extends FalcoError {
  /// Creates the error.
  const new();
}

/// The server failed (5xx) or answered with something unparseable.
final class Server extends FalcoError {
  /// Creates the error.
  const new({super.code});
}

/// Maps any error thrown by dio or a generated client to a [FalcoError].
FalcoError toFalcoError(Object error) {
  if (error is FalcoError) return error;
  if (error is DioException) {
    if (error.error is FalcoError) return error.error! as FalcoError;
    final response = error.response;
    if (response != null) {
      return fromResponse(
        response.statusCode ?? 0,
        response.data,
        response.headers.value('retry-after'),
      );
    }
    return toFalcoError(error.error ?? const Network());
  }
  if (error is HandshakeException || error is TlsException) {
    return const PinningFailed();
  }
  if (error is SocketException || error is HttpException) {
    return const Network();
  }
  return const Server();
}

/// Maps an HTTP error response to a [FalcoError].
///
/// Understands the Cloud and Storage Box format
/// `{"error": {"code", "message", "details": {"fields": [...]}}}` and the
/// Robot format `{"error": {"status", "code", "message", "invalid": [...]}}`.
/// The error code decides first, the status code is the fallback.
FalcoError fromResponse(int status, Object? body, [String? retryAfter]) {
  final error = _errorObject(body);
  final code = error?['code']?.toString();
  final lower = code?.toLowerCase();
  final retry = int.tryParse(retryAfter ?? '');
  final retryDuration = retry == null ? null : Duration(seconds: retry);

  switch (lower) {
    case 'unauthorized':
      return Unauthorized(code: code);
    case 'forbidden' || 'token_readonly' || 'resource_limit_exceeded':
      return Forbidden(code: code);
    case 'not_found':
      return NotFound(code: code);
    case 'conflict' || 'protected' || 'locked' || 'uniqueness_error':
      return Conflict(code: code);
    case 'rate_limit_exceeded' || 'rate_limit_exceeded_global':
      return RateLimited(retryAfter: retryDuration, code: code);
    case 'invalid_input' || 'json_error' || 'invalid_input_data':
      return Invalid(fields: _fields(error), code: code);
  }
  return switch (status) {
    401 => Unauthorized(code: code),
    // Robot throttles with 403; a Retry-After marks it (ROB-003).
    403 when retryDuration != null => RateLimited(
      retryAfter: retryDuration,
      code: code,
    ),
    403 => Forbidden(code: code),
    404 => NotFound(code: code),
    409 || 423 => Conflict(code: code),
    429 => RateLimited(retryAfter: retryDuration, code: code),
    400 || 422 => Invalid(fields: _fields(error), code: code),
    _ => Server(code: code),
  };
}

Map<String, Object?>? _errorObject(Object? body) {
  var data = body;
  if (data is List<int>) {
    try {
      data = jsonDecode(utf8.decode(data));
    } on FormatException {
      return null;
    }
  } else if (data is String) {
    try {
      data = jsonDecode(data);
    } on FormatException {
      return null;
    }
  }
  if (data is Map && data['error'] is Map) {
    return (data['error'] as Map).cast<String, Object?>();
  }
  return null;
}

Map<String, List<String>> _fields(Map<String, Object?>? error) {
  final result = <String, List<String>>{};
  // Cloud: details.fields = [{name, messages: [...]}]
  final details = error?['details'];
  if (details is Map && details['fields'] is List) {
    for (final field in details['fields'] as List) {
      if (field is Map && field['name'] is String) {
        result[field['name'] as String] = [
          for (final m in (field['messages'] as List?) ?? const []) '$m',
        ];
      }
    }
  }
  // Robot: invalid = ["field", ...]
  final invalid = error?['invalid'];
  if (invalid is List) {
    for (final name in invalid) {
      result.putIfAbsent('$name', () => const []);
    }
  }
  return result;
}

/// Retry rule of the provider container: only failures that may pass by
/// themselves (network, 5xx, rate limit after its Retry-After) are retried,
/// up to 5 times with growing delay. Client errors (401, 403, 404, 4xx)
/// never are: they fail the same way again and cost rate limit.
Duration? retryDelay(int retryCount, Object error) {
  if (retryCount >= 5) return null;
  final backoff = Duration(milliseconds: 200 * (1 << retryCount));
  return switch (error) {
    RateLimited(:final retryAfter) => retryAfter ?? backoff,
    Network() || Server() => backoff,
    _ => null,
  };
}
