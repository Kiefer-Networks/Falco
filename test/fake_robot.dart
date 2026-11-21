// SPDX-License-Identifier: GPL-3.0-or-later
// In memory Robot webservice for widget and integration tests. Answers in
// the documented format (see test/fixtures/robot); data is made up.
import 'package:dio/dio.dart';

typedef _Json = Map<String, Object?>;

_Json _error(int status, String code) => {
  'error': {'status': status, 'code': code, 'message': code.toLowerCase()},
};

/// Robot state: servers 321 (`server1`) and 421 (no name, cancelled),
/// one failover IP, vSwitch `backend`, an SSH key, reverse DNS, IPs, a
/// subnet, a server firewall and a template.
class FakeRobot {
  final servers = <_Json>[
    _server(321, 'server1', '123.123.123.123', 'AX41-NVMe', 'FSN1-DC14'),
    _server(421, '', '123.123.123.124', 'EX44', 'NBG1-DC3', cancelled: true),
  ];
  final resetTypes = <int, List<String>>{
    321: ['sw', 'hw', 'man'],
    421: ['hw', 'man'],
  };

  /// Boot configurations per server and kind.
  final boot = <int, Map<String, _Json>>{
    for (final n in const [321, 421])
      n: {
        'rescue': {
          'os': ['linux', 'vkvm'],
          'arch': [64, 32],
          'active': false,
          'password': null,
          'authorized_key': <Object?>[],
          'host_key': <Object?>[],
        },
        'linux': {
          'dist': ['Debian 12 base', 'Ubuntu 24.04 LTS base'],
          'arch': [64],
          'lang': ['en', 'de'],
          'active': false,
          'password': null,
          'authorized_key': <Object?>[],
          'host_key': <Object?>[],
        },
        'vnc': {
          'dist': ['Fedora 40'],
          'arch': [64],
          'lang': ['en_US'],
          'active': false,
          'password': null,
        },
        'windows': {
          'os': ['Windows Server 2022 Standard Edition'],
          'lang': ['en'],
          'active': false,
          'password': null,
        },
      },
  };

  /// The last activation per server and kind.
  final last = <(int, String), _Json>{};

  /// Server cancellations: date, reason, reserved.
  final cancellations = <int, _Json>{
    421: {'date': '2030-01-31', 'reserved': false},
  };
  final rdns = <String, String>{'123.123.123.123': 'server1.example.com'};
  final failovers = <_Json>[
    {
      'ip': '123.123.123.200',
      'netmask': '255.255.255.255',
      'server_ip': '123.123.123.123',
      'server_ipv6_net': '2a01:4f8:111:4221::',
      'server_number': 321,
      'active_server_ip': '123.123.123.123',
    },
  ];
  final vswitches = <_Json>[
    {
      'id': 1234,
      'name': 'backend',
      'vlan': 4000,
      'cancelled': false,
      'server': <int>[321],
    },
  ];
  final keys = <_Json>[
    {
      'name': 'laptop',
      'fingerprint': '15:28:b0:03:95:f0:77:b3:10:56:15:6b:77:22:a5:bb',
      'type': 'ED25519',
      'size': 256,
      'data': 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFake laptop',
      'created_at': '2025-12-31 23:59:59',
    },
  ];
  final ips = <_Json>[_ip('123.123.123.123', 321), _ip('123.123.123.124', 421)];
  final subnets = <_Json>[
    {
      'ip': '2a01:4f8:111:141::',
      'mask': 64,
      'gateway': 'fe80::1',
      'server_ip': '123.123.123.123',
      'server_number': 321,
      'failover': false,
      'locked': false,
      'traffic_warnings': false,
      'traffic_hourly': 100,
      'traffic_daily': 500,
      'traffic_monthly': 2,
    },
  ];

  /// Separate MACs; a missing key means none can be set.
  final macs = <String, String?>{'123.123.123.123': null};
  final addressCancellations = <String, String?>{};
  final firewalls = <int, _Json>{
    321: {
      'status': 'active',
      'filter_ipv6': false,
      'whitelist_hos': true,
      'port': 'main',
      'rules': {
        'input': [
          {'name': 'ssh', 'ip_version': 'ipv4', 'dst_port': '22'},
        ],
        'output': [
          {'name': 'Allow all', 'action': 'accept'},
        ],
      },
    },
  };
  final templates = <_Json>[
    {
      'id': 1,
      'name': 'web',
      'filter_ipv6': false,
      'whitelist_hos': true,
      'is_default': true,
      'rules': {'input': <Object?>[], 'output': <Object?>[]},
    },
  ];
  var _nextId = 5000;

  static _Json _server(
    int n,
    String name,
    String ip,
    String product,
    String dc, {
    bool cancelled = false,
  }) => {
    'server_ip': ip,
    'server_ipv6_net': '2a01:4f8:111:${n.toRadixString(16)}::',
    'server_number': n,
    'server_name': name,
    'product': product,
    'dc': dc,
    'traffic': '20 TB',
    'status': 'ready',
    'cancelled': cancelled,
    'paid_until': '2030-01-31',
    'ip': [ip],
    'subnet': [
      {'ip': '2a01:4f8:111:${n.toRadixString(16)}::', 'mask': '64'},
    ],
  };

  static _Json _ip(String ip, int server) => {
    'ip': ip,
    'gateway': '123.123.123.1',
    'mask': 26,
    'broadcast': '123.123.123.63',
    'server_ip': ip,
    'server_number': server,
    'locked': false,
    'separate_mac': null,
    'traffic_warnings': false,
    'traffic_hourly': 50,
    'traffic_daily': 500,
    'traffic_monthly': 8,
  };

  /// The form fields of a request in order.
  static List<(String, String)> form(RequestOptions o) => [
    if (o.data case final String d when d.isNotEmpty)
      for (final pair in d.split('&'))
        (
          Uri.decodeQueryComponent(pair.split('=').first),
          Uri.decodeQueryComponent(pair.split('=').skip(1).join('=')),
        ),
  ];

  _Json? _serverOf(String n) =>
      servers.where((s) => '${s['server_number']}' == n).firstOrNull;

  _Json _detail(_Json s) => {
    'server': {
      ...s,
      'reset': true,
      'rescue': true,
      'vnc': true,
      'windows': true,
      'wol': s['server_number'] == 321,
      'hot_swap': false,
    },
  };

  _Json _cancellation(int n) {
    final c = cancellations[n];
    return {
      'cancellation': {
        'server_number': n,
        'earliest_cancellation_date': '2030-01-31',
        'cancelled': c != null,
        'reservation_possible': n == 321,
        'reserved': c?['reserved'] ?? false,
        'cancellation_date': c?['date'],
        'cancellation_reason': c == null
            ? ['Server too expensive', 'Upgrade to a new server']
            : c['reason'],
      },
    };
  }

  _Json _vswitch(_Json v) => {
    ...v,
    'server': [
      for (final n in v['server']! as List<int>)
        {
          'server_ip': _serverOf('$n')?['server_ip'],
          'server_ipv6_net': _serverOf('$n')?['server_ipv6_net'],
          'server_number': n,
          'status': 'ready',
        },
    ],
    'subnet': <Object?>[],
    'cloud_network': <Object?>[],
  };

  static _Json _rules(List<(String, String)> form) {
    final rules = <String, Map<int, _Json>>{'input': {}, 'output': {}};
    final key = RegExp(r'^rules\[(\w+)\]\[(\d+)\]\[(\w+)\]$');
    for (final (k, v) in form) {
      if (key.firstMatch(k) case final m?) {
        rules[m[1]!]!.putIfAbsent(int.parse(m[2]!), () => {})[m[3]!] = v;
      }
    }
    return {
      for (final MapEntry(:key, :value) in rules.entries)
        key: [for (final i in value.keys.toList()..sort()) value[i]],
    };
  }

  /// Answers per first path segment, e.g. failover to a 403.
  final failures = <String, (int, Object?)>{};

  /// A 403 of a section the webservice user may not use.
  static (int, Object?) forbidden() => (403, _error(403, 'FORBIDDEN'));

  /// Robot's throttling answer.
  static (int, Object?) rateLimited() =>
      (403, _error(403, 'RATE_LIMIT_EXCEEDED'));

  /// Answers a request that passed authentication.
  (int, Object?) handle(RequestOptions o) {
    final segments = o.uri.pathSegments.map(Uri.decodeComponent).toList();
    if (failures[segments.first] case final f?) return f;
    final f = {for (final (k, v) in form(o)) k: v};
    final list = form(o);
    switch ((o.method, segments)) {
      case ('GET', ['server']):
        return (
          200,
          [
            for (final s in servers) {'server': s},
          ],
        );
      case ('GET', ['server', final n]):
        final s = _serverOf(n);
        return s == null
            ? (404, _error(404, 'SERVER_NOT_FOUND'))
            : (200, _detail(s));
      case ('POST', ['server', final n]):
        final s = _serverOf(n)!..['server_name'] = f['server_name'];
        return (200, _detail(s));
      case ('GET', ['server', final n, 'cancellation']):
        return (200, _cancellation(int.parse(n)));
      case ('POST', ['server', final n, 'cancellation']):
        final number = int.parse(n);
        cancellations[number] = {
          'date': f['cancellation_date'],
          'reason': f['cancellation_reason'],
          'reserved': f['reserve_location'] == 'true',
        };
        _serverOf(n)!['cancelled'] = true;
        return (200, _cancellation(number));
      case ('DELETE', ['server', final n, 'cancellation']):
        cancellations.remove(int.parse(n));
        _serverOf(n)!['cancelled'] = false;
        return (200, null);
      case ('GET', ['reset']):
        return (
          200,
          [
            for (final MapEntry(:key, :value) in resetTypes.entries)
              {
                'reset': {'server_number': key, 'type': value},
              },
          ],
        );
      case ('GET', ['reset', final n]):
        return (
          200,
          {
            'reset': {
              'server_number': int.parse(n),
              'type': resetTypes[int.parse(n)],
              'operating_status': 'not supported',
            },
          },
        );
      case ('POST', ['reset', final n]):
        return (
          200,
          {
            'reset': {'server_number': int.parse(n), 'type': f['type']},
          },
        );
      case ('GET' || 'POST', ['wol', final n]):
        return n == '321'
            ? (
                200,
                {
                  'wol': {'server_number': 321},
                },
              )
            : (404, _error(404, 'WOL_NOT_AVAILABLE'));
      case ('GET', ['boot', final n]):
        return (200, {'boot': boot[int.parse(n)]});
      case ('GET', ['boot', final n, final kind]):
        return (200, {kind: boot[int.parse(n)]![kind]});
      case ('GET', ['boot', final n, final kind, 'last']):
        final l = last[(int.parse(n), kind)];
        return l == null
            ? (404, _error(404, 'BOOT_NOT_AVAILABLE'))
            : (200, {kind: l});
      case ('POST', ['boot', final n, final kind]):
        final active = <String, Object?>{
          ...boot[int.parse(n)]![kind]!,
          'active': true,
          'password': 'Fake-Rescue-Pass-1',
          for (final k in const ['os', 'dist', 'lang', 'arch']) k: ?f[k],
          'authorized_key': [
            for (final (k, v) in list)
              if (k == 'authorized_key[]') v,
          ],
        };
        boot[int.parse(n)]![kind] = active;
        last[(int.parse(n), kind)] = active;
        return (200, {kind: active});
      case ('DELETE', ['boot', final n, final kind]):
        boot[int.parse(n)]![kind]!
          ..['active'] = false
          ..['password'] = null;
        return (200, {kind: boot[int.parse(n)]![kind]});
      case ('GET', ['rdns']):
        return rdns.isEmpty
            ? (404, _error(404, 'NOT_FOUND'))
            : (
                200,
                [
                  for (final MapEntry(:key, :value) in rdns.entries)
                    {
                      'rdns': {'ip': key, 'ptr': value},
                    },
                ],
              );
      case ('GET', ['rdns', final ip]):
        return rdns[ip] == null
            ? (404, _error(404, 'RDNS_NOT_FOUND'))
            : (
                200,
                {
                  'rdns': {'ip': ip, 'ptr': rdns[ip]},
                },
              );
      case ('PUT' || 'POST', ['rdns', final ip]):
        if (o.method == 'PUT' && rdns.containsKey(ip)) {
          return (409, _error(409, 'RDNS_ALREADY_EXISTS'));
        }
        rdns[ip] = f['ptr']!;
        return (
          201,
          {
            'rdns': {'ip': ip, 'ptr': rdns[ip]},
          },
        );
      case ('DELETE', ['rdns', final ip]):
        rdns.remove(ip);
        return (200, null);
      case ('GET', ['failover']):
        return (
          200,
          [
            for (final x in failovers) {'failover': x},
          ],
        );
      case ('GET' || 'POST' || 'DELETE', ['failover', final ip]):
        final x = failovers.firstWhere((x) => x['ip'] == ip);
        if (o.method == 'POST') {
          if (x['active_server_ip'] == f['active_server_ip']) {
            return (409, _error(409, 'FAILOVER_ALREADY_ROUTED'));
          }
          x['active_server_ip'] = f['active_server_ip'];
        }
        if (o.method == 'DELETE') x['active_server_ip'] = null;
        return (200, {'failover': x});
      case ('GET', ['vswitch']):
        return (
          200,
          [
            for (final v in vswitches)
              {
                for (final k in const ['id', 'name', 'vlan', 'cancelled'])
                  k: v[k],
              },
          ],
        );
      case ('POST', ['vswitch']):
        final v = <String, Object?>{
          'id': _nextId++,
          'name': f['name'],
          'vlan': int.parse(f['vlan']!),
          'cancelled': false,
          'server': <int>[],
        };
        vswitches.add(v);
        return (201, _vswitch(v));
      case (_, ['vswitch', final id, ...final rest]):
        final v = vswitches.firstWhere((v) => '${v['id']}' == id);
        final servers = v['server']! as List<int>;
        final picked = [
          for (final (k, x) in list)
            if (k == 'server[]') int.parse(x),
        ];
        switch ((o.method, rest)) {
          case ('POST', []):
            v
              ..['name'] = f['name']
              ..['vlan'] = int.parse(f['vlan']!);
          case ('DELETE', []):
            v['cancelled'] = true;
          case ('POST', ['server']):
            servers.addAll(picked);
          case ('DELETE', ['server']):
            servers.removeWhere(picked.contains);
        }
        return (200, o.method == 'GET' ? _vswitch(v) : null);
      case ('GET', ['key']):
        return (
          200,
          [
            for (final k in keys) {'key': k},
          ],
        );
      case ('POST', ['key']):
        final k = <String, Object?>{
          'name': f['name'],
          'fingerprint': 'aa:bb:cc:dd:ee:ff:00:11:22:33:44:55:66:77:88:99',
          'type': 'ED25519',
          'size': 256,
          'data': f['data'],
          'created_at': '2026-01-01 00:00:00',
        };
        keys.add(k);
        return (201, {'key': k});
      case (_, ['key', final fp]):
        final k = keys.firstWhere((k) => k['fingerprint'] == fp);
        if (o.method == 'POST') k['name'] = f['name'];
        if (o.method == 'DELETE') keys.remove(k);
        return (200, o.method == 'DELETE' ? null : {'key': k});
      case ('GET', [final kind && ('ip' || 'subnet')]):
        final all = kind == 'ip' ? ips : subnets;
        return (
          200,
          [
            for (final a in all) {kind: a},
          ],
        );
      case (_, [final kind && ('ip' || 'subnet'), final ip, ...final rest]):
        final a = (kind == 'ip' ? ips : subnets).firstWhere(
          (a) => a['ip'] == ip,
        );
        switch ((o.method, rest)) {
          case ('POST', []):
            a
              ..['traffic_warnings'] = f['traffic_warnings'] == 'true'
              ..['traffic_hourly'] = int.parse(f['traffic_hourly']!)
              ..['traffic_daily'] = int.parse(f['traffic_daily']!)
              ..['traffic_monthly'] = int.parse(f['traffic_monthly']!);
          case (final m, ['mac']):
            if (!macs.containsKey(ip)) {
              return (404, _error(404, 'MAC_NOT_AVAILABLE'));
            }
            if (m == 'PUT') macs[ip] = '00:50:56:00:fa:ce';
            if (m == 'DELETE') macs[ip] = null;
            if (m == 'GET' && macs[ip] == null) {
              return (404, _error(404, 'MAC_NOT_FOUND'));
            }
            a['separate_mac'] = macs[ip];
            return (
              200,
              {
                'mac': {'ip': ip, 'mac': macs[ip]},
              },
            );
          case (final m, ['cancellation']):
            if (m == 'POST') {
              addressCancellations[ip] = f['cancellation_date'];
            }
            if (m == 'DELETE') addressCancellations.remove(ip);
            final date = addressCancellations[ip];
            return (
              200,
              {
                'cancellation': {
                  'ip': ip,
                  'server_number': a['server_number'],
                  'earliest_cancellation_date': '2030-01-31',
                  'cancelled': date != null,
                  'cancellation-date': date,
                },
              },
            );
        }
        return (200, {kind: a});
      case ('POST', ['traffic']):
        final addresses = [
          for (final (k, v) in list)
            if (k == 'ip[]') v,
          for (final (k, v) in list)
            if (k == 'subnet[]') '$v/64',
        ];
        return (
          200,
          {
            'traffic': {
              'type': f['type'],
              'from': f['from'],
              'to': f['to'],
              'data': {
                for (final a in addresses)
                  a: {'in': 12.5, 'out': 3.25, 'sum': 15.75},
              },
            },
          },
        );
      case ('GET', ['firewall', 'template']):
        return (
          200,
          [
            for (final t in templates)
              {
                'firewall_template': {...t}..remove('rules'),
              },
          ],
        );
      case ('POST', ['firewall', 'template']):
        final t = <String, Object?>{
          'id': _nextId++,
          'name': f['name'],
          'filter_ipv6': f['filter_ipv6'] == 'true',
          'whitelist_hos': f['whitelist_hos'] == 'true',
          'is_default': f['is_default'] == 'true',
          'rules': _rules(list),
        };
        templates.add(t);
        return (201, {'firewall_template': t});
      case (_, ['firewall', 'template', final id]):
        final t = templates.firstWhere((t) => '${t['id']}' == id);
        if (o.method == 'POST') {
          t
            ..['name'] = f['name']
            ..['filter_ipv6'] = f['filter_ipv6'] == 'true'
            ..['whitelist_hos'] = f['whitelist_hos'] == 'true'
            ..['is_default'] = f['is_default'] == 'true'
            ..['rules'] = _rules(list);
        }
        if (o.method == 'DELETE') templates.remove(t);
        return (200, o.method == 'DELETE' ? null : {'firewall_template': t});
      case (_, ['firewall', final n]):
        final number = int.parse(n);
        final fw = firewalls.putIfAbsent(
          number,
          () => {
            'status': 'disabled',
            'filter_ipv6': false,
            'whitelist_hos': true,
            'port': 'main',
            'rules': <String, Object?>{},
          },
        );
        if (o.method == 'POST') {
          final template = templates
              .where((t) => '${t['id']}' == f['template_id'])
              .firstOrNull;
          fw
            ..['status'] = f['status']
            ..['filter_ipv6'] = f['filter_ipv6'] == 'true'
            ..['whitelist_hos'] =
                template?['whitelist_hos'] ?? f['whitelist_hos'] == 'true'
            ..['rules'] = template?['rules'] ?? _rules(list);
        }
        if (o.method == 'DELETE') fw['rules'] = <String, Object?>{};
        return (
          200,
          {
            'firewall': {'server_number': number, ...fw},
          },
        );
    }
    return (404, _error(404, 'NOT_FOUND'));
  }
}
