// SPDX-License-Identifier: GPL-3.0-or-later
// Steps of the Robot area tests (widget, golden, integration).
import 'package:flutter_test/flutter_test.dart';

import 'fake_cloud.dart';
import 'steps.dart';

export 'network_steps.dart' show enter, tile, typeName;

/// Opens the Robot area of [acmeRobot], then [tab] when given.
Future<FakeCloud> openRobot(
  WidgetTester tester, {
  String? tab,
  FakeCloud? cloud,
}) async {
  final c = cloud ?? FakeCloud();
  setSurface(tester);
  await pumpFalco(tester, c, accounts: const [acmeRobot]);
  await tester.tap(find.text('Robot').last);
  await tester.pumpAndSettle();
  if (tab != null) await robotTab(tester, tab);
  return c;
}

/// Opens the list [tab] from the Robot overview.
Future<void> robotTab(WidgetTester tester, String tab) => openList(tester, tab);

/// Opens server [name] of the server list.
Future<FakeCloud> openRobotServer(
  WidgetTester tester, [
  String name = 'server1',
]) async {
  final c = await openRobot(tester);
  await tap(tester, name);
  return c;
}
