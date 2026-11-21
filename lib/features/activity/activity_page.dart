// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/actions/action_tracker.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/storage/storage_boxes.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// Actions of a project, or of one resource when [type] and [id] are
/// set: running on top, then by day (SUC-006 to SUC-010).
class ActivityPage extends ConsumerWidget {
  const new({required this.scope, this.type, this.id, super.key});

  final ProjectScope scope;
  final String? type;
  final int? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = activityProvider(scope, type: type, id: id);
    final async = ref.watch(provider);
    final items = async.value == null ? null : runningFirst(async.value!);
    final now = DateTime.now();
    bool within(ActionProgress a, Duration d) =>
        a.started != null && now.difference(a.started!) <= d;
    return FalcoScaffold(
      title: l10n.activityTitle,
      body: ResourceList<ActionProgress>(
        title: l10n.activityTitle,
        items: items,
        loading: async.isLoading,
        error: async.hasError
            ? errorText(toFalcoError(async.error!), l10n)
            : null,
        onRefresh: () => refreshQuietly(ref, provider.future),
        empty: EmptyHint(message: l10n.activityEmpty),
        searchText: (a) => [
          actionCommandText(a.command, l10n),
          for (final (t, id) in a.resources) '${resourceTypeText(t, l10n)} $id',
        ].join(' '),
        filters: [
          ResourceFilter(l10n.filterAll, (_) => true),
          ResourceFilter(l10n.filterInProgress, (a) => !a.done),
          ResourceFilter(
            l10n.filterFailed,
            (a) => a.status == ActionStatus.error,
          ),
        ],
        menuFilters: [
          if (type == null)
            ResourceMenuFilter(l10n.activityType, [
              ResourceFilter(l10n.filterAll, (_) => true),
              for (final t in {
                for (final a in items ?? const <ActionProgress>[])
                  for (final (t, _) in a.resources) t,
              })
                ResourceFilter(
                  resourceTypeText(t, l10n),
                  (a) => a.resources.any((r) => r.$1 == t),
                ),
            ]),
          ResourceMenuFilter(l10n.activityTime, [
            ResourceFilter(l10n.activityAnyTime, (_) => true),
            ResourceFilter(
              l10n.activityLastDay,
              (a) => within(a, const Duration(days: 1)),
            ),
            ResourceFilter(
              l10n.activityLastWeek,
              (a) => within(a, const Duration(days: 7)),
            ),
            ResourceFilter(
              l10n.activityLastMonth,
              (a) => within(a, const Duration(days: 30)),
            ),
          ]),
        ],
        groupOf: (a) => activityGroup(a, now, l10n),
        itemBuilder: (context, a) => ActivityRow(action: a, scope: scope),
      ),
    );
  }
}

/// Running actions on top, the rest keeps its order (newest first).
List<ActionProgress> runningFirst(List<ActionProgress> actions) => [
  ...actions.where((a) => !a.done),
  ...actions.where((a) => a.done),
];

/// Section of an action in the activity: running, today, yesterday or
/// its day (SUC-008).
String activityGroup(ActionProgress a, DateTime now, AppLocalizations l10n) {
  final started = a.started?.toLocal();
  if (!a.done) return l10n.filterInProgress;
  if (started == null) return l10n.activityEarlier;
  final day = DateTime(started.year, started.month, started.day);
  if (day == DateTime(now.year, now.month, now.day)) return l10n.activityToday;
  if (day == DateTime(now.year, now.month, now.day - 1)) {
    return l10n.activityYesterday;
  }
  return formatDate(started, l10n.localeName);
}

/// One action: status, command, the affected resources, start and end or
/// progress (SUC-009). With [scope] a tap opens the first resource that
/// has a page.
class ActivityRow extends StatelessWidget {
  const new({required this.action, this.scope, super.key});

  final ActionProgress action;
  final ProjectScope? scope;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;
    final a = action;
    final scope = this.scope;
    final route = scope == null
        ? null
        : a.resources
              .map((r) => resourceRoute(scope, r.$1, r.$2))
              .nonNulls
              .firstOrNull;
    return ResourceRow(
      status: switch (a.status) {
        ActionStatus.running => ResourceStatus.inProgress,
        ActionStatus.success => ResourceStatus.done,
        ActionStatus.error => ResourceStatus.failed,
      },
      name: actionCommandText(a.command, l10n),
      monoLine: [
        for (final (type, id) in a.resources)
          '${resourceTypeText(type, l10n)} #$id',
        if (a.started case final t?)
          [
            formatDateTime(t, locale),
            if (a.finished case final f?)
              DateFormat.Hm(locale).format(f.toLocal()),
          ].join(' → '),
        if (!a.done) '${a.progress} %',
        ?a.errorCode,
      ].join(' · '),
      onTap: route == null ? null : () => route.push<void>(context),
    );
  }
}

/// The activity section of a detail page: the latest actions of resource
/// [type] [id] and a link to all of them.
DetailSection activitySection(
  AppLocalizations l10n,
  ProjectScope scope,
  String type,
  int id,
) => DetailSection(
  title: l10n.sectionActivity,
  child: _ActivityPreview(scope: scope, type: type, id: id),
);

class _ActivityPreview extends ConsumerWidget {
  const new({required this.scope, required this.type, required this.id});

  final ProjectScope scope;
  final String type;
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final actions =
        ref.watch(activityProvider(scope, type: type, id: id)).value ??
        const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final a in runningFirst(actions).take(5)) ActivityRow(action: a),
        if (actions.isEmpty)
          Text(l10n.activityEmpty)
        else
          TextButton(
            onPressed: () => ActivityRoute(
              accountId: scope.accountId,
              projectId: scope.projectId,
              type: type,
              id: id,
            ).push<void>(context),
            child: Text(l10n.activityShowAll),
          ),
      ],
    );
  }
}

/// Localized name of an API resource type; an unknown one reads as
/// words.
String resourceTypeText(String type, AppLocalizations l10n) => switch (type) {
  CloudType.server => l10n.resourceServer,
  CloudType.volume => l10n.resourceVolume,
  CloudType.image => l10n.resourceImage,
  CloudType.placementGroup => l10n.resourcePlacementGroup,
  CloudType.sshKey => l10n.resourceSshKey,
  CloudType.network => l10n.resourceNetwork,
  CloudType.firewall => l10n.resourceFirewall,
  CloudType.floatingIp => l10n.resourceFloatingIp,
  CloudType.primaryIp => l10n.resourcePrimaryIp,
  CloudType.loadBalancer => l10n.resourceLoadBalancer,
  CloudType.certificate => l10n.resourceCertificate,
  CloudType.zone => l10n.resourceZone,
  storageBoxType => l10n.resourceStorageBox,
  'storage_box_snapshot' => l10n.resourceBoxSnapshot,
  'storage_box_subaccount' => l10n.resourceSubaccount,
  _ => type.replaceAll('_', ' '),
};

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
