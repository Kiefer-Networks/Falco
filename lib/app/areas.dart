// SPDX-License-Identifier: GPL-3.0-or-later
/// The resource types of each area and the two screens built from them:
/// the area overview (one tile per type) and the list of one type with
/// its one create button.
library;

import 'package:falco/api/robot/robot_client.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/dns/zone_pages.dart';
import 'package:falco/features/dns/zones.dart';
import 'package:falco/features/images/image_pages.dart';
import 'package:falco/features/images/images.dart';
import 'package:falco/features/network/certificate_pages.dart';
import 'package:falco/features/network/certificates.dart';
import 'package:falco/features/network/firewall_pages.dart';
import 'package:falco/features/network/firewalls.dart';
import 'package:falco/features/network/ip_pages.dart';
import 'package:falco/features/network/ips.dart';
import 'package:falco/features/network/load_balancer_pages.dart';
import 'package:falco/features/network/load_balancers.dart';
import 'package:falco/features/network/network_pages.dart';
import 'package:falco/features/network/networks.dart';
import 'package:falco/features/placement_groups/placement_group_pages.dart';
import 'package:falco/features/placement_groups/placement_groups.dart';
import 'package:falco/features/robot/robot.dart';
import 'package:falco/features/robot/robot_lists.dart';
import 'package:falco/features/servers/server_list.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/features/ssh_keys/ssh_key_pages.dart';
import 'package:falco/features/ssh_keys/ssh_keys.dart';
import 'package:falco/features/storage/object_pages.dart';
import 'package:falco/features/storage/object_storage.dart';
import 'package:falco/features/storage/storage_box_pages.dart';
import 'package:falco/features/storage/storage_boxes.dart';
import 'package:falco/features/volumes/volume_pages.dart';
import 'package:falco/features/volumes/volumes.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Areas of the bottom navigation, in order.
enum Area { compute, network, storage, robot }

/// Rows a tile with a preview shows (servers, dedicated servers).
const _previewRows = 5;

/// Every resource type, grouped by [area] in display order (README
/// section 3). One place names its list, its create wizard and how its
/// overview tile counts.
enum ResourceKind {
  servers(Area.compute),
  volumes(Area.compute),
  images(Area.compute),
  placementGroups(Area.compute),
  sshKeys(Area.compute),
  networks(Area.network),
  firewalls(Area.network),
  floatingIps(Area.network),
  primaryIps(Area.network),
  loadBalancers(Area.network),
  certificates(Area.network),
  zones(Area.network),
  storageBoxes(Area.storage),
  buckets(Area.storage),
  robotServers(Area.robot),
  failover(Area.robot),
  vswitches(Area.robot),
  rdns(Area.robot),
  robotKeys(Area.robot),
  robotIps(Area.robot),
  robotSubnets(Area.robot),
  robotTemplates(Area.robot);

  new(this.area);

  /// Area the type belongs to.
  final Area area;

  /// Types of [area] in display order.
  static List<ResourceKind> of(Area area) => [
    for (final k in values)
      if (k.area == area) k,
  ];

  /// Localized plural name.
  String label(AppLocalizations l10n) => switch (this) {
    servers => l10n.resourceServers,
    volumes => l10n.resourceVolumes,
    images => l10n.resourceImages,
    placementGroups => l10n.resourcePlacementGroups,
    sshKeys => l10n.resourceSshKeys,
    networks => l10n.resourceNetworks,
    firewalls => l10n.resourceFirewalls,
    floatingIps => l10n.resourceFloatingIps,
    primaryIps => l10n.resourcePrimaryIps,
    loadBalancers => l10n.resourceLoadBalancers,
    certificates => l10n.resourceCertificates,
    zones => l10n.resourceZones,
    storageBoxes => l10n.resourceStorageBoxes,
    buckets => l10n.resourceObjectStorage,
    robotServers => l10n.robotServers,
    failover => l10n.robotFailover,
    vswitches => l10n.robotVSwitches,
    rdns => l10n.reverseDns,
    robotKeys => l10n.resourceSshKeys,
    robotIps => l10n.robotIps,
    robotSubnets => l10n.robotSubnets,
    robotTemplates => l10n.robotTemplates,
  };

  /// Icon of tile and list.
  IconData get icon => switch (this) {
    servers => Icons.dns_outlined,
    volumes => Icons.save_outlined,
    images => Icons.photo_library_outlined,
    placementGroups => Icons.scatter_plot_outlined,
    sshKeys || robotKeys => Icons.key_outlined,
    networks => Icons.hub_outlined,
    firewalls || robotTemplates => Icons.shield_outlined,
    floatingIps => Icons.place_outlined,
    primaryIps || robotIps => Icons.lan_outlined,
    loadBalancers => Icons.call_split,
    certificates => Icons.verified_user_outlined,
    zones => Icons.language,
    storageBoxes => Icons.inventory_2_outlined,
    buckets => Icons.cloud_outlined,
    robotServers => Icons.storage_outlined,
    failover => Icons.swap_horiz,
    vswitches => Icons.device_hub,
    rdns => Icons.dns,
    robotSubnets => Icons.account_tree_outlined,
  };

  /// The list of this type in [scope].
  Widget list(Scope scope) {
    final a = scope.accountId;
    return switch (this) {
      servers => ServerList(scope: scope),
      volumes => VolumeList(scope: scope),
      images => ImageList(scope: scope),
      placementGroups => PlacementGroupList(scope: scope),
      sshKeys => SshKeyList(scope: scope),
      networks => NetworkList(scope: scope),
      firewalls => FirewallList(scope: scope),
      floatingIps => IpList(scope: scope, kind: IpKind.floating),
      primaryIps => IpList(scope: scope, kind: IpKind.primary),
      loadBalancers => LoadBalancerList(scope: scope),
      certificates => CertificateList(scope: scope),
      zones => ZoneList(scope: scope),
      storageBoxes => StorageBoxList(scope: scope),
      buckets => BucketList(scope: scope),
      robotServers => RobotServerList(accountId: a),
      failover => FailoverList(accountId: a),
      vswitches => VSwitchList(accountId: a),
      rdns => RdnsList(accountId: a),
      robotKeys => RobotKeyList(accountId: a),
      robotIps => AddressList(accountId: a, kind: AddressKind.ip),
      robotSubnets => AddressList(accountId: a, kind: AddressKind.subnet),
      robotTemplates => TemplateList(accountId: a),
    };
  }

  /// Label and route of the create wizard; null for types that are not
  /// created here (images come from servers, failover IPs, Robot servers,
  /// IPs and subnets from orders).
  (String, GoRouteData)? create(AppLocalizations l10n, Scope scope) {
    (String, GoRouteData) cloud(String label, CreateKind kind) =>
        (label, CreateRoute.of(scope, kind));
    (String, GoRouteData) robot(String label, RobotCreateKind kind) =>
        (label, RobotCreateRoute(accountId: scope.accountId, kind: kind));
    return switch (this) {
      servers => cloud(l10n.actionCreateServer, CreateKind.server),
      volumes => cloud(l10n.volumeCreate, CreateKind.volume),
      placementGroups => cloud(
        l10n.placementGroupCreate,
        CreateKind.placementGroup,
      ),
      sshKeys => cloud(l10n.sshKeyAdd, CreateKind.sshKey),
      networks => cloud(l10n.networkCreate, CreateKind.network),
      firewalls => cloud(l10n.firewallCreate, CreateKind.firewall),
      floatingIps => cloud(l10n.floatingIpCreate, CreateKind.floatingIp),
      primaryIps => cloud(l10n.primaryIpCreate, CreateKind.primaryIp),
      loadBalancers => cloud(l10n.loadBalancerCreate, CreateKind.loadBalancer),
      certificates => cloud(l10n.certificateCreate, CreateKind.certificate),
      zones => cloud(l10n.zoneCreate, CreateKind.zone),
      storageBoxes => cloud(l10n.storageBoxCreate, CreateKind.storageBox),
      buckets => cloud(l10n.bucketCreate, CreateKind.bucket),
      vswitches => robot(l10n.vswitchCreate, RobotCreateKind.vswitch),
      rdns => robot(l10n.rdnsCreate, RobotCreateKind.rdns),
      robotKeys => robot(l10n.sshKeyAdd, RobotCreateKind.key),
      robotTemplates => robot(l10n.templateCreate, RobotCreateKind.template),
      images || robotServers || failover || robotIps || robotSubnets => null,
    };
  }

  /// The provider behind the list, to count and to refresh. Null data
  /// means the type is not set up (Object Storage without keys).
  ({
    ProviderListenable<AsyncValue<List<Object>?>> watch,
    Refreshable<Future<Object?>> future,
  })
  _source(Scope scope) {
    final a = scope.accountId;
    return switch (this) {
      servers => (
        watch: serversProvider(scope),
        future: serversProvider(scope).future,
      ),
      volumes => (
        watch: volumesProvider(scope),
        future: volumesProvider(scope).future,
      ),
      images => (
        watch: imagesProvider(scope),
        future: imagesProvider(scope).future,
      ),
      placementGroups => (
        watch: placementGroupsProvider(scope),
        future: placementGroupsProvider(scope).future,
      ),
      sshKeys => (
        watch: sshKeysProvider(scope),
        future: sshKeysProvider(scope).future,
      ),
      networks => (
        watch: networksProvider(scope),
        future: networksProvider(scope).future,
      ),
      firewalls => (
        watch: firewallsProvider(scope),
        future: firewallsProvider(scope).future,
      ),
      floatingIps => (
        watch: publicIpsProvider(scope, IpKind.floating),
        future: publicIpsProvider(scope, IpKind.floating).future,
      ),
      primaryIps => (
        watch: publicIpsProvider(scope, IpKind.primary),
        future: publicIpsProvider(scope, IpKind.primary).future,
      ),
      loadBalancers => (
        watch: loadBalancersProvider(scope),
        future: loadBalancersProvider(scope).future,
      ),
      certificates => (
        watch: certificatesProvider(scope),
        future: certificatesProvider(scope).future,
      ),
      zones => (
        watch: zonesProvider(scope),
        future: zonesProvider(scope).future,
      ),
      storageBoxes => (
        watch: storageBoxesProvider(scope),
        future: storageBoxesProvider(scope).future,
      ),
      buckets => (
        watch: bucketsProvider(scope),
        future: bucketsProvider(scope).future,
      ),
      robotServers => (
        watch: robotServersProvider(a),
        future: robotServersProvider(a).future,
      ),
      failover => (
        watch: robotFailoversProvider(a),
        future: robotFailoversProvider(a).future,
      ),
      vswitches => (
        watch: robotVSwitchesProvider(a),
        future: robotVSwitchesProvider(a).future,
      ),
      rdns => (
        watch: robotRdnsProvider(a),
        future: robotRdnsProvider(a).future,
      ),
      robotKeys => (
        watch: robotKeysProvider(a),
        future: robotKeysProvider(a).future,
      ),
      robotIps => (
        watch: robotAddressesProvider(a, AddressKind.ip),
        future: robotAddressesProvider(a, AddressKind.ip).future,
      ),
      robotSubnets => (
        watch: robotAddressesProvider(a, AddressKind.subnet),
        future: robotAddressesProvider(a, AddressKind.subnet).future,
      ),
      robotTemplates => (
        watch: robotTemplatesProvider(a),
        future: robotTemplatesProvider(a).future,
      ),
    };
  }
}

/// Status of a resource for the overview; null for types without one.
ResourceStatus? _statusOf(Object item) => switch (item) {
  CloudServer(:final status) => status,
  Volume(:final status) => status,
  CloudImage(:final status) => status,
  LoadBalancer(:final status) => status,
  StorageBox(:final status) => status,
  final RobotServer s => serverStatus(s),
  final RobotVSwitch v =>
    v.cancelled ? ResourceStatus.cancelled : ResourceStatus.active,
  _ => null,
};

/// The overview of [area] in [scope]: a tile per resource type with its
/// count and status summary; servers show their first rows.
class AreaOverviewPage extends ConsumerWidget {
  const new({required this.scope, required this.area, super.key});

  final Scope scope;
  final Area area;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kinds = ResourceKind.of(area);
    final accounts = scope is AllProjectsScope
        ? ref.watch(accountsProvider.select((a) => a.value))
        : null;
    final sources = [
      for (final k in kinds)
        (kind: k, async: ref.watch(k._source(scope).watch)),
    ];
    // Nothing loaded at all (token rejected, offline): the cause once on
    // top, as a list without data shows it.
    final failed = [
      for (final s in sources)
        if (s.async.hasError && !s.async.hasValue) s.async.error!,
    ];
    return AreaOverview(
      onRefresh: () => Future.wait([
        for (final k in kinds) refreshQuietly(ref, k._source(scope).future),
      ]),
      error: failed.length == sources.length
          ? switch (toFalcoError(failed.first)) {
              final e when area == Area.robot => robotErrorText(e, l10n),
              final e => errorText(e, l10n),
            }
          : null,
      tiles: [
        for (final s in sources)
          _tile(context, ref, l10n, s.kind, s.async, accounts),
      ],
    );
  }

  OverviewTile _tile(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ResourceKind kind,
    AsyncValue<List<Object>?> async,
    List<Account>? accounts,
  ) {
    final items = async.value;
    final statuses = [...?items?.map(_statusOf).nonNulls];
    final preview = items == null
        ? const <Widget>[]
        : [
            for (final item in items.take(_previewRows))
              switch (item) {
                final CloudServer s => serverRow(context, scope, s, accounts),
                final RobotServer s => robotServerRow(
                  context,
                  ref,
                  scope.accountId,
                  s,
                ),
                _ => null,
              },
          ].nonNulls.toList();
    return OverviewTile(
      icon: kind.icon,
      label: kind.label(l10n),
      onTap: () => ResourcesRoute.of(scope, kind).push<void>(context),
      count: items?.length,
      statuses: statuses.isEmpty ? null : statuses,
      note: async.hasError && items == null
          ? l10n.overviewUnavailable
          : async.hasValue && items == null
          ? l10n.s3NoKeys
          : null,
      preview: preview,
    );
  }
}

/// The list of [kind] in [scope] with the type's one create button at the
/// bottom; on tablets the detail opens beside it (QRS-027).
class ResourceListPage extends StatelessWidget {
  const new({required this.scope, required this.kind, super.key});

  final Scope scope;
  final ResourceKind kind;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final create = kind.create(l10n, scope);
    return FalcoScaffold(
      title: kind.label(l10n),
      // The create button belongs to the list pane: on tablets it must not
      // cover the action bar of the detail beside it.
      body: ListDetail(
        list: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: switch (create) {
            (final label, final route) => FloatingActionButton.extended(
              heroTag: kind,
              onPressed: () => route.push<void>(context),
              icon: const Icon(Icons.add),
              label: Text(label),
            ),
            null => null,
          },
          body: kind.list(scope),
        ),
      ),
    );
  }
}
