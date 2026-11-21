// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:math' as math;

import 'package:falco/ui/ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// WCAG 2 relative luminance.
double _luminance(Color c) {
  double channel(double v) =>
      v <= 0.04045 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * channel(c.r) + 0.7152 * channel(c.g) + 0.0722 * channel(c.b);
}

/// WCAG 2 contrast ratio.
double contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  test('contrast formula matches WCAG reference values', () {
    expect(
      contrast(const Color(0xFF000000), const Color(0xFFFFFFFF)),
      closeTo(21, 0.01),
    );
    expect(
      contrast(const Color(0xFF777777), const Color(0xFFFFFFFF)),
      closeTo(4.48, 0.01),
    );
  });

  for (final variant in FalcoVariant.values) {
    for (final accent in AccentPreset.values) {
      test('${variant.name}/${accent.name} text tokens reach 4.5:1', () {
        final c = FalcoColors.resolve(variant, accent);
        final pairs = <String, (Color, Color)>{
          for (final (name, bg) in [
            ('background', c.background),
            ('surface', c.surface),
          ]) ...{
            'text on $name': (c.text, bg),
            'textBody on $name': (c.textBody, bg),
            'textSecondary on $name': (c.textSecondary, bg),
            'textMuted on $name': (c.textMuted, bg),
          },
          // Status words and accent text sit on cards, rows and sheets.
          'running on surface': (c.running, c.surface),
          'off on surface': (c.off, c.surface),
          'error on surface': (c.error, c.surface),
          'accent on surface': (c.accent, c.surface),
          'onAccent on accent': (c.onAccent, c.accent),
          'onError on error': (c.onError, c.error),
        };
        for (final MapEntry(key: name, value: (fg, bg)) in pairs.entries) {
          expect(
            contrast(fg, bg),
            greaterThanOrEqualTo(4.5),
            reason: '$name is ${contrast(fg, bg).toStringAsFixed(2)}:1',
          );
        }
      });
    }
  }
}
