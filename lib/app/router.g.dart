// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $homeRoute,
  $showcaseRoute,
  $welcomeRoute,
  $setupRoute,
  $settingsRoute,
  $aboutRoute,
  $accountsRoute,
  $accountRoute,
  $addProjectRoute,
  $projectRoute,
  $serverRoute,
  $activityRoute,
  $allProjectsRoute,
  $robotRoute,
  $createRoute,
  $volumeRoute,
  $imageRoute,
  $placementGroupRoute,
  $sshKeyRoute,
  $networkRoute,
  $firewallRoute,
  $loadBalancerRoute,
  $certificateRoute,
  $zoneRoute,
  $ipRoute,
  $rRSetRoute,
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

RouteBase get $welcomeRoute => GoRouteData.$route(
  path: '/welcome',
  hasOverriddenOnExit: false,
  factory: $WelcomeRoute._fromState,
);

mixin $WelcomeRoute on GoRouteData {
  static WelcomeRoute _fromState(GoRouterState state) => const WelcomeRoute();

  @override
  String get location => GoRouteData.$location('/welcome');

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

RouteBase get $settingsRoute => GoRouteData.$route(
  path: '/settings',
  hasOverriddenOnExit: false,
  factory: $SettingsRoute._fromState,
);

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) =>
      SettingsRoute(active: state.uri.queryParameters['active']);

  SettingsRoute get _self => this as SettingsRoute;

  @override
  String get location => GoRouteData.$location(
    '/settings',
    queryParams: {if (_self.active != null) 'active': _self.active},
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

RouteBase get $aboutRoute => GoRouteData.$route(
  path: '/about',
  hasOverriddenOnExit: false,
  factory: $AboutRoute._fromState,
);

mixin $AboutRoute on GoRouteData {
  static AboutRoute _fromState(GoRouterState state) => const AboutRoute();

  @override
  String get location => GoRouteData.$location('/about');

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

RouteBase get $accountsRoute => GoRouteData.$route(
  path: '/accounts',
  hasOverriddenOnExit: false,
  factory: $AccountsRoute._fromState,
);

mixin $AccountsRoute on GoRouteData {
  static AccountsRoute _fromState(GoRouterState state) =>
      AccountsRoute(active: state.uri.queryParameters['active']);

  AccountsRoute get _self => this as AccountsRoute;

  @override
  String get location => GoRouteData.$location(
    '/accounts',
    queryParams: {if (_self.active != null) 'active': _self.active},
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

RouteBase get $accountRoute => GoRouteData.$route(
  path: '/accounts/:accountId',
  hasOverriddenOnExit: false,
  factory: $AccountRoute._fromState,
);

mixin $AccountRoute on GoRouteData {
  static AccountRoute _fromState(GoRouterState state) =>
      AccountRoute(accountId: state.pathParameters['accountId']!);

  AccountRoute get _self => this as AccountRoute;

  @override
  String get location => GoRouteData.$location(
    '/accounts/${Uri.encodeComponent(_self.accountId)}',
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

RouteBase get $createRoute => GoRouteData.$route(
  path: '/a/:accountId/create/:kind',
  hasOverriddenOnExit: false,
  factory: $CreateRoute._fromState,
);

mixin $CreateRoute on GoRouteData {
  static CreateRoute _fromState(GoRouterState state) => CreateRoute(
    accountId: state.pathParameters['accountId']!,
    kind: _$CreateKindEnumMap._$fromName(state.pathParameters['kind']!)!,
    projectId: state.uri.queryParameters['project-id'],
  );

  CreateRoute get _self => this as CreateRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/create/${Uri.encodeComponent(_$CreateKindEnumMap[_self.kind]!)}',
    queryParams: {if (_self.projectId != null) 'project-id': _self.projectId},
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

const _$CreateKindEnumMap = {
  CreateKind.server: 'server',
  CreateKind.volume: 'volume',
  CreateKind.placementGroup: 'placement-group',
  CreateKind.sshKey: 'ssh-key',
  CreateKind.network: 'network',
  CreateKind.firewall: 'firewall',
  CreateKind.floatingIp: 'floating-ip',
  CreateKind.primaryIp: 'primary-ip',
  CreateKind.loadBalancer: 'load-balancer',
  CreateKind.certificate: 'certificate',
  CreateKind.zone: 'zone',
};

extension<T extends Enum> on Map<T, String> {
  T? _$fromName(String? value) =>
      entries.where((element) => element.value == value).firstOrNull?.key;
}

RouteBase get $volumeRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/volumes/:volumeId',
  hasOverriddenOnExit: false,
  factory: $VolumeRoute._fromState,
);

mixin $VolumeRoute on GoRouteData {
  static VolumeRoute _fromState(GoRouterState state) => VolumeRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
    volumeId: int.parse(state.pathParameters['volumeId']!),
  );

  VolumeRoute get _self => this as VolumeRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/volumes/${Uri.encodeComponent(_self.volumeId.toString())}',
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

RouteBase get $imageRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/images/:imageId',
  hasOverriddenOnExit: false,
  factory: $ImageRoute._fromState,
);

mixin $ImageRoute on GoRouteData {
  static ImageRoute _fromState(GoRouterState state) => ImageRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
    imageId: int.parse(state.pathParameters['imageId']!),
  );

  ImageRoute get _self => this as ImageRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/images/${Uri.encodeComponent(_self.imageId.toString())}',
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

RouteBase get $placementGroupRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/placement-groups/:groupId',
  hasOverriddenOnExit: false,
  factory: $PlacementGroupRoute._fromState,
);

mixin $PlacementGroupRoute on GoRouteData {
  static PlacementGroupRoute _fromState(GoRouterState state) =>
      PlacementGroupRoute(
        accountId: state.pathParameters['accountId']!,
        projectId: state.pathParameters['projectId']!,
        groupId: int.parse(state.pathParameters['groupId']!),
      );

  PlacementGroupRoute get _self => this as PlacementGroupRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/placement-groups/${Uri.encodeComponent(_self.groupId.toString())}',
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

RouteBase get $sshKeyRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/ssh-keys/:keyId',
  hasOverriddenOnExit: false,
  factory: $SshKeyRoute._fromState,
);

mixin $SshKeyRoute on GoRouteData {
  static SshKeyRoute _fromState(GoRouterState state) => SshKeyRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
    keyId: int.parse(state.pathParameters['keyId']!),
  );

  SshKeyRoute get _self => this as SshKeyRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/ssh-keys/${Uri.encodeComponent(_self.keyId.toString())}',
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

RouteBase get $networkRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/networks/:networkId',
  hasOverriddenOnExit: false,
  factory: $NetworkRoute._fromState,
);

mixin $NetworkRoute on GoRouteData {
  static NetworkRoute _fromState(GoRouterState state) => NetworkRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
    networkId: int.parse(state.pathParameters['networkId']!),
  );

  NetworkRoute get _self => this as NetworkRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/networks/${Uri.encodeComponent(_self.networkId.toString())}',
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

RouteBase get $firewallRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/firewalls/:firewallId',
  hasOverriddenOnExit: false,
  factory: $FirewallRoute._fromState,
);

mixin $FirewallRoute on GoRouteData {
  static FirewallRoute _fromState(GoRouterState state) => FirewallRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
    firewallId: int.parse(state.pathParameters['firewallId']!),
  );

  FirewallRoute get _self => this as FirewallRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/firewalls/${Uri.encodeComponent(_self.firewallId.toString())}',
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

RouteBase get $loadBalancerRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/load-balancers/:lbId',
  hasOverriddenOnExit: false,
  factory: $LoadBalancerRoute._fromState,
);

mixin $LoadBalancerRoute on GoRouteData {
  static LoadBalancerRoute _fromState(GoRouterState state) => LoadBalancerRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
    lbId: int.parse(state.pathParameters['lbId']!),
  );

  LoadBalancerRoute get _self => this as LoadBalancerRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/load-balancers/${Uri.encodeComponent(_self.lbId.toString())}',
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

RouteBase get $certificateRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/certificates/:certificateId',
  hasOverriddenOnExit: false,
  factory: $CertificateRoute._fromState,
);

mixin $CertificateRoute on GoRouteData {
  static CertificateRoute _fromState(GoRouterState state) => CertificateRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
    certificateId: int.parse(state.pathParameters['certificateId']!),
  );

  CertificateRoute get _self => this as CertificateRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/certificates/${Uri.encodeComponent(_self.certificateId.toString())}',
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

RouteBase get $zoneRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/zones/:zoneId',
  hasOverriddenOnExit: false,
  factory: $ZoneRoute._fromState,
);

mixin $ZoneRoute on GoRouteData {
  static ZoneRoute _fromState(GoRouterState state) => ZoneRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
    zoneId: int.parse(state.pathParameters['zoneId']!),
  );

  ZoneRoute get _self => this as ZoneRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/zones/${Uri.encodeComponent(_self.zoneId.toString())}',
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

RouteBase get $ipRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/ips/:kind/:ipId',
  hasOverriddenOnExit: false,
  factory: $IpRoute._fromState,
);

mixin $IpRoute on GoRouteData {
  static IpRoute _fromState(GoRouterState state) => IpRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
    kind: _$IpKindEnumMap._$fromName(state.pathParameters['kind']!)!,
    ipId: int.parse(state.pathParameters['ipId']!),
  );

  IpRoute get _self => this as IpRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/ips/${Uri.encodeComponent(_$IpKindEnumMap[_self.kind]!)}/${Uri.encodeComponent(_self.ipId.toString())}',
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

const _$IpKindEnumMap = {
  IpKind.floating: 'floating',
  IpKind.primary: 'primary',
};

RouteBase get $rRSetRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/zones/:zoneId/rrsets/:name/:type',
  hasOverriddenOnExit: false,
  factory: $RRSetRoute._fromState,
);

mixin $RRSetRoute on GoRouteData {
  static RRSetRoute _fromState(GoRouterState state) => RRSetRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
    zoneId: int.parse(state.pathParameters['zoneId']!),
    name: state.pathParameters['name']!,
    type: state.pathParameters['type']!,
  );

  RRSetRoute get _self => this as RRSetRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/zones/${Uri.encodeComponent(_self.zoneId.toString())}/rrsets/${Uri.encodeComponent(_self.name)}/${Uri.encodeComponent(_self.type)}',
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
