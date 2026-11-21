// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/lock_gate.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerFontLicenses();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [preferencesProvider.overrideWithValue(prefs)],
      child: const FalcoApp(),
    ),
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
    final s = ref.watch(appSettingsProvider);
    // Null variant follows the system: light by day, dark by night.
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: falcoTheme(
        variant: s.variant ?? FalcoVariant.light,
        accent: s.accent,
      ),
      darkTheme: falcoTheme(
        variant: s.variant ?? FalcoVariant.dark,
        accent: s.accent,
      ),
      themeMode: s.variant == null ? ThemeMode.system : ThemeMode.light,
      locale: s.language == null ? null : Locale(s.language!),
      localizationsDelegates: falcoLocalizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => LockGate(child: child!),
    );
  }
}
