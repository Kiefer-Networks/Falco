// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:async';
import 'dart:io';

import 'package:falco/api/s3/s3.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/clipboard/sensitive_clipboard.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/files/text_files.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/permissions/notifications.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/accounts/checks.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/storage/object_storage.dart';
import 'package:falco/features/storage/transfers.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

/// Expiry choices of a share link (OBJ-011).
const shareExpiries = [
  Duration(hours: 1),
  Duration(hours: 24),
  Duration(days: 7),
];

/// Runs [change] on S3 and shows [done] or the failure; returns whether it
/// worked.
Future<bool> runS3(
  BuildContext context,
  Future<void> Function() change, {
  String? done,
}) async {
  final l10n = AppLocalizations.of(context);
  try {
    await change();
    if (context.mounted && done != null) {
      FalcoScaffold.showSnack(context, done);
    }
    return true;
  } on Object catch (error) {
    if (context.mounted) {
      FalcoScaffold.showSnack(context, s3ErrorText(error, l10n));
    }
    return false;
  }
}

/// Text of a failed S3 change or transfer. Not only S3 answers: the
/// platform refuses a transfer, and the device's own storage fails (full)
/// while parts are copied.
String s3ErrorText(Object error, AppLocalizations l10n) {
  if (error is FileSystemException) return l10n.errorLocalStorage;
  final e = toFalcoError(error);
  return e is Invalid && e.code == dotSegmentKey
      ? l10n.objectKeyDotSegment
      : errorText(e, l10n);
}

/// Buckets of a scope at all locations (OBJ-001, OBJ-020).
class BucketList extends ConsumerWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = bucketsProvider(scope);
    final async = ref.watch(provider);
    if (async.hasValue && async.value == null) {
      return ActionHint(
        message: l10n.s3NoKeysHint,
        actionLabel: l10n.accountManage,
        onAction: () =>
            AccountRoute(accountId: scope.accountId).push<void>(context),
      );
    }
    final accounts = scope is AllProjectsScope
        ? ref.watch(accountsProvider.select((a) => a.value))
        : null;
    return ResourceList<Bucket>(
      title: l10n.resourceBuckets,
      items: async.value,
      loading: async.isLoading,
      error: async.hasError
          ? errorText(toFalcoError(async.error!), l10n)
          : null,
      onRefresh: () => refreshQuietly(ref, provider.future),
      empty: EmptyHint(message: l10n.emptyBuckets),
      searchText: (b) => b.name,
      filters: [
        ResourceFilter(l10n.filterAll, (_) => true),
        for (final l in s3Locations) ResourceFilter(l, (b) => b.location == l),
      ],
      sorts: [
        ResourceSort(l10n.sortName, (a, b) => a.name.compareTo(b.name)),
        ResourceSort(
          l10n.sortCreated,
          (a, b) =>
              (b.created ?? DateTime(0)).compareTo(a.created ?? DateTime(0)),
        ),
      ],
      itemBuilder: (context, b) => ResourceRow(
        status: ResourceStatus.available,
        name: b.name,
        monoLine: [
          b.location,
          if (b.created case final c?) formatDateTime(c, l10n.localeName),
          if (accounts != null) projectName(accounts, b.projectId),
        ].join(' · '),
        onTap: () => openDetail(
          context,
          BucketRoute(
            accountId: scope.accountId,
            projectId: b.projectId,
            region: b.location,
            bucket: b.name,
          ),
        ),
      ),
    );
  }
}

/// Create a bucket: location, name, visibility, versioning (OBJ-002).
class CreateBucketPage extends ConsumerStatefulWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  ConsumerState<CreateBucketPage> createState() => _CreateBucketPageState();
}

class _CreateBucketPageState extends ConsumerState<CreateBucketPage> {
  String? _project;
  String _location = '';
  var _values = <String, String>{};
  bool _creating = false;

  Future<void> _create(ProjectScope scope) async {
    if (_creating) return;
    setState(() => _creating = true);
    final name = _values['name']!.trim();
    final ok = await runS3(
      context,
      () =>
          ref.read(s3AccessProvider).run(scope.projectId, _location, (c) async {
            await c.createBucket(name, public: _values['public'] == 'true');
            if (_values['versioning'] == 'true') {
              await c.setVersioning(name, enabled: true);
            }
          }),
    );
    if (!mounted) return;
    ref.invalidate(bucketsProvider);
    setState(() => _creating = false);
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = targetScope(widget.scope, _project);
    final yesNo = {'false': l10n.commonNo, 'true': l10n.commonYes};
    final details = [
      FieldSpec(
        'name',
        l10n.fieldName,
        maxLength: 63,
        helper: l10n.bucketNameHint,
      ),
      FieldSpec(
        'public',
        l10n.bucketVisibility,
        initial: 'false',
        options: {'false': l10n.bucketPrivate, 'true': l10n.bucketPublic},
      ),
      FieldSpec(
        'versioning',
        l10n.bucketVersioning,
        initial: 'false',
        options: yesNo,
      ),
    ];
    return CreateWizard(
      title: l10n.bucketCreate,
      creating: _creating,
      onCreate: scope == null ? null : () => _create(scope),
      projectStep: projectStep(
        ref,
        l10n,
        widget.scope,
        _project,
        (p) => setState(() => _project = p),
      ),
      steps: [
        WizardStep(
          title: l10n.fieldLocation,
          canContinue: s3Locations.contains(_location),
          child: ChoiceList(
            options: {for (final l in s3Locations) l: l},
            selected: _location,
            onSelected: (v) => setState(() => _location = v),
          ),
        ),
        WizardStep(
          title: l10n.wizardDetails,
          canContinue: validBucketName((_values['name'] ?? '').trim()),
          child: FormFields(
            fields: details,
            values: _values,
            onChanged: (v) => setState(() => _values = {..._values, ...v}),
          ),
        ),
      ],
      summary: FactRows([
        ConfirmFact(l10n.fieldName, (_values['name'] ?? '').trim()),
        ConfirmFact(l10n.fieldLocation, _location),
        ConfirmFact(
          l10n.bucketVisibility,
          _values['public'] == 'true' ? l10n.bucketPublic : l10n.bucketPrivate,
        ),
        ConfirmFact(
          l10n.bucketVersioning,
          yesNo[_values['versioning'] ?? 'false']!,
        ),
      ]),
    );
  }
}

/// A folder or an object of a listing.
typedef _Entry = ({String key, S3Object? object});

/// The object browser of a bucket below [prefix] (OBJ-006 to OBJ-025).
class BucketPage extends ConsumerStatefulWidget {
  const new({
    required this.scope,
    required this.location,
    required this.bucket,
    this.prefix = '',
    super.key,
  });

  final ProjectScope scope;
  final String location;
  final String bucket;
  final String prefix;

  @override
  ConsumerState<BucketPage> createState() => _BucketPageState();
}

class _BucketPageState extends ConsumerState<BucketPage> {
  final _selected = <String>{};

  String get _p => widget.scope.projectId;
  String get _l => widget.location;
  String get _b => widget.bucket;

  S3Access get _s3 => ref.read(s3AccessProvider);

  Future<T> _run<T>(Future<T> Function(S3Client c) f) => _s3.run(_p, _l, f);

  void _refresh() => ref.invalidate(objectsProvider(_p, _l, _b, widget.prefix));

  void _open(String folder) => BucketRoute(
    accountId: widget.scope.accountId,
    projectId: _p,
    region: _l,
    bucket: _b,
    prefix: folder,
  ).push<void>(context);

  late final ObjectTransfers _transferService;
  StreamSubscription<TransferEvent>? _transfers;

  @override
  void initState() {
    super.initState();
    // Open, so transfers of this bucket wait for it, not for any browser.
    _transferService = ref.read(transfersProvider)..openBucket(_b);
    _transfers = _transferService.events.listen((_) => _showTransfer());
  }

  @override
  void dispose() {
    unawaited(_transfers?.cancel());
    _transferService.closeBucket(_b);
    super.dispose();
  }

  /// Shows finished transfers, one after the other. Every folder level
  /// listens; only the one on top shows them, and a sheet over it or the
  /// lock defers them until it closes.
  void _showTransfer() {
    if (!mounted || ModalRoute.isCurrentOf(context) == false) return;
    if (ref.read(appLockProvider) != AppLockState.unlocked) return;
    final events = ref.read(transfersProvider).takeUnseen(_b);
    if (events.isEmpty) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    for (final e in events) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(switch (e) {
            (upload: true, ok: true, :final name) => l10n.uploadDone(name),
            (upload: false, ok: true, :final name) => l10n.downloadSaved(name),
            (:final name, ok: false, upload: _) => l10n.transferFailedNamed(
              name,
            ),
          }),
        ),
      );
    }
  }

  void _toggle(String key) => setState(
    () => _selected.contains(key) ? _selected.remove(key) : _selected.add(key),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = objectsProvider(_p, _l, _b, widget.prefix);
    final async = ref.watch(provider);
    ref.listen(appLockProvider, (_, _) => _showTransfer());
    // Rebuilt when a sheet over it closes: shows what finished meanwhile.
    if ((ModalRoute.isCurrentOf(context) ?? true) &&
        ref.read(transfersProvider).hasUnseen(_b)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showTransfer());
    }
    final listing = async.value;
    final items = listing == null
        ? null
        : <_Entry>[
            for (final f in listing.folders) (key: f, object: null),
            for (final o in listing.objects) (key: o.key, object: o),
          ];
    final selecting = _selected.isNotEmpty;
    return FalcoScaffold(
      title: selecting
          ? l10n.selectedCount(_selected.length)
          : (widget.prefix.isEmpty ? _b : baseName(widget.prefix)),
      moreMenu: MoreMenu(
        actions: selecting
            ? [
                DetailAction(
                  label: l10n.selectionClear,
                  icon: Icons.deselect,
                  group: ActionGroup.manage,
                  onTap: () => setState(_selected.clear),
                ),
                DetailAction(
                  label: l10n.actionDelete,
                  icon: Icons.delete_outline,
                  group: ActionGroup.danger,
                  onTap: _deleteSelected,
                ),
              ]
            : [
                DetailAction(
                  label: l10n.bucketSettings,
                  icon: Icons.tune,
                  group: ActionGroup.manage,
                  onTap: _settings,
                ),
                DetailAction(
                  label: l10n.folderCreate,
                  icon: Icons.create_new_folder_outlined,
                  group: ActionGroup.manage,
                  onTap: _createFolder,
                ),
                DetailAction(
                  label: l10n.uploadLink,
                  icon: Icons.link,
                  group: ActionGroup.access,
                  onTap: _uploadLink,
                ),
                if (widget.prefix.isEmpty)
                  DetailAction(
                    label: l10n.bucketDelete,
                    icon: Icons.delete_outline,
                    group: ActionGroup.danger,
                    onTap: _deleteBucket,
                  ),
              ],
      ),
      floatingActionButton: selecting
          ? null
          : FloatingActionButton.extended(
              onPressed: _upload,
              icon: const Icon(Icons.upload),
              label: Text(l10n.objectUpload),
            ),
      body: ResourceList<_Entry>(
        title: '$_b/${widget.prefix}',
        items: items,
        loading: async.isLoading,
        error: async.hasError
            ? errorText(toFalcoError(async.error!), l10n)
            : null,
        onRefresh: () => refreshQuietly(ref, provider.future),
        empty: EmptyHint(message: l10n.emptyObjects),
        searchText: (e) => baseName(e.key),
        sorts: [
          ResourceSort(l10n.sortName, (a, b) => a.key.compareTo(b.key)),
          ResourceSort(
            l10n.sortSize,
            (a, b) => (b.object?.size ?? -1).compareTo(a.object?.size ?? -1),
          ),
        ],
        itemBuilder: (context, e) {
          final o = e.object;
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: selecting && o != null
                ? Checkbox(
                    value: _selected.contains(e.key),
                    onChanged: (_) => _toggle(e.key),
                  )
                : Icon(
                    o == null
                        ? Icons.folder_outlined
                        : Icons.description_outlined,
                  ),
            title: Text(baseName(e.key)),
            subtitle: o == null
                ? null
                : Mono(
                    [
                      formatBytes(o.size, l10n.localeName),
                      if (o.modified case final m?)
                        formatDateTime(m, l10n.localeName),
                    ].join(' · '),
                  ),
            onTap: o == null
                ? () => _open(e.key)
                : selecting
                ? () => _toggle(e.key)
                : () => _actions(o),
            onLongPress: o == null ? null : () => _toggle(e.key),
          );
        },
      ),
    );
  }

  Future<void> _upload() async {
    final l10n = AppLocalizations.of(context);
    final File? picked;
    try {
      picked = await ref.read(textFilesProvider).pickFile();
    } on Exception catch (_) {
      if (mounted) FalcoScaffold.showSnack(context, l10n.actionFailed);
      return;
    }
    if (picked == null) return;
    final file = picked;
    // The picker's copy goes unless a transfer sends it; a finished
    // single part upload or the part copies of a multipart one drop it.
    void drop() => unawaited(dropUploadCopy(file.path));
    if (!mounted) return drop();
    final name = file.uri.pathSegments.last;
    final key = '${widget.prefix}$name';
    final mime = mimeOf(name);
    if (!validKey(key) || !validMime(mime) || !validBucketName(_b)) {
      FalcoScaffold.showSnack(context, l10n.objectKeyInvalid);
      return drop();
    }
    final hint = await notificationHint(ref, l10n);
    if (!mounted) return drop();
    try {
      await ref
          .read(transfersProvider)
          .upload(
            projectId: _p,
            location: _l,
            bucket: _b,
            key: key,
            file: file,
            contentType: mime,
          );
      if (mounted) {
        FalcoScaffold.showSnack(context, '${l10n.uploadStarted(name)}$hint');
      }
    } on Object catch (e) {
      drop();
      if (mounted) FalcoScaffold.showSnack(context, s3ErrorText(e, l10n));
    }
  }

  Future<void> _actions(S3Object o) {
    final l10n = AppLocalizations.of(context);
    DetailAction item(
      IconData icon,
      String label,
      ActionGroup group,
      VoidCallback onTap,
    ) => DetailAction(icon: icon, label: label, group: group, onTap: onTap);
    return showActionSheet(
      context,
      title: baseName(o.key),
      actions: [
        item(
          Icons.download,
          l10n.objectDownload,
          ActionGroup.access,
          () => _download(o.key),
        ),
        item(
          Icons.share_outlined,
          l10n.shareLink,
          ActionGroup.access,
          () => _share(o),
        ),
        item(
          Icons.info_outline,
          l10n.objectInfo,
          ActionGroup.manage,
          () => _info(o),
        ),
        item(
          Icons.history,
          l10n.objectVersions,
          ActionGroup.manage,
          () => _versions(o),
        ),
        item(
          Icons.copy,
          l10n.objectCopy,
          ActionGroup.manage,
          () => _copy(o, move: false),
        ),
        item(
          Icons.drive_file_move_outline,
          l10n.objectMove,
          ActionGroup.manage,
          () => _copy(o, move: true),
        ),
        item(
          Icons.delete_outline,
          l10n.actionDelete,
          ActionGroup.danger,
          () => _delete(o),
        ),
      ],
    );
  }

  Future<void> _info(S3Object o) => showFalcoSheet<void>(
    context,
    Consumer(
      builder: (context, ref, _) {
        final l10n = AppLocalizations.of(context);
        final async = ref.watch(objectInfoProvider(_p, _l, _b, o.key));
        final i = async.value;
        return SheetFrame(
          title: l10n.objectInfo,
          children: [
            if (async.hasError)
              ErrorBanner(message: errorText(toFalcoError(async.error!), l10n))
            else if (i == null)
              const Center(child: CircularProgressIndicator())
            else
              FactRows([
                ConfirmFact(l10n.fieldKey, i.key, mono: true),
                ConfirmFact(
                  l10n.fieldSize,
                  formatBytes(i.size, l10n.localeName),
                ),
                if (i.modified case final m?)
                  ConfirmFact(
                    l10n.fieldModified,
                    formatDateTime(m, l10n.localeName),
                  ),
                ConfirmFact(l10n.fieldContentType, i.contentType ?? ''),
                ConfirmFact(l10n.fieldEtag, i.etag ?? '', mono: true),
              ]),
          ],
        );
      },
    ),
  );

  Future<void> _download(String key, [String? versionId]) async {
    final l10n = AppLocalizations.of(context);
    final hint = await notificationHint(ref, l10n);
    if (!mounted) return;
    await runS3(
      context,
      () => ref
          .read(transfersProvider)
          .download(
            projectId: _p,
            location: _l,
            bucket: _b,
            key: key,
            versionId: versionId,
          ),
      done: '${l10n.downloadStarted(baseName(key))}$hint',
    );
  }

  Future<void> _share(S3Object o) async {
    final l10n = AppLocalizations.of(context);
    final picked = await ChoiceList.show(
      context,
      title: l10n.shareExpiry,
      options: {
        for (final d in shareExpiries) '${d.inHours}': expiryText(d, l10n),
      },
      selected: '',
    );
    if (picked == null || !mounted) return;
    Uri? link;
    await runS3(
      context,
      () async => link = await _s3.presign(
        _p,
        _l,
        'GET',
        _b,
        o.key,
        expires: Duration(hours: int.parse(picked)),
      ),
    );
    if (link != null && mounted) {
      await showLink(context, l10n.shareLink, '$link');
    }
  }

  Future<void> _uploadLink() {
    final l10n = AppLocalizations.of(context);
    return FormSheet.show(
      context,
      title: l10n.uploadLink,
      fields: (_) => [
        FieldSpec('key', l10n.fieldKey, initial: widget.prefix),
        FieldSpec(
          'expiry',
          l10n.shareExpiry,
          initial: '1',
          options: {
            for (final d in shareExpiries) '${d.inHours}': expiryText(d, l10n),
          },
        ),
      ],
      valid: (v) => validKey(v['key'] ?? '') && !(v['key'] ?? '').endsWith('/'),
      onSave: (v) async {
        final link = await _s3.presign(
          _p,
          _l,
          'PUT',
          _b,
          v['key']!,
          expires: Duration(hours: int.parse(v['expiry']!)),
        );
        if (mounted) {
          // After the form sheet closed.
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => showLink(context, l10n.uploadLink, '$link'),
          );
        }
      },
    );
  }

  Future<void> _versions(S3Object o) => showFalcoSheet<void>(
    context,
    Consumer(
      builder: (context, ref, _) {
        final l10n = AppLocalizations.of(context);
        final async = ref.watch(objectVersionsProvider(_p, _l, _b, o.key));
        final list = async.value;
        return SheetFrame(
          title: l10n.objectVersions,
          children: [
            if (async.hasError)
              ErrorBanner(message: errorText(toFalcoError(async.error!), l10n))
            else if (list == null)
              const Center(child: CircularProgressIndicator())
            else
              entries([
                for (final v in list)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      [
                        if (v.modified case final m?)
                          formatDateTime(m, l10n.localeName),
                        if (v.latest) l10n.versionLatest,
                        if (v.deleteMarker) l10n.versionDeleteMarker,
                      ].join(' · '),
                    ),
                    subtitle: Mono(
                      [
                        formatBytes(v.size, l10n.localeName),
                        v.versionId,
                      ].join(' · '),
                    ),
                    trailing: v.deleteMarker || v.latest
                        ? null
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: l10n.objectDownload,
                                icon: const Icon(Icons.download),
                                onPressed: () => _download(o.key, v.versionId),
                              ),
                              IconButton(
                                tooltip: l10n.versionRestore,
                                icon: const Icon(Icons.restore),
                                onPressed: () => _restore(context, o, v),
                              ),
                            ],
                          ),
                  ),
              ], l10n.versionsEmpty),
          ],
        );
      },
    ),
  );

  Future<void> _restore(BuildContext sheet, S3Object o, S3Version v) async {
    final l10n = AppLocalizations.of(context);
    final ok = await ConfirmSheet.show(
      sheet,
      title: l10n.versionRestoreTitle(baseName(o.key)),
      consequence: l10n.versionRestoreConsequence,
      confirmLabel: l10n.versionRestore,
      resourceName: baseName(o.key),
    );
    if (!ok || !mounted) return;
    if (sheet.mounted) Navigator.pop(sheet);
    if (await runS3(
          context,
          () =>
              _run((c) => c.copy(_b, o.key, _b, o.key, versionId: v.versionId)),
          done: l10n.savedMessage,
        ) &&
        mounted) {
      _refresh();
      ref.invalidate(objectVersionsProvider);
    }
  }

  Future<void> _copy(S3Object o, {required bool move}) async {
    final l10n = AppLocalizations.of(context);
    final all = await loadForPicker(
      context,
      () async =>
          await ref.read(bucketsProvider(widget.scope).future) ??
          const <Bucket>[],
    );
    if (all == null || !mounted) return;
    await FormSheet.show(
      context,
      title: move ? l10n.objectMove : l10n.objectCopy,
      fields: (_) => [
        FieldSpec(
          'bucket',
          l10n.resourceBucket,
          initial: _b,
          // S3 copies within one location.
          options: {
            for (final b in all)
              if (b.location == _l) b.name: b.name,
          },
        ),
        FieldSpec('key', l10n.fieldKey, initial: o.key),
      ],
      valid: (v) {
        final key = v['key'] ?? '';
        // A trailing `/` would hide the object as a folder marker.
        return validKey(key) &&
            !key.endsWith('/') &&
            !(v['bucket'] == _b && key == o.key);
      },
      onSave: (v) async {
        await _run((c) async {
          await c.copy(_b, o.key, v['bucket']!, v['key']!);
          if (move) await c.delete(_b, o.key);
        });
        ref.invalidate(objectsProvider);
      },
    );
  }

  Future<void> _delete(S3Object o) async {
    final l10n = AppLocalizations.of(context);
    final name = baseName(o.key);
    final t = (scope: widget.scope, type: 'object', id: 0, name: name);
    if (!await confirmDelete(context, t, l10n.objectDeleteConsequence) ||
        !mounted) {
      return;
    }
    if (await runS3(
          context,
          () => _run((c) => c.delete(_b, o.key)),
          done: l10n.deletedMessage(name),
        ) &&
        mounted) {
      _refresh();
    }
  }

  Future<void> _deleteSelected() async {
    final l10n = AppLocalizations.of(context);
    final keys = _selected.toList();
    final ok = await ConfirmSheet.show(
      context,
      title: l10n.objectsDeleteTitle(keys.length),
      consequence: l10n.objectDeleteConsequence,
      confirmLabel: l10n.actionDelete,
      resourceName: '${keys.length}',
      destructive: true,
    );
    if (!ok || !mounted) return;
    var failed = <String>[];
    if (!await runS3(
          context,
          () async => failed = await _run((c) => c.deleteMany(_b, keys)),
        ) ||
        !mounted) {
      return;
    }
    FalcoScaffold.showSnack(
      context,
      failed.isEmpty
          ? l10n.objectsDeleted(keys.length)
          : l10n.objectsDeletedPartly(
              keys.length - failed.length,
              failed.length,
            ),
    );
    setState(
      () => _selected
        ..clear()
        ..addAll(failed),
    );
    _refresh();
  }

  Future<void> _createFolder() {
    final l10n = AppLocalizations.of(context);
    return FormSheet.show(
      context,
      title: l10n.folderCreate,
      fields: (_) => [FieldSpec('name', l10n.fieldFolderName)],
      valid: (v) {
        final n = (v['name'] ?? '').trim();
        return n.isNotEmpty &&
            !n.contains('/') &&
            validKey('${widget.prefix}$n/');
      },
      onSave: (v) async {
        await _run(
          (c) => c.put(_b, '${widget.prefix}${v['name']!.trim()}/', []),
        );
        _refresh();
      },
    );
  }

  Future<void> _settings() async {
    final l10n = AppLocalizations.of(context);
    final s = await ref
        .read(bucketSettingsProvider(_p, _l, _b).future)
        .then<({String? versioning, bool public})?>((s) => s)
        .catchError((Object e) {
          if (mounted) {
            FalcoScaffold.showSnack(context, errorText(toFalcoError(e), l10n));
          }
          return null;
        });
    if (s == null || !mounted) return;
    await FormSheet.show(
      context,
      title: l10n.bucketSettings,
      fields: (_) => [
        FieldSpec(
          'versioning',
          l10n.bucketVersioning,
          initial: s.versioning ?? '',
          helper: l10n.bucketVersioningHint,
          options: {
            if (s.versioning == null) '': l10n.versioningNever,
            'Enabled': l10n.versioningEnabled,
            'Suspended': l10n.versioningSuspended,
          },
        ),
        FieldSpec(
          'public',
          l10n.bucketVisibility,
          initial: '${s.public}',
          helper: l10n.bucketPublicHint,
          options: {'false': l10n.bucketPrivate, 'true': l10n.bucketPublic},
        ),
      ],
      valid: (_) => true,
      onSave: (v) async {
        await _run((c) async {
          final versioning = v['versioning'] ?? '';
          if (versioning.isNotEmpty && versioning != (s.versioning ?? '')) {
            await c.setVersioning(_b, enabled: versioning == 'Enabled');
          }
          if ((v['public'] == 'true') != s.public) {
            await c.setPublic(_b, public: v['public'] == 'true');
          }
        });
        ref.invalidate(bucketSettingsProvider(_p, _l, _b));
      },
    );
  }

  Future<void> _deleteBucket() async {
    final l10n = AppLocalizations.of(context);
    final t = (scope: widget.scope, type: 'bucket', id: 0, name: _b);
    if (!await confirmDelete(context, t, l10n.bucketDeleteConsequence) ||
        !mounted) {
      return;
    }
    try {
      await _run((c) => c.deleteBucket(_b));
    } on FalcoError catch (e) {
      if (mounted) {
        FalcoScaffold.showSnack(
          context,
          e is Conflict ? l10n.bucketNotEmpty : errorText(e, l10n),
        );
      }
      return;
    }
    ref.invalidate(bucketsProvider);
    if (!mounted) return;
    FalcoScaffold.showSnack(context, l10n.deletedMessage(_b));
    Navigator.pop(context);
  }
}

/// "1 hour", "24 hours", "7 days".
String expiryText(Duration d, AppLocalizations l10n) =>
    d.inHours < 48 ? l10n.hours(d.inHours) : l10n.days(d.inDays);

/// Shows a presigned link to copy or share (OBJ-011, OBJ-025).
Future<void> showLink(BuildContext context, String title, String link) =>
    showFalcoSheet<void>(
      context,
      Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          return SheetFrame(
            title: title,
            children: [
              Mono(link, maxLines: 6),
              FilledButton.icon(
                icon: const Icon(Icons.content_copy),
                label: Text(l10n.commonCopy),
                onPressed: () async {
                  final marked = await SensitiveClipboard.copy(link);
                  if (context.mounted) {
                    final s = SensitiveClipboard.expiry.inSeconds;
                    FalcoScaffold.showSnack(
                      context,
                      marked ? l10n.copiedSensitive(s) : l10n.copiedPlain(s),
                    );
                  }
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.share_outlined),
                label: Text(l10n.commonShare),
                onPressed: () =>
                    SharePlus.instance.share(ShareParams(uri: Uri.parse(link))),
              ),
            ],
          );
        },
      ),
    );
