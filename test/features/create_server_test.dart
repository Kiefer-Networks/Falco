// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';
import '../steps.dart';

void main() {
  testWidgets('CMP-013 creating sends one POST despite a double tap and '
      'reloads the list', (tester) async {
    final cloud = FakeCloud(sshKeys: [sshKeyJson(id: 61, name: 'laptop')]);
    setSurface(tester);
    await pumpFalco(tester, cloud);
    await openList(tester, 'Servers');
    await tap(tester, 'Create server');
    await tap(tester, 'fsn1');
    await tap(tester, 'Next');
    await tap(tester, 'CX22');
    await tap(tester, 'Next');
    await tap(tester, 'Debian 12');
    await tap(tester, 'Next');
    await tap(tester, 'laptop');
    for (var i = 0; i < 3; i++) {
      await tap(tester, 'Next');
    }
    await tester.enterText(find.byKey(const ValueKey('name')), 'app-1');
    await tester.pumpAndSettle();
    await tap(tester, 'Next');
    final lists = cloud.calls.where((c) => c == 'GET /servers').length;
    await tester.tap(find.text('Create'));
    await tester.tap(find.text('Create'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(cloud.calls.where((c) => c == 'POST /servers'), hasLength(1));
    expect(
      cloud.calls.where((c) => c == 'GET /servers').length,
      greaterThan(lists),
    );
    expect(find.text('app-1'), findsOneWidget);
    await settleAction(tester);
  });
}
