// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Servers of a scope; with "All projects" each row names its project.
class ServerList extends ConsumerWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = serversProvider(scope);
    final async = ref.watch(provider);
    final accounts = scope is AllProjectsScope
        ? ref.watch(accountsProvider.select((a) => a.value))
        : null;
    return ResourceList<CloudServer>(
      title: l10n.resourceServers,
      items: async.value,
      loading: async.isLoading,
      error: async.hasError
          ? errorText(toFalcoError(async.error!), l10n)
          : null,
      onRefresh: () => refreshQuietly(ref, provider.future),
      empty: EmptyHint(message: l10n.emptyServers),
      searchText: (s) => '${s.name} ${s.address ?? ''}',
      filters: [
        ResourceFilter(l10n.filterAll, (_) => true),
        ResourceFilter(
          l10n.filterRunning,
          (s) => s.status == ResourceStatus.running,
        ),
        ResourceFilter(l10n.filterOff, (s) => s.status == ResourceStatus.off),
        ResourceFilter(
          l10n.filterInProgress,
          (s) => s.status.tone == StatusTone.progress,
        ),
      ],
      sorts: [
        ResourceSort(l10n.sortName, (a, b) => a.name.compareTo(b.name)),
        ResourceSort(
          l10n.sortCreated,
          (a, b) => b.created.compareTo(a.created),
        ),
      ],
      itemBuilder: (context, s) => serverRow(context, scope, s, accounts),
    );
  }
}

/// The row of server [s]: status, name, IP, type, location and, with
/// "All projects", the project ([accounts] given). Opens the detail.
Widget serverRow(
  BuildContext context,
  Scope scope,
  CloudServer s,
  List<Account>? accounts,
) => ResourceRow(
  status: s.status,
  name: s.name,
  monoLine: [
    if (s.address case final a?) formatIp(a),
    s.type.toUpperCase(),
    s.location,
    if (accounts != null) projectName(accounts, s.projectId),
  ].join(' · '),
  onTap: () => openDetail(
    context,
    ServerRoute(
      accountId: scope.accountId,
      projectId: s.projectId,
      serverId: s.id,
    ),
  ),
);
