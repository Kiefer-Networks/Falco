// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:async';

import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/placement_groups/placement_groups.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';
import '../steps.dart';

Future<FakeCloud> openServer(
  WidgetTester tester, {
  FakeCloud? cloud,
  String name = 'web-1',
}) async {
  final c = cloud ?? FakeCloud();
  setSurface(tester);
  await pumpFalco(tester, c);
  await tester.tap(find.text(name));
  await tester.pumpAndSettle();
  return c;
}

void main() {
  group('create server', () {
    testWidgets('CMP-001 CMP-007 the Compute overview counts its types, '
        'the list has the one create button', (tester) async {
      await pumpFalco(tester, FakeCloud());
      for (final type in [
        'Servers',
        'Volumes',
        'Images',
        'Placement groups',
        'SSH keys',
      ]) {
        expect(find.text(type), findsOneWidget);
      }
      expect(find.text('Create server'), findsNothing);
      expect(find.text('running: 1 · off: 1'), findsOneWidget);
      await openList(tester, 'Servers');
      expect(find.text('Create server'), findsOneWidget);
    });

    testWidgets('CMP-004 the empty list shows a hint, creating is the button '
        'at the bottom', (tester) async {
      await pumpFalco(tester, FakeCloud(servers: []));
      await openList(tester, 'Servers');
      expect(find.byType(FilledButton), findsNothing);
      await tester.tap(
        find.widgetWithText(FloatingActionButton, 'Create server'),
      );
      await tester.pumpAndSettle();
      expect(find.text('Location'), findsWidgets);
    });

    testWidgets('CMP-008 CMP-009 CMP-010 CMP-011 CMP-012 CMP-014 CMP-085 '
        'CMP-086 steps, type with price, skippable keys, details, root '
        'password once', (tester) async {
      final cloud = FakeCloud();
      setSurface(tester);
      await pumpFalco(tester, cloud);
      await openList(tester, 'Servers');
      await tap(tester, 'Create server');
      expect(
        cloud.calls,
        containsAll([
          'GET /locations',
          'GET /server_types',
          'GET /images',
          'GET /ssh_keys',
        ]),
      );
      await tap(tester, 'fsn1');
      await tap(tester, 'Next');
      expect(
        find.text('2 vCPU · 4 GiB · 40 GiB · €4.51/month'),
        findsOneWidget,
      );
      await tap(tester, 'CX22');
      await tap(tester, 'Next');
      await tap(tester, 'Debian 12');
      await tap(tester, 'Next');
      expect(
        find.textContaining('No SSH keys in this project'),
        findsOneWidget,
      );
      await tap(tester, 'Next');
      await tap(tester, 'Public IPv6');
      await tap(tester, 'Next');
      await tap(tester, 'Next');
      await tester.enterText(find.byKey(const ValueKey('name')), 'app-1');
      await tester.enterText(find.byKey(const ValueKey('labels')), 'env=prod');
      await tester.enterText(
        find.byKey(const ValueKey('userData')),
        '#cloud-config',
      );
      await tester.pumpAndSettle();
      await tap(tester, 'Next');
      // Server and the new Primary IPv4 (CMP-010).
      expect(find.text('€5.01/month'), findsOneWidget);
      // The create button spins until the password sheet is closed.
      await tester.tap(find.text('Create'));
      await pumpFrames(tester);
      expect(find.text('Root password'), findsWidgets);
      final body = cloud.body('POST /servers');
      expect(body['name'], 'app-1');
      expect(body['server_type'], 'cx22');
      expect(body['image'], '7');
      expect(body['location'], 'fsn1');
      expect(body['labels'], {'env': 'prod'});
      expect(body['user_data'], '#cloud-config');
      expect(body['public_net'], containsPair('enable_ipv6', false));
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('app-1'), findsOneWidget);
      await settleAction(tester);
    });

    testWidgets('CMP-081 CMP-082 CMP-083 CMP-084 networks, firewalls, '
        'volumes and placement group go into the request', (tester) async {
      final cloud = FakeCloud(
        volumes: [volumeJson(id: 31, name: 'data')],
        placementGroups: [placementGroupJson(id: 41, name: 'spread-1')],
        sshKeys: [sshKeyJson(id: 61, name: 'laptop')],
      );
      cloud.collections['networks']!.add({
        'id': 71,
        'name': 'backend',
        'ip_range': '10.0.0.0/16',
        'subnets': <Object?>[],
        'routes': <Object?>[],
        'servers': <Object?>[],
        'load_balancers': <Object?>[],
        'protection': {'delete': false},
        'labels': <String, Object?>{},
        'created': '2026-01-01T00:00:00Z',
        'expose_routes_to_vswitch': false,
      });
      cloud.collections['firewalls']!.add({
        'id': 81,
        'name': 'web',
        'labels': <String, Object?>{},
        'created': '2026-01-01T00:00:00Z',
        'rules': <Object?>[],
        'applied_to': <Object?>[],
      });
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
      await tap(tester, 'laptop');
      await tap(tester, 'Next');
      await tap(tester, 'backend');
      await tap(tester, 'web');
      await tap(tester, 'Next');
      await tap(tester, 'data · 50 GiB');
      await tap(tester, 'spread-1');
      await tap(tester, 'Next');
      await tester.enterText(find.byKey(const ValueKey('name')), 'app-2');
      await tester.pumpAndSettle();
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      final body = cloud.body('POST /servers');
      expect(body['ssh_keys'], ['61']);
      expect(body['networks'], [71]);
      expect(body['firewalls'], [
        {'firewall': 81},
      ]);
      expect(body['volumes'], [31]);
      expect(body['automount'], true);
      expect(body['placement_group'], 41);
      // With a key there is no password to show.
      expect(find.text('Root password'), findsNothing);
      await settleAction(tester);
    });
  });

  group('server detail', () {
    testWidgets('CMP-019 attached volume and placement group open their '
        'detail', (tester) async {
      final cloud = FakeCloud(
        servers: [
          serverJson(
            id: 1,
            name: 'web-1',
            volumes: [31],
            placementGroup: placementGroupJson(id: 41, name: 'spread-1'),
          ),
        ],
        volumes: [volumeJson(id: 31, name: 'data', server: 1)],
        placementGroups: [
          placementGroupJson(id: 41, name: 'spread-1', servers: [1]),
        ],
      );
      await openServer(tester, cloud: cloud);
      await tap(tester, 'data');
      expect(find.text('/dev/disk/by-id/scsi-0HC_Volume_31'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tap(tester, 'spread-1');
      expect(find.text('web-1'), findsOneWidget);
    });

    testWidgets('CMP-026 console shows URL and password', (tester) async {
      final cloud = await openServer(tester);
      await more(tester, 'Console');
      expect(cloud.calls, contains('POST /servers/1/actions/request_console'));
      expect(find.text('Websocket URL'), findsOneWidget);
      expect(find.text('VNC password'), findsOneWidget);
      await settleAction(tester);
    });

    testWidgets('CMP-025 CMP-089 snapshot with description and labels', (
      tester,
    ) async {
      final cloud = await openServer(tester);
      await more(tester, 'Snapshot');
      await tester.enterText(
        find.byKey(const ValueKey('description')),
        'before upgrade',
      );
      await tester.enterText(find.byKey(const ValueKey('labels')), 'keep=yes');
      await tester.pumpAndSettle();
      await tap(tester, 'Save');
      expect(cloud.body('POST /servers/1/actions/create_image'), {
        'description': 'before upgrade',
        'labels': {'keep': 'yes'},
        'type': 'snapshot',
      });
      await settleAction(tester);
    });

    testWidgets('CMP-030 reset root password shows it once', (tester) async {
      final cloud = await openServer(tester);
      await more(tester, 'Reset root password');
      await confirm(tester, 'Reset root password');
      expect(cloud.calls, contains('POST /servers/1/actions/reset_password'));
      expect(find.text('Root password'), findsWidgets);
      await settleAction(tester);
    });

    testWidgets('CMP-030 the password survives leaving the page meanwhile', (
      tester,
    ) async {
      final cloud = await openServer(tester);
      await more(tester, 'Reset root password');
      final gate = Completer<void>();
      cloud.adapter.gate = gate.future;
      await tester.tap(
        find.widgetWithText(FilledButton, 'Reset root password'),
      );
      await tester.pump();
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('web-1'), findsOneWidget);
      cloud.adapter.gate = null;
      gate.complete();
      await tester.pumpAndSettle();
      expect(find.text('Root password'), findsWidgets);
      await settleAction(tester);
    });

    testWidgets('CMP-031 CMP-032 CMP-077 rebuild picks an image, needs the '
        'name, shows the password', (tester) async {
      final cloud = FakeCloud(
        images: [
          imageJson(id: 7, name: 'debian-12', description: 'Debian 12'),
          imageJson(id: 8, description: 'nightly', type: 'snapshot', size: 1.5),
        ],
      );
      await openServer(tester, cloud: cloud);
      await tap(tester, 'Rebuild');
      expect(find.text('Snapshot · 1.5 GiB'), findsOneWidget);
      await tap(tester, 'nightly');
      expect(find.text('Rebuild web-1?'), findsOneWidget);
      final button = find.widgetWithText(FilledButton, 'Rebuild');
      expect(tester.widget<FilledButton>(button).onPressed, isNull);
      await tester.enterText(
        find.byKey(const ValueKey('confirm-name')),
        'web-1',
      );
      await tester.pumpAndSettle();
      await confirm(tester, 'Rebuild');
      expect(cloud.body('POST /servers/1/actions/rebuild'), {'image': '8'});
      expect(find.text('Root password'), findsWidgets);
      await settleAction(tester);
    });

    testWidgets('CMP-033 CMP-034 change type needs the server off and sends '
        'the disk choice', (tester) async {
      final cloud = await openServer(tester);
      await more(tester, 'Change type');
      expect(
        find.text('Power off the server before changing its type.'),
        findsOneWidget,
      );
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('db-1'));
      await tester.pumpAndSettle();
      await more(tester, 'Change type');
      await tap(tester, 'CX32');
      expect(find.text('Change to CX32'), findsOneWidget);
      await tap(tester, 'Yes');
      await tap(tester, 'Save');
      expect(cloud.body('POST /servers/2/actions/change_type'), {
        'server_type': 'cx32',
        'upgrade_disk': true,
      });
      await settleAction(tester);
    });

    testWidgets('CMP-035 CMP-036 CMP-037 ISO search, insert, show, eject', (
      tester,
    ) async {
      final cloud = await openServer(tester);
      await more(tester, 'Insert ISO');
      await tester.enterText(find.byType(TextField).last, 'virtio');
      await tester.pumpAndSettle();
      await tap(tester, 'virtio-win-0.1.248.iso');
      expect(cloud.body('POST /servers/1/actions/attach_iso'), {'iso': '51'});
      cloud.servers.first['iso'] = {
        'id': 51,
        'name': 'virtio-win-0.1.248.iso',
        'description': 'virtio 0.1.248',
        'deprecation': null,
        'architecture': 'x86',
      };
      await settleAction(tester);
      expect(find.text('virtio-win-0.1.248.iso'), findsOneWidget);
      await more(tester, 'Eject ISO');
      await confirm(tester, 'Eject ISO');
      expect(cloud.calls, contains('POST /servers/1/actions/detach_iso'));
      await settleAction(tester);
    });

    testWidgets('CMP-038 backups and CMP-039 rescue ask first', (tester) async {
      final cloud = await openServer(tester);
      await more(tester, 'Enable backups');
      expect(find.text('Enable backups for web-1?'), findsOneWidget);
      await confirm(tester, 'Enable backups');
      expect(cloud.calls, contains('POST /servers/1/actions/enable_backup'));
      await more(tester, 'Enable rescue');
      await confirm(tester, 'Enable rescue');
      expect(cloud.calls, contains('POST /servers/1/actions/enable_rescue'));
      expect(find.text('Root password'), findsWidgets);
      await tap(tester, 'Close');
      await settleAction(tester);
      await more(tester, 'Disable rescue');
      await confirm(tester, 'Disable rescue');
      expect(cloud.calls, contains('POST /servers/1/actions/disable_rescue'));
      await settleAction(tester);
    });

    testWidgets('CMP-043 CMP-044 placement group needs the server off, '
        'hint, add and remove', (tester) async {
      final cloud = await openServer(tester);
      await more(tester, 'Add to placement group');
      expect(
        find.text(
          'Power off the server before adding it to a placement group.',
        ),
        findsOneWidget,
      );
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('db-1'));
      await tester.pumpAndSettle();
      await more(tester, 'Add to placement group');
      expect(find.textContaining('No placement groups'), findsOneWidget);
      cloud.collections['placement_groups']!.add(
        placementGroupJson(id: 41, name: 'spread-1'),
      );
      // Created elsewhere: the overview keeps the old list until a refresh.
      ProviderScope.containerOf(tester.element(find.byType(DetailPage)))
          .invalidate(placementGroupsProvider);
      await more(tester, 'Add to placement group');
      await tap(tester, 'spread-1');
      expect(cloud.body('POST /servers/2/actions/add_to_placement_group'), {
        'placement_group': 41,
      });
      cloud.servers.firstWhere((s) => s['id'] == 2)['placement_group'] =
          placementGroupJson(id: 41, name: 'spread-1');
      await settleAction(tester);
      await more(tester, 'Remove from placement group');
      expect(find.text('Remove db-1 from spread-1?'), findsOneWidget);
      await confirm(tester, 'Remove from placement group');
      expect(
        cloud.calls,
        contains('POST /servers/2/actions/remove_from_placement_group'),
      );
      await settleAction(tester);
    });

    testWidgets('CMP-046 delete and rebuild protection as one switch', (
      tester,
    ) async {
      final cloud = await openServer(tester);
      await more(tester, 'Protection');
      await confirm(tester, 'Protect');
      expect(cloud.body('POST /servers/1/actions/change_protection'), {
        'delete': true,
        'rebuild': true,
      });
      await settleAction(tester);
    });

    testWidgets('CMP-047 CMP-087 rename and labels in the edit sheet', (
      tester,
    ) async {
      final cloud = await openServer(tester);
      await more(tester, 'Edit');
      await tester.enterText(find.byKey(const ValueKey('name')), 'web-2');
      await tester.enterText(find.byKey(const ValueKey('labels')), 'a=b, c');
      await tester.pumpAndSettle();
      await tap(tester, 'Save');
      expect(cloud.body('PUT /servers/1'), {
        'name': 'web-2',
        'labels': {'a': 'b', 'c': ''},
      });
      expect(find.text('web-2'), findsOneWidget);
      await settleAction(tester);
    });

    testWidgets('CMP-042 reverse DNS, empty resets', (tester) async {
      final cloud = await openServer(tester);
      await more(tester, 'Reverse DNS');
      await tester.enterText(find.byKey(const ValueKey('ptr')), '');
      await tester.pumpAndSettle();
      await tap(tester, 'Save');
      expect(cloud.body('POST /servers/1/actions/change_dns_ptr'), {
        'ip': '203.0.113.1',
        'dns_ptr': null,
      });
      await settleAction(tester);
    });

    testWidgets('CMP-048 CMP-049 delete sits in the danger zone and needs '
        'the name', (tester) async {
      final cloud = await openServer(tester);
      await tap(tester, 'Delete');
      expect(find.textContaining('Attached volumes are kept'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('confirm-name')),
        'web-1',
      );
      await tester.pumpAndSettle();
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /servers/1'));
      expect(find.text('db-1'), findsOneWidget);
      await settleAction(tester);
    });

    testWidgets('CMP-005 CMP-006 power actions live only in the detail '
        '(BUG-017)', (tester) async {
      await pumpFalco(tester, FakeCloud());
      expect(find.text('Reboot'), findsNothing);
      await tester.tap(find.text('web-1'));
      await tester.pumpAndSettle();
      expect(find.text('Reboot'), findsOneWidget);
    });

    testWidgets('CMP-027 CMP-028 metrics per period with min, max, average', (
      tester,
    ) async {
      final cloud = await openServer(tester);
      expect(
        find.text('CPU: min 2.0 % · max 6.0 % · avg 4.0 %'),
        findsOneWidget,
      );
      await tester.tap(find.text('7d').first);
      await tester.pumpAndSettle();
      expect(
        cloud.calls.where((c) => c == 'GET /servers/1/metrics').length,
        greaterThan(3),
      );
      await settleAction(tester);
    });
  });

  test('CMP-029 series statistics', () {
    final t = DateTime(2026);
    expect(seriesStats([]), isNull);
    expect(seriesStats([(t, 1), (t, 5), (t, 3)]), (
      min: 1.0,
      max: 5.0,
      avg: 3.0,
    ));
  });
}
