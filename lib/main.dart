// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/lock_gate.dart';
import 'package:falco/app/router.dart';
import 'package:falco/app/theme_settings.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  registerFontLicenses();
  runApp(const ProviderScope(child: FalcoApp()));
}

/// Root widget: theme, l10n, app lock and router.
class FalcoApp extends ConsumerWidget {
  /// Creates the app.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeSettingsProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: falcoTheme(variant: theme.variant, accent: theme.accent),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => LockGate(child: child!),
    );
  }
}
