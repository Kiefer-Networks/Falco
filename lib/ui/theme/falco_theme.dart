// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:falco/ui/theme/falco_text.dart';
import 'package:falco/ui/theme/tokens.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Builds the Falco [ThemeData] for [variant] and [accent].
ThemeData falcoTheme({
  FalcoVariant variant = FalcoVariant.dark,
  AccentPreset accent = AccentPreset.amber,
}) {
  final c = FalcoColors.resolve(variant, accent);
  final t = FalcoText.resolve(c);
  final brightness = variant.brightness;

  TextStyle s(double size, FontWeight weight, Color color, [double? h]) =>
      TextStyle(
        fontFamily: kFalcoSans,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: h,
      );

  final textTheme = TextTheme(
    headlineSmall: s(28, FontWeight.w600, c.text, 1.15),
    titleLarge: s(22, FontWeight.w600, c.text, 1.25),
    titleMedium: s(16, FontWeight.w600, c.text, 1.3),
    titleSmall: s(15, FontWeight.w600, c.text, 1.3),
    bodyLarge: s(15, FontWeight.w400, c.textBody, 1.45),
    bodyMedium: s(14, FontWeight.w400, c.text, 1.4),
    bodySmall: s(12, FontWeight.w400, c.textSecondary, 1.35),
    labelLarge: s(16, FontWeight.w600, c.text),
    labelMedium: s(13, FontWeight.w400, c.textSecondary),
    labelSmall: s(11, FontWeight.w400, c.textSecondary),
  );

  final scheme = ColorScheme(
    brightness: brightness,
    primary: c.accent,
    onPrimary: c.onAccent,
    secondary: c.accent,
    onSecondary: c.onAccent,
    error: c.error,
    onError: c.onError,
    surface: c.background,
    onSurface: c.text,
    onSurfaceVariant: c.textSecondary,
    surfaceContainerLowest: c.background,
    surfaceContainerLow: c.surface,
    surfaceContainer: c.surface,
    surfaceContainerHigh: c.surface,
    surfaceContainerHighest: c.surfaceSelected,
    outline: c.hairline,
    outlineVariant: c.divider,
    scrim: c.scrim,
  );

  final cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(FalcoRadius.card),
  );
  const buttonSize = Size(kFalcoMinTouchTarget, 52);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    fontFamily: kFalcoSans,
    textTheme: textTheme,
    scaffoldBackgroundColor: c.background,
    canvasColor: c.background,
    dividerColor: c.divider,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    visualDensity: VisualDensity.standard,
    extensions: [c, t],
    appBarTheme: AppBarTheme(
      backgroundColor: c.background,
      foregroundColor: c.text,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.titleMedium,
      systemOverlayStyle: brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    ),
    iconTheme: IconThemeData(color: c.text, size: 20),
    dividerTheme: DividerThemeData(color: c.divider, thickness: 1, space: 1),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.accent,
        foregroundColor: c.onAccent,
        disabledBackgroundColor: c.surfaceSelected,
        disabledForegroundColor: c.textMuted,
        minimumSize: buttonSize,
        shape: cardShape,
        textStyle: s(16, FontWeight.w600, c.onAccent),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: c.text,
        minimumSize: buttonSize,
        side: BorderSide(color: c.hairline),
        shape: cardShape,
        textStyle: s(16, FontWeight.w400, c.text),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.textSecondary,
        minimumSize: const Size(kFalcoMinTouchTarget, kFalcoMinTouchTarget),
        textStyle: s(13, FontWeight.w400, c.textSecondary),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.transparent,
      selectedColor: Colors.transparent,
      disabledColor: Colors.transparent,
      side: BorderSide(color: c.hairline),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FalcoRadius.pill),
      ),
      labelStyle: s(14, FontWeight.w400, c.textBody),
      secondaryLabelStyle: s(14, FontWeight.w600, c.accent),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 6),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.surface,
      hintStyle: s(15, FontWeight.w400, c.textMuted),
      labelStyle: s(15, FontWeight.w400, c.textSecondary),
      prefixIconColor: c.textSecondary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FalcoRadius.field),
        borderSide: BorderSide(color: c.hairline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FalcoRadius.field),
        borderSide: BorderSide(color: c.hairline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FalcoRadius.field),
        borderSide: BorderSide(color: c.accent, width: 1.5),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.surface,
      modalBackgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      modalBarrierColor: c.scrim,
      showDragHandle: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(FalcoRadius.sheet),
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: c.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FalcoRadius.field),
        side: BorderSide(color: c.hairline),
      ),
      textStyle: s(15, FontWeight.w400, c.text),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: c.text,
      contentTextStyle: s(14, FontWeight.w400, c.background),
      actionTextColor: c.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FalcoRadius.field),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: c.accent,
      linearTrackColor: c.divider,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: c.textSecondary,
      textColor: c.text,
      minTileHeight: kFalcoMinTouchTarget + 8,
    ),
  );
}
