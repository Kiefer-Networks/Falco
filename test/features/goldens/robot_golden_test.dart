// SPDX-License-Identifier: GPL-3.0-or-later
// Goldens of the Robot area against the fake Robot webservice.
@Tags(['golden'])
library;

import 'package:falco/features/robot/robot_pages.dart';
import 'package:falco/main.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../fake_cloud.dart';
import '../../helpers.dart';
import '../../robot_steps.dart';
import '../../steps.dart' hide setSurface;

void main() {
  final screens = <String, Future<void> Function(WidgetTester)>{
    'robot_servers': (_) async {},
    'robot_server_detail': (tester) => tap(tester, 'server1'),
    'robot_server_network': (tester) async {
      await tap(tester, 'server1');
      await tester.scrollUntilVisible(
        find.text('TRAFFIC THIS MONTH'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
    },
    'robot_failover': (tester) => robotTab(tester, 'Failover'),
    'robot_rdns': (tester) => robotTab(tester, 'Reverse DNS'),
    'robot_vswitches': (tester) => robotTab(tester, 'vSwitches'),
    'robot_vswitch_detail': (tester) async {
      await robotTab(tester, 'vSwitches');
      await tap(tester, 'backend');
    },
    'robot_keys': (tester) => robotTab(tester, 'SSH keys'),
    'robot_ips': (tester) => robotTab(tester, 'IPs'),
    'robot_subnets': (tester) => robotTab(tester, 'Subnets'),
    'robot_firewall': (tester) async {
      await tap(tester, 'server1');
      await more(tester, 'Firewall');
    },
    'robot_templates': (tester) => robotTab(tester, 'Firewall templates'),
  };

  // PARITY rows each golden covers.
  const ids = {
    'robot_servers': 'ROB-004',
    'robot_server_detail': 'ROB-006',
    'robot_server_network': 'ROB-007',
    'robot_failover': 'ROB-017',
    'robot_rdns': 'ROB-020',
    'robot_vswitches': 'ROB-024',
    'robot_vswitch_detail': 'ROB-026 ROB-027',
    'robot_keys': 'ROB-032',
    'robot_ips': 'ROB-049',
    'robot_subnets': 'ROB-053',
    'robot_firewall': 'ROB-057',
    'robot_templates': 'ROB-058',
  };

  for (final variant in [FalcoVariant.light, FalcoVariant.dark]) {
    group(variant.name, () {
      for (final MapEntry(key: name, value: open) in screens.entries) {
        testWidgets('$name ${ids[name]}', (tester) async {
          setSurface(tester, const Size(390, 844));
          await pumpFalco(
            tester,
            FakeCloud(),
            accounts: const [acmeRobot],
            variant: variant,
          );
          await tester.tap(find.text('Robot').last);
          await tester.pumpAndSettle();
          await open(tester);
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('${name}_${variant.name}.png'),
          );
        });
      }

      // A fixed day, so the period does not move with the calendar.
      testWidgets('robot_traffic ROB-059', (tester) async {
        setSurface(tester, const Size(390, 844));
        final cloud = FakeCloud();
        seedSecrets(const [acmeRobot]);
        await tester.pumpWidget(
          ProviderScope(
            overrides: fakeApis(cloud),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: falcoTheme(variant: variant),
              locale: const Locale('en'),
              localizationsDelegates: falcoLocalizationsDelegates,
              supportedLocales: const [Locale('en')],
              home: RobotTrafficPage(
                accountId: 'a1',
                ip: '123.123.123.123',
                day: DateTime(2026, 3, 15),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('robot_traffic_${variant.name}.png'),
        );
      });
    });
  }
}
