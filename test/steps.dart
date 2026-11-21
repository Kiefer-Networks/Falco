// SPDX-License-Identifier: GPL-3.0-or-later
// Small UI steps shared by the feature and integration tests.
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Taps the last widget with [text], scrolling it into view first.
Future<void> tap(WidgetTester tester, String text) async {
  if (find.text(text).evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      find.text(text),
      300,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(find.text(text).last);
  await tester.pumpAndSettle();
  await tester.tap(find.text(text).last);
  await tester.pumpAndSettle();
}

/// Opens the more menu and picks [item].
Future<void> more(WidgetTester tester, String item) async {
  await tester.tap(find.byTooltip('More actions'));
  await tester.pumpAndSettle();
  await tap(tester, item);
}

/// Taps the primary button [label] of a sheet.
Future<void> confirm(WidgetTester tester, String label) async {
  await tester.tap(find.widgetWithText(FilledButton, label));
  await tester.pumpAndSettle();
}

/// Lets the fake action finish and the tracker refresh.
Future<void> settleAction(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle();
}

/// A tall surface so detail pages show most sections.
void setSurface(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(800, 1400)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Pumps a second of frames where a spinner keeps pumpAndSettle from
/// settling (a create button while its result sheet is open).
Future<void> pumpFrames(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
