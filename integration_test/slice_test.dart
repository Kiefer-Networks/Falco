// SPDX-License-Identifier: GPL-3.0-or-later
// The vertical slice end to end on a device: add account and project,
// server list, detail, reboot with progress, activity. HTTP is faked
// below dio, everything above it is the real app.
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

import '../test/fake_cloud.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('account, project, servers, reboot, activity', (tester) async {
    final cloud = FakeCloud();
    await pumpFalco(tester, cloud, accounts: const []);

    // Account and project; the token is checked before it is stored.
    await tester.enterText(find.byKey(const ValueKey('account-name')), 'Acme');
    await tester.pump();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('project-name')), 'prod');
    await tester.enterText(find.byKey(const ValueKey('api-token')), fakeToken);
    await tester.pump();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check and save'));
    await tester.pumpAndSettle();

    // Server list of the new project.
    expect(find.text('web-1'), findsOneWidget);
    expect(find.text('db-1'), findsOneWidget);

    // Detail and reboot with confirmation and tracked progress.
    await tester.tap(find.text('web-1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reboot'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Reboot'));
    await tester.pumpAndSettle();
    expect(cloud.calls, contains('POST /servers/1/actions/reboot'));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.textContaining('rebooting'), findsNothing);

    // Back to the list, then the project activity shows the reboot.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Activity'));
    await tester.pumpAndSettle();
    expect(find.text('Reboot server'), findsOneWidget);
    expect(find.text('done'), findsOneWidget);
  });
}
