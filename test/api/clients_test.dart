// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/api/robot/robot_client.dart';
import 'package:falco/api/s3/s3.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_http.dart';

void main() {
  group('Robot client against fixtures', () {
    RobotClient client(FakeAdapter adapter) => RobotClient(
      fakeDio(adapter, baseUrl: robotBaseUrl, auth: basicAuth('u', 'p')),
    );

    test('GET /server', () async {
      final servers = await client(
        FakeAdapter((_) => (200, fixture('robot/server_list.json'))),
      ).servers();
      expect(servers, hasLength(2));
      expect(servers.first.number, 321);
      expect(servers.first.ipv4, '123.123.123.123');
      expect(servers.first.product, 'DS 3000');
      expect(servers.last.name, '');
      expect(servers.last.cancelled, isTrue);
    });

    test('GET /reset/{number} offers only listed types (BUG-012)', () async {
      final adapter = FakeAdapter(
        (_) => (200, fixture('robot/reset_options.json')),
      );
      expect(await client(adapter).resetTypes(321), ['sw', 'hw', 'man']);
      expect(adapter.requests.single.path, '/reset/321');
    });

    test('Robot errors become FalcoErrors', () async {
      await expectLater(
        client(FakeAdapter((_) => (404, fixture('robot/error_not_found.json'))))
            .servers(),
        throwsA(predicate<Object>((e) => toFalcoError(e) is NotFound)),
      );
    });
  });

  group('S3', () {
    test('SigV4 matches the AWS get-vanilla test vector', () {
      final headers = signV4(
        method: 'GET',
        uri: Uri.parse('https://example.amazonaws.com/'),
        headers: const {},
        payloadHash: emptyPayloadHash,
        accessKey: 'AKIDEXAMPLE',
        secretKey: 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY',
        region: 'us-east-1',
        service: 'service',
        now: DateTime.utc(2015, 8, 30, 12, 36),
      );
      expect(headers['x-amz-date'], '20150830T123600Z');
      expect(
        headers['Authorization'],
        'AWS4-HMAC-SHA256 '
        'Credential=AKIDEXAMPLE/20150830/us-east-1/service/aws4_request, '
        'SignedHeaders=host;x-amz-date, '
        'Signature='
        '5fa00fa31553b73ebf1942676e86291e8372ff2a2260956d9b8aae1d763fbf31',
      );
    });

    test('signs every request', () async {
      final adapter = FakeAdapter((_) => (200, null));
      final dio = createS3Dio(
        endpoint: 'https://fsn1.your-objectstorage.com',
        region: 'fsn1',
        accessKey: 'ak',
        secretKey: 'sk',
        userAgent: 'Falco/test',
      )..httpClientAdapter = adapter;
      await dio.get<Object?>('/bucket', queryParameters: {'list-type': '2'});
      final headers = adapter.requests.single.headers;
      expect(headers['x-amz-content-sha256'], emptyPayloadHash);
      expect(
        headers['Authorization'],
        startsWith('AWS4-HMAC-SHA256 Credential=ak/'),
      );
      expect(headers['Authorization'], contains('/fsn1/s3/aws4_request'));
    });

    test('rejects plain http endpoints (QRS-019)', () {
      expect(
        () => createS3Dio(
          endpoint: 'http://fsn1.your-objectstorage.com',
          region: 'fsn1',
          accessKey: 'ak',
          secretKey: 'sk',
          userAgent: 'x',
        ),
        throwsArgumentError,
      );
    });
  });
}
