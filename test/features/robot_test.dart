// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:async';

import 'package:falco/api/robot/robot_client.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/scope/scope_repository.dart' show accountsProvider;
import 'package:falco/core/secure/secret_store.dart';
import 'package:falco/features/robot/robot.dart';
import 'package:falco/features/robot/robot_ui.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';
import '../fake_robot.dart';
import '../helpers.dart' show testApp;
import '../robot_steps.dart';
import '../steps.dart';

/// Form fields of the last Robot request to `METHOD /path`.
List<(String, String)> sentForm(FakeCloud c, String call) => FakeRobot.form(
  c.adapter.requests.lastWhere(
    (r) =>
        r.uri.host == 'robot-ws.your-server.de' &&
        '${r.method} ${Uri.decodeFull(r.uri.path)}' == call,
  ),
);

void main() {
  group('area', () {
    testWidgets('ROB-001 the Robot overview lists its types', (tester) async {
      await openRobot(tester);
      for (final tab in [
        'Servers',
        'Failover',
        'vSwitches',
        'Reverse DNS',
        'SSH keys',
        'IPs',
        'Subnets',
        'Firewall templates',
      ]) {
        expect(find.text(tab), findsOneWidget);
      }
    });

    testWidgets('ROB-002 a section the login may not use says how to '
        'enable it', (tester) async {
      final cloud = FakeCloud();
      cloud.robot.failures['failover'] = FakeRobot.forbidden();
      await openRobot(tester, tab: 'Failover', cloud: cloud);
      expect(
        find.text(
          'Enable this section for the webservice user in Hetzner Robot.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('ROB-003 throttling is reported as throttling', (tester) async {
      final cloud = FakeCloud();
      cloud.robot.failures['server'] = FakeRobot.rateLimited();
      await openRobot(tester, tab: 'Servers', cloud: cloud);
      expect(
        find.text('Too many requests. Wait a moment and try again.'),
        findsOneWidget,
      );
    });

    testWidgets('a project scope without Robot access offers to add it', (
      tester,
    ) async {
      setSurface(tester);
      await pumpFalco(tester, FakeCloud());
      await tester.tap(find.text('Robot').last);
      await tester.pumpAndSettle();
      expect(find.text('This account has no Robot access.'), findsOneWidget);
      expect(find.text('Add Robot access'), findsOneWidget);
    });

    testWidgets('Robot and Cloud areas switch scope', (tester) async {
      await openRobot(tester);
      expect(find.text('server1'), findsOneWidget);
      await tester.tap(find.text('Compute'));
      await tester.pumpAndSettle();
      expect(find.text('web-1'), findsOneWidget);
    });
  });

  group('servers', () {
    testWidgets('ROB-004 name or number, cancelled badge, IPs, data '
        'center, paid until', (tester) async {
      await openRobot(tester);
      expect(find.text('server1'), findsOneWidget);
      expect(find.text('#421'), findsOneWidget);
      expect(find.text('cancelled'), findsOneWidget);
      expect(
        find.textContaining('123.123.123.123 · 2a01:4f8:111:141:: · FSN1-DC14'),
        findsOneWidget,
      );
      expect(find.textContaining('paid until 2030-01-31'), findsNWidgets(2));
    });

    testWidgets('ROB-005 ROB-036 reset and Wake on LAN from the row', (
      tester,
    ) async {
      final cloud = await openRobot(tester);
      await tester.longPress(find.text('#421'));
      await tester.pumpAndSettle();
      // Types from GET /reset: 421 offers no software reset, and
      // GET /wol/421 no Wake on LAN (ROB-043).
      expect(find.text('Software reset (Ctrl+Alt+Del)'), findsNothing);
      expect(find.text('Wake on LAN'), findsNothing);
      await tap(tester, 'Hardware reset');
      await confirm(tester, 'Reset');
      expect(cloud.calls, contains('GET /reset'));
      expect(sentForm(cloud, 'POST /reset/421'), [('type', 'hw')]);
      expect(find.text('Action completed'), findsOneWidget);
      await tester.longPress(find.text('server1'));
      await tester.pumpAndSettle();
      await tap(tester, 'Wake on LAN');
      await confirm(tester, 'Wake on LAN');
      expect(cloud.calls, contains('POST /wol/321'));
    });
  });

  group('server detail', () {
    testWidgets('ROB-006 ROB-007 ROB-008 ROB-037 overview, network, '
        'traffic, boot', (tester) async {
      final cloud = await openRobotServer(tester);
      expect(find.text('AX41-NVMe'), findsOneWidget);
      expect(find.text('FSN1-DC14'), findsOneWidget);
      expect(find.text('2030-01-31'), findsWidgets);
      expect(find.text('2a01:4f8:111:141::'), findsOneWidget);
      expect(find.text('server1.example.com'), findsOneWidget);
      expect(find.text('12.50 GB'), findsOneWidget);
      expect(find.text('15.75 GB'), findsOneWidget);
      expect(find.text('No boot configuration active.'), findsOneWidget);
      final traffic = sentForm(cloud, 'POST /traffic');
      expect(traffic.first, ('type', 'month'));
      expect(traffic.last, ('ip[]', '123.123.123.123'));
    });

    testWidgets('ROB-009 ROB-035 BUG-012 reset with the offered types', (
      tester,
    ) async {
      final cloud = await openRobotServer(tester);
      await tile(tester, 'Reset');
      expect(cloud.calls, contains('GET /reset/321'));
      expect(find.text('Power button'), findsNothing);
      await tap(tester, 'Software reset (Ctrl+Alt+Del)');
      await confirm(tester, 'Reset');
      expect(sentForm(cloud, 'POST /reset/321'), [('type', 'sw')]);
    });

    testWidgets('ROB-010 ROB-043 Wake on LAN only where available', (
      tester,
    ) async {
      final cloud = await openRobotServer(tester);
      await tile(tester, 'Wake on LAN');
      await confirm(tester, 'Wake on LAN');
      expect(cloud.calls, contains('POST /wol/321'));
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tap(tester, '#421');
      expect(cloud.calls, contains('GET /wol/421'));
      await tile(tester, 'Wake on LAN');
      expect(cloud.calls, isNot(contains('POST /wol/421')));
    });

    testWidgets('ROB-011 ROB-012 rescue with a Robot key, password once, '
        'then off', (tester) async {
      final cloud = await openRobotServer(tester);
      await tile(tester, 'Enable rescue');
      expect(cloud.calls, contains('GET /boot/321/rescue'));
      expect(cloud.calls, contains('GET /key'));
      await tap(tester, 'laptop');
      await tap(tester, 'Save');
      expect(sentForm(cloud, 'POST /boot/321/rescue'), [
        ('os', 'linux'),
        ('arch', '64'),
        ('authorized_key[]', '15:28:b0:03:95:f0:77:b3:10:56:15:6b:77:22:a5:bb'),
      ]);
      expect(find.text('Root password'), findsOneWidget);
      await tap(tester, 'Close');
      expect(find.text('Rescue system'), findsOneWidget);
      await tile(tester, 'Disable rescue');
      await confirm(tester, 'Deactivate');
      expect(cloud.calls, contains('DELETE /boot/321/rescue'));
      expect(find.text('No boot configuration active.'), findsOneWidget);
    });

    testWidgets('ROB-038 last rescue activation with its password', (
      tester,
    ) async {
      final cloud = FakeCloud();
      cloud.robot.last[(321, 'rescue')] = {
        'os': 'linux',
        'active': false,
        'password': 'Fake-Last-Pass',
      };
      await openRobot(tester, cloud: cloud);
      await tap(tester, 'server1');
      await more(tester, 'Last rescue activation');
      expect(cloud.calls, contains('GET /boot/321/rescue/last'));
      expect(find.text('Root password'), findsOneWidget);
      expect(find.text('linux'), findsOneWidget);
    });

    testWidgets('ROB-039 Linux installation needs the typed name, then '
        'shows the password', (tester) async {
      final cloud = await openRobotServer(tester);
      await more(tester, 'Linux installation');
      await tap(tester, 'Save');
      await typeName(tester, 'server1');
      await confirm(tester, 'Activate');
      expect(sentForm(cloud, 'POST /boot/321/linux'), [
        ('dist', 'Debian 12 base'),
        ('lang', 'en'),
        ('arch', '64'),
      ]);
      expect(find.text('Root password'), findsOneWidget);
      await tap(tester, 'Close');
      await more(tester, 'Linux installation');
      await confirm(tester, 'Deactivate');
      expect(cloud.calls, contains('DELETE /boot/321/linux'));
    });

    testWidgets('ROB-040 ROB-041 VNC and Windows installation', (tester) async {
      final cloud = await openRobotServer(tester);
      await more(tester, 'VNC installation');
      await tap(tester, 'Save');
      await typeName(tester, 'server1');
      await confirm(tester, 'Activate');
      expect(cloud.calls, contains('POST /boot/321/vnc'));
      await tap(tester, 'Close');
      await more(tester, 'Windows installation');
      expect(find.text('Windows Server 2022 Standard Edition'), findsWidgets);
      await tap(tester, 'Save');
      await typeName(tester, 'server1');
      await confirm(tester, 'Activate');
      expect(sentForm(cloud, 'POST /boot/321/windows'), [
        ('os', 'Windows Server 2022 Standard Edition'),
        ('lang', 'en'),
      ]);
    });

    testWidgets('ROB-042 rename', (tester) async {
      final cloud = await openRobotServer(tester);
      await tile(tester, 'Edit');
      await enter(tester, 'name', 'web 1');
      await tap(tester, 'Save');
      expect(sentForm(cloud, 'POST /server/321'), [('server_name', 'web 1')]);
      expect(find.text('web 1'), findsWidgets);
    });

    testWidgets('ROB-013 ROB-045 ROB-046 reverse DNS of a server IP', (
      tester,
    ) async {
      final cloud = await openRobotServer(tester);
      await tap(tester, 'server1.example.com');
      expect(cloud.calls, contains('GET /rdns/123.123.123.123'));
      await enter(tester, 'ptr', 'mail.example.com');
      await tap(tester, 'Save');
      expect(sentForm(cloud, 'POST /rdns/123.123.123.123'), [
        ('ptr', 'mail.example.com'),
      ]);
      // Empty resets to the default by deleting the entry.
      await tap(tester, 'mail.example.com');
      await enter(tester, 'ptr', '');
      await tap(tester, 'Save');
      expect(cloud.calls, contains('DELETE /rdns/123.123.123.123'));
    });

    testWidgets('ROB-014 BUG-013 cancel with reason and reservation, '
        'typed name', (tester) async {
      final cloud = await openRobotServer(tester);
      await tap(tester, 'Cancel contract');
      await tap(tester, 'Immediately');
      await chipOf(tester, 'reason', 'Server too expensive');
      await chipOf(tester, 'reserve', 'Yes');
      await tap(tester, 'Save');
      await typeName(tester, 'server1');
      await confirm(tester, 'Cancel contract');
      expect(sentForm(cloud, 'POST /server/321/cancellation'), [
        ('cancellation_date', 'now'),
        ('cancellation_reason', 'Server too expensive'),
        ('reserve_location', 'true'),
      ]);
      expect(find.text('Withdraw cancellation'), findsOneWidget);
    });

    testWidgets('BUG-013 the date picker starts at the earliest date', (
      tester,
    ) async {
      final cloud = await openRobotServer(tester);
      await tap(tester, 'Cancel contract');
      await tap(tester, 'At a date (from 2030-01-31)');
      await tap(tester, 'OK');
      await tap(tester, 'Save');
      await typeName(tester, 'server1');
      await confirm(tester, 'Cancel contract');
      expect(sentForm(cloud, 'POST /server/321/cancellation').first, (
        'cancellation_date',
        '2030-01-31',
      ));
    });

    testWidgets('ROB-015 withdraw a cancellation', (tester) async {
      final cloud = await openRobotServer(tester, '#421');
      expect(find.text('cancelled for 2030-01-31'), findsWidgets);
      await tap(tester, 'Withdraw cancellation');
      await confirm(tester, 'Withdraw cancellation');
      expect(cloud.calls, contains('DELETE /server/421/cancellation'));
    });

    testWidgets('ROB-016 failures show as "Action failed"', (tester) async {
      final cloud = await openRobotServer(tester);
      cloud.robot.failures['wol'] = (
        500,
        {
          'error': {'status': 500, 'code': 'WOL_FAILED', 'message': ''},
        },
      );
      await tile(tester, 'Wake on LAN');
      await confirm(tester, 'Wake on LAN');
      expect(find.textContaining('Action failed: '), findsOneWidget);
    });

    testWidgets('Robot actions appear in the activity', (tester) async {
      final cloud = await openRobotServer(tester);
      cloud.robot.failures['wol'] = (500, null);
      await tile(tester, 'Wake on LAN');
      await confirm(tester, 'Wake on LAN');
      await tile(tester, 'Reset');
      await tap(tester, 'Hardware reset');
      await confirm(tester, 'Reset');
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Activity'));
      await tester.pumpAndSettle();
      expect(find.text('Reset'), findsOneWidget);
      expect(find.text('Wake on LAN'), findsOneWidget);
      expect(find.textContaining('Server #321'), findsNWidgets(2));
      expect(find.text('failed'), findsOneWidget);
    });
  });

  group('failover', () {
    testWidgets('ROB-017 IP and where it is active', (tester) async {
      await openRobot(tester, tab: 'Failover');
      expect(find.text('123.123.123.200'), findsOneWidget);
      expect(find.text('Active on server1'), findsOneWidget);
    });

    testWidgets('ROB-018 ROB-044 route to another server only', (tester) async {
      final cloud = await openRobot(tester, tab: 'Failover');
      await tap(tester, '123.123.123.200');
      await tile(tester, 'Route');
      expect(cloud.calls, contains('GET /failover/123.123.123.200'));
      // The current target is not offered: server1 only on the page.
      expect(find.text('server1'), findsNWidgets(2));
      await tap(tester, '#421');
      await confirm(tester, 'Route');
      expect(sentForm(cloud, 'POST /failover/123.123.123.200'), [
        ('active_server_ip', '123.123.123.124'),
      ]);
      expect(find.textContaining('Active on #421'), findsWidgets);
    });

    testWidgets('ROB-019 unroute with confirmation', (tester) async {
      final cloud = await openRobot(tester, tab: 'Failover');
      await tap(tester, '123.123.123.200');
      await tile(tester, 'Unroute');
      expect(find.textContaining('services on it become'), findsOneWidget);
      await confirm(tester, 'Unroute');
      expect(cloud.calls, contains('DELETE /failover/123.123.123.200'));
      expect(find.textContaining('Not routed'), findsWidgets);
    });
  });

  group('reverse DNS', () {
    testWidgets('ROB-020 IP and PTR', (tester) async {
      await openRobot(tester, tab: 'Reverse DNS');
      expect(find.text('server1.example.com'), findsOneWidget);
      expect(find.text('123.123.123.123'), findsOneWidget);
    });

    testWidgets('ROB-021 ROB-046 add requires IP and PTR, created with PUT', (
      tester,
    ) async {
      final cloud = await openRobot(tester, tab: 'Reverse DNS');
      await tap(tester, 'Add reverse DNS');
      await enter(tester, 'ip', '123.123.123.124');
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next'))
            .onPressed,
        isNull,
      );
      await enter(tester, 'ptr', 'b.example.com');
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      expect(sentForm(cloud, 'PUT /rdns/123.123.123.124'), [
        ('ptr', 'b.example.com'),
      ]);
      expect(find.text('b.example.com'), findsOneWidget);
    });

    testWidgets('ROB-022 edit keeps the IP, ROB-023 delete confirms', (
      tester,
    ) async {
      final cloud = await openRobot(tester, tab: 'Reverse DNS');
      await tap(tester, 'server1.example.com');
      expect(find.byKey(const ValueKey('ip')), findsNothing);
      await enter(tester, 'ptr', 'c.example.com');
      await tap(tester, 'Save');
      expect(cloud.calls, contains('POST /rdns/123.123.123.123'));
      await tester.tap(find.byTooltip('Delete'));
      await tester.pumpAndSettle();
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /rdns/123.123.123.123'));
      expect(find.text('No reverse DNS entries.'), findsOneWidget);
    });
  });

  group('vSwitch', () {
    testWidgets('ROB-024 name, VLAN, id', (tester) async {
      await openRobot(tester, tab: 'vSwitches');
      expect(find.text('backend'), findsOneWidget);
      expect(find.text('VLAN 4000 · #1234'), findsOneWidget);
    });

    testWidgets('ROB-025 create with VLAN 4000 to 4091', (tester) async {
      final cloud = await openRobot(tester, tab: 'vSwitches');
      await tap(tester, 'Create vSwitch');
      await enter(tester, 'name', 'storage');
      await enter(tester, 'vlan', '4092');
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next'))
            .onPressed,
        isNull,
      );
      await enter(tester, 'vlan', '4091');
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      expect(sentForm(cloud, 'POST /vswitch'), [
        ('name', 'storage'),
        ('vlan', '4091'),
      ]);
      expect(find.text('storage'), findsOneWidget);
    });

    testWidgets('ROB-026 ROB-027 ROB-028 ROB-029 detail, add and remove '
        'servers', (tester) async {
      final cloud = await openRobot(tester, tab: 'vSwitches');
      await tap(tester, 'backend');
      expect(find.text('server1'), findsOneWidget);
      expect(find.textContaining('ready'), findsOneWidget);
      await tile(tester, 'Add server');
      await tap(tester, '#421');
      expect(sentForm(cloud, 'POST /vswitch/1234/server'), [
        ('server[]', '421'),
      ]);
      await tester.tap(find.byTooltip('Remove').first);
      await tester.pumpAndSettle();
      await confirm(tester, 'Remove');
      expect(sentForm(cloud, 'DELETE /vswitch/1234/server'), [
        ('server[]', '321'),
      ]);
    });

    testWidgets('ROB-030 edit, ROB-031 cancel with typed name', (tester) async {
      final cloud = await openRobot(tester, tab: 'vSwitches');
      await tap(tester, 'backend');
      await tile(tester, 'Edit');
      await enter(tester, 'vlan', '4010');
      await tap(tester, 'Save');
      expect(sentForm(cloud, 'POST /vswitch/1234'), [
        ('name', 'backend'),
        ('vlan', '4010'),
      ]);
      await tap(tester, 'Cancel contract');
      await tap(tester, 'Immediately');
      await typeName(tester, 'backend');
      await confirm(tester, 'Cancel contract');
      expect(sentForm(cloud, 'DELETE /vswitch/1234'), [
        ('cancellation_date', 'now'),
      ]);
    });
  });

  group('SSH keys', () {
    testWidgets('ROB-032 name, fingerprint, type, bits', (tester) async {
      await openRobot(tester, tab: 'SSH keys');
      expect(find.text('laptop'), findsOneWidget);
      expect(
        find.text(
          '15:28:b0:03:95:f0:77:b3:10:56:15:6b:77:22:a5:bb · ED25519 · 256 bit',
        ),
        findsOneWidget,
      );
    });

    testWidgets('ROB-033 add from a file, checked like Cloud keys', (
      tester,
    ) async {
      final cloud = await openRobot(tester, tab: 'SSH keys');
      await tap(tester, 'Add SSH key');
      await enter(tester, 'name', 'ci');
      await enter(tester, 'key', '-----BEGIN OPENSSH PRIVATE KEY-----');
      expect(find.textContaining('private key'), findsOneWidget);
      cloud.files.picked = (text: '$_ciKey\n', tooLarge: false);
      await tap(tester, 'From file');
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      expect(sentForm(cloud, 'POST /key'), [('name', 'ci'), ('data', _ciKey)]);
      expect(find.text('ci'), findsOneWidget);
    });

    testWidgets('ROB-061 a generated key pair: public key added, private '
        'key handed over once', (tester) async {
      final cloud = await openRobot(tester, tab: 'SSH keys');
      await tap(tester, 'Add SSH key');
      await enter(tester, 'name', 'ci');
      await tap(tester, 'Generate key pair');
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      final sent = Map.fromEntries([
        for (final (k, v) in sentForm(cloud, 'POST /key')) MapEntry(k, v),
      ]);
      expect(sent['data'], startsWith('ssh-ed25519 '));
      expect(find.text('Private key'), findsWidgets);
      await tap(tester, 'Save to file');
      expect(
        cloud.files.saved['id_ed25519.pem'],
        startsWith('-----BEGIN OPENSSH PRIVATE KEY-----'),
      );
      await tap(tester, 'Close');
    });

    testWidgets('ROB-047 ROB-048 ROB-034 detail, rename, delete', (
      tester,
    ) async {
      final cloud = await openRobot(tester, tab: 'SSH keys');
      await tap(tester, 'laptop');
      const fp = '15:28:b0:03:95:f0:77:b3:10:56:15:6b:77:22:a5:bb';
      expect(cloud.calls, contains('GET /key/$fp'));
      await tile(tester, 'Edit');
      await enter(tester, 'name', 'desk');
      await tap(tester, 'Save');
      expect(sentForm(cloud, 'POST /key/$fp'), [('name', 'desk')]);
      await tap(tester, 'Delete');
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /key/$fp'));
      expect(find.text('No SSH keys in Robot yet.'), findsOneWidget);
    });
  });

  group('IPs and subnets', () {
    testWidgets('ROB-049 IPs with their server', (tester) async {
      await openRobot(tester, tab: 'IPs');
      expect(find.text('123.123.123.124'), findsOneWidget);
      expect(find.textContaining('#421 · 123.123.123.1'), findsOneWidget);
    });

    testWidgets('ROB-050 ROB-051 ROB-052 warnings, MAC, cancellation of '
        'an IP', (tester) async {
      final cloud = await openRobot(tester, tab: 'IPs');
      await tap(tester, '123.123.123.123');
      expect(find.text('123.123.123.63'), findsOneWidget);
      await tile(tester, 'Traffic warnings');
      await chipOf(tester, 'on', 'Yes');
      await enter(tester, 'daily', '900');
      await tap(tester, 'Save');
      expect(sentForm(cloud, 'POST /ip/123.123.123.123'), [
        ('traffic_warnings', 'true'),
        ('traffic_hourly', '50'),
        ('traffic_daily', '900'),
        ('traffic_monthly', '8'),
      ]);
      await tile(tester, 'Separate MAC');
      await confirm(tester, 'Separate MAC');
      expect(cloud.calls, contains('PUT /ip/123.123.123.123/mac'));
      expect(find.text('00:50:56:00:fa:ce'), findsOneWidget);
      await tile(tester, 'Remove MAC');
      await confirm(tester, 'Remove MAC');
      expect(cloud.calls, contains('DELETE /ip/123.123.123.123/mac'));
      await tap(tester, 'Cancel contract');
      await tap(tester, 'Immediately');
      await typeName(tester, '123.123.123.123');
      await confirm(tester, 'Cancel contract');
      expect(sentForm(cloud, 'POST /ip/123.123.123.123/cancellation'), [
        ('cancellation_date', 'now'),
      ]);
      await tap(tester, 'Withdraw cancellation');
      await confirm(tester, 'Withdraw cancellation');
      expect(cloud.calls, contains('DELETE /ip/123.123.123.123/cancellation'));
    });

    testWidgets('ROB-053 ROB-054 ROB-055 ROB-056 subnet: list, warnings, '
        'MAC not possible, cancellation', (tester) async {
      final cloud = await openRobot(tester, tab: 'Subnets');
      expect(find.text('2a01:4f8:111:141::/64'), findsOneWidget);
      await tap(tester, '2a01:4f8:111:141::/64');
      expect(cloud.calls, contains('GET /subnet/2a01:4f8:111:141::/mac'));
      expect(find.text('not possible'), findsOneWidget);
      await tile(tester, 'Traffic warnings');
      await tap(tester, 'Save');
      expect(cloud.calls, contains('POST /subnet/2a01:4f8:111:141::'));
      await tap(tester, 'Cancel contract');
      await tap(tester, 'Immediately');
      await typeName(tester, '2a01:4f8:111:141::');
      await confirm(tester, 'Cancel contract');
      expect(
        cloud.calls,
        contains('POST /subnet/2a01:4f8:111:141::/cancellation'),
      );
    });

    testWidgets('ROB-059 traffic of a day, month or year', (tester) async {
      final cloud = await openRobot(tester, tab: 'IPs');
      await tap(tester, '123.123.123.123');
      await tile(tester, 'Traffic');
      expect(find.text('15.75 GB'), findsOneWidget);
      await tap(tester, 'Year');
      final year = sentForm(cloud, 'POST /traffic');
      expect(year.first, ('type', 'year'));
      expect(year[1].$2, matches(RegExp(r'^\d{4}-01$')));
      await tap(tester, 'Day');
      final day = sentForm(cloud, 'POST /traffic');
      expect(day[1].$2, matches(RegExp(r'^\d{4}-\d\d-\d\dT00$')));
      expect(day.last, ('ip[]', '123.123.123.123'));
    });
  });

  group('firewall', () {
    testWidgets('ROB-057 rules, IPv6 filter, Hetzner services, apply, '
        'template, clear', (tester) async {
      final cloud = await openRobotServer(tester);
      await more(tester, 'Firewall');
      expect(find.text('ssh'), findsOneWidget);
      expect(find.text('Allow all'), findsOneWidget);
      await tap(tester, 'Filter IPv6');
      await tap(tester, 'Add rule');
      await enter(tester, 'name', 'web');
      await enter(tester, 'dst_port', '443');
      await chipOf(tester, 'protocol', 'tcp');
      await tap(tester, 'Save');
      await tile(tester, 'Apply');
      final sent = sentForm(cloud, 'POST /firewall/321');
      expect(sent.take(3), [
        ('status', 'active'),
        ('filter_ipv6', 'true'),
        ('whitelist_hos', 'true'),
      ]);
      expect(sent, contains(('rules[input][1][dst_port]', '443')));
      expect(sent, contains(('rules[input][1][protocol]', 'tcp')));
      int applied() =>
          cloud.calls.where((c) => c == 'POST /firewall/321').length;
      final before = applied();
      await more(tester, 'Apply template');
      await tap(tester, 'web');
      expect(find.text('Apply template web?'), findsOneWidget);
      expect(applied(), before);
      await typeName(tester, 'web');
      await confirm(tester, 'Apply template');
      // The template's IPv6 filter, not the server's.
      expect(sentForm(cloud, 'POST /firewall/321'), [
        ('status', 'active'),
        ('filter_ipv6', 'false'),
        ('template_id', '1'),
      ]);
      await tap(tester, 'Clear firewall');
      await confirm(tester, 'Clear firewall');
      expect(cloud.calls, contains('DELETE /firewall/321'));
    });

    testWidgets('ROB-058 templates: create, edit rules, delete', (
      tester,
    ) async {
      final cloud = await openRobot(tester, tab: 'Firewall templates');
      expect(find.textContaining('Default template'), findsOneWidget);
      await tap(tester, 'Create template');
      await enter(tester, 'name', 'db');
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      expect(sentForm(cloud, 'POST /firewall/template'), [
        ('name', 'db'),
        ('filter_ipv6', 'false'),
        ('whitelist_hos', 'true'),
        ('is_default', 'false'),
      ]);
      await tap(tester, 'db');
      await tap(tester, 'Add rule');
      await enter(tester, 'dst_port', '5432');
      await tap(tester, 'Save');
      await tile(tester, 'Save');
      final saved = sentForm(cloud, 'POST /firewall/template/5000');
      expect(saved, contains(('rules[input][0][dst_port]', '5432')));
      // An unedited name is not sent: it may be older than Robot's.
      expect(saved.map((e) => e.$1), isNot(contains('name')));
      await tap(tester, 'Delete');
      await typeName(tester, 'db');
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /firewall/template/5000'));
      // The detail is not reloaded for the deleted template.
      expect(
        cloud.calls
            .skipWhile((c) => c != 'DELETE /firewall/template/5000')
            .where((c) => c == 'GET /firewall/template/5000'),
        isEmpty,
      );
    });

    testWidgets('ROB-057 editing a rule keeps TCP flags and fields the '
        'form does not show', (tester) async {
      (String, FirewallRule)? edited;
      const rule = {
        'name': 'syn',
        'protocol': 'tcp',
        'dst_port': '22',
        'tcp_flags': 'syn',
        'action': 'accept',
        'packet_size': '64',
      };
      await tester.pumpWidget(
        testApp(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async =>
                  edited = await editRule(context, rule: rule),
              child: const Text('edit'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('edit'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('tcp_flags')), findsOneWidget);
      await enter(tester, 'dst_port', '2222');
      await tap(tester, 'Save');
      expect(edited?.$2, {...rule, 'dst_port': '2222'});
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(ruleSummary(rule, l10n), endsWith(' syn'));
    });
  });

  group('session safety', () {
    testWidgets('a Robot save finishes after its page is gone', (tester) async {
      final c = await fakeContainer(FakeCloud(), accounts: const [acmeRobot]);
      final done = Completer<void>();
      late Future<void> pending;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c,
          child: testApp(
            Consumer(
              builder: (context, ref, _) => TextButton(
                onPressed: () => pending = saveRobot(
                  ref,
                  'a1',
                  (_) => done.future,
                  command: RobotCommand.rdns,
                  refresh: [robotRdnsProvider('a1')],
                ),
                child: const Text('save'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('save'));
      await tester.pumpWidget(
        UncontrolledProviderScope(container: c, child: const SizedBox()),
      );
      done.complete();
      await expectLater(pending, completes);
      expect(c.read(robotActivityProvider('a1')).single.command, 'robot_rdns');
    });

    test('a refused Robot login is not sent again until it changes', () async {
      final cloud = FakeCloud();
      final c = await fakeContainer(cloud, accounts: const [acmeRobot]);
      final secrets = c.read(secretStoreProvider);
      await secrets.setRobot(
        'a1',
        const RobotCredentials(user: fakeRobotUser, password: 'wrong'),
      );
      int sent() => cloud.adapter.requests
          .where((r) => r.uri.host == 'robot-ws.your-server.de')
          .length;
      final api = c.read(robotApiProvider('a1'));
      final refused = throwsA(
        predicate<Object>((e) => toFalcoError(e) is Unauthorized),
      );
      await expectLater(api.servers(), refused);
      await expectLater(api.servers(), refused);
      await expectLater(api.failovers(), refused);
      expect(sent(), 1);
      await secrets.setRobot(
        'a1',
        const RobotCredentials(
          user: fakeRobotUser,
          password: fakeRobotPassword,
        ),
      );
      await api.servers();
      expect(sent(), 2);
    });

    test(
      'a refusal that raced the first success blocks only its path',
      () async {
        final cloud = FakeCloud();
        final c = await fakeContainer(cloud, accounts: const [acmeRobot]);
        cloud.robot.failures['failover'] = (
          401,
          {
            'error': {'status': 401, 'code': 'UNAUTHORIZED', 'message': ''},
          },
        );
        int sent(String path) => cloud.adapter.requests
            .where((r) => r.uri.host == 'robot-ws.your-server.de')
            .where((r) => r.uri.path == path)
            .length;
        final api = c.read(robotApiProvider('a1'));
        final refused = throwsA(isA<Unauthorized>());
        final failovers = api.failovers();
        final servers = api.servers();
        await expectLater(failovers, refused);
        await servers;
        await api.servers();
        await expectLater(api.failovers(), refused);
        // One of them is the probe that found the login valid.
        expect(sent('/server'), 3);
        expect(sent('/failover'), 1);
      },
    );

    test('after a success a refused path blocks only itself until the '
        'login changes', () async {
      final cloud = FakeCloud();
      final c = await fakeContainer(cloud, accounts: const [acmeRobot]);
      cloud.robot.failures['failover'] = (
        401,
        {
          'error': {'status': 401, 'code': 'UNAUTHORIZED', 'message': ''},
        },
      );
      int sent(String path) => cloud.adapter.requests
          .where((r) => r.uri.host == 'robot-ws.your-server.de')
          .where((r) => r.uri.path == path)
          .length;
      final api = c.read(robotApiProvider('a1'));
      final refused = throwsA(isA<Unauthorized>());
      await api.servers();
      await expectLater(api.failovers(), refused);
      await expectLater(api.failovers(), refused);
      await api.servers();
      await expectLater(api.failovers(), refused);
      expect(sent('/failover'), 1);
      // One of them is the probe that found the login valid.
      expect(sent('/server'), 3);
      // An account reload with the same login keeps the client.
      c.invalidate(accountsProvider);
      await c.read(accountsProvider.future);
      await pumpEventQueue();
      expect(c.read(robotApiProvider('a1')), same(api));
      await c
          .read(secretStoreProvider)
          .setRobot(
            'a1',
            const RobotCredentials(user: 'other', password: fakeRobotPassword),
          );
      c.invalidate(accountsProvider);
      await c.read(accountsProvider.future);
      await pumpEventQueue();
      expect(c.read(robotApiProvider('a1')), isNot(same(api)));
    });

    test('a refusal is a wrong login only when GET /server refuses it '
        'too, before and after a success', () async {
      const unauthorized = (
        401,
        {
          'error': {'status': 401, 'code': 'UNAUTHORIZED', 'message': ''},
        },
      );
      final cloud = FakeCloud();
      final c = await fakeContainer(cloud, accounts: const [acmeRobot]);
      int sent(String path) => cloud.adapter.requests
          .where((r) => r.uri.host == 'robot-ws.your-server.de')
          .where((r) => r.uri.path == path)
          .length;
      final api = c.read(robotApiProvider('a1'));
      final refused = throwsA(isA<Unauthorized>());
      // Before any success: a refused section does not block the login.
      cloud.robot.failures['failover'] = unauthorized;
      await expectLater(api.failovers(), refused);
      await api.servers();
      expect(sent('/server'), 2);
      // After a success: the password changed outside the app.
      cloud.robot.failures['vswitch'] = unauthorized;
      cloud.robot.failures['server'] = unauthorized;
      final login = throwsA(same(robotLoginRejected));
      await expectLater(api.vswitches(), login);
      await expectLater(api.servers(), login);
      await expectLater(api.keys(), login);
      expect(sent('/server'), 3);
      expect(sent('/key'), 0);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        robotErrorText(robotLoginRejected, l10n),
        'Robot rejected the login. Update it under Accounts.',
      );
      expect(
        robotErrorText(const Unauthorized(), l10n),
        l10n.robotSectionDisabled,
      );
    });

    test('a login Robot has not answered yet is sent once; an open '
        'GET /server is the probe', () async {
      const unauthorized = (
        401,
        {
          'error': {'status': 401, 'code': 'UNAUTHORIZED', 'message': ''},
        },
      );
      final cloud = FakeCloud();
      final c = await fakeContainer(cloud, accounts: const [acmeRobot]);
      final secrets = c.read(secretStoreProvider);
      await secrets.setRobot(
        'a1',
        const RobotCredentials(user: fakeRobotUser, password: 'wrong'),
      );
      int sent([String? path]) => cloud.adapter.requests
          .where((r) => r.uri.host == 'robot-ws.your-server.de')
          .where((r) => path == null || r.uri.path == path)
          .length;
      var api = c.read(robotApiProvider('a1'));
      final login = throwsA(same(robotLoginRejected));
      await Future.wait([
        expectLater(api.servers(), login),
        expectLater(api.failovers(), login),
        expectLater(api.keys(), login),
        expectLater(api.vswitches(), login),
      ]);
      expect(sent(), 1);
      // A known login: a refusal while GET /server is open waits for it.
      await secrets.setRobot(
        'a1',
        const RobotCredentials(
          user: fakeRobotUser,
          password: fakeRobotPassword,
        ),
      );
      c.invalidate(accountsProvider);
      await c.read(accountsProvider.future);
      await pumpEventQueue();
      api = c.read(robotApiProvider('a1'));
      await api.keys();
      cloud.robot.failures['vswitch'] = unauthorized;
      cloud.robot.failures['server'] = unauthorized;
      final before = sent('/server');
      await Future.wait([
        expectLater(api.vswitches(), login),
        expectLater(api.servers(), login),
      ]);
      expect(sent('/server'), before + 1);
    });

    test('a template without a name fails; the loaded list is used', () async {
      final cloud = FakeCloud();
      final c = await fakeContainer(cloud, accounts: const [acmeRobot]);
      int lists() =>
          cloud.calls.where((e) => e == 'GET /firewall/template').length;
      final sub = c.listen(robotTemplatesProvider('a1'), (_, _) {});
      await c.read(robotTemplatesProvider('a1').future);
      expect((await c.read(robotTemplateProvider('a1', 1).future)).name, 'web');
      expect(lists(), 1);
      sub.close();
      cloud.robot.templates.first['name'] = '';
      c
        ..invalidate(robotTemplatesProvider('a1'))
        ..invalidate(robotTemplateProvider('a1', 1));
      await expectLater(
        c.read(robotTemplateProvider('a1', 1).future),
        throwsA(isA<NotFound>()),
      );
    });
  });
}

/// Picks option [label] of form field [key].
Future<void> chipOf(WidgetTester tester, String key, String label) async {
  final f = find.descendant(
    of: find.byKey(ValueKey(key)),
    matching: find.text(label),
  );
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await tester.tap(f);
  await tester.pumpAndSettle();
}

const _ciKey =
    'ssh-ed25519 '
    'AAAAC3NzaC1lZDI1NTE5AAAAINdamAGCsQq31Uv+08lkBzoO4XLz2qYjJa8CGmj3B1Ea ci';
