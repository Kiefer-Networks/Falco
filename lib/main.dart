// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/showcase/showcase_page.dart';
import 'package:falco/ui/ui.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  registerFontLicenses();
  runApp(const FalcoApp());
}

/// Root widget. Until features exist, the design system showcase is home.
class FalcoApp extends StatefulWidget {
  /// Creates the app.
  const new({super.key});

  @override
  State<FalcoApp> createState() => _FalcoAppState();
}

class _FalcoAppState extends State<FalcoApp> {
  FalcoVariant _variant = FalcoVariant.dark;
  AccentPreset _accent = AccentPreset.amber;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: falcoTheme(variant: _variant, accent: _accent),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ShowcasePage(
        variant: _variant,
        accent: _accent,
        onThemeChanged: (variant, accent) => setState(() {
          _variant = variant;
          _accent = accent;
        }),
      ),
    );
  }
}
