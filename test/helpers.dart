// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Wraps [child] in a MaterialApp with the Falco theme and English l10n.
Widget testApp(Widget child, {FalcoVariant variant = FalcoVariant.dark}) =>
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: falcoTheme(variant: variant),
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

/// Sets a fixed logical surface of [size] at device pixel ratio 1.
void setSurface(WidgetTester tester, Size size) {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}
