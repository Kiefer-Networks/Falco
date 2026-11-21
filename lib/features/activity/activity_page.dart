// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/actions/action_tracker.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Actions of a project, or of one server when [serverId] is set.
class ActivityPage extends ConsumerWidget {
  const new({required this.scope, this.serverId, super.key});

  final ProjectScope scope;
  final int? serverId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = activityProvider(scope, serverId);
    final async = ref.watch(provider);
    return FalcoScaffold(
      title: l10n.activityTitle,
      body: ResourceList<ActionProgress>(
        title: l10n.activityTitle,
        items: async.value,
        loading: async.isLoading,
        error: async.hasError
            ? errorText(toFalcoError(async.error!), l10n)
            : null,
        onRefresh: () => refreshQuietly(ref, provider.future),
        empty: EmptyHint(message: l10n.activityEmpty),
        searchText: (a) => actionCommandText(a.command, l10n),
        filters: [
          ResourceFilter(l10n.filterAll, (_) => true),
          ResourceFilter(l10n.filterInProgress, (a) => !a.done),
          ResourceFilter(
            l10n.filterFailed,
            (a) => a.status == ActionStatus.error,
          ),
        ],
        itemBuilder: (context, a) => ActivityRow(action: a),
      ),
    );
  }
}

/// One action: status, command and the affected resources with time.
class ActivityRow extends StatelessWidget {
  const new({required this.action, super.key});

  final ActionProgress action;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ResourceRow(
      status: switch (action.status) {
        ActionStatus.running => ResourceStatus.inProgress,
        ActionStatus.success => ResourceStatus.done,
        ActionStatus.error => ResourceStatus.failed,
      },
      name: actionCommandText(action.command, l10n),
      monoLine: [
        for (final (type, id) in action.resources) '$type #$id',
        if (action.started case final t?)
          formatRelative(t, DateTime.now(), l10n),
      ].join(' · '),
    );
  }
}

/// Localized name of an action command; a command without translation
/// (new in the API) shows as readable words.
String actionCommandText(String command, AppLocalizations l10n) {
  final text = l10n.actionCommand(command);
  if (text.isNotEmpty) return text;
  final words = command.replaceAll('_', ' ');
  return words.isEmpty
      ? words
      : '${words[0].toUpperCase()}${words.substring(1)}';
}
