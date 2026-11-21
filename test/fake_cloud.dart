// SPDX-License-Identifier: GPL-3.0-or-later
// A fake Hetzner Cloud API and app harness shared by widget, golden and
// integration tests. Data is made up; no file IO, so it also runs on a
// device.
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/api/robot/robot_client.dart';
import 'package:falco/api/s3/s3.dart';
import 'package:falco/core/files/text_files.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/features/accounts/checks.dart';
import 'package:falco/features/storage/object_storage.dart';
import 'package:falco/features/storage/transfers.dart';
import 'package:falco/main.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_http.dart';
import 'fake_network.dart';
import 'fake_robot.dart';
import 'fake_storage.dart';

export 'fake_network.dart';
export 'fake_storage.dart';

/// A made up token, never valid anywhere.
const fakeToken = 'fake-token-for-tests';

/// Made up Robot webservice login.
const fakeRobotUser = '#ws+fake';

/// Made up Robot webservice password.
const fakeRobotPassword = 'fake-robot-password';

/// Made up S3 access key; the secret key is not checked by the fake.
const fakeAccessKey = 'FAKEACCESSKEY';

/// [acme] with Robot access.
const acmeRobot = Account(
  id: 'a1',
  name: 'Acme',
  hasRobot: true,
  projects: [Project(id: 'p1', name: 'prod')],
);

/// One account "Acme" with project "prod" (ids a1, p1).
const acme = Account(
  id: 'a1',
  name: 'Acme',
  projects: [Project(id: 'p1', name: 'prod')],
);

const Map<String, Object?> _fsn1 = {
  'id': 1,
  'name': 'fsn1',
  'description': 'Falkenstein DC Park 1',
  'country': 'DE',
  'city': 'Falkenstein',
  'latitude': 50.47612,
  'longitude': 12.370071,
  'network_zone': 'eu-central',
};

/// A complete `server_type` object; cx22 costs 4.51 a month in fsn1.
Map<String, Object?> serverTypeJson({
  int id = 1,
  String name = 'cx22',
  int cores = 2,
  num memory = 4,
  int disk = 40,
  String price = '4.5100000000',
}) => {
  'id': id,
  'name': name,
  'description': name.toUpperCase(),
  'cores': cores,
  'memory': memory,
  'disk': disk,
  'prices': [
    {
      'location': 'fsn1',
      'price_hourly': {'net': '0.0060000000', 'gross': '0.0071400000'},
      'price_monthly': {'net': price, 'gross': price},
      'included_traffic': 21990232555520,
      'price_per_tb_traffic': {'net': '1.0000000000', 'gross': '1.1900000000'},
    },
  ],
  'storage_type': 'local',
  'cpu_type': 'shared',
  'category': 'cost_optimized',
  'architecture': 'x86',
  'deprecation': null,
  'locations': [
    {
      'id': 1,
      'name': 'fsn1',
      'deprecation': null,
      'recommended': true,
      'available': true,
    },
  ],
};

/// A complete `image` object; [type] is system, snapshot or backup.
Map<String, Object?> imageJson({
  required int id,
  required String description,
  String type = 'system',
  String? name,
  num? size,
  String? createdFrom,
}) => {
  'id': id,
  'type': type,
  'status': 'available',
  'name': name,
  'description': description,
  'image_size': size,
  'disk_size': 5,
  'created': '2026-03-0${id % 9 + 1}T06:00:02Z',
  'created_from': createdFrom == null ? null : {'id': 1, 'name': createdFrom},
  'bound_to': null,
  'os_flavor': 'debian',
  'os_version': '12',
  'rapid_deploy': type == 'system',
  'protection': {'delete': false},
  'deprecation': null,
  'deleted': null,
  'labels': <String, Object?>{},
  'architecture': 'x86',
};

/// A complete `server` object of the Cloud API.
Map<String, Object?> serverJson({
  required int id,
  required String name,
  String status = 'running',
  Map<String, Object?>? type,
  Map<String, Object?>? placementGroup,
  List<int> volumes = const [],
  Map<String, String> labels = const {},
}) => {
  'id': id,
  'name': name,
  'status': status,
  'created': '2026-01-0${id % 9 + 1}T10:00:00Z',
  'public_net': {
    'ipv4': {
      'id': 1000 + id,
      'ip': '203.0.113.$id',
      'blocked': false,
      'dns_ptr': 'static.example.com',
    },
    'ipv6': {
      'id': 2000 + id,
      'ip': '2001:db8:$id::/64',
      'blocked': false,
      'dns_ptr': <Object?>[],
    },
    'floating_ips': <Object?>[],
    'firewalls': <Object?>[],
  },
  'private_net': <Object?>[],
  'server_type': type ?? serverTypeJson(),
  'location': _fsn1,
  'image': imageJson(id: 7, name: 'debian-12', description: 'Debian 12'),
  'iso': null,
  'rescue_enabled': false,
  'locked': false,
  'backup_window': null,
  'outgoing_traffic': 0,
  'ingoing_traffic': 0,
  'included_traffic': 21990232555520,
  'protection': {'delete': false, 'rebuild': false},
  'labels': labels,
  'volumes': volumes,
  'load_balancers': <Object?>[],
  'primary_disk_size': 40,
  'placement_group': placementGroup,
};

/// A complete `volume` object.
Map<String, Object?> volumeJson({
  required int id,
  required String name,
  int size = 50,
  int? server,
}) => {
  'id': id,
  'created': '2026-02-0${id % 9 + 1}T10:00:00Z',
  'name': name,
  'server': server,
  'assignee': server == null ? null : {'id': server, 'type': 'server'},
  'location': _fsn1,
  'size': size,
  'linux_device': '/dev/disk/by-id/scsi-0HC_Volume_$id',
  'protection': {'delete': false},
  'labels': <String, Object?>{},
  'status': 'available',
  'format': 'ext4',
};

/// A complete `placement_group` object.
Map<String, Object?> placementGroupJson({
  required int id,
  required String name,
  List<int> servers = const [],
}) => {
  'id': id,
  'name': name,
  'labels': <String, Object?>{},
  'type': 'spread',
  'created': '2026-02-01T10:00:00Z',
  'servers': servers,
};

/// A complete `ssh_key` object with a made up key.
Map<String, Object?> sshKeyJson({required int id, required String name}) => {
  'id': id,
  'name': name,
  'fingerprint': 'b7:2f:30:a0:2f:6c:58:6c:21:04:58:61:ba:06:3b:2$id',
  'public_key': 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFAKEFAKEFAKE$id fake',
  'labels': <String, Object?>{},
  'created': '2026-01-01T10:00:00Z',
};

Map<String, Object?> _price(String v) => {'net': v, 'gross': v};

/// A complete `pricing` object: EUR, volumes 0.0440 per GB and month.
final Map<String, Object?> pricingJson = {
  'currency': 'EUR',
  'vat_rate': '19.00',
  'primary_ips': <Object?>[],
  'floating_ips': <Object?>[],
  'image': {'price_per_gb_month': _price('0.0110000000')},
  'volume': {'price_per_gb_month': _price('0.0440000000')},
  'server_backup': {'percentage': '20.0000000000'},
  'server_types': <Object?>[],
  'load_balancer_types': <Object?>[],
  'floating_ip': {'price_monthly': _price('3.0000000000')},
};

Map<String, Object?> _meta(int total) => {
  'pagination': {
    'page': 1,
    'per_page': 50,
    'previous_page': null,
    'next_page': null,
    'last_page': 1,
    'total_entries': total,
  },
};

/// One page of [items] as [key], by the `page` and `per_page` query.
(int, Object?) _paged(RequestOptions o, String key, List<Object?> items) {
  final q = o.uri.queryParameters;
  final per = int.tryParse(q['per_page'] ?? '') ?? 50;
  final page = int.tryParse(q['page'] ?? '') ?? 1;
  final last = items.isEmpty ? 1 : (items.length + per - 1) ~/ per;
  return (
    200,
    {
      key: items.skip((page - 1) * per).take(per).toList(),
      'meta': {
        'pagination': {
          'page': page,
          'per_page': per,
          'previous_page': page > 1 ? page - 1 : null,
          'next_page': page < last ? page + 1 : null,
          'last_page': last,
          'total_entries': items.length,
        },
      },
    },
  );
}

/// A Cloud API error body.
Map<String, Object?> errorJson(String code) => {
  'error': {'code': code, 'message': code, 'details': null},
};

// Collection to its object key: `servers` holds `server` objects.
const _singular = {
  'servers': 'server',
  'volumes': 'volume',
  'images': 'image',
  'placement_groups': 'placement_group',
  'ssh_keys': 'ssh_key',
  'isos': 'iso',
  'locations': 'location',
  'server_types': 'server_type',
  'networks': 'network',
  'firewalls': 'firewall',
  'floating_ips': 'floating_ip',
  'primary_ips': 'primary_ip',
  'load_balancers': 'load_balancer',
  'load_balancer_types': 'load_balancer_type',
  'certificates': 'certificate',
  'zones': 'zone',
};

/// In memory Cloud API: every Compute, Network and DNS resource, their
/// actions, metrics.
///
/// An action starts `running` and ends `success` on its second poll;
/// power actions then change the server status.
class FakeCloud {
  new({
    List<Map<String, Object?>>? servers,
    List<Map<String, Object?>>? actions,
    List<Map<String, Object?>>? volumes,
    List<Map<String, Object?>>? images,
    List<Map<String, Object?>>? placementGroups,
    List<Map<String, Object?>>? sshKeys,
    List<Map<String, Object?>>? networks,
    List<Map<String, Object?>>? firewalls,
    List<Map<String, Object?>>? floatingIps,
    List<Map<String, Object?>>? primaryIps,
    List<Map<String, Object?>>? loadBalancers,
    List<Map<String, Object?>>? certificates,
    List<Map<String, Object?>>? zones,
    Map<int, List<Map<String, Object?>>>? rrsets,
    FakeStorage? storage,
  }) : actions = actions ?? [],
       storage = storage ?? FakeStorage(),
       rrsets = rrsets ?? {},
       collections = {
         'servers':
             servers ??
             [
               serverJson(id: 1, name: 'web-1'),
               serverJson(id: 2, name: 'db-1', status: 'off'),
             ],
         'volumes': volumes ?? [],
         'images':
             images ??
             [imageJson(id: 7, name: 'debian-12', description: 'Debian 12')],
         'placement_groups': placementGroups ?? [],
         'ssh_keys': sshKeys ?? [],
         'isos': [
           {
             'id': 51,
             'name': 'virtio-win-0.1.248.iso',
             'description': 'virtio 0.1.248',
             'type': 'public',
             'deprecation': null,
             'architecture': 'x86',
           },
         ],
         'locations': [_fsn1],
         'server_types': [
           serverTypeJson(),
           serverTypeJson(
             id: 2,
             name: 'cx32',
             cores: 4,
             memory: 8,
             disk: 80,
             price: '7.4900000000',
           ),
         ],
         'networks': networks ?? [],
         'firewalls': firewalls ?? [],
         'floating_ips': floatingIps ?? [],
         'primary_ips': primaryIps ?? [],
         'load_balancers': loadBalancers ?? [],
         'load_balancer_types': [
           lbTypeJson(),
           lbTypeJson(
             id: 2,
             name: 'lb21',
             services: 15,
             price: '16.4000000000',
           ),
         ],
         'certificates': certificates ?? [],
         'zones': zones ?? [],
       };

  /// RRSets per zone id.
  final Map<int, List<Map<String, Object?>>> rrsets;

  /// Storage Boxes (api.hetzner.com) and Object Storage (S3).
  final FakeStorage storage;

  /// The Robot webservice.
  final robot = FakeRobot();

  /// The last imported zone file.
  String? importedZonefile;

  /// The file dialogs: what a pick returns, what was saved.
  final files = FakeTextFiles();

  /// Whether load balancer metrics have samples.
  bool lbMetrics = true;

  /// Objects per collection, e.g. `collections['volumes']`.
  final Map<String, List<Map<String, Object?>>> collections;
  final List<Map<String, Object?>> actions;

  List<Map<String, Object?>> get servers => collections['servers']!;
  List<Map<String, Object?>> get volumes => collections['volumes']!;
  List<Map<String, Object?>> get images => collections['images']!;

  /// When set, every request answers with this (status, body).
  (int, Object?)? failWith;

  /// Polls of `GET /actions/{id}` until a running action succeeds.
  int pollsToFinish = 2;

  /// Tokens the API accepts.
  final Set<String> validTokens = {fakeToken};

  late final FakeAdapter adapter = FakeAdapter(_handle);
  final _polls = <int, int>{};
  var _nextId = 100;

  /// Paths of all requests as `METHOD /path`.
  List<String> get calls => [
    for (final r in adapter.requests)
      '${r.method} ${Uri.decodeFull(r.uri.path).replaceFirst('/v1', '')}',
  ];

  /// JSON body of the last request to `METHOD /path`.
  Map<String, Object?> body(String call) {
    final r = adapter.requests.lastWhere(
      (r) =>
          '${r.method} ${Uri.decodeFull(r.uri.path).replaceFirst('/v1', '')}' ==
          call,
    );
    return (jsonDecode(r.data as String) as Map).cast<String, Object?>();
  }

  /// An action of the API on resource [type] [id].
  static Map<String, Object?> action(
    int id,
    String command,
    int resourceId, {
    String status = 'success',
    DateTime? started,
    String type = 'server',
  }) => {
    'id': id,
    'command': command,
    'status': status,
    'progress': status == 'running' ? 0 : 100,
    'started': (started ?? DateTime.now().subtract(const Duration(minutes: 5)))
        .toUtc()
        .toIso8601String(),
    'finished': null,
    'resources': [
      {'id': resourceId, 'type': type},
    ],
    'error': status == 'error'
        ? {'code': 'action_failed', 'message': 'Action failed'}
        : null,
  };

  Map<String, Object?> _start(String command, int id, String type) {
    final a = action(
      900 + actions.length,
      command,
      id,
      status: 'running',
      started: DateTime.now(),
      type: type,
    );
    actions.insert(0, a);
    return a;
  }

  (int, Object?) _handle(RequestOptions o) {
    if (failWith case final f?) return f;
    final auth0 = '${o.headers['authorization']}';
    if (o.uri.host == 'robot-ws.your-server.de') {
      final login = utf8.encode('$fakeRobotUser:$fakeRobotPassword');
      return auth0 == 'Basic ${base64.encode(login)}'
          ? robot.handle(o)
          : (
              401,
              {
                'error': {'status': 401, 'code': 'UNAUTHORIZED', 'message': ''},
              },
            );
    }
    if (o.uri.host.endsWith('.your-objectstorage.com')) {
      return storage.s3(o, auth0, fakeAccessKey);
    }
    if (!validTokens.any((t) => auth0 == 'Bearer $t')) {
      return (401, errorJson('unauthorized'));
    }
    if (o.uri.host == 'api.hetzner.com') return storage.box(o);
    final path = o.uri.path.replaceFirst('/v1', '');
    final segments = path.split('/').skip(1).map(Uri.decodeComponent).toList();
    final body = o.data is String
        ? (jsonDecode(o.data as String) as Map).cast<String, Object?>()
        : const <String, Object?>{};
    Map<String, Object?>? find(String coll, String id) =>
        collections[coll]?.where((s) => '${s['id']}' == id).firstOrNull;
    List<Map<String, Object?>> actionsOf(String type, [String? id]) => [
      for (final a in actions)
        if ((a['resources']! as List).any(
          (r) =>
              (r as Map)['type'] == type && (id == null || '${r['id']}' == id),
        ))
          a,
    ];

    if (_network(o.method, segments, body) case final r?) return r;
    switch ((o.method, segments)) {
      case ('GET', ['pricing']):
        return (200, {'pricing': pricingJson});
      case ('GET', [final coll, 'actions']) when _singular.containsKey(coll):
        return _paged(o, 'actions', actionsOf(_singular[coll]!));
      case ('GET', [final coll]) when collections.containsKey(coll):
        final all = collections[coll]!;
        return (200, {coll: all, 'meta': _meta(all.length)});
      case ('GET', ['servers', _, 'metrics']):
        final now = DateTime.now().toUtc();
        final t = now.millisecondsSinceEpoch / 1000;
        return (
          200,
          {
            'metrics': {
              'start': now.toIso8601String(),
              'end': now.toIso8601String(),
              'step': 60,
              'time_series': {
                'cpu': {
                  'values': [
                    [t - 120, '2.0'],
                    [t - 60, '6.0'],
                    [t, '4.0'],
                  ],
                },
              },
            },
          },
        );
      case ('GET', [final coll, final id, 'actions']):
        return _paged(o, 'actions', actionsOf(_singular[coll] ?? coll, id));
      case ('GET', [final coll, final id]) when collections.containsKey(coll):
        final s = find(coll, id);
        return s == null
            ? (404, errorJson('not_found'))
            : (200, {_singular[coll]!: s});
      case ('PUT', [final coll, final id]) when collections.containsKey(coll):
        final s = find(coll, id);
        if (s == null) return (404, errorJson('not_found'));
        s.addAll(body);
        return (200, {_singular[coll]!: s});
      case ('DELETE', [final coll, final id])
          when collections.containsKey(coll):
        final s = find(coll, id);
        if (s == null) return (404, errorJson('not_found'));
        collections[coll]!.remove(s);
        if (coll case 'servers' || 'zones') {
          final type = _singular[coll]!;
          return (
            coll == 'zones' ? 201 : 200,
            {'action': _start('delete_$type', s['id']! as int, type)},
          );
        }
        return (204, null);
      case ('POST', ['servers']):
        final id = _nextId++;
        final type = collections['server_types']!.firstWhere(
          (t) => t['name'] == body['server_type'],
        );
        final s = serverJson(
          id: id,
          name: body['name']! as String,
          status: 'initializing',
          type: type,
          volumes: [...?(body['volumes'] as List?)?.cast<int>()],
          labels: (body['labels'] as Map? ?? {}).cast<String, String>(),
        );
        servers.add(s);
        return (
          201,
          {
            'server': s,
            'action': _start('create_server', id, 'server'),
            'next_actions': [
              if (body['start_after_create'] != false)
                _start('start_server', id, 'server'),
            ],
            'root_password': (body['ssh_keys'] as List? ?? []).isEmpty
                ? 'fake-root-password'
                : null,
          },
        );
      case ('POST', ['volumes']):
        final id = _nextId++;
        final v = volumeJson(
          id: id,
          name: body['name']! as String,
          size: body['size']! as int,
          server: (body['assignee'] as Map?)?['id'] as int?,
        );
        volumes.add(v);
        return (
          201,
          {
            'volume': v,
            'action': _start('create_volume', id, 'volume'),
            'next_actions': [
              if (body['assignee'] != null)
                _start('attach_volume', id, 'volume'),
            ],
          },
        );
      case ('POST', [final coll]) when collections.containsKey(coll):
        final id = _nextId++;
        final created = switch (coll) {
          'placement_groups' => placementGroupJson(
            id: id,
            name: body['name']! as String,
          ),
          _ => sshKeyJson(id: id, name: body['name']! as String),
        };
        collections[coll]!.add(created);
        return (201, {_singular[coll]!: created});
      case ('POST', [final coll, final id, 'actions', final command]):
        final type = _singular[coll]!;
        final a = _start('${command}_$type', int.parse(id), type);
        final target = find(coll, id);
        switch (command) {
          case 'attach':
            target?['server'] = (body['assignee']! as Map)['id'];
            target?['assignee'] = body['assignee'];
          case 'detach':
            target?['server'] = null;
            target?['assignee'] = null;
          case 'change_protection':
            target?['protection'] = {
              ...(target['protection']! as Map).cast<String, Object?>(),
              ...body,
            };
          case 'enable_rescue':
            target?['rescue_enabled'] = true;
        }
        return (
          201,
          {
            'action': a,
            if (command case 'reset_password' || 'rebuild' || 'enable_rescue')
              'root_password': 'fake-root-password',
            if (command == 'request_console') ...{
              'wss_url': 'wss://console.example.com/?token=fake',
              'password': 'fake-vnc-password',
            },
            if (command == 'create_image')
              'image': imageJson(
                id: _nextId++,
                description: '${body['description']}',
                type: 'snapshot',
              ),
          },
        );
      case ('GET', ['actions', final id]):
        final a = actions.firstWhere((a) => '${a['id']}' == id);
        final polls = _polls[a['id']! as int] = (_polls[a['id']] ?? 0) + 1;
        if (polls >= pollsToFinish && a['status'] == 'running') _finish(a);
        return (200, {'action': a});
    }
    return (404, errorJson('not_found'));
  }

  /// Network and DNS requests; null for everything else.
  (int, Object?)? _network(
    String method,
    List<String> segments,
    Map<String, Object?> body,
  ) {
    const colls = {
      'networks',
      'firewalls',
      'floating_ips',
      'primary_ips',
      'load_balancers',
      'certificates',
      'zones',
    };
    Map<String, Object?>? find(String coll, String id) =>
        collections[coll]?.where((s) => '${s['id']}' == id).firstOrNull;
    List<Map<String, Object?>> list(Map<String, Object?> o, String key) {
      final l = [...?(o[key] as List?)?.cast<Map<String, Object?>>()];
      o[key] = l;
      return l;
    }

    final now = DateTime.now().toUtc();
    switch ((method, segments)) {
      case ('GET', ['networks', final id, 'members']):
        final members = [
          for (final s in servers)
            for (final n
                in (s['private_net']! as List).cast<Map<String, Object?>>())
              if ('${n['network']}' == id)
                {
                  'type': 'server',
                  'id': s['id'],
                  'ip': n['ip'],
                  'status': 'ok',
                  'alias_ips': n['alias_ips'] ?? <String>[],
                  'subnet': '10.0.1.0/24',
                },
          for (final lb in collections['load_balancers']!)
            for (final n
                in (lb['private_net']! as List).cast<Map<String, Object?>>())
              if ('${n['network']}' == id)
                {
                  'type': 'load_balancer',
                  'id': lb['id'],
                  'ip': n['ip'],
                  'status': 'ok',
                  'alias_ips': <String>[],
                  'subnet': '10.0.1.0/24',
                },
        ];
        return (200, {'members': members, 'meta': _meta(members.length)});
      case ('GET', ['load_balancers', _, 'metrics']):
        final t = now.millisecondsSinceEpoch / 1000;
        // No samples with [lbMetrics] off: goldens without a time axis.
        List<List<Object>> values(String v) => [
          if (lbMetrics) ...[
            [t - 60, v],
            [t, v],
          ],
        ];
        return (
          200,
          {
            'metrics': {
              'start': now.toIso8601String(),
              'end': now.toIso8601String(),
              'step': 60,
              'time_series': {
                'open_connections': {'values': values('12')},
                'connections_per_second': {'values': values('3')},
                'requests_per_second': {'values': values('7')},
                'bandwidth.in': {'values': values('2048')},
                'bandwidth.out': {'values': values('4096')},
              },
            },
          },
        );
      case ('GET', ['zones', final z, 'rrsets']):
        final sets = rrsets[int.parse(z)] ?? [];
        return (200, {'rrsets': sets, 'meta': _meta(sets.length)});
      case ('GET', ['zones', final z, 'zonefile']):
        final zone = find('zones', z)!;
        return (
          200,
          {
            'zonefile': [
              '\$ORIGIN ${zone['name']}.',
              for (final r in rrsets[int.parse(z)] ?? <Map<String, Object?>>[])
                for (final v
                    in (r['records']! as List).cast<Map<String, Object?>>())
                  '${r['name']} IN ${r['type']} ${v['value']}',
            ].join('\n'),
          },
        );
      case ('GET', ['zones', final z, 'rrsets', final n, final t]):
        final set = (rrsets[int.parse(z)] ?? [])
            .where((r) => r['name'] == n && r['type'] == t)
            .firstOrNull;
        return set == null
            ? (404, errorJson('not_found'))
            : (200, {'rrset': set});
      case ('POST', ['zones', final z, 'rrsets']):
        final zone = int.parse(z);
        final set = rrsetJson(
          zone: zone,
          name: body['name']! as String,
          type: body['type']! as String,
          ttl: body['ttl'] as int?,
          values: [
            for (final r
                in (body['records']! as List).cast<Map<String, Object?>>())
              '${r['value']}',
          ],
        );
        (rrsets[zone] ??= []).add(set);
        return (
          201,
          {'rrset': set, 'action': _start('create_rrset', zone, 'zone')},
        );
      case ('PUT', ['zones', final z, 'rrsets', final n, final t]):
        final set = rrsets[int.parse(z)]!.firstWhere(
          (r) => r['name'] == n && r['type'] == t,
        );
        set['labels'] = body['labels'];
        return (200, {'rrset': set});
      case ('DELETE', ['zones', final z, 'rrsets', final n, final t]):
        rrsets[int.parse(z)]!.removeWhere(
          (r) => r['name'] == n && r['type'] == t,
        );
        return (201, {'action': _start('delete_rrset', int.parse(z), 'zone')});
      case (
        'POST',
        ['zones', final z, 'rrsets', final n, final t, 'actions', final cmd],
      ):
        final set = rrsets[int.parse(z)]!.firstWhere(
          (r) => r['name'] == n && r['type'] == t,
        );
        final records = list(set, 'records');
        final given = [
          for (final r
              in (body['records'] as List? ?? const [])
                  .cast<Map<String, Object?>>())
            <String, Object?>{
              'value': r['value'],
              'comment': r['comment'] ?? '',
            },
        ];
        switch (cmd) {
          case 'add_records':
            records.addAll(given);
            if (body['ttl'] case final int ttl) set['ttl'] = ttl;
          case 'set_records':
            set['records'] = given;
          case 'remove_records':
            records.removeWhere(
              (r) => given.any((g) => g['value'] == r['value']),
            );
          case 'update_records':
            for (final r in records) {
              for (final g in given) {
                if (g['value'] == r['value']) r['comment'] = g['comment'];
              }
            }
          case 'change_ttl':
            set['ttl'] = body['ttl'];
          case 'change_protection':
            set['protection'] = body;
        }
        return (201, {'action': _start('${cmd}_rrset', int.parse(z), 'zone')});
      case ('POST', [final coll]) when colls.contains(coll):
        final id = _nextId++;
        final name = '${body['name'] ?? 'ip-$id'}';
        final type = _singular[coll]!;
        List<Map<String, Object?>> items(String key) =>
            (body[key] as List? ?? const []).cast();
        final created = switch (coll) {
          'networks' => networkJson(
            id: id,
            name: name,
            ipRange: body['ip_range']! as String,
            subnets: [
              for (final sn in items('subnets'))
                networkSubnetJson(
                  ipRange: '${sn['ip_range'] ?? '10.0.1.0/24'}',
                  type: '${sn['type']}',
                ),
            ],
          ),
          'firewalls' => firewallJson(
            id: id,
            name: name,
            rules: [for (final r in items('rules')) _rule(r)],
            servers: [
              for (final a in items('apply_to'))
                if (a['server'] case final Map<String, Object?> s)
                  s['id']! as int,
            ],
          ),
          'floating_ips' => floatingIpJson(
            id: id,
            name: name,
            server: body['server'] as int?,
            ipv6: body['type'] == 'ipv6',
          ),
          'primary_ips' => primaryIpJson(
            id: id,
            name: name,
            server: body['assignee_id'] as int?,
            ipv6: body['type'] == 'ipv6',
          ),
          'load_balancers' => loadBalancerJson(
            id: id,
            name: name,
            services: [
              for (final sv in items('services')) sv.cast<String, Object?>(),
            ],
            targets: [
              for (final t in items('targets'))
                lbTargetFromBody(t.cast<String, Object?>()),
            ],
            networks: [?body['network'] as int?],
          ),
          'certificates' => certificateJson(
            id: id,
            name: name,
            managed: body['type'] == 'managed',
            domains: [...?(body['domain_names'] as List?)?.cast<String>()],
          ),
          _ => zoneJson(
            id: id,
            name: name,
            ttl: body['ttl'] as int? ?? 3600,
            primaries: body['mode'] == 'secondary'
                ? [
                    for (final p in items('primary_nameservers'))
                      p.cast<String, Object?>(),
                  ]
                : null,
          ),
        };
        collections[coll]!.add(created);
        return (
          201,
          {
            type: created,
            if (coll == 'firewalls')
              'actions': <Object?>[]
            else if (coll != 'networks' &&
                (coll != 'certificates' || body['type'] == 'managed'))
              'action': _start('create_$type', id, type),
          },
        );
      case ('POST', [final coll, final id, 'actions', final command])
          when colls.contains(coll) ||
              (coll == 'servers' &&
                  (command.contains('network') ||
                      command == 'change_alias_ips')):
        final type = _singular[coll]!;
        final o = find(coll, id)!;
        final a = _start('${command}_$type', int.parse(id), type);
        List<Map<String, Object?>> given(String key) =>
            (body[key]! as List).cast();
        switch ((coll, command)) {
          case (_, 'change_protection'):
            o['protection'] = {
              ...(o['protection']! as Map).cast<String, Object?>(),
              ...body,
            };
          case ('networks', 'add_subnet'):
            list(o, 'subnets').add(
              networkSubnetJson(
                ipRange: '${body['ip_range'] ?? '10.0.2.0/24'}',
                type: '${body['type']}',
                vswitch: body['vswitch_id'] as int?,
              ),
            );
          case ('networks', 'delete_subnet'):
            list(
              o,
              'subnets',
            ).removeWhere((sn) => sn['ip_range'] == body['ip_range']);
          case ('networks', 'add_route'):
            list(o, 'routes').add(body);
          case ('networks', 'delete_route'):
            list(
              o,
              'routes',
            ).removeWhere((r) => r['destination'] == body['destination']);
          case ('networks', 'change_ip_range'):
            o['ip_range'] = body['ip_range'];
          case ('firewalls', 'set_rules'):
            o['rules'] = [for (final r in given('rules')) _rule(r)];
          case ('firewalls', 'apply_to_resources'):
            list(o, 'applied_to').addAll(given('apply_to'));
          case ('firewalls', 'remove_from_resources'):
            final gone = {for (final r in given('remove_from')) jsonEncode(r)};
            list(
              o,
              'applied_to',
            ).removeWhere((t) => gone.contains(jsonEncode(t)));
          case ('floating_ips', 'assign'):
            o['server'] = body['server'];
          case ('floating_ips', 'unassign'):
            o['server'] = null;
          case ('primary_ips', 'assign'):
            o['assignee_id'] = body['assignee_id'];
          case ('primary_ips', 'unassign'):
            o['assignee_id'] = null;
          case ('floating_ips' || 'primary_ips', 'change_dns_ptr'):
            o['dns_ptr'] = [
              if (body['dns_ptr'] != null)
                {'ip': body['ip'], 'dns_ptr': body['dns_ptr']},
            ];
          case ('load_balancers', 'change_dns_ptr'):
            ((o['public_net']! as Map)['ipv4']! as Map)['dns_ptr'] =
                body['dns_ptr'];
          case ('load_balancers', 'add_service'):
            list(o, 'services').add(body);
          case ('load_balancers', 'update_service'):
            final services = list(o, 'services');
            final i = services.indexWhere(
              (sv) => sv['listen_port'] == body['listen_port'],
            );
            services[i] = {...services[i], ...body};
          case ('load_balancers', 'delete_service'):
            list(
              o,
              'services',
            ).removeWhere((sv) => sv['listen_port'] == body['listen_port']);
          case ('load_balancers', 'add_target'):
            list(o, 'targets').add(lbTargetFromBody(body));
          case ('load_balancers', 'remove_target'):
            final key = '${body['type']}';
            list(o, 'targets').removeWhere(
              (t) =>
                  t['type'] == key &&
                  jsonEncode(t[key]) == jsonEncode(body[key]),
            );
          case ('load_balancers', 'change_algorithm'):
            o['algorithm'] = body;
          case ('load_balancers', 'change_type'):
            o['load_balancer_type'] = collections['load_balancer_types']!
                .firstWhere((t) => t['name'] == body['load_balancer_type']);
          case ('load_balancers', 'enable_public_interface'):
            (o['public_net']! as Map)['enabled'] = true;
          case ('load_balancers', 'disable_public_interface'):
            (o['public_net']! as Map)['enabled'] = false;
          case ('load_balancers' || 'servers', 'attach_to_network'):
            list(o, 'private_net').add({
              'network': body['network'],
              'ip': body['ip'] ?? '10.0.1.${o['id']}',
              if (coll == 'servers') ...{
                'alias_ips': body['alias_ips'] ?? <String>[],
                'mac_address': '86:00:00:2a:7d:e0',
              },
            });
          case ('load_balancers' || 'servers', 'detach_from_network'):
            list(
              o,
              'private_net',
            ).removeWhere((n) => n['network'] == body['network']);
          case ('servers', 'change_alias_ips'):
            for (final n in list(o, 'private_net')) {
              if (n['network'] == body['network']) {
                n['alias_ips'] = body['alias_ips'];
              }
            }
          case ('certificates', 'retry'):
            o['status'] = {
              'issuance': 'pending',
              'renewal': 'unavailable',
              'error': null,
            };
          case ('zones', 'change_ttl'):
            o['ttl'] = body['ttl'];
          case ('zones', 'change_primary_nameservers'):
            o['primary_nameservers'] = body['primary_nameservers'];
          case ('zones', 'import_zonefile'):
            final zone = int.parse(id);
            final text = importedZonefile = body['zonefile']! as String;
            rrsets[zone] = [
              for (final line in text.split('\n'))
                if (line.trim().split(RegExp(r'\s+')) case [
                  final n,
                  'IN',
                  final t,
                  ...final v,
                ])
                  rrsetJson(
                    zone: zone,
                    name: n,
                    type: t,
                    values: [v.join(' ')],
                  ),
            ];
        }
        return (
          201,
          coll == 'firewalls'
              ? {
                  'actions': [a],
                }
              : {'action': a},
        );
    }
    return null;
  }

  static Map<String, Object?> _rule(Map<Object?, Object?> r) => ruleJson(
    direction: '${r['direction']}',
    protocol: '${r['protocol']}',
    port: r['port'] as String?,
    ips: [
      ...?((r['source_ips'] ?? r['destination_ips']) as List?)?.cast<String>(),
    ],
    description: r['description'] as String?,
  );

  void _finish(Map<String, Object?> a) {
    a
      ..['status'] = 'success'
      ..['progress'] = 100;
    final id = ((a['resources']! as List).first as Map)['id'];
    final s = servers.where((s) => s['id'] == id).firstOrNull;
    if (s == null) return;
    switch (a['command']) {
      case 'poweroff_server' || 'shutdown_server':
        s['status'] = 'off';
      case 'reboot_server' ||
          'reset_server' ||
          'poweron_server' ||
          'create_server':
        s['status'] = 'running';
    }
  }
}

/// Seeds the secure storage: [accounts] plus a token for every project.
void seedSecrets(List<Account> accounts, {bool s3 = false}) {
  FlutterSecureStorage.setMockInitialValues({
    if (s3)
      for (final a in accounts)
        for (final p in a.projects)
          's3.${p.id}': jsonEncode({
            'accessKey': fakeAccessKey,
            'secretKey': 'fake-secret',
            'endpoint': 'https://fsn1.your-objectstorage.com',
            'region': 'fsn1',
          }),
    if (accounts.isNotEmpty)
      'accounts': jsonEncode([for (final a in accounts) a.toJson()]),
    for (final a in accounts)
      for (final p in a.projects) 'cloud.${p.id}': fakeToken,
    for (final a in accounts)
      if (a.hasRobot)
        'robot.${a.id}': jsonEncode({
          'user': fakeRobotUser,
          'password': fakeRobotPassword,
        }),
  });
}

/// Fresh preferences holding [values].
Future<SharedPreferences> testPrefs([
  Map<String, Object> values = const {},
]) async {
  SharedPreferences.setMockInitialValues(values);
  return await SharedPreferences.getInstance();
}

/// File dialogs without dialogs: [picked] is what the user picks, [saved]
/// collects saved files by name.
class FakeTextFiles extends TextFiles {
  PickedText? picked;

  /// What a pick of any file returns (uploads).
  File? pickedFile;
  final saved = <String, String>{};

  @override
  Future<PickedText?> pick({required int maxBytes}) async => picked;

  @override
  Future<File?> pickFile() async => pickedFile;

  @override
  Future<bool> save(String name, String text) async {
    saved[name] = text;
    return true;
  }
}

/// Overrides that route every API of the app to [cloud].
List<Override> fakeApis(FakeCloud cloud) => [
  textFilesProvider.overrideWithValue(cloud.files),
  cloudDioProvider.overrideWithValue(
    (auth) => fakeDio(cloud.adapter, auth: auth),
  ),
  storageBoxDioProvider.overrideWithValue(
    (auth) => fakeDio(cloud.adapter, baseUrl: storageBoxBaseUrl, auth: auth),
  ),
  transfersProvider.overrideWith(
    (ref) => FakeTransfers(
      ref.watch(s3AccessProvider),
      cloud.storage,
      onUploaded: () => ref.invalidate(objectsProvider),
    ),
  ),
  robotDioProvider.overrideWithValue(
    (auth) => fakeDio(cloud.adapter, baseUrl: robotBaseUrl, auth: auth),
  ),
  s3DioProvider.overrideWithValue(
    (c) => createS3Dio(
      endpoint: c.endpoint,
      region: c.region,
      accessKey: c.accessKey,
      secretKey: c.secretKey,
      userAgent: 'Falco/test',
    )..httpClientAdapter = cloud.adapter,
  ),
];

/// Pumps the whole app against [cloud], unlocked, with [accounts] stored.
/// Authentication succeeds, or answers from [answers] in order.
Future<ProviderContainer> pumpFalco(
  WidgetTester tester,
  FakeCloud cloud, {
  List<Account> accounts = const [acme],
  FalcoVariant variant = FalcoVariant.dark,
  Map<String, Object> prefs = const {},
  List<bool?>? answers,
  bool s3 = false,
}) async {
  seedSecrets(accounts, s3: s3);
  final container = ProviderContainer(
    overrides: [
      preferencesProvider.overrideWithValue(
        await testPrefs({
          'variant': variant.name,
          // Integration tests run on devices in any language; the tests
          // read English labels.
          if (tester.binding is LiveTestWidgetsFlutterBinding) 'language': 'en',
          ...prefs,
        }),
      ),
      authenticatorProvider.overrideWithValue(
        (_) async => answers == null ? true : answers.removeAt(0),
      ),
      ...fakeApis(cloud),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const FalcoApp()),
  );
  await tester.pumpAndSettle();
  return container;
}

/// A container like the app's, against [cloud], for provider tests.
Future<ProviderContainer> fakeContainer(
  FakeCloud cloud, {
  List<Account> accounts = const [acme],
  bool s3 = false,
}) async {
  seedSecrets(accounts, s3: s3);
  final container = ProviderContainer(
    overrides: [
      preferencesProvider.overrideWithValue(await testPrefs()),
      ...fakeApis(cloud),
    ],
  );
  addTearDown(container.dispose);
  return container;
}
