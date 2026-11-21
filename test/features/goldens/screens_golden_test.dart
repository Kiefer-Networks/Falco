// SPDX-License-Identifier: GPL-3.0-or-later
// Goldens of the vertical slice screens against the fake Cloud API.
@Tags(['golden'])
library;

import 'package:falco/ui/ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../fake_cloud.dart';
import '../../helpers.dart';

void main() {
  useTolerantGoldens('screens_golden_test.dart');

  Future<void> tap(WidgetTester tester, String text) async {
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  Future<void> settings(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
  }

  final screens = <String, Future<void> Function(WidgetTester)>{
    'welcome': (_) async {},
    'welcome_features': (tester) => tap(tester, 'Next'),
    'welcome_security': (tester) async {
      await tap(tester, 'Next');
      await tap(tester, 'Next');
    },
    'account_wizard_summary': (tester) async {
      await tap(tester, 'Skip');
      await tester.enterText(find.byKey(const ValueKey('name')), 'Acme');
      await tester.pump();
      await tap(tester, 'Next');
      await tap(tester, 'Robot');
      await tap(tester, 'Next');
      await tap(tester, 'Add project');
      await tester.enterText(find.byKey(const ValueKey('name')), 'prod');
      await tester.enterText(find.byKey(const ValueKey('token')), fakeToken);
      await tester.pump();
      await tap(tester, 'Save');
      await tap(tester, 'Next');
      await tester.enterText(
        find.byKey(const ValueKey('robotUser')),
        fakeRobotUser,
      );
      await tester.enterText(
        find.byKey(const ValueKey('robotPassword')),
        fakeRobotPassword,
      );
      await tester.pump();
      await tap(tester, 'Next');
    },
    'settings': settings,
    'accounts': (tester) async {
      await settings(tester);
      await tap(tester, 'Accounts');
    },
    'account': (tester) async {
      await settings(tester);
      await tap(tester, 'Accounts');
      await tap(tester, 'Acme');
    },
    'about': (tester) async {
      await settings(tester);
      await tester.scrollUntilVisible(find.text('ABOUT FALCO'), 200);
      await tap(tester, 'About Falco');
    },
    'server_list': (_) async {},
    'server_detail': (tester) async {
      await tester.tap(find.text('web-1'));
      await tester.pumpAndSettle();
    },
    'confirm_reboot': (tester) async {
      await tester.tap(find.text('web-1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reboot'));
      await tester.pumpAndSettle();
    },
    'activity': (tester) async {
      await tester.tap(find.byTooltip('Activity'));
      await tester.pumpAndSettle();
    },
  };

  // PARITY rows each golden covers.
  const ids = {
    'welcome': 'ONB-001',
    'welcome_features': 'ONB-004',
    'welcome_security': 'ONB-005',
    'account_wizard_summary': 'ONB-016',
    'settings': 'SET-001 SET-002 SET-003',
    'accounts': 'ONB-021 ONB-022 ONB-023',
    'account': 'ONB-029',
    'about': 'ONB-040',
  };

  for (final variant in [FalcoVariant.dark, FalcoVariant.light]) {
    group(variant.name, () {
      for (final MapEntry(key: name, value: open) in screens.entries) {
        testWidgets('$name ${ids[name] ?? ''}'.trim(), (tester) async {
          setSurface(tester, const Size(390, 844));
          await pumpFalco(
            tester,
            FakeCloud(
              actions: [
                FakeCloud.action(11, 'reboot_server', 1),
                FakeCloud.action(12, 'start_server', 2, status: 'error'),
              ],
            ),
            accounts: name.startsWith('welcome') || name.startsWith('account_')
                ? const []
                : const [acme],
            variant: variant,
          );
          await open(tester);
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('${name}_${variant.name}.png'),
          );
        });
      }

      testWidgets('lock (SET-011)', (tester) async {
        setSurface(tester, const Size(390, 844));
        await pumpFalco(
          tester,
          FakeCloud(),
          variant: variant,
          answers: [false],
        );
        expect(find.text('web-1'), findsNothing);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('lock_${variant.name}.png'),
        );
      });
    });
  }
}
