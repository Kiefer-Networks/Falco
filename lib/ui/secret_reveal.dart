// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/clipboard/sensitive_clipboard.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/falco_scaffold.dart';
import 'package:falco/ui/mono.dart';
import 'package:falco/ui/sheets.dart';
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:falco/ui/theme/tokens.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// A secret (password, key) hidden by default, with show/hide and copy.
/// Copying marks the clipboard as sensitive and clears it after 60 s
/// (see [SensitiveClipboard]). Keep the secret out of app state and logs;
/// pass it in only while this widget is visible.
class SecretReveal extends StatefulWidget {
  /// Creates the reveal for [secret] labelled [label].
  const new({
    required this.label,
    required this.secret,
    this.initiallyVisible = false,
    super.key,
  });

  /// Localized label, e.g. "Root password".
  final String label;

  /// The secret.
  final String secret;

  /// Starts revealed (tests).
  final bool initiallyVisible;

  @override
  State<SecretReveal> createState() => _SecretRevealState();
}

class _SecretRevealState extends State<SecretReveal> {
  late bool _visible = widget.initiallyVisible;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.only(left: 14, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.hairline),
        borderRadius: BorderRadius.circular(FalcoRadius.field),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(fontSize: 12, color: c.textSecondary),
                ),
                const SizedBox(height: 2),
                if (_visible)
                  Mono(
                    widget.secret,
                    // A private key (PEM) is several lines long.
                    maxLines: 30,
                    style: TextStyle(fontSize: 15, color: c.text),
                  )
                else
                  Semantics(
                    label: l10n.secretHidden,
                    excludeSemantics: true,
                    child: Mono(
                      '•' * 12,
                      style: TextStyle(fontSize: 15, color: c.text),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: _visible ? l10n.secretHide : l10n.secretShow,
            onPressed: () => setState(() => _visible = !_visible),
            icon: Icon(
              _visible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: c.textSecondary,
            ),
          ),
          IconButton(
            tooltip: l10n.commonCopy,
            onPressed: () async {
              final marked = await SensitiveClipboard.copy(widget.secret);
              if (context.mounted) {
                final s = SensitiveClipboard.expiry.inSeconds;
                FalcoScaffold.showSnack(
                  context,
                  marked ? l10n.copiedSensitive(s) : l10n.copiedPlain(s),
                );
              }
            },
            icon: Icon(Icons.content_copy, color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Shows one time secrets (a root password, a console login) in a sheet:
/// [note] explains them, each entry is a [SecretReveal]. [onSave] adds
/// "Save to file" (a generated private key). Without [dismissible] only
/// the close button ends the sheet.
Future<void> showSecretSheet(
  BuildContext context, {
  required String title,
  required String note,
  required Map<String, String> secrets,
  Future<void> Function()? onSave,
  bool dismissible = true,
}) => showFalcoSheet<void>(
  context,
  dismissible: dismissible,
  Builder(
    builder: (context) => SheetFrame(
      title: title,
      children: [
        Text(note, style: Theme.of(context).textTheme.bodyLarge),
        for (final MapEntry(key: label, value: secret) in secrets.entries)
          SecretReveal(label: label, secret: secret),
        if (onSave != null) _SaveButton(onSave),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).commonClose),
        ),
      ],
    ),
  ),
);

/// "Save to file": disabled while a save runs (the dialog allows one at
/// a time); a failing dialog shows an error.
class _SaveButton extends StatefulWidget {
  const new(this.onSave);

  final Future<void> Function() onSave;

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool _busy = false;

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      await widget.onSave();
    } on PlatformException {
      if (mounted) {
        FalcoScaffold.showSnack(
          context,
          AppLocalizations.of(context).actionFailed,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: _busy ? null : _save,
    icon: const Icon(Icons.save_alt),
    label: Text(AppLocalizations.of(context).commonSaveToFile),
  );
}
