// SPDX-License-Identifier: GPL-3.0-or-later
// End to end on a device (Phase 7): a dedicated server through rescue,
// reset, cancellation and the activity. The Robot webservice is faked
// below dio in the documented format, everything above is the real app.
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/robot_steps.dart';
import '../test/steps.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ROB-011 ROB-009 ROB-014 ROB-015 ROB-016 rescue with a '
      'Robot key, reset, cancel, withdraw, activity', (tester) async {
    final cloud = await openRobotServer(tester);

    // Rescue with the Robot key; the password shows once.
    await tile(tester, 'Enable rescue');
    await tap(tester, 'laptop');
    await tap(tester, 'Save');
    expect(find.text('Root password'), findsOneWidget);
    await tap(tester, 'Close');
    expect(find.text('Rescue system'), findsOneWidget);

    // Reset with an offered type.
    await tile(tester, 'Reset');
    await tap(tester, 'Hardware reset');
    await confirm(tester, 'Reset');
    expect(find.text('Action completed'), findsOneWidget);

    // Cancel immediately with the typed name, then withdraw.
    await tap(tester, 'Cancel contract');
    await tap(tester, 'Immediately');
    await tap(tester, 'Save');
    await typeName(tester, 'server1');
    await confirm(tester, 'Cancel contract');
    await tap(tester, 'Withdraw cancellation');
    await confirm(tester, 'Withdraw cancellation');
    expect(find.text('Cancel contract'), findsOneWidget);

    for (final c in [
      'POST /boot/321/rescue',
      'POST /reset/321',
      'POST /server/321/cancellation',
      'DELETE /server/321/cancellation',
    ]) {
      expect(cloud.calls, contains(c));
    }

    // Every change is in the Robot activity.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Activity'));
    await tester.pumpAndSettle();
    expect(find.text('Activate boot configuration'), findsOneWidget);
    expect(find.text('Withdraw cancellation'), findsOneWidget);
  });
}
