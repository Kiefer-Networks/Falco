// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert';
import 'dart:io';

import 'package:falco/app/router.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/main.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'fake_cloud.dart';

Widget app(List<bool> answers) => ProviderScope(
  overrides: [
    authenticatorProvider.overrideWithValue((_) async => answers.removeAt(0)),
  ],
  child: const FalcoApp(),
);

void main() {
  setUp(() => seedSecrets(const []));

  testWidgets('without account the app starts dark in the setup (ONB-006)', (
    tester,
  ) async {
    await tester.pumpWidget(app([true]));
    await tester.pumpAndSettle();
    expect(find.text('Add account'), findsOneWidget);
    expect(find.text('Design system'), findsNothing);
    final context = tester.element(find.text('Add account'));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(FalcoColors.of(context).accent, AccentPreset.amber.dark);
  });

  testWidgets('stays locked until authentication succeeds', (tester) async {
    await tester.pumpWidget(app([false, true]));
    await tester.pumpAndSettle();
    expect(find.text('Falco is locked.'), findsOneWidget);
    expect(find.text('Add account'), findsNothing);
    await tester.tap(find.text('Unlock'));
    await tester.pumpAndSettle();
    expect(find.text('Add account'), findsOneWidget);
  });

  testWidgets('scope routes carry the scope in the path (QRS-003)', (
    tester,
  ) async {
    expect(scopeRoute(const ProjectScope('a1', 'p1')).location, '/a/a1/p/p1');
    expect(scopeRoute(const AllProjectsScope('a1')).location, '/a/a1/all');
    expect(scopeRoute(const RobotScope('a1')).location, '/a/a1/robot');

    await tester.pumpWidget(app([true]));
    await tester.pumpAndSettle();
    scopeRoute(const RobotScope('a1'))
        .go(tester.element(find.text('Add account')));
    await tester.pumpAndSettle();
    expect(find.text('Nothing to show in this scope yet.'), findsOneWidget);
  });

  testWidgets('showcase stays reachable in debug builds', (tester) async {
    await tester.pumpWidget(app([true]));
    await tester.pumpAndSettle();
    const ShowcaseRoute().go(tester.element(find.text('Add account')));
    await tester.pumpAndSettle();
    expect(find.text('Design system'), findsOneWidget);
  });

  test('User-Agent version matches the pubspec (BUG-009)', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('version: $appVersion+'));
    expect(falcoUserAgent, startsWith('Falco/$appVersion ('));
  });

  test('English and German ARB files have the same keys', () {
    Set<String> keys(String path) =>
        (jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>).keys
            .where((k) => !k.startsWith('@'))
            .toSet();
    expect(keys('lib/l10n/app_de.arb'), keys('lib/l10n/app_en.arb'));
  });
}
