// SPDX-License-Identifier: GPL-3.0-or-later
/// The flows every Compute resource shares, so each runs one way: start
/// and track an action, save an edit, rename and relabel, protect,
/// delete, and the project step of a create wizard.
library;

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:material_ui/material_ui.dart';

/// A resource a flow acts on: project, Cloud type, id and name.
typedef Target = ({ProjectScope scope, String type, int id, String name});

/// Starts the action of [start] and hands it to the tracker, which shows
/// progress at the object and refreshes it when done. A failure becomes
/// the screen's snackbar. Returns whether the action started.
Future<bool> runAction(
  BuildContext context,
  WidgetRef ref,
  ProjectScope scope,
  Future<int> Function(cloud.Server api) start,
) async {
  final l10n = AppLocalizations.of(context);
  try {
    final id = await start(ref.read(cloudApiProvider(scope.projectId)));
    ref.read(actionTrackerProvider(scope)).track(id);
    return true;
  } on FalcoError catch (e) {
    if (context.mounted) FalcoScaffold.showSnack(context, errorText(e, l10n));
    return false;
  }
}

/// Runs a change without a Hetzner action (rename, labels, delete),
/// refreshes [t] and confirms with [done] or shows the failure.
Future<bool> runChange(
  BuildContext context,
  WidgetRef ref,
  Target t,
  Future<void> Function(cloud.Server api) change, {
  String? done,
}) async {
  final l10n = AppLocalizations.of(context);
  try {
    await change(ref.read(cloudApiProvider(t.scope.projectId)));
    refreshResource(ref.invalidate, t.scope, t.type, t.id);
    if (context.mounted) {
      FalcoScaffold.showSnack(context, done ?? l10n.savedMessage);
    }
    return true;
  } on FalcoError catch (e) {
    if (context.mounted) FalcoScaffold.showSnack(context, errorText(e, l10n));
    return false;
  }
}

/// Labels as one text field, `key=value, key2=value2`.
FieldSpec labelsField(AppLocalizations l10n, [Map<String, String>? labels]) =>
    FieldSpec(
      'labels',
      l10n.fieldLabels,
      initial: formatLabels(labels ?? const {}),
      helper: l10n.labelsHint,
    );

/// Whether the labels text of [values] is valid.
bool validLabels(Map<String, String> values) =>
    parseLabels(values['labels'] ?? '') != null;

/// The edit sheet for name and labels (rename and labels of every
/// Compute resource). [save] gets the trimmed name and parsed labels;
/// [nameLabel] renames the name field (an image's description).
Future<void> editNameAndLabels(
  BuildContext context,
  WidgetRef ref,
  Target t,
  Map<String, String> labels,
  Future<void> Function(cloud.Server api, String name, Map<String, String> l)
  save, {
  String? nameLabel,
}) {
  final l10n = AppLocalizations.of(context);
  return FormSheet.show(
    context,
    title: l10n.commonEdit,
    fields: (_) => [
      FieldSpec(
        'name',
        nameLabel ?? l10n.fieldName,
        initial: t.name,
        maxLength: 63,
      ),
      labelsField(l10n, labels),
    ],
    valid: (v) => (v['name'] ?? '').trim().isNotEmpty && validLabels(v),
    onSave: (v) async {
      await save(
        ref.read(cloudApiProvider(t.scope.projectId)),
        v['name']!.trim(),
        parseLabels(v['labels'] ?? '')!,
      );
      refreshResource(ref.invalidate, t.scope, t.type, t.id);
    },
  );
}

/// Level 2 confirmation for deleting [t] (BUG-002): type its name.
Future<bool> confirmDelete(BuildContext context, Target t, String consequence) {
  final l10n = AppLocalizations.of(context);
  return ConfirmSheet.show(
    context,
    title: l10n.deleteTitle(t.name),
    consequence: consequence,
    confirmLabel: l10n.actionDelete,
    resourceName: t.name,
    level: ConfirmLevel.typeName,
    destructive: true,
  );
}

/// Level 1 confirmation for turning delete protection of [t] on or off.
Future<bool> confirmProtection(
  BuildContext context,
  Target t, {
  required bool protect,
}) {
  final l10n = AppLocalizations.of(context);
  return ConfirmSheet.show(
    context,
    title: protect ? l10n.protectOnTitle(t.name) : l10n.protectOffTitle(t.name),
    consequence: protect
        ? l10n.protectOnConsequence
        : l10n.protectOffConsequence,
    confirmLabel: protect ? l10n.protectOn : l10n.protectOff,
    resourceName: t.name,
  );
}

/// "Yes" or "No".
String yesNo(bool value, AppLocalizations l10n) =>
    value ? l10n.commonYes : l10n.commonNo;

/// Labels for a detail page, or "None".
String labelsText(Map<String, String> labels, AppLocalizations l10n) =>
    labels.isEmpty ? l10n.commonNone : formatLabels(labels);

/// Hetzner sizes are GB; shown in the one byte format.
String gb(num gb, String locale) =>
    formatBytes((gb * 1024 * 1024 * 1024).round(), locale);

/// The project step of a create wizard for scope "All projects"; null
/// for a single project, whose wizard needs no such step.
WizardStep? projectStep(
  WidgetRef ref,
  AppLocalizations l10n,
  Scope scope,
  String? selected,
  ValueChanged<String> onSelected,
) {
  if (scope is! AllProjectsScope) return null;
  final account = ref
      .watch(accountsProvider)
      .value
      ?.where((a) => a.id == scope.accountId)
      .firstOrNull;
  return WizardStep(
    title: l10n.wizardProject,
    canContinue: selected != null,
    child: ChoiceList(
      options: {
        for (final p in account?.projects ?? const <Project>[]) p.id: p.name,
      },
      selected: selected ?? '',
      onSelected: onSelected,
    ),
  );
}

/// The project a create wizard targets: the scope's own, or the one
/// picked in [projectStep].
ProjectScope? targetScope(Scope scope, String? picked) => switch (scope) {
  ProjectScope() => scope,
  _ when picked != null => ProjectScope(scope.accountId, picked),
  _ => null,
};

/// Reloads [future]'s provider for pull to refresh; a failure shows up in
/// the provider state, not as an exception of the gesture.
Future<void> refreshQuietly(
  WidgetRef ref,
  Refreshable<Future<Object?>> future,
) async {
  try {
    final reload = ref.refresh(future);
    await reload;
  } on Object {
    // Shown by the watching widget.
  }
}

/// A detail page before its resource loaded: a spinner, or the error card
/// with retry.
class DetailLoading extends StatelessWidget {
  const new({
    required this.title,
    required this.onRetry,
    this.error,
    super.key,
  });

  final String title;
  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => FalcoScaffold(
    title: title,
    body: switch (error) {
      null => const Center(child: CircularProgressIndicator()),
      final e => Padding(
        padding: const EdgeInsets.all(FalcoSpacing.l),
        child: ErrorCard(
          message: errorText(toFalcoError(e), AppLocalizations.of(context)),
          onRetry: onRetry,
        ),
      ),
    },
  );
}

/// The delete button of a danger zone.
class DeleteButton extends StatelessWidget {
  const new({required this.onPressed, this.label, super.key});

  final VoidCallback? onPressed;

  /// Defaults to "Delete".
  final String? label;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    style: OutlinedButton.styleFrom(
      foregroundColor: FalcoColors.of(context).error,
    ),
    onPressed: onPressed,
    icon: const Icon(Icons.delete_outline),
    label: Text(label ?? AppLocalizations.of(context).actionDelete),
  );
}
