// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/files/text_files.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/activity/activity_page.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/dns/zones.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Largest zone file to import (DNS-015).
const int maxZonefileBytes = 1024 * 1024;

/// Parses `address`, `address:port` or `[ipv6]:port`; port 53 by default
/// (DNS-018).
Nameserver? parseNameserver(String text) {
  final t = text.trim();
  if (t.isEmpty) return null;
  final m =
      RegExp(r'^\[(.+)\]:(\d+)$').firstMatch(t) ??
      RegExp(r'^([^:\s]+):(\d+)$').firstMatch(t);
  final (address, port) = m == null
      ? (t, 53)
      : (m.group(1)!, int.parse(m.group(2)!));
  if (port < 1 || port > 65535 || address.contains(' ')) return null;
  return (address: address, port: port);
}

/// Nameservers of [text], one per line or comma separated; null when one
/// is invalid.
List<Nameserver>? parseNameservers(String text) {
  final out = <Nameserver>[];
  for (final part in text.split(RegExp(r'[\n,]+'))) {
    if (part.trim().isEmpty) continue;
    final n = parseNameserver(part);
    if (n == null) return null;
    out.add(n);
  }
  return out;
}

String _ns(Nameserver n) => n.address.contains(':')
    ? '[${n.address}]:${n.port}'
    : '${n.address}:${n.port}';

/// Record values of [text], one per line, normalized for [type]
/// (DNS-009).
List<DnsRecord> recordsOf(String type, String text) => [
  for (final line in text.split('\n'))
    if (line.trim().isNotEmpty)
      (value: normalizeRecord(type, line), comment: ''),
];

/// DNS zones of a scope: name, records, TTL, status (DNS-001).
class ZoneList extends ConsumerWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = zonesProvider(scope);
    final async = ref.watch(provider);
    final accounts = scope is AllProjectsScope
        ? ref.watch(accountsProvider).value
        : null;
    return ResourceList<Zone>(
      title: l10n.resourceZones,
      items: async.value,
      loading: async.isLoading,
      error: async.hasError
          ? errorText(toFalcoError(async.error!), l10n)
          : null,
      onRefresh: () => refreshQuietly(ref, provider.future),
      empty: EmptyHint(
        message: l10n.emptyZones,
        actionLabel: l10n.zoneCreate,
        onAction: () =>
            CreateRoute.of(scope, CreateKind.zone).push<void>(context),
      ),
      searchText: (z) => z.name,
      sorts: [ResourceSort(l10n.sortName, (a, b) => a.name.compareTo(b.name))],
      itemBuilder: (context, z) => ResourceRow(
        status: z.resourceStatus,
        name: z.name,
        monoLine: [
          l10n.recordCount(z.recordCount),
          l10n.ttlValue(z.ttl),
          if (z.secondary) l10n.zoneSecondary,
          if (accounts != null) projectName(accounts, z.projectId),
        ].join(' · '),
        onTap: () => ZoneRoute(
          accountId: scope.accountId,
          projectId: z.projectId,
          zoneId: z.id,
        ).push<void>(context),
      ),
    );
  }
}

/// The RRSet sheet: name, type, TTL, values one per line, labels
/// (DNS-007, DNS-008, DNS-026). A name and type that exist get the values
/// added instead.
Future<bool> showRecordSheet(
  BuildContext context,
  WidgetRef ref,
  ProjectScope scope,
  Zone zone,
  List<RRSet> existing,
) {
  final l10n = AppLocalizations.of(context);
  return FormSheet.show(
    context,
    title: l10n.recordAdd,
    fields: (_) => [
      FieldSpec(
        'name',
        l10n.fieldRecordName,
        initial: '@',
        helper: l10n.recordNameHint,
      ),
      FieldSpec(
        'type',
        l10n.fieldType,
        initial: 'A',
        options: {for (final t in rrTypes) t: t},
      ),
      FieldSpec('ttl', l10n.fieldTtl, helper: l10n.ttlHint(zone.ttl)),
      FieldSpec(
        'values',
        l10n.fieldValues,
        multiline: true,
        helper: l10n.valuesHint,
      ),
      labelsField(l10n),
    ],
    valid: (v) =>
        (v['name'] ?? '').trim().isNotEmpty &&
        recordsOf(v['type'] ?? 'A', v['values'] ?? '').isNotEmpty &&
        validTtl(v['ttl']) &&
        validLabels(v),
    onSave: (v) async {
      final type = v['type'] ?? 'A';
      final set = RRSet(
        name: v['name']!.trim(),
        type: type,
        ttl: int.tryParse(v['ttl']?.trim() ?? ''),
        records: recordsOf(type, v['values']!),
        labels: parseLabels(v['labels'] ?? '') ?? const {},
      );
      final known = existing.where((e) => e.key == set.key).firstOrNull;
      await startTracked(
        ref,
        scope,
        (api) => known == null
            ? createRrset(api, zone.id, set)
            : changeRrset(api, zone.id, known, AddRecords(set.records)),
      );
      if (known != null && set.ttl != null && set.ttl != known.ttl) {
        await startTracked(
          ref,
          scope,
          (api) => changeRrset(api, zone.id, known, ChangeRRSetTtl(set.ttl)),
        );
      }
    },
  );
}

/// One zone: records with multi selection and bulk edit, primary
/// nameservers, import and export, edit, protection, delete (DNS-003 to
/// DNS-006, DNS-012 to DNS-020, DNS-024, DNS-025).
class ZoneDetailPage extends ConsumerStatefulWidget {
  const new({required this.scope, required this.zoneId, super.key});

  final ProjectScope scope;
  final int zoneId;

  @override
  ConsumerState<ZoneDetailPage> createState() => _ZoneDetailPageState();
}

class _ZoneDetailPageState extends ConsumerState<ZoneDetailPage> {
  /// Keys of selected RRSets; null when not selecting (DNS-012).
  Set<String>? _selected;

  ProjectScope get _scope => widget.scope;

  Future<void> _export(Zone z) async {
    final l10n = AppLocalizations.of(context);
    try {
      final text = await exportZonefile(
        ref.read(cloudApiProvider(_scope.projectId)),
        z.id,
      );
      final saved = await ref
          .read(textFilesProvider)
          .save('${z.name}.zone', text);
      if (saved && mounted) {
        FalcoScaffold.showSnack(context, l10n.zoneExported);
      }
    } on FalcoError catch (e) {
      if (mounted) FalcoScaffold.showSnack(context, errorText(e, l10n));
    }
  }

  Future<void> _import(Zone z) async {
    final l10n = AppLocalizations.of(context);
    final picked = await ref
        .read(textFilesProvider)
        .pick(maxBytes: maxZonefileBytes);
    if (picked == null || !mounted) return;
    final text = picked.text;
    if (text == null) {
      FalcoScaffold.showSnack(context, l10n.zonefileTooLarge);
      return;
    }
    // Replacing every record is destructive: level 2 (DNS-015, BUG-002).
    final ok = await ConfirmSheet.show(
      context,
      title: l10n.zoneImportTitle(z.name),
      consequence: l10n.zoneImportConsequence,
      confirmLabel: l10n.zoneImport,
      resourceName: z.name,
      level: ConfirmLevel.typeName,
      destructive: true,
      facts: [
        ConfirmFact(l10n.fieldSize, formatBytes(text.length, l10n.localeName)),
      ],
    );
    if (ok && mounted) {
      await runAction(
        context,
        ref,
        _scope,
        (api) => changeZone(api, z.id, ImportZonefile(text)),
      );
    }
  }

  Future<void> _edit(Zone z) {
    final l10n = AppLocalizations.of(context);
    return FormSheet.show(
      context,
      title: l10n.commonEdit,
      fields: (_) => [
        FieldSpec(
          'ttl',
          l10n.fieldDefaultTtl,
          initial: '${z.ttl}',
          helper: l10n.ttlLimits,
        ),
        labelsField(l10n, z.labels),
      ],
      valid: (v) => validTtl(v['ttl'], optional: false) && validLabels(v),
      onSave: (v) async {
        final ttl = int.parse(v['ttl']!.trim());
        final labels = parseLabels(v['labels'] ?? '')!;
        if (ttl != z.ttl) {
          await startTracked(
            ref,
            _scope,
            (api) => changeZone(api, z.id, ChangeZoneTtl(ttl)),
          );
        }
        if (labels.toString() != z.labels.toString()) {
          await updateZone(
            ref.read(cloudApiProvider(_scope.projectId)),
            z.id,
            labels,
          );
        }
        refreshResource(ref.invalidate, _scope, CloudType.zone, z.id);
      },
    );
  }

  Future<void> _primary(Zone z, [Nameserver? current]) {
    final l10n = AppLocalizations.of(context);
    return FormSheet.show(
      context,
      title: current == null ? l10n.primaryAdd : l10n.primaryEdit,
      fields: (_) => [
        FieldSpec(
          'address',
          l10n.fieldAddress,
          initial: current?.address ?? '',
        ),
        FieldSpec('port', l10n.fieldPort, initial: '${current?.port ?? 53}'),
      ],
      valid: (v) =>
          (v['address'] ?? '').trim().isNotEmpty &&
          validNameserverPort(v['port']),
      onSave: (v) {
        final next = (
          address: v['address']!.trim(),
          port: int.parse(v['port']!.trim()),
        );
        return startTracked(
          ref,
          _scope,
          (api) => changeZone(
            api,
            z.id,
            SetPrimaries([
              for (final p in z.primaries)
                if (p == current) next else p,
              if (current == null) next,
            ]),
          ),
        );
      },
    );
  }

  /// Bulk edit of the selection: a new value and/or TTL, empty keeps
  /// (DNS-013); reports success or the number that failed (DNS-014).
  Future<void> _bulkEdit(Zone z, List<RRSet> sets) async {
    final l10n = AppLocalizations.of(context);
    Map<String, String>? input;
    await FormSheet.show(
      context,
      title: l10n.recordsBulkEdit(sets.length),
      fields: (_) => [
        FieldSpec('value', l10n.fieldNewValue, helper: l10n.keepIfEmpty),
        FieldSpec('ttl', l10n.fieldTtl, helper: l10n.keepIfEmpty),
      ],
      valid: (v) =>
          ((v['value'] ?? '').trim().isNotEmpty ||
              (v['ttl'] ?? '').trim().isNotEmpty) &&
          validTtl(v['ttl']),
      onSave: (v) async => input = v,
    );
    final v = input;
    if (v == null || !mounted) return;
    final api = ref.read(cloudApiProvider(_scope.projectId));
    final tracker = ref.read(actionTrackerProvider(_scope));
    final value = (v['value'] ?? '').trim();
    final ttl = int.tryParse(v['ttl']?.trim() ?? '');
    var failed = 0;
    for (final set in sets) {
      try {
        if (value.isNotEmpty) {
          tracker.track(
            await changeRrset(
              api,
              z.id,
              set,
              SetRecords([
                (value: normalizeRecord(set.type, value), comment: ''),
              ]),
            ),
          );
        }
        if (ttl != null) {
          tracker.track(await changeRrset(api, z.id, set, ChangeRRSetTtl(ttl)));
        }
      } on FalcoError {
        failed++;
      }
    }
    if (!mounted) return;
    setState(() => _selected = null);
    refreshResource(ref.invalidate, _scope, CloudType.zone, z.id);
    FalcoScaffold.showSnack(
      context,
      failed == 0 ? l10n.recordsUpdated : l10n.recordsFailed(failed),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = zoneProvider(_scope, widget.zoneId);
    final async = ref.watch(provider);
    final z = async.value;
    if (z == null) {
      return DetailLoading(
        title: l10n.resourceZone,
        error: async.error,
        onRetry: () => ref.invalidate(provider),
      );
    }
    final t = (scope: _scope, type: CloudType.zone, id: z.id, name: z.name);
    final sets = ref.watch(rrsetsProvider(_scope, z.id)).value ?? const [];
    final progress = ref
        .watch(trackedActionProvider(_scope, CloudType.zone, z.id))
        .value;
    final busy = progress != null && !progress.done;
    final selected = _selected;
    final picked = [
      for (final s in sets)
        if (selected?.contains(s.key) ?? false) s,
    ];

    return FalcoScaffold(
      title: l10n.resourceZone,
      moreMenu: MoreMenu(
        items: [
          MoreMenuItem(
            label: l10n.recordsSelect,
            icon: Icons.checklist,
            onSelected: () => setState(() => _selected = {}),
          ),
          if (!z.secondary)
            MoreMenuItem(
              label: l10n.zoneImport,
              icon: Icons.upload_file,
              onSelected: () => _import(z),
            ),
          if (z.secondary)
            MoreMenuItem(
              label: l10n.primaryAdd,
              icon: Icons.add,
              onSelected: () => _primary(z),
            ),
        ],
      ),
      body: DetailPage(
        status: busy ? ResourceStatus.inProgress : z.resourceStatus,
        statusDetail: busy
            ? '${progress.progress} %'
            : (z.protectDelete ? l10n.protected : null),
        name: z.name,
        ids: [l10n.ttlValue(z.ttl), ...z.nameservers],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          ActionTile(
            icon: Icons.add,
            label: l10n.recordAdd,
            onTap: busy || z.secondary
                ? null
                : () => showRecordSheet(context, ref, _scope, z, sets),
          ),
          ActionTile(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            onTap: busy ? null : () => _edit(z),
          ),
          ActionTile(
            icon: z.protectDelete ? Icons.lock : Icons.lock_open,
            label: l10n.fieldProtection,
            onTap: busy
                ? null
                : () => toggleProtection(
                    context,
                    ref,
                    t,
                    protected: z.protectDelete,
                    start: (api, p) =>
                        changeZone(api, z.id, ProtectZone(delete: p)),
                  ),
          ),
          ActionTile(
            icon: Icons.download,
            label: l10n.zoneExport,
            onTap: () => _export(z),
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionOverview,
            child: FactRows([
              ConfirmFact(
                l10n.fieldMode,
                z.secondary ? l10n.zoneSecondary : l10n.zonePrimary,
              ),
              ConfirmFact(l10n.fieldDefaultTtl, '${z.ttl} s'),
              ConfirmFact(l10n.fieldStatus, z.resourceStatus.label(l10n)),
              ConfirmFact(l10n.sectionRecords, '${z.recordCount}'),
              if (z.nameservers.isNotEmpty)
                ConfirmFact(
                  l10n.fieldNameservers,
                  z.nameservers.join('\n'),
                  mono: true,
                ),
              ConfirmFact(
                l10n.fieldDeleteProtection,
                yesNo(z.protectDelete, l10n),
              ),
              ConfirmFact(
                l10n.fieldCreated,
                formatDateTime(z.created, l10n.localeName),
              ),
              ConfirmFact(l10n.fieldLabels, labelsText(z.labels, l10n)),
            ]),
          ),
          if (z.secondary)
            DetailSection(
              title: l10n.sectionPrimaries,
              child: entries([
                for (final p in z.primaries)
                  EntryRow(
                    title: _ns(p),
                    onTap: busy ? null : () => _primary(z, p),
                    removeLabel: l10n.actionRemove,
                    onRemove: busy
                        ? null
                        : () => confirmAction(
                            context,
                            ref,
                            _scope,
                            title: l10n.primaryRemoveTitle(_ns(p)),
                            consequence: l10n.primaryRemoveConsequence,
                            label: l10n.actionRemove,
                            name: z.name,
                            start: (api) => changeZone(
                              api,
                              z.id,
                              SetPrimaries([
                                for (final x in z.primaries)
                                  if (x != p) x,
                              ]),
                            ),
                          ),
                  ),
              ], l10n.primariesEmpty),
            ),
          DetailSection(
            title: l10n.sectionRecords,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (selected != null)
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: FalcoSpacing.s,
                    children: [
                      Text(l10n.selectedCount(selected.length)),
                      TextButton(
                        onPressed: () => setState(
                          () => _selected = {for (final s in sets) s.key},
                        ),
                        child: Text(l10n.selectAll),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _selected = null),
                        child: Text(l10n.selectClear),
                      ),
                      FilledButton(
                        onPressed: picked.isEmpty
                            ? null
                            : () => _bulkEdit(z, picked),
                        child: Text(l10n.recordsEditSelected),
                      ),
                    ],
                  ),
                if (sets.isEmpty) Text(l10n.recordsEmpty),
                for (final s in sets)
                  if (selected != null)
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: selected.contains(s.key),
                      title: Text('${s.name} ${s.type}'),
                      subtitle: Mono(
                        s.records.map((r) => r.value).join('\n'),
                        maxLines: 3,
                      ),
                      onChanged: (on) => setState(
                        () => _selected = on ?? false
                            ? {...selected, s.key}
                            : {...selected.where((k) => k != s.key)},
                      ),
                    )
                  else
                    EntryRow(
                      title: '${s.name} ${s.type}',
                      subtitle: [
                        ...s.records.map((r) => r.value),
                        l10n.ttlValue(s.ttl ?? z.ttl),
                      ].join(' · '),
                      onTap: () => RRSetRoute(
                        accountId: _scope.accountId,
                        projectId: _scope.projectId,
                        zoneId: z.id,
                        name: s.name,
                        type: s.type,
                      ).push<void>(context),
                    ),
              ],
            ),
          ),
          activitySection(l10n, _scope, CloudType.zone, z.id),
        ],
        dangerZone: [
          DeleteButton(
            onPressed: busy
                ? null
                : () async {
                    if (!await confirmDelete(
                          context,
                          t,
                          l10n.zoneDeleteConsequence,
                        ) ||
                        !context.mounted) {
                      return;
                    }
                    if (await runAction(
                          context,
                          ref,
                          _scope,
                          (api) => deleteZone(api, z.id),
                        ) &&
                        context.mounted) {
                      ref.invalidate(zonesProvider);
                      Navigator.pop(context);
                    }
                  },
          ),
        ],
      ),
    );
  }
}

/// A nameserver port, 1 to 65535 (DNS-018).
bool validNameserverPort(String? text) {
  final p = int.tryParse(text?.trim() ?? '');
  return p != null && p >= 1 && p <= 65535;
}

/// One RRSet: its values with edit and remove, TTL, labels, protection,
/// delete (DNS-007, DNS-010, DNS-011, DNS-027 to DNS-031).
class RRSetDetailPage extends ConsumerWidget {
  const new({
    required this.scope,
    required this.zoneId,
    required this.name,
    required this.type,
    super.key,
  });

  final ProjectScope scope;
  final int zoneId;
  final String name;
  final String type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = rrsetProvider(scope, zoneId, name, type);
    final async = ref.watch(provider);
    final s = async.value;
    if (s == null) {
      return DetailLoading(
        title: l10n.resourceRecord,
        error: async.error,
        onRetry: () => ref.invalidate(provider),
      );
    }
    final zone = ref.watch(zoneProvider(scope, zoneId)).value;
    final progress = ref
        .watch(trackedActionProvider(scope, CloudType.zone, zoneId))
        .value;
    final busy = progress != null && !progress.done;
    // Changes on an RRSet are actions of its zone.
    Future<void> change(RRSetChange c) =>
        startTracked(ref, scope, (api) => changeRrset(api, zoneId, s, c));
    Future<void> run(RRSetChange c) =>
        runAction(context, ref, scope, (api) => changeRrset(api, zoneId, s, c));
    final locked = busy || s.protectChange;

    Future<void> editValue(DnsRecord r) => FormSheet.show(
      context,
      title: l10n.recordEdit,
      fields: (_) => [
        FieldSpec('value', l10n.fieldValue, initial: r.value),
        FieldSpec('comment', l10n.fieldComment, initial: r.comment),
      ],
      valid: (v) => (v['value'] ?? '').trim().isNotEmpty,
      onSave: (v) {
        final value = normalizeRecord(s.type, v['value']!);
        final comment = (v['comment'] ?? '').trim();
        // Only the comment: update in place (DNS-031); else replace the
        // value within the RRSet (DNS-010).
        return value == r.value
            ? change(UpdateRecords([(value: value, comment: comment)]))
            : change(
                SetRecords([
                  for (final x in s.records)
                    if (x == r) (value: value, comment: comment) else x,
                ]),
              );
      },
    );

    return FalcoScaffold(
      title: l10n.resourceRecord,
      body: DetailPage(
        status: busy ? ResourceStatus.inProgress : ResourceStatus.available,
        statusDetail: busy
            ? '${progress.progress} %'
            : (s.protectChange ? l10n.protected : null),
        name: '${s.name} ${s.type}',
        ids: [?zone?.name, l10n.ttlValue(s.ttl ?? zone?.ttl ?? 3600)],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          ActionTile(
            icon: Icons.add,
            label: l10n.valueAdd,
            onTap: locked
                ? null
                : () => FormSheet.show(
                    context,
                    title: l10n.valueAdd,
                    fields: (_) => [
                      FieldSpec(
                        'values',
                        l10n.fieldValues,
                        multiline: true,
                        helper: l10n.valuesHint,
                      ),
                    ],
                    valid: (v) =>
                        recordsOf(s.type, v['values'] ?? '').isNotEmpty,
                    onSave: (v) =>
                        change(AddRecords(recordsOf(s.type, v['values']!))),
                  ),
          ),
          ActionTile(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            onTap: busy
                ? null
                : () => FormSheet.show(
                    context,
                    title: l10n.commonEdit,
                    fields: (_) => [
                      FieldSpec(
                        'ttl',
                        l10n.fieldTtl,
                        initial: s.ttl == null ? '' : '${s.ttl}',
                        helper: l10n.ttlHint(zone?.ttl ?? 3600),
                      ),
                      labelsField(l10n, s.labels),
                    ],
                    valid: (v) => validTtl(v['ttl']) && validLabels(v),
                    onSave: (v) async {
                      final ttl = int.tryParse(v['ttl']?.trim() ?? '');
                      final labels = parseLabels(v['labels'] ?? '')!;
                      if (ttl != s.ttl) await change(ChangeRRSetTtl(ttl));
                      if (labels.toString() != s.labels.toString()) {
                        await updateRrset(
                          ref.read(cloudApiProvider(scope.projectId)),
                          zoneId,
                          s,
                          labels,
                        );
                      }
                      refreshResource(
                        ref.invalidate,
                        scope,
                        CloudType.zone,
                        zoneId,
                      );
                    },
                  ),
          ),
          ActionTile(
            icon: s.protectChange ? Icons.lock : Icons.lock_open,
            label: l10n.fieldProtection,
            onTap: busy
                ? null
                : () async {
                    final ok = await ConfirmSheet.show(
                      context,
                      title: s.protectChange
                          ? l10n.protectOffTitle(s.key)
                          : l10n.protectOnTitle(s.key),
                      consequence: s.protectChange
                          ? l10n.rrsetProtectOffConsequence
                          : l10n.rrsetProtectOnConsequence,
                      confirmLabel: s.protectChange
                          ? l10n.protectOff
                          : l10n.protectOn,
                      resourceName: s.key,
                    );
                    if (ok && context.mounted) {
                      await run(ProtectRRSet(change: !s.protectChange));
                    }
                  },
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionOverview,
            child: FactRows([
              ConfirmFact(l10n.fieldRecordName, s.name, mono: true),
              ConfirmFact(l10n.fieldType, s.type),
              ConfirmFact(
                l10n.fieldTtl,
                s.ttl == null
                    ? l10n.ttlDefault(zone?.ttl ?? 3600)
                    : l10n.ttlValue(s.ttl!),
              ),
              ConfirmFact(
                l10n.fieldChangeProtection,
                yesNo(s.protectChange, l10n),
              ),
              ConfirmFact(l10n.fieldLabels, labelsText(s.labels, l10n)),
            ]),
          ),
          DetailSection(
            title: l10n.fieldValues,
            child: entries([
              for (final r in s.records)
                EntryRow(
                  title: r.value,
                  subtitle: r.comment,
                  onTap: locked ? null : () => editValue(r),
                  onRemove: locked
                      ? null
                      : () => confirmAction(
                          context,
                          ref,
                          scope,
                          title: l10n.valueRemoveTitle(r.value),
                          consequence: l10n.valueRemoveConsequence,
                          label: l10n.actionDelete,
                          name: s.key,
                          destructive: true,
                          start: (api) =>
                              changeRrset(api, zoneId, s, RemoveRecords([r])),
                        ),
                ),
            ], l10n.recordsEmpty),
          ),
        ],
        dangerZone: [
          DeleteButton(
            onPressed: locked
                ? null
                : () async {
                    final t = (
                      scope: scope,
                      type: CloudType.zone,
                      id: zoneId,
                      name: s.key,
                    );
                    if (!await confirmDelete(
                          context,
                          t,
                          l10n.rrsetDeleteConsequence,
                        ) ||
                        !context.mounted) {
                      return;
                    }
                    if (await runAction(
                          context,
                          ref,
                          scope,
                          (api) => deleteRrset(api, zoneId, s),
                        ) &&
                        context.mounted) {
                      ref.invalidate(rrsetsProvider);
                      Navigator.pop(context);
                    }
                  },
          ),
        ],
      ),
    );
  }
}

/// Create a primary or secondary zone (DNS-002, DNS-022).
class CreateZonePage extends ConsumerStatefulWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  ConsumerState<CreateZonePage> createState() => _CreateZonePageState();
}

class _CreateZonePageState extends ConsumerState<CreateZonePage> {
  String? _project;
  bool _secondary = false;
  var _values = <String, String>{};
  bool _creating = false;

  List<Nameserver>? get _primaries =>
      parseNameservers(_values['primaries'] ?? '');

  Future<void> _create(ProjectScope scope) async {
    if (_creating) return;
    setState(() => _creating = true);
    final l10n = AppLocalizations.of(context);
    final name = _values['name']!.trim();
    final ok = await runChange(
      context,
      ref,
      (scope: scope, type: CloudType.zone, id: 0, name: name),
      (api) async {
        final r = await createZone(
          api,
          name: name,
          secondary: _secondary,
          ttl: int.tryParse(_values['ttl']?.trim() ?? ''),
          primaries: _primaries ?? const [],
          labels: parseLabels(_values['labels'] ?? '') ?? const {},
        );
        ref.read(actionTrackerProvider(scope)).track(r.action);
      },
      done: l10n.createdMessage(name),
    );
    if (!mounted) return;
    setState(() => _creating = false);
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = targetScope(widget.scope, _project);
    final primaries = _primaries;
    return CreateWizard(
      title: l10n.zoneCreate,
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
          title: l10n.fieldMode,
          child: ChoiceList(
            options: {
              'primary': l10n.zonePrimary,
              'secondary': l10n.zoneSecondary,
            },
            details: {
              'primary': l10n.zonePrimaryHint,
              'secondary': l10n.zoneSecondaryHint,
            },
            selected: _secondary ? 'secondary' : 'primary',
            onSelected: (v) => setState(() => _secondary = v == 'secondary'),
          ),
        ),
        WizardStep(
          title: l10n.wizardDetails,
          canContinue:
              (_values['name'] ?? '').trim().isNotEmpty &&
              validTtl(_values['ttl']) &&
              validLabels(_values) &&
              (!_secondary || (primaries != null && primaries.isNotEmpty)),
          child: FormFields(
            fields: [
              FieldSpec('name', l10n.fieldZoneName, helper: 'example.com'),
              FieldSpec(
                'ttl',
                l10n.fieldDefaultTtl,
                helper: l10n.ttlCreateHint,
              ),
              if (_secondary)
                FieldSpec(
                  'primaries',
                  l10n.sectionPrimaries,
                  multiline: true,
                  helper: l10n.primariesHint,
                ),
              labelsField(l10n),
            ],
            values: _values,
            onChanged: (v) => setState(() => _values = {..._values, ...v}),
          ),
        ),
      ],
      summary: FactRows([
        ConfirmFact(l10n.fieldZoneName, (_values['name'] ?? '').trim()),
        ConfirmFact(
          l10n.fieldMode,
          _secondary ? l10n.zoneSecondary : l10n.zonePrimary,
        ),
        ConfirmFact(
          l10n.fieldDefaultTtl,
          l10n.ttlValue(int.tryParse(_values['ttl']?.trim() ?? '') ?? 3600),
        ),
        if (_secondary)
          ConfirmFact(
            l10n.sectionPrimaries,
            [for (final p in primaries ?? const <Nameserver>[]) _ns(p)]
                .join('\n'),
            mono: true,
          ),
      ]),
    );
  }
}
