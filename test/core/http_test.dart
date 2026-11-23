// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert';
import 'dart:io';

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/pins/pins.g.dart';
import 'package:falco/core/pins/x509.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;

import '../fake_http.dart';

void main() {
  group('createDio', () {
    test('rejects plain http (QRS-019)', () {
      expect(
        () => createDio(
          baseUrl: 'http://fsn1.your-objectstorage.com',
          userAgent: 'x',
        ),
        throwsArgumentError,
      );
    });

    test('rejects hosts without pins', () {
      expect(
        () => createDio(baseUrl: 'https://example.com', userAgent: 'x'),
        throwsArgumentError,
      );
    });

    test('sets timeouts and the user agent (QRS-020, BUG-009)', () {
      final dio = createDio(baseUrl: cloudBaseUrl, userAgent: 'Falco/3 (ios)');
      expect(dio.options.connectTimeout, const Duration(seconds: 15));
      expect(dio.options.receiveTimeout, const Duration(seconds: 30));
      expect(dio.options.sendTimeout, const Duration(seconds: 30));
      expect(dio.options.headers['user-agent'], 'Falco/3 (ios)');
    });

    test('sends a failed POST exactly once (QRS-020)', () async {
      final adapter = FakeAdapter((_) => (503, null));
      final dio = fakeDio(adapter);
      await expectLater(
        dio.post<Object?>('/servers'),
        throwsA(predicate<Object>((e) => toFalcoError(e) is Server)),
      );
      expect(adapter.requests, hasLength(1));
    });

    test('SET-015 a vault that stays closed fails as Locked, sends nothing '
        'and is not retried (K3)', () async {
      final adapter = FakeAdapter((_) => (200, <String, Object?>{}));
      for (final auth in [
        storedBearerAuth(() => throw PlatformException(code: 'cancel')),
        storedBasicAuth(() => throw const Locked()),
      ]) {
        Object? error;
        try {
          await fakeDio(adapter, auth: auth).get<Object?>('/x');
        } on Object catch (e) {
          error = toFalcoError(e);
        }
        expect(error, isA<Locked>());
        expect(retryDelay(0, error!), isNull);
      }
      expect(adapter.requests, isEmpty);
    });

    test('adds bearer and basic auth', () async {
      final adapter = FakeAdapter((_) => (200, <String, Object?>{}));
      await fakeDio(adapter, auth: bearerAuth('t0k')).get<Object?>('/x');
      await fakeDio(
        adapter,
        baseUrl: 'https://robot-ws.your-server.de',
        auth: basicAuth('user', 'pass'),
      ).get<Object?>('/server');
      expect(adapter.requests[0].headers['authorization'], 'Bearer t0k');
      expect(
        adapter.requests[1].headers['authorization'],
        'Basic ${base64.encode(utf8.encode('user:pass'))}',
      );
    });
  });

  group('pins', () {
    test('every pinned host has a valid root context with TLS 1.2 or '
        'newer (QRS-017, QRS-018)', () {
      for (final host in pinnedRoots.keys) {
        expect(pinnedRoots[host], isNotEmpty, reason: host);
        expect(
          pinnedContext(host).minimumTlsProtocolVersion,
          TlsProtocolVersion.tls1_2,
          reason: host,
        );
      }
    });

    test('covers the Robot, Cloud and Object Storage hosts', () {
      expect(
        pinnedRoots.keys,
        containsAll([
          'api.hetzner.cloud',
          'api.hetzner.com',
          'robot-ws.your-server.de',
          'fsn1.your-objectstorage.com',
          'nbg1.your-objectstorage.com',
          'hel1.your-objectstorage.com',
        ]),
      );
    });

    test('roots are self issued and match their SPKI pin', () {
      for (final MapEntry(:key, :value) in pinnedRoots.entries) {
        for (final der in value) {
          final cert = X509Parts.parse(base64.decode(der));
          expect(cert.selfIssued, isTrue, reason: key);
          expect(pinnedSpki[key], contains(cert.spkiPin), reason: key);
        }
      }
    });

    test('a root without matching pin is refused', () {
      expect(
        () => pinnedContext(
          'api.hetzner.cloud',
          spki: {
            'api.hetzner.cloud': ['AAAA'],
          },
        ),
        throwsStateError,
      );
    });

    test('bucket subdomains use the pins of their location', () {
      expect(
        pinKey('my-bucket.fsn1.your-objectstorage.com', pinnedRoots.keys),
        'fsn1.your-objectstorage.com',
      );
      expect(pinKey('evilhetzner.cloud', ['hetzner.cloud']), isNull);
    });
  });

  group('generated client through createDio', () {
    test('an error status becomes a FalcoError (QRS-021)', () async {
      final adapter = FakeAdapter(
        (_) => (
          403,
          {
            'error': {'code': 'forbidden', 'message': 'read only'},
          },
        ),
      );
      final api = cloud.ActionsApi(cloudServer(fakeDio(adapter)));
      await expectLater(
        unwrap(api.getAction(id: 1)),
        throwsA(isA<Forbidden>()),
      );
      expect(
        adapter.requests.single.uri.toString(),
        'https://api.hetzner.cloud/v1/actions/1',
      );
    });

    test('a success is decoded', () async {
      final adapter = FakeAdapter(
        (_) => (200, fixture('cloud/action_running.json')),
      );
      final api = cloud.ActionsApi(cloudServer(fakeDio(adapter)));
      final action = await cloudActionFetcher(api)(13);
      expect(action.command, 'start_server');
      expect(action.progress, 50);
      expect(action.resources, [('server', 42)]);
    });
  });
}
