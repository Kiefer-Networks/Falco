// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/ui/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Semantic color tokens of the Falco design system.
///
/// Read them with [FalcoColors.of]. Components never use raw colors.
@immutable
class FalcoColors extends ThemeExtension<FalcoColors> {
  /// Creates a token set. Prefer [FalcoColors.resolve].
  const new({
    required this.background,
    required this.surface,
    required this.surfaceSelected,
    required this.navBar,
    required this.hairline,
    required this.divider,
    required this.text,
    required this.textBody,
    required this.textSecondary,
    required this.textMuted,
    required this.handle,
    required this.scrim,
    required this.accent,
    required this.onAccent,
    required this.running,
    required this.off,
    required this.error,
    required this.onError,
    required this.info,
    required this.sparkline,
  });

  /// Token set for [variant] with the [accent] preset.
  factory resolve(FalcoVariant variant, AccentPreset accent) {
    final tone = accent.tone(variant.brightness);
    switch (variant) {
      case FalcoVariant.light:
        return FalcoColors(
          background: const Color(0xFFF4F2EE),
          surface: const Color(0xFFFFFFFF),
          surfaceSelected: const Color(0xFFEEEAE4),
          navBar: const Color(0xFFFBFAF7),
          hairline: const Color(0xFFE2DED7),
          divider: const Color(0xFFEEEAE4),
          text: const Color(0xFF15181B),
          textBody: const Color(0xFF3A3F45),
          textSecondary: const Color(0xFF5B6168),
          textMuted: const Color(0xFF61676E),
          handle: const Color(0xFFD8D3CB),
          scrim: const Color(0x8A15181B),
          accent: tone,
          onAccent: const Color(0xFFFFFFFF),
          running: const Color(0xFF1E7F4F),
          off: const Color(0xFF6B7178),
          error: const Color(0xFFB3261E),
          onError: const Color(0xFFFFFFFF),
          info: const Color(0xFF1F6FB2),
          sparkline: const Color(0xFF8A9096),
        );
      case FalcoVariant.dark:
      case FalcoVariant.oled:
        final oled = variant == FalcoVariant.oled;
        return FalcoColors(
          background: oled ? const Color(0xFF000000) : const Color(0xFF0F1113),
          surface: oled ? const Color(0xFF0B0C0D) : const Color(0xFF16191C),
          surfaceSelected: const Color(0xFF262B30),
          navBar: oled ? const Color(0xFF000000) : const Color(0xFF121417),
          hairline: oled ? const Color(0xFF22262A) : const Color(0xFF2A2F35),
          divider: oled ? const Color(0xFF16191C) : const Color(0xFF1F2327),
          text: const Color(0xFFE8E6E1),
          textBody: const Color(0xFFC9CCD0),
          textSecondary: const Color(0xFF9AA0A6),
          textMuted: const Color(0xFF7D838A),
          handle: const Color(0xFF3A4046),
          scrim: const Color(0x9E050607),
          accent: tone,
          onAccent: const Color(0xFF15120C),
          running: const Color(0xFF4CC38A),
          off: const Color(0xFF7D838A),
          error: const Color(0xFFF28B82),
          onError: const Color(0xFF15120C),
          info: const Color(0xFF5FB3F0),
          sparkline: const Color(0xFF6B7178),
        );
    }
  }

  /// Screen background.
  final Color background;

  /// Cards, tiles, sheets.
  final Color surface;

  /// Selected segment background.
  final Color surfaceSelected;

  /// Bottom navigation background.
  final Color navBar;

  /// Hairline borders of cards and chips.
  final Color hairline;

  /// Divider between list rows.
  final Color divider;

  /// Primary text.
  final Color text;

  /// Body copy in sheets (slightly softer than [text]).
  final Color textBody;

  /// Secondary text, labels, mono lines.
  final Color textSecondary;

  /// Axis labels and hints.
  final Color textMuted;

  /// Sheet drag handle.
  final Color handle;

  /// Modal scrim.
  final Color scrim;

  /// Accent of the chosen preset.
  final Color accent;

  /// Foreground on [accent].
  final Color onAccent;

  /// Status: running.
  final Color running;

  /// Status: off.
  final Color off;

  /// Status: error, destructive actions.
  final Color error;

  /// Foreground on [error].
  final Color onError;

  /// Informational tone, second chart series.
  final Color info;

  /// Sparkline stroke in list rows.
  final Color sparkline;

  /// Status: action in progress (always the accent).
  Color get progress => accent;

  /// Tokens of the current theme.
  static FalcoColors of(BuildContext context) =>
      Theme.of(context).extension<FalcoColors>()!;

  @override
  FalcoColors copyWith({Color? accent, Color? onAccent}) => FalcoColors(
    background: background,
    surface: surface,
    surfaceSelected: surfaceSelected,
    navBar: navBar,
    hairline: hairline,
    divider: divider,
    text: text,
    textBody: textBody,
    textSecondary: textSecondary,
    textMuted: textMuted,
    handle: handle,
    scrim: scrim,
    accent: accent ?? this.accent,
    onAccent: onAccent ?? this.onAccent,
    running: running,
    off: off,
    error: error,
    onError: onError,
    info: info,
    sparkline: sparkline,
  );

  // ponytail: theme switches snap instead of interpolating each token;
  // interpolate when animated theme changes matter.
  @override
  FalcoColors lerp(FalcoColors? other, double t) =>
      other == null || t < 0.5 ? this : other;
}
