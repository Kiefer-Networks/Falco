// SPDX-License-Identifier: GPL-3.0-or-later
// The Robot client against the documented responses, one test per
// endpoint: path, method, form body and parsing.
import 'package:dio/dio.dart';
import 'package:falco/api/robot/robot_client.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_http.dart';

void main() {
  late FakeAdapter adapter;
  late (int, Object?) answer;

  RobotClient client() => RobotClient(
    fakeDio(adapter, baseUrl: robotBaseUrl, auth: basicAuth('u', 'p')),
  );

  /// Answers every request with fixture [name] and [status].
  RobotClient serve(String? name, [int status = 200]) {
    answer = (status, name == null ? null : fixture('robot/$name.json'));
    adapter = FakeAdapter((_) => answer);
    return client();
  }

  RequestOptions last() => adapter.requests.last;
  String sent() => '${last().method} ${Uri.decodeFull(last().uri.path)}';
  List<(String, String)> form() => [
    for (final pair in (last().data as String? ?? '').split('&'))
      if (pair.isNotEmpty)
        (
          Uri.decodeQueryComponent(pair.split('=').first),
          Uri.decodeQueryComponent(pair.split('=').last),
        ),
  ];

  group('servers', () {
    test('ROB-004 GET /server', () async {
      final servers = await serve('server_list').servers();
      expect(sent(), 'GET /server');
      expect(servers.map((s) => s.number), [321, 421]);
      final s = servers.first;
      expect(s.ipv4, '123.123.123.123');
      expect(s.ipv6Net, '2a01:f48:111:4221::');
      expect(s.product, 'DS 3000');
      expect(s.dc, 'NBG1-DC1');
      expect(s.paidUntil, '2010-09-02');
      expect(s.ips, ['123.123.123.123']);
      expect(s.subnets, ['2a01:4f8:111:4221::/64']);
      expect(servers.last.subnets, isEmpty);
    });

    test('ROB-004 no servers is an empty list, not an error', () async {
      expect(await serve('error_not_found', 404).servers(), isEmpty);
    });

    test('ROB-006 ROB-007 GET /server/{n}', () async {
      final s = await serve('server').server(321);
      expect(sent(), 'GET /server/321');
      expect(s.label, 'server1');
      expect(s.traffic, '5 TB');
      expect([s.reset, s.rescue, s.vnc, s.windows, s.wol], everyElement(true));
    });

    test('ROB-042 POST /server/{n} renames', () async {
      await serve('server').renameServer(321, 'web 1');
      expect(sent(), 'POST /server/321');
      expect(last().contentType, Headers.formUrlEncodedContentType);
      expect(last().data, 'server_name=web+1');
    });

    test('ROB-014 GET /server/{n}/cancellation', () async {
      final c = await serve('cancellation').cancellation(321);
      expect(sent(), 'GET /server/321/cancellation');
      expect(c.earliest, '2014-04-15');
      expect(c.cancelled, isFalse);
      expect(c.reasons, hasLength(9));
      final active = await serve('cancellation_active').cancellation(321);
      expect(active.cancelled, isTrue);
      expect(active.date, '2014-04-15');
      expect(active.reasons, isEmpty);
    });

    test('ROB-014 POST /server/{n}/cancellation with reason and '
        'reservation', () async {
      await serve('cancellation_active').cancelServer(
        321,
        date: '2014-04-15',
        reason: 'Server too expensive',
        reserve: true,
      );
      expect(sent(), 'POST /server/321/cancellation');
      expect(form(), [
        ('cancellation_date', '2014-04-15'),
        ('cancellation_reason', 'Server too expensive'),
        ('reserve_location', 'true'),
      ]);
      await serve('cancellation_active').cancelServer(321, date: 'now');
      expect(form(), [('cancellation_date', 'now')]);
    });

    test('ROB-015 DELETE /server/{n}/cancellation', () async {
      await serve(null).withdrawCancellation(321);
      expect(sent(), 'DELETE /server/321/cancellation');
    });
  });

  group('reset and Wake on LAN', () {
    test('ROB-036 GET /reset', () async {
      expect(await serve('reset_list').resets(), {
        321: ['sw', 'hw', 'man'],
        111: ['power', 'power_long', 'hw', 'man'],
      });
      expect(sent(), 'GET /reset');
    });

    test('ROB-035 BUG-012 GET /reset/{n} offers only listed types', () async {
      expect(await serve('reset_options').resetTypes(321), ['sw', 'hw', 'man']);
      expect(sent(), 'GET /reset/321');
    });

    test('ROB-009 POST /reset/{n}', () async {
      await serve('reset').reset(321, 'hw');
      expect(sent(), 'POST /reset/321');
      expect(form(), [('type', 'hw')]);
    });

    test('ROB-043 GET /wol/{n}', () async {
      expect(await serve('wol').wolAvailable(321), isTrue);
      expect(sent(), 'GET /wol/321');
      expect(await serve('error_not_found', 404).wolAvailable(321), isFalse);
    });

    test('ROB-010 POST /wol/{n}', () async {
      await serve('wol').wakeOnLan(321);
      expect(sent(), 'POST /wol/321');
    });
  });

  group('boot', () {
    test('ROB-037 GET /boot/{n}', () async {
      final boot = await serve('boot').boot(321);
      expect(sent(), 'GET /boot/321');
      expect(boot.keys, BootKind.all);
      expect(boot['rescue']!.os, ['linux', 'vkvm']);
      expect(boot['rescue']!.arch, ['64', '32']);
      expect(boot['linux']!.dist, hasLength(2));
      expect(boot['windows']!.os, hasLength(3));
      expect(boot.values.any((b) => b.active), isFalse);
    });

    test('ROB-011 GET /boot/{n}/rescue', () async {
      final r = await serve('rescue').bootOption(321, 'rescue');
      expect(sent(), 'GET /boot/321/rescue');
      expect(r.active, isFalse);
      expect(r.password, isNull);
    });

    test('ROB-011 POST /boot/{n}/rescue with keys from Robot', () async {
      final r = await serve('rescue_active').activateBoot(
        321,
        'rescue',
        os: 'linux',
        arch: '64',
        keys: ['aa:bb', 'cc:dd'],
      );
      expect(sent(), 'POST /boot/321/rescue');
      expect(form(), [
        ('os', 'linux'),
        ('arch', '64'),
        ('authorized_key[]', 'aa:bb'),
        ('authorized_key[]', 'cc:dd'),
      ]);
      expect(r.active, isTrue);
      expect(r.password, 'jEt0dtUvomlyOwRr');
      expect(r.os, ['linux']);
    });

    test('ROB-012 DELETE /boot/{n}/rescue', () async {
      await serve('rescue').deactivateBoot(321, 'rescue');
      expect(sent(), 'DELETE /boot/321/rescue');
    });

    test('ROB-038 GET /boot/{n}/rescue/last', () async {
      final r = await serve('rescue_last').lastBoot(321, 'rescue');
      expect(sent(), 'GET /boot/321/rescue/last');
      expect(r.os, ['linux']);
    });

    test('ROB-039 Linux: options, activate, last, cancel', () async {
      expect((await serve('linux').bootOption(321, 'linux')).lang, ['en']);
      expect(sent(), 'GET /boot/321/linux');
      final active = await serve('linux_active')
          .activateBoot(321, 'linux', dist: 'CentOS 5.5 minimal', lang: 'en');
      expect(sent(), 'POST /boot/321/linux');
      expect(form(), [('dist', 'CentOS 5.5 minimal'), ('lang', 'en')]);
      expect(active.password, 'jEt0dtUvomlyOwRr');
      expect((await serve('linux_active').lastBoot(321, 'linux')).active, true);
      expect(sent(), 'GET /boot/321/linux/last');
      await serve('linux').deactivateBoot(321, 'linux');
      expect(sent(), 'DELETE /boot/321/linux');
    });

    test('ROB-040 VNC: options, activate, cancel', () async {
      expect((await serve('vnc').bootOption(321, 'vnc')).dist, hasLength(3));
      await serve('vnc')
          .activateBoot(321, 'vnc', dist: 'Fedora-6', lang: 'en_US');
      expect(sent(), 'POST /boot/321/vnc');
      await serve('vnc').deactivateBoot(321, 'vnc');
      expect(sent(), 'DELETE /boot/321/vnc');
    });

    test('ROB-041 Windows: options, activate, cancel', () async {
      final w = await serve('windows').bootOption(321, 'windows');
      expect(w.lang, ['en', 'de']);
      await serve('windows')
          .activateBoot(321, 'windows', os: w.os.first, lang: 'en');
      expect(form(), [('os', w.os.first), ('lang', 'en')]);
      await serve('windows').deactivateBoot(321, 'windows');
      expect(sent(), 'DELETE /boot/321/windows');
    });
  });

  group('reverse DNS', () {
    test('ROB-020 GET /rdns', () async {
      final all = await serve('rdns_list').rdns();
      expect(all.map((r) => r.ptr), ['testen.de', 'your-server.de']);
    });

    test('ROB-045 GET /rdns/{ip}, null without entry', () async {
      expect((await serve('rdns').rdnsOf('123.123.123.123'))!.ptr, 'testen.de');
      expect(sent(), 'GET /rdns/123.123.123.123');
      expect(await serve('error_not_found', 404).rdnsOf('1.2.3.4'), isNull);
    });

    test('ROB-046 PUT creates, POST changes', () async {
      await serve('rdns').setRdns('123.123.123.123', 'a.de', create: true);
      expect(sent(), 'PUT /rdns/123.123.123.123');
      expect(form(), [('ptr', 'a.de')]);
      await serve('rdns').setRdns('123.123.123.123', 'b.de', create: false);
      expect(sent(), 'POST /rdns/123.123.123.123');
    });

    test('ROB-023 DELETE /rdns/{ip}', () async {
      await serve(null).deleteRdns('2a01:4f8::1');
      expect(sent(), 'DELETE /rdns/2a01:4f8::1');
    });
  });

  group('failover', () {
    test('ROB-017 GET /failover', () async {
      final all = await serve('failover_list').failovers();
      expect(all.first.activeServerIp, '78.46.1.93');
      expect(all.last.netmask, 'ffff:ffff:ffff:ffff::');
    });

    test('ROB-044 GET /failover/{ip}', () async {
      final f = await serve('failover').failover('123.123.123.123');
      expect(sent(), 'GET /failover/123.123.123.123');
      expect(f.serverNumber, 321);
    });

    test('ROB-018 ROB-019 route and unroute', () async {
      await serve('failover').routeFailover('123.123.123.123', '124.1.1.1');
      expect(sent(), 'POST /failover/123.123.123.123');
      expect(form(), [('active_server_ip', '124.1.1.1')]);
      await serve('failover').unrouteFailover('123.123.123.123');
      expect(sent(), 'DELETE /failover/123.123.123.123');
    });
  });

  group('vSwitch', () {
    test('ROB-024 GET /vswitch', () async {
      final all = await serve('vswitch_list').vswitches();
      expect(all.map((v) => v.vlan), [4000, 4001]);
    });

    test('ROB-026 ROB-027 GET /vswitch/{id}', () async {
      final v = await serve('vswitch').vswitch(4321);
      expect(sent(), 'GET /vswitch/4321');
      expect(v.servers.map((s) => s.number), [321, 421]);
      expect(v.servers.first.status, 'ready');
      expect(v.subnets, ['213.239.252.48/29']);
      expect(v.cloudNetworks, ['10.0.2.0/24']);
    });

    test('ROB-025 ROB-030 create and edit', () async {
      final v = await serve('vswitch_created')
          .createVSwitch('my vSwitch', 4000);
      expect(sent(), 'POST /vswitch');
      expect(form(), [('name', 'my vSwitch'), ('vlan', '4000')]);
      expect(v.id, 4321);
      await serve(null).updateVSwitch(4321, 'new', 4001);
      expect(sent(), 'POST /vswitch/4321');
      expect(form(), [('name', 'new'), ('vlan', '4001')]);
    });

    test('ROB-028 ROB-029 add and remove servers', () async {
      await serve(null).addVSwitchServers(4321, [321, 421]);
      expect(sent(), 'POST /vswitch/4321/server');
      expect(form(), [('server[]', '321'), ('server[]', '421')]);
      await serve(null).removeVSwitchServers(4321, [321]);
      expect(sent(), 'DELETE /vswitch/4321/server');
      expect(form(), [('server[]', '321')]);
    });

    test('ROB-031 DELETE /vswitch/{id} cancels', () async {
      await serve(null).cancelVSwitch(4321, '2018-06-30');
      expect(sent(), 'DELETE /vswitch/4321');
      expect(form(), [('cancellation_date', '2018-06-30')]);
    });
  });

  group('SSH keys', () {
    test('ROB-032 GET /key', () async {
      final keys = await serve('key_list').keys();
      expect(keys.map((k) => k.type), ['ECDSA', 'ED25519']);
      expect(keys.first.size, 521);
    });

    test('ROB-047 GET /key/{fp}', () async {
      final k = await serve('key')
          .key('15:28:b0:03:95:f0:77:b3:10:56:15:6b:77:22:a5:bb');
      expect(
        sent(),
        'GET /key/15:28:b0:03:95:f0:77:b3:10:56:15:6b:77:22:a5:bb',
      );
      expect(k.name, 'key2');
    });

    test('ROB-033 ROB-048 ROB-034 add, rename, delete', () async {
      await serve('key').addKey('NewKey', 'ssh-ed25519 AAAA x');
      expect(sent(), 'POST /key');
      expect(form(), [('name', 'NewKey'), ('data', 'ssh-ed25519 AAAA x')]);
      await serve('key').renameKey('15:28', 'MyTestKey');
      expect(sent(), 'POST /key/15:28');
      expect(form(), [('name', 'MyTestKey')]);
      await serve(null).deleteKey('15:28');
      expect(sent(), 'DELETE /key/15:28');
    });
  });

  group('IPs and subnets', () {
    test('ROB-049 GET /ip and GET /ip/{ip}', () async {
      final all = await serve('ip_list').addresses(AddressKind.ip);
      expect(sent(), 'GET /ip');
      expect(all.last.daily, 2000);
      final ip = await serve('ip').address(AddressKind.ip, '123.123.123.123');
      expect(sent(), 'GET /ip/123.123.123.123');
      expect(ip.gateway, '123.123.123.97');
      expect(ip.broadcast, '123.123.123.127');
    });

    test('ROB-053 GET /subnet', () async {
      final all = await serve('subnet_list').addresses(AddressKind.subnet);
      expect(sent(), 'GET /subnet');
      expect(all.first.mask, 29);
      expect(all.last.serverIp, isNull);
    });

    test('ROB-050 ROB-054 traffic warnings', () async {
      await serve('ip').setTrafficWarnings(
        AddressKind.subnet,
        '123.123.123.123',
        enabled: true,
        hourly: 50,
        daily: 500,
        monthly: 8,
      );
      expect(sent(), 'POST /subnet/123.123.123.123');
      expect(form(), [
        ('traffic_warnings', 'true'),
        ('traffic_hourly', '50'),
        ('traffic_daily', '500'),
        ('traffic_monthly', '8'),
      ]);
    });

    test('ROB-051 ROB-055 separate MAC', () async {
      expect(
        await serve('ip_mac').mac(AddressKind.ip, '123.123.123.123'),
        '00:21:85:62:3e:9c',
      );
      expect(sent(), 'GET /ip/123.123.123.123/mac');
      expect(
        await serve('error_mac_not_found', 404).mac(AddressKind.ip, '1.1.1.1'),
        isNull,
      );
      await serve('ip_mac').setMac(AddressKind.subnet, '1.1.1.0', on: true);
      expect(sent(), 'PUT /subnet/1.1.1.0/mac');
      await serve('ip_mac').setMac(AddressKind.ip, '1.1.1.1', on: false);
      expect(sent(), 'DELETE /ip/1.1.1.1/mac');
    });

    test('ROB-052 ROB-056 cancellation', () async {
      final c = await serve('ip_cancellation')
          .addressCancellation(AddressKind.ip, '123.123.123.123');
      expect(sent(), 'GET /ip/123.123.123.123/cancellation');
      expect(c.earliest, '2022-02-11');
      expect(c.cancelled, isFalse);
      await serve('subnet_cancellation')
          .cancelAddress(AddressKind.subnet, '123.123.123.123', '2022-02-11');
      expect(sent(), 'POST /subnet/123.123.123.123/cancellation');
      expect(form(), [('cancellation_date', '2022-02-11')]);
      await serve('subnet_cancellation')
          .withdrawAddressCancellation(AddressKind.subnet, '123.123.123.123');
      expect(sent(), 'DELETE /subnet/123.123.123.123/cancellation');
    });
  });

  test('ROB-008 ROB-059 BUG-014 POST /traffic', () async {
    final t = await serve('traffic').traffic(
      type: TrafficType.month,
      from: '2010-09-01',
      to: '2010-09-31',
      ips: ['123.123.123.123', '124.124.124.124'],
      subnets: ['2a01:4f8:61:41a2::'],
    );
    expect(sent(), 'POST /traffic');
    expect(form(), [
      ('type', 'month'),
      ('from', '2010-09-01'),
      ('to', '2010-09-31'),
      ('ip[]', '123.123.123.123'),
      ('ip[]', '124.124.124.124'),
      ('subnet[]', '2a01:4f8:61:41a2::'),
    ]);
    expect(t['123.123.123.123']!.sumGb, 0.3355);
    expect(t['124.124.124.124']!.inGb, 0.2874);
  });

  group('firewall', () {
    test('ROB-057 GET /firewall/{n}', () async {
      final f = await serve('firewall').firewall(321);
      expect(sent(), 'GET /firewall/321');
      expect(f.status, 'active');
      expect(f.whitelistHos, isTrue);
      expect(f.rules['input']!.single, {
        'ip_version': 'ipv4',
        'name': 'rule 1',
        'src_ip': '1.1.1.1',
        'dst_port': '80',
        'action': 'accept',
      });
      expect(f.rules['output']!.single['name'], 'Allow all');
    });

    test('ROB-057 POST /firewall/{n} encodes the rules', () async {
      await serve('firewall').setFirewall(
        321,
        active: true,
        filterIpv6: false,
        whitelistHos: true,
        rules: {
          'input': [
            {'name': 'rule 1', 'src_ip': '1.1.1.1', 'action': 'accept'},
          ],
          'output': [
            {'name': 'Allow all', 'action': 'accept'},
          ],
        },
      );
      expect(sent(), 'POST /firewall/321');
      expect(form(), [
        ('status', 'active'),
        ('filter_ipv6', 'false'),
        ('whitelist_hos', 'true'),
        ('rules[input][0][name]', 'rule 1'),
        ('rules[input][0][src_ip]', '1.1.1.1'),
        ('rules[input][0][action]', 'accept'),
        ('rules[output][0][name]', 'Allow all'),
        ('rules[output][0][action]', 'accept'),
      ]);
      await serve('firewall')
          .setFirewall(321, active: false, filterIpv6: true, templateId: 2);
      expect(form(), [
        ('status', 'disabled'),
        ('filter_ipv6', 'true'),
        ('template_id', '2'),
      ]);
      await serve('firewall').clearFirewall(321);
      expect(sent(), 'DELETE /firewall/321');
    });

    test('ROB-058 templates: list, get, create, change, delete', () async {
      final all = await serve('template_list').templates();
      expect(sent(), 'GET /firewall/template');
      expect(all.first.isDefault, isTrue);
      final t = await serve('template').template(123);
      expect(sent(), 'GET /firewall/template/123');
      expect(t.rules['input'], hasLength(2));
      await serve('template').saveTemplate(
        name: 'My new template',
        filterIpv6: false,
        whitelistHos: true,
        isDefault: false,
        rules: const {},
      );
      expect(sent(), 'POST /firewall/template');
      expect(form().first, ('name', 'My new template'));
      await serve('template').saveTemplate(
        id: 123,
        name: 'x',
        filterIpv6: false,
        whitelistHos: true,
        isDefault: false,
        rules: const {},
      );
      expect(sent(), 'POST /firewall/template/123');
      await serve(null).deleteTemplate(123);
      expect(sent(), 'DELETE /firewall/template/123');
    });
  });

  group('errors', () {
    test('a missing server is NotFound', () async {
      await expectLater(
        serve('error_not_found', 404).server(1),
        throwsA(predicate<Object>((e) => toFalcoError(e) is NotFound)),
      );
    });

    test('errors are FalcoErrors, never the request with its login', () {
      expect(serve('error_not_found', 404).server(1), throwsA(isA<NotFound>()));
    });

    test('ROB-003 403 RATE_LIMIT_EXCEEDED is throttling, not auth', () async {
      await expectLater(
        serve('error_rate_limit', 403).server(321),
        throwsA(predicate<Object>((e) => toFalcoError(e) is RateLimited)),
      );
    });

    test('ROB-003 403 with Retry-After is throttling', () {
      expect(fromResponse(403, null, '60'), isA<RateLimited>());
      expect(fromResponse(403, null), isA<Forbidden>());
    });

    test('INVALID_INPUT names the invalid fields', () async {
      await expectLater(
        serve('error_invalid', 400).createVSwitch('x', 1),
        throwsA(
          predicate<Object>(
            (e) => switch (toFalcoError(e)) {
              Invalid(:final fields) => fields.containsKey('vlan'),
              _ => false,
            },
          ),
        ),
      );
    });
  });
}
