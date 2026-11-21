// SPDX-License-Identifier: GPL-3.0-or-later
// Goldens are rendered on macOS; CI runs them only on the macOS job.
@Tags(['golden'])
library;

import 'package:falco/ui/showcase/showcase_page.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers.dart';

/// Accepts sub percent pixel differences so goldens made on macOS also
/// pass on the Linux CI runner (different font rasterization).
class _TolerantComparator extends LocalFileComparator {
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

const _width = 390.0;

void main() {
  final base = goldenFileComparator as LocalFileComparator;
  goldenFileComparator = _TolerantComparator(
    base.basedir.resolve('components_golden_test.dart'),
  );

  Future<void> pumpCase(
    WidgetTester tester,
    ShowcaseCase c,
    FalcoVariant variant,
  ) async {
    setSurface(tester, Size(_width, c.height));
    await tester.pumpWidget(
      testApp(Builder(builder: c.builder), variant: variant),
    );
    await tester.pump();
  }

  for (final variant in [FalcoVariant.dark, FalcoVariant.light]) {
    group(variant.name, () {
      for (final c in showcaseCases()) {
        testWidgets(c.id, (tester) async {
          await pumpCase(tester, c, variant);
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('${c.id}_${variant.name}.png'),
          );
        });
      }

      testWidgets('more_menu_open', (tester) async {
        final c = showcaseCases().firstWhere((c) => c.id == 'falco_scaffold');
        await pumpCase(tester, c, variant);
        await tester.tap(find.byTooltip('More actions'));
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('more_menu_open_${variant.name}.png'),
        );
      });

      testWidgets('confirm_sheet_level2_matched', (tester) async {
        final c = showcaseCases().firstWhere(
          (c) => c.id == 'confirm_sheet_level2',
        );
        await pumpCase(tester, c, variant);
        await tester.enterText(find.byType(TextField), 'db-primary');
        await tester.pump(const Duration(milliseconds: 300));
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('confirm_sheet_level2_matched_${variant.name}.png'),
        );
      });
    });
  }
}
