// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/scope/scope_repository.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';

Future<void> fillSetup(
  WidgetTester tester, {
  required String token,
  String? account = 'Acme',
}) async {
  if (account != null) {
    await tester.enterText(find.byKey(const ValueKey('account-name')), account);
    await tester.pump();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
  }
  await tester.enterText(find.byKey(const ValueKey('project-name')), 'prod');
  await tester.enterText(find.byKey(const ValueKey('api-token')), token);
  await tester.pump();
  await tester.tap(find.text('Next'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('steps need their fields before "Next"', (tester) async {
    await pumpFalco(tester, FakeCloud(), accounts: const []);
    expect(find.text('STEP 1 OF 3'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('STEP 1 OF 3'), findsOneWidget);
  });

  testWidgets('a rejected token is reported and nothing is stored '
      '(ONB-017)', (tester) async {
    final container = await pumpFalco(tester, FakeCloud(), accounts: const []);
    await fillSetup(tester, token: 'wrong');
    expect(find.text('Summary'), findsOneWidget);
    expect(find.text('wrong'), findsNothing);
    await tester.tap(find.text('Check and save'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'The access data was rejected. Check the token or the credentials.',
      ),
      findsOneWidget,
    );
    expect(await container.read(scopeRepositoryProvider).accounts(), isEmpty);
  });

  testWidgets('a valid token is stored and the project opens', (tester) async {
    final cloud = FakeCloud();
    final container = await pumpFalco(tester, cloud, accounts: const []);
    await fillSetup(tester, token: fakeToken);
    await tester.tap(find.text('Check and save'));
    await tester.pumpAndSettle();
    expect(cloud.calls.first, 'GET /servers');
    expect(find.text('web-1'), findsOneWidget);
    final accounts = await container.read(scopeRepositoryProvider).accounts();
    expect(accounts.single.name, 'Acme');
    final project = accounts.single.projects.single;
    expect(project.name, 'prod');
    expect(
      await container.read(secretStoreProvider).cloudToken(project.id),
      fakeToken,
    );
  });

  testWidgets('a project is added to an existing account', (tester) async {
    final container = await pumpFalco(tester, FakeCloud());
    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add project'));
    await tester.pumpAndSettle();
    expect(find.text('STEP 1 OF 2'), findsOneWidget);
    await fillSetup(tester, token: fakeToken, account: null);
    await tester.tap(find.text('Check and save'));
    await tester.pumpAndSettle();
    final accounts = await container.read(scopeRepositoryProvider).accounts();
    expect(accounts.single.projects, hasLength(2));
    // The new project is open; the switcher shows it.
    expect(find.text('prod'), findsOneWidget);
  });
}
