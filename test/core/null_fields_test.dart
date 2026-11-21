// SPDX-License-Identifier: GPL-3.0-or-later
// The generated clients send every nullable field, unset ones as null.
// The request path omits those nulls in one place, keeping the ones the
// API gives a meaning (reset reverse DNS, zone default TTL).
//
// The spec JSON is untyped by nature.
// ignore_for_file: avoid_dynamic_calls
import 'dart:convert';
import 'dart:io';

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_cloud.dart';
import '../fake_http.dart';

void main() {
  test('nulls are dropped recursively, meaningful ones kept', () {
    expect(
      NullFieldsInterceptor.withoutNulls({
        'public_net': {'enable_ipv4': true, 'ipv4': null, 'ipv6': null},
        'dns_ptr': null,
        'ttl': null,
        'list': [
          {'a': null, 'b': 1},
        ],
      }, '/zones/1/rrsets/@/A/actions/add_records'),
      {
        'public_net': {'enable_ipv4': true},
        'dns_ptr': null,
        'list': [
          {'b': 1},
        ],
      },
    );
  });

  test('a server create sends no null Primary IP ids', () async {
    final cloud = FakeCloud();
    final api = cloudServer(
      fakeDio(cloud.adapter, auth: bearerAuth(fakeToken)),
    );
    await createServer(
      api,
      const ServerDraft(
        name: 'a',
        location: 'fsn1',
        type: 'cx22',
        image: 'debian-12',
      ),
    );
    expect(cloud.body('POST /servers')['public_net'], {
      'enable_ipv4': true,
      'enable_ipv6': true,
    });
  });

  test('every required nullable field of the spec keeps its null', () {
    final spec = jsonDecode(File('spec/cloud.spec.json').readAsStringSync());
    final required = <(String, String)>{};
    void walk(dynamic schema, String path) {
      if (schema is! Map) return;
      for (final key in ['allOf', 'oneOf', 'anyOf']) {
        for (final s in schema[key] as List? ?? const []) {
          walk(s, path);
        }
      }
      final req = {...?(schema['required'] as List?)?.cast<String>()};
      for (final MapEntry(:key, :value)
          in ((schema['properties'] as Map?) ?? const {}).entries) {
        final type = value['type'];
        final nullable =
            value['nullable'] == true ||
            (type is List && type.contains('null'));
        if (nullable && req.contains(key)) required.add((path, key as String));
        walk(value, path);
      }
      walk(schema['items'], path);
    }

    for (final MapEntry(key: path, value: ops)
        in (spec['paths'] as Map).entries) {
      for (final op in (ops as Map).values) {
        if (op is Map && op['requestBody'] != null) {
          walk(
            op['requestBody']['content']['application/json']['schema'],
            path as String,
          );
        }
      }
    }
    expect(required, isNotEmpty);
    for (final (path, key) in required) {
      expect(
        path.endsWith(meaningfulNulls[key] ?? '-'),
        isTrue,
        reason: '$key of $path',
      );
    }
  });
}
