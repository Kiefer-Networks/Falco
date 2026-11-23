// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/main.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Wraps [child] in a MaterialApp with the Falco theme and English l10n.
Widget testApp(Widget child, {FalcoVariant variant = FalcoVariant.dark}) =>
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: falcoTheme(variant: variant),
      locale: const Locale('en'),
      localizationsDelegates: falcoLocalizationsDelegates,
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

/// Accepts sub percent pixel differences so goldens made on macOS also
/// pass on the Linux CI runner (different font rasterization).
class TolerantComparator extends LocalFileComparator {
  new(super.testFile);

  static const double _tolerance = 0.005;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed || result.diffPercent <= _tolerance) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}

/// Installs [TolerantComparator] for the golden test file [fileName] that
/// lives in the current test's directory.
void useTolerantGoldens(String fileName) {
  final base = goldenFileComparator as LocalFileComparator;
  goldenFileComparator = TolerantComparator(base.basedir.resolve(fileName));
}
