// SPDX-License-Identifier: GPL-3.0-or-later
// End to end on a device (Phase 5): a network flow and a DNS flow. HTTP and
// the file dialogs are faked below the app, everything above is the real
// app.
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/network_steps.dart';
import '../test/steps.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('NET-042 NET-046 CMP-040 NET-055 create a network, add a '
      'subnet, attach a server, delete the network', (tester) async {
    final cloud = await openNetwork(tester, 'Networks');

    // Create with a first subnet.
    await tap(tester, 'Create network');
    await enter(tester, 'name', 'lan');
    await tap(tester, 'Next');
    await tap(tester, 'Next');
    await tap(tester, 'Create');
    expect(cloud.calls.where((c) => c == 'POST /networks'), hasLength(1));
    await tap(tester, 'lan');

    // A second subnet, tracked until done.
    await tile(tester, 'Add subnet');
    await enter(tester, 'range', '10.0.2.0/24');
    await tap(tester, 'Save');
    await settleAction(tester);
    expect(find.text('10.0.2.0/24'), findsOneWidget);

    // The server joins the network from its own page.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Compute'));
    await tester.pumpAndSettle();
    await tap(tester, 'web-1');
    await more(tester, 'Attach to network');
    await tap(tester, 'lan');
    await tap(tester, 'Save');
    await settleAction(tester);
    expect(find.text('lan'), findsOneWidget);
    expect(cloud.calls, contains('POST /servers/1/actions/attach_to_network'));

    // Delete the network with its typed name.
    await tap(tester, 'lan');
    await tap(tester, 'Delete');
    await typeName(tester, 'lan');
    await confirm(tester, 'Delete');
    expect(
      cloud.calls.where((c) => c.startsWith('DELETE /networks/')),
      hasLength(1),
    );
  });

  testWidgets('DNS-002 DNS-026 DNS-015 DNS-016 create a zone, add a record, '
      'import and export the zone file', (tester) async {
    final cloud = await openNetwork(tester, 'DNS');

    await tap(tester, 'Create zone');
    await tap(tester, 'Next');
    await enter(tester, 'name', 'example.com');
    await tap(tester, 'Next');
    await tap(tester, 'Create');
    await settleAction(tester);
    await tap(tester, 'example.com');

    await tile(tester, 'Add record');
    await enter(tester, 'name', 'www');
    await enter(tester, 'values', '203.0.113.1');
    await tap(tester, 'Save');
    await settleAction(tester);
    expect(find.text('www A'), findsOneWidget);

    cloud.files.picked = (text: 'mail IN A 203.0.113.2', tooLarge: false);
    await more(tester, 'Import zone file');
    await typeName(tester, 'example.com');
    await confirm(tester, 'Import zone file');
    await settleAction(tester);
    expect(cloud.importedZonefile, 'mail IN A 203.0.113.2');
    expect(find.text('mail A'), findsOneWidget);

    await tile(tester, 'Export');
    expect(cloud.files.saved.keys, ['example.com.zone']);
    expect(find.text('Zone file saved'), findsOneWidget);
  });
}
