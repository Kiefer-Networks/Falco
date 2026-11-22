// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/format/format.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:material_ui/material_ui.dart';

/// A named component state, rendered by [ShowcasePage] and by the golden
/// tests (one golden per case and theme).
typedef ShowcaseCase = ({String id, double height, WidgetBuilder builder});

/// Demo server used by the list cases.
typedef _Server = ({
  String name,
  ResourceStatus status,
  String ip,
  String meta,
  List<double>? spark,
});

const List<_Server> _servers = [
  (
    name: 'api-01',
    status: ResourceStatus.running,
    ip: '49.13.204.17',
    meta: 'CX32 · fsn1',
    spark: [18, 16, 17, 12, 14, 9, 11, 6],
  ),
  (
    name: 'db-primary',
    status: ResourceStatus.running,
    ip: '116.203.88.4',
    meta: 'CCX23 · nbg1',
    spark: [10, 9, 11, 8, 9, 7, 9, 8],
  ),
  (
    name: 'worker-03',
    status: ResourceStatus.rebooting,
    ip: '65.21.140.92',
    meta: 'CPX21 · hel1',
    spark: [20, 20, 19, 20, 14, 8, 12, 10],
  ),
  (
    name: 'backup-node',
    status: ResourceStatus.off,
    ip: '167.235.10.3',
    meta: 'CX22 · fsn1',
    spark: [0, 0],
  ),
  (
    name: 'staging-web',
    status: ResourceStatus.error,
    ip: '78.47.66.201',
    meta: 'CX22 · nbg1',
    spark: null,
  ),
];

Future<void> _noop() async {}

Widget _row(_Server s) => ResourceRow(
  status: s.status,
  name: s.name,
  monoLine: '${s.ip} · ${s.meta}',
  sparkline: s.spark,
  onTap: () {},
);

Widget _list(
  BuildContext context, {
  List<_Server>? items,
  String? error,
  bool loading = false,
}) {
  final l10n = AppLocalizations.of(context);
  return ResourceList<_Server>(
    title: l10n.resourceServers,
    items: items,
    error: error,
    loading: loading,
    onRefresh: _noop,
    itemBuilder: (_, s) => _row(s),
    searchText: (s) => '${s.name} ${s.ip}',
    filters: [
      ResourceFilter(l10n.filterAll, (_) => true),
      ResourceFilter(
        l10n.statusRunning,
        (s) => s.status == ResourceStatus.running,
      ),
      ResourceFilter(l10n.statusOff, (s) => s.status == ResourceStatus.off),
    ],
    sorts: [
      ResourceSort(l10n.sortName, (a, b) => a.name.compareTo(b.name)),
      ResourceSort(l10n.sortCreated, (a, b) => 0),
    ],
    empty: EmptyHint(message: l10n.emptyServers),
  );
}

// Local wall clock times keep axis labels identical in every time zone.
List<(DateTime, double)> _samples(List<double> values) => [
  for (final (i, v) in values.indexed)
    (DateTime(2026, 11, 20, 12).add(Duration(hours: i * 2)), v),
];

Widget _chart(
  BuildContext context, {
  required List<MetricSeries> series,
  String? headline,
}) {
  final l10n = AppLocalizations.of(context);
  return MetricChart(
    title: series.length > 1 ? l10n.metricNetwork : l10n.metricCpu,
    unit: series.length > 1 ? 'MB/s' : '%',
    series: series,
    period: MetricPeriod.day,
    onPeriodChanged: (_) {},
    headline: headline,
  );
}

const _accounts = [
  ScopeAccountItem(
    id: 'a1',
    name: 'Kiefer Networks',
    hasRobot: true,
    projects: [
      ScopeProjectItem(id: 'p1', name: 'kiefer-prod'),
      ScopeProjectItem(id: 'p2', name: 'kiefer-staging'),
    ],
  ),
  ScopeAccountItem(
    id: 'a2',
    name: 'Lab',
    projects: [ScopeProjectItem(id: 'p3', name: 'lab')],
  ),
];

Widget _confirm(BuildContext context, ConfirmLevel level) {
  final l10n = AppLocalizations.of(context);
  final simple = level == ConfirmLevel.simple;
  return Align(
    alignment: Alignment.bottomCenter,
    child: ConfirmSheet(
      title: simple
          ? l10n.rebootTitle('db-primary')
          : l10n.deleteTitle('db-primary'),
      consequence: simple ? l10n.rebootConsequence : l10n.deleteConsequence,
      confirmLabel: simple ? l10n.actionReboot : l10n.actionDelete,
      resourceName: 'db-primary',
      level: level,
      destructive: !simple,
      facts: [
        ConfirmFact(l10n.scopeProject, 'kiefer-prod'),
        ConfirmFact(l10n.fieldAddress, '116.203.88.4', mono: true),
      ],
    ),
  );
}

Widget _wizard(BuildContext context, {bool project = false, int step = 0}) {
  final l10n = AppLocalizations.of(context);
  return CreateWizard(
    title: l10n.actionCreateServer,
    initialStep: step,
    projectStep: project
        ? WizardStep(
            title: l10n.wizardProject,
            child: Text(
              'kiefer-prod',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
        : null,
    steps: [
      WizardStep(
        title: l10n.fieldName,
        child: TextField(
          decoration: InputDecoration(labelText: l10n.fieldName),
        ),
      ),
      WizardStep(title: l10n.fieldType, child: const Mono('CX32')),
    ],
    summary: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.fieldType, style: Theme.of(context).textTheme.bodySmall),
        const Mono('CX32 · 4 vCPU · 8 GB'),
        const SizedBox(height: 8),
        Text(l10n.fieldLocation, style: Theme.of(context).textTheme.bodySmall),
        const Mono('fsn1'),
      ],
    ),
    onCreate: () {},
  );
}

/// All showcase cases in display order.
List<ShowcaseCase> showcaseCases() => [
  for (final status in [
    ResourceStatus.running,
    ResourceStatus.off,
    ResourceStatus.rebooting,
    ResourceStatus.error,
  ])
    (
      id: 'status_badge_${status.name}',
      height: 48,
      builder: (_) => Align(
        alignment: Alignment.centerLeft,
        child: StatusBadge(status: status),
      ),
    ),
  (
    id: 'mono',
    height: 48,
    builder: (_) => const Align(
      alignment: Alignment.centerLeft,
      child: Mono('116.203.88.4 · 2a01:4f8:c17:3b2::/64'),
    ),
  ),
  (
    id: 'copyable_value',
    height: 56,
    builder: (_) => Align(
      alignment: Alignment.centerLeft,
      child: CopyableValue(formatIp('2A01:04F8:C17:3B2:0:0:0:1')),
    ),
  ),
  for (final visible in [false, true])
    (
      id: 'secret_reveal_${visible ? 'shown' : 'hidden'}',
      height: 80,
      builder: (context) => SecretReveal(
        label: AppLocalizations.of(context).fieldRootPassword,
        secret: 'hX7#pQ2v-Lm9tR4w',
        initiallyVisible: visible,
      ),
    ),
  (
    id: 'detail_action_bar',
    height: 100,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return Align(
        alignment: Alignment.bottomCenter,
        child: DetailActionBar(
          actions: [
            DetailAction(
              icon: Icons.refresh,
              label: l10n.actionReboot,
              group: ActionGroup.power,
              onTap: () {},
            ),
            DetailAction(
              icon: Icons.power_settings_new,
              label: l10n.actionShutdown,
              group: ActionGroup.power,
              onTap: null,
            ),
            DetailAction(
              icon: Icons.scatter_plot_outlined,
              label: l10n.placementGroupRemove,
              group: ActionGroup.manage,
              onTap: () {},
            ),
            DetailAction(
              icon: Icons.terminal,
              label: l10n.actionConsole,
              group: ActionGroup.access,
              onTap: () {},
            ),
          ],
        ),
      );
    },
  ),
  (
    id: 'area_overview',
    height: 520,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return AreaOverview(
        onRefresh: () async {},
        tiles: [
          OverviewTile(
            icon: Icons.dns_outlined,
            label: l10n.resourceServers,
            onTap: () {},
            count: 3,
            statuses: [for (final s in _servers.take(3)) s.status],
            preview: [for (final s in _servers.take(3)) _row(s)],
          ),
          OverviewTile(
            icon: Icons.save_outlined,
            label: l10n.resourceVolumes,
            onTap: () {},
            count: 2,
            statuses: const [
              ResourceStatus.available,
              ResourceStatus.available,
            ],
          ),
          OverviewTile(
            icon: Icons.scatter_plot_outlined,
            label: l10n.resourcePlacementGroups,
            onTap: () {},
            count: 0,
          ),
          OverviewTile(
            icon: Icons.photo_library_outlined,
            label: l10n.resourceImages,
            onTap: () {},
            note: l10n.overviewUnavailable,
          ),
        ],
      );
    },
  ),
  for (final s in [_servers[0], _servers[2], _servers[3], _servers[4]])
    (id: 'resource_row_${s.status.name}', height: 72, builder: (_) => _row(s)),
  (
    id: 'error_card',
    height: 190,
    builder: (context) => ErrorCard(
      message: AppLocalizations.of(context).errorNetwork,
      onRetry: () {},
    ),
  ),
  (
    id: 'empty_hint',
    height: 160,
    builder: (context) =>
        EmptyHint(message: AppLocalizations.of(context).emptyServers),
  ),
  (
    id: 'error_banner',
    height: 80,
    builder: (context) => ErrorBanner(
      message: AppLocalizations.of(context).listStaleBanner,
      onRetry: () {},
    ),
  ),
  (
    id: 'metric_chart_single',
    height: 280,
    builder: (context) => _chart(
      context,
      headline: '38%',
      series: [
        MetricSeries(
          label: AppLocalizations.of(context).metricCpu,
          points: _samples([12, 14, 11, 20, 24, 38, 52, 47, 40, 36, 38, 33]),
        ),
      ],
    ),
  ),
  (
    id: 'metric_chart_multi',
    height: 280,
    builder: (context) => _chart(
      context,
      series: [
        MetricSeries(
          label: AppLocalizations.of(context).metricIn,
          points: _samples([2.1, 2.4, 3.2, 2.9, 4.4, 3.9, 4.8, 4.0, 4.2]),
        ),
        MetricSeries(
          label: AppLocalizations.of(context).metricOut,
          points: _samples([0.8, 0.9, 1.0, 1.0, 1.3, 1.1, 1.4, 1.2, 1.1]),
        ),
      ],
    ),
  ),
  (
    id: 'metric_chart_empty',
    height: 240,
    builder: (context) => _chart(
      context,
      series: [
        MetricSeries(
          label: AppLocalizations.of(context).metricCpu,
          points: const [],
        ),
      ],
    ),
  ),
  (
    id: 'resource_list_loading',
    height: 560,
    builder: (context) => _list(context, loading: true),
  ),
  (
    id: 'resource_list_loaded',
    height: 560,
    builder: (context) => _list(context, items: _servers, loading: true),
  ),
  (
    id: 'resource_list_empty',
    height: 400,
    builder: (context) => _list(context, items: const []),
  ),
  (
    id: 'resource_list_error',
    height: 400,
    builder: (context) =>
        _list(context, error: AppLocalizations.of(context).errorNetwork),
  ),
  (
    id: 'resource_list_stale',
    height: 560,
    builder: (context) => _list(
      context,
      items: _servers.take(3).toList(),
      error: AppLocalizations.of(context).errorNetwork,
    ),
  ),
  (
    id: 'detail_page',
    height: 1500,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return FalcoScaffold(
        title: l10n.resourceServer,
        body: DetailPage(
          status: ResourceStatus.running,
          statusDetail: formatRelative(
            DateTime(2026, 11, 9),
            DateTime(2026, 11, 21),
            l10n,
          ),
          name: 'db-primary',
          ids: const [
            DetailId('116.203.88.4', icon: Icons.public, copy: true),
            DetailId('fsn1', icon: Icons.place_outlined),
            DetailId('CX32', icon: Icons.memory),
          ],
          facts: [
            Fact(l10n.fieldVcpu, text: '4'),
            Fact(l10n.fieldMemory, text: '8 GiB'),
            Fact(
              l10n.fieldDisk,
              text: formatBytes(80 * 1024 * 1024 * 1024, l10n.localeName),
            ),
            Fact(l10n.fieldBackups, on: true),
          ],
          onRefresh: _noop,
          actions: [
            DetailAction(
              icon: Icons.restart_alt,
              label: l10n.actionReboot,
              group: ActionGroup.power,
              onTap: () {},
            ),
            DetailAction(
              icon: Icons.power_settings_new,
              label: l10n.actionShutdown,
              group: ActionGroup.power,
              onTap: () {},
            ),
            DetailAction(
              icon: Icons.terminal,
              label: l10n.actionConsole,
              group: ActionGroup.access,
              onTap: () {},
            ),
            DetailAction(
              icon: Icons.power_off_outlined,
              label: l10n.actionPowerOff,
              group: ActionGroup.power,
              onTap: () {},
            ),
            DetailAction(
              icon: Icons.edit_outlined,
              label: l10n.commonEdit,
              group: ActionGroup.manage,
              onTap: () {},
            ),
            DetailAction(
              icon: Icons.dns_outlined,
              label: l10n.reverseDns,
              group: ActionGroup.network,
              onTap: () {},
            ),
            DetailAction(
              icon: Icons.photo_camera_outlined,
              label: l10n.actionSnapshot,
              group: ActionGroup.backup,
              onTap: null,
            ),
            DetailAction(
              icon: Icons.restart_alt,
              label: l10n.actionReset,
              group: ActionGroup.danger,
              onTap: () {},
            ),
          ],
          sections: [
            DetailSection(
              title: l10n.sectionNetwork,
              facts: [
                Fact(l10n.publicIpv4, text: '116.203.88.4', copy: true),
                Fact(l10n.reverseDns, text: 'db.example.com', mono: true),
              ],
            ),
            DetailSection(
              title: l10n.sectionProtection,
              facts: [
                Fact(l10n.fieldDeleteProtection, on: true),
                Fact(l10n.fieldRebuildProtection, on: false),
              ],
            ),
            DetailSection(
              title: l10n.sectionAttached,
              cards: [
                RelatedCard(
                  icon: Icons.storage_outlined,
                  title: 'pg-data',
                  subtitle: '100 GiB',
                  status: ResourceStatus.available,
                  onTap: () {},
                ),
              ],
            ),
            DetailSection(
              title: l10n.fieldLabels,
              child: const LabelChips({'env': 'prod', 'role': 'db'}),
            ),
            DetailSection(
              title: l10n.sectionMetrics,
              cards: [
                _chart(
                  context,
                  headline: '38%',
                  series: [
                    MetricSeries(
                      label: l10n.metricCpu,
                      points: _samples([12, 14, 11, 20, 24, 38, 52, 47, 40]),
                    ),
                  ],
                ),
              ],
            ),
          ],
          dangerZone: [
            OutlinedButton(onPressed: () {}, child: Text(l10n.actionRebuild)),
            OutlinedButton(onPressed: () {}, child: Text(l10n.actionDelete)),
          ],
        ),
      );
    },
  ),
  (
    id: 'falco_scaffold',
    height: 320,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return FalcoScaffold(
        scopeSwitcher: ScopeSwitcherButton(
          scopeName: 'kiefer-prod',
          onTap: () => ScopeSwitcherSheet.show(
            context,
            accounts: _accounts,
            selected: const ScopeChoice('a1', ScopeKind.project, 'p1'),
          ),
        ),
        actions: [
          IconButton(
            tooltip: l10n.commonSearch,
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
        moreMenu: MoreMenu(
          actions: [
            DetailAction(
              label: l10n.actionRename,
              icon: Icons.edit_outlined,
              group: ActionGroup.manage,
              onTap: () {},
            ),
            DetailAction(
              label: l10n.actionDelete,
              icon: Icons.delete_outline,
              group: ActionGroup.danger,
              onTap: () {},
            ),
          ],
        ),
        body: Column(children: [_row(_servers[0]), _row(_servers[1])]),
      );
    },
  ),
  (
    id: 'edit_sheet',
    height: 300,
    builder: (context) => Align(
      alignment: Alignment.bottomCenter,
      child: EditSheet(
        title: AppLocalizations.of(context).actionRename,
        onSave: () {},
        child: TextFormField(
          initialValue: 'db-primary',
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).fieldName,
          ),
        ),
      ),
    ),
  ),
  (
    id: 'confirm_sheet_level1',
    height: 480,
    builder: (context) => _confirm(context, ConfirmLevel.simple),
  ),
  (
    id: 'confirm_sheet_level2',
    height: 600,
    builder: (context) => _confirm(context, ConfirmLevel.typeName),
  ),
  (
    id: 'scope_switcher_sheet',
    height: 600,
    builder: (_) => const Align(
      alignment: Alignment.bottomCenter,
      child: ScopeSwitcherSheet(
        accounts: _accounts,
        selected: ScopeChoice('a1', ScopeKind.project, 'p1'),
      ),
    ),
  ),
  (id: 'create_wizard_step', height: 560, builder: _wizard),
  (
    id: 'create_wizard_project',
    height: 560,
    builder: (context) => _wizard(context, project: true),
  ),
  (
    id: 'create_wizard_summary',
    height: 560,
    builder: (context) => _wizard(context, step: 2),
  ),
];

/// Renders every design system component in all its states. Home screen
/// until the first feature lands.
class ShowcasePage extends StatelessWidget {
  /// Creates the showcase.
  const new({
    required this.variant,
    required this.accent,
    required this.onThemeChanged,
    super.key,
  });

  /// Current surface variant.
  final FalcoVariant variant;

  /// Current accent.
  final AccentPreset accent;

  /// Switches the app theme.
  final void Function(FalcoVariant variant, AccentPreset accent) onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = FalcoColors.of(context);
    final cases = showcaseCases();
    return FalcoScaffold(
      title: l10n.showcaseTitle,
      body: ListView(
        padding: const EdgeInsets.all(FalcoSpacing.l),
        children: [
          SegmentedButton<FalcoVariant>(
            segments: [
              ButtonSegment(
                value: FalcoVariant.dark,
                label: Text(l10n.showcaseDark),
              ),
              ButtonSegment(
                value: FalcoVariant.light,
                label: Text(l10n.showcaseLight),
              ),
              ButtonSegment(
                value: FalcoVariant.oled,
                label: Text(l10n.showcaseOled),
              ),
            ],
            selected: {variant},
            onSelectionChanged: (s) => onThemeChanged(s.first, accent),
          ),
          const SizedBox(height: FalcoSpacing.s),
          Wrap(
            children: [
              for (final a in AccentPreset.values)
                IconButton(
                  tooltip: '${l10n.showcaseAccent} ${a.index + 1}',
                  onPressed: () => onThemeChanged(variant, a),
                  icon: Icon(
                    a == accent ? Icons.radio_button_checked : Icons.circle,
                    color: a.tone(variant.brightness),
                  ),
                ),
            ],
          ),
          for (final sc in cases) ...[
            const SizedBox(height: FalcoSpacing.l),
            Text(sc.id, style: FalcoText.of(context).monoSmall),
            const SizedBox(height: FalcoSpacing.xs),
            Container(
              height: sc.height,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                border: Border.all(color: c.hairline),
                borderRadius: BorderRadius.circular(FalcoRadius.small),
              ),
              child: Builder(builder: sc.builder),
            ),
          ],
          const SizedBox(height: FalcoSpacing.l),
          Wrap(
            spacing: FalcoSpacing.s,
            children: [
              OutlinedButton(
                onPressed: () => ConfirmSheet.show(
                  context,
                  title: l10n.deleteTitle('db-primary'),
                  consequence: l10n.deleteConsequence,
                  confirmLabel: l10n.actionDelete,
                  resourceName: 'db-primary',
                  level: ConfirmLevel.typeName,
                  destructive: true,
                ),
                child: Text('${l10n.showcaseOpen}: ${l10n.actionDelete}'),
              ),
              OutlinedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => _wizard(context, project: true),
                  ),
                ),
                child: Text('${l10n.showcaseOpen}: ${l10n.actionCreateServer}'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
