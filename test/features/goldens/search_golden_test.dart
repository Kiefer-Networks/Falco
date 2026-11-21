// SPDX-License-Identifier: GPL-3.0-or-later
// Goldens of search and activity against the fake APIs. Every time shown
// is a fixed day, so no label moves with the clock.
@Tags(['golden'])
library;

import 'package:falco/ui/ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../fake_cloud.dart';
import '../../helpers.dart';
import '../../search_steps.dart';

void main() {
  useTolerantGoldens('search_golden_test.dart');

  final day = DateTime(2026, 3, 1, 14, 5);
  String at(int minutes) =>
      day.add(Duration(minutes: minutes)).toUtc().toIso8601String();
  final actions = [
    FakeCloud.action(
      11,
      'rebuild_server',
      1,
      status: 'running',
      started: day.add(const Duration(days: 2)),
    )..['progress'] = 45,
    FakeCloud.action(12, 'attach_volume', 21, type: 'volume', started: day)
      ..['finished'] = at(1),
    FakeCloud.action(
      13,
      'start_server',
      2,
      status: 'error',
      started: day.subtract(const Duration(days: 1)),
    )..['finished'] = at(-1439),
    FakeCloud.action(
      14,
      'change_protection',
      37,
      type: 'zone',
      started: day.subtract(const Duration(days: 1)),
    )..['finished'] = at(-1438),
  ];

  final screens = <String, Future<void> Function(WidgetTester)>{
    'search_start': (tester) async {
      await tester.tap(find.byTooltip('Search'));
      await tester.pumpAndSettle();
    },
    'search_results': (tester) async {
      await tester.tap(find.byTooltip('Search'));
      await tester.pumpAndSettle();
      await search(tester, 'web');
    },
    'activity_grouped': (tester) async {
      await tester.tap(find.byTooltip('Activity'));
      await tester.pumpAndSettle();
    },
  };

  // PARITY rows each golden covers.
  const ids = {
    'search_start': 'SUC-001',
    'search_results': 'SUC-003 SUC-004',
    'activity_grouped': 'SUC-008 SUC-009',
  };

  for (final variant in [FalcoVariant.light, FalcoVariant.dark]) {
    group(variant.name, () {
      for (final MapEntry(key: name, value: open) in screens.entries) {
        testWidgets('$name ${ids[name]}', (tester) async {
          setSurface(tester, const Size(390, 844));
          await pumpFalco(
            tester,
            searchCloud(actions: actions),
            accounts: const [acmeRobot],
            variant: variant,
            s3: true,
          );
          await open(tester);
          // No blinking cursor in the picture.
          FocusManager.instance.primaryFocus?.unfocus();
          await tester.pumpAndSettle();
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('${name}_${variant.name}.png'),
          );
        });
      }
    });
  }
}
