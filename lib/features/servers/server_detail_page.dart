// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/actions/action_tracker.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity_page.dart';
import 'package:falco/features/servers/server_list.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Entries of the activity section before "Show all".
const _activityPreview = 5;

/// Server detail: header, power tiles, overview, metrics, activity
/// (CMP-015 to CMP-029).
class ServerDetailPage extends ConsumerStatefulWidget {
  const new({required this.scope, required this.serverId, super.key});

  final ProjectScope scope;
  final int serverId;

  @override
  ConsumerState<ServerDetailPage> createState() => _ServerDetailPageState();
}

class _ServerDetailPageState extends ConsumerState<ServerDetailPage> {
  final _periods = <ServerMetric, MetricPeriod>{};
  ({int id, ServerPower power})? _action;

  ProjectScope get _scope => widget.scope;

  Future<void> _run(CloudServer s, ServerPower power) async {
    final l10n = AppLocalizations.of(context);
    if (power != ServerPower.powerOn) {
      final (title, consequence, label) = switch (power) {
        ServerPower.reboot => (
          l10n.rebootTitle(s.name),
          l10n.rebootConsequence,
          l10n.actionReboot,
        ),
        ServerPower.shutdown => (
          l10n.shutdownTitle(s.name),
          l10n.shutdownConsequence,
          l10n.actionShutdown,
        ),
        ServerPower.powerOff => (
          l10n.powerOffTitle(s.name),
          l10n.powerOffConsequence,
          l10n.actionPowerOff,
        ),
        ServerPower.reset || ServerPower.powerOn => (
          l10n.resetTitle(s.name),
          l10n.resetConsequence,
          l10n.actionReset,
        ),
      };
      final confirmed = await ConfirmSheet.show(
        context,
        title: title,
        consequence: consequence,
        confirmLabel: label,
        resourceName: s.name,
        destructive:
            power == ServerPower.powerOff || power == ServerPower.reset,
        facts: [
          ConfirmFact(
            l10n.scopeProject,
            projectName(ref.read(accountsProvider).value, s.projectId),
          ),
          if (s.address case final a?)
            ConfirmFact(l10n.fieldAddress, formatIp(a), mono: true),
        ],
      );
      if (!confirmed || !mounted) return;
    }
    try {
      final id = await startPower(
        ref.read(cloudApiProvider(_scope.projectId)),
        s.id,
        power,
      );
      if (mounted) setState(() => _action = (id: id, power: power));
    } on FalcoError catch (e) {
      if (mounted) FalcoScaffold.showSnack(context, errorText(e, l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = serverProvider(_scope, widget.serverId);
    final async = ref.watch(provider);
    final s = async.value;
    final error = async.hasError
        ? errorText(toFalcoError(async.error!), l10n)
        : null;
    if (s == null) {
      return FalcoScaffold(
        title: l10n.resourceServer,
        body: error == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(FalcoSpacing.l),
                child: ErrorCard(
                  message: error,
                  onRetry: () => ref.invalidate(provider),
                ),
              ),
      );
    }

    final action = _action;
    ActionProgress? progress;
    if (action != null) {
      final tracked = trackedActionProvider(_scope, action.id);
      progress = ref.watch(tracked).value;
      ref.listen(tracked, (_, next) {
        if (next.value?.status == ActionStatus.error) {
          FalcoScaffold.showSnack(context, l10n.actionFailed);
        }
      });
    }
    final busy = progress != null && !progress.done;
    final running = s.status == ResourceStatus.running && !busy;
    final off = s.status == ResourceStatus.off && !busy;

    return FalcoScaffold(
      title: l10n.resourceServer,
      moreMenu: MoreMenu(
        items: [
          MoreMenuItem(
            label: l10n.actionReset,
            icon: Icons.restart_alt,
            destructive: true,
            onSelected: () => _run(s, ServerPower.reset),
          ),
        ],
      ),
      body: Column(
        children: [
          if (error != null)
            ErrorBanner(
              message: error,
              onRetry: () => ref.invalidate(provider),
            ),
          Expanded(
            child: DetailPage(
              status: busy
                  ? switch (action!.power) {
                      ServerPower.reboot ||
                      ServerPower.reset => ResourceStatus.rebooting,
                      ServerPower.powerOn => ResourceStatus.starting,
                      ServerPower.shutdown ||
                      ServerPower.powerOff => ResourceStatus.stopping,
                    }
                  : s.status,
              statusDetail: busy ? '${progress.progress} %' : null,
              name: s.name,
              ids: [
                if (s.ipv4 case final ip?) formatIp(ip),
                if (s.ipv6 case final ip?) formatIp(ip),
              ],
              onRefresh: () => refreshQuietly(ref, provider.future),
              actions: [
                ActionTile(
                  icon: Icons.refresh,
                  label: l10n.actionReboot,
                  onTap: running ? () => _run(s, ServerPower.reboot) : null,
                ),
                ActionTile(
                  icon: Icons.power_settings_new,
                  label: l10n.actionShutdown,
                  onTap: running ? () => _run(s, ServerPower.shutdown) : null,
                ),
                if (off)
                  ActionTile(
                    icon: Icons.play_arrow,
                    label: l10n.actionPowerOn,
                    onTap: () => _run(s, ServerPower.powerOn),
                  )
                else
                  ActionTile(
                    icon: Icons.power_off_outlined,
                    label: l10n.actionPowerOff,
                    onTap: running ? () => _run(s, ServerPower.powerOff) : null,
                  ),
              ],
              sections: [
                DetailSection(
                  title: l10n.sectionOverview,
                  child: FactRows([
                    ConfirmFact(l10n.fieldType, s.type.toUpperCase()),
                    ConfirmFact(l10n.fieldLocation, s.location),
                    ConfirmFact(l10n.fieldVcpu, '${s.cores}'),
                    ConfirmFact(
                      l10n.fieldMemory,
                      _gb(s.memoryGb, l10n.localeName),
                    ),
                    ConfirmFact(l10n.fieldDisk, _gb(s.diskGb, l10n.localeName)),
                    if (s.image case final image?)
                      ConfirmFact(l10n.fieldImage, image),
                  ]),
                ),
                DetailSection(
                  title: l10n.sectionMetrics,
                  child: Column(
                    spacing: FalcoSpacing.m,
                    children: [
                      _chart(ServerMetric.cpu, l10n.metricCpu, [
                        l10n.metricCpu,
                      ]),
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
                DetailSection(
                  title: l10n.sectionActivity,
                  child: _activity(l10n),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chart(ServerMetric metric, String title, List<String> labels) {
    final period = _periods[metric] ?? MetricPeriod.day;
    final data =
        ref
            .watch(
              serverMetricsProvider(_scope, widget.serverId, metric, period),
            )
            .value ??
        const [];
    final max = data
        .expand((s) => s)
        .fold<double>(0, (m, p) => p.$2 > m ? p.$2 : m);
    final (unit, factor) = metric == ServerMetric.cpu ? ('%', 1.0) : _rate(max);
    return MetricChart(
      title: title,
      unit: unit,
      period: period,
      onPeriodChanged: (p) => setState(() => _periods[metric] = p),
      series: [
        for (final (i, points) in data.indexed)
          if (i < labels.length)
            MetricSeries(
              label: labels[i],
              points: [for (final (t, v) in points) (t, v / factor)],
            ),
      ],
    );
  }

  Widget _activity(AppLocalizations l10n) {
    final actions =
        ref.watch(activityProvider(_scope, widget.serverId)).value ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final a in actions.take(_activityPreview)) ActivityRow(action: a),
        if (actions.isEmpty)
          Text(l10n.activityEmpty)
        else
          TextButton(
            onPressed: () => ActivityRoute(
              accountId: _scope.accountId,
              projectId: _scope.projectId,
              serverId: widget.serverId,
            ).push<void>(context),
            child: Text(l10n.activityShowAll),
          ),
      ],
    );
  }
}

/// Hetzner sizes are GB; shown in the one byte format.
String _gb(num gb, String locale) =>
    formatBytes((gb * 1024 * 1024 * 1024).round(), locale);

/// Unit and divisor for a byte rate whose largest sample is [max]
/// (CMP-029).
(String, double) _rate(double max) {
  const units = ['B/s', 'KiB/s', 'MiB/s', 'GiB/s'];
  var factor = 1.0;
  var i = 0;
  while (max / factor >= 1024 && i < units.length - 1) {
    factor *= 1024;
    i++;
  }
  return (units[i], factor);
}
