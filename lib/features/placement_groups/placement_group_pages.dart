// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/placement_groups/placement_groups.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Placement groups of a scope (CMP-065).
class PlacementGroupList extends ConsumerWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = placementGroupsProvider(scope);
    final async = ref.watch(provider);
    final accounts = scope is AllProjectsScope
        ? ref.watch(accountsProvider.select((a) => a.value))
        : null;
    return ResourceList<PlacementGroup>(
      title: l10n.resourcePlacementGroups,
      items: async.value,
      loading: async.isLoading,
      error: async.hasError
          ? errorText(toFalcoError(async.error!), l10n)
          : null,
      onRefresh: () => refreshQuietly(ref, provider.future),
      empty: EmptyHint(message: l10n.emptyPlacementGroups),
      searchText: (g) => g.name,
      sorts: [ResourceSort(l10n.sortName, (a, b) => a.name.compareTo(b.name))],
      itemBuilder: (context, g) => ResourceRow(
        status: ResourceStatus.available,
        name: g.name,
        monoLine: [
          g.type,
          l10n.serverCount(g.servers.length),
          if (accounts != null) projectName(accounts, g.projectId),
        ].join(' · '),
        onTap: () => openDetail(
          context,
          PlacementGroupRoute(
            accountId: scope.accountId,
            projectId: g.projectId,
            groupId: g.id,
          ),
        ),
      ),
    );
  }
}

/// One placement group with its servers; rename, labels, delete
/// (CMP-067 to CMP-069).
class PlacementGroupDetailPage extends ConsumerWidget {
  const new({required this.scope, required this.groupId, super.key});

  final ProjectScope scope;
  final int groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = placementGroupProvider(scope, groupId);
    final async = ref.watch(provider);
    final g = async.value;
    if (g == null) {
      return DetailLoading(
        title: l10n.resourcePlacementGroup,
        error: async.error,
        onRetry: () => ref.invalidate(provider),
      );
    }
    final t = (
      scope: scope,
      type: CloudType.placementGroup,
      id: g.id,
      name: g.name,
    );
    final servers = {
      for (final s
          in ref.watch(serversProvider(scope)).value ?? const <CloudServer>[])
        s.id: s,
    };
    return FalcoScaffold(
      title: l10n.resourcePlacementGroup,
      body: DetailPage(
        name: g.name,
        ids: [DetailId(g.type, icon: Icons.scatter_plot_outlined)],
        facts: [
          Fact(l10n.fieldType, text: g.type),
          Fact(l10n.resourceServers, text: '${g.servers.length}'),
          Fact(l10n.fieldCreated, time: g.created),
        ],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          DetailAction(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            group: ActionGroup.manage,
            onTap: () => editNameAndLabels(
              context,
              ref,
              t,
              g.labels,
              (api, name, labels) =>
                  updatePlacementGroup(api, g.id, name: name, labels: labels),
            ),
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.resourceServers,
            cards: [
              for (final id in g.servers)
                RelatedCard(
                  icon: Icons.dns_outlined,
                  title: servers[id]?.name ?? '#$id',
                  status: servers[id]?.status ?? ResourceStatus.unknown,
                  subtitle: [
                    if (servers[id]?.address case final a?) formatIp(a),
                    if (servers[id] case final s?) s.type.toUpperCase(),
                  ].join(' · '),
                  onTap: () => ServerRoute(
                    accountId: scope.accountId,
                    projectId: scope.projectId,
                    serverId: id,
                  ).push<void>(context),
                ),
            ],
            child: g.servers.isEmpty ? Text(l10n.placementGroupEmpty) : null,
          ),
          labelsSection(l10n, g.labels),
          detailsSection(l10n, id: g.id),
        ],
        dangerZone: [
          DeleteButton(
            onPressed: () async {
              if (!await confirmDelete(
                    context,
                    t,
                    l10n.placementGroupDeleteConsequence,
                  ) ||
                  !context.mounted) {
                return;
              }
              final deleted = await runChange(
                context,
                ref,
                t,
                (api) => deletePlacementGroup(api, g.id),
                done: l10n.deletedMessage(g.name),
              );
              if (deleted && context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

/// Create a placement group: name, type from the spec, labels
/// (CMP-066, CMP-091).
class CreatePlacementGroupPage extends ConsumerStatefulWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  ConsumerState<CreatePlacementGroupPage> createState() =>
      _CreatePlacementGroupPageState();
}

class _CreatePlacementGroupPageState
    extends ConsumerState<CreatePlacementGroupPage> {
  String? _project;
  var _values = <String, String>{'type': placementGroupTypes.first};
  bool _creating = false;

  Future<void> _create(ProjectScope scope) async {
    if (_creating) return;
    setState(() => _creating = true);
    final ok = await runChange(
      context,
      ref,
      (scope: scope, type: CloudType.placementGroup, id: 0, name: ''),
      (api) => createPlacementGroup(
        api,
        name: _values['name']!.trim(),
        type: _values['type']!,
        labels: parseLabels(_values['labels'] ?? '') ?? const {},
      ),
      done: AppLocalizations.of(context).createdMessage(_values['name']!),
    );
    if (!mounted) return;
    setState(() => _creating = false);
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = targetScope(widget.scope, _project);
    return CreateWizard(
      title: l10n.placementGroupCreate,
      creating: _creating,
      onCreate: scope == null ? null : () => _create(scope),
      projectStep: projectStep(
        ref,
        l10n,
        widget.scope,
        _project,
        (p) => setState(() => _project = p),
      ),
      steps: [
        WizardStep(
          title: l10n.wizardDetails,
          canContinue:
              (_values['name'] ?? '').trim().isNotEmpty && validLabels(_values),
          child: FormFields(
            fields: [
              FieldSpec('name', l10n.fieldName, maxLength: 63),
              FieldSpec(
                'type',
                l10n.fieldType,
                initial: placementGroupTypes.first,
                helper: l10n.placementGroupTypeHint,
                options: {for (final t in placementGroupTypes) t: t},
              ),
              labelsField(l10n),
            ],
            values: _values,
            onChanged: (v) => setState(() => _values = {..._values, ...v}),
          ),
        ),
      ],
      summary: FactRows([
        ConfirmFact(l10n.fieldName, (_values['name'] ?? '').trim()),
        ConfirmFact(l10n.fieldType, _values['type'] ?? ''),
        ConfirmFact(
          l10n.fieldLabels,
          labelsText(parseLabels(_values['labels'] ?? '') ?? const {}, l10n),
        ),
      ]),
    );
  }
}
