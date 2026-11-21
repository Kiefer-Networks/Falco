// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert';
import 'dart:io';

import 'package:falco/app/router.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/main.dart';
import 'package:falco/ui/ui.dart';
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
    expect(find.text('Design system'), findsNothing);
    final context = tester.element(find.text('Choose your language'));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(FalcoColors.of(context).accent, AccentPreset.amber.dark);
  });

  testWidgets('stays locked until authentication succeeds', (tester) async {
    await tester.pumpWidget(await app([false, true]));
    await tester.pumpAndSettle();
    expect(find.text('Falco is locked.'), findsOneWidget);
    expect(find.text('Choose your language'), findsNothing);
    await tester.tap(find.text('Unlock'));
    await tester.pumpAndSettle();
    expect(find.text('Choose your language'), findsOneWidget);
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
    expect(find.widgetWithText(Tab, 'Servers'), findsOneWidget);
    expect(find.text('Robot'), findsWidgets);
  });

  testWidgets('showcase stays reachable in debug builds', (tester) async {
    await tester.pumpWidget(await app([true]));
    await tester.pumpAndSettle();
    const ShowcaseRoute().go(tester.element(find.text('Choose your language')));
    await tester.pumpAndSettle();
    expect(find.text('Design system'), findsOneWidget);
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
