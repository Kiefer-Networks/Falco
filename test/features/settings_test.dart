// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/http/http.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/main.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';

Future<ProviderContainer> openSettings(
  WidgetTester tester, {
  Map<String, Object> prefs = const {},
  List<bool?>? answers,
}) async {
  final c = await pumpFalco(
    tester,
    FakeCloud(),
    prefs: prefs,
    answers: answers,
  );
  await tester.tap(find.byTooltip('Settings'));
  await tester.pumpAndSettle();
  return c;
}

Future<void> choose(WidgetTester tester, String row, String option) async {
  await tester.tap(find.text(row));
  await tester.pumpAndSettle();
  await tester.tap(find.text(option).last);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('SET-001 SET-016 ONB-041 sections, pinning info and version', (
    tester,
  ) async {
    await openSettings(tester);
    for (final section in ['ACCOUNTS', 'GENERAL', 'SECURITY']) {
      expect(find.text(section), findsOneWidget, reason: section);
    }
    await tester.scrollUntilVisible(find.text('ABOUT FALCO'), 200);
    expect(find.text('Certificate pinning'), findsOneWidget);
    expect(find.text('Version $appVersion'), findsOneWidget);
  });

  testWidgets('SET-002 SET-003 theme and accent apply at once', (tester) async {
    final c = await openSettings(tester);
    await choose(tester, 'Appearance', 'Light');
    var context = tester.element(find.text('Appearance'));
    expect(Theme.of(context).brightness, Brightness.light);
    await choose(tester, 'Appearance', 'OLED');
    expect(c.read(appSettingsProvider).variant, FalcoVariant.oled);
    await choose(tester, 'Appearance', 'System');
    expect(c.read(appSettingsProvider).variant, isNull);
    await choose(tester, 'Accent', 'Blue');
    context = tester.element(find.text('Accent'));
    expect(FalcoColors.of(context).accent, AccentPreset.blue.light);
  });

  testWidgets('SET-004 the app language is independent of the system', (
    tester,
  ) async {
    final c = await openSettings(tester);
    await choose(tester, 'Language', 'Deutsch');
    expect(find.text('Einstellungen'), findsOneWidget);
    expect(c.read(preferencesProvider).getString('language'), 'de');
  });

  testWidgets('SET-008 the auto lock time is a fixed choice', (tester) async {
    final c = await openSettings(tester);
    expect(find.text('After 1 minute'), findsOneWidget);
    await choose(tester, 'Auto lock', 'After 15 minutes');
    expect(c.read(appSettingsProvider).lockTimeout, 900);
  });

  testWidgets('turning the lock off needs authentication', (tester) async {
    final c = await openSettings(tester, answers: [true, false, true]);
    await tester.tap(find.text('Unlock at start'));
    await tester.pumpAndSettle();
    expect(c.read(appSettingsProvider).lock, isTrue);
    await tester.tap(find.text('Unlock at start'));
    await tester.pumpAndSettle();
    expect(c.read(appSettingsProvider).lock, isFalse);
  });

  testWidgets('SET-014 blocking screenshots reaches the platform and the '
      'app switcher shows no content', (tester) async {
    final calls = <Object?>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('falco/screen'),
      (call) async => calls.add(call.arguments),
    );
    final c = await openSettings(tester);
    await tester.tap(find.text('Block screenshots'));
    await tester.pumpAndSettle();
    expect(calls.last, isFalse);
    expect(c.read(appSettingsProvider).secureScreen, isFalse);
    await tester.tap(find.text('Block screenshots'));
    await tester.pumpAndSettle();
    expect(calls.last, isTrue);

    // Android: FLAG_SECURE hides the app switcher, a system dialog
    // (inactive) leaves the page visible (K9).
    final page = tester.element(find.text('Settings'));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.text('Settings').hitTestable(), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    // iOS: covered already when inactive, not rebuilt: the page keeps its
    // state (L1).
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    debugDefaultTargetPlatformOverride = null;
    expect(find.text('Settings').hitTestable(), findsNothing);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.text('Settings').hitTestable(), findsOneWidget);
    expect(tester.element(find.text('Settings')), same(page));
  });

  testWidgets('SET-012 without a screen lock the app explains it', (
    tester,
  ) async {
    seedSecrets(const [Account(id: 'a1', name: 'Acme')]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesProvider.overrideWithValue(await testPrefs()),
          authenticatorProvider.overrideWithValue((_) async => null),
        ],
        child: const FalcoApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('no screen lock'), findsOneWidget);
    await tester.tap(find.text('Continue without app lock'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectSetupPage), findsOneWidget);
  });

  testWidgets('ONB-040 ONB-041 about shows version, links and licenses', (
    tester,
  ) async {
    final opened = <Uri>[];
    final original = LinkButton.open;
    LinkButton.open = (u) async => opened.add(u);
    addTearDown(() => LinkButton.open = original);
    await openSettings(tester);
    await tester.scrollUntilVisible(find.text('Version $appVersion'), 200);
    await tester.tap(find.text('About Falco').last);
    await tester.pumpAndSettle();
    expect(find.text('Version $appVersion'), findsOneWidget);
    for (final title in ['Website', 'Donate', 'Source code', 'Developer']) {
      await tester.tap(find.text(title));
    }
    await tester.tap(find.text('License'));
    expect(opened.map((u) => u.host), [
      'kiefer-networks.de',
      'de.liberapay.com',
      'github.com',
      'kiefer-networks.de',
      'www.gnu.org',
    ]);
    expect(find.text('GPL-3.0-or-later'), findsOneWidget);
    await tester.tap(find.text('Open source licenses'));
    await tester.pumpAndSettle();
    expect(find.byType(LicensePage), findsOneWidget);
  });
}
