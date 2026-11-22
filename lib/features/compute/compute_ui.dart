// SPDX-License-Identifier: GPL-3.0-or-later
/// The flows every Cloud resource shares, so each runs one way: start
/// and track an action, save an edit, rename and relabel, protect,
/// delete, metrics, and the project step of a create wizard.
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
) => runActions(context, ref, scope, (api) async => [await start(api)]);

/// [runAction] for a call that starts several actions (a create and its
/// next actions); all are tracked.
Future<bool> runActions(
  BuildContext context,
  WidgetRef ref,
  ProjectScope scope,
  Future<List<int>> Function(cloud.Server api) start,
) async {
  final l10n = AppLocalizations.of(context);
  // Read before the first await: the page may be gone when it returns.
  final api = ref.read(cloudApiProvider(scope.projectId));
  final tracker = ref.read(actionTrackerProvider(scope));
  try {
    (await start(api)).forEach(tracker.track);
    return true;
  } on FalcoError catch (e) {
    if (context.mounted) FalcoScaffold.showSnack(context, errorText(e, l10n));
    return false;
  }
}

/// Starts the action of [start] from a sheet's save and tracks it; a
/// failure throws, so the sheet shows it and stays open.
Future<void> startTracked(
  WidgetRef ref,
  ProjectScope scope,
  Future<int> Function(cloud.Server api) start,
) async {
  // Read before the first await: the page may be gone when it returns.
  final api = ref.read(cloudApiProvider(scope.projectId));
  final tracker = ref.read(actionTrackerProvider(scope));
  final id = await start(api);
  tracker.track(id);
}

/// Level 1 confirmation, then [start] as a tracked action (remove,
/// detach, unassign, disable).
Future<void> confirmAction(
  BuildContext context,
  WidgetRef ref,
  ProjectScope scope, {
  required String title,
  required String consequence,
  required String label,
  required String name,
  required Future<int> Function(cloud.Server api) start,
  List<ConfirmFact> facts = const [],
  bool destructive = false,
}) async {
  final ok = await ConfirmSheet.show(
    context,
    title: title,
    consequence: consequence,
    confirmLabel: label,
    resourceName: name,
    facts: facts,
    destructive: destructive,
  );
  if (ok && context.mounted) await runAction(context, ref, scope, start);
}

/// Turns delete protection of [t] on or off after a level 1
/// confirmation.
Future<void> toggleProtection(
  BuildContext context,
  WidgetRef ref,
  Target t, {
  required bool protected,
  required Future<int> Function(cloud.Server api, bool protect) start,
}) async {
  if (await confirmProtection(context, t, protect: !protected) &&
      context.mounted) {
    await runAction(context, ref, t.scope, (api) => start(api, !protected));
  }
}

/// Deletes [t] after the level 2 confirmation and closes its page.
Future<void> deleteResource(
  BuildContext context,
  WidgetRef ref,
  Target t,
  String consequence,
  Future<void> Function(cloud.Server api) delete,
) async {
  final l10n = AppLocalizations.of(context);
  if (!await confirmDelete(context, t, consequence) || !context.mounted) {
    return;
  }
  final deleted = await runChange(
    context,
    ref,
    t,
    delete,
    done: l10n.deletedMessage(t.name),
  );
  if (deleted && context.mounted) Navigator.pop(context);
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
  // Read before the first await: the page may be gone when it returns.
  final api = ref.read(cloudApiProvider(t.scope.projectId));
  final container = ProviderScope.containerOf(context, listen: false);
  try {
    await change(api);
    refreshResource(container.invalidate, t.scope, t.type, t.id);
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

/// [fields] with their initial values taken from [values] where set, for
/// an edit sheet filled with what exists.
List<FieldSpec> prefill(List<FieldSpec> fields, Map<String, String>? values) =>
    values == null
    ? fields
    : [
        for (final f in fields)
          FieldSpec(
            f.key,
            f.label,
            initial: values[f.key] ?? f.initial,
            secret: f.secret,
            maxLength: f.maxLength,
            helper: f.helper,
            options: f.options,
            multiple: f.multiple,
            multiline: f.multiline,
          ),
      ];

/// Whether the labels text of [values] is valid.
bool validLabels(Map<String, String> values) =>
    parseLabels(values['labels'] ?? '') != null;

/// The edit sheet for name and labels (rename and labels of every
/// Compute resource). [save] gets the trimmed name and parsed labels;
/// [nameLabel] renames the name field (an image's description);
/// [maxLength] is the API's limit of the name, null for none.
Future<void> editNameAndLabels(
  BuildContext context,
  WidgetRef ref,
  Target t,
  Map<String, String> labels,
  Future<void> Function(cloud.Server api, String name, Map<String, String> l)
  save, {
  String? nameLabel,
  int? maxLength = 63,
}) {
  final l10n = AppLocalizations.of(context);
  // Read before the sheet opens: the page may be gone when it saves.
  final api = ref.read(cloudApiProvider(t.scope.projectId));
  final container = ProviderScope.containerOf(context, listen: false);
  return FormSheet.show(
    context,
    title: l10n.commonEdit,
    fields: (_) => [
      FieldSpec(
        'name',
        nameLabel ?? l10n.fieldName,
        initial: t.name,
        maxLength: maxLength,
      ),
      labelsField(l10n, labels),
    ],
    valid: (v) => (v['name'] ?? '').trim().isNotEmpty && validLabels(v),
    onSave: (v) async {
      await save(api, v['name']!.trim(), parseLabels(v['labels'] ?? '')!);
      refreshResource(container.invalidate, t.scope, t.type, t.id);
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

/// Labels for a wizard summary, or "None".
String labelsText(Map<String, String> labels, AppLocalizations l10n) =>
    labels.isEmpty ? l10n.commonNone : formatLabels(labels);

/// The labels section of a detail page.
DetailSection labelsSection(
  AppLocalizations l10n,
  Map<String, String> labels,
) => DetailSection(title: l10n.fieldLabels, child: LabelChips(labels));

/// The last section before the activity of a detail page: the ID to copy
/// and the creation date, after [more] facts (fingerprint, created from).
DetailSection detailsSection(
  AppLocalizations l10n, {
  required int id,
  DateTime? created,
  List<Fact> more = const [],
}) => DetailSection(
  title: l10n.sectionDetails,
  facts: [
    ...more,
    Fact('ID', text: '$id', copy: true),
    if (created != null) Fact(l10n.fieldCreated, time: created),
  ],
);

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

/// One entry of a detail section (a subnet, a rule, a target): title, a
/// mono line, opens on tap, and an optional remove button.
class EntryRow extends StatelessWidget {
  const new({
    required this.title,
    this.subtitle,
    this.onTap,
    this.onRemove,
    this.removeLabel,
    this.leading,
    super.key,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  /// Tooltip of the remove button; defaults to "Delete".
  final String? removeLabel;
  final Widget? leading;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: leading,
    title: Text(title),
    subtitle: switch (subtitle) {
      final s? when s.isNotEmpty => Mono(s, maxLines: 3),
      _ => null,
    },
    onTap: onTap,
    trailing: onRemove == null
        ? (onTap == null ? null : const Icon(Icons.chevron_right))
        : IconButton(
            tooltip: removeLabel ?? AppLocalizations.of(context).actionDelete,
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: onRemove,
          ),
  );
}

/// Entries of a section, or [empty] when there are none.
Widget entries(List<Widget> rows, String empty) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: rows.isEmpty ? [Text(empty)] : rows,
);

/// One metric chart with its own period and the min, max and average of
/// each series (CMP-027 to CMP-029, NET-078). [data] gives the samples of
/// a period, one list per entry of [labels]. Byte rates ([rate]) scale to
/// a readable unit; other values show with [unit].
class MetricPanel extends ConsumerStatefulWidget {
  const new({
    required this.title,
    required this.labels,
    required this.data,
    this.unit = '',
    this.rate = false,
    super.key,
  });

  final String title;
  final List<String> labels;
  final ProviderListenable<AsyncValue<List<List<(DateTime, double)>>>> Function(
    MetricPeriod period,
  )
  data;
  final String unit;
  final bool rate;

  @override
  ConsumerState<MetricPanel> createState() => _MetricPanelState();
}

class _MetricPanelState extends ConsumerState<MetricPanel> {
  MetricPeriod _period = MetricPeriod.day;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(widget.data(_period)).value ?? const [];
    final max = data
        .expand((s) => s)
        .fold<double>(0, (m, p) => p.$2 > m ? p.$2 : m);
    final (unit, factor) = widget.rate ? byteRate(max) : (widget.unit, 1.0);
    String value(double v) =>
        '${(v / factor).toStringAsFixed(v / factor < 10 ? 1 : 0)} $unit'.trim();
    final labels = widget.labels;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MetricChart(
          title: widget.title,
          unit: unit,
          period: _period,
          onPeriodChanged: (p) => setState(() => _period = p),
          series: [
            for (final (i, points) in data.indexed)
              if (i < labels.length)
                MetricSeries(
                  label: labels[i],
                  points: [for (final (t, v) in points) (t, v / factor)],
                ),
          ],
        ),
        for (final (i, points) in data.indexed)
          if (i < labels.length)
            if (seriesStats(points) case final st?)
              Padding(
                padding: const EdgeInsets.only(top: FalcoSpacing.xs),
                child: Text(
                  l10n.metricStats(
                    labels[i],
                    value(st.min),
                    value(st.max),
                    value(st.avg),
                  ),
                  style: FalcoText.of(context).monoSmall,
                ),
              ),
      ],
    );
  }
}

/// Unit and divisor for a byte rate whose largest sample is [max]
/// (CMP-029).
(String, double) byteRate(double max) {
  const units = ['B/s', 'KiB/s', 'MiB/s', 'GiB/s'];
  var factor = 1.0;
  var i = 0;
  while (max / factor >= 1024 && i < units.length - 1) {
    factor *= 1024;
    i++;
  }
  return (units[i], factor);
}

/// Min, max and average of [points] (CMP-029); null without samples.
({double min, double max, double avg})? seriesStats(
  List<(DateTime, double)> points,
) {
  if (points.isEmpty) return null;
  var min = points.first.$2;
  var max = min;
  var sum = 0.0;
  for (final (_, v) in points) {
    if (v < min) min = v;
    if (v > max) max = v;
    sum += v;
  }
  return (min: min, max: max, avg: sum / points.length);
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
