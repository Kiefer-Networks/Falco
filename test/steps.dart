// SPDX-License-Identifier: GPL-3.0-or-later
// Small UI steps shared by the feature and integration tests.
import 'package:falco/ui/ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Taps the last widget with [text], scrolling it into view first. A
/// detail action that is not in the action bar is picked from its "More"
/// sheet.
Future<void> tap(WidgetTester tester, String text) async {
  final more = find.descendant(
    of: find.byType(DetailActionBar),
    matching: find.byTooltip('More actions'),
  );
  if (find.text(text).evaluate().isEmpty && more.evaluate().isNotEmpty) {
    await tester.tap(more);
    await tester.pumpAndSettle();
    if (find.text(text).evaluate().isEmpty) {
      // Not an action: close the sheet and look further down the page.
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
    }
  }
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

/// Runs action [item]: its button in the detail action bar, else the
/// entry of the "More" sheet (or of a screen's more menu).
Future<void> more(WidgetTester tester, String item) async {
  final bar = find.descendant(
    of: find.byType(DetailActionBar),
    matching: find.text(item),
  );
  if (bar.evaluate().isNotEmpty) {
    await tester.tap(bar);
    await tester.pumpAndSettle();
    return;
  }
  await tester.tap(find.byTooltip('More actions'));
  await tester.pumpAndSettle();
  await tap(tester, item);
}

/// Opens the list [type] from the overview of the area shown.
Future<void> openList(WidgetTester tester, String type) => tap(tester, type);

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
