// SPDX-License-Identifier: GPL-3.0-or-later
/// Search over every account: all Cloud projects, Storage Boxes, buckets
/// and Robot (SUC-001 to SUC-005). The index is built from the same
/// providers the lists use and matched on the device, so a search needs
/// no request and keeps working on loaded data when a refresh fails.
library;

import 'dart:async';

import 'package:falco/app/router.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/dns/zones.dart';
import 'package:falco/features/images/images.dart';
import 'package:falco/features/network/certificates.dart';
import 'package:falco/features/network/firewalls.dart';
import 'package:falco/features/network/ips.dart';
import 'package:falco/features/network/load_balancers.dart';
import 'package:falco/features/network/networks.dart';
import 'package:falco/features/placement_groups/placement_groups.dart';
import 'package:falco/features/robot/robot.dart';
import 'package:falco/features/robot/robot_lists.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/features/ssh_keys/ssh_keys.dart';
import 'package:falco/features/storage/object_storage.dart';
import 'package:falco/features/storage/storage_boxes.dart';
import 'package:falco/features/volumes/volumes.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search.g.dart';

/// Result groups in display order (SUC-003).
enum SearchGroup {
  server,
  dedicated,
  volume,
  image,
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
  failover,
  vswitch,
  robotKey,
}

/// One searchable resource and the page it opens.
@immutable
class SearchHit {
  /// Creates a hit; [terms] are matched in lower case.
  new({
    required this.group,
    required this.name,
    required this.detail,
    required this.where,
    required this.route,
    required Iterable<Object?> terms,
    this.status = ResourceStatus.available,
  }) : terms = [name, where, ...terms].nonNulls.join(' ').toLowerCase();

  final SearchGroup group;
  final String name;

  /// The line below the name (SUC-004).
  final String Function(AppLocalizations l10n) detail;

  /// Account and project, or account and Robot.
  final String where;

  /// The detail page, with the hit's scope in its path (SUC-005).
  final GoRouteData route;
  final String terms;
  final ResourceStatus status;

  /// True when every word of [query] occurs in the hit.
  bool matches(String query) => query
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .every(terms.contains);
}

/// The hits of [index] matching [query], by group and name.
List<SearchHit> searchHits(List<SearchHit> index, String query) =>
    [
      for (final h in index)
        if (query.trim().isNotEmpty && h.matches(query)) h,
    ]..sort((a, b) {
      final g = a.group.index.compareTo(b.group.index);
      return g != 0 ? g : a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

/// The search index: every hit loaded so far, whether sources are still
/// loading, the sources that failed with the first error, and the
/// projects missing from "All projects" lists.
typedef SearchIndexState = ({
  List<SearchHit> hits,
  bool loading,
  int failed,
  Object? error,
  List<Project> failedProjects,
});

/// Every resource of every account (SUC-002), from the providers the
/// lists use. Kept alive, so a search opened again starts on loaded data;
/// a source whose refresh fails keeps its last data (offline).
@Riverpod(keepAlive: true)
SearchIndexState searchIndex(Ref ref) {
  final index = _Index(ref);
  final accounts = ref.watch(accountsProvider);
  index.add(accounts, (_) => null);
  for (final a in accounts.value ?? const <Account>[]) {
    index.cloud(a);
    if (a.hasRobot) index.robot(a);
  }
  return (
    hits: index.hits,
    loading: index.loading,
    failed: index.failed,
    error: index.error,
    failedProjects: [...index.failedProjects.values],
  );
}

class _Index {
  new(this.ref);

  final Ref ref;
  final hits = <SearchHit>[];
  bool loading = false;
  int failed = 0;
  Object? error;
  final failedProjects = <String, Project>{};

  /// Adds the hits of one source; a failed refresh keeps its last data,
  /// a project that failed in "All projects" is named.
  void add<T>(AsyncValue<List<T>?> source, SearchHit? Function(T item) hit) {
    if (source.hasError) {
      failed++;
      error ??= source.error;
    } else if (source.isLoading) {
      loading = true;
    }
    if (source.value case PartialList<T>(failed: final projects)) {
      // By name: Object Storage names each failed location of a project.
      for (final p in projects) {
        failedProjects[p.name] = p;
      }
    }
    hits.addAll((source.value ?? const []).map(hit).nonNulls);
  }

  void cloud(Account a) {
    if (a.projects.isEmpty) return;
    final scope = AllProjectsScope(a.id);
    String where(String projectId) =>
        '${a.name} · ${projectName([a], projectId)}';
    GoRouteData route(String projectId, String type, int id) =>
        resourceRoute(ProjectScope(a.id, projectId), type, id)!;
    Iterable<String> labels(Map<String, String> l) => [
      for (final MapEntry(:key, :value) in l.entries) '$key=$value',
    ];

    add(
      ref.watch(serversProvider(scope)),
      (s) => SearchHit(
        group: SearchGroup.server,
        name: s.name,
        status: s.status,
        detail: (_) => [?s.address, s.type, s.location].join(' · '),
        where: where(s.projectId),
        route: route(s.projectId, CloudType.server, s.id),
        terms: [s.id, s.ipv4, s.ipv6, s.ipv4Ptr, ...labels(s.labels)],
      ),
    );
    add(
      ref.watch(volumesProvider(scope)),
      (v) => SearchHit(
        group: SearchGroup.volume,
        name: v.name,
        status: v.status,
        detail: (_) => '${v.sizeGb} GB · ${v.location}',
        where: where(v.projectId),
        route: route(v.projectId, CloudType.volume, v.id),
        terms: [v.id, v.device, ...labels(v.labels)],
      ),
    );
    add(
      ref.watch(imagesProvider(scope)),
      // Own snapshots and backups; system images are in every project.
      (i) => !i.own
          ? null
          : SearchHit(
              group: SearchGroup.image,
              name: i.description,
              detail: (_) => [i.kind.name, ?i.source].join(' · '),
              where: where(i.projectId),
              route: route(i.projectId, CloudType.image, i.id),
              terms: [i.id, i.name, i.source, ...labels(i.labels)],
            ),
    );
    add(
      ref.watch(placementGroupsProvider(scope)),
      (g) => SearchHit(
        group: SearchGroup.placementGroup,
        name: g.name,
        detail: (_) => g.type,
        where: where(g.projectId),
        route: route(g.projectId, CloudType.placementGroup, g.id),
        terms: [g.id, ...labels(g.labels)],
      ),
    );
    add(
      ref.watch(sshKeysProvider(scope)),
      (k) => SearchHit(
        group: SearchGroup.sshKey,
        name: k.name,
        detail: (_) => k.fingerprint,
        where: where(k.projectId),
        route: route(k.projectId, CloudType.sshKey, k.id),
        terms: [k.id, k.fingerprint, ...labels(k.labels)],
      ),
    );
    add(
      ref.watch(networksProvider(scope)),
      (n) => SearchHit(
        group: SearchGroup.network,
        name: n.name,
        detail: (_) => n.ipRange,
        where: where(n.projectId),
        route: route(n.projectId, CloudType.network, n.id),
        terms: [
          n.id,
          n.ipRange,
          for (final s in n.subnets) s.ipRange,
          ...labels(n.labels),
        ],
      ),
    );
    add(
      ref.watch(firewallsProvider(scope)),
      (f) => SearchHit(
        group: SearchGroup.firewall,
        name: f.name,
        detail: (l10n) => l10n.ruleCount(f.rules.length),
        where: where(f.projectId),
        route: route(f.projectId, CloudType.firewall, f.id),
        terms: [f.id, ...labels(f.labels)],
      ),
    );
    for (final kind in IpKind.values) {
      add(
        ref.watch(publicIpsProvider(scope, kind)),
        (ip) => SearchHit(
          group: kind == IpKind.floating
              ? SearchGroup.floatingIp
              : SearchGroup.primaryIp,
          name: ip.name,
          detail: (_) => [ip.ip, ip.location].join(' · '),
          where: where(ip.projectId),
          route: route(ip.projectId, switch (kind) {
            IpKind.floating => CloudType.floatingIp,
            IpKind.primary => CloudType.primaryIp,
          }, ip.id),
          terms: [
            ip.id,
            ip.ip,
            ip.description,
            ...ip.reverseDns.values,
            ...labels(ip.labels),
          ],
        ),
      );
    }
    add(
      ref.watch(loadBalancersProvider(scope)),
      (lb) => SearchHit(
        group: SearchGroup.loadBalancer,
        name: lb.name,
        detail: (_) => [?lb.ipv4, lb.type.name, lb.location].join(' · '),
        where: where(lb.projectId),
        route: route(lb.projectId, CloudType.loadBalancer, lb.id),
        terms: [
          lb.id,
          lb.ipv4,
          lb.ipv6,
          for (final n in lb.privateNets) n.ip,
          ...labels(lb.labels),
        ],
      ),
    );
    add(
      ref.watch(certificatesProvider(scope)),
      (c) => SearchHit(
        group: SearchGroup.certificate,
        name: c.name,
        detail: (_) => c.domains.join(', '),
        where: where(c.projectId),
        route: route(c.projectId, CloudType.certificate, c.id),
        terms: [c.id, ...c.domains, ...labels(c.labels)],
      ),
    );
    add(
      ref.watch(zonesProvider(scope)),
      (z) => SearchHit(
        group: SearchGroup.zone,
        name: z.name,
        detail: (l10n) => l10n.recordCount(z.recordCount),
        where: where(z.projectId),
        route: route(z.projectId, CloudType.zone, z.id),
        terms: [z.id, ...labels(z.labels)],
      ),
    );
    add(
      ref.watch(storageBoxesProvider(scope)),
      (b) => SearchHit(
        group: SearchGroup.storageBox,
        name: b.name,
        status: b.status,
        detail: (_) => [b.username, b.location].join(' · '),
        where: where(b.projectId),
        route: route(b.projectId, storageBoxType, b.id),
        terms: [b.id, b.username, b.server, ...labels(b.labels)],
      ),
    );
    add(
      ref.watch(bucketsProvider(scope)),
      (b) => SearchHit(
        group: SearchGroup.bucket,
        name: b.name,
        detail: (_) => b.location,
        where: where(b.projectId),
        route: BucketRoute(
          accountId: a.id,
          projectId: b.projectId,
          region: b.location,
          bucket: b.name,
        ),
        terms: const [],
      ),
    );
  }

  void robot(Account a) {
    final where = '${a.name} · Robot';
    final id = a.id;
    add(
      ref.watch(robotServersProvider(id)),
      (s) => SearchHit(
        group: SearchGroup.dedicated,
        name: s.label,
        status: serverStatus(s),
        detail: (_) => [?s.ipv4, s.product, s.dc].join(' · '),
        where: where,
        route: RobotServerRoute(accountId: id, number: s.number),
        terms: [s.number, s.ipv4, s.ipv6Net, s.product, ...s.ips],
      ),
    );
    add(
      ref.watch(robotFailoversProvider(id)),
      (f) => SearchHit(
        group: SearchGroup.failover,
        name: f.ip,
        detail: (_) => f.activeServerIp ?? f.serverIp,
        where: where,
        route: RobotFailoverRoute(accountId: id, ip: f.ip),
        terms: [f.serverIp, f.activeServerIp, f.serverNumber],
      ),
    );
    add(
      ref.watch(robotVSwitchesProvider(id)),
      (v) => SearchHit(
        group: SearchGroup.vswitch,
        name: v.name,
        detail: (_) => 'VLAN ${v.vlan}',
        where: where,
        route: RobotVSwitchRoute(accountId: id, id: v.id),
        terms: [v.id, 'vlan ${v.vlan}', ...v.subnets],
      ),
    );
    add(
      ref.watch(robotKeysProvider(id)),
      (k) => SearchHit(
        group: SearchGroup.robotKey,
        name: k.name,
        detail: (_) => k.fingerprint,
        where: where,
        route: RobotKeyRoute(accountId: id, fingerprint: k.fingerprint),
        terms: [k.fingerprint],
      ),
    );
  }
}

/// Reloads every source of the index (pull to refresh); progress and
/// failures show in the index state.
void refreshSearch(WidgetRef ref) {
  <ProviderOrFamily>[
    serversProvider,
    volumesProvider,
    imagesProvider,
    placementGroupsProvider,
    sshKeysProvider,
    networksProvider,
    firewallsProvider,
    publicIpsProvider,
    loadBalancersProvider,
    certificatesProvider,
    zonesProvider,
    storageBoxesProvider,
    bucketsProvider,
    robotServersProvider,
    robotFailoversProvider,
    robotVSwitchesProvider,
    robotKeysProvider,
  ].forEach(ref.invalidate);
}

/// The last searches, newest first, kept on the device.
@Riverpod(keepAlive: true)
class RecentSearches extends _$RecentSearches {
  static const _key = 'recentSearches';
  static const _max = 8;

  @override
  List<String> build() =>
      ref.read(preferencesProvider).getStringList(_key) ?? const [];

  /// Puts [query] on top.
  void add(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    state = [q, ...state.where((s) => s != q)].take(_max).toList();
    unawaited(ref.read(preferencesProvider).setStringList(_key, state));
  }

  /// Forgets all searches.
  void clear() {
    state = const [];
    unawaited(ref.read(preferencesProvider).remove(_key));
  }
}
