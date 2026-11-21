// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';
import '../steps.dart' hide setSurface;

void main() {
  void size(WidgetTester tester, Size size) {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  group('QRS-027 tablet layout', () {
    testWidgets('rows open their detail beside the list, back closes it', (
      tester,
    ) async {
      size(tester, const Size(1280, 800));
      await pumpFalco(tester, FakeCloud());
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.text('Pick an entry to see its details.'), findsOneWidget);

      await tap(tester, 'web-1');
      expect(find.text('Reboot'), findsOneWidget);
      expect(find.text('db-1'), findsOneWidget);

      // Another row replaces the detail.
      await tap(tester, 'db-1');
      expect(find.text('Power on'), findsOneWidget);
      expect(find.text('web-1'), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Pick an entry to see its details.'), findsOneWidget);
      expect(find.text('db-1'), findsOneWidget);
    });

    testWidgets('a detail that closes itself only empties the pane', (
      tester,
    ) async {
      size(tester, const Size(1280, 800));
      final cloud = FakeCloud();
      await pumpFalco(tester, cloud);
      await tap(tester, 'db-1');
      await tester.scrollUntilVisible(
        find.text('Delete'),
        300,
        scrollable: find
            .descendant(
              of: find.byType(Navigator).last,
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('confirm-name')),
        'db-1',
      );
      await tester.pumpAndSettle();
      await confirm(tester, 'Delete');
      await settleAction(tester);
      expect(cloud.calls, contains('DELETE /servers/2'));
      expect(find.text('Pick an entry to see its details.'), findsOneWidget);
      expect(find.text('web-1'), findsOneWidget);
    });

    testWidgets('a new area starts without detail', (tester) async {
      size(tester, const Size(1280, 800));
      await pumpFalco(tester, FakeCloud());
      await tap(tester, 'web-1');
      await tester.tap(find.text('Network').last);
      await tester.pumpAndSettle();
      expect(find.text('Reboot'), findsNothing);
      expect(find.text('Pick an entry to see its details.'), findsOneWidget);
    });

    testWidgets('phones keep the bottom bar and open details as pages', (
      tester,
    ) async {
      size(tester, const Size(390, 844));
      await pumpFalco(tester, FakeCloud());
      expect(find.byType(NavigationBar), findsOneWidget);
      await tap(tester, 'web-1');
      expect(find.text('Reboot'), findsOneWidget);
      expect(find.text('db-1'), findsNothing);
    });

    testWidgets('in landscape a phone gets the rail and keeps the tab', (
      tester,
    ) async {
      size(tester, const Size(390, 844));
      await pumpFalco(tester, FakeCloud());
      await tester.tap(find.widgetWithText(Tab, 'Volumes'));
      await tester.pumpAndSettle();
      size(tester, const Size(844, 390));
      await tester.pumpAndSettle();
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.text('VOLUMES · 0'), findsOneWidget);
    });
  });
}
