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

    DetailAction item(String label, IconData icon, VoidCallback onTap) =>
        DetailAction(label: label, icon: icon, onTap: onTap);

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
          if (s.ipv4 case final ip?) formatIp(ip),
          if (s.ipv6 case final ip?) formatIp(ip),
        ],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          if (off)
            DetailAction(
              icon: Icons.play_arrow,
              label: l10n.actionPowerOn,
              onTap: () => ops.power(ServerPower.powerOn),
            )
          else
            DetailAction(
              icon: Icons.power_settings_new,
              label: l10n.actionShutdown,
              onTap: running ? () => ops.power(ServerPower.shutdown) : null,
            ),
          DetailAction(
            icon: Icons.refresh,
            label: l10n.actionReboot,
            onTap: running ? () => ops.power(ServerPower.reboot) : null,
          ),
          DetailAction(
            icon: Icons.terminal,
            label: l10n.actionConsole,
            onTap: running ? ops.console : null,
          ),
          DetailAction(
            icon: Icons.power_off_outlined,
            label: l10n.actionPowerOff,
            onTap: running ? () => ops.power(ServerPower.powerOff) : null,
          ),
          item(l10n.commonEdit, Icons.edit_outlined, ops.edit),
          item(l10n.actionSnapshot, Icons.photo_camera_outlined, ops.snapshot),
          item(
            s.backupWindow == null ? l10n.backupsOn : l10n.backupsOff,
            Icons.backup_outlined,
            ops.backups,
          ),
          item(
            s.iso == null ? l10n.isoAttach : l10n.isoDetach,
            Icons.album_outlined,
            ops.iso,
          ),
          item(
            s.rescue ? l10n.rescueOff : l10n.rescueOn,
            Icons.medical_services_outlined,
            ops.rescue,
          ),
          item(l10n.resetPassword, Icons.password, ops.resetRootPassword),
          item(l10n.changeType, Icons.swap_vert, ops.changeType),
          item(
            s.placementGroup == null
                ? l10n.placementGroupAdd
                : l10n.placementGroupRemove,
            Icons.scatter_plot_outlined,
            ops.placementGroup,
          ),
          item(l10n.fieldProtection, Icons.lock_outline, ops.protection),
          item(l10n.reverseDns, Icons.dns_outlined, ops.reverseDns),
          item(l10n.networkAttach, Icons.hub_outlined, ops.attachNetwork),
          DetailAction(
            label: l10n.actionReset,
            icon: Icons.restart_alt,
            destructive: true,
            onTap: () => ops.power(ServerPower.reset),
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionOverview,
            child: FactRows([
              ConfirmFact(l10n.fieldType, s.type.toUpperCase()),
              ConfirmFact(l10n.fieldLocation, s.location),
              ConfirmFact(l10n.fieldVcpu, '${s.cores}'),
              ConfirmFact(l10n.fieldMemory, gb(s.memoryGb, l10n.localeName)),
              ConfirmFact(l10n.fieldDisk, gb(s.diskGb, l10n.localeName)),
              ConfirmFact(l10n.fieldImage, s.image ?? l10n.commonNone),
              if (s.iso case final iso?) ConfirmFact(l10n.fieldIso, iso),
              ConfirmFact(
                l10n.fieldBackups,
                s.backupWindow == null
                    ? l10n.commonOff
                    : l10n.backupWindow(s.backupWindow!),
              ),
              ConfirmFact(
                l10n.fieldDeleteProtection,
                yesNo(s.protectDelete, l10n),
              ),
              ConfirmFact(
                l10n.fieldRebuildProtection,
                yesNo(s.protectRebuild, l10n),
              ),
              ConfirmFact(
                l10n.fieldCreated,
                formatDateTime(s.created, l10n.localeName),
              ),
              ConfirmFact(l10n.fieldLabels, labelsText(s.labels, l10n)),
            ]),
          ),
          DetailSection(
            title: l10n.sectionNetwork,
            child: _Network(ops: ops),
          ),
          DetailSection(
            title: l10n.sectionAttached,
            child: _Attached(scope: _scope, server: s),
          ),
          DetailSection(
            title: l10n.sectionMetrics,
            child: Column(
              spacing: FalcoSpacing.m,
              children: [
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
          ),
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
}

/// Public IPs with reverse DNS, private networks with remove and alias
/// IPs, firewalls (CMP-018, CMP-041, NET-086).
class _Network extends ConsumerWidget {
  const new({required this.ops});

  final ServerOps ops;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (s.ipv4 case final ip?) ...[
          Text(l10n.publicIpv4, style: _label(context)),
          CopyableValue(formatIp(ip)),
          if (s.ipv4Ptr case final ptr? when ptr.isNotEmpty)
            Text(l10n.reverseDnsValue(ptr), style: _label(context)),
        ],
        if (s.ipv6 case final ip?) ...[
          Text(l10n.publicIpv6, style: _label(context)),
          CopyableValue(formatIp(ip)),
        ],
        if (s.networks.isNotEmpty) ...[
          Text(l10n.resourceNetworks, style: _label(context)),
          for (final n in s.networks)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(networks[n.id] ?? '#${n.id}'),
              subtitle: Mono([formatIp(n.ip), ...n.aliasIps].join(' · ')),
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
        ],
        if (s.firewalls.isNotEmpty) ...[
          Text(l10n.resourceFirewalls, style: _label(context)),
          for (final f in s.firewalls)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.shield_outlined),
              title: Text(firewalls[f] ?? '#$f'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => FirewallRoute(
                accountId: scope.accountId,
                projectId: scope.projectId,
                firewallId: f,
              ).push<void>(context),
            ),
        ],
      ],
    );
  }

  static TextStyle _label(BuildContext context) =>
      TextStyle(fontSize: 13, color: FalcoColors.of(context).textSecondary);
}

/// Volumes, placement group and load balancers, with a jump into the
/// detail where it exists (CMP-019).
class _Attached extends ConsumerWidget {
  const new({required this.scope, required this.server});

  final ProjectScope scope;
  final CloudServer server;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final s = server;
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
    Widget link(IconData icon, String title, String? sub, VoidCallback? tap) =>
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon),
          title: Text(title),
          subtitle: sub == null ? null : Text(sub),
          trailing: tap == null ? null : const Icon(Icons.chevron_right),
          onTap: tap,
        );
    final empty =
        s.volumes.isEmpty &&
        s.placementGroup == null &&
        s.loadBalancers.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (empty) Text(l10n.commonNone),
        for (final id in s.volumes)
          link(
            Icons.storage_outlined,
            volumes[id]?.name ?? '#$id',
            switch (volumes[id]) {
              final v? => gb(v.sizeGb, l10n.localeName),
              null => l10n.resourceVolume,
            },
            () => VolumeRoute(
              accountId: scope.accountId,
              projectId: scope.projectId,
              volumeId: id,
            ).push<void>(context),
          ),
        if (s.placementGroup case final g?)
          link(
            Icons.scatter_plot_outlined,
            g.name,
            l10n.resourcePlacementGroup,
            () => PlacementGroupRoute(
              accountId: scope.accountId,
              projectId: scope.projectId,
              groupId: g.id,
            ).push<void>(context),
          ),
        for (final id in s.loadBalancers)
          link(
            Icons.balance,
            lbs[id] ?? '#$id',
            l10n.resourceLoadBalancer,
            () => LoadBalancerRoute(
              accountId: scope.accountId,
              projectId: scope.projectId,
              lbId: id,
            ).push<void>(context),
          ),
      ],
    );
  }
}

extension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}
