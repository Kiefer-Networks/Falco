// SPDX-License-Identifier: GPL-3.0-or-later
/// Typed routes. Every route below the root carries its Scope in the path
/// (`/a/:accountId/p/:projectId/...`), so back, deep links and process
/// restore need no hidden state (QRS-003).
library;

import 'package:falco/app/theme_settings.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/showcase/showcase_page.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

/// The app router.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final router = GoRouter(routes: $appRoutes);
  ref.onDispose(router.dispose);
  return router;
}

/// Route of [scope]'s home.
GoRouteData scopeRoute(Scope scope) => switch (scope) {
  ProjectScope(:final accountId, :final projectId) => ProjectRoute(
    accountId: accountId,
    projectId: projectId,
  ),
  AllProjectsScope(:final accountId) => AllProjectsRoute(accountId: accountId),
  RobotScope(:final accountId) => RobotRoute(accountId: accountId),
};

/// Design system showcase; home until features exist.
@TypedGoRoute<ShowcaseRoute>(path: '/')
class ShowcaseRoute extends GoRouteData with $ShowcaseRoute {
  /// Creates the route.
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => Consumer(
    builder: (context, ref, _) {
      final theme = ref.watch(themeSettingsProvider);
      return ShowcasePage(
        variant: theme.variant,
        accent: theme.accent,
        onThemeChanged: ref.read(themeSettingsProvider.notifier).set,
      );
    },
  );
}

/// Home of one Cloud project.
@TypedGoRoute<ProjectRoute>(path: '/a/:accountId/p/:projectId')
class ProjectRoute extends GoRouteData with $ProjectRoute {
  /// Creates the route.
  const new({required this.accountId, required this.projectId});

  /// Account id.
  final String accountId;

  /// Project id.
  final String projectId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ScopeHomePage(scope: ProjectScope(accountId, projectId));
}

/// Home of "all projects" of an account.
@TypedGoRoute<AllProjectsRoute>(path: '/a/:accountId/all')
class AllProjectsRoute extends GoRouteData with $AllProjectsRoute {
  /// Creates the route.
  const new({required this.accountId});

  /// Account id.
  final String accountId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ScopeHomePage(scope: AllProjectsScope(accountId));
}

/// Home of the Robot access of an account.
@TypedGoRoute<RobotRoute>(path: '/a/:accountId/robot')
class RobotRoute extends GoRouteData with $RobotRoute {
  /// Creates the route.
  const new({required this.accountId});

  /// Account id.
  final String accountId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ScopeHomePage(scope: RobotScope(accountId));
}

/// Placeholder home of a scope until the feature areas exist (Phase 2b).
class ScopeHomePage extends StatelessWidget {
  /// Creates the page.
  const new({required this.scope, super.key});

  /// Scope of the page.
  final Scope scope;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FalcoScaffold(
      title: l10n.appTitle,
      body: EmptyHint(
        message: l10n.scopeEmpty,
        actionLabel: l10n.commonBack,
        onAction: () => const ShowcaseRoute().go(context),
      ),
    );
  }
}
