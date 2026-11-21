// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/features/network/certificates.dart';
import 'package:falco/features/network/load_balancers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';
import '../network_steps.dart';
import '../steps.dart';

FakeCloud withLb() => FakeCloud(
  networks: [networkJson(id: 21, name: 'lan')],
  loadBalancers: [
    loadBalancerJson(
      id: 81,
      name: 'front',
      networks: [21],
      services: [
        lbServiceJson(),
        lbServiceJson(protocol: 'tcp', listen: 25, destination: 25),
      ],
      targets: [
        serverTargetJson(1),
        {
          'type': 'label_selector',
          'label_selector': {'selector': 'role=web'},
          'targets': <Object?>[],
          'use_private_ip': true,
        },
      ],
    ),
  ],
  certificates: [
    certificateJson(id: 91, name: 'site', usedBy: [81]),
    certificateJson(
      id: 92,
      name: 'auto',
      managed: true,
      failed: true,
      domains: ['example.com', 'www.example.com'],
    ),
  ],
);

void main() {
  group('load balancers', () {
    testWidgets('NET-056 list with type, location, IP, counts', (tester) async {
      await openNetwork(tester, 'Load balancers', cloud: withLb());
      expect(
        find.text('LB11 · fsn1 · 203.0.113.81 · 2 services · 2 targets'),
        findsOneWidget,
      );
    });

    testWidgets('empty state offers create', (tester) async {
      await openNetwork(tester, 'Load balancers');
      expect(
        find.text('No load balancers in this project yet.'),
        findsOneWidget,
      );
    });

    testWidgets('NET-057 NET-058 NET-059 NET-063 detail with network, '
        'services and targets', (tester) async {
      await openNetwork(tester, 'Load balancers', cloud: withLb());
      await tap(tester, 'front');
      expect(
        find.textContaining('10000 connections, 5 services'),
        findsOneWidget,
      );
      expect(find.text('lan'), findsOneWidget);
      expect(find.text('HTTP 80 → 80'), findsOneWidget);
      expect(find.text('TCP 25 → 25'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('role=web'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Server · healthy'), findsOneWidget);
      expect(
        find.text('Label selector · Route via private network'),
        findsOneWidget,
      );
    });

    testWidgets('NET-060 NET-088 add an HTTPS service with certificate and '
        'redirect', (tester) async {
      final cloud = await openNetwork(
        tester,
        'Load balancers',
        cloud: withLb(),
      );
      await tap(tester, 'front');
      await tile(tester, 'Add service');
      await tap(tester, 'HTTPS');
      await enter(tester, 'listen', '443');
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'))
            .onPressed,
        isNull,
        reason: 'https needs a certificate',
      );
      await tap(tester, 'site');
      await tester.tap(find.text('Yes').at(1));
      await tester.pumpAndSettle();
      await tap(tester, 'Save');
      final body = cloud.body('POST /load_balancers/81/actions/add_service');
      expect(body['protocol'], 'https');
      expect(body['listen_port'], 443);
      expect(
        body['http'],
        allOf(
          containsPair('redirect_http', true),
          containsPair('certificates', [91]),
        ),
      );
      await settleAction(tester);
    });

    testWidgets('NET-061 NET-087 edit a service health check, listen port '
        'fixed', (tester) async {
      final cloud = await openNetwork(
        tester,
        'Load balancers',
        cloud: withLb(),
      );
      await tap(tester, 'front');
      await tap(tester, 'HTTP 80 → 80');
      expect(find.byKey(const ValueKey('listen')), findsNothing);
      await enter(tester, 'hcInterval', '2');
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'))
            .onPressed,
        isNull,
      );
      await enter(tester, 'hcInterval', '30');
      await enter(tester, 'hcPath', '/health');
      await tap(tester, 'Save');
      final body = cloud.body('POST /load_balancers/81/actions/update_service');
      expect(body['listen_port'], 80);
      expect(body['health_check'], {
        'protocol': 'http',
        'port': 80,
        'interval': 30,
        'timeout': 10,
        'retries': 3,
        'http': {
          'domain': null,
          'path': '/health',
          'status_codes': ['2??', '3??'],
          'tls': false,
        },
      });
      await settleAction(tester);
    });

    testWidgets('NET-062 NET-067 delete a service, remove a target', (
      tester,
    ) async {
      final cloud = await openNetwork(
        tester,
        'Load balancers',
        cloud: withLb(),
      );
      await tap(tester, 'front');
      await tester.ensureVisible(find.text('TCP 25 → 25'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.widgetWithText(ListTile, 'TCP 25 → 25'),
          matching: find.byTooltip('Delete'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Delete service TCP 25 → 25?'), findsOneWidget);
      await confirm(tester, 'Delete');
      expect(cloud.body('POST /load_balancers/81/actions/delete_service'), {
        'listen_port': 25,
      });
      await settleAction(tester);
      await tester.scrollUntilVisible(
        find.text('role=web'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(
        find.descendant(
          of: find.widgetWithText(ListTile, 'role=web'),
          matching: find.byTooltip('Remove'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Remove target role=web?'), findsOneWidget);
      await confirm(tester, 'Remove');
      expect(cloud.body('POST /load_balancers/81/actions/remove_target'), {
        'type': 'label_selector',
        'label_selector': {'selector': 'role=web'},
      });
      await settleAction(tester);
    });

    testWidgets('NET-064 NET-065 NET-066 targets: server, selector, IP', (
      tester,
    ) async {
      final cloud = await openNetwork(
        tester,
        'Load balancers',
        cloud: withLb(),
      );
      await tap(tester, 'front');
      await tile(tester, 'Add target');
      await tap(tester, 'db-1');
      await tester.tap(find.text('Yes').last);
      await tester.pumpAndSettle();
      await tap(tester, 'Save');
      expect(cloud.body('POST /load_balancers/81/actions/add_target'), {
        'type': 'server',
        'server': {'id': 2},
        'use_private_ip': true,
      });
      await settleAction(tester);
      await tile(tester, 'Add target');
      await tap(tester, 'Label selector');
      await enter(tester, 'selector', 'role=api');
      await tap(tester, 'Save');
      expect(
        cloud.body(
          'POST /load_balancers/81/actions/add_target',
        )['label_selector'],
        {'selector': 'role=api'},
      );
      await settleAction(tester);
      await tile(tester, 'Add target');
      await tap(tester, 'Address');
      await enter(tester, 'ip', '203.0.113.7');
      await tap(tester, 'Save');
      expect(cloud.body('POST /load_balancers/81/actions/add_target'), {
        'type': 'ip',
        'ip': {'ip': '203.0.113.7'},
        'use_private_ip': false,
      });
      await settleAction(tester);
    });

    testWidgets('NET-068 NET-069 NET-091 algorithm only when changed, type '
        'with limits', (tester) async {
      final cloud = await openNetwork(
        tester,
        'Load balancers',
        cloud: withLb(),
      );
      await tap(tester, 'front');
      await more(tester, 'Algorithm');
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'))
            .onPressed,
        isNull,
      );
      await tap(tester, 'Least connections');
      await tap(tester, 'Save');
      expect(cloud.body('POST /load_balancers/81/actions/change_algorithm'), {
        'type': 'least_connections',
      });
      await settleAction(tester);
      await more(tester, 'Change type');
      expect(
        find.text('20000 connections, 15 services, 50 targets'),
        findsOneWidget,
      );
      await tap(tester, 'LB21');
      expect(cloud.body('POST /load_balancers/81/actions/change_type'), {
        'load_balancer_type': 'lb21',
      });
      await settleAction(tester);
    });

    testWidgets('NET-070 NET-075 NET-076 NET-077 public interface, networks, '
        'reverse DNS', (tester) async {
      final cloud = withLb();
      cloud.collections['networks']!.add(networkJson(id: 22, name: 'db-net'));
      await openNetwork(tester, 'Load balancers', cloud: cloud);
      await tap(tester, 'front');
      await more(tester, 'Disable public interface');
      await confirm(tester, 'Disable public interface');
      expect(
        cloud.calls,
        contains('POST /load_balancers/81/actions/disable_public_interface'),
      );
      await settleAction(tester);
      expect(find.text('Public interface disabled'), findsOneWidget);
      await more(tester, 'Enable public interface');
      expect(
        cloud.calls,
        contains('POST /load_balancers/81/actions/enable_public_interface'),
      );
      await settleAction(tester);
      await more(tester, 'Attach to network');
      await tap(tester, 'db-net');
      await tap(tester, 'Save');
      expect(cloud.body('POST /load_balancers/81/actions/attach_to_network'), {
        'network': 22,
      });
      await settleAction(tester);
      await tester.tap(
        find.descendant(
          of: find.widgetWithText(ListTile, 'lan'),
          matching: find.byTooltip('Remove'),
        ),
      );
      await tester.pumpAndSettle();
      await confirm(tester, 'Remove');
      expect(
        cloud.body('POST /load_balancers/81/actions/detach_from_network'),
        {'network': 21},
      );
      await settleAction(tester);
      await more(tester, 'Reverse DNS');
      await enter(tester, 'ptr', 'www.example.com');
      await tap(tester, 'Save');
      expect(cloud.body('POST /load_balancers/81/actions/change_dns_ptr'), {
        'ip': '203.0.113.81',
        'dns_ptr': 'www.example.com',
      });
      await settleAction(tester);
    });

    testWidgets('NET-071 NET-072 NET-073 NET-090 protection, edit, delete', (
      tester,
    ) async {
      final cloud = await openNetwork(
        tester,
        'Load balancers',
        cloud: withLb(),
      );
      await tap(tester, 'front');
      await tile(tester, 'Protection');
      await confirm(tester, 'Protect');
      expect(cloud.body('POST /load_balancers/81/actions/change_protection'), {
        'delete': true,
      });
      await settleAction(tester);
      await tile(tester, 'Edit');
      await enter(tester, 'labels', 'env=prod');
      await tap(tester, 'Save');
      expect(cloud.body('PUT /load_balancers/81'), {
        'name': 'front',
        'labels': {'env': 'prod'},
      });
      await tap(tester, 'Delete');
      await typeName(tester, 'front');
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /load_balancers/81'));
    });

    testWidgets('NET-078 metrics: connections, requests, bandwidth', (
      tester,
    ) async {
      final cloud = await openNetwork(
        tester,
        'Load balancers',
        cloud: withLb(),
      );
      await tap(tester, 'front');
      await tester.scrollUntilVisible(
        find.textContaining('Requests per second: min'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(
        cloud.calls.where((c) => c == 'GET /load_balancers/81/metrics'),
        hasLength(4),
      );
      expect(
        find.textContaining('Requests per second: min 7.0 · max 7.0'),
        findsOneWidget,
      );
    });

    testWidgets('NET-074 create with type, network, service and target', (
      tester,
    ) async {
      final cloud = await openNetwork(
        tester,
        'Load balancers',
        cloud: withLb(),
      );
      await tap(tester, 'Create load balancer');
      await tap(tester, 'fsn1');
      await tap(tester, 'Next');
      expect(find.textContaining('€5.39'), findsOneWidget);
      await tap(tester, 'LB11');
      await tap(tester, 'Next');
      await tap(tester, 'lan');
      await tap(tester, 'Next');
      await enter(tester, 'name', 'edge');
      await tap(tester, 'Next');
      await tap(tester, 'Add service');
      await tap(tester, 'Save');
      expect(find.text('HTTP 80 → 80'), findsOneWidget);
      await tap(tester, 'Next');
      await tap(tester, 'Add target');
      await tap(tester, 'web-1');
      await tap(tester, 'Save');
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      final body = cloud.body('POST /load_balancers');
      expect(body['name'], 'edge');
      expect(body['load_balancer_type'], 'lb11');
      expect(body['location'], 'fsn1');
      expect(body['network'], 21);
      expect(body['algorithm'], {'type': 'round_robin'});
      expect(
        (body['services']! as List).single,
        containsPair('listen_port', 80),
      );
      expect(body['targets'], [
        {
          'type': 'server',
          'server': {'id': 1},
          'use_private_ip': false,
        },
      ]);
      await settleAction(tester);
    });

    test('NET-060 NET-087 service form round trip and limits', () {
      final s = serviceJson({
        ...serviceValuesDefaults,
        'protocol': 'tcp',
        'hcProtocol': 'tcp',
      });
      expect(s.containsKey('http'), isFalse);
      expect(serviceValues(s)['protocol'], 'tcp');
      expect(validServicePort('0'), isFalse);
      expect(validServicePort('65535'), isTrue);
      expect(
        validService({...serviceValuesDefaults, 'hcRetries': '6'}),
        isFalse,
      );
      expect(
        targetKey({
          'type': 'server',
          'server': {'id': 3},
          'use_private_ip': true,
        }),
        {
          'type': 'server',
          'server': {'id': 3},
        },
      );
    });
  });

  group('certificates', () {
    testWidgets('NET-079 list with type, domains, expiry', (tester) async {
      await openNetwork(tester, 'Certificates', cloud: withLb());
      expect(
        find.textContaining('Uploaded · example.com · Valid until'),
        findsOneWidget,
      );
      expect(
        find.textContaining("Managed (Let's Encrypt) · example.com, www"),
        findsOneWidget,
      );
    });

    testWidgets('empty state', (tester) async {
      await openNetwork(tester, 'Certificates');
      expect(find.text('No certificates in this project yet.'), findsOneWidget);
    });

    testWidgets('NET-082 NET-083 NET-084 detail, rename, delete', (
      tester,
    ) async {
      final cloud = await openNetwork(tester, 'Certificates', cloud: withLb());
      await tap(tester, 'site');
      expect(find.text('front'), findsOneWidget);
      expect(
        find.text('03:c7:55:9b:2a:d1:04:17:09:f6:d0:7f:18:34:63:d4'),
        findsOneWidget,
      );
      await tile(tester, 'Edit');
      await enter(tester, 'name', 'site-2');
      await tap(tester, 'Save');
      expect(cloud.body('PUT /certificates/91'), {
        'name': 'site-2',
        'labels': <String, Object?>{},
      });
      await tap(tester, 'Delete');
      await typeName(tester, 'site-2');
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /certificates/91'));
    });

    testWidgets('NET-085 retry a failed managed certificate', (tester) async {
      final cloud = await openNetwork(tester, 'Certificates', cloud: withLb());
      await tap(tester, 'auto');
      expect(find.text('DNS zone not found'), findsOneWidget);
      await tile(tester, 'Retry');
      expect(cloud.calls, contains('POST /certificates/92/actions/retry'));
      await settleAction(tester);
    });

    testWidgets('NET-080 upload with PEM certificate and key', (tester) async {
      final cloud = await openNetwork(tester, 'Certificates');
      await tap(tester, 'Add certificate');
      await tap(tester, 'Uploaded');
      await tap(tester, 'Next');
      await enter(tester, 'name', 'own');
      await enter(tester, 'certificate', 'not a pem');
      await enter(tester, 'key', '-----BEGIN PRIVATE KEY-----\nFAKE');
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next'))
            .onPressed,
        isNull,
      );
      await enter(tester, 'certificate', '-----BEGIN CERTIFICATE-----\nFAKE');
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      expect(cloud.body('POST /certificates'), {
        'name': 'own',
        'type': 'uploaded',
        'certificate': '-----BEGIN CERTIFICATE-----\nFAKE',
        'private_key': '-----BEGIN PRIVATE KEY-----\nFAKE',
        'labels': <String, Object?>{},
      });
    });

    testWidgets("NET-081 managed with Let's Encrypt domains", (tester) async {
      final cloud = await openNetwork(tester, 'Certificates');
      await tap(tester, 'Add certificate');
      await tap(tester, 'Next');
      await enter(tester, 'name', 'le');
      await enter(tester, 'domains', 'example.com, *.example.com');
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      expect(cloud.body('POST /certificates'), {
        'name': 'le',
        'type': 'managed',
        'domain_names': ['example.com', '*.example.com'],
        'labels': <String, Object?>{},
      });
      await settleAction(tester);
    });

    test('certificate states', () {
      final now = DateTime.utc(2026, 6);
      Certificate c(Map<String, Object?> j) => Certificate.fromJson(j, 'p1');
      expect(
        c(certificateJson(id: 1, name: 'a')).status(now).name,
        'available',
      );
      expect(
        c(certificateJson(id: 1, name: 'a', managed: true, failed: true))
            .status(now)
            .name,
        'error',
      );
      expect(splitDomains('a.com,  b.com'), ['a.com', 'b.com']);
      expect(
        looksLikePem('-----BEGIN RSA PRIVATE KEY-----', key: true),
        isTrue,
      );
    });
  });
}

/// Form values of a new HTTP service.
const serviceValuesDefaults = {
  'protocol': 'http',
  'listen': '80',
  'destination': '80',
  'hcProtocol': 'http',
  'hcInterval': '15',
  'hcTimeout': '10',
  'hcRetries': '3',
};
