// SPDX-License-Identifier: GPL-3.0-or-later
// A fake Hetzner Cloud API and app harness shared by widget, golden and
// integration tests. Data is made up; no file IO, so it also runs on a
// device.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/api/robot/robot_client.dart';
import 'package:falco/api/s3/s3.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/features/accounts/checks.dart';
import 'package:falco/main.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_http.dart';

/// A made up token, never valid anywhere.
const fakeToken = 'fake-token-for-tests';

/// Made up Robot webservice login.
const fakeRobotUser = '#ws+fake';

/// Made up Robot webservice password.
const fakeRobotPassword = 'fake-robot-password';

/// Made up S3 access key; the secret key is not checked by the fake.
const fakeAccessKey = 'FAKEACCESSKEY';

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
};

/// In memory Cloud API: every Compute resource, their actions, metrics.
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
  }) : actions = actions ?? [],
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
         'networks': [],
         'firewalls': [],
       };

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
      '${r.method} ${r.uri.path.replaceFirst('/v1', '')}',
  ];

  /// JSON body of the last request to `METHOD /path`.
  Map<String, Object?> body(String call) {
    final r = adapter.requests.lastWhere(
      (r) => '${r.method} ${r.uri.path.replaceFirst('/v1', '')}' == call,
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
      final valid = 'Basic ${base64.encode(login)}';
      return auth0 == valid
          ? (
              200,
              [
                {
                  'server': {
                    'server_number': 321,
                    'server_name': 'metal-1',
                    'server_ip': '198.51.100.7',
                    'product': 'AX41-NVMe',
                    'dc': 'FSN1-DC14',
                    'status': 'ready',
                    'cancelled': false,
                  },
                },
              ],
            )
          : (
              401,
              {
                'error': {'status': 401, 'code': 'UNAUTHORIZED', 'message': ''},
              },
            );
    }
    if (o.uri.host.endsWith('.your-objectstorage.com')) {
      return auth0.contains('Credential=$fakeAccessKey/')
          ? (200, null)
          : (403, null);
    }
    if (!validTokens.any((t) => auth0 == 'Bearer $t')) {
      return (401, errorJson('unauthorized'));
    }
    final path = o.uri.path.replaceFirst('/v1', '');
    final segments = path.split('/').skip(1).toList();
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

    switch ((o.method, segments)) {
      case ('GET', ['pricing']):
        return (200, {'pricing': pricingJson});
      case ('GET', [final coll, 'actions']) when _singular.containsKey(coll):
        final mine = actionsOf(_singular[coll]!);
        return (200, {'actions': mine, 'meta': _meta(mine.length)});
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
        final mine = actionsOf(_singular[coll] ?? coll, id);
        return (200, {'actions': mine, 'meta': _meta(mine.length)});
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
        if (coll != 'servers') return (204, null);
        return (
          200,
          {'action': _start('delete_server', s['id']! as int, 'server')},
        );
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
            'next_actions': <Object?>[],
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
            'next_actions': <Object?>[],
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
void seedSecrets(List<Account> accounts) {
  FlutterSecureStorage.setMockInitialValues({
    if (accounts.isNotEmpty)
      'accounts': jsonEncode([for (final a in accounts) a.toJson()]),
    for (final a in accounts)
      for (final p in a.projects) 'cloud.${p.id}': fakeToken,
  });
}

/// Fresh preferences holding [values].
Future<SharedPreferences> testPrefs([
  Map<String, Object> values = const {},
]) async {
  SharedPreferences.setMockInitialValues(values);
  return await SharedPreferences.getInstance();
}

/// Overrides that route every API of the app to [cloud].
List<Override> fakeApis(FakeCloud cloud) => [
  cloudDioProvider.overrideWithValue(
    (auth) => fakeDio(cloud.adapter, auth: auth),
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
}) async {
  seedSecrets(accounts);
  final container = ProviderContainer(
    overrides: [
      preferencesProvider.overrideWithValue(
        await testPrefs({'variant': variant.name, ...prefs}),
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
}) async {
  seedSecrets(accounts);
  final container = ProviderContainer(
    overrides: [
      preferencesProvider.overrideWithValue(await testPrefs()),
      ...fakeApis(cloud),
    ],
  );
  addTearDown(container.dispose);
  return container;
}
