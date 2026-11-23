// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:ui';

/// Surface variants of the Falco theme.
enum FalcoVariant {
  /// Default dark theme.
  dark,

  /// Light theme.
  light,

  /// Dark theme with true black surfaces for OLED screens.
  oled;

  /// Platform brightness of this variant.
  Brightness get brightness =>
      this == light ? Brightness.light : Brightness.dark;
}

/// Accent color presets, each with a tone for dark and one for light
/// surfaces. Signal amber is the default.
enum AccentPreset {
  /// Signal amber (default).
  amber(Color(0xFFF2A33A), Color(0xFFA85F00)),

  /// Blue.
  blue(Color(0xFF5FB3F0), Color(0xFF1F6FB2)),

  /// Green.
  green(Color(0xFF4CC38A), Color(0xFF1E7F4F)),

  /// Red.
  red(Color(0xFFF28B82), Color(0xFFB3261E)),

  /// Purple.
  purple(Color(0xFFC3A6F5), Color(0xFF6E44C2)),

  /// Orange.
  orange(Color(0xFFF59E6B), Color(0xFFB4501A));

  new(this.dark, this.light);

  /// Tone used on dark and OLED surfaces.
  final Color dark;

  /// Tone used on light surfaces.
  final Color light;

  /// Tone for [brightness].
  Color tone(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;
}

/// Spacing scale in logical pixels.
abstract final class FalcoSpacing {
  /// 4
  static const double xs = 4;

  /// 8
  static const double s = 8;

  /// 12
  static const double m = 12;

  /// 16, the default screen gutter.
  static const double l = 16;

  /// 20
  static const double xl = 20;

  /// 24
  static const double xxl = 24;
}

/// Corner radii.
abstract final class FalcoRadius {
  /// Segmented controls and small chips.
  static const double small = 8;

  /// Text fields and fact boxes.
  static const double field = 12;

  /// Cards, tiles and primary buttons.
  static const double card = 14;

  /// Pills (filter chips).
  static const double pill = 18;

  /// Top corners of bottom sheets.
  static const double sheet = 24;
}

/// Minimum touch target edge in dp.
const double kFalcoMinTouchTarget = 48;

/// Window widths that change the layout (Material window size classes).
abstract final class FalcoBreakpoint {
  /// From here a navigation rail replaces the bottom bar.
  static const double rail = 600;

  /// From here lists show their detail beside them (QRS-027).
  static const double twoPane = 840;
}
