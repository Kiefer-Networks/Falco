// SPDX-License-Identifier: GPL-3.0-or-later
// End to end on a device (Phase 4): create a server through the wizard,
// reboot it with tracked progress, delete it with the typed name. HTTP is
// faked below dio, everything above it is the real app.
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

import '../test/fake_cloud.dart';
import '../test/steps.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CMP-013 CMP-020 CMP-048 create a server, reboot it, delete '
      'it', (tester) async {
    final cloud = FakeCloud(sshKeys: [sshKeyJson(id: 61, name: 'laptop')]);
    await pumpFalco(tester, cloud);

    // Create from the server list: location, type, image, key, defaults,
    // name.
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
    await tester.tap(find.text('Create'));
    // A second tap while creating must not create twice.
    await tester.tap(find.text('Create'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(cloud.calls.where((c) => c == 'POST /servers'), hasLength(1));
    expect(find.text('app-1'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('running'), findsOneWidget);

    // Reboot with confirmation and tracked progress.
    await tap(tester, 'Reboot');
    await confirm(tester, 'Reboot');
    expect(cloud.calls, contains('POST /servers/100/actions/reboot'));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.textContaining('rebooting'), findsNothing);

    // Delete with the typed name; the list no longer has it.
    await tap(tester, 'Delete');
    await tester.enterText(find.byKey(const ValueKey('confirm-name')), 'app-1');
    await tester.pumpAndSettle();
    await confirm(tester, 'Delete');
    expect(cloud.calls, contains('DELETE /servers/100'));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('app-1'), findsNothing);
    expect(find.text('web-1'), findsOneWidget);
  });
}
