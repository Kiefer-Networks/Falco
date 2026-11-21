// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert';
import 'dart:io';

import 'package:falco/main.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('app starts dark on the showcase', (tester) async {
    await tester.pumpWidget(const FalcoApp());
    await tester.pump();
    expect(find.text('Design system'), findsOneWidget);
    final context = tester.element(find.text('Design system'));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(FalcoColors.of(context).accent, AccentPreset.amber.dark);
  });

  test('English and German ARB files have the same keys', () {
    Set<String> keys(String path) =>
        (jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>).keys
            .where((k) => !k.startsWith('@'))
            .toSet();
    expect(keys('lib/l10n/app_de.arb'), keys('lib/l10n/app_en.arb'));
  });
}
