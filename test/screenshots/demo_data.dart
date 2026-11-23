// SPDX-License-Identifier: GPL-3.0-or-later
// A realistic but made up project for the store screenshots: documentation
// IP ranges (203.0.113.0/24, 198.51.100.0/24, 2001:db8::/32) and
// example.com names only.
import 'dart:convert';

import '../fake_cloud.dart';
import '../fake_robot.dart';
import '../storage_steps.dart';

Map<String, Object?> _location(int id, String name, String city, String c) => {
  'id': id,
  'name': name,
  'description': '$city DC Park 1',
  'country': c,
  'city': city,
  'latitude': 50.0,
  'longitude': 12.0,
  'network_zone': 'eu-central',
};

final Map<String, Object?> _fsn1 = _location(1, 'fsn1', 'Falkenstein', 'DE');
final Map<String, Object?> _nbg1 = _location(2, 'nbg1', 'Nuremberg', 'DE');
final Map<String, Object?> _hel1 = _location(3, 'hel1', 'Helsinki', 'FI');

final Map<String, Object?> _cx22 = serverTypeJson();
final Map<String, Object?> _cx32 = serverTypeJson(
  id: 2,
  name: 'cx32',
  cores: 4,
  memory: 8,
  disk: 80,
  price: '7.4900000000',
);
final Map<String, Object?> _ccx23 = serverTypeJson(
  id: 3,
  name: 'ccx23',
  cores: 4,
  memory: 16,
  disk: 160,
  price: '28.5500000000',
);
final Map<String, Object?> _cax21 = serverTypeJson(
  id: 4,
  name: 'cax21',
  cores: 4,
  memory: 8,
  disk: 80,
  price: '6.4900000000',
);

const _web = 51;
const _net = 31;

/// Server [id] with [name], a firewall when [web], in network [_net].
Map<String, Object?> _server(
  int id,
  String name,
  Map<String, Object?> type,
  Map<String, Object?> location, {
  String status = 'running',
  bool web = false,
  List<int> volumes = const [],
  int? group,
  Map<String, String> labels = const {},
  bool backups = false,
}) {
  final s = serverJson(
    id: id,
    name: name,
    status: status,
    type: type,
    volumes: volumes,
    labels: labels,
    placementGroup: group == null
        ? null
        : placementGroupJson(id: group, name: 'web-spread', servers: [1, 2]),
  );
  final net = s['public_net']! as Map<String, Object?>;
  net['firewalls'] = [
    if (web) {'id': _web, 'status': 'applied'},
  ];
  net['floating_ips'] = [if (id == 1) 81];
  (net['ipv4']! as Map)['dns_ptr'] = '$name.example.com';
  return {
    ...s,
    'location': location,
    'primary_disk_size': type['disk'],
    'backup_window': backups ? '22-02' : null,
    'outgoing_traffic': 1374389534720 ~/ id,
    'ingoing_traffic': 274877906944 ~/ id,
    'private_net': [
      {
        'network': _net,
        'ip': '10.0.1.$id',
        'alias_ips': <String>[],
        'mac_address': '86:00:00:00:00:0$id',
      },
    ],
  };
}

/// Six servers in three locations with volumes, images, a placement group,
/// SSH keys, firewall `web`, network `private`, IPs, load balancer `lb-web`,
/// zone `example.com` with records and the Storage Boxes of [storageCloud].
FakeCloud demoCloud() {
  final cloud = FakeCloud(
    servers: [
      _server(
        1,
        'web-1',
        _cx32,
        _fsn1,
        web: true,
        group: 21,
        backups: true,
        labels: {'role': 'web', 'env': 'prod'},
      ),
      _server(
        2,
        'web-2',
        _cx32,
        _nbg1,
        web: true,
        group: 21,
        labels: {'role': 'web', 'env': 'prod'},
      ),
      _server(
        3,
        'api-1',
        _cax21,
        _fsn1,
        web: true,
        labels: {'role': 'api', 'env': 'prod'},
      ),
      _server(
        4,
        'db-1',
        _ccx23,
        _fsn1,
        volumes: [11],
        backups: true,
        labels: {'role': 'db', 'env': 'prod'},
      ),
      _server(5, 'worker-1', _cx22, _hel1, volumes: [12]),
      _server(6, 'backup-1', _cx22, _hel1, status: 'off', volumes: [13]),
    ],
    volumes: [
      {...volumeJson(id: 11, name: 'db-data', size: 200, server: 4)},
      {
        ...volumeJson(id: 12, name: 'queue-cache', server: 5),
        'location': _hel1,
      },
      {
        ...volumeJson(id: 13, name: 'backup-archive', size: 500, server: 6),
        'location': _hel1,
      },
    ],
    images: [
      imageJson(id: 7, name: 'debian-12', description: 'Debian 12'),
      imageJson(
        id: 101,
        type: 'snapshot',
        description: 'web-1 before release 4.2',
        size: 2.4,
        createdFrom: 'web-1',
      ),
      imageJson(
        id: 102,
        type: 'snapshot',
        description: 'db-1 golden image',
        size: 6.1,
        createdFrom: 'db-1',
      ),
      imageJson(
        id: 103,
        type: 'backup',
        description: 'web-1 nightly',
        size: 2.2,
        createdFrom: 'web-1',
      ),
      imageJson(
        id: 104,
        type: 'backup',
        description: 'db-1 nightly',
        size: 5.8,
        createdFrom: 'db-1',
      ),
    ],
    placementGroups: [
      placementGroupJson(id: 21, name: 'web-spread', servers: [1, 2]),
    ],
    sshKeys: [
      sshKeyJson(id: 1, name: 'alice@laptop'),
      sshKeyJson(id: 2, name: 'bob@workstation'),
      sshKeyJson(id: 3, name: 'ci-deploy'),
    ],
    networks: [
      networkJson(
        id: _net,
        name: 'private',
        servers: [1, 2, 3, 4, 5, 6],
        loadBalancers: [91],
      ),
    ],
    firewalls: [
      firewallJson(
        id: _web,
        name: 'web',
        servers: [1, 2, 3],
        rules: [
          ruleJson(ips: ['198.51.100.0/24'], description: 'SSH from office'),
          ruleJson(port: '80', description: 'HTTP'),
          ruleJson(port: '443', description: 'HTTPS'),
          ruleJson(protocol: 'icmp', port: null, description: 'Ping'),
          ruleJson(
            direction: 'out',
            protocol: 'udp',
            port: '53',
            description: 'DNS',
          ),
        ],
      ),
      firewallJson(
        id: 52,
        name: 'db',
        servers: [4],
        rules: [
          ruleJson(
            port: '5432',
            ips: ['10.0.1.0/24'],
            description: 'PostgreSQL',
          ),
        ],
      ),
    ],
    floatingIps: [floatingIpJson(id: 81, name: 'www', server: 1)],
    primaryIps: [
      for (final (id, name) in [
        (1, 'web-1'),
        (2, 'web-2'),
        (3, 'api-1'),
        (4, 'db-1'),
        (5, 'worker-1'),
        (6, 'backup-1'),
      ])
        primaryIpJson(
          id: 1000 + id,
          name: '$name-v4',
          ip: '203.0.113.$id',
          server: id,
        ),
    ],
    loadBalancers: [
      loadBalancerJson(
        id: 91,
        name: 'lb-web',
        networks: [_net],
        services: [
          lbServiceJson(),
          lbServiceJson(protocol: 'https', listen: 443, certificates: [61]),
        ],
        targets: [serverTargetJson(1), serverTargetJson(2)],
      ),
    ],
    certificates: [
      certificateJson(
        id: 61,
        name: 'example.com',
        domains: ['example.com', 'www.example.com'],
        managed: true,
        usedBy: [91],
      ),
    ],
    zones: [
      zoneJson(id: 5, name: 'example.com', records: 9),
      zoneJson(id: 6, name: 'example.org', records: 3),
    ],
    rrsets: {
      5: [
        rrsetJson(zone: 5, name: '@', type: 'A', values: ['203.0.113.91']),
        rrsetJson(zone: 5, name: '@', type: 'AAAA', values: ['2001:db8:91::1']),
        rrsetJson(
          zone: 5,
          name: 'www',
          type: 'CNAME',
          values: ['example.com.'],
          ttl: 600,
        ),
        rrsetJson(zone: 5, name: 'api', type: 'A', values: ['203.0.113.3']),
        rrsetJson(
          zone: 5,
          name: '@',
          type: 'MX',
          values: ['10 mail.example.com.'],
        ),
        rrsetJson(
          zone: 5,
          name: '@',
          type: 'TXT',
          values: ['"v=spf1 mx -all"'],
        ),
        rrsetJson(zone: 5, name: 'mail', type: 'A', values: ['203.0.113.25']),
        rrsetJson(
          zone: 5,
          name: '@',
          type: 'CAA',
          values: ['0 issue "letsencrypt.org"'],
        ),
        rrsetJson(
          zone: 5,
          name: '@',
          type: 'NS',
          values: [
            'hydrogen.ns.hetzner.com.',
            'oxygen.ns.hetzner.com.',
            'helium.ns.hetzner.de.',
          ],
          ttl: 86400,
        ),
      ],
    },
    storage: storageCloud().storage,
  );
  cloud.collections['locations']!.addAll([_nbg1, _hel1]);
  cloud.collections['server_types']!.addAll([_ccx23, _cax21]);
  _documentationRobot(cloud.robot);
  return cloud;
}

/// Moves the Robot data to documentation ranges and names its servers.
void _documentationRobot(FakeRobot robot) {
  Object? doc(Object v) => jsonDecode(
    jsonEncode(v)
        .replaceAll('123.123.123.', '198.51.100.')
        .replaceAll('2a01:4f8:111:', '2001:db8:111:'),
  );
  void swap(List<Map<String, Object?>> l) {
    final d = (doc(l)! as List).cast<Map<String, Object?>>();
    l
      ..clear()
      ..addAll(d);
  }

  void swapMap<V>(Map<String, V> m) {
    final d = (doc(m)! as Map).cast<String, V>();
    m
      ..clear()
      ..addAll(d);
  }

  swap(robot.servers);
  swap(robot.ips);
  swap(robot.subnets);
  swap(robot.failovers);
  swapMap(robot.rdns);
  swapMap(robot.macs);
  robot.rdns['198.51.100.123'] = 'storage.example.com';
  robot.servers.first['server_name'] = 'storage-1';
  robot.servers.last['server_name'] = 'build-old';
}
