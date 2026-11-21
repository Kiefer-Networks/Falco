// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:falco/ui/theme/falco_text.dart';
import 'package:falco/ui/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

/// One step of a [CreateWizard].
@immutable
class WizardStep {
  /// Creates a step.
  const new({
    required this.title,
    required this.child,
    this.canContinue = true,
  });

  /// Localized step title.
  final String title;

  /// Step content (pick cards, fields).
  final Widget child;

  /// Enables "Next" (or "Create" on the summary).
  final bool canContinue;
}

/// The one create pattern: a full screen wizard with steps, a summary and
/// "Create". Pass [projectStep] only when the scope is "All projects"; it
/// becomes the first step.
class CreateWizard extends StatefulWidget {
  /// Creates a wizard.
  const new({
    required this.title,
    required this.steps,
    required this.summary,
    required this.onCreate,
    this.projectStep,
    this.createLabel,
    this.creating = false,
    this.initialStep = 0,
    super.key,
  });

  /// Screen title, e.g. "Create server".
  final String title;

  /// Steps before the summary.
  final List<WizardStep> steps;

  /// Summary content shown as the last step.
  final Widget summary;

  /// Called by the create button.
  final VoidCallback? onCreate;

  /// Project picker for scope "All projects".
  final WizardStep? projectStep;

  /// Create button label; defaults to "Create".
  final String? createLabel;

  /// Shows progress on the create button.
  final bool creating;

  /// Step to open at (showcase and tests).
  final int initialStep;

  @override
  State<CreateWizard> createState() => _CreateWizardState();
}

class _CreateWizardState extends State<CreateWizard> {
  late int _index = widget.initialStep;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = FalcoColors.of(context);
    final steps = [
      ?widget.projectStep,
      ...widget.steps,
      WizardStep(title: l10n.wizardSummary, child: widget.summary),
    ];
    final index = _index.clamp(0, steps.length - 1);
    final step = steps[index];
    final last = index == steps.length - 1;

    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(color: c.text),
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(value: (index + 1) / steps.length),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Text(
              l10n.wizardStep(index + 1, steps.length).toUpperCase(),
              style: FalcoText.of(context).sectionLabel,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Semantics(
              header: true,
              child: Text(
                step.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(FalcoSpacing.l),
              child: step.child,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            spacing: FalcoSpacing.s,
            children: [
              if (index > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _index = index - 1),
                    child: Text(l10n.commonBack),
                  ),
                ),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: !step.canContinue || widget.creating
                      ? null
                      : last
                      ? widget.onCreate
                      : () => setState(() => _index = index + 1),
                  child: widget.creating
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          last
                              ? widget.createLabel ?? l10n.commonCreate
                              : l10n.commonNext,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
