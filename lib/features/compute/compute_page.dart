// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/images/image_pages.dart';
import 'package:falco/features/placement_groups/placement_group_pages.dart';
import 'package:falco/features/servers/server_list.dart';
import 'package:falco/features/ssh_keys/ssh_key_pages.dart';
import 'package:falco/features/volumes/volume_pages.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// The Compute area: servers, volumes, images, placement groups and SSH
/// keys as tabs, each a list with its create action (CMP-001, CMP-007).
class ComputePage extends StatefulWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  State<ComputePage> createState() => _ComputePageState();
}

class _ComputePageState extends State<ComputePage>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 5, vsync: this)
    ..addListener(() => setState(() {}));

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = widget.scope;
    // Images come from servers (snapshot, backup); nothing to create here.
    final create = switch (_tabs.index) {
      0 => (CreateKind.server, l10n.actionCreateServer),
      1 => (CreateKind.volume, l10n.volumeCreate),
      3 => (CreateKind.placementGroup, l10n.placementGroupCreate),
      4 => (CreateKind.sshKey, l10n.sshKeyAdd),
      _ => null,
    };
    return Scaffold(
      floatingActionButton: switch (create) {
        (final kind, final label) => FloatingActionButton.extended(
          heroTag: kind,
          onPressed: () => CreateRoute.of(scope, kind).push<void>(context),
          icon: const Icon(Icons.add),
          label: Text(label),
        ),
        null => null,
      },
      body: Column(
        children: [
          TabBar(
            controller: _tabs,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l10n.resourceServers),
              Tab(text: l10n.resourceVolumes),
              Tab(text: l10n.resourceImages),
              Tab(text: l10n.resourcePlacementGroups),
              Tab(text: l10n.resourceSshKeys),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                ServerList(scope: scope),
                VolumeList(scope: scope),
                ImageList(scope: scope),
                PlacementGroupList(scope: scope),
                SshKeyList(scope: scope),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
