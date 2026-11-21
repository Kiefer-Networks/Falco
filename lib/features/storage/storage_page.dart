// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/storage/object_pages.dart';
import 'package:falco/features/storage/storage_box_pages.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// The Storage area: Storage Boxes and Object Storage as tabs, each a
/// list with its create action (README section 3, BUG-017).
class StoragePage extends StatefulWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 2, vsync: this)
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
    final (kind, label) = _tabs.index == 0
        ? (CreateKind.storageBox, l10n.storageBoxCreate)
        : (CreateKind.bucket, l10n.bucketCreate);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: kind,
        onPressed: () => CreateRoute.of(scope, kind).push<void>(context),
        icon: const Icon(Icons.add),
        label: Text(label),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabs,
            tabs: [
              Tab(text: l10n.resourceStorageBoxes),
              Tab(text: l10n.resourceObjectStorage),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                StorageBoxList(scope: scope),
                BucketList(scope: scope),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
