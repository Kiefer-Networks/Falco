// SPDX-License-Identifier: GPL-3.0-or-later
// End to end on a device (Phase 8): search hits of a Cloud project,
// Object Storage and Robot open their pages, and the activity links back
// to a resource. HTTP is faked below dio, everything above is the real
// app.
import 'package:falco/ui/ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/fake_cloud.dart';
import '../test/search_steps.dart';
import '../test/steps.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SUC-005 search hit opens target', (tester) async {
    await openSearch(
      tester,
      cloud: searchCloud(
        actions: [FakeCloud.action(11, 'attach_volume', 21, type: 'volume')],
      ),
      query: '203.0.113.1',
      surface: false,
    );

    // By IP to the Cloud server.
    await tester.tap(find.widgetWithText(ResourceRow, 'web-1'));
    await tester.pumpAndSettle();
    expect(find.text('Reboot'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // By name to the zone, the bucket and the dedicated server.
    for (final (query, name, shows) in [
      ('example.com 37', 'example.com', 'example.com'),
      ('media', 'media', 'media'),
      ('server1', 'server1', 'AX41-NVMe'),
    ]) {
      await search(tester, query);
      await tester.tap(find.widgetWithText(ResourceRow, name));
      await tester.pumpAndSettle();
      expect(find.textContaining(shows), findsWidgets, reason: query);
      await tester.pageBack();
      await tester.pumpAndSettle();
    }

    // The search is remembered.
    await search(tester, '');
    expect(find.text('server1'), findsOneWidget);

    // The project activity links to the volume.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Activity'));
    await tester.pumpAndSettle();
    await tap(tester, 'Attach volume');
    expect(find.text('data'), findsWidgets);
  });
}
