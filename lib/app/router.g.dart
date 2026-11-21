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
  $searchRoute,
  $allProjectsRoute,
  $robotRoute,
  $resourcesRoute,
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
  $storageBoxRoute,
  $boxSnapshotRoute,
  $subaccountRoute,
  $bucketRoute,
  $robotServerRoute,
  $robotFirewallRoute,
  $robotFailoverRoute,
  $robotVSwitchRoute,
  $robotKeyRoute,
  $robotAddressRoute,
  $robotTemplateRoute,
  $robotTrafficRoute,
  $robotActivityRoute,
  $robotCreateRoute,
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
    area: _$convertMapValue('area', state.uri.queryParameters, int.parse) ?? 0,
  );

  ProjectRoute get _self => this as ProjectRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}',
    queryParams: {if (_self.area != 0) 'area': _self.area.toString()},
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
    type: state.uri.queryParameters['type'],
    id: _$convertMapValue('id', state.uri.queryParameters, int.tryParse),
  );

  ActivityRoute get _self => this as ActivityRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/activity',
    queryParams: {
      if (_self.type != null) 'type': _self.type,
      if (_self.id != null) 'id': _self.id!.toString(),
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

RouteBase get $searchRoute => GoRouteData.$route(
  path: '/search',
  hasOverriddenOnExit: false,
  factory: $SearchRoute._fromState,
);

mixin $SearchRoute on GoRouteData {
  static SearchRoute _fromState(GoRouterState state) => const SearchRoute();

  @override
  String get location => GoRouteData.$location('/search');

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

RouteBase get $allProjectsRoute => GoRouteData.$route(
  path: '/a/:accountId/all',
  hasOverriddenOnExit: false,
  factory: $AllProjectsRoute._fromState,
);

mixin $AllProjectsRoute on GoRouteData {
  static AllProjectsRoute _fromState(GoRouterState state) => AllProjectsRoute(
    accountId: state.pathParameters['accountId']!,
    area: _$convertMapValue('area', state.uri.queryParameters, int.parse) ?? 0,
  );

  AllProjectsRoute get _self => this as AllProjectsRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/all',
    queryParams: {if (_self.area != 0) 'area': _self.area.toString()},
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

RouteBase get $resourcesRoute => GoRouteData.$route(
  path: '/a/:accountId/list/:kind',
  hasOverriddenOnExit: false,
  factory: $ResourcesRoute._fromState,
);

mixin $ResourcesRoute on GoRouteData {
  static ResourcesRoute _fromState(GoRouterState state) => ResourcesRoute(
    accountId: state.pathParameters['accountId']!,
    kind: _$ResourceKindEnumMap._$fromName(state.pathParameters['kind']!)!,
    projectId: state.uri.queryParameters['project-id'],
  );

  ResourcesRoute get _self => this as ResourcesRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/list/${Uri.encodeComponent(_$ResourceKindEnumMap[_self.kind]!)}',
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

const _$ResourceKindEnumMap = {
  ResourceKind.servers: 'servers',
  ResourceKind.volumes: 'volumes',
  ResourceKind.images: 'images',
  ResourceKind.placementGroups: 'placement-groups',
  ResourceKind.sshKeys: 'ssh-keys',
  ResourceKind.networks: 'networks',
  ResourceKind.firewalls: 'firewalls',
  ResourceKind.floatingIps: 'floating-ips',
  ResourceKind.primaryIps: 'primary-ips',
  ResourceKind.loadBalancers: 'load-balancers',
  ResourceKind.certificates: 'certificates',
  ResourceKind.zones: 'zones',
  ResourceKind.storageBoxes: 'storage-boxes',
  ResourceKind.buckets: 'buckets',
  ResourceKind.robotServers: 'robot-servers',
  ResourceKind.failover: 'failover',
  ResourceKind.vswitches: 'vswitches',
  ResourceKind.rdns: 'rdns',
  ResourceKind.robotKeys: 'robot-keys',
  ResourceKind.robotIps: 'robot-ips',
  ResourceKind.robotSubnets: 'robot-subnets',
  ResourceKind.robotTemplates: 'robot-templates',
};

extension<T extends Enum> on Map<T, String> {
  T? _$fromName(String? value) =>
      entries.where((element) => element.value == value).firstOrNull?.key;
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
  CreateKind.storageBox: 'storage-box',
  CreateKind.bucket: 'bucket',
};

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

RouteBase get $storageBoxRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/storage-boxes/:boxId',
  hasOverriddenOnExit: false,
  factory: $StorageBoxRoute._fromState,
);

mixin $StorageBoxRoute on GoRouteData {
  static StorageBoxRoute _fromState(GoRouterState state) => StorageBoxRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
    boxId: int.parse(state.pathParameters['boxId']!),
  );

  StorageBoxRoute get _self => this as StorageBoxRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/storage-boxes/${Uri.encodeComponent(_self.boxId.toString())}',
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

RouteBase get $boxSnapshotRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/storage-boxes/:boxId/snapshots/:snapshotId',
  hasOverriddenOnExit: false,
  factory: $BoxSnapshotRoute._fromState,
);

mixin $BoxSnapshotRoute on GoRouteData {
  static BoxSnapshotRoute _fromState(GoRouterState state) => BoxSnapshotRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
    boxId: int.parse(state.pathParameters['boxId']!),
    snapshotId: int.parse(state.pathParameters['snapshotId']!),
  );

  BoxSnapshotRoute get _self => this as BoxSnapshotRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/storage-boxes/${Uri.encodeComponent(_self.boxId.toString())}/snapshots/${Uri.encodeComponent(_self.snapshotId.toString())}',
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

RouteBase get $subaccountRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/storage-boxes/:boxId/subaccounts/:subaccountId',
  hasOverriddenOnExit: false,
  factory: $SubaccountRoute._fromState,
);

mixin $SubaccountRoute on GoRouteData {
  static SubaccountRoute _fromState(GoRouterState state) => SubaccountRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
    boxId: int.parse(state.pathParameters['boxId']!),
    subaccountId: int.parse(state.pathParameters['subaccountId']!),
  );

  SubaccountRoute get _self => this as SubaccountRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/storage-boxes/${Uri.encodeComponent(_self.boxId.toString())}/subaccounts/${Uri.encodeComponent(_self.subaccountId.toString())}',
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

RouteBase get $bucketRoute => GoRouteData.$route(
  path: '/a/:accountId/p/:projectId/buckets/:region/:bucket',
  hasOverriddenOnExit: false,
  factory: $BucketRoute._fromState,
);

mixin $BucketRoute on GoRouteData {
  static BucketRoute _fromState(GoRouterState state) => BucketRoute(
    accountId: state.pathParameters['accountId']!,
    projectId: state.pathParameters['projectId']!,
    region: state.pathParameters['region']!,
    bucket: state.pathParameters['bucket']!,
    prefix: state.uri.queryParameters['prefix'] ?? '',
  );

  BucketRoute get _self => this as BucketRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/p/${Uri.encodeComponent(_self.projectId)}/buckets/${Uri.encodeComponent(_self.region)}/${Uri.encodeComponent(_self.bucket)}',
    queryParams: {if (_self.prefix != '') 'prefix': _self.prefix},
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

RouteBase get $robotServerRoute => GoRouteData.$route(
  path: '/a/:accountId/robot/servers/:number',
  hasOverriddenOnExit: false,
  factory: $RobotServerRoute._fromState,
);

mixin $RobotServerRoute on GoRouteData {
  static RobotServerRoute _fromState(GoRouterState state) => RobotServerRoute(
    accountId: state.pathParameters['accountId']!,
    number: int.parse(state.pathParameters['number']!),
  );

  RobotServerRoute get _self => this as RobotServerRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/robot/servers/${Uri.encodeComponent(_self.number.toString())}',
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

RouteBase get $robotFirewallRoute => GoRouteData.$route(
  path: '/a/:accountId/robot/servers/:number/firewall',
  hasOverriddenOnExit: false,
  factory: $RobotFirewallRoute._fromState,
);

mixin $RobotFirewallRoute on GoRouteData {
  static RobotFirewallRoute _fromState(GoRouterState state) =>
      RobotFirewallRoute(
        accountId: state.pathParameters['accountId']!,
        number: int.parse(state.pathParameters['number']!),
      );

  RobotFirewallRoute get _self => this as RobotFirewallRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/robot/servers/${Uri.encodeComponent(_self.number.toString())}/firewall',
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

RouteBase get $robotFailoverRoute => GoRouteData.$route(
  path: '/a/:accountId/robot/failover/:ip',
  hasOverriddenOnExit: false,
  factory: $RobotFailoverRoute._fromState,
);

mixin $RobotFailoverRoute on GoRouteData {
  static RobotFailoverRoute _fromState(GoRouterState state) =>
      RobotFailoverRoute(
        accountId: state.pathParameters['accountId']!,
        ip: state.pathParameters['ip']!,
      );

  RobotFailoverRoute get _self => this as RobotFailoverRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/robot/failover/${Uri.encodeComponent(_self.ip)}',
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

RouteBase get $robotVSwitchRoute => GoRouteData.$route(
  path: '/a/:accountId/robot/vswitches/:id',
  hasOverriddenOnExit: false,
  factory: $RobotVSwitchRoute._fromState,
);

mixin $RobotVSwitchRoute on GoRouteData {
  static RobotVSwitchRoute _fromState(GoRouterState state) => RobotVSwitchRoute(
    accountId: state.pathParameters['accountId']!,
    id: int.parse(state.pathParameters['id']!),
  );

  RobotVSwitchRoute get _self => this as RobotVSwitchRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/robot/vswitches/${Uri.encodeComponent(_self.id.toString())}',
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

RouteBase get $robotKeyRoute => GoRouteData.$route(
  path: '/a/:accountId/robot/keys/:fingerprint',
  hasOverriddenOnExit: false,
  factory: $RobotKeyRoute._fromState,
);

mixin $RobotKeyRoute on GoRouteData {
  static RobotKeyRoute _fromState(GoRouterState state) => RobotKeyRoute(
    accountId: state.pathParameters['accountId']!,
    fingerprint: state.pathParameters['fingerprint']!,
  );

  RobotKeyRoute get _self => this as RobotKeyRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/robot/keys/${Uri.encodeComponent(_self.fingerprint)}',
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

RouteBase get $robotAddressRoute => GoRouteData.$route(
  path: '/a/:accountId/robot/addresses/:kind/:ip',
  hasOverriddenOnExit: false,
  factory: $RobotAddressRoute._fromState,
);

mixin $RobotAddressRoute on GoRouteData {
  static RobotAddressRoute _fromState(GoRouterState state) => RobotAddressRoute(
    accountId: state.pathParameters['accountId']!,
    kind: _$AddressKindEnumMap._$fromName(state.pathParameters['kind']!)!,
    ip: state.pathParameters['ip']!,
  );

  RobotAddressRoute get _self => this as RobotAddressRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/robot/addresses/${Uri.encodeComponent(_$AddressKindEnumMap[_self.kind]!)}/${Uri.encodeComponent(_self.ip)}',
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

const _$AddressKindEnumMap = {
  AddressKind.ip: 'ip',
  AddressKind.subnet: 'subnet',
};

RouteBase get $robotTemplateRoute => GoRouteData.$route(
  path: '/a/:accountId/robot/templates/:id',
  hasOverriddenOnExit: false,
  factory: $RobotTemplateRoute._fromState,
);

mixin $RobotTemplateRoute on GoRouteData {
  static RobotTemplateRoute _fromState(GoRouterState state) =>
      RobotTemplateRoute(
        accountId: state.pathParameters['accountId']!,
        id: int.parse(state.pathParameters['id']!),
      );

  RobotTemplateRoute get _self => this as RobotTemplateRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/robot/templates/${Uri.encodeComponent(_self.id.toString())}',
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

RouteBase get $robotTrafficRoute => GoRouteData.$route(
  path: '/a/:accountId/robot/traffic',
  hasOverriddenOnExit: false,
  factory: $RobotTrafficRoute._fromState,
);

mixin $RobotTrafficRoute on GoRouteData {
  static RobotTrafficRoute _fromState(GoRouterState state) => RobotTrafficRoute(
    accountId: state.pathParameters['accountId']!,
    ip: state.uri.queryParameters['ip'],
    subnet: state.uri.queryParameters['subnet'],
  );

  RobotTrafficRoute get _self => this as RobotTrafficRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/robot/traffic',
    queryParams: {
      if (_self.ip != null) 'ip': _self.ip,
      if (_self.subnet != null) 'subnet': _self.subnet,
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

RouteBase get $robotActivityRoute => GoRouteData.$route(
  path: '/a/:accountId/robot/activity',
  hasOverriddenOnExit: false,
  factory: $RobotActivityRoute._fromState,
);

mixin $RobotActivityRoute on GoRouteData {
  static RobotActivityRoute _fromState(GoRouterState state) =>
      RobotActivityRoute(accountId: state.pathParameters['accountId']!);

  RobotActivityRoute get _self => this as RobotActivityRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/robot/activity',
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

RouteBase get $robotCreateRoute => GoRouteData.$route(
  path: '/a/:accountId/robot/create/:kind',
  hasOverriddenOnExit: false,
  factory: $RobotCreateRoute._fromState,
);

mixin $RobotCreateRoute on GoRouteData {
  static RobotCreateRoute _fromState(GoRouterState state) => RobotCreateRoute(
    accountId: state.pathParameters['accountId']!,
    kind: _$RobotCreateKindEnumMap._$fromName(state.pathParameters['kind']!)!,
  );

  RobotCreateRoute get _self => this as RobotCreateRoute;

  @override
  String get location => GoRouteData.$location(
    '/a/${Uri.encodeComponent(_self.accountId)}/robot/create/${Uri.encodeComponent(_$RobotCreateKindEnumMap[_self.kind]!)}',
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

const _$RobotCreateKindEnumMap = {
  RobotCreateKind.vswitch: 'vswitch',
  RobotCreateKind.rdns: 'rdns',
  RobotCreateKind.key: 'key',
  RobotCreateKind.template: 'template',
};

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
