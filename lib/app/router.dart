// SPDX-License-Identifier: GPL-3.0-or-later
/// Typed routes. Every route below the root carries its Scope in the path
/// (`/a/:accountId/p/:projectId/...`), so back, deep links and process
/// restore need no hidden state (QRS-003).
library;

import 'package:falco/api/robot/robot_client.dart';
import 'package:falco/app/scope_home.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/features/accounts/account_pages.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/activity/activity_page.dart';
import 'package:falco/features/dns/zone_pages.dart';
import 'package:falco/features/images/image_pages.dart';
import 'package:falco/features/network/certificate_pages.dart';
import 'package:falco/features/network/firewall_pages.dart';
import 'package:falco/features/network/ip_pages.dart';
import 'package:falco/features/network/ips.dart';
import 'package:falco/features/network/load_balancer_pages.dart';
import 'package:falco/features/network/network_pages.dart';
import 'package:falco/features/onboarding/welcome_page.dart';
import 'package:falco/features/placement_groups/placement_group_pages.dart';
import 'package:falco/features/robot/robot_pages.dart';
import 'package:falco/features/robot/robot_server_page.dart';
import 'package:falco/features/search/search_page.dart';
import 'package:falco/features/servers/create_server_page.dart';
import 'package:falco/features/servers/server_detail_page.dart';
import 'package:falco/features/settings/settings_page.dart';
import 'package:falco/features/ssh_keys/ssh_key_pages.dart';
import 'package:falco/features/storage/object_pages.dart';
import 'package:falco/features/storage/storage_box_pages.dart';
import 'package:falco/features/storage/storage_boxes.dart';
import 'package:falco/features/volumes/volume_pages.dart';
import 'package:falco/ui/showcase/showcase_page.dart';
import 'package:falco/ui/ui.dart';
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

/// Start: the first scope of the default account (ONB-027), else of the
/// first account, or the welcome pages when there is none (ONB-006).
@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData with $HomeRoute {
  const new();

  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final container = ProviderScope.containerOf(context, listen: false);
    final accounts = await container.read(accountsProvider.future);
    final preferred = container.read(appSettingsProvider).defaultAccount;
    final a =
        accounts.where((a) => a.id == preferred).firstOrNull ??
        accounts.firstOrNull;
    if (a == null) return const WelcomeRoute().location;
    if (firstScope(a) case final scope?) return scopeRoute(scope).location;
    return AddProjectRoute(accountId: a.id).location;
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
      final s = ref.watch(appSettingsProvider);
      return ShowcasePage(
        variant: s.variant ?? FalcoVariant.dark,
        accent: s.accent,
        onThemeChanged: (variant, accent) => ref
            .read(appSettingsProvider.notifier)
            .update(s.copyWith(variant: () => variant, accent: accent)),
      );
    },
  );
}

/// First start without an account (ONB-001).
@TypedGoRoute<WelcomeRoute>(path: '/welcome')
class WelcomeRoute extends GoRouteData with $WelcomeRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const WelcomePage();
}

/// New account wizard (ONB-007).
@TypedGoRoute<SetupRoute>(path: '/setup')
class SetupRoute extends GoRouteData with $SetupRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AccountWizardPage();
}

/// Settings; [active] is the account of the scope the user came from.
@TypedGoRoute<SettingsRoute>(path: '/settings')
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const new({this.active});

  final String? active;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SettingsPage(activeAccountId: active);
}

/// About Falco (ONB-040).
@TypedGoRoute<AboutRoute>(path: '/about')
class AboutRoute extends GoRouteData with $AboutRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const AboutPage();
}

/// All accounts (ONB-021).
@TypedGoRoute<AccountsRoute>(path: '/accounts')
class AccountsRoute extends GoRouteData with $AccountsRoute {
  const new({this.active});

  final String? active;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AccountsPage(activeAccountId: active);
}

/// One account with its projects and accesses.
@TypedGoRoute<AccountRoute>(path: '/accounts/:accountId')
class AccountRoute extends GoRouteData with $AccountRoute {
  const new({required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AccountPage(accountId: accountId);
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

/// Home of one Cloud project, on tab `?area=` (0 Compute, 1 Network,
/// 2 Storage).
@TypedGoRoute<ProjectRoute>(path: '/a/:accountId/p/:projectId')
class ProjectRoute extends GoRouteData with $ProjectRoute {
  /// Creates the route.
  const new({required this.accountId, required this.projectId, this.area = 0});

  /// Account id.
  final String accountId;

  /// Project id.
  final String projectId;

  /// Bottom tab shown first.
  final int area;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ScopeHomePage(scope: ProjectScope(accountId, projectId), area: area);
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

/// Activity of a project, or of one resource with `?type=&id=`.
@TypedGoRoute<ActivityRoute>(path: '/a/:accountId/p/:projectId/activity')
class ActivityRoute extends GoRouteData with $ActivityRoute {
  const new({
    required this.accountId,
    required this.projectId,
    this.type,
    this.id,
  });

  final String accountId;
  final String projectId;

  /// Resource type as the API names it, e.g. `server`.
  final String? type;
  final int? id;

  @override
  Widget build(BuildContext context, GoRouterState state) => ActivityPage(
    scope: ProjectScope(accountId, projectId),
    type: type,
    id: id,
  );
}

/// Search over every account, project and Robot access (SUC-001).
@TypedGoRoute<SearchRoute>(path: '/search')
class SearchRoute extends GoRouteData with $SearchRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SearchPage();
}

/// The detail route of Cloud resource [type] [id] in [scope], or null
/// for a type without a page of its own (activity and search links).
GoRouteData? resourceRoute(ProjectScope scope, String type, int id) {
  final (a, p) = (scope.accountId, scope.projectId);
  return switch (type) {
    CloudType.server => ServerRoute(accountId: a, projectId: p, serverId: id),
    CloudType.volume => VolumeRoute(accountId: a, projectId: p, volumeId: id),
    CloudType.image => ImageRoute(accountId: a, projectId: p, imageId: id),
    CloudType.placementGroup => PlacementGroupRoute(
      accountId: a,
      projectId: p,
      groupId: id,
    ),
    CloudType.sshKey => SshKeyRoute(accountId: a, projectId: p, keyId: id),
    CloudType.network => NetworkRoute(
      accountId: a,
      projectId: p,
      networkId: id,
    ),
    CloudType.firewall => FirewallRoute(
      accountId: a,
      projectId: p,
      firewallId: id,
    ),
    CloudType.floatingIp => IpRoute(
      accountId: a,
      projectId: p,
      kind: IpKind.floating,
      ipId: id,
    ),
    CloudType.primaryIp => IpRoute(
      accountId: a,
      projectId: p,
      kind: IpKind.primary,
      ipId: id,
    ),
    CloudType.loadBalancer => LoadBalancerRoute(
      accountId: a,
      projectId: p,
      lbId: id,
    ),
    CloudType.certificate => CertificateRoute(
      accountId: a,
      projectId: p,
      certificateId: id,
    ),
    CloudType.zone => ZoneRoute(accountId: a, projectId: p, zoneId: id),
    storageBoxType => StorageBoxRoute(accountId: a, projectId: p, boxId: id),
    _ => null,
  };
}

/// Home of "all projects" of an account, on tab `?area=`.
@TypedGoRoute<AllProjectsRoute>(path: '/a/:accountId/all')
class AllProjectsRoute extends GoRouteData with $AllProjectsRoute {
  /// Creates the route.
  const new({required this.accountId, this.area = 0});

  /// Account id.
  final String accountId;

  /// Bottom tab shown first.
  final int area;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ScopeHomePage(scope: AllProjectsScope(accountId), area: area);
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

/// What a create wizard creates.
enum CreateKind {
  server,
  volume,
  placementGroup,
  sshKey,
  network,
  firewall,
  floatingIp,
  primaryIp,
  loadBalancer,
  certificate,
  zone,
  storageBox,
  bucket,
}

/// Create wizard of [kind] for a project, or for "All projects" when
/// [projectId] is null (the wizard then asks for the project first).
@TypedGoRoute<CreateRoute>(path: '/a/:accountId/create/:kind')
class CreateRoute extends GoRouteData with $CreateRoute {
  const new({required this.accountId, required this.kind, this.projectId});

  /// The route creating [kind] in [scope].
  factory of(Scope scope, CreateKind kind) => CreateRoute(
    accountId: scope.accountId,
    kind: kind,
    projectId: scope is ProjectScope ? scope.projectId : null,
  );

  final String accountId;
  final CreateKind kind;
  final String? projectId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final scope = projectId == null
        ? AllProjectsScope(accountId)
        : ProjectScope(accountId, projectId!);
    return switch (kind) {
      CreateKind.server => CreateServerPage(scope: scope),
      CreateKind.volume => CreateVolumePage(scope: scope),
      CreateKind.placementGroup => CreatePlacementGroupPage(scope: scope),
      CreateKind.sshKey => CreateSshKeyPage(scope: scope),
      CreateKind.network => CreateNetworkPage(scope: scope),
      CreateKind.firewall => CreateFirewallPage(scope: scope),
      CreateKind.floatingIp => CreateIpPage(
        scope: scope,
        kind: IpKind.floating,
      ),
      CreateKind.primaryIp => CreateIpPage(scope: scope, kind: IpKind.primary),
      CreateKind.loadBalancer => CreateLoadBalancerPage(scope: scope),
      CreateKind.certificate => CreateCertificatePage(scope: scope),
      CreateKind.zone => CreateZonePage(scope: scope),
      CreateKind.storageBox => CreateStorageBoxPage(scope: scope),
      CreateKind.bucket => CreateBucketPage(scope: scope),
    };
  }
}

/// One volume.
@TypedGoRoute<VolumeRoute>(path: '/a/:accountId/p/:projectId/volumes/:volumeId')
class VolumeRoute extends GoRouteData with $VolumeRoute {
  const new({
    required this.accountId,
    required this.projectId,
    required this.volumeId,
  });

  final String accountId;
  final String projectId;
  final int volumeId;

  @override
  Widget build(BuildContext context, GoRouterState state) => VolumeDetailPage(
    scope: ProjectScope(accountId, projectId),
    volumeId: volumeId,
  );
}

/// One snapshot or backup.
@TypedGoRoute<ImageRoute>(path: '/a/:accountId/p/:projectId/images/:imageId')
class ImageRoute extends GoRouteData with $ImageRoute {
  const new({
    required this.accountId,
    required this.projectId,
    required this.imageId,
  });

  final String accountId;
  final String projectId;
  final int imageId;

  @override
  Widget build(BuildContext context, GoRouterState state) => ImageDetailPage(
    scope: ProjectScope(accountId, projectId),
    imageId: imageId,
  );
}

/// One placement group.
@TypedGoRoute<PlacementGroupRoute>(
  path: '/a/:accountId/p/:projectId/placement-groups/:groupId',
)
class PlacementGroupRoute extends GoRouteData with $PlacementGroupRoute {
  const new({
    required this.accountId,
    required this.projectId,
    required this.groupId,
  });

  final String accountId;
  final String projectId;
  final int groupId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PlacementGroupDetailPage(
        scope: ProjectScope(accountId, projectId),
        groupId: groupId,
      );
}

/// One SSH key.
@TypedGoRoute<SshKeyRoute>(path: '/a/:accountId/p/:projectId/ssh-keys/:keyId')
class SshKeyRoute extends GoRouteData with $SshKeyRoute {
  const new({
    required this.accountId,
    required this.projectId,
    required this.keyId,
  });

  final String accountId;
  final String projectId;
  final int keyId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SshKeyDetailPage(scope: ProjectScope(accountId, projectId), keyId: keyId);
}

/// One private network.
@TypedGoRoute<NetworkRoute>(
  path: '/a/:accountId/p/:projectId/networks/:networkId',
)
class NetworkRoute extends GoRouteData with $NetworkRoute {
  const new({
    required this.accountId,
    required this.projectId,
    required this.networkId,
  });

  final String accountId;
  final String projectId;
  final int networkId;

  @override
  Widget build(BuildContext context, GoRouterState state) => NetworkDetailPage(
    scope: ProjectScope(accountId, projectId),
    networkId: networkId,
  );
}

/// One firewall.
@TypedGoRoute<FirewallRoute>(
  path: '/a/:accountId/p/:projectId/firewalls/:firewallId',
)
class FirewallRoute extends GoRouteData with $FirewallRoute {
  const new({
    required this.accountId,
    required this.projectId,
    required this.firewallId,
  });

  final String accountId;
  final String projectId;
  final int firewallId;

  @override
  Widget build(BuildContext context, GoRouterState state) => FirewallDetailPage(
    scope: ProjectScope(accountId, projectId),
    firewallId: firewallId,
  );
}

/// One load balancer.
@TypedGoRoute<LoadBalancerRoute>(
  path: '/a/:accountId/p/:projectId/load-balancers/:lbId',
)
class LoadBalancerRoute extends GoRouteData with $LoadBalancerRoute {
  const new({
    required this.accountId,
    required this.projectId,
    required this.lbId,
  });

  final String accountId;
  final String projectId;
  final int lbId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      LoadBalancerDetailPage(
        scope: ProjectScope(accountId, projectId),
        lbId: lbId,
      );
}

/// One certificate.
@TypedGoRoute<CertificateRoute>(
  path: '/a/:accountId/p/:projectId/certificates/:certificateId',
)
class CertificateRoute extends GoRouteData with $CertificateRoute {
  const new({
    required this.accountId,
    required this.projectId,
    required this.certificateId,
  });

  final String accountId;
  final String projectId;
  final int certificateId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CertificateDetailPage(
        scope: ProjectScope(accountId, projectId),
        certificateId: certificateId,
      );
}

/// One DNS zone.
@TypedGoRoute<ZoneRoute>(path: '/a/:accountId/p/:projectId/zones/:zoneId')
class ZoneRoute extends GoRouteData with $ZoneRoute {
  const new({
    required this.accountId,
    required this.projectId,
    required this.zoneId,
  });

  final String accountId;
  final String projectId;
  final int zoneId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ZoneDetailPage(scope: ProjectScope(accountId, projectId), zoneId: zoneId);
}

/// One Floating or Primary IP.
@TypedGoRoute<IpRoute>(path: '/a/:accountId/p/:projectId/ips/:kind/:ipId')
class IpRoute extends GoRouteData with $IpRoute {
  const new({
    required this.accountId,
    required this.projectId,
    required this.kind,
    required this.ipId,
  });

  final String accountId;
  final String projectId;
  final IpKind kind;
  final int ipId;

  @override
  Widget build(BuildContext context, GoRouterState state) => IpDetailPage(
    scope: ProjectScope(accountId, projectId),
    kind: kind,
    ipId: ipId,
  );
}

/// One RRSet of a zone: name and type are its key.
@TypedGoRoute<RRSetRoute>(
  path: '/a/:accountId/p/:projectId/zones/:zoneId/rrsets/:name/:type',
)
class RRSetRoute extends GoRouteData with $RRSetRoute {
  const new({
    required this.accountId,
    required this.projectId,
    required this.zoneId,
    required this.name,
    required this.type,
  });

  final String accountId;
  final String projectId;
  final int zoneId;
  final String name;
  final String type;

  @override
  Widget build(BuildContext context, GoRouterState state) => RRSetDetailPage(
    scope: ProjectScope(accountId, projectId),
    zoneId: zoneId,
    name: name,
    type: type,
  );
}

/// One Storage Box.
@TypedGoRoute<StorageBoxRoute>(
  path: '/a/:accountId/p/:projectId/storage-boxes/:boxId',
)
class StorageBoxRoute extends GoRouteData with $StorageBoxRoute {
  const new({
    required this.accountId,
    required this.projectId,
    required this.boxId,
  });

  final String accountId;
  final String projectId;
  final int boxId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      StorageBoxDetailPage(
        scope: ProjectScope(accountId, projectId),
        boxId: boxId,
      );
}

/// One snapshot of a Storage Box.
@TypedGoRoute<BoxSnapshotRoute>(
  path: '/a/:accountId/p/:projectId/storage-boxes/:boxId/snapshots/:snapshotId',
)
class BoxSnapshotRoute extends GoRouteData with $BoxSnapshotRoute {
  const new({
    required this.accountId,
    required this.projectId,
    required this.boxId,
    required this.snapshotId,
  });

  final String accountId;
  final String projectId;
  final int boxId;
  final int snapshotId;

  @override
  Widget build(BuildContext context, GoRouterState state) => BoxSnapshotPage(
    scope: ProjectScope(accountId, projectId),
    boxId: boxId,
    snapshotId: snapshotId,
  );
}

/// One subaccount of a Storage Box.
@TypedGoRoute<SubaccountRoute>(
  path: '/a/:accountId/p/:projectId/storage-boxes/:boxId/subaccounts/:subaccountId',
)
class SubaccountRoute extends GoRouteData with $SubaccountRoute {
  const new({
    required this.accountId,
    required this.projectId,
    required this.boxId,
    required this.subaccountId,
  });

  final String accountId;
  final String projectId;
  final int boxId;
  final int subaccountId;

  @override
  Widget build(BuildContext context, GoRouterState state) => SubaccountPage(
    scope: ProjectScope(accountId, projectId),
    boxId: boxId,
    subaccountId: subaccountId,
  );
}

/// The object browser of a bucket at location [region], below
/// `?prefix=`.
@TypedGoRoute<BucketRoute>(
  path: '/a/:accountId/p/:projectId/buckets/:region/:bucket',
)
class BucketRoute extends GoRouteData with $BucketRoute {
  const new({
    required this.accountId,
    required this.projectId,
    required this.region,
    required this.bucket,
    this.prefix = '',
  });

  final String accountId;
  final String projectId;
  final String region;
  final String bucket;
  final String prefix;

  @override
  Widget build(BuildContext context, GoRouterState state) => BucketPage(
    scope: ProjectScope(accountId, projectId),
    location: region,
    bucket: bucket,
    prefix: prefix,
  );
}

/// One dedicated server.
@TypedGoRoute<RobotServerRoute>(path: '/a/:accountId/robot/servers/:number')
class RobotServerRoute extends GoRouteData with $RobotServerRoute {
  const new({required this.accountId, required this.number});

  final String accountId;
  final int number;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RobotServerPage(accountId: accountId, number: number);
}

/// The firewall of a dedicated server.
@TypedGoRoute<RobotFirewallRoute>(
  path: '/a/:accountId/robot/servers/:number/firewall',
)
class RobotFirewallRoute extends GoRouteData with $RobotFirewallRoute {
  const new({required this.accountId, required this.number});

  final String accountId;
  final int number;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RobotFirewallPage(accountId: accountId, number: number);
}

/// One failover IP.
@TypedGoRoute<RobotFailoverRoute>(path: '/a/:accountId/robot/failover/:ip')
class RobotFailoverRoute extends GoRouteData with $RobotFailoverRoute {
  const new({required this.accountId, required this.ip});

  final String accountId;
  final String ip;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RobotFailoverPage(accountId: accountId, ip: ip);
}

/// One vSwitch.
@TypedGoRoute<RobotVSwitchRoute>(path: '/a/:accountId/robot/vswitches/:id')
class RobotVSwitchRoute extends GoRouteData with $RobotVSwitchRoute {
  const new({required this.accountId, required this.id});

  final String accountId;
  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RobotVSwitchPage(accountId: accountId, id: id);
}

/// One Robot SSH key.
@TypedGoRoute<RobotKeyRoute>(path: '/a/:accountId/robot/keys/:fingerprint')
class RobotKeyRoute extends GoRouteData with $RobotKeyRoute {
  const new({required this.accountId, required this.fingerprint});

  final String accountId;
  final String fingerprint;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RobotKeyPage(accountId: accountId, fingerprint: fingerprint);
}

/// One single IP or subnet.
@TypedGoRoute<RobotAddressRoute>(
  path: '/a/:accountId/robot/addresses/:kind/:ip',
)
class RobotAddressRoute extends GoRouteData with $RobotAddressRoute {
  const new({required this.accountId, required this.kind, required this.ip});

  final String accountId;
  final AddressKind kind;
  final String ip;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RobotAddressPage(accountId: accountId, kind: kind, ip: ip);
}

/// One firewall template.
@TypedGoRoute<RobotTemplateRoute>(path: '/a/:accountId/robot/templates/:id')
class RobotTemplateRoute extends GoRouteData with $RobotTemplateRoute {
  const new({required this.accountId, required this.id});

  final String accountId;
  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RobotTemplatePage(accountId: accountId, id: id);
}

/// Traffic of `?ip=` or `?subnet=`.
@TypedGoRoute<RobotTrafficRoute>(path: '/a/:accountId/robot/traffic')
class RobotTrafficRoute extends GoRouteData with $RobotTrafficRoute {
  const new({required this.accountId, this.ip, this.subnet});

  final String accountId;
  final String? ip;
  final String? subnet;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RobotTrafficPage(accountId: accountId, ip: ip, subnet: subnet);
}

/// Robot changes of this session.
@TypedGoRoute<RobotActivityRoute>(path: '/a/:accountId/robot/activity')
class RobotActivityRoute extends GoRouteData with $RobotActivityRoute {
  const new({required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RobotActivityPage(accountId: accountId);
}

/// What a Robot create wizard creates.
enum RobotCreateKind { vswitch, rdns, key, template }

/// Create wizard of [kind] in Robot.
@TypedGoRoute<RobotCreateRoute>(path: '/a/:accountId/robot/create/:kind')
class RobotCreateRoute extends GoRouteData with $RobotCreateRoute {
  const new({required this.accountId, required this.kind});

  final String accountId;
  final RobotCreateKind kind;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RobotCreatePage(accountId: accountId, kind: kind);
}
