// SPDX-License-Identifier: GPL-3.0-or-later
// Goldens of the Storage area against the fake APIs.
@Tags(['golden'])
library;

import 'package:falco/ui/ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../fake_cloud.dart';
import '../../helpers.dart';
import '../../steps.dart' hide setSurface;
import '../../storage_steps.dart';

void main() {
  Future<void> storage(WidgetTester tester, String tab) async {
    await tap(tester, 'Storage');
    await openList(tester, tab);
  }

  final screens = <String, Future<void> Function(WidgetTester)>{
    'storage_boxes': (tester) => storage(tester, 'Storage Boxes'),
    'storage_box_detail': (tester) async {
      await storage(tester, 'Storage Boxes');
      await tap(tester, 'backup');
    },
    'storage_box_sections': (tester) async {
      await storage(tester, 'Storage Boxes');
      await tap(tester, 'backup');
      await tester.scrollUntilVisible(
        find.text('u41-sub71'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
    },
    'create_storage_box_type': (tester) async {
      await storage(tester, 'Storage Boxes');
      await tap(tester, 'Create Storage Box');
      await tap(tester, 'fsn1');
      await tap(tester, 'Next');
    },
    'box_snapshot_detail': (tester) async {
      await storage(tester, 'Storage Boxes');
      await tap(tester, 'backup');
      await tap(tester, 'before upgrade');
    },
    'subaccount_detail': (tester) async {
      await storage(tester, 'Storage Boxes');
      await tap(tester, 'backup');
      await tap(tester, 'u41-sub71');
    },
    'buckets': (tester) => storage(tester, 'Object Storage'),
    'bucket_browser': (tester) async {
      await storage(tester, 'Object Storage');
      await tap(tester, 'media');
    },
    'object_menu': (tester) async {
      await storage(tester, 'Object Storage');
      await tap(tester, 'media');
      await tap(tester, 'notes.txt');
    },
  };

  // PARITY rows each golden covers.
  const ids = {
    'storage_boxes': 'STB-001',
    'storage_box_detail': 'STB-005 STB-006',
    'storage_box_sections': 'STB-013 STB-017',
    'create_storage_box_type': 'STB-002',
    'box_snapshot_detail': 'STB-035',
    'subaccount_detail': 'STB-032',
    'buckets': 'OBJ-001',
    'bucket_browser': 'OBJ-006',
    'object_menu': 'OBJ-018',
  };

  for (final variant in [FalcoVariant.light, FalcoVariant.dark]) {
    group(variant.name, () {
      for (final MapEntry(key: name, value: open) in screens.entries) {
        testWidgets('$name ${ids[name]}', (tester) async {
          setSurface(tester, const Size(390, 844));
          await pumpFalco(tester, storageCloud(), variant: variant, s3: true);
          await open(tester);
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('${name}_${variant.name}.png'),
          );
        });
      }
    });
  }
}
