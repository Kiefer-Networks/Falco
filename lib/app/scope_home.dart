// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/areas.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Home of a scope: scope switcher on top, the four areas at the bottom
/// (Compute, Network, Storage, Robot), each opening its overview.
class ScopeHomePage extends ConsumerStatefulWidget {
  const new({required this.scope, this.area = 0, super.key});

  final Scope scope;

  /// Area of a project scope shown first (0 Compute, 1 Network, 2 Storage).
  final int area;

  @override
  ConsumerState<ScopeHomePage> createState() => _ScopeHomePageState();
}

class _ScopeHomePageState extends ConsumerState<ScopeHomePage> {
  late int _area = widget.scope is RobotScope ? 3 : widget.area.clamp(0, 2);

  /// The area a project scope keeps when the scope changes.
  int get _projectArea => _area < 3 ? _area : 0;

  Future<void> _switchScope(List<Account> accounts) async {
    final scope = widget.scope;
    final choice = await ScopeSwitcherSheet.show(
      context,
      accounts: [
        for (final a in accounts)
          ScopeAccountItem(
            id: a.id,
            name: a.name,
            hasRobot: a.hasRobot,
            projects: [
              for (final p in a.projects)
                ScopeProjectItem(id: p.id, name: p.name),
            ],
          ),
      ],
      selected: switch (scope) {
        ProjectScope(:final projectId) => ScopeChoice(
          scope.accountId,
          ScopeKind.project,
          projectId,
        ),
        AllProjectsScope() => ScopeChoice(
          scope.accountId,
          ScopeKind.allProjects,
        ),
        RobotScope() => ScopeChoice(scope.accountId, ScopeKind.robot),
      },
    );
    if (choice == null || !mounted) return;
    switch (choice.kind) {
      case ScopeKind.addProject:
        AddProjectRoute(accountId: choice.accountId)
            .push<void>(context)
            .ignore();
      case ScopeKind.manage:
        AccountRoute(accountId: choice.accountId).push<void>(context).ignore();
      case ScopeKind.project:
        ProjectRoute(
          accountId: choice.accountId,
          projectId: choice.projectId!,
          area: _projectArea,
        ).go(context);
      case ScopeKind.allProjects:
        AllProjectsRoute(
          accountId: choice.accountId,
          area: _projectArea,
        ).go(context);
      case ScopeKind.robot:
        RobotRoute(accountId: choice.accountId).go(context);
    }
  }

  /// Robot is its own scope: its tab opens the account's Robot, the
  /// others the tapped area of its first project, when there is one.
  void _openArea(int area, Account? account) {
    final robot = widget.scope is RobotScope;
    if (area == 3 && !robot && (account?.hasRobot ?? false)) {
      return RobotRoute(accountId: account!.id).go(context);
    }
    if (area < 3 && robot && (account?.projects.isNotEmpty ?? false)) {
      return ProjectRoute(
        accountId: account!.id,
        projectId: account.projects.first.id,
        area: area,
      ).go(context);
    }
    setState(() => _area = area);
  }

  bool _exists(Account? account) => switch ((widget.scope, account)) {
    (_, null) => false,
    (ProjectScope(:final projectId), final Account a) => a.projects.any(
      (p) => p.id == projectId,
    ),
    (AllProjectsScope(), final Account a) => a.projects.isNotEmpty,
    (RobotScope(), final Account a) => a.hasRobot,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = widget.scope;
    final async = ref.watch(accountsProvider);
    final accounts = async.value ?? const <Account>[];
    final account = accounts.where((a) => a.id == scope.accountId).firstOrNull;
    // A deleted account or project (or a stale deep link) goes back to
    // the start, which picks a scope that exists.
    // Not while reloading: a just added project is not in the old list.
    if (async.hasValue && !async.isLoading && !_exists(account)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) const HomeRoute().go(context);
      });
    }
    // Tablets and phones in landscape get a rail instead of the bottom bar
    // (README section 4).
    final rail = MediaQuery.sizeOf(context).width >= FalcoBreakpoint.rail;
    void open(int i) => _openArea(i, account);
    final areas = [
      (Icons.dns_outlined, l10n.navCompute),
      (Icons.hub_outlined, l10n.navNetwork),
      (Icons.inventory_2_outlined, l10n.navStorage),
      (Icons.storage_outlined, l10n.navRobot),
    ];
    final area = Area.values[_area];
    final content = switch (_area) {
      3 when scope is! RobotScope => ActionHint(
        icon: Icons.storage_outlined,
        message: l10n.robotNoAccess,
        actionLabel: l10n.robotAdd,
        onAction: () =>
            AccountRoute(accountId: scope.accountId).push<void>(context),
      ),
      < 3 when scope is RobotScope => EmptyHint(message: l10n.scopeEmpty),
      _ => AreaOverviewPage(scope: scope, area: area),
    };
    // Only an overview with rows opens details beside it; the others
    // use the full width.
    final body = content is AreaOverviewPage && area.hasPreview
        ? ListDetail(key: ValueKey(_area), list: content)
        : KeyedSubtree(key: ValueKey(_area), child: content);
    return FalcoScaffold(
      scopeSwitcher: ScopeSwitcherButton(
        caption: account?.name,
        scopeName: switch (scope) {
          ProjectScope(:final projectId) => projectName(accounts, projectId),
          AllProjectsScope() => l10n.scopeAllProjects,
          RobotScope() => l10n.scopeRobot,
        },
        onTap: () => _switchScope(accounts),
      ),
      actions: [
        IconButton(
          tooltip: l10n.commonSearch,
          icon: const Icon(Icons.search),
          onPressed: () => const SearchRoute().push<void>(context),
        ),
        IconButton(
          tooltip: l10n.settingsTitle,
          icon: const Icon(Icons.account_circle_outlined),
          onPressed: () =>
              SettingsRoute(active: scope.accountId).push<void>(context),
        ),
        if (scope case ProjectScope(:final accountId, :final projectId))
          IconButton(
            tooltip: l10n.activityTitle,
            icon: const Icon(Icons.history),
            onPressed: () => ActivityRoute(
              accountId: accountId,
              projectId: projectId,
            ).push<void>(context),
          ),
        if (scope is RobotScope)
          IconButton(
            tooltip: l10n.activityTitle,
            icon: const Icon(Icons.history),
            onPressed: () =>
                RobotActivityRoute(accountId: scope.accountId)
                    .push<void>(context),
          ),
      ],
      moreMenu: kDebugMode
          ? MoreMenu(
              items: [
                MoreMenuItem(
                  label: l10n.showcaseTitle,
                  icon: Icons.palette_outlined,
                  onSelected: () => const ShowcaseRoute().push<void>(context),
                ),
              ],
            )
          : null,
      bottomNavigationBar: rail
          ? null
          : NavigationBar(
              selectedIndex: _area,
              onDestinationSelected: open,
              destinations: [
                for (final (icon, label) in areas)
                  NavigationDestination(icon: Icon(icon), label: label),
              ],
            ),
      // One Row either way, so the area keeps its state on rotation.
      body: Row(
        children: [
          if (rail) ...[
            NavigationRail(
              selectedIndex: _area,
              onDestinationSelected: open,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final (icon, label) in areas)
                  NavigationRailDestination(
                    icon: Icon(icon),
                    label: Text(label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
          ],
          Expanded(child: body),
        ],
      ),
    );
  }
}
