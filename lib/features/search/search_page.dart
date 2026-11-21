// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:async';

import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/features/search/search.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Search over all accounts: recent searches before input, then hits
/// grouped by type; a tap opens the hit's page (SUC-001 to SUC-005).
class SearchPage extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  void _search(String q) {
    _query
      ..text = q
      ..selection = TextSelection.collapsed(offset: q.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final index = ref.watch(searchIndexProvider);
    final recent = ref.watch(recentSearchesProvider);
    final q = _query.text;
    // Nothing loaded yet: skeleton, or the error when loading failed.
    final empty = index.hits.isEmpty && (index.loading || index.failed > 0);
    return FalcoScaffold(
      title: l10n.commonSearch,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _query,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              onSubmitted: ref.read(recentSearchesProvider.notifier).add,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: q.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l10n.searchClear,
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => _search(''),
                      ),
              ),
            ),
          ),
          Expanded(
            child: q.trim().isEmpty
                ? _Recent(
                    recent: recent,
                    onPick: _search,
                    onClear: ref.read(recentSearchesProvider.notifier).clear,
                  )
                : ResourceList<SearchHit>(
                    title: l10n.searchResults,
                    items: empty ? null : searchHits(index.hits, q),
                    loading: index.loading,
                    // With hits a failed source shows as the list banner.
                    error: index.error == null
                        ? null
                        : errorText(toFalcoError(index.error!), l10n),
                    onRefresh: () async => refreshSearch(ref),
                    empty: EmptyHint(message: l10n.searchNoMatches),
                    groupOf: (h) => searchGroupText(h.group, l10n),
                    itemBuilder: (context, h) => ResourceRow(
                      status: h.status,
                      name: h.name,
                      monoLine: [
                        h.detail(l10n),
                        h.where,
                      ].where((s) => s.isNotEmpty).join(' · '),
                      onTap: () {
                        ref.read(recentSearchesProvider.notifier).add(q);
                        unawaited(h.route.push<void>(context));
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Recent extends StatelessWidget {
  const new({
    required this.recent,
    required this.onPick,
    required this.onClear,
  });

  final List<String> recent;
  final ValueChanged<String> onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (recent.isEmpty) return EmptyHint(message: l10n.searchStart);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: FalcoSpacing.s),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.searchRecent.toUpperCase(),
                  style: FalcoText.of(context).sectionLabel,
                ),
              ),
              TextButton(onPressed: onClear, child: Text(l10n.searchClear)),
            ],
          ),
        ),
        for (final r in recent)
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(r),
            onTap: () => onPick(r),
          ),
      ],
    );
  }
}

/// Localized title of a result group.
String searchGroupText(SearchGroup g, AppLocalizations l10n) => switch (g) {
  SearchGroup.server => l10n.resourceServers,
  SearchGroup.dedicated => l10n.searchDedicated,
  SearchGroup.volume => l10n.resourceVolumes,
  SearchGroup.image => l10n.resourceImages,
  SearchGroup.placementGroup => l10n.resourcePlacementGroups,
  SearchGroup.sshKey => l10n.resourceSshKeys,
  SearchGroup.network => l10n.resourceNetworks,
  SearchGroup.firewall => l10n.resourceFirewalls,
  SearchGroup.floatingIp => l10n.resourceFloatingIps,
  SearchGroup.primaryIp => l10n.resourcePrimaryIps,
  SearchGroup.loadBalancer => l10n.resourceLoadBalancers,
  SearchGroup.certificate => l10n.resourceCertificates,
  SearchGroup.zone => l10n.resourceZones,
  SearchGroup.storageBox => l10n.resourceStorageBoxes,
  SearchGroup.bucket => l10n.resourceBuckets,
  SearchGroup.failover => l10n.robotFailover,
  SearchGroup.vswitch => l10n.robotVSwitches,
  SearchGroup.robotKey => l10n.searchRobotKeys,
};
