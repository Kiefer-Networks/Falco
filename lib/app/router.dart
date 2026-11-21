// SPDX-License-Identifier: GPL-3.0-or-later
/// Typed routes. Every route below the root carries its Scope in the path
/// (`/a/:accountId/p/:projectId/...`), so back, deep links and process
/// restore need no hidden state (QRS-003).
library;

import 'package:falco/app/scope_home.dart';
import 'package:falco/app/theme_settings.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity_page.dart';
import 'package:falco/features/servers/server_detail_page.dart';
import 'package:falco/ui/showcase/showcase_page.dart';
import 'package:flutter/foundation.dart';
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

/// Start: the first scope of the first account, or the account setup when
/// there is none (ONB-006).
@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData with $HomeRoute {
  const new();

  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final accounts = await ProviderScope.containerOf(
      context,
      listen: false,
    ).read(accountsProvider.future);
    final a = accounts.firstOrNull;
    if (a == null) return const SetupRoute().location;
    if (a.projects.firstOrNull case final p?) {
      return ProjectRoute(accountId: a.id, projectId: p.id).location;
    }
    return a.hasRobot
        ? RobotRoute(accountId: a.id).location
        : AddProjectRoute(accountId: a.id).location;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

/// Design system showcase, debug builds only.
@TypedGoRoute<ShowcaseRoute>(path: '/showcase')
class ShowcaseRoute extends GoRouteData with $ShowcaseRoute {
  const new();

  @override
  String? redirect(BuildContext context, GoRouterState state) =>
      kDebugMode ? null : const HomeRoute().location;

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

/// New account with its first Cloud project.
@TypedGoRoute<SetupRoute>(path: '/setup')
class SetupRoute extends GoRouteData with $SetupRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProjectSetupPage();
}

/// New Cloud project of an account.
@TypedGoRoute<AddProjectRoute>(path: '/a/:accountId/projects/new')
class AddProjectRoute extends GoRouteData with $AddProjectRoute {
  const new({required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ProjectSetupPage(accountId: accountId);
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

/// One Cloud server.
@TypedGoRoute<ServerRoute>(path: '/a/:accountId/p/:projectId/servers/:serverId')
class ServerRoute extends GoRouteData with $ServerRoute {
  const new({
    required this.accountId,
    required this.projectId,
    required this.serverId,
  });

  final String accountId;
  final String projectId;
  final int serverId;

  @override
  Widget build(BuildContext context, GoRouterState state) => ServerDetailPage(
    scope: ProjectScope(accountId, projectId),
    serverId: serverId,
  );
}

/// Activity of a project, or of one server with `?server-id=`.
@TypedGoRoute<ActivityRoute>(path: '/a/:accountId/p/:projectId/activity')
class ActivityRoute extends GoRouteData with $ActivityRoute {
  const new({required this.accountId, required this.projectId, this.serverId});

  final String accountId;
  final String projectId;
  final int? serverId;

  @override
  Widget build(BuildContext context, GoRouterState state) => ActivityPage(
    scope: ProjectScope(accountId, projectId),
    serverId: serverId,
  );
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
