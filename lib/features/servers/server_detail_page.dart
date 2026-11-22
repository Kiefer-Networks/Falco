// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/actions/action_tracker.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/activity/activity_page.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/network/firewalls.dart';
import 'package:falco/features/network/load_balancers.dart';
import 'package:falco/features/network/networks.dart';
import 'package:falco/features/servers/server_actions.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/features/volumes/volumes.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Server detail: header, power tiles, overview, network, attached
/// resources, metrics, activity, danger zone; everything else in the more
/// menu (CMP-015 to CMP-049).
class ServerDetailPage extends ConsumerStatefulWidget {
  const new({required this.scope, required this.serverId, super.key});

  final ProjectScope scope;
  final int serverId;

  @override
  ConsumerState<ServerDetailPage> createState() => _ServerDetailPageState();
}

class _ServerDetailPageState extends ConsumerState<ServerDetailPage> {
  ProjectScope get _scope => widget.scope;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = serverProvider(_scope, widget.serverId);
    final async = ref.watch(provider);
    final s = async.value;
    if (s == null) {
      return DetailLoading(
        title: l10n.resourceServer,
        error: async.error,
        onRetry: () => ref.invalidate(provider),
      );
    }

    final tracked = trackedActionProvider(
      _scope,
      CloudType.server,
      widget.serverId,
    );
    final progress = ref.watch(tracked).value;
    ref.listen(tracked, (_, next) {
      if (next.value?.status == ActionStatus.error) {
        FalcoScaffold.showSnack(context, l10n.actionFailed);
      }
    });
    final busy = progress != null && !progress.done;
    final running = s.status == ResourceStatus.running && !busy;
    final off = s.status == ResourceStatus.off && !busy;
    final ops = ServerOps(context, ref, _scope, s);

    DetailAction item(
      ActionGroup group,
      String label,
      IconData icon,
      VoidCallback onTap,
    ) => DetailAction(label: label, icon: icon, group: group, onTap: onTap);
    final locale = l10n.localeName;

    return FalcoScaffold(
      title: l10n.resourceServer,
      body: DetailPage(
        status: busy
            ? switch (progress.command) {
                'reboot_server' || 'reset_server' => ResourceStatus.rebooting,
                'start_server' || 'poweron_server' => ResourceStatus.starting,
                'shutdown_server' ||
                'stop_server' ||
                'poweroff_server' => ResourceStatus.stopping,
                'rebuild_server' => ResourceStatus.rebuilding,
                'delete_server' => ResourceStatus.deleting,
                _ => ResourceStatus.inProgress,
              }
            : s.status,
        statusDetail: busy
            ? '${progress.progress} %'
            : [
                if (s.protectDelete || s.protectRebuild) l10n.protected,
                if (s.rescue) l10n.rescueActive,
              ].join(' · ').nullIfEmpty,
        name: s.name,
        ids: [
          if (s.ipv4 case final ip?)
            DetailId(formatIp(ip), icon: Icons.public, copy: true),
          if (s.ipv6 case final ip?)
            DetailId(formatIp(ip), icon: Icons.public, copy: true),
          DetailId(s.location, icon: Icons.place_outlined),
          DetailId(s.type.toUpperCase(), icon: Icons.memory),
        ],
        facts: [
          Fact(l10n.fieldVcpu, text: '${s.cores}'),
          Fact(l10n.fieldMemory, text: gb(s.memoryGb, locale)),
          Fact(l10n.fieldDisk, text: gb(s.diskGb, locale)),
          Fact(l10n.fieldImage, text: s.image ?? l10n.commonNone),
          Fact(l10n.fieldBackups, on: s.backupWindow != null),
          Fact(l10n.fieldCreated, time: s.created),
        ],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          if (off)
            DetailAction(
              icon: Icons.play_arrow,
              label: l10n.actionPowerOn,
              group: ActionGroup.power,
              onTap: () => ops.power(ServerPower.powerOn),
            )
          else
            DetailAction(
              icon: Icons.power_settings_new,
              label: l10n.actionShutdown,
              group: ActionGroup.power,
              onTap: running ? () => ops.power(ServerPower.shutdown) : null,
            ),
          DetailAction(
            icon: Icons.refresh,
            label: l10n.actionReboot,
            group: ActionGroup.power,
            onTap: running ? () => ops.power(ServerPower.reboot) : null,
          ),
          DetailAction(
            icon: Icons.terminal,
            label: l10n.actionConsole,
            group: ActionGroup.access,
            onTap: running ? ops.console : null,
          ),
          DetailAction(
            icon: Icons.power_off_outlined,
            label: l10n.actionPowerOff,
            group: ActionGroup.power,
            onTap: running ? () => ops.power(ServerPower.powerOff) : null,
          ),
          item(
            ActionGroup.access,
            s.rescue ? l10n.rescueOff : l10n.rescueOn,
            Icons.medical_services_outlined,
            ops.rescue,
          ),
          item(
            ActionGroup.access,
            l10n.resetPassword,
            Icons.password,
            ops.resetRootPassword,
          ),
          item(
            ActionGroup.manage,
            l10n.commonEdit,
            Icons.edit_outlined,
            ops.edit,
          ),
          item(
            ActionGroup.manage,
            l10n.changeType,
            Icons.swap_vert,
            ops.changeType,
          ),
          item(
            ActionGroup.manage,
            s.iso == null ? l10n.isoAttach : l10n.isoDetach,
            Icons.album_outlined,
            ops.iso,
          ),
          item(
            ActionGroup.manage,
            s.placementGroup == null
                ? l10n.placementGroupAdd
                : l10n.placementGroupRemove,
            Icons.scatter_plot_outlined,
            ops.placementGroup,
          ),
          item(
            ActionGroup.manage,
            l10n.fieldProtection,
            Icons.lock_outline,
            ops.protection,
          ),
          item(
            ActionGroup.network,
            l10n.reverseDns,
            Icons.dns_outlined,
            ops.reverseDns,
          ),
          item(
            ActionGroup.network,
            l10n.networkAttach,
            Icons.hub_outlined,
            ops.attachNetwork,
          ),
          item(
            ActionGroup.backup,
            l10n.actionSnapshot,
            Icons.photo_camera_outlined,
            ops.snapshot,
          ),
          item(
            ActionGroup.backup,
            s.backupWindow == null ? l10n.backupsOn : l10n.backupsOff,
            Icons.backup_outlined,
            ops.backups,
          ),
          item(
            ActionGroup.danger,
            l10n.actionReset,
            Icons.restart_alt,
            () => ops.power(ServerPower.reset),
          ),
        ],
        sections: [
          _network(ops),
          DetailSection(
            title: l10n.sectionConfiguration,
            facts: [
              Fact(l10n.fieldIso, text: s.iso ?? l10n.commonNone),
              if (s.backupWindow case final w?)
                Fact(l10n.fieldBackups, text: l10n.backupWindow(w)),
              Fact(l10n.bootRescue, on: s.rescue),
            ],
          ),
          DetailSection(
            title: l10n.sectionProtection,
            facts: [
              Fact(l10n.fieldDeleteProtection, on: s.protectDelete),
              Fact(l10n.fieldRebuildProtection, on: s.protectRebuild),
            ],
          ),
          _attached(s),
          DetailSection(
            title: l10n.sectionMetrics,
            cards: [
              _chart(ServerMetric.cpu, l10n.metricCpu, [l10n.metricCpu]),
              _chart(ServerMetric.disk, l10n.metricDisk, [
                l10n.metricRead,
                l10n.metricWrite,
              ]),
              _chart(ServerMetric.network, l10n.metricNetwork, [
                l10n.metricIn,
                l10n.metricOut,
              ]),
            ],
          ),
          labelsSection(l10n, s.labels),
          detailsSection(l10n, id: s.id),
          activitySection(l10n, _scope, CloudType.server, widget.serverId),
        ],
        dangerZone: [
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: FalcoColors.of(context).error,
            ),
            onPressed: busy ? null : ops.rebuild,
            icon: const Icon(Icons.restore),
            label: Text(l10n.actionRebuild),
          ),
          DeleteButton(
            onPressed: busy
                ? null
                : () async {
                    if (await ops.delete() && context.mounted) {
                      Navigator.pop(context);
                    }
                  },
          ),
        ],
      ),
    );
  }

  Widget _chart(ServerMetric metric, String title, List<String> labels) =>
      MetricPanel(
        title: title,
        labels: labels,
        unit: '%',
        rate: metric != ServerMetric.cpu,
        data: (period) =>
            serverMetricsProvider(_scope, widget.serverId, metric, period),
      );

  /// Public IPs with reverse DNS, private networks with remove and alias
  /// IPs, firewalls (CMP-018, CMP-041, NET-086).
  DetailSection _network(ServerOps ops) {
    final l10n = AppLocalizations.of(context);
    final s = ops.server;
    final scope = ops.scope;
    final networks = {
      for (final n
          in s.networks.isEmpty
              ? const <CloudNetwork>[]
              : ref.watch(networksProvider(scope)).value ??
                    const <CloudNetwork>[])
        n.id: n.name,
    };
    final firewalls = {
      for (final f
          in s.firewalls.isEmpty
              ? const <Firewall>[]
              : ref.watch(firewallsProvider(scope)).value ?? const <Firewall>[])
        f.id: f.name,
    };
    final facts = [
      if (s.ipv4 case final ip?) ...[
        Fact(l10n.publicIpv4, text: formatIp(ip), copy: true),
        if (s.ipv4Ptr case final ptr? when ptr.isNotEmpty)
          Fact(l10n.reverseDns, text: ptr, mono: true),
      ],
      if (s.ipv6 case final ip?)
        Fact(l10n.publicIpv6, text: formatIp(ip), copy: true),
    ];
    final cards = [
      for (final n in s.networks)
        RelatedCard(
          icon: Icons.hub_outlined,
          title: networks[n.id] ?? '#${n.id}',
          subtitle: [formatIp(n.ip), ...n.aliasIps].join(' · '),
          onTap: () => NetworkRoute(
            accountId: scope.accountId,
            projectId: scope.projectId,
            networkId: n.id,
          ).push<void>(context),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: l10n.fieldAliasIps,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => ops.aliasIps(n.id, n.aliasIps),
              ),
              IconButton(
                tooltip: l10n.actionRemove,
                icon: const Icon(Icons.link_off),
                onPressed: () =>
                    ops.detachNetwork(n.id, networks[n.id] ?? '#${n.id}'),
              ),
            ],
          ),
        ),
      for (final f in s.firewalls)
        RelatedCard(
          icon: Icons.shield_outlined,
          title: firewalls[f] ?? '#$f',
          subtitle: l10n.resourceFirewall,
          onTap: () => FirewallRoute(
            accountId: scope.accountId,
            projectId: scope.projectId,
            firewallId: f,
          ).push<void>(context),
        ),
    ];
    return DetailSection(
      title: l10n.sectionNetwork,
      facts: facts,
      cards: cards,
      child: facts.isEmpty && cards.isEmpty ? Text(l10n.commonNone) : null,
    );
  }

  /// Volumes, placement group and load balancers, with a jump into the
  /// detail where it exists (CMP-019).
  DetailSection _attached(CloudServer s) {
    final l10n = AppLocalizations.of(context);
    final scope = _scope;
    final volumes = {
      for (final v
          in ref.watch(volumesProvider(scope)).value ?? const <Volume>[])
        v.id: v,
    };
    final lbs = {
      for (final lb
          in s.loadBalancers.isEmpty
              ? const <LoadBalancer>[]
              : ref.watch(loadBalancersProvider(scope)).value ??
                    const <LoadBalancer>[])
        lb.id: lb.name,
    };
    final cards = [
      for (final id in s.volumes)
        RelatedCard(
          icon: Icons.storage_outlined,
          title: volumes[id]?.name ?? '#$id',
          status: volumes[id]?.status,
          subtitle: switch (volumes[id]) {
            final v? => gb(v.sizeGb, l10n.localeName),
            null => l10n.resourceVolume,
          },
          onTap: () => VolumeRoute(
            accountId: scope.accountId,
            projectId: scope.projectId,
            volumeId: id,
          ).push<void>(context),
        ),
      if (s.placementGroup case final g?)
        RelatedCard(
          icon: Icons.scatter_plot_outlined,
          title: g.name,
          subtitle: l10n.resourcePlacementGroup,
          onTap: () => PlacementGroupRoute(
            accountId: scope.accountId,
            projectId: scope.projectId,
            groupId: g.id,
          ).push<void>(context),
        ),
      for (final id in s.loadBalancers)
        RelatedCard(
          icon: Icons.balance,
          title: lbs[id] ?? '#$id',
          subtitle: l10n.resourceLoadBalancer,
          onTap: () => LoadBalancerRoute(
            accountId: scope.accountId,
            projectId: scope.projectId,
            lbId: id,
          ).push<void>(context),
        ),
    ];
    return DetailSection(
      title: l10n.sectionAttached,
      cards: cards,
      child: cards.isEmpty ? Text(l10n.commonNone) : null,
    );
  }
}

extension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}
