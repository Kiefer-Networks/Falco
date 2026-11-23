// SPDX-License-Identifier: GPL-3.0-or-later
// Store screenshots of the main screens against the fake APIs (no real data),
// in German and English, at the phone and tablet sizes both stores accept.
// Skipped in normal runs (dart_test.yaml); generate with
//   flutter test --tags screenshots --run-skipped --update-goldens
// Output (git ignored): fastlane/metadata/android/<locale>/images/ for
// Google Play, fastlane/screenshots/<locale>/ for the App Store.
@Tags(['screenshots'])
library;

import 'package:falco/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';
import '../steps.dart' hide setSurface;
import 'demo_data.dart';

typedef Steps = Future<void> Function(WidgetTester, AppLocalizations);

/// Logical size, pixel ratio and output folder (with {locale}) per device.
const _devices = <String, (Size, double, String)>{
  // 1080 x 1920
  'phone': (
    Size(360, 640),
    3,
    'fastlane/metadata/android/{locale}/images/phoneScreenshots',
  ),
  // 1600 x 2560
  'tablet': (
    Size(800, 1280),
    2,
    'fastlane/metadata/android/{locale}/images/tenInchScreenshots',
  ),
  // 1290 x 2796, iPhone 6.7" and 6.9" slot
  'iphone': (Size(430, 932), 3, 'fastlane/screenshots/{locale}'),
  // 2048 x 2732, iPad 12.9" and 13" slot
  'ipad': (Size(1024, 1366), 2, 'fastlane/screenshots/{locale}'),
};

Future<void> _area(WidgetTester tester, String name, [String? tab]) async {
  await tap(tester, name);
  if (tab != null) await openList(tester, tab);
}

/// Scrolls section [title] of a detail page to the top on short phones,
/// where it would start below the fold.
Future<void> _section(WidgetTester tester, String title) async {
  final view = tester.view;
  if (view.physicalSize.height / view.devicePixelRatio > 700) return;
  await Scrollable.ensureVisible(
    tester.element(find.text(title.toUpperCase())),
  );
  await tester.pumpAndSettle();
}

final _screens = <String, Steps>{
  // A wide layout shows a detail pane next to the overview: fill it.
  '1_overview': (t, l) async {
    if (find.text(l.detailPick).evaluate().isNotEmpty) await tap(t, 'db-1');
  },
  '2_server': (t, _) => tap(t, 'web-1'),
  '3_firewall': (t, l) async {
    await _area(t, l.navNetwork, l.resourceFirewalls);
    await tap(t, 'web');
  },
  '4_dns_zone': (t, l) async {
    await _area(t, l.navNetwork, l.resourceZones);
    await tap(t, 'example.com');
    await _section(t, l.sectionRecords);
  },
  '5_storage_box': (t, l) async {
    await _area(t, l.navStorage, l.resourceStorageBoxes);
    await tap(t, 'backup');
  },
  '6_robot': (t, l) async {
    await _area(t, l.navRobot);
    await tap(t, 'storage-1');
  },
  '7_load_balancer': (t, l) async {
    await _area(t, l.navNetwork, l.resourceLoadBalancers);
    await tap(t, 'lb-web');
  },
};

void main() {
  for (final (locale, language) in [('en-US', 'en'), ('de-DE', 'de')]) {
    final l10n = lookupAppLocalizations(Locale(language));
    for (final MapEntry(key: device, value: (size, ratio, folder))
        in _devices.entries) {
      for (final MapEntry(key: name, value: open) in _screens.entries) {
        testWidgets('$locale $device $name', (tester) async {
          tester.view
            ..physicalSize = size * ratio
            ..devicePixelRatio = ratio;
          addTearDown(tester.view.reset);
          await pumpFalco(
            tester,
            demoCloud(),
            accounts: const [acmeRobot],
            prefs: {'language': language},
          );
          await open(tester, l10n);
          final path = folder.replaceAll('{locale}', locale);
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('../../$path/${device}_$name.png'),
          );
        });
      }
    }
  }
}
