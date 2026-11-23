// SPDX-License-Identifier: GPL-3.0-or-later
// Store screenshots of the main screens against the fake APIs (no real data),
// in German and English, at the phone and tablet sizes both stores accept.
// Skipped in normal runs (dart_test.yaml); generate with
//   flutter test --tags screenshots --run-skipped --update-goldens
// Output (git ignored): fastlane/metadata/android/<locale>/images/ for
// Google Play, fastlane/screenshots/<locale>/ for the App Store.
@Tags(['screenshots'])
library;

import 'package:falco/core/scope/scope.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';
import '../steps.dart' hide setSurface;
import '../storage_steps.dart';

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

final _screens = <String, (List<Account>, FakeCloud Function(), Steps)>{
  '1_servers': (const [acme], FakeCloud.new, (_, _) async {}),
  '2_server': (const [acme], FakeCloud.new, (t, _) => tap(t, 'web-1')),
  '3_firewall': (
    const [acme],
    () => FakeCloud(
      firewalls: [
        firewallJson(id: 51, name: 'web', servers: [1]),
      ],
    ),
    (t, l) async {
      await _area(t, l.navNetwork, l.resourceFirewalls);
      await tap(t, 'web');
    },
  ),
  '4_storage_box': (
    const [acme],
    storageCloud,
    (t, l) async {
      await _area(t, l.navStorage);
      await tap(t, 'backup');
    },
  ),
  '5_robot': (
    const [acmeRobot],
    FakeCloud.new,
    (t, l) async {
      await _area(t, l.navRobot);
      await tap(t, 'server1');
    },
  ),
};

void main() {
  for (final (locale, language) in [('en-US', 'en'), ('de-DE', 'de')]) {
    final l10n = lookupAppLocalizations(Locale(language));
    for (final MapEntry(key: device, value: (size, ratio, folder))
        in _devices.entries) {
      for (final MapEntry(key: name, value: (accounts, cloud, open))
          in _screens.entries) {
        testWidgets('$locale $device $name', (tester) async {
          tester.view
            ..physicalSize = size * ratio
            ..devicePixelRatio = ratio;
          addTearDown(tester.view.reset);
          await pumpFalco(
            tester,
            cloud(),
            accounts: accounts,
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
