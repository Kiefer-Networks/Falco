// SPDX-License-Identifier: GPL-3.0-or-later
// Goldens of the main screens on tablets and phones in landscape: rail,
// list and detail side by side (QRS-027).
@Tags(['golden'])
library;

import 'package:falco/core/scope/scope.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../fake_cloud.dart';
import '../../helpers.dart';
import '../../steps.dart' hide setSurface;
import '../../storage_steps.dart';

const _tablet = Size(1280, 800);

void main() {
  useTolerantGoldens('tablet_golden_test.dart');

  Future<void> area(WidgetTester tester, String name, [String? tab]) async {
    await tester.tap(find.text(name).last);
    await tester.pumpAndSettle();
    if (tab != null) {
      await tester.tap(find.widgetWithText(Tab, tab));
      await tester.pumpAndSettle();
    }
  }

  final screens = <String, (Size, List<Account>, FakeCloud Function(), Steps)>{
    'tablet_servers': (
      _tablet,
      const [acme],
      FakeCloud.new,
      (tester) => tap(tester, 'web-1'),
    ),
    'tablet_portrait_servers': (
      const Size(800, 1280),
      const [acme],
      FakeCloud.new,
      (_) async {},
    ),
    'phone_landscape_servers': (
      const Size(844, 390),
      const [acme],
      FakeCloud.new,
      (tester) => tap(tester, 'db-1'),
    ),
    'tablet_firewalls': (
      _tablet,
      const [acme],
      () => FakeCloud(
        firewalls: [
          firewallJson(id: 51, name: 'web', servers: [1]),
        ],
      ),
      (tester) async {
        await area(tester, 'Network', 'Firewalls');
        await tap(tester, 'web');
      },
    ),
    'tablet_storage_boxes': (
      _tablet,
      const [acme],
      storageCloud,
      (tester) async {
        await area(tester, 'Storage');
        await tap(tester, 'backup');
      },
    ),
    'tablet_robot': (
      _tablet,
      const [acmeRobot],
      FakeCloud.new,
      (tester) async {
        await area(tester, 'Robot');
        await tap(tester, 'server1');
      },
    ),
  };

  for (final variant in [FalcoVariant.dark, FalcoVariant.light]) {
    group(variant.name, () {
      for (final MapEntry(key: name, value: (size, accounts, cloud, open))
          in screens.entries) {
        testWidgets('$name QRS-027', (tester) async {
          tester.view
            ..physicalSize = size
            ..devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          await pumpFalco(
            tester,
            cloud(),
            accounts: accounts,
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

typedef Steps = Future<void> Function(WidgetTester tester);
