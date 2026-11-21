// SPDX-License-Identifier: GPL-3.0-or-later
// Screen reader labels, touch targets and text scaling of the main
// screens (QRS-026). Contrast is covered by test/ui/contrast_test.dart.
import 'package:falco/core/scope/scope.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';
import '../steps.dart' hide setSurface;
import '../storage_steps.dart';

typedef _Open = Future<void> Function(WidgetTester tester);

Future<void> _area(WidgetTester tester, String name, [String? tab]) async {
  await tester.tap(find.text(name).last);
  await tester.pumpAndSettle();
  if (tab == null) return;
  await tester.ensureVisible(find.widgetWithText(Tab, tab));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(Tab, tab));
  await tester.pumpAndSettle();
}

final _screens = <String, (List<Account>, FakeCloud Function(), _Open)>{
  'servers': (const [acme], FakeCloud.new, (_) async {}),
  'server detail': (const [acme], FakeCloud.new, (t) => tap(t, 'web-1')),
  'firewalls': (
    const [acme],
    () => FakeCloud(firewalls: [firewallJson(id: 51, name: 'web')]),
    (t) => _area(t, 'Network', 'Firewalls'),
  ),
  'storage boxes': (const [acme], storageCloud, (t) => _area(t, 'Storage')),
  'storage box detail': (
    const [acme],
    storageCloud,
    (t) async {
      await _area(t, 'Storage');
      await tap(t, 'backup');
    },
  ),
  'robot servers': (const [acmeRobot], FakeCloud.new, (t) => _area(t, 'Robot')),
  'search': (
    const [acme],
    FakeCloud.new,
    (t) async {
      await t.tap(find.byTooltip('Search'));
      await t.pumpAndSettle();
      await t.enterText(find.byType(TextField), 'web');
      await t.pumpAndSettle();
    },
  ),
  'activity': (
    const [acme],
    () => FakeCloud(actions: [FakeCloud.action(11, 'reboot_server', 1)]),
    (t) async {
      await t.tap(find.byTooltip('Activity'));
      await t.pumpAndSettle();
    },
  ),
  'settings': (
    const [acme],
    FakeCloud.new,
    (t) async {
      await t.tap(find.byTooltip('Settings'));
      await t.pumpAndSettle();
    },
  ),
};

void main() {
  Future<void> pump(
    WidgetTester tester,
    String name, {
    double textScale = 1,
  }) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(() {
      tester.view.reset();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });
    final (accounts, cloud, open) = _screens[name]!;
    await pumpFalco(tester, cloud(), accounts: accounts);
    await open(tester);
  }

  group('QRS-026 accessibility', () {
    for (final name in _screens.keys) {
      testWidgets('$name: labelled 48 dp touch targets', (tester) async {
        final semantics = tester.ensureSemantics();
        await pump(tester, name);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        semantics.dispose();
      });

      if (name == 'server detail') {
        testWidgets('$name: the screen reader says the name before the '
            'status', (tester) async {
          final semantics = tester.ensureSemantics();
          await pump(tester, name);
          final order = [
            for (final n in tester.semantics.simulatedAccessibilityTraversal())
              n.label,
          ];
          expect(
            order.indexOf('web-1'),
            allOf(isNonNegative, lessThan(order.indexOf('running'))),
          );
          semantics.dispose();
        });
      }

      for (final scale in [1.0, 1.5, 2.0]) {
        testWidgets('$name: text at ${scale}x does not overflow', (
          tester,
        ) async {
          await pump(tester, name, textScale: scale);
          expect(tester.takeException(), isNull);
        });
      }
    }
  });
}
