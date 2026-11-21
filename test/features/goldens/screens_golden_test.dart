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

  final screens = <String, Future<void> Function(WidgetTester)>{
    'setup': (_) async {},
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

  for (final variant in [FalcoVariant.dark, FalcoVariant.light]) {
    group(variant.name, () {
      for (final MapEntry(key: name, value: open) in screens.entries) {
        testWidgets(name, (tester) async {
          setSurface(tester, const Size(390, 844));
          await pumpFalco(
            tester,
            FakeCloud(
              actions: [
                FakeCloud.action(11, 'reboot_server', 1),
                FakeCloud.action(12, 'start_server', 2, status: 'error'),
              ],
            ),
            accounts: name == 'setup' ? const [] : const [acme],
            variant: variant,
          );
          await open(tester);
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('${name}_${variant.name}.png'),
          );
        });
      }
    });
  }
}
