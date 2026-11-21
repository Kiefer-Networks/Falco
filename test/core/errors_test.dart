// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, Object?> cloudError(String code, [Object? details]) => {
  'error': {'code': code, 'message': 'msg', 'details': details},
};

void main() {
  test('QRS-020 retryDelay retries only transient errors', () {
    expect(retryDelay(0, const Network()), isNotNull);
    expect(retryDelay(0, const Server()), isNotNull);
    expect(
      retryDelay(0, const RateLimited(retryAfter: Duration(seconds: 7))),
      const Duration(seconds: 7),
    );
    expect(retryDelay(5, const Network()), isNull);
    for (final e in <Object>[
      const NotFound(),
      const Unauthorized(),
      const Forbidden(),
      const Invalid(),
      const Conflict(),
      StateError('bug'),
    ]) {
      expect(retryDelay(0, e), isNull, reason: '$e');
    }
  });

  group('fromResponse', () {
    test('maps Cloud error codes before status codes', () {
      expect(
        fromResponse(401, cloudError('unauthorized')),
        isA<Unauthorized>(),
      );
      expect(fromResponse(403, cloudError('forbidden')), isA<Forbidden>());
      expect(fromResponse(403, cloudError('token_readonly')), isA<Forbidden>());
      expect(fromResponse(404, cloudError('not_found')), isA<NotFound>());
      expect(fromResponse(423, cloudError('locked')), isA<Conflict>());
      expect(fromResponse(403, cloudError('protected')), isA<Conflict>());
      expect(
        fromResponse(409, cloudError('uniqueness_error')),
        isA<Conflict>(),
      );
      expect(fromResponse(503, cloudError('maintenance')), isA<Server>());
    });

    test('keeps the code', () {
      expect(fromResponse(403, cloudError('protected')).code, 'protected');
    });

    test('reads invalid fields', () {
      final error = fromResponse(
        400,
        cloudError('invalid_input', {
          'fields': [
            {
              'name': 'name',
              'messages': ['is too long'],
            },
          ],
        }),
      );
      expect(error, isA<Invalid>());
      expect((error as Invalid).fields, {
        'name': ['is too long'],
      });
    });

    test('reads Retry-After', () {
      final error = fromResponse(429, cloudError('rate_limit_exceeded'), '7');
      expect((error as RateLimited).retryAfter, const Duration(seconds: 7));
    });

    test('understands the Robot format', () {
      final error = fromResponse(400, {
        'error': {
          'status': 400,
          'code': 'INVALID_INPUT',
          'message': 'invalid input',
          'invalid': ['server_ip'],
        },
      });
      expect((error as Invalid).fields.keys, ['server_ip']);
      expect(
        fromResponse(404, {
          'error': {'status': 404, 'code': 'SERVER_NOT_FOUND'},
        }),
        isA<NotFound>(),
      );
    });

    test('falls back to the status for unknown or missing bodies', () {
      expect(fromResponse(401, 'not json'), isA<Unauthorized>());
      expect(fromResponse(409, null), isA<Conflict>());
      expect(fromResponse(502, '<html>'), isA<Server>());
      expect(fromResponse(422, null), isA<Invalid>());
    });

    test('decodes byte bodies', () {
      expect(
        fromResponse(403, '{"error":{"code":"forbidden"}}'.codeUnits),
        isA<Forbidden>(),
      );
    });
  });

  group('toFalcoError', () {
    final options = RequestOptions(path: '/servers');

    test('maps transport failures', () {
      expect(
        toFalcoError(
          DioException.connectionTimeout(
            timeout: Duration.zero,
            requestOptions: options,
          ),
        ),
        isA<Network>(),
      );
      expect(toFalcoError(const SocketException('no route')), isA<Network>());
      expect(
        toFalcoError(
          DioException(
            requestOptions: options,
            error: const HandshakeException('CERTIFICATE_VERIFY_FAILED'),
          ),
        ),
        isA<PinningFailed>(),
      );
    });

    test('unwraps a FalcoError carried by dio', () {
      expect(
        toFalcoError(
          DioException(requestOptions: options, error: const NotFound()),
        ),
        isA<NotFound>(),
      );
    });
  });

  test('toString carries no message, URL or token (SET-022)', () {
    final text = fromResponse(401, {
      'error': {
        'code': 'unauthorized',
        'message': 'token abc123 at https://api.hetzner.cloud/v1/servers',
      },
    }).toString();
    expect(text, 'Unauthorized(unauthorized)');
  });
}
