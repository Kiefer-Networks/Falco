// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/servers/server_list.dart';
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
    scopeRoute(switch (choice.kind) {
      ScopeKind.project => ProjectScope(choice.accountId, choice.projectId!),
      ScopeKind.allProjects => AllProjectsScope(choice.accountId),
      ScopeKind.robot => RobotScope(choice.accountId),
    }).go(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = widget.scope;
    final accounts = ref.watch(accountsProvider).value ?? const [];
    final account = accounts.where((a) => a.id == scope.accountId).firstOrNull;
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
      moreMenu: MoreMenu(
        items: [
          MoreMenuItem(
            label: l10n.projectAdd,
            icon: Icons.add,
            onSelected: () =>
                AddProjectRoute(accountId: scope.accountId).push<void>(context),
          ),
          MoreMenuItem(
            label: l10n.accountAdd,
            icon: Icons.person_add_alt,
            onSelected: () => const SetupRoute().push<void>(context),
          ),
          if (kDebugMode)
            MoreMenuItem(
              label: l10n.showcaseTitle,
              icon: Icons.palette_outlined,
              onSelected: () => const ShowcaseRoute().push<void>(context),
            ),
        ],
      ),
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
          ? ServerList(scope: scope)
          : EmptyHint(message: l10n.scopeEmpty),
    );
  }
}
