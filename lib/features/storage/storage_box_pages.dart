// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/activity/activity_page.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/storage/storage_boxes.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hetzner_storage_box_api/hetzner_storage_box_api.dart' as box;
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// Starts the Storage Box action of [start] and tracks it; a failure
/// becomes the screen's snackbar. Returns whether it started.
Future<bool> runBoxAction(
  BuildContext context,
  WidgetRef ref,
  ProjectScope scope,
  Future<int> Function(box.Server api) start,
) async {
  final l10n = AppLocalizations.of(context);
  try {
    await startBoxTracked(ref, scope, start);
    return true;
  } on FalcoError catch (e) {
    if (context.mounted) FalcoScaffold.showSnack(context, errorText(e, l10n));
    return false;
  }
}

/// Starts the Storage Box action of [start] from a sheet's save and
/// tracks it; a failure throws, so the sheet shows it and stays open.
Future<void> startBoxTracked(
  WidgetRef ref,
  ProjectScope scope,
  Future<int> Function(box.Server api) start,
) async {
  // Read before the first await: the page may be gone when it returns.
  final api = ref.read(storageBoxApiProvider(scope.projectId));
  final tracker = ref.read(storageBoxTrackerProvider(scope));
  final id = await start(api);
  tracker.track(id);
}

/// Label of an access setting.
String accessLabel(String key, AppLocalizations l10n) => switch (key) {
  'ssh_enabled' => l10n.accessSsh,
  'samba_enabled' => l10n.accessSamba,
  'webdav_enabled' => l10n.accessWebdav,
  'zfs_enabled' => l10n.accessZfs,
  'reachable_externally' => l10n.accessExternal,
  _ => l10n.accessReadonly,
};

/// One yes/no field per access setting of [keys].
List<FieldSpec> accessFields(
  AppLocalizations l10n,
  List<String> keys, [
  Access current = const {},
]) => [
  for (final k in keys)
    FieldSpec(
      k,
      accessLabel(k, l10n),
      initial: '${current[k] ?? false}',
      options: {'true': l10n.commonYes, 'false': l10n.commonNo},
    ),
];

/// The access settings of [keys] from form [values].
Access accessFrom(Map<String, String> values, List<String> keys) => {
  for (final k in keys) k: values[k] == 'true',
};

/// Access settings as facts.
List<ConfirmFact> accessFacts(Access access, AppLocalizations l10n) => [
  for (final MapEntry(:key, :value) in access.entries)
    ConfirmFact(accessLabel(key, l10n), yesNo(value, l10n)),
];

/// The password field and its repetition (STB-012, STB-018).
List<FieldSpec> passwordFields(AppLocalizations l10n) => [
  FieldSpec(
    'password',
    l10n.fieldPassword,
    secret: true,
    helper: l10n.boxPasswordHint,
  ),
  FieldSpec('repeat', l10n.fieldPasswordRepeat, secret: true),
];

/// Whether the password follows the policy and is repeated (STB-012).
bool validPasswords(Map<String, String> v) =>
    validBoxPassword(v['password'] ?? '') && v['password'] == v['repeat'];

/// Home directory: an existing folder or a new one; [current] is the
/// home being changed (STB-025, STB-033).
List<FieldSpec> homeFields(
  AppLocalizations l10n,
  List<String> folders,
  Map<String, String> values, [
  String current = '',
]) {
  final initial = folders.contains(current)
      ? current
      : (current.isEmpty ? folders.firstOrNull ?? '' : '');
  return [
    FieldSpec(
      'folder',
      l10n.fieldHomeDirectory,
      initial: initial,
      options: {for (final f in folders) f: f, '': l10n.boxNewFolder},
    ),
    if ((values['folder'] ?? initial).isEmpty)
      FieldSpec(
        'home',
        l10n.fieldFolderName,
        initial: folders.contains(current) ? '' : current,
      ),
  ];
}

/// The home directory from form values [v].
String homeFrom(Map<String, String> v) => switch (v['folder'] ?? '') {
  '' => (v['home'] ?? '').trim(),
  final f => f,
};

/// Storage Boxes of a scope (STB-001).
class StorageBoxList extends ConsumerWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = storageBoxesProvider(scope);
    final async = ref.watch(provider);
    final accounts = scope is AllProjectsScope
        ? ref.watch(accountsProvider.select((a) => a.value))
        : null;
    return ResourceList<StorageBox>(
      title: l10n.resourceStorageBoxes,
      items: async.value,
      loading: async.isLoading,
      error: async.hasError
          ? errorText(toFalcoError(async.error!), l10n)
          : null,
      onRefresh: () => refreshQuietly(ref, provider.future),
      empty: EmptyHint(message: l10n.emptyStorageBoxes),
      searchText: (b) => '${b.name} ${b.username}',
      filters: [
        ResourceFilter(l10n.filterAll, (_) => true),
        ResourceFilter(l10n.protected, (b) => b.protectDelete),
      ],
      sorts: [
        ResourceSort(l10n.sortName, (a, b) => a.name.compareTo(b.name)),
        ResourceSort(l10n.sortSize, (a, b) => b.capacity.compareTo(a.capacity)),
      ],
      itemBuilder: (context, b) => ResourceRow(
        status: b.status,
        name: b.name,
        monoLine: [
          b.username,
          b.typeName,
          b.location,
          if (b.protectDelete) l10n.protected,
          if (accounts != null) projectName(accounts, b.projectId),
        ].where((s) => s.isNotEmpty).join(' · '),
        onTap: () => openDetail(
          context,
          StorageBoxRoute(
            accountId: scope.accountId,
            projectId: b.projectId,
            boxId: b.id,
          ),
        ),
      ),
    );
  }
}

/// One Storage Box (STB-005 to STB-037 except create).
class StorageBoxDetailPage extends ConsumerWidget {
  const new({required this.scope, required this.boxId, super.key});

  final ProjectScope scope;
  final int boxId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = storageBoxProvider(scope, boxId);
    final async = ref.watch(provider);
    final b = async.value;
    if (b == null) {
      return DetailLoading(
        title: l10n.resourceStorageBox,
        error: async.error,
        onRetry: () => ref.invalidate(provider),
      );
    }
    final t = (scope: scope, type: storageBoxType, id: b.id, name: b.name);
    final progress = ref
        .watch(trackedActionProvider(scope, storageBoxType, b.id))
        .value;
    final busy = progress != null && !progress.done;
    final snapshots = ref.watch(boxSnapshotsProvider(scope, b.id)).value;
    final subs = ref.watch(subaccountsProvider(scope, b.id)).value;
    final locale = l10n.localeName;
    Future<void> act(Future<int> Function(box.Server api) start) =>
        runBoxAction(context, ref, scope, start);

    return FalcoScaffold(
      title: l10n.resourceStorageBox,
      body: DetailPage(
        status: busy ? ResourceStatus.inProgress : b.status,
        statusDetail: busy ? '${progress.progress} %' : null,
        name: b.name,
        ids: [b.username, b.server].where((s) => s.isNotEmpty).toList(),
        onRefresh: () async {
          ref
            ..invalidate(boxSnapshotsProvider(scope, b.id))
            ..invalidate(subaccountsProvider(scope, b.id))
            ..invalidate(boxActionsProvider(scope, b.id));
          await refreshQuietly(ref, provider.future);
        },
        actions: [
          DetailAction(
            icon: Icons.photo_camera_outlined,
            label: l10n.actionSnapshot,
            onTap: busy
                ? null
                : () => FormSheet.show(
                    context,
                    title: l10n.boxSnapshotCreate,
                    fields: (_) => [
                      FieldSpec('description', l10n.fieldDescription),
                    ],
                    valid: (_) => true,
                    onSave: (v) => startBoxTracked(
                      ref,
                      scope,
                      (api) => createBoxSnapshot(
                        api,
                        b.id,
                        (v['description'] ?? '').trim(),
                      ),
                    ),
                  ),
          ),
          DetailAction(
            icon: Icons.person_add_alt,
            label: l10n.subaccountCreate,
            onTap: busy ? null : () => _createSubaccount(context, ref, b),
          ),
          DetailAction(
            icon: Icons.password,
            label: l10n.boxResetPassword,
            onTap: busy
                ? null
                : () => FormSheet.show(
                    context,
                    title: l10n.boxResetPassword,
                    fields: (_) => passwordFields(l10n),
                    valid: validPasswords,
                    onSave: (v) => startBoxTracked(
                      ref,
                      scope,
                      (api) => resetBoxPassword(api, b.id, v['password']!),
                    ),
                  ),
          ),
          DetailAction(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            onTap: () => FormSheet.show(
              context,
              title: l10n.commonEdit,
              fields: (_) => [
                FieldSpec('name', l10n.fieldName, initial: b.name),
                labelsField(l10n, b.labels),
              ],
              valid: (v) =>
                  (v['name'] ?? '').trim().isNotEmpty && validLabels(v),
              onSave: (v) async {
                final container = ProviderScope.containerOf(
                  context,
                  listen: false,
                );
                await updateStorageBox(
                  ref.read(storageBoxApiProvider(scope.projectId)),
                  b.id,
                  name: v['name']?.trim(),
                  labels: parseLabels(v['labels'] ?? ''),
                );
                refreshResource(
                  container.invalidate,
                  scope,
                  storageBoxType,
                  b.id,
                );
              },
            ),
          ),
          DetailAction(
            label: l10n.boxAccessSettings,
            icon: Icons.tune,
            onTap: () => FormSheet.show(
              context,
              title: l10n.boxAccessSettings,
              fields: (_) => accessFields(l10n, boxAccessKeys, b.access),
              valid: (_) => true,
              onSave: (v) => startBoxTracked(
                ref,
                scope,
                (api) =>
                    updateBoxAccess(api, b.id, accessFrom(v, boxAccessKeys)),
              ),
            ),
          ),
          DetailAction(
            label: l10n.boxSnapshotPlan,
            icon: Icons.schedule,
            onTap: () => _plan(context, ref, b),
          ),
          DetailAction(
            label: l10n.boxChangeType,
            icon: Icons.swap_vert,
            onTap: () => _changeType(context, ref, b),
          ),
          DetailAction(
            label: b.protectDelete ? l10n.protectOff : l10n.protectOn,
            icon: b.protectDelete ? Icons.lock_open : Icons.lock,
            onTap: () async {
              if (await confirmProtection(
                    context,
                    t,
                    protect: !b.protectDelete,
                  ) &&
                  context.mounted) {
                await act(
                  (api) =>
                      protectStorageBox(api, b.id, delete: !b.protectDelete),
                );
              }
            },
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionOverview,
            child: FactRows([
              ConfirmFact(l10n.fieldUsername, b.username, mono: true),
              ConfirmFact(l10n.fieldServer, b.server, mono: true),
              ConfirmFact(l10n.fieldType, b.typeName),
              ConfirmFact(l10n.fieldLocation, b.location),
              ConfirmFact(l10n.fieldSize, formatBytes(b.capacity, locale)),
              ConfirmFact(l10n.boxUsedData, formatBytes(b.usedData, locale)),
              ConfirmFact(
                l10n.boxUsedSnapshots,
                formatBytes(b.usedSnapshots, locale),
              ),
              ConfirmFact(
                l10n.fieldDeleteProtection,
                yesNo(b.protectDelete, l10n),
              ),
              ConfirmFact(l10n.fieldCreated, formatDateTime(b.created, locale)),
              ConfirmFact(l10n.fieldLabels, labelsText(b.labels, l10n)),
            ]),
          ),
          DetailSection(
            title: l10n.boxUsage,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: FalcoSpacing.xs,
              children: [
                LinearProgressIndicator(
                  value: b.capacity == 0 ? 0 : b.used / b.capacity,
                ),
                Text(
                  l10n.boxUsedOf(
                    formatBytes(b.used, locale),
                    formatBytes(b.capacity, locale),
                  ),
                ),
              ],
            ),
          ),
          DetailSection(
            title: l10n.boxAccessSettings,
            child: FactRows(accessFacts(b.access, l10n)),
          ),
          DetailSection(
            title: l10n.boxSnapshotPlan,
            child: Text(planText(b.plan, l10n)),
          ),
          DetailSection(
            title: l10n.sectionSnapshots,
            child: entries([
              for (final s in snapshots ?? const <BoxSnapshot>[])
                EntryRow(
                  title: s.description.isEmpty ? s.name : s.description,
                  subtitle: [
                    formatDateTime(s.created, locale),
                    formatBytes(s.size, locale),
                    if (s.automatic) l10n.boxAutomatic,
                  ].join(' · '),
                  onTap: () => BoxSnapshotRoute(
                    accountId: scope.accountId,
                    projectId: scope.projectId,
                    boxId: b.id,
                    snapshotId: s.id,
                  ).push<void>(context),
                ),
            ], l10n.emptyBoxSnapshots),
          ),
          DetailSection(
            title: l10n.sectionSubaccounts,
            child: entries([
              for (final s in subs ?? const <Subaccount>[])
                EntryRow(
                  title: s.username,
                  subtitle: [
                    s.home,
                    if (s.description.isNotEmpty) s.description,
                    if (s.access['readonly'] ?? false) l10n.accessReadonly,
                  ].join(' · '),
                  onTap: () => SubaccountRoute(
                    accountId: scope.accountId,
                    projectId: scope.projectId,
                    boxId: b.id,
                    subaccountId: s.id,
                  ).push<void>(context),
                ),
            ], l10n.emptySubaccounts),
          ),
          activitySection(l10n, scope, storageBoxType, b.id),
        ],
        dangerZone: [
          DeleteButton(
            onPressed: b.protectDelete
                ? null
                : () async {
                    if (!await confirmDelete(
                          context,
                          t,
                          l10n.boxDeleteConsequence,
                        ) ||
                        !context.mounted) {
                      return;
                    }
                    if (await runBoxAction(
                          context,
                          ref,
                          scope,
                          (api) => deleteStorageBox(api, b.id),
                        ) &&
                        context.mounted) {
                      FalcoScaffold.showSnack(
                        context,
                        l10n.deletedMessage(b.name),
                      );
                      Navigator.pop(context);
                    }
                  },
          ),
        ],
      ),
    );
  }

  Future<void> _plan(BuildContext context, WidgetRef ref, StorageBox b) {
    final l10n = AppLocalizations.of(context);
    final p = b.plan;
    final days = {'': l10n.boxEveryDay};
    return FormSheet.show(
      context,
      title: l10n.boxSnapshotPlan,
      fields: (v) => [
        FieldSpec(
          'enabled',
          l10n.boxAutomaticSnapshots,
          initial: '${p != null}',
          options: {'true': l10n.commonYes, 'false': l10n.commonNo},
        ),
        if (v['enabled'] != 'false') ...[
          FieldSpec(
            'max',
            l10n.boxMaxSnapshots,
            initial: '${p?.maxSnapshots ?? 10}',
          ),
          FieldSpec(
            'hour',
            l10n.boxPlanHour,
            initial: '${p?.hour ?? 3}',
            helper: l10n.boxPlanUtc,
          ),
          FieldSpec('minute', l10n.boxPlanMinute, initial: '${p?.minute ?? 0}'),
          FieldSpec(
            'weekday',
            l10n.boxPlanWeekday,
            initial: '${p?.dayOfWeek ?? ''}',
            options: {
              ...days,
              for (var d = 1; d <= 7; d++) '$d': weekdayName(d, l10n),
            },
          ),
          FieldSpec(
            'monthday',
            l10n.boxPlanMonthday,
            initial: '${p?.dayOfMonth ?? ''}',
            options: {...days, for (var d = 1; d <= 31; d++) '$d': '$d'},
          ),
        ],
      ],
      valid: (v) => v['enabled'] == 'false' || planFrom(v) != null,
      onSave: (v) => startBoxTracked(
        ref,
        scope,
        (api) => setSnapshotPlan(
          api,
          b.id,
          v['enabled'] == 'false' ? null : planFrom(v),
        ),
      ),
    );
  }

  Future<void> _changeType(
    BuildContext context,
    WidgetRef ref,
    StorageBox b,
  ) async {
    final l10n = AppLocalizations.of(context);
    final types = await ref.read(boxTypesProvider(scope).future);
    if (!context.mounted) return;
    await FormSheet.show(
      context,
      title: l10n.boxChangeType,
      fields: (_) => [
        FieldSpec(
          'type',
          l10n.fieldType,
          initial: b.typeName,
          options: {
            for (final ty in types) ty.name: typeText(ty, b.location, l10n),
          },
        ),
      ],
      valid: (v) => v['type'] != b.typeName,
      onSave: (v) => startBoxTracked(
        ref,
        scope,
        (api) => changeBoxType(api, b.id, v['type']!),
      ),
    );
  }

  Future<void> _createSubaccount(
    BuildContext context,
    WidgetRef ref,
    StorageBox b,
  ) async {
    final l10n = AppLocalizations.of(context);
    final folders = await ref
        .read(boxFoldersProvider(scope, b.id).future)
        .catchError((Object _) => const <String>[]);
    if (!context.mounted) return;
    await FormSheet.show(
      context,
      title: l10n.subaccountCreate,
      fields: (v) => [
        ...homeFields(l10n, folders, v),
        ...passwordFields(l10n),
        FieldSpec('name', l10n.fieldNameOptional),
        FieldSpec('description', l10n.fieldDescription),
        ...accessFields(l10n, subaccountAccessKeys, const {
          'samba_enabled': true,
          'ssh_enabled': true,
          'webdav_enabled': true,
        }),
        labelsField(l10n),
      ],
      valid: (v) =>
          homeFrom(v).isNotEmpty && validPasswords(v) && validLabels(v),
      onSave: (v) => startBoxTracked(
        ref,
        scope,
        (api) => createSubaccount(
          api,
          b.id,
          home: homeFrom(v),
          password: v['password']!,
          access: accessFrom(v, subaccountAccessKeys),
          name: (v['name'] ?? '').trim(),
          description: (v['description'] ?? '').trim(),
          labels: parseLabels(v['labels'] ?? '') ?? const {},
        ),
      ),
    );
  }
}

/// The plan from form values [v]; null when a number is out of range.
SnapshotPlan? planFrom(Map<String, String> v) {
  final max = int.tryParse(v['max']?.trim() ?? '');
  final hour = int.tryParse(v['hour']?.trim() ?? '');
  final minute = int.tryParse(v['minute']?.trim() ?? '');
  if (max == null || max < 1 || hour == null || hour < 0 || hour > 23) {
    return null;
  }
  if (minute == null || minute < 0 || minute > 59) return null;
  return (
    maxSnapshots: max,
    hour: hour,
    minute: minute,
    dayOfWeek: int.tryParse(v['weekday'] ?? ''),
    dayOfMonth: int.tryParse(v['monthday'] ?? ''),
  );
}

/// Name of ISO weekday [d], 1 is Monday.
String weekdayName(int d, AppLocalizations l10n) =>
    DateFormat.EEEE(l10n.localeName).format(DateTime(2024, 1, d));

/// The plan in one line (STB-030, STB-031).
String planText(SnapshotPlan? p, AppLocalizations l10n) {
  if (p == null) return l10n.commonOff;
  final time =
      '${p.hour.toString().padLeft(2, '0')}:'
      '${p.minute.toString().padLeft(2, '0')} UTC';
  final when = p.dayOfMonth != null
      ? l10n.boxPlanMonthly(p.dayOfMonth!, time)
      : p.dayOfWeek != null
      ? l10n.boxPlanWeekly(weekdayName(p.dayOfWeek!, l10n), time)
      : l10n.boxPlanDaily(time);
  return l10n.boxPlanKeeps(when, p.maxSnapshots);
}

/// A box type with size and monthly price at [location] (STB-029).
String typeText(BoxType t, String location, AppLocalizations l10n) {
  final price = switch (t.monthlyGross[location]) {
    final g? => ' · ${formatMoney(num.parse(g), 'EUR', l10n.localeName)}',
    _ => '',
  };
  return '${t.name} · ${formatBytes(t.size, l10n.localeName)}$price';
}

/// One snapshot of a box: edit, rollback, delete (STB-014 to STB-016,
/// STB-035, STB-036).
class BoxSnapshotPage extends ConsumerWidget {
  const new({
    required this.scope,
    required this.boxId,
    required this.snapshotId,
    super.key,
  });

  final ProjectScope scope;
  final int boxId;
  final int snapshotId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = boxSnapshotProvider(scope, boxId, snapshotId);
    final async = ref.watch(provider);
    final s = async.value;
    if (s == null) {
      return DetailLoading(
        title: l10n.resourceBoxSnapshot,
        error: async.error,
        onRetry: () => ref.invalidate(provider),
      );
    }
    final t = (scope: scope, type: storageBoxType, id: boxId, name: s.name);
    final locale = l10n.localeName;
    return FalcoScaffold(
      title: l10n.resourceBoxSnapshot,
      body: DetailPage(
        name: s.name,
        ids: [formatDateTime(s.created, locale)],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          DetailAction(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            onTap: () => FormSheet.show(
              context,
              title: l10n.commonEdit,
              fields: (_) => [
                FieldSpec(
                  'description',
                  l10n.fieldDescription,
                  initial: s.description,
                ),
                labelsField(l10n, s.labels),
              ],
              valid: validLabels,
              onSave: (v) async {
                await updateBoxSnapshot(
                  ref.read(storageBoxApiProvider(scope.projectId)),
                  boxId,
                  s.id,
                  description: (v['description'] ?? '').trim(),
                  labels: parseLabels(v['labels'] ?? '')!,
                );
                ref
                  ..invalidate(provider)
                  ..invalidate(boxSnapshotsProvider(scope, boxId));
              },
            ),
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionOverview,
            child: FactRows([
              ConfirmFact(l10n.fieldName, s.name, mono: true),
              ConfirmFact(
                l10n.fieldDescription,
                s.description.isEmpty ? l10n.commonNone : s.description,
              ),
              ConfirmFact(l10n.fieldSize, formatBytes(s.size, locale)),
              ConfirmFact(l10n.boxAutomatic, yesNo(s.automatic, l10n)),
              ConfirmFact(l10n.fieldCreated, formatDateTime(s.created, locale)),
              ConfirmFact(l10n.fieldLabels, labelsText(s.labels, l10n)),
            ]),
          ),
        ],
        dangerZone: [
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: FalcoColors.of(context).error,
            ),
            icon: const Icon(Icons.restore),
            label: Text(l10n.boxRollback),
            onPressed: () async {
              final ok = await ConfirmSheet.show(
                context,
                title: l10n.boxRollbackTitle(s.name),
                consequence: l10n.boxRollbackConsequence,
                confirmLabel: l10n.boxRollback,
                resourceName: s.name,
                level: ConfirmLevel.typeName,
                destructive: true,
              );
              if (ok && context.mounted) {
                await runBoxAction(
                  context,
                  ref,
                  scope,
                  (api) => rollbackBox(api, boxId, s.name),
                );
              }
            },
          ),
          DeleteButton(
            onPressed: () async {
              if (!await confirmDelete(
                    context,
                    t,
                    l10n.boxSnapshotDeleteConsequence,
                  ) ||
                  !context.mounted) {
                return;
              }
              if (await runBoxAction(
                    context,
                    ref,
                    scope,
                    (api) => deleteBoxSnapshot(api, boxId, s.id),
                  ) &&
                  context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

/// One subaccount: edit, home, access, password, delete (STB-019 to
/// STB-021, STB-032 to STB-034).
class SubaccountPage extends ConsumerWidget {
  const new({
    required this.scope,
    required this.boxId,
    required this.subaccountId,
    super.key,
  });

  final ProjectScope scope;
  final int boxId;
  final int subaccountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = subaccountProvider(scope, boxId, subaccountId);
    final async = ref.watch(provider);
    final s = async.value;
    if (s == null) {
      return DetailLoading(
        title: l10n.resourceSubaccount,
        error: async.error,
        onRetry: () => ref.invalidate(provider),
      );
    }
    final t = (scope: scope, type: storageBoxType, id: boxId, name: s.username);
    final progress = ref
        .watch(trackedActionProvider(scope, storageBoxType, boxId))
        .value;
    final busy = progress != null && !progress.done;
    Future<void> save(Future<int> Function(box.Server api) start) =>
        startBoxTracked(ref, scope, start);
    return FalcoScaffold(
      title: l10n.resourceSubaccount,
      body: DetailPage(
        status: busy ? ResourceStatus.inProgress : null,
        name: s.name.isEmpty ? s.username : s.name,
        ids: [s.username, s.server],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          DetailAction(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            onTap: () => FormSheet.show(
              context,
              title: l10n.commonEdit,
              fields: (_) => [
                FieldSpec('name', l10n.fieldNameOptional, initial: s.name),
                FieldSpec(
                  'description',
                  l10n.fieldDescription,
                  initial: s.description,
                ),
                labelsField(l10n, s.labels),
              ],
              valid: validLabels,
              onSave: (v) async {
                await updateSubaccount(
                  ref.read(storageBoxApiProvider(scope.projectId)),
                  boxId,
                  s.id,
                  name: (v['name'] ?? '').trim(),
                  description: (v['description'] ?? '').trim(),
                  labels: parseLabels(v['labels'] ?? '')!,
                );
                ref
                  ..invalidate(provider)
                  ..invalidate(subaccountsProvider(scope, boxId));
              },
            ),
          ),
          DetailAction(
            icon: Icons.folder_outlined,
            label: l10n.fieldHomeDirectory,
            onTap: busy
                ? null
                : () async {
                    final folders = await ref
                        .read(boxFoldersProvider(scope, boxId).future)
                        .catchError((Object _) => const <String>[]);
                    if (!context.mounted) return;
                    await FormSheet.show(
                      context,
                      title: l10n.fieldHomeDirectory,
                      fields: (v) => homeFields(l10n, folders, v, s.home),
                      valid: (v) =>
                          homeFrom(v).isNotEmpty && homeFrom(v) != s.home,
                      onSave: (v) => save(
                        (api) =>
                            changeSubaccountHome(api, boxId, s.id, homeFrom(v)),
                      ),
                    );
                  },
          ),
          DetailAction(
            icon: Icons.tune,
            label: l10n.boxAccessSettings,
            onTap: busy
                ? null
                : () => FormSheet.show(
                    context,
                    title: l10n.boxAccessSettings,
                    fields: (_) =>
                        accessFields(l10n, subaccountAccessKeys, s.access),
                    valid: (_) => true,
                    onSave: (v) => save(
                      (api) => updateSubaccountAccess(
                        api,
                        boxId,
                        s.id,
                        accessFrom(v, subaccountAccessKeys),
                      ),
                    ),
                  ),
          ),
          DetailAction(
            icon: Icons.password,
            label: l10n.boxResetPassword,
            onTap: busy
                ? null
                : () => FormSheet.show(
                    context,
                    title: l10n.boxResetPassword,
                    fields: (_) => passwordFields(l10n),
                    valid: validPasswords,
                    onSave: (v) => save(
                      (api) => resetSubaccountPassword(
                        api,
                        boxId,
                        s.id,
                        v['password']!,
                      ),
                    ),
                  ),
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionOverview,
            child: FactRows([
              ConfirmFact(l10n.fieldUsername, s.username, mono: true),
              ConfirmFact(l10n.fieldServer, s.server, mono: true),
              ConfirmFact(l10n.fieldHomeDirectory, s.home, mono: true),
              ConfirmFact(
                l10n.fieldDescription,
                s.description.isEmpty ? l10n.commonNone : s.description,
              ),
              ConfirmFact(
                l10n.fieldCreated,
                formatDateTime(s.created, l10n.localeName),
              ),
              ConfirmFact(l10n.fieldLabels, labelsText(s.labels, l10n)),
            ]),
          ),
          DetailSection(
            title: l10n.boxAccessSettings,
            child: FactRows(accessFacts(s.access, l10n)),
          ),
        ],
        dangerZone: [
          DeleteButton(
            onPressed: () async {
              if (!await confirmDelete(
                    context,
                    t,
                    l10n.subaccountDeleteConsequence,
                  ) ||
                  !context.mounted) {
                return;
              }
              if (await runBoxAction(
                    context,
                    ref,
                    scope,
                    (api) => deleteSubaccount(api, boxId, s.id),
                  ) &&
                  context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Create a Storage Box: location, type with price, access data
/// (STB-002 to STB-004).
class CreateStorageBoxPage extends ConsumerStatefulWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  ConsumerState<CreateStorageBoxPage> createState() =>
      _CreateStorageBoxPageState();
}

class _CreateStorageBoxPageState extends ConsumerState<CreateStorageBoxPage> {
  String? _project;
  String _location = '';
  String _type = '';
  var _values = <String, String>{};
  bool _creating = false;

  Future<void> _create(ProjectScope scope) async {
    if (_creating) return;
    setState(() => _creating = true);
    final container = ProviderScope.containerOf(context, listen: false);
    final ok = await runBoxAction(
      context,
      ref,
      scope,
      (api) => createStorageBox(
        api,
        name: _values['name']!.trim(),
        location: _location,
        type: _type,
        password: _values['password']!,
        access: accessFrom(_values, boxAccessKeys),
        labels: parseLabels(_values['labels'] ?? '') ?? const {},
      ),
    );
    container.invalidate(storageBoxesProvider);
    if (!mounted) return;
    setState(() => _creating = false);
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = targetScope(widget.scope, _project);
    final types = scope == null
        ? const <BoxType>[]
        : ref.watch(boxTypesProvider(scope)).value ?? const <BoxType>[];
    final locations = {for (final t in types) ...t.monthlyGross.keys}.toList()
      ..sort();
    final offered = [
      for (final t in types)
        if (t.monthlyGross.containsKey(_location)) t,
    ];
    final details = [
      FieldSpec('name', l10n.fieldName, maxLength: 63),
      ...passwordFields(l10n),
      ...accessFields(l10n, boxAccessKeys, const {'ssh_enabled': true}),
      labelsField(l10n),
    ];
    final type = offered.where((t) => t.name == _type).firstOrNull;
    return CreateWizard(
      title: l10n.storageBoxCreate,
      creating: _creating,
      onCreate: scope == null ? null : () => _create(scope),
      projectStep: projectStep(
        ref,
        l10n,
        widget.scope,
        _project,
        (p) => setState(() {
          _project = p;
          _location = '';
          _type = '';
        }),
      ),
      steps: [
        WizardStep(
          title: l10n.fieldLocation,
          canContinue: locations.contains(_location),
          child: ChoiceList(
            options: {for (final l in locations) l: l},
            selected: _location,
            onSelected: (v) => setState(() {
              _location = v;
              _type = '';
            }),
          ),
        ),
        WizardStep(
          title: l10n.fieldType,
          canContinue: type != null,
          child: ChoiceList(
            options: {
              for (final t in offered) t.name: typeText(t, _location, l10n),
            },
            details: {for (final t in offered) t.name: t.description},
            selected: _type,
            onSelected: (v) => setState(() => _type = v),
          ),
        ),
        WizardStep(
          title: l10n.wizardDetails,
          canContinue:
              (_values['name'] ?? '').trim().isNotEmpty &&
              validPasswords(_values) &&
              validLabels(_values),
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
        if (type != null)
          ConfirmFact(l10n.fieldType, typeText(type, _location, l10n)),
        ...accessFacts(accessFrom(_values, boxAccessKeys), l10n),
      ]),
    );
  }
}
