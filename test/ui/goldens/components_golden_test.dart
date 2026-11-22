// SPDX-License-Identifier: GPL-3.0-or-later
// Goldens are rendered on macOS; CI runs them only on the macOS job.
@Tags(['golden'])
library;

import 'package:falco/ui/ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers.dart';
import 'component_cases.dart';

const _width = 390.0;

// PARITY rows a component golden covers.
const _parity = {
  'error_card': 'QRS-005',
  'resource_list_error': 'QRS-005',
  'resource_list_loading': 'QRS-006',
  'empty_hint': 'QRS-007',
  'resource_list_empty': 'QRS-007',
  'status_badge_running': 'QRS-011',
  'detail_page': 'QRS-012',
  'create_wizard_step': 'QRS-013',
  'metric_chart_multi': 'QRS-014',
};

void main() {
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
        testWidgets('${c.id} ${_parity[c.id] ?? ''}'.trim(), (tester) async {
          await pumpCase(tester, c, variant);
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('${c.id}_${variant.name}.png'),
          );
        });
      }

      testWidgets('more_menu_open QRS-008', (tester) async {
        final c = showcaseCases().firstWhere((c) => c.id == 'falco_scaffold');
        await pumpCase(tester, c, variant);
        await tester.tap(find.byTooltip('More actions'));
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('more_menu_open_${variant.name}.png'),
        );
      });

      testWidgets('detail_more_sheet QRS-008 QRS-030', (tester) async {
        final c = showcaseCases().firstWhere((c) => c.id == 'detail_page');
        await pumpCase(tester, c, variant);
        await tester.tap(find.byTooltip('More actions'));
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('detail_more_sheet_${variant.name}.png'),
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
