// SPDX-License-Identifier: GPL-3.0-or-later
// Steps and data of the Storage area tests (widget, golden, integration).
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'fake_cloud.dart';
import 'network_steps.dart';
import 'steps.dart';

export 'network_steps.dart' show enter, tile, typeName;

/// A strong password of the Storage Box policy; made up.
const boxPassword = 'Fake-Passw0rd!x';

/// A project with box `backup` (one snapshot, one subaccount) and bucket
/// `media` in fsn1 with a folder and two objects.
FakeCloud storageCloud() => FakeCloud(
  storage: FakeStorage(
    boxes: [
      storageBoxJson(
        id: 41,
        name: 'backup',
        plan: {
          'max_snapshots': 7,
          'minute': 30,
          'hour': 3,
          'day_of_week': null,
          'day_of_month': null,
        },
      ),
      storageBoxJson(id: 42, name: 'archive', protect: true),
    ],
    snapshots: {
      41: [boxSnapshotJson(id: 61, box: 41, description: 'before upgrade')],
    },
    subaccounts: {
      41: [subaccountJson(id: 71, box: 41, description: 'nas')],
    },
    buckets: {
      'fsn1': {
        'media': FakeBucket(
          objects: {
            'docs/': FakeObject(0),
            'docs/a.txt': FakeObject(12),
            'logo.png': FakeObject(2048),
            'notes.txt': FakeObject(64),
          },
        ),
      },
      'hel1': {'logs': FakeBucket()},
    },
  ),
);

/// Opens [tab] of the Storage area.
Future<FakeCloud> openStorage(
  WidgetTester tester,
  String tab, {
  FakeCloud? cloud,
  bool s3 = true,
}) async {
  final c = cloud ?? storageCloud();
  setSurface(tester);
  // English whatever the device language is.
  await pumpFalco(tester, c, s3: s3, prefs: const {'language': 'en'});
  await tester.tap(find.text('Storage'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(Tab, tab));
  await tester.pumpAndSettle();
  return c;
}

/// Picks option [label] of form field [key].
Future<void> chip(WidgetTester tester, String key, String label) async {
  final f = find.descendant(
    of: find.byKey(ValueKey(key)),
    matching: find.text(label),
  );
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await tester.tap(f);
  await tester.pumpAndSettle();
}

/// Enters [boxPassword] twice.
Future<void> passwords(WidgetTester tester) async {
  await enter(tester, 'password', boxPassword);
  await enter(tester, 'repeat', boxPassword);
}
