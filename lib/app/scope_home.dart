// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/compute/compute_page.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Home of a scope: scope switcher on top, the four areas at the bottom
/// (Compute, Network, Storage, Robot).
class ScopeHomePage extends ConsumerStatefulWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  ConsumerState<ScopeHomePage> createState() => _ScopeHomePageState();
}

class _ScopeHomePageState extends ConsumerState<ScopeHomePage> {
  late int _area = widget.scope is RobotScope ? 3 : 0;

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
        ).go(context);
      case ScopeKind.allProjects:
        AllProjectsRoute(accountId: choice.accountId).go(context);
      case ScopeKind.robot:
        RobotRoute(accountId: choice.accountId).go(context);
    }
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _area,
        onDestinationSelected: (i) => setState(() => _area = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dns_outlined),
            label: l10n.navCompute,
          ),
          NavigationDestination(
            icon: const Icon(Icons.hub_outlined),
            label: l10n.navNetwork,
          ),
          NavigationDestination(
            icon: const Icon(Icons.inventory_2_outlined),
            label: l10n.navStorage,
          ),
          NavigationDestination(
            icon: const Icon(Icons.storage_outlined),
            label: l10n.navRobot,
          ),
        ],
      ),
      // Network, Storage and Robot follow in Phases 5 to 7.
      body: _area == 0 && scope is! RobotScope
          ? ComputePage(scope: scope)
          : EmptyHint(message: l10n.scopeEmpty),
    );
  }
}
