// SPDX-License-Identifier: GPL-3.0-or-later
// End to end on a device: welcome, account with two Cloud projects,
// switching between them and "All projects" (Phase 3), then server list,
// detail, reboot with progress and activity (vertical slice). HTTP is
// faked below dio, everything above it is the real app.
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

import '../test/fake_cloud.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> tap(WidgetTester tester, String text) async {
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  Future<void> enter(WidgetTester tester, String key, String text) async {
    await tester.enterText(find.byKey(ValueKey(key)), text);
    await tester.pump();
  }

  testWidgets('ONB-006 ONB-028 SET-006 account with two projects, switch, '
      'servers, reboot, activity', (tester) async {
    final cloud = FakeCloud();
    await pumpFalco(tester, cloud, accounts: const []);

    // Welcome pages, then the account wizard with two projects.
    expect(find.text('Choose your language'), findsOneWidget);
    for (var i = 0; i < 3; i++) {
      await tap(tester, 'Next');
    }
    await tap(tester, 'Add account');
    await enter(tester, 'name', 'Acme');
    await tap(tester, 'Next');
    await tap(tester, 'Next');
    for (final name in ['prod', 'staging']) {
      await tap(tester, 'Add project');
      await enter(tester, 'name', name);
      await enter(tester, 'token', fakeToken);
      await tap(tester, 'Save');
    }
    await tap(tester, 'Next');
    await tap(tester, 'Check and save');
    expect(find.text('All set. Acme is ready to use.'), findsOneWidget);
    await tap(tester, 'Open');

    // Server list of the first project.
    expect(find.text('web-1'), findsOneWidget);
    expect(find.text('db-1'), findsOneWidget);

    // Switch to the second project and to "All projects".
    await tester.tap(find.bySemanticsLabel('Switch account or project: prod'));
    await tester.pumpAndSettle();
    await tap(tester, 'staging');
    expect(find.text('staging'), findsOneWidget);
    await tester.tap(
      find.bySemanticsLabel('Switch account or project: staging'),
    );
    await tester.pumpAndSettle();
    await tap(tester, 'All projects');
    expect(find.text('All projects'), findsOneWidget);
    await tester.tap(
      find.bySemanticsLabel('Switch account or project: All projects'),
    );
    await tester.pumpAndSettle();
    await tap(tester, 'prod');

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
