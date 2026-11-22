// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/features/network/firewall_pages.dart';
import 'package:falco/features/network/firewalls.dart';
import 'package:falco/features/network/ips.dart';
import 'package:falco/features/network/network_pages.dart';
import 'package:falco/features/network/networks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';
import '../network_steps.dart';
import '../steps.dart';

void main() {
  group('networks', () {
    FakeCloud withNetwork() => FakeCloud(
      servers: [
        {
          ...serverJson(id: 1, name: 'web-1'),
          'private_net': [
            {
              'network': 21,
              'ip': '10.0.1.2',
              'alias_ips': <String>[],
              'mac_address': '86:00:00:2a:7d:e0',
            },
          ],
        },
        serverJson(id: 2, name: 'db-1', status: 'off'),
      ],
      networks: [
        networkJson(
          id: 21,
          name: 'backend',
          routes: [
            {'destination': '10.100.1.0/24', 'gateway': '10.0.1.1'},
          ],
          servers: [1],
        ),
      ],
    );

    testWidgets('NET-039 list with range and subnets, empty state', (
      tester,
    ) async {
      await openNetwork(tester, 'Networks', cloud: withNetwork());
      expect(find.text('backend'), findsOneWidget);
      expect(find.text('10.0.0.0/16 · 1 subnet'), findsOneWidget);
    });

    testWidgets('empty state offers create', (tester) async {
      await openNetwork(tester, 'Networks');
      expect(find.text('No networks in this project yet.'), findsOneWidget);
      expect(find.text('Create network'), findsWidgets);
    });

    testWidgets('error state shows the cause with retry', (tester) async {
      final cloud = FakeCloud()..failWith = (500, errorJson('server_error'));
      setSurface(tester);
      await pumpFalco(tester, cloud);
      await tester.tap(find.text('Network'));
      await tester.pumpAndSettle();
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('NET-043 NET-044 NET-045 NET-048 NET-092 detail with '
        'subnets, routes and members', (tester) async {
      await openNetwork(tester, 'Networks', cloud: withNetwork());
      await tap(tester, 'backend');
      expect(find.text('10.0.1.0/24'), findsOneWidget);
      expect(find.text('cloud · eu-central · via 10.0.0.1'), findsOneWidget);
      expect(find.text('10.100.1.0/24'), findsOneWidget);
      expect(find.text('via 10.0.1.1'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('MEMBERS'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.textContaining('10.0.1.2'), findsOneWidget);
    });

    testWidgets('NET-046 NET-047 add a vSwitch subnet, delete one', (
      tester,
    ) async {
      final cloud = await openNetwork(tester, 'Networks', cloud: withNetwork());
      await tap(tester, 'backend');
      await tap(tester, 'Add subnet');
      await tap(tester, 'vswitch');
      await enter(tester, 'range', '10.1.0.0/24');
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'))
            .onPressed,
        isNull,
        reason: 'outside the network',
      );
      await enter(tester, 'range', '10.0.2.0/24');
      await enter(tester, 'vswitch', '4711');
      await tap(tester, 'Save');
      expect(cloud.body('POST /networks/21/actions/add_subnet'), {
        'type': 'vswitch',
        'network_zone': 'eu-central',
        'ip_range': '10.0.2.0/24',
        'vswitch_id': 4711,
      });
      await settleAction(tester);
      await tester.tap(find.byTooltip('Delete').first);
      await tester.pumpAndSettle();
      expect(find.text('Delete subnet 10.0.1.0/24?'), findsOneWidget);
      await confirm(tester, 'Delete');
      expect(cloud.body('POST /networks/21/actions/delete_subnet'), {
        'ip_range': '10.0.1.0/24',
      });
      await settleAction(tester);
    });

    testWidgets('NET-049 NET-050 add a route inside the network, delete one', (
      tester,
    ) async {
      final cloud = await openNetwork(tester, 'Networks', cloud: withNetwork());
      await tap(tester, 'backend');
      await tap(tester, 'Add route');
      await enter(tester, 'destination', '10.200.0.0/24');
      await enter(tester, 'gateway', '10.0.1.5');
      await tap(tester, 'Save');
      expect(cloud.body('POST /networks/21/actions/add_route'), {
        'destination': '10.200.0.0/24',
        'gateway': '10.0.1.5',
      });
      await settleAction(tester);
      await tester.tap(find.byTooltip('Delete').last);
      await tester.pumpAndSettle();
      expect(find.text('Delete route to 10.200.0.0/24?'), findsOneWidget);
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('POST /networks/21/actions/delete_route'));
      await settleAction(tester);
    });

    testWidgets('NET-051 NET-052 NET-053 NET-054 NET-090 range, vSwitch '
        'routes, edit, protection', (tester) async {
      final cloud = await openNetwork(tester, 'Networks', cloud: withNetwork());
      await tap(tester, 'backend');
      await more(tester, 'Change IP range');
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'))
            .onPressed,
        isNull,
        reason: 'unchanged',
      );
      await enter(tester, 'range', '10.0.0.0/15');
      await tap(tester, 'Save');
      expect(cloud.body('POST /networks/21/actions/change_ip_range'), {
        'ip_range': '10.0.0.0/15',
      });
      await settleAction(tester);
      await more(tester, 'Expose routes to vSwitch');
      await confirm(tester, 'Save');
      expect(cloud.body('PUT /networks/21'), {
        'expose_routes_to_vswitch': true,
      });
      await tap(tester, 'Edit');
      await enter(tester, 'name', 'backend-2');
      await enter(tester, 'labels', 'env=prod');
      await tap(tester, 'Save');
      expect(cloud.body('PUT /networks/21'), {
        'name': 'backend-2',
        'labels': {'env': 'prod'},
      });
      await tap(tester, 'Protection');
      await confirm(tester, 'Protect');
      expect(cloud.body('POST /networks/21/actions/change_protection'), {
        'delete': true,
      });
      await settleAction(tester);
    });

    testWidgets('NET-055 delete with the typed name', (tester) async {
      final cloud = await openNetwork(tester, 'Networks', cloud: withNetwork());
      await tap(tester, 'backend');
      await tap(tester, 'Delete');
      expect(find.textContaining('subnets and routes'), findsOneWidget);
      await typeName(tester, 'backend');
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /networks/21'));
      expect(find.text('backend'), findsNothing);
    });

    testWidgets('NET-040 NET-041 NET-042 create with a first subnet', (
      tester,
    ) async {
      final cloud = await openNetwork(tester, 'Networks');
      await tap(tester, 'Create network');
      await enter(tester, 'name', 'lan');
      await enter(tester, 'range', '8.8.0.0/16');
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next'))
            .onPressed,
        isNull,
        reason: 'not private',
      );
      await enter(tester, 'range', '10.0.0.0/16');
      await tap(tester, 'Next');
      await tap(tester, 'us-east');
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      expect(cloud.body('POST /networks'), {
        'name': 'lan',
        'ip_range': '10.0.0.0/16',
        'subnets': [
          {'type': 'cloud', 'network_zone': 'us-east'},
        ],
        'labels': <String, Object?>{},
      });
      expect(find.text('lan'), findsOneWidget);
    });

    test('NET-040 NET-041 NET-046 NET-049 NET-051 address rules', () {
      expect(validNetworkRange('10.0.0.0/16'), isTrue);
      expect(validNetworkRange('172.16.0.0/12'), isTrue);
      expect(validNetworkRange('8.8.0.0/16'), isFalse);
      expect(validNetworkRange('10.0.0.1/16'), isFalse, reason: 'host bits');
      expect(validSubnetRange('', '10.0.0.0/16'), isTrue);
      expect(validSubnetRange('10.0.5.0/24', '10.0.0.0/16'), isTrue);
      expect(validSubnetRange('10.1.0.0/24', '10.0.0.0/16'), isFalse);
      expect(validRoute('0.0.0.0/0', '10.0.0.5', '10.0.0.0/16'), isTrue);
      expect(validRoute('0.0.0.0/0', '10.1.0.5', '10.0.0.0/16'), isFalse);
      expect(validRangeChange('10.0.0.0/15', '10.0.0.0/16'), isTrue);
      expect(validRangeChange('10.0.0.0/16', '10.0.0.0/16'), isFalse);
      expect(validRangeChange('10.0.0.0/17', '10.0.0.0/16'), isFalse);
      expect(validSubnet({'type': 'vswitch'}, '10.0.0.0/16'), isFalse);
      expect(
        subnetOf({'type': 'vswitch', 'zone': 'eu-central', 'vswitch': '9'}),
        {'type': 'vswitch', 'network_zone': 'eu-central', 'vswitch_id': 9},
      );
    });
  });

  group('server network section', () {
    testWidgets('CMP-040 CMP-041 NET-086 attach, alias IPs and remove', (
      tester,
    ) async {
      final cloud = FakeCloud(networks: [networkJson(id: 21, name: 'lan')]);
      setSurface(tester);
      await pumpFalco(tester, cloud);
      await tap(tester, 'web-1');
      await more(tester, 'Attach to network');
      await tap(tester, 'lan');
      await enter(tester, 'ip', '10.0.1.9');
      await tap(tester, 'Save');
      expect(cloud.body('POST /servers/1/actions/attach_to_network'), {
        'network': 21,
        'ip': '10.0.1.9',
      });
      await settleAction(tester);
      expect(find.text('lan'), findsOneWidget);
      await tester.tap(find.byTooltip('Alias IPs'));
      await tester.pumpAndSettle();
      await enter(tester, 'alias', '10.0.1.10, 10.0.1.11');
      await tap(tester, 'Save');
      expect(cloud.body('POST /servers/1/actions/change_alias_ips'), {
        'network': 21,
        'alias_ips': ['10.0.1.10', '10.0.1.11'],
      });
      await settleAction(tester);
      await tester.tap(find.byTooltip('Remove'));
      await tester.pumpAndSettle();
      expect(find.text('Remove web-1 from lan?'), findsOneWidget);
      await confirm(tester, 'Remove');
      expect(cloud.body('POST /servers/1/actions/detach_from_network'), {
        'network': 21,
      });
      await settleAction(tester);
    });

    testWidgets('CMP-040 hint when there is no network', (tester) async {
      setSurface(tester);
      await pumpFalco(tester, FakeCloud());
      await tap(tester, 'web-1');
      await more(tester, 'Attach to network');
      expect(find.textContaining('No networks left'), findsOneWidget);
    });
  });

  group('firewalls', () {
    FakeCloud withFirewall() => FakeCloud(
      firewalls: [
        firewallJson(
          id: 51,
          name: 'web',
          servers: [1],
          rules: [
            ruleJson(description: 'ssh'),
            ruleJson(direction: 'out', protocol: 'icmp', port: null),
          ],
        ),
        firewallJson(id: 52, name: 'spare', rules: []),
      ],
    );

    testWidgets('NET-001 list with active and not applied', (tester) async {
      await openNetwork(tester, 'Firewalls', cloud: withFirewall());
      expect(find.text('Active · 2 rules'), findsOneWidget);
      expect(find.text('Not applied · 0 rules'), findsOneWidget);
      await tap(tester, 'Not applied');
      expect(find.text('web'), findsNothing);
    });

    testWidgets('NET-004 NET-013 detail with rules and servers', (
      tester,
    ) async {
      await openNetwork(tester, 'Firewalls', cloud: withFirewall());
      await tap(tester, 'web');
      expect(find.text('TCP 22'), findsOneWidget);
      expect(find.text('0.0.0.0/0, ::/0 · ssh'), findsOneWidget);
      expect(find.text('ICMP'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('APPLIED TO'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('web-1'), findsOneWidget);
    });

    testWidgets('NET-005 NET-006 NET-007 NET-008 NET-009 NET-010 add a rule', (
      tester,
    ) async {
      final cloud = await openNetwork(
        tester,
        'Firewalls',
        cloud: withFirewall(),
      );
      await tap(tester, 'spare');
      await tap(tester, 'Add rule');
      await enter(tester, 'port', '80-x');
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'))
            .onPressed,
        isNull,
      );
      await enter(tester, 'port', '8000-9000');
      await tap(tester, 'Any IPv4');
      await enter(tester, 'description', 'app');
      await tap(tester, 'Save');
      expect(cloud.body('POST /firewalls/52/actions/set_rules'), {
        'rules': [
          {
            'direction': 'in',
            'protocol': 'tcp',
            'port': '8000-9000',
            'source_ips': ['0.0.0.0/0'],
            'description': 'app',
          },
        ],
      });
      await settleAction(tester);
    });

    testWidgets('NET-005 a rule added meanwhile stays; an applied firewall '
        'cannot be deleted', (tester) async {
      final cloud = await openNetwork(
        tester,
        'Firewalls',
        cloud: withFirewall(),
      );
      await tap(tester, 'web');
      expect(
        find.text(
          'Still in use. Remove it from all its servers and label selectors '
          'first, then delete it.',
        ),
        findsOneWidget,
      );
      // Elsewhere, after the page loaded.
      (cloud.collections['firewalls']!.first['rules']! as List).add(
        ruleJson(port: '443', description: 'https'),
      );
      await tap(tester, 'Add rule');
      await enter(tester, 'port', '80');
      await tap(tester, 'Any IPv4');
      await tap(tester, 'Save');
      final rules =
          cloud.body('POST /firewalls/51/actions/set_rules')['rules']! as List;
      expect(
        [for (final r in rules) (r as Map)['port']],
        ['22', null, '443', '80'],
      );
      await settleAction(tester);
    });

    testWidgets('NET-011 NET-012 edit and delete a rule', (tester) async {
      final cloud = await openNetwork(
        tester,
        'Firewalls',
        cloud: withFirewall(),
      );
      await tap(tester, 'web');
      await tap(tester, 'TCP 22');
      await tap(tester, 'Custom');
      await enter(tester, 'ips', '203.0.113.0/24');
      await tap(tester, 'Save');
      final rules =
          cloud.body('POST /firewalls/51/actions/set_rules')['rules']! as List;
      expect(rules, hasLength(2));
      expect((rules.first as Map)['source_ips'], ['203.0.113.0/24']);
      await settleAction(tester);
      await tester.tap(find.byTooltip('Delete').first);
      await tester.pumpAndSettle();
      expect(find.text('Delete rule TCP 22?'), findsOneWidget);
      await confirm(tester, 'Delete');
      expect(
        (cloud.body('POST /firewalls/51/actions/set_rules')['rules']! as List)
            .length,
        1,
      );
      await settleAction(tester);
    });

    testWidgets('NET-003 NET-014 NET-089 apply to a searched server and a '
        'label selector', (tester) async {
      final cloud = await openNetwork(
        tester,
        'Firewalls',
        cloud: withFirewall(),
      );
      await tap(tester, 'spare');
      await tap(tester, 'Apply');
      await tester.enterText(find.byType(TextField).last, 'db');
      await tester.pumpAndSettle();
      expect(find.text('web-1'), findsNothing);
      await tap(tester, 'db-1');
      expect(cloud.body('POST /firewalls/52/actions/apply_to_resources'), {
        'apply_to': [
          {
            'type': 'server',
            'server': {'id': 2},
          },
        ],
      });
      await settleAction(tester);
      await tap(tester, 'Apply');
      await tap(tester, 'Label selector');
      await enter(tester, 'selector', 'role=web');
      await tap(tester, 'Save');
      expect(cloud.body('POST /firewalls/52/actions/apply_to_resources'), {
        'apply_to': [
          {
            'type': 'label_selector',
            'label_selector': {'selector': 'role=web'},
          },
        ],
      });
      await settleAction(tester);
    });

    testWidgets('NET-015 NET-016 NET-017 BUG-018 remove from a server, rename, '
        'delete', (tester) async {
      final cloud = await openNetwork(
        tester,
        'Firewalls',
        cloud: withFirewall(),
      );
      await tap(tester, 'web');
      await tester.scrollUntilVisible(
        find.byTooltip('Remove'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byTooltip('Remove'));
      await tester.pumpAndSettle();
      expect(find.text('Remove web from web-1?'), findsOneWidget);
      expect(find.textContaining('no longer protect'), findsOneWidget);
      await confirm(tester, 'Remove');
      expect(cloud.body('POST /firewalls/51/actions/remove_from_resources'), {
        'remove_from': [
          {
            'type': 'server',
            'server': {'id': 1},
          },
        ],
      });
      await settleAction(tester);
      await tap(tester, 'Edit');
      await enter(tester, 'name', 'edge');
      await tap(tester, 'Save');
      expect(cloud.body('PUT /firewalls/51'), {
        'name': 'edge',
        'labels': <String, Object?>{},
      });
      await tap(tester, 'Delete');
      await typeName(tester, 'edge');
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /firewalls/51'));
    });

    testWidgets('NET-002 create with rules and targets in the wizard', (
      tester,
    ) async {
      final cloud = await openNetwork(tester, 'Firewalls');
      expect(find.text('No firewalls in this project yet.'), findsOneWidget);
      await tap(tester, 'Create firewall');
      await enter(tester, 'name', 'edge');
      await tap(tester, 'Next');
      await tap(tester, 'Add rule');
      await enter(tester, 'port', '443');
      await tap(tester, 'Save');
      expect(find.text('Inbound TCP 443'), findsOneWidget);
      await tap(tester, 'Next');
      await tap(tester, 'web-1');
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      expect(cloud.body('POST /firewalls'), {
        'name': 'edge',
        'rules': [
          {
            'direction': 'in',
            'protocol': 'tcp',
            'port': '443',
            'source_ips': ['0.0.0.0/0', '::/0'],
            'description': null,
          },
        ],
        'apply_to': [
          {
            'type': 'server',
            'server': {'id': 1},
          },
        ],
        'labels': <String, Object?>{},
      });
      expect(find.text('edge'), findsOneWidget);
    });

    test('NET-006 NET-007 NET-008 NET-009 rule rules', () {
      expect(hasPort('tcp'), isTrue);
      expect(hasPort('icmp'), isFalse);
      expect(validPort('22'), isTrue);
      expect(validPort('8000-9000'), isTrue);
      expect(validPort('9000-8000'), isFalse);
      expect(validPort('0'), isFalse);
      expect(validPort('70000'), isFalse);
      expect(validPort('any'), isTrue);
      expect(validPort(' ANY '), isTrue);
      expect(validPort('anything'), isFalse);
      expect(validIps('0.0.0.0/0, ::/0'), isTrue);
      expect(validIps('2001:db8::/32\n10.0.0.0/8'), isTrue);
      expect(validIps(''), isFalse);
      expect(validIps('10.0.0.1'), isFalse);
      final out = ruleOf({
        'direction': 'out',
        'protocol': 'icmp',
        'preset': 'v6',
        'port': '22',
      });
      expect(out.toJson(), {
        'direction': 'out',
        'protocol': 'icmp',
        'destination_ips': ['::/0'],
      });
      expect(ruleValues(out)['preset'], 'v6');
      expect(validRule({'protocol': 'udp', 'port': ''}), isFalse);
      expect(ruleOf({'protocol': 'tcp', 'port': ' 80 - 443 '}).port, '80-443');
    });
  });

  group('Floating and Primary IPs', () {
    /// Servers that are off: db-1 without, app-1 with a Primary IPv4.
    List<Map<String, Object?>> offServers() {
      final db = serverJson(id: 2, name: 'db-1', status: 'off');
      db['public_net'] = <Object?, Object?>{
        ...db['public_net']! as Map,
        'ipv4': null,
      };
      return [
        serverJson(id: 1, name: 'web-1'),
        db,
        serverJson(id: 3, name: 'app-1', status: 'off'),
      ];
    }

    FakeCloud withIps() => FakeCloud(
      servers: offServers(),
      floatingIps: [
        floatingIpJson(id: 61, name: 'vip', server: 1),
        floatingIpJson(id: 62, name: 'spare-ip', ip: '198.51.100.11'),
      ],
      primaryIps: [
        primaryIpJson(id: 71, name: 'web-v4', server: 1),
        primaryIpJson(id: 72, name: 'free-v4', ip: '198.51.100.21'),
      ],
    );

    testWidgets(
      'NET-018 NET-031 BUG-011 lists with IP, type, server, location',
      (tester) async {
        await openNetwork(tester, 'Floating IPs', cloud: withIps());
        expect(
          find.text('198.51.100.10 · IPv4 · web-1 · fsn1'),
          findsOneWidget,
        );
        expect(
          find.text('198.51.100.11 · IPv4 · Not assigned · fsn1'),
          findsOneWidget,
        );
        await tester.pageBack();
        await tester.pumpAndSettle();
        await openList(tester, 'Primary IPs');
        expect(
          find.text('198.51.100.20 · IPv4 · web-1 · fsn1'),
          findsOneWidget,
        );
      },
    );

    testWidgets('empty states', (tester) async {
      await openNetwork(tester, 'Floating IPs');
      expect(find.text('No Floating IPs in this project yet.'), findsOneWidget);
    });

    testWidgets('NET-024 NET-026 NET-027 detail, unassign, reverse DNS', (
      tester,
    ) async {
      final cloud = await openNetwork(tester, 'Floating IPs', cloud: withIps());
      await tap(tester, 'vip');
      expect(find.textContaining('assigned to web-1'), findsOneWidget);
      expect(find.text('198.51.100.10 → static.example.com'), findsOneWidget);
      await tap(tester, 'Unassign');
      expect(find.text('Unassign vip from web-1?'), findsOneWidget);
      await confirm(tester, 'Unassign');
      expect(cloud.calls, contains('POST /floating_ips/61/actions/unassign'));
      await settleAction(tester);
      await tile(tester, 'Reverse DNS');
      await enter(tester, 'ptr', '');
      await tap(tester, 'Save');
      expect(cloud.body('POST /floating_ips/61/actions/change_dns_ptr'), {
        'ip': '198.51.100.10',
        'dns_ptr': null,
      });
      await settleAction(tester);
    });

    testWidgets('NET-025 NET-028 NET-029 NET-030 BUG-001 assign, edit, '
        'protect, delete', (tester) async {
      final cloud = await openNetwork(tester, 'Floating IPs', cloud: withIps());
      await tap(tester, 'spare-ip');
      await tap(tester, 'Assign');
      await tap(tester, 'db-1');
      expect(cloud.body('POST /floating_ips/62/actions/assign'), {'server': 2});
      await settleAction(tester);
      await tap(tester, 'Edit');
      await enter(tester, 'description', 'failover');
      await tap(tester, 'Save');
      expect(cloud.body('PUT /floating_ips/62'), {
        'name': 'spare-ip',
        'labels': <String, Object?>{},
        'description': 'failover',
      });
      await tap(tester, 'Protection');
      await confirm(tester, 'Protect');
      expect(cloud.body('POST /floating_ips/62/actions/change_protection'), {
        'delete': true,
      });
      await settleAction(tester);
      // The API refuses to delete an assigned IP: unassign first.
      expect(
        find.text(
          'The IP is still assigned. Unassign it from its server first, '
          'then delete it.',
        ),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Delete'));
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(find.text('Delete spare-ip?'), findsNothing);
      await tap(tester, 'Unassign');
      await confirm(tester, 'Unassign');
      await settleAction(tester);
      await tap(tester, 'Delete');
      // The Floating IP's own texts, never another type's (BUG-001).
      expect(find.text('Delete spare-ip?'), findsOneWidget);
      expect(find.textContaining('198.51.100.11 is released'), findsOneWidget);
      await typeName(tester, 'spare-ip');
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /floating_ips/62'));
    });

    testWidgets('NET-019 NET-020 NET-021 NET-022 NET-023 create on a server', (
      tester,
    ) async {
      final cloud = await openNetwork(tester, 'Floating IPs');
      await tap(tester, 'Create Floating IP');
      await tap(tester, 'IPv6');
      await tap(tester, 'Next');
      await tap(tester, 'Assign to web-1 (fsn1)');
      await tap(tester, 'Next');
      await enter(tester, 'description', 'vip');
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      expect(cloud.body('POST /floating_ips'), {
        'type': 'ipv6',
        'server': 1,
        'description': 'vip',
        'labels': <String, Object?>{},
      });
      await settleAction(tester);
    });

    testWidgets('NET-032 NET-033 Primary IP needs a name, goes to a location', (
      tester,
    ) async {
      final cloud = await openNetwork(
        tester,
        'Primary IPs',
        cloud: FakeCloud(servers: offServers()),
      );
      await tap(tester, 'Create Primary IP');
      await tap(tester, 'Next');
      // Only servers that are off and have no Primary IP of the type can
      // take one.
      expect(find.text('Assign to web-1 (fsn1)'), findsNothing);
      expect(find.text('Assign to app-1 (fsn1)'), findsNothing);
      expect(find.text('Assign to db-1 (fsn1)'), findsOneWidget);
      await tap(tester, 'fsn1 · Falkenstein DC Park 1');
      await tap(tester, 'Next');
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next'))
            .onPressed,
        isNull,
      );
      await enter(tester, 'name', 'mail-v4');
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      expect(cloud.body('POST /primary_ips'), {
        'type': 'ipv4',
        'name': 'mail-v4',
        'location': 'fsn1',
        'assignee_type': 'unassigned',
        'labels': <String, Object?>{},
        'auto_delete': false,
      });
      await settleAction(tester);
    });

    testWidgets('NET-034 NET-035 NET-036 NET-037 NET-038 NET-093 NET-094 '
        'BUG-015 Primary IP detail and changes', (tester) async {
      final cloud = await openNetwork(tester, 'Primary IPs', cloud: withIps());
      await tap(tester, 'free-v4');
      expect(find.text('Not assigned'), findsWidgets);
      await tap(tester, 'Assign');
      expect(find.text('web-1'), findsNothing, reason: 'running');
      expect(find.text('app-1'), findsNothing, reason: 'has a Primary IPv4');
      await tap(tester, 'db-1');
      expect(cloud.body('POST /primary_ips/72/actions/assign'), {
        'assignee_type': 'server',
        'assignee_id': 2,
      });
      await settleAction(tester);
      await tap(tester, 'Unassign');
      await confirm(tester, 'Unassign');
      expect(cloud.calls, contains('POST /primary_ips/72/actions/unassign'));
      await settleAction(tester);
      await tile(tester, 'Reverse DNS');
      await enter(tester, 'ptr', 'mail.example.com');
      await tap(tester, 'Save');
      expect(cloud.body('POST /primary_ips/72/actions/change_dns_ptr'), {
        'ip': '198.51.100.21',
        'dns_ptr': 'mail.example.com',
      });
      await settleAction(tester);
      await tap(tester, 'Edit');
      await enter(tester, 'name', 'mail-v4');
      await tester.tap(find.text('Yes').last);
      await tester.pumpAndSettle();
      await tap(tester, 'Save');
      expect(cloud.body('PUT /primary_ips/72'), {
        'name': 'mail-v4',
        'labels': <String, Object?>{},
        'auto_delete': true,
      });
      await tap(tester, 'Protection');
      await confirm(tester, 'Protect');
      expect(
        cloud.calls,
        contains('POST /primary_ips/72/actions/change_protection'),
      );
      await settleAction(tester);
      await tap(tester, 'Delete');
      await typeName(tester, 'mail-v4');
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /primary_ips/72'));
    });

    testWidgets('CMP-085 the server wizard can use a free Primary IP', (
      tester,
    ) async {
      final cloud = withIps();
      setSurface(tester);
      await pumpFalco(tester, cloud);
      await openList(tester, 'Servers');
      await tap(tester, 'Create server');
      await tap(tester, 'fsn1');
      await tap(tester, 'Next');
      await tap(tester, 'CX22');
      await tap(tester, 'Next');
      await tap(tester, 'Debian 12');
      await tap(tester, 'Next');
      await tap(tester, 'Next');
      await tap(tester, 'free-v4 · 198.51.100.21');
      await tap(tester, 'Next');
      await tap(tester, 'Next');
      await enter(tester, 'name', 'app-1');
      await tap(tester, 'Next');
      expect(
        find.textContaining('Public IPv4 (free-v4 · 198.51.100.21)'),
        findsOneWidget,
      );
      await tester.tap(find.text('Create'));
      await pumpFrames(tester);
      expect(cloud.body('POST /servers')['public_net'], {
        'enable_ipv4': true,
        'enable_ipv6': true,
        'ipv4': 72,
      });
    });

    test('kinds share one model', () {
      final ip = PublicIp.fromJson(
        IpKind.primary,
        primaryIpJson(
          id: 1,
          name: 'a',
          server: 3,
          ipv6: true,
          ip: '2001:db8::/64',
        ),
        'p1',
      );
      expect(ip.server, 3);
      expect(ip.ipv6, isTrue);
      expect(ip.location, 'fsn1');
      expect(ip.ptrAddress, '2001:db8::1');
    });
  });
}
