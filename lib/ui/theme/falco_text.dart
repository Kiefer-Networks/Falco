// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:material_ui/material_ui.dart';

/// Font family of IBM Plex Sans (bundled).
const String kFalcoSans = 'IBMPlexSans';

/// Font family of IBM Plex Mono (bundled).
const String kFalcoMono = 'IBMPlexMono';

/// Text styles beyond the Material [TextTheme]: mono values and the
/// uppercase section label.
@immutable
class FalcoText extends ThemeExtension<FalcoText> {
  /// Creates the styles. Prefer [FalcoText.resolve].
  const new({
    required this.mono,
    required this.monoSmall,
    required this.monoValue,
    required this.sectionLabel,
  });

  /// Styles colored with [colors].
  factory resolve(FalcoColors colors) => FalcoText(
    mono: TextStyle(
      fontFamily: kFalcoMono,
      fontSize: 13,
      height: 1.35,
      color: colors.textSecondary,
    ),
    monoSmall: TextStyle(
      fontFamily: kFalcoMono,
      fontSize: 12,
      height: 1.35,
      color: colors.textSecondary,
    ),
    monoValue: TextStyle(
      fontFamily: kFalcoMono,
      fontSize: 26,
      fontWeight: FontWeight.w500,
      height: 1.2,
      color: colors.text,
    ),
    sectionLabel: TextStyle(
      fontFamily: kFalcoSans,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.78,
      height: 1.3,
      color: colors.textSecondary,
    ),
  );

  /// IPs, IDs and other machine values (13 px).
  final TextStyle mono;

  /// Secondary mono line in list rows and axis labels (12 px).
  final TextStyle monoSmall;

  /// Large metric value (26 px).
  final TextStyle monoValue;

  /// Uppercase section heading; callers pass upper case text.
  final TextStyle sectionLabel;

  /// Styles of the current theme.
  static FalcoText of(BuildContext context) =>
      Theme.of(context).extension<FalcoText>()!;

  @override
  FalcoText copyWith({TextStyle? mono}) => FalcoText(
    mono: mono ?? this.mono,
    monoSmall: monoSmall,
    monoValue: monoValue,
    sectionLabel: sectionLabel,
  );

  @override
  FalcoText lerp(FalcoText? other, double t) =>
      other == null || t < 0.5 ? this : other;
}
