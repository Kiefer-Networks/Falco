// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/ui/ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_settings.g.dart';

/// Surface variant and accent of the app. Not persisted yet (Phase 3).
@Riverpod(keepAlive: true)
class ThemeSettings extends _$ThemeSettings {
  @override
  ({FalcoVariant variant, AccentPreset accent}) build() =>
      (variant: FalcoVariant.dark, accent: AccentPreset.amber);

  /// Changes variant and accent.
  void set(FalcoVariant variant, AccentPreset accent) =>
      state = (variant: variant, accent: accent);
}
