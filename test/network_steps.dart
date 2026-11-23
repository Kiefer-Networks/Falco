// SPDX-License-Identifier: GPL-3.0-or-later
// Steps of the Network area tests (widget and integration).
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'fake_cloud.dart';
import 'steps.dart';

/// Opens [tab] of the Network area.
Future<FakeCloud> openNetwork(
  WidgetTester tester,
  String tab, {
  FakeCloud? cloud,
}) async {
  final c = cloud ?? FakeCloud();
  setSurface(tester);
  await pumpFalco(tester, c);
  await tester.tap(find.text('Network'));
  await tester.pumpAndSettle();
  await openList(tester, tab);
  return c;
}

Future<void> enter(WidgetTester tester, String key, String text) async {
  await tester.enterText(find.byKey(ValueKey(key)), text);
  await tester.pumpAndSettle();
}

/// Runs the detail action [label] (the same word may be a fact label).
Future<void> tile(WidgetTester tester, String label) => more(tester, label);

Future<void> typeName(WidgetTester tester, String name) =>
    enter(tester, 'confirm-name', name);
