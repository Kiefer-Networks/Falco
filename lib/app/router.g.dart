// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $homeRoute,
  $showcaseRoute,
  $setupRoute,
  $addProjectRoute,
  $projectRoute,
  $serverRoute,
  $activityRoute,
  $allProjectsRoute,
  $robotRoute,
];

RouteBase get $homeRoute => GoRouteData.$route(
  path: '/',
  hasOverriddenOnExit: false,
  factory: $HomeRoute._fromState,
);

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $showcaseRoute => GoRouteData.$route(
  path: '/showcase',
  hasOverriddenOnExit: false,
  factory: $ShowcaseRoute._fromState,
);

mixin $ShowcaseRoute on GoRouteData {
  static ShowcaseRoute _fromState(GoRouterState state) => const ShowcaseRoute();

  @override
  String get location => GoRouteData.$location('/showcase');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $setupRoute => GoRouteData.$route(
  path: '/setup',
  hasOverriddenOnExit: false,
  factory: $SetupRoute._fromState,
);

mixin $SetupRoute on GoRouteData {
  static SetupRoute _fromState(GoRouterState state) => const SetupRoute();

  @override
  String get location => GoRouteData.$location('/setup');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $addProjectRoute => GoRouteData.$route(
  path: '/a/:accountId/projects/new',
  hasOverriddenOnExit: false,
  factory: $AddProjectRoute._fromState,
);

mixin $AddProjectRoute on GoRouteData {
  static AddProjectRoute _fromState(GoRouterState state) =>
      AddProjectRoute(accountId: state.pathParameters['accountId']!);

  AddProjectRoute get _self => this as AddProjectRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/projects/new',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $projectRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId',
  hasOverriddenOnExit: false,
  factory: $ProjectRoute._fromState,
);

mixin $ProjectRoute on GoRouteData {
  static ProjectRoute _fromState(GoRouterState state) => ProjectRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
  );

  ProjectRoute get _self => this as ProjectRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $serverRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/servers/:serverId',
  hasOverriddenOnExit: false,
  factory: $ServerRoute._fromState,
);

mixin $ServerRoute on GoRouteData {
  static ServerRoute _fromState(GoRouterState state) => ServerRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
    serverId: int.parse(state.pathParameters['serverId']!),
  );

  ServerRoute get _self => this as ServerRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/servers/${Uri.encodeComponent(_self.serverId.toString())}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $activityRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/activity',
  hasOverriddenOnExit: false,
  factory: $ActivityRoute._fromState,
);

mixin $ActivityRoute on GoRouteData {
  static ActivityRoute _fromState(GoRouterState state) => ActivityRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
    serverId: _$convertMapValue(
      'server-id',
      state.uri.queryParameters,
      int.tryParse,
    ),
  );

  ActivityRoute get _self => this as ActivityRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/activity',
    queryParams: {
      if (_self.serverId != null) 'server-id': _self.serverId!.toString(),
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

RouteBase get $allProjectsRoute => GoRouteData.$route(
  path: '/a/:accountId/all',
  hasOverriddenOnExit: false,
  factory: $AllProjectsRoute._fromState,
);

mixin $AllProjectsRoute on GoRouteData {
  static AllProjectsRoute _fromState(GoRouterState state) =>
      AllProjectsRoute(accountId: state.pathParameters['accountId']!);

  AllProjectsRoute get _self => this as AllProjectsRoute;

  @override
  String get location =>
      GoRouteData.$location('/a/${Uri.encodeComponent(_self.accountId)}/all');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $robotRoute => GoRouteData.$route(
  path: '/a/:accountId/robot',
  hasOverriddenOnExit: false,
  factory: $RobotRoute._fromState,
);

mixin $RobotRoute on GoRouteData {
  static RobotRoute _fromState(GoRouterState state) =>
      RobotRoute(accountId: state.pathParameters['accountId']!);

  RobotRoute get _self => this as RobotRoute;

  @override
  String get location =>
      GoRouteData.$location('/a/${Uri.encodeComponent(_self.accountId)}/robot');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app router.

@ProviderFor(router)
final routerProvider = RouterProvider._();

/// The app router.

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// The app router.
  RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'6d1797c7ba7380280d3a38c2f60aa7ad2c5800de';
