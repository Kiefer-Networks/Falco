// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:async';

import 'package:falco/app/lock_gate.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/features/storage/transfers.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerFontLicenses();
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    retry: retryDelay,
    overrides: [preferencesProvider.overrideWithValue(prefs)],
  );
  // The lock closes the vault before any background read; then pick up
  // transfers that went on while Falco was closed.
  final transfers = (container..read(appLockProvider)).read(transfersProvider);
  unawaited(transfers.start());
  runApp(
    UncontrolledProviderScope(container: container, child: const FalcoApp()),
  );
}

/// Falco texts plus the Material, Cupertino and widgets texts of
/// `material_ui`. The generated `AppLocalizations.localizationsDelegates`
/// name the Material texts of `flutter_localizations`, which `material_ui`
/// widgets do not read: German would fail with "No MaterialLocalizations".
const falcoLocalizationsDelegates = <LocalizationsDelegate<Object?>>[
  AppLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
];

/// Root widget: theme, l10n, app lock and router.
class FalcoApp extends ConsumerWidget {
  /// Creates the app.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only what the app frame shows: the lock or default account settings
    // do not rebuild every screen.
    final (variant, accent, language) = ref.watch(
      appSettingsProvider.select((s) => (s.variant, s.accent, s.language)),
    );
    // Null variant follows the system: light by day, dark by night.
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: falcoTheme(variant: variant ?? FalcoVariant.light, accent: accent),
      darkTheme: falcoTheme(
        variant: variant ?? FalcoVariant.dark,
        accent: accent,
      ),
      themeMode: variant == null ? ThemeMode.system : ThemeMode.light,
      locale: language == null ? null : Locale(language),
      localizationsDelegates: falcoLocalizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => LockGate(child: child!),
    );
  }
}
