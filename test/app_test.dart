// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert';
import 'dart:io';

import 'package:falco/app/areas.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/main.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'fake_cloud.dart';

Future<Widget> app(List<bool> answers) async => ProviderScope(
  overrides: [
    preferencesProvider.overrideWithValue(await testPrefs()),
    authenticatorProvider.overrideWithValue((_) async => answers.removeAt(0)),
  ],
  child: const FalcoApp(),
);

void main() {
  setUp(() => seedSecrets(const []));

  testWidgets('without account the app starts dark in the welcome pages '
      '(ONB-006)', (tester) async {
    await tester.pumpWidget(await app([true]));
    await tester.pumpAndSettle();
    expect(find.text('Choose your language'), findsOneWidget);
    final context = tester.element(find.text('Choose your language'));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(FalcoColors.of(context).accent, AccentPreset.amber.dark);
  });

  testWidgets('stays locked until authentication succeeds', (tester) async {
    seedSecrets(const [Account(id: 'a1', name: 'Acme')]);
    await tester.pumpWidget(await app([false, true]));
    await tester.pumpAndSettle();
    expect(find.text('Falco is locked.'), findsOneWidget);
    expect(find.byType(ProjectSetupPage), findsNothing);
    await tester.tap(find.text('Unlock'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectSetupPage), findsOneWidget);
  });

  testWidgets('a cancelled prompt is not asked again on return, a lock '
      'keeps the page (L1, L5)', (tester) async {
    seedSecrets(const [Account(id: 'a1', name: 'Acme')]);
    final answers = [false, true];
    await tester.pumpWidget(await app(answers));
    await tester.pumpAndSettle();
    // The resume that ends the cancelled system prompt.
    tester.binding
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
      ..handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(answers, [true]);
    expect(find.text('Falco is locked.'), findsOneWidget);
    await tester.tap(find.text('Unlock'));
    await tester.pumpAndSettle();
    final page = tester.element(find.byType(ProjectSetupPage));

    // Back from background after the auto lock time: locked, page kept.
    final container = ProviderScope.containerOf(page);
    final lock = container.read(appLockProvider.notifier);
    var now = DateTime(2026);
    lock.now = () => now;
    answers.add(true);
    [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ].forEach(tester.binding.handleAppLifecycleStateChanged);
    now = now.add(const Duration(hours: 1));
    [
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ].forEach(tester.binding.handleAppLifecycleStateChanged);
    await tester.pumpAndSettle();
    expect(answers, isEmpty, reason: 'a real lock asks at once');
    expect(tester.element(find.byType(ProjectSetupPage)), same(page));
  });

  testWidgets('SET-011 while locked back stays on the cover and snackbars '
      'stay below it (K10, K11)', (tester) async {
    seedSecrets(const [Account(id: 'a1', name: 'Acme')]);
    final answers = [true, false];
    await tester.pumpWidget(await app(answers));
    await tester.pumpAndSettle();
    final page = tester.element(find.byType(ProjectSetupPage));
    final lock = ProviderScope.containerOf(page).read(appLockProvider.notifier);
    var now = DateTime(2026);
    lock.now = () => now;
    [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ].forEach(tester.binding.handleAppLifecycleStateChanged);
    now = now.add(const Duration(hours: 1));
    // Android passes inactive on the way back: already covered (L5), the
    // prompt waits for resumed.
    [
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
    ].forEach(tester.binding.handleAppLifecycleStateChanged);
    await tester.pump();
    expect(find.text('Falco is locked.'), findsOneWidget);
    expect(answers, [false]);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(answers, isEmpty);
    expect(find.text('Falco is locked.'), findsOneWidget);

    expect(await tester.binding.handlePopRoute(), isTrue);
    await tester.pumpAndSettle();
    expect(tester.element(find.byType(ProjectSetupPage)), same(page));

    FalcoScaffold.showSnack(page, 'Saved');
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsOneWidget, reason: 'not on the cover');
    expect(find.text('Saved').hitTestable(), findsNothing);
  });

  testWidgets('L9 while locked the system handles back, so a predictive '
      'back gesture never reaches the pages', (tester) async {
    seedSecrets(const [Account(id: 'a1', name: 'Acme')]);
    await tester.pumpWidget(await app([true, false]));
    await tester.pumpAndSettle();
    final page = tester.element(find.byType(ProjectSetupPage));
    final frameworkBack = <Object?>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'SystemNavigator.setFrameworkHandlesBack') {
          frameworkBack.add(call.arguments);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    Navigator.of(page)
        .push(MaterialPageRoute<void>(builder: (_) => const Scaffold()));
    await tester.pumpAndSettle();
    expect(frameworkBack.last, isTrue);
    final lock = ProviderScope.containerOf(page).read(appLockProvider.notifier);
    var now = DateTime(2026);
    lock.now = () => now;
    [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ].forEach(tester.binding.handleAppLifecycleStateChanged);
    now = now.add(const Duration(hours: 1));
    [
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ].forEach(tester.binding.handleAppLifecycleStateChanged);
    await tester.pumpAndSettle();
    expect(find.text('Falco is locked.'), findsOneWidget);
    expect(frameworkBack.last, isFalse);
  });

  testWidgets('L6 names the accounts whose access data the system deleted', (
    tester,
  ) async {
    seedSecrets(const [
      Account(
        id: 'a1',
        name: 'Acme',
        projects: [Project(id: 'p1', name: 'P')],
      ),
      Account(id: 'a2', name: 'Other', hasRobot: true),
    ]);
    await tester.pumpWidget(await app([true]));
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(Navigator).first);
    ProviderScope.containerOf(context).read(secretStoreProvider).lost.value = {
      'cloud.p1',
    };
    await tester.pumpAndSettle();
    expect(find.text('Access data deleted'), findsOneWidget);
    expect(find.textContaining('again for: Acme.'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Access data deleted'), findsNothing);
  });

  testWidgets('SET-023 the first start asks for no unlock', (tester) async {
    final answers = [false];
    await tester.pumpWidget(await app(answers));
    await tester.pumpAndSettle();
    expect(find.text('Falco is locked.'), findsNothing);
    expect(find.text('Choose your language'), findsOneWidget);
    expect(answers, [false]);
  });

  testWidgets('scope routes carry the scope in the path (QRS-003, BUG-007)', (
    tester,
  ) async {
    expect(scopeRoute(const ProjectScope('a1', 'p1')).location, '/a/a1/p/p1');
    expect(scopeRoute(const AllProjectsScope('a1')).location, '/a/a1/all');
    expect(scopeRoute(const RobotScope('a1')).location, '/a/a1/robot');

    seedSecrets(const [Account(id: 'a1', name: 'Acme', hasRobot: true)]);
    await tester.pumpWidget(await app([true]));
    await tester.pumpAndSettle();
    // A Robot only account opens its Robot area.
    expect(find.byType(AreaOverviewPage), findsOneWidget);
    expect(find.text('Robot'), findsWidgets);
  });

  test('SET-026 every permission the plugins use is declared with a '
      'usage text, so iOS cannot end the app for a missing one', () {
    final plist = File('ios/Runner/Info.plist').readAsStringSync();
    final de = File('ios/Runner/de.lproj/InfoPlist.strings').readAsStringSync();
    for (final key in [
      // local_auth: Face ID.
      'NSFaceIDUsageDescription',
      // file_picker and share_plus link the photo library APIs.
      'NSPhotoLibraryUsageDescription',
      'NSPhotoLibraryAddUsageDescription',
    ]) {
      expect(
        plist,
        matches(RegExp('<key>$key</key>\\s*<string>[^<]+</string>')),
        reason: key,
      );
      expect(de, contains('"$key" = "'), reason: key);
    }
    final manifest = File('android/app/src/main/AndroidManifest.xml')
        .readAsStringSync();
    for (final permission in [
      'INTERNET',
      'POST_NOTIFICATIONS',
      'RUN_USER_INITIATED_JOBS',
      'FOREGROUND_SERVICE_DATA_SYNC',
    ]) {
      expect(manifest, contains('android.permission.$permission"'));
    }
    expect(
      manifest,
      matches(RegExp(r'WRITE_EXTERNAL_STORAGE"\s*android:maxSdkVersion="28"')),
    );
  });

  test('User-Agent version matches the pubspec (BUG-009)', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('version: $appVersion+'));
    expect(falcoUserAgent, startsWith('Falco/$appVersion ('));
  });

  test('SET-005 BUG-020 only complete languages: English and German, with '
      'the same keys', () {
    expect(AppLocalizations.supportedLocales, const [
      Locale('de'),
      Locale('en'),
    ]);
    expect(
      Directory('lib/l10n')
          .listSync()
          .map((f) => f.path)
          .where((p) => p.endsWith('.arb')),
      unorderedEquals(['lib/l10n/app_de.arb', 'lib/l10n/app_en.arb']),
    );
    Set<String> keys(String path) =>
        (jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>).keys
            .where((k) => !k.startsWith('@'))
            .toSet();
    expect(keys('lib/l10n/app_de.arb'), keys('lib/l10n/app_en.arb'));
  });

  test('SET-005 iOS asks for Face ID in German too', () {
    final strings = File('ios/Runner/de.lproj/InfoPlist.strings')
        .readAsStringSync();
    expect(strings, contains('"NSFaceIDUsageDescription" = "Face ID'));
    final project = File('ios/Runner.xcodeproj/project.pbxproj')
        .readAsStringSync();
    expect(project, contains('path = de.lproj/InfoPlist.strings;'));
    expect(project, contains('InfoPlist.strings in Resources'));
    expect(
      File('ios/Runner/Info.plist').readAsStringSync(),
      contains('<string>de</string>'),
    );
  });
}
