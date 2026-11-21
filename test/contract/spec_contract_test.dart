// SPDX-License-Identifier: GPL-3.0-or-later
// Contract tests: the generated models must parse responses built from the
// current specs. The Hetzner specs carry examples per property, not per
// response, so a full response is assembled from the schema: every
// property (optional ones too), the documented example where there is one,
// otherwise a value of the declared type. specs.yml regenerates models and
// specs together, so a breaking Hetzner change fails here in the update PR.
//
// The spec JSON is untyped by nature.
// ignore_for_file: avoid_dynamic_calls
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:hetzner_storage_box_api/hetzner_storage_box_api.dart' as box;

typedef Parser = Object Function(Object? json);

final _cloud = <(String, String), Parser>{
  ('/actions/{id}', '200'): cloud.ActionsIdGet200BodyModel.fromJson,
  ('/servers', '200'): cloud.ServersGet200BodyModel.fromJson,
  ('/servers/{id}', '200'): cloud.ServersIdGet200BodyModel.fromJson,
  ('/servers/{id}/metrics', '200'):
      cloud.ServersIdMetricsGet200BodyModel.fromJson,
  ('/volumes', '200'): cloud.VolumesGet200BodyModel.fromJson,
  ('/images', '200'): cloud.ImagesGet200BodyModel.fromJson,
  ('/firewalls', '200'): cloud.FirewallsGet200BodyModel.fromJson,
  ('/primary_ips', '200'): cloud.PrimaryIpsGet200BodyModel.fromJson,
  ('/load_balancers', '200'): cloud.LoadBalancersGet200BodyModel.fromJson,
  ('/zones/{id_or_name}/rrsets', '200'):
      cloud.ZonesIdOrNameRrsetsGet200BodyModel.fromJson,
  ('/actions/{id}', '4xx'): cloud.ActionsIdGet4xxBodyModel.fromJson,
};

final _box = <(String, String), Parser>{
  ('/storage_boxes', '200'): box.StorageBoxesGet200BodyModel.fromJson,
  ('/storage_boxes/{id}', '200'): box.StorageBoxesIdGet200BodyModel.fromJson,
  ('/storage_boxes/{id}/subaccounts', '200'):
      box.StorageBoxesIdSubaccountsGet200BodyModel.fromJson,
};

/// A JSON value that satisfies [schema].
Object? sample(dynamic schema) {
  if (schema is! Map) return null;
  if (schema.containsKey('example')) return schema['example'];
  if (schema['enum'] is List) return (schema['enum'] as List).first;
  for (final key in ['oneOf', 'anyOf']) {
    if (schema[key] is List) return sample((schema[key] as List).first);
  }
  if (schema['allOf'] is List) {
    return {
      for (final part in schema['allOf'] as List)
        ...(sample(part) as Map? ?? const {}),
    };
  }
  var type = schema['type'];
  if (type is List) type = type.firstWhere((t) => t != 'null');
  return switch (type) {
    'object' => {
      for (final MapEntry(:key, :value)
          in ((schema['properties'] as Map?) ?? const {}).entries)
        key: sample(value),
    },
    'array' => [sample(schema['items'])],
    'integer' => 1,
    'number' => 1.5,
    'boolean' => true,
    'string' => switch (schema['format']) {
      'date-time' => '2026-01-01T00:00:00+00:00',
      'date' => '2026-01-01',
      _ => 'x',
    },
    _ => null,
  };
}

void main() {
  void check(String specPath, Map<(String, String), Parser> parsers) {
    final spec = jsonDecode(File(specPath).readAsStringSync());
    for (final MapEntry(key: (path, status), value: parse) in parsers.entries) {
      test('GET $path $status', () {
        final schema =
            spec['paths'][path]['get']['responses'][status]['content']['application/json']['schema'];
        // Through JSON text, as a real response arrives.
        final json = jsonDecode(jsonEncode(sample(schema)));
        expect(json, isA<Map<String, Object?>>());
        expect(() => parse(json), returnsNormally);
      });
    }
  }

  group('cloud.spec.json', () => check('spec/cloud.spec.json', _cloud));
  group('hetzner.spec.json', () => check('spec/hetzner.spec.json', _box));
}
