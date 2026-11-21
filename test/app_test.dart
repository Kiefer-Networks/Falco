// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert';
import 'dart:io';

import 'package:falco/app/router.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/main.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget app(List<bool> answers) => ProviderScope(
  overrides: [
    authenticatorProvider.overrideWithValue((_) async => answers.removeAt(0)),
  ],
  child: const FalcoApp(),
);

void main() {
  testWidgets('app unlocks and starts dark on the showcase', (tester) async {
    await tester.pumpWidget(app([true]));
    await tester.pumpAndSettle();
    expect(find.text('Design system'), findsOneWidget);
    final context = tester.element(find.text('Design system'));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(FalcoColors.of(context).accent, AccentPreset.amber.dark);
  });

  testWidgets('stays locked until authentication succeeds', (tester) async {
    await tester.pumpWidget(app([false, true]));
    await tester.pumpAndSettle();
    expect(find.text('Falco is locked.'), findsOneWidget);
    expect(find.text('Design system'), findsNothing);
    await tester.tap(find.text('Unlock'));
    await tester.pumpAndSettle();
    expect(find.text('Design system'), findsOneWidget);
  });

  testWidgets('scope routes carry the scope in the path (QRS-003)', (
    tester,
  ) async {
    expect(scopeRoute(const ProjectScope('a1', 'p1')).location, '/a/a1/p/p1');
    expect(scopeRoute(const AllProjectsScope('a1')).location, '/a/a1/all');
    expect(scopeRoute(const RobotScope('a1')).location, '/a/a1/robot');

    await tester.pumpWidget(app([true]));
    await tester.pumpAndSettle();
    scopeRoute(const ProjectScope('a1', 'p1'))
        .go(tester.element(find.text('Design system')));
    await tester.pumpAndSettle();
    expect(find.text('Nothing to show in this scope yet.'), findsOneWidget);
  });

  test('English and German ARB files have the same keys', () {
    Set<String> keys(String path) =>
        (jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>).keys
            .where((k) => !k.startsWith('@'))
            .toSet();
    expect(keys('lib/l10n/app_de.arb'), keys('lib/l10n/app_en.arb'));
  });
}
