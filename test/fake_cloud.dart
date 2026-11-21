// SPDX-License-Identifier: GPL-3.0-or-later
// A fake Hetzner Cloud API and app harness shared by widget, golden and
// integration tests. Data is made up; no file IO, so it also runs on a
// device.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/app/theme_settings.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/main.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_http.dart';

/// A made up token, never valid anywhere.
const fakeToken = 'fake-token-for-tests';

/// One account "Acme" with project "prod" (ids a1, p1).
const acme = Account(
  id: 'a1',
  name: 'Acme',
  projects: [Project(id: 'p1', name: 'prod')],
);

/// A complete `server` object of the Cloud API.
Map<String, Object?> serverJson({
  required int id,
  required String name,
  String status = 'running',
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
  'server_type': {
    'id': 1,
    'name': 'cx22',
    'description': 'CX22',
    'cores': 2,
    'memory': 4,
    'disk': 40,
    'prices': <Object?>[],
    'storage_type': 'local',
    'cpu_type': 'shared',
    'category': 'cost_optimized',
    'architecture': 'x86',
    'deprecation': null,
    'locations': <Object?>[],
  },
  'location': {
    'id': 1,
    'name': 'fsn1',
    'description': 'Falkenstein DC Park 1',
    'country': 'DE',
    'city': 'Falkenstein',
    'latitude': 50.47612,
    'longitude': 12.370071,
    'network_zone': 'eu-central',
  },
  'image': {
    'id': 7,
    'type': 'system',
    'status': 'available',
    'name': 'debian-12',
    'description': 'Debian 12',
    'image_size': null,
    'disk_size': 5,
    'created': '2023-06-13T06:00:02Z',
    'created_from': null,
    'bound_to': null,
    'os_flavor': 'debian',
    'os_version': '12',
    'rapid_deploy': true,
    'protection': {'delete': false},
    'deprecation': null,
    'deleted': null,
    'labels': <String, Object?>{},
    'architecture': 'x86',
  },
  'iso': null,
  'rescue_enabled': false,
  'locked': false,
  'backup_window': null,
  'outgoing_traffic': 0,
  'ingoing_traffic': 0,
  'included_traffic': 21990232555520,
  'protection': {'delete': false, 'rebuild': false},
  'labels': <String, Object?>{},
  'volumes': <Object?>[],
  'load_balancers': <Object?>[],
  'primary_disk_size': 40,
  'placement_group': null,
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

/// In memory Cloud API: servers, their actions, metrics.
///
/// A power action starts `running` and ends `success` on its second poll,
/// then the server takes its new status.
class FakeCloud {
  new({
    List<Map<String, Object?>>? servers,
    List<Map<String, Object?>>? actions,
  }) : servers =
           servers ??
           [
             serverJson(id: 1, name: 'web-1'),
             serverJson(id: 2, name: 'db-1', status: 'off'),
           ],
       actions = actions ?? [];

  final List<Map<String, Object?>> servers;
  final List<Map<String, Object?>> actions;

  /// When set, every request answers with this (status, body).
  (int, Object?)? failWith;

  /// Tokens the API accepts.
  final Set<String> validTokens = {fakeToken};

  late final FakeAdapter adapter = FakeAdapter(_handle);
  final _polls = <int, int>{};

  /// Paths of all requests as `METHOD /path`.
  List<String> get calls => [
    for (final r in adapter.requests)
      '${r.method} ${r.uri.path.replaceFirst('/v1', '')}',
  ];

  /// An action of the API.
  static Map<String, Object?> action(
    int id,
    String command,
    int serverId, {
    String status = 'success',
    DateTime? started,
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
      {'id': serverId, 'type': 'server'},
    ],
    'error': status == 'error'
        ? {'code': 'action_failed', 'message': 'Action failed'}
        : null,
  };

  (int, Object?) _handle(RequestOptions o) {
    if (failWith case final f?) return f;
    final auth = '${o.headers['authorization']}';
    if (!validTokens.any((t) => auth == 'Bearer $t')) {
      return (401, errorJson('unauthorized'));
    }
    final path = o.uri.path.replaceFirst('/v1', '');
    final segments = path.split('/').skip(1).toList();
    Map<String, Object?>? server(String id) =>
        servers.where((s) => '${s['id']}' == id).firstOrNull;

    switch ((o.method, segments)) {
      case ('GET', ['servers']):
        return (200, {'servers': servers, 'meta': _meta(servers.length)});
      case ('GET', ['servers', 'actions']):
        return (200, {'actions': actions, 'meta': _meta(actions.length)});
      case ('GET', ['servers', final id]):
        final s = server(id);
        return s == null ? (404, errorJson('not_found')) : (200, {'server': s});
      case ('GET', ['servers', _, 'metrics']):
        final now = DateTime.now().toUtc();
        return (
          200,
          {
            'metrics': {
              'start': now.toIso8601String(),
              'end': now.toIso8601String(),
              'step': 60,
              'time_series': <String, Object?>{},
            },
          },
        );
      case ('GET', ['servers', final id, 'actions']):
        final mine = [
          for (final a in actions)
            if ((a['resources']! as List).any(
              (r) => '${(r as Map)['id']}' == id,
            ))
              a,
        ];
        return (200, {'actions': mine, 'meta': _meta(mine.length)});
      case ('POST', ['servers', final id, 'actions', final command]):
        final a = action(
          900 + actions.length,
          '${command}_server',
          int.parse(id),
          status: 'running',
          started: DateTime.now(),
        );
        actions.insert(0, a);
        return (201, {'action': a});
      case ('GET', ['actions', final id]):
        final a = actions.firstWhere((a) => '${a['id']}' == id);
        final polls = _polls[a['id']! as int] = (_polls[a['id']] ?? 0) + 1;
        if (polls >= 2 && a['status'] == 'running') _finish(a);
        return (200, {'action': a});
    }
    return (404, errorJson('not_found'));
  }

  void _finish(Map<String, Object?> a) {
    a
      ..['status'] = 'success'
      ..['progress'] = 100;
    final id = ((a['resources']! as List).first as Map)['id'];
    final s = servers.firstWhere((s) => s['id'] == id);
    s['status'] = switch (a['command']) {
      'poweroff_server' || 'shutdown_server' => 'off',
      _ => 'running',
    };
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

/// Pumps the whole app against [cloud], unlocked, with [accounts] stored.
Future<ProviderContainer> pumpFalco(
  WidgetTester tester,
  FakeCloud cloud, {
  List<Account> accounts = const [acme],
  FalcoVariant variant = FalcoVariant.dark,
}) async {
  seedSecrets(accounts);
  final container = ProviderContainer(
    overrides: [
      authenticatorProvider.overrideWithValue((_) async => true),
      cloudDioProvider.overrideWithValue(
        (auth) => fakeDio(cloud.adapter, auth: auth),
      ),
    ],
  );
  addTearDown(container.dispose);
  container
      .read(themeSettingsProvider.notifier)
      .set(variant, AccentPreset.amber);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const FalcoApp()),
  );
  await tester.pumpAndSettle();
  return container;
}
