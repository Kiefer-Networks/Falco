// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:falco/ui/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Full error state: the cause in plain words and "Try again".
/// Shown when there is no data to fall back to; otherwise use
/// [ErrorBanner].
class ErrorCard extends StatelessWidget {
  /// Shows [message] with a retry button calling [onRetry].
  const new({required this.message, this.onRetry, super.key});

  /// Localized cause.
  final String message;

  /// Retry callback; hides the button when null.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(FalcoSpacing.l),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.hairline),
        borderRadius: BorderRadius.circular(FalcoRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: c.error),
              const SizedBox(width: FalcoSpacing.s),
              Expanded(
                child: Text(
                  l10n.errorTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: FalcoSpacing.s),
          Text(message, style: theme.textTheme.bodyLarge),
          if (onRetry != null) ...[
            const SizedBox(height: FalcoSpacing.l),
            OutlinedButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
          ],
        ],
      ),
    );
  }
}

/// The one empty state: icon and one sentence. Never a button: creating
/// sits in the screen's one floating action button, so an empty list
/// never shows a second create entry.
class EmptyHint extends StatelessWidget {
  /// Shows [message] under [icon].
  const new({
    required this.message,
    this.icon = Icons.inbox_outlined,
    super.key,
  });

  /// What is empty, in one sentence.
  final String message;

  /// Icon above the message.
  final IconData icon;

  @override
  Widget build(BuildContext context) =>
      _CenteredHint(icon: icon, message: message);
}

/// A state that blocks the whole screen until the user does one thing:
/// unlock, add missing access, open a just added account. One sentence
/// and exactly one button; never used for empty lists (see [EmptyHint]).
class ActionHint extends StatelessWidget {
  /// Shows [message] with the button [actionLabel].
  const new({
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.icon = Icons.info_outline,
    super.key,
  });

  /// What blocks the screen, in one sentence.
  final String message;

  /// Label of the one action.
  final String actionLabel;

  /// Action callback.
  final VoidCallback onAction;

  /// Icon above the message.
  final IconData icon;

  @override
  Widget build(BuildContext context) => _CenteredHint(
    icon: icon,
    message: message,
    action: FilledButton(onPressed: onAction, child: Text(actionLabel)),
  );
}

class _CenteredHint extends StatelessWidget {
  const new({required this.icon, required this.message, this.action});

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FalcoSpacing.l,
        vertical: FalcoSpacing.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: c.textMuted),
          const SizedBox(height: FalcoSpacing.m),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
          if (action case final action?) ...[
            const SizedBox(height: FalcoSpacing.l),
            action,
          ],
        ],
      ),
    );
  }
}

/// Error banner above data that is still shown (stale data).
class ErrorBanner extends StatelessWidget {
  /// Shows [message]; a retry icon appears when [onRetry] is set.
  const new({required this.message, this.onRetry, super.key});

  /// Localized message.
  final String message;

  /// Retry callback.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.only(left: FalcoSpacing.m),
        decoration: BoxDecoration(
          color: c.surface,
          border: Border.all(color: c.error),
          borderRadius: BorderRadius.circular(FalcoRadius.field),
        ),
        child: Row(
          children: [
            Icon(Icons.cloud_off, size: 18, color: c.error),
            const SizedBox(width: FalcoSpacing.s),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: FalcoSpacing.m),
                child: Text(
                  message,
                  style: TextStyle(fontSize: 13, color: c.text),
                ),
              ),
            ),
            if (onRetry != null)
              IconButton(
                tooltip: l10n.commonRetry,
                onPressed: onRetry,
                icon: Icon(Icons.refresh, color: c.text),
              ),
          ],
        ),
      ),
    );
  }
}
