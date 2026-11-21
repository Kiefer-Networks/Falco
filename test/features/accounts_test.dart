// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/scope/scope_repository.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/accounts/checks.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';
import '../helpers.dart';

/// Two projects and Robot (ids a1, p1, p2).
const acmeTwo = Account(
  id: 'a1',
  name: 'Acme',
  description: 'Main company',
  hasRobot: true,
  projects: [
    Project(id: 'p1', name: 'prod'),
    Project(id: 'p2', name: 'staging'),
  ],
);

const other = Account(
  id: 'a2',
  name: 'Lab',
  projects: [Project(id: 'p3', name: 'lab')],
);

Future<void> tapText(WidgetTester tester, String text) async {
  await tester.tap(find.text(text).last);
  await tester.pumpAndSettle();
}

Future<void> enter(WidgetTester tester, String key, String text) async {
  await tester.enterText(find.byKey(ValueKey(key)), text);
  await tester.pump();
}

/// Opens the wizard from the start of a fresh install.
Future<ProviderContainer> openWizard(WidgetTester tester, FakeCloud c) async {
  final container = await pumpFalco(tester, c, accounts: const []);
  await tapText(tester, 'Skip');
  return container;
}

/// Account "Acme" with Cloud and optionally Robot, to the summary.
Future<void> fillWizard(
  WidgetTester tester, {
  String token = fakeToken,
  bool robot = false,
  String robotPassword = fakeRobotPassword,
  String? s3AccessKey,
}) async {
  await enter(tester, 'name', 'Acme');
  await tapText(tester, 'Next');
  if (robot) await tapText(tester, 'Robot');
  await tapText(tester, 'Next');
  await tapText(tester, 'Add project');
  await enter(tester, 'name', 'prod');
  await enter(tester, 'token', token);
  if (s3AccessKey != null) {
    await tapText(tester, 'fsn1');
    await enter(tester, 'accessKey', s3AccessKey);
    await enter(tester, 'secretKey', 'fake-secret');
  }
  await tapText(tester, 'Save');
  await tapText(tester, 'Next');
  if (robot) {
    await enter(tester, 'robotUser', fakeRobotUser);
    await enter(tester, 'robotPassword', robotPassword);
    await tapText(tester, 'Next');
  }
}

void main() {
  group('rules', () {
    test('ONB-008 name required, at most 64 characters', () {
      expect(validName(null), isFalse);
      expect(validName('  '), isFalse);
      expect(validName('a' * 64), isTrue);
      expect(validName('a' * 65), isFalse);
    });

    test('ONB-010 ONB-011 ONB-032 project needs name and token', () {
      expect(validProject({'name': 'prod', 'token': 't'}), isTrue);
      expect(validProject({'name': 'prod', 'token': ' '}), isFalse);
      expect(validProject({'name': '', 'token': 't'}), isFalse);
    });

    test('ONB-012 S3 optional, complete when a location is chosen', () {
      expect(validS3({}), isTrue);
      expect(validS3({'s3': 'fsn1', 'accessKey': 'a'}), isFalse);
      expect(
        validS3({'s3': 'fsn1', 'accessKey': 'a', 'secretKey': 's'}),
        isTrue,
      );
      expect(
        validS3({'s3': 'ams1', 'accessKey': 'a', 'secretKey': 's'}),
        isFalse,
      );
    });

    test('ONB-014 Robot user and password required', () {
      expect(validRobot({'robotUser': 'u', 'robotPassword': 'p'}), isTrue);
      expect(validRobot({'robotUser': 'u', 'robotPassword': ''}), isFalse);
    });

    test('ONB-038 only Hetzner S3 endpoints over https without path', () {
      for (final l in s3Locations) {
        expect(isS3Endpoint(s3Endpoint(l)), isTrue);
      }
      for (final bad in [
        'http://fsn1.your-objectstorage.com',
        'https://fsn1.your-objectstorage.com/bucket',
        'https://fsn1.your-objectstorage.com:8443',
        'https://evil.example.com',
        'https://u:p@fsn1.your-objectstorage.com',
      ]) {
        expect(isS3Endpoint(bad), isFalse, reason: bad);
      }
      final c = s3Credentials(
        location: 'hel1',
        accessKey: ' A ',
        secretKey: 'S',
      );
      expect(
        (c.endpoint, c.region, c.accessKey),
        ('https://hel1.your-objectstorage.com', 'hel1', 'A'),
      );
    });
  });

  group('welcome', () {
    testWidgets('ONB-001 ONB-002 four pages with Next, Back and Skip', (
      tester,
    ) async {
      await pumpFalco(tester, FakeCloud(), accounts: const []);
      expect(find.text('Choose your language'), findsOneWidget);
      expect(find.bySemanticsLabel('Step 1 of 4'), findsOneWidget);
      await tapText(tester, 'Next');
      expect(find.text('What Falco does'), findsOneWidget);
      await tapText(tester, 'Back');
      expect(find.text('Choose your language'), findsOneWidget);
      await tapText(tester, 'Next');
      await tapText(tester, 'Next');
      expect(find.text('Your access stays safe'), findsOneWidget);
      await tapText(tester, 'Next');
      expect(find.text('Ready to start'), findsOneWidget);
      expect(find.text('Skip'), findsNothing);
      await tapText(tester, 'Add account');
      expect(find.text('STEP 1 OF 4'), findsOneWidget);
    });

    testWidgets('ONB-003 the language applies at once', (tester) async {
      final c = await pumpFalco(tester, FakeCloud(), accounts: const []);
      await tapText(tester, 'Deutsch');
      expect(find.text('Sprache wählen'), findsOneWidget);
      expect(c.read(appSettingsProvider).language, 'de');
      await tapText(tester, 'System');
      expect(c.read(appSettingsProvider).language, isNull);
    });

    testWidgets('ONB-006 with an account the app opens its project', (
      tester,
    ) async {
      await pumpFalco(tester, FakeCloud());
      expect(find.text('web-1'), findsOneWidget);
    });
  });

  group('account wizard', () {
    testWidgets('ONB-007 the step count follows the chosen services', (
      tester,
    ) async {
      await openWizard(tester, FakeCloud());
      expect(find.text('STEP 1 OF 4'), findsOneWidget);
      await enter(tester, 'name', 'Acme');
      await tapText(tester, 'Next');
      await tapText(tester, 'Robot');
      expect(find.text('STEP 2 OF 5'), findsOneWidget);
    });

    testWidgets('ONB-009 at least one service', (tester) async {
      await openWizard(tester, FakeCloud());
      await enter(tester, 'name', 'Acme');
      await tapText(tester, 'Next');
      await tapText(tester, 'Cloud');
      expect(find.text('Pick at least one service.'), findsOneWidget);
      await tapText(tester, 'Next');
      expect(find.text('Services'), findsOneWidget);
    });

    testWidgets('ONB-013 ONB-015 links open the Hetzner pages', (tester) async {
      final opened = <Uri>[];
      final original = LinkButton.open;
      LinkButton.open = (u) async => opened.add(u);
      addTearDown(() => LinkButton.open = original);
      await openWizard(tester, FakeCloud());
      await enter(tester, 'name', 'Acme');
      await tapText(tester, 'Next');
      await tapText(tester, 'Robot');
      await tapText(tester, 'Next');
      await tapText(tester, 'Open Cloud Console');
      expect(opened.last.toString(), cloudTokensUrl);
      await tapText(tester, 'Add project');
      await enter(tester, 'name', 'prod');
      await enter(tester, 'token', fakeToken);
      await tapText(tester, 'Save');
      await tapText(tester, 'Next');
      await tapText(tester, 'Open Robot settings');
      expect(opened.last.toString(), robotSettingsUrl);
    });

    testWidgets('ONB-016 the summary masks every secret', (tester) async {
      await openWizard(tester, FakeCloud());
      await fillWizard(tester, robot: true, s3AccessKey: fakeAccessKey);
      expect(find.text('Summary'), findsOneWidget);
      expect(find.text('Acme'), findsOneWidget);
      expect(find.text('API token hidden · S3 fsn1'), findsOneWidget);
      expect(find.text(fakeRobotUser), findsOneWidget);
      expect(find.textContaining(fakeToken), findsNothing);
      expect(find.textContaining(fakeRobotPassword), findsNothing);
      expect(find.textContaining(fakeAccessKey), findsNothing);
    });

    testWidgets('ONB-017 a rejected token is reported and nothing is stored', (
      tester,
    ) async {
      final c = await openWizard(tester, FakeCloud());
      await fillWizard(tester, token: 'wrong');
      await tapText(tester, 'Check and save');
      expect(
        find.text(
          'prod: The access data was rejected. Check the token or the '
          'credentials.',
        ),
        findsOneWidget,
      );
      expect(await c.read(scopeRepositoryProvider).accounts(), isEmpty);
    });

    testWidgets('ONB-017 ONB-039 rejected Robot and S3 access is reported', (
      tester,
    ) async {
      final c = await openWizard(tester, FakeCloud());
      await fillWizard(tester, robot: true, robotPassword: 'wrong');
      await tapText(tester, 'Check and save');
      expect(find.textContaining('Robot: The access data'), findsOneWidget);
      expect(await c.read(scopeRepositoryProvider).accounts(), isEmpty);
    });

    testWidgets('ONB-017 rejected S3 keys are reported', (tester) async {
      final c = await openWizard(tester, FakeCloud());
      await fillWizard(tester, s3AccessKey: 'WRONG');
      await tapText(tester, 'Check and save');
      expect(
        find.textContaining('prod, Object Storage: The access data'),
        findsOneWidget,
      );
      expect(await c.read(scopeRepositoryProvider).accounts(), isEmpty);
    });

    testWidgets('ONB-018 ONB-019 every access is checked, stored once, and '
        'the account opens', (tester) async {
      final cloud = FakeCloud();
      final c = await openWizard(tester, cloud);
      await fillWizard(tester, robot: true, s3AccessKey: fakeAccessKey);
      await tester.tap(find.text('Check and save'));
      await tester.tap(find.text('Check and save'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(cloud.calls, contains('GET /servers'));
      expect(cloud.calls, contains('GET /server'));
      expect(cloud.calls, contains('GET /'));
      expect(find.text('All set. Acme is ready to use.'), findsOneWidget);

      final accounts = await c.read(scopeRepositoryProvider).accounts();
      final a = accounts.single;
      expect(
        (a.name, a.hasRobot, a.projects.single.name),
        ('Acme', true, 'prod'),
      );
      final secrets = c.read(secretStoreProvider);
      expect(await secrets.cloudToken(a.projects.single.id), fakeToken);
      expect((await secrets.s3(a.projects.single.id))?.region, 'fsn1');
      expect((await secrets.robot(a.id))?.user, fakeRobotUser);

      await tapText(tester, 'Open');
      expect(find.text('web-1'), findsOneWidget);
    });

    testWidgets('ONB-020 back and jump from the summary', (tester) async {
      await openWizard(tester, FakeCloud());
      await fillWizard(tester, robot: true);
      await tester.tap(find.text('Edit').first);
      await tester.pumpAndSettle();
      expect(find.text('STEP 1 OF 5'), findsOneWidget);
      expect(find.text('Acme'), findsOneWidget);
      await tapText(tester, 'Next');
      await tapText(tester, 'Back');
      expect(find.text('STEP 1 OF 5'), findsOneWidget);
    });

    testWidgets('ONB-010 projects are added and removed in the wizard', (
      tester,
    ) async {
      await openWizard(tester, FakeCloud());
      await enter(tester, 'name', 'Acme');
      await tapText(tester, 'Next');
      await tapText(tester, 'Next');
      for (final name in ['prod', 'staging']) {
        await tapText(tester, 'Add project');
        await enter(tester, 'name', name);
        await enter(tester, 'token', fakeToken);
        await tapText(tester, 'Save');
      }
      expect(find.text('staging'), findsOneWidget);
      await tester.tap(find.byTooltip('Remove staging'));
      await tester.pumpAndSettle();
      expect(find.text('staging'), findsNothing);
      expect(find.text('prod'), findsOneWidget);
    });
  });

  group('accounts', () {
    Future<ProviderContainer> openAccounts(
      WidgetTester tester, {
      List<Account> accounts = const [acmeTwo, other],
      Map<String, Object> prefs = const {},
    }) async {
      final c = await pumpFalco(
        tester,
        FakeCloud(),
        accounts: accounts,
        prefs: prefs,
      );
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();
      await tapText(tester, 'Accounts');
      return c;
    }

    testWidgets('ONB-021 ONB-022 ONB-023 list with services, active and '
        'default', (tester) async {
      await openAccounts(tester, prefs: {'defaultAccount': 'a2'});
      expect(find.text('Main company\nCloud, 2 projects · Robot'), findsOne);
      expect(find.text('Cloud, 1 project'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Default'), findsOneWidget);
    });

    testWidgets('ONB-024 add account opens the wizard', (tester) async {
      await openAccounts(tester);
      await tapText(tester, 'Add account');
      expect(find.text('STEP 1 OF 4'), findsOneWidget);
    });

    testWidgets('ONB-042 without accounts a hint with "Add account"', (
      tester,
    ) async {
      await pumpFalco(tester, FakeCloud(), accounts: const []);
      const AccountsRoute().go(tester.element(find.byType(Scaffold).first));
      await tester.pumpAndSettle();
      expect(find.text('No accounts yet.'), findsOneWidget);
      await tapText(tester, 'Add account');
      expect(find.text('STEP 1 OF 4'), findsOneWidget);
    });

    testWidgets('ONB-026 edit name and description', (tester) async {
      final c = await openAccounts(tester);
      await tapText(tester, 'Lab');
      await tapText(tester, 'Edit');
      await enter(tester, 'name', 'Lab 2');
      await enter(tester, 'description', 'Tests');
      await tapText(tester, 'Save');
      final a = (await c.read(scopeRepositoryProvider).accounts()).last;
      expect((a.name, a.description), ('Lab 2', 'Tests'));
      expect(find.text('Lab 2'), findsOneWidget);
    });

    testWidgets('ONB-027 the default account opens at start', (tester) async {
      final c = await openAccounts(tester);
      await tapText(tester, 'Lab');
      await tapText(tester, 'Default');
      expect(c.read(appSettingsProvider).defaultAccount, 'a2');
      const HomeRoute().go(tester.element(find.byType(Scaffold).first));
      await tester.pumpAndSettle();
      expect(find.text('lab'), findsOneWidget);
    });

    testWidgets('start skips an account without scope, leaving its '
        '"Add project" opens the accounts', (tester) async {
      const empty = Account(id: 'a0', name: 'Empty');
      await pumpFalco(
        tester,
        FakeCloud(),
        accounts: const [empty, acme],
        prefs: {'defaultAccount': 'a0'},
      );
      expect(find.text('prod'), findsOneWidget);
      const AddProjectRoute(accountId: 'a0')
          .go(tester.element(find.byType(Scaffold).first));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CloseButton));
      await tester.pumpAndSettle();
      expect(find.text('Add account'), findsOneWidget);
    });

    testWidgets('ONB-028 open switches to the account', (tester) async {
      await openAccounts(tester);
      await tapText(tester, 'Lab');
      await tapText(tester, 'Open');
      expect(find.text('LAB'), findsOneWidget);
      expect(find.text('lab'), findsOneWidget);
    });

    testWidgets('ONB-025 delete asks for the name and removes all secrets', (
      tester,
    ) async {
      final c = await openAccounts(tester);
      final secrets = c.read(secretStoreProvider);
      await secrets.setRobot(
        'a1',
        const RobotCredentials(user: 'u', password: 'p'),
      );
      await tapText(tester, 'Acme');
      await tester.scrollUntilVisible(find.text('Delete account'), 200);
      await tapText(tester, 'Delete account');
      expect(find.text('Delete Acme?'), findsOneWidget);
      final confirm = find.widgetWithText(FilledButton, 'Delete');
      expect(tester.widget<FilledButton>(confirm).onPressed, isNull);
      await enter(tester, 'confirm-name', 'Acme');
      await tester.tap(confirm);
      await tester.pumpAndSettle();
      expect(
        (await c.read(scopeRepositoryProvider).accounts()).map((a) => a.id),
        ['a2'],
      );
      expect(await secrets.cloudToken('p1'), isNull);
      expect(await secrets.cloudToken('p2'), isNull);
      expect(await secrets.robot('a1'), isNull);
      // The start moves on to the remaining account.
      expect(find.text('lab'), findsOneWidget);
    });
  });

  group('projects', () {
    Future<ProviderContainer> openAccount(WidgetTester tester) async {
      final c = await pumpFalco(tester, FakeCloud(), accounts: [acmeTwo]);
      await tester.tap(
        find.bySemanticsLabel('Switch account or project: prod'),
      );
      await tester.pumpAndSettle();
      await tapText(tester, 'Manage account');
      return c;
    }

    Future<void> projectMenu(WidgetTester tester, String project) async {
      await tester.tap(
        find.descendant(
          of: find.widgetWithText(ListTile, project),
          matching: find.byTooltip('More actions'),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('ONB-029 the account lists its projects', (tester) async {
      await openAccount(tester);
      expect(find.text('CLOUD PROJECTS'), findsOneWidget);
      expect(find.text('prod'), findsOneWidget);
      expect(find.text('staging'), findsOneWidget);
      expect(find.text('No Object Storage keys'), findsNWidgets(2));
      expect(find.text('Webservice access'), findsOneWidget);
    });

    testWidgets('ONB-030 add a project with Object Storage keys', (
      tester,
    ) async {
      final c = await pumpFalco(tester, FakeCloud());
      await tester.tap(
        find.bySemanticsLabel('Switch account or project: prod'),
      );
      await tester.pumpAndSettle();
      await tapText(tester, 'Add project');
      expect(find.text('STEP 1 OF 3'), findsOneWidget);
      await enter(tester, 'name', 'staging');
      await enter(tester, 'token', fakeToken);
      await tapText(tester, 'Next');
      await tapText(tester, 'nbg1');
      await enter(tester, 'accessKey', fakeAccessKey);
      await enter(tester, 'secretKey', 'fake-secret');
      await tapText(tester, 'Next');
      await tapText(tester, 'Check and save');
      final a = (await c.read(scopeRepositoryProvider).accounts()).single;
      expect(a.projects.map((p) => p.name), ['prod', 'staging']);
      final s3 = await c.read(secretStoreProvider).s3(a.projects.last.id);
      expect(s3?.endpoint, 'https://nbg1.your-objectstorage.com');
      expect(find.text('staging'), findsOneWidget);
    });

    testWidgets('ONB-031 rename and change the token with a check', (
      tester,
    ) async {
      final c = await openAccount(tester);
      await projectMenu(tester, 'staging');
      await tapText(tester, 'Rename');
      await enter(tester, 'name', 'stage');
      await tapText(tester, 'Save');
      expect(find.text('stage'), findsOneWidget);

      await projectMenu(tester, 'stage');
      await tapText(tester, 'Change token');
      final field = tester.widget<TextField>(
        find.byKey(const ValueKey('token')),
      );
      expect(field.controller!.text, isEmpty);
      await enter(tester, 'token', 'wrong');
      await tapText(tester, 'Save');
      expect(find.textContaining('rejected'), findsOneWidget);
      expect(await c.read(secretStoreProvider).cloudToken('p2'), fakeToken);
      await enter(tester, 'token', '$fakeToken ');
      await tapText(tester, 'Save');
      expect(find.text('Saved'), findsOneWidget);
    });

    testWidgets('S3 keys per project are checked and deletable', (
      tester,
    ) async {
      final c = await openAccount(tester);
      await projectMenu(tester, 'prod');
      await tapText(tester, 'Object Storage keys');
      await tapText(tester, 'hel1');
      await enter(tester, 'accessKey', fakeAccessKey);
      await enter(tester, 'secretKey', 'fake-secret');
      await tapText(tester, 'Save');
      expect(find.text('Object Storage keys, checked at hel1'), findsOneWidget);
      await projectMenu(tester, 'prod');
      await tapText(tester, 'Delete Object Storage keys');
      await tapText(tester, 'Delete');
      expect(await c.read(secretStoreProvider).s3('p1'), isNull);
    });

    testWidgets('ONB-033 delete a project with its secrets', (tester) async {
      final c = await openAccount(tester);
      await projectMenu(tester, 'staging');
      await tapText(tester, 'Delete project');
      expect(find.text('Delete staging?'), findsOneWidget);
      await enter(tester, 'confirm-name', 'staging');
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();
      final a = (await c.read(scopeRepositoryProvider).accounts()).single;
      expect(a.projects.map((p) => p.id), ['p1']);
      expect(await c.read(secretStoreProvider).cloudToken('p2'), isNull);
    });

    testWidgets('Robot access is checked, changed and deleted', (tester) async {
      final c = await openAccount(tester);
      await tester.tap(
        find.descendant(
          of: find.widgetWithText(ListTile, 'Webservice access'),
          matching: find.byTooltip('More actions'),
        ),
      );
      await tester.pumpAndSettle();
      await tapText(tester, 'Change Robot access');
      await enter(tester, 'robotUser', fakeRobotUser);
      await enter(tester, 'robotPassword', 'wrong');
      await tapText(tester, 'Save');
      expect(find.textContaining('rejected'), findsOneWidget);
      await enter(tester, 'robotPassword', fakeRobotPassword);
      await tapText(tester, 'Save');
      expect(
        (await c.read(secretStoreProvider).robot('a1'))?.user,
        fakeRobotUser,
      );

      await tester.tap(
        find.descendant(
          of: find.widgetWithText(ListTile, 'Webservice access'),
          matching: find.byTooltip('More actions'),
        ),
      );
      await tester.pumpAndSettle();
      await tapText(tester, 'Delete Robot access');
      await tapText(tester, 'Delete');
      expect(await c.read(secretStoreProvider).robot('a1'), isNull);
      expect(find.text('Add Robot access'), findsOneWidget);
    });
  });

  group('scope switcher', () {
    testWidgets(
      'ONB-034 ONB-035 SET-006 QRS-002 projects, all projects, Robot, add '
      'and manage; a switch loads the new scope',
      (tester) async {
        final cloud = FakeCloud();
        await pumpFalco(tester, cloud, accounts: [acmeTwo]);
        await tester.tap(
          find.bySemanticsLabel('Switch account or project: prod'),
        );
        await tester.pumpAndSettle();
        for (final entry in [
          'All projects',
          'prod',
          'staging',
          'Robot',
          'Add project',
          'Manage account',
        ]) {
          expect(find.text(entry), findsWidgets, reason: entry);
        }
        final before = cloud.calls.length;
        await tapText(tester, 'staging');
        expect(find.text('staging'), findsOneWidget);
        expect(cloud.calls.length, greaterThan(before));

        await tester.tap(
          find.bySemanticsLabel('Switch account or project: staging'),
        );
        await tester.pumpAndSettle();
        await tapText(tester, 'All projects');
        expect(find.text('All projects'), findsOneWidget);
      },
    );

    test('ONB-036 the scope travels in the route, not in hidden state', () {
      expect(
        const ServerRoute(
          accountId: 'a1',
          projectId: 'p2',
          serverId: 7,
        ).location,
        '/a/a1/p/p2/servers/7',
      );
    });

    testWidgets('ONB-037 with "All projects" the create wizard asks for the '
        'project first', (tester) async {
      await tester.pumpWidget(
        testApp(
          CreateWizard(
            title: 'Create',
            projectStep: const WizardStep(title: 'Project', child: Text('p')),
            steps: const [WizardStep(title: 'Name', child: Text('n'))],
            summary: const Text('s'),
            onCreate: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('STEP 1 OF 3'), findsOneWidget);
      expect(find.text('Project'), findsOneWidget);
    });

    testWidgets('a deleted scope falls back to the start', (tester) async {
      await pumpFalco(tester, FakeCloud(), accounts: [acmeTwo]);
      const ProjectRoute(
        accountId: 'a1',
        projectId: 'gone',
      ).go(tester.element(find.byType(Scaffold).first));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text('prod'), findsOneWidget);
    });
  });
}
