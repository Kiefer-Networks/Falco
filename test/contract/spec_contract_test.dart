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
  ('/images/{id}', '200'): cloud.ImagesIdGet200BodyModel.fromJson,
  ('/volumes/{id}', '200'): cloud.VolumesIdGet200BodyModel.fromJson,
  ('/placement_groups', '200'): cloud.PlacementGroupsGet200BodyModel.fromJson,
  ('/placement_groups/{id}', '200'):
      cloud.PlacementGroupsIdGet200BodyModel.fromJson,
  ('/ssh_keys', '200'): cloud.SshKeysGet200BodyModel.fromJson,
  ('/ssh_keys/{id}', '200'): cloud.SshKeysIdGet200BodyModel.fromJson,
  ('/isos', '200'): cloud.IsosGet200BodyModel.fromJson,
  ('/locations', '200'): cloud.LocationsGet200BodyModel.fromJson,
  ('/server_types', '200'): cloud.ServerTypesGet200BodyModel.fromJson,
  ('/pricing', '200'): cloud.PricingGet200BodyModel.fromJson,
  ('/networks', '200'): cloud.NetworksGet200BodyModel.fromJson,
  ('/servers/actions', '200'): cloud.ServersActionsGet200BodyModel.fromJson,
  ('/volumes/actions', '200'): cloud.VolumesActionsGet200BodyModel.fromJson,
  ('/images/actions', '200'): cloud.ImagesActionsGet200BodyModel.fromJson,
  ('/firewalls', '200'): cloud.FirewallsGet200BodyModel.fromJson,
  ('/primary_ips', '200'): cloud.PrimaryIpsGet200BodyModel.fromJson,
  ('/load_balancers', '200'): cloud.LoadBalancersGet200BodyModel.fromJson,
  ('/zones/{id_or_name}/rrsets', '200'):
      cloud.ZonesIdOrNameRrsetsGet200BodyModel.fromJson,
  ('/networks/{id}', '200'): cloud.NetworksIdGet200BodyModel.fromJson,
  ('/networks/{id}/members', '200'):
      cloud.NetworksIdMembersGet200BodyModel.fromJson,
  ('/firewalls/{id}', '200'): cloud.FirewallsIdGet200BodyModel.fromJson,
  ('/floating_ips', '200'): cloud.FloatingIpsGet200BodyModel.fromJson,
  ('/floating_ips/{id}', '200'): cloud.FloatingIpsIdGet200BodyModel.fromJson,
  ('/primary_ips/{id}', '200'): cloud.PrimaryIpsIdGet200BodyModel.fromJson,
  ('/load_balancers/{id}', '200'):
      cloud.LoadBalancersIdGet200BodyModel.fromJson,
  ('/load_balancers/{id}/metrics', '200'):
      cloud.LoadBalancersIdMetricsGet200BodyModel.fromJson,
  ('/load_balancer_types', '200'):
      cloud.LoadBalancerTypesGet200BodyModel.fromJson,
  ('/certificates', '200'): cloud.CertificatesGet200BodyModel.fromJson,
  ('/certificates/{id}', '200'): cloud.CertificatesIdGet200BodyModel.fromJson,
  ('/zones', '200'): cloud.ZonesGet200BodyModel.fromJson,
  ('/zones/{id_or_name}', '200'): cloud.ZonesIdOrNameGet200BodyModel.fromJson,
  ('/zones/{id_or_name}/rrsets/{rr_name}/{rr_type}', '200'):
      cloud.ZonesIdOrNameRrsetsRrNameRrTypeGet200BodyModel.fromJson,
  ('/zones/{id_or_name}/zonefile', '200'):
      cloud.ZonesIdOrNameZonefileGet200BodyModel.fromJson,
  ('/zones/actions', '200'): cloud.ZonesActionsGet200BodyModel.fromJson,
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
