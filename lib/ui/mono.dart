// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/falco_scaffold.dart';
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:falco/ui/theme/falco_text.dart';
import 'package:falco/ui/theme/tokens.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Machine values (IPs, IDs, sizes) in IBM Plex Mono.
class Mono extends StatelessWidget {
  /// Shows [text] in the mono style.
  const new(this.text, {this.style, this.maxLines = 1, super.key});

  /// Value to show.
  final String text;

  /// Overrides merged into the theme mono style (size, color).
  final TextStyle? style;

  /// Maximum lines before ellipsis.
  final int maxLines;

  @override
  Widget build(BuildContext context) => Text(
    text,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: FalcoText.of(context).mono.merge(style),
  );
}

/// A mono value that copies itself on tap and confirms with a snackbar.
/// Use for IPs, IDs and other values that are not secret; secrets use
/// `SecretReveal`.
class CopyableValue extends StatelessWidget {
  /// Shows [value], copying [copyText] (defaults to [value]) on tap.
  const new(this.value, {this.copyText, super.key});

  /// Displayed value.
  final String value;

  /// Raw value placed on the clipboard if it differs from [value].
  final String? copyText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = FalcoColors.of(context);
    return Semantics(
      button: true,
      label: l10n.copyValue(value),
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(FalcoRadius.small),
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: copyText ?? value));
          if (context.mounted) FalcoScaffold.showSnack(context, l10n.copied);
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: kFalcoMinTouchTarget),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Mono(value, style: TextStyle(color: c.text)),
              ),
              const SizedBox(width: 8),
              Icon(Icons.content_copy, size: 16, color: c.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
