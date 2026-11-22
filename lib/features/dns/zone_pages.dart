// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert' show utf8;

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/actions/action_tracker.dart';
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
      : (m.group(1)!, int.tryParse(m.group(2)!));
  if (port == null || port < 1 || port > 65535 || address.contains(' ')) {
    return null;
  }
  return (address: address, port: port, tsigKey: null, tsigAlgorithm: null);
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
        ? ref.watch(accountsProvider.select((a) => a.value))
        : null;
    return ResourceList<Zone>(
      title: l10n.resourceZones,
      items: async.value,
      loading: async.isLoading,
      error: async.hasError
          ? errorText(toFalcoError(async.error!), l10n)
          : null,
      onRefresh: () => refreshQuietly(ref, provider.future),
      empty: EmptyHint(message: l10n.emptyZones),
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
        onTap: () => openDetail(
          context,
          ZoneRoute(
            accountId: scope.accountId,
            projectId: z.projectId,
            zoneId: z.id,
          ),
        ),
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
      final api = ref.read(cloudApiProvider(scope.projectId));
      final tracker = ref.read(actionTrackerProvider(scope));
      final id = await (known == null
          ? createRrset(api, zone.id, set)
          : changeRrset(api, zone.id, known, AddRecords(set.records)));
      tracker.track(id);
      if (known == null) return;
      final relabel = set.labels.isNotEmpty;
      final retime = set.ttl != null && set.ttl != known.ttl;
      if (!relabel && !retime) return;
      // A failed add must not close the form as saved, nor change more.
      final added = await tracker.track(id).last;
      if (added.status != ActionStatus.success) {
        throw ActionFailed(code: added.errorCode);
      }
      if (relabel) {
        // Labels are no action; added ones join those the RRSet has now,
        // as the PUT replaces them all.
        final now = await getRrset(api, zone.id, known.name, known.type);
        final labels = {...now.labels, ...set.labels};
        if (labels.toString() != now.labels.toString()) {
          await updateRrset(api, zone.id, known, labels);
        }
      }
      if (retime) {
        tracker.track(
          await changeRrset(api, zone.id, known, ChangeRRSetTtl(set.ttl)),
        );
      }
    },
  );
}

/// Follows zone action [id] to its end; false when it failed. A zone
/// runs one action at a time, so the next one starts after this.
Future<bool> _ended(ActionTracker tracker, int id) async =>
    (await tracker.track(id).last).status == ActionStatus.success;

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
      FalcoScaffold.showSnack(
        context,
        picked.tooLarge ? l10n.zonefileTooLarge : l10n.fileNotText,
      );
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
        ConfirmFact(
          l10n.fieldSize,
          formatBytes(utf8.encode(text).length, l10n.localeName),
        ),
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
      // A secondary zone has no TTL of its own; only labels change.
      fields: (_) => [
        if (!z.secondary)
          FieldSpec(
            'ttl',
            l10n.fieldDefaultTtl,
            initial: '${z.ttl}',
            helper: l10n.ttlLimits,
          ),
        labelsField(l10n, z.labels),
      ],
      valid: (v) =>
          (z.secondary || validTtl(v['ttl'], optional: false)) &&
          validLabels(v),
      onSave: (v) async {
        final ttl = z.secondary ? z.ttl : int.parse(v['ttl']!.trim());
        final labels = parseLabels(v['labels'] ?? '')!;
        final api = ref.read(cloudApiProvider(_scope.projectId));
        final tracker = ref.read(actionTrackerProvider(_scope));
        final container = ProviderScope.containerOf(context, listen: false);
        if (ttl != z.ttl) {
          tracker.track(await changeZone(api, z.id, ChangeZoneTtl(ttl)));
        }
        if (labels.toString() != z.labels.toString()) {
          await updateZone(api, z.id, labels);
        }
        refreshResource(container.invalidate, _scope, CloudType.zone, z.id);
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
        FieldSpec(
          'tsig_algorithm',
          l10n.fieldTsigAlgorithm,
          initial: current?.tsigAlgorithm ?? '',
          options: {'': l10n.tsigNone, for (final a in tsigAlgorithms) a: a},
        ),
        FieldSpec(
          'tsig_key',
          l10n.fieldTsigKey,
          secret: true,
          helper: current?.tsigKey == null ? null : l10n.keepIfEmpty,
        ),
      ],
      valid: (v) =>
          (v['address'] ?? '').trim().isNotEmpty &&
          validNameserverPort(v['port']) &&
          ((v['tsig_algorithm'] ?? '').isEmpty ||
              (v['tsig_key'] ?? '').trim().isNotEmpty ||
              current?.tsigKey != null),
      onSave: (v) {
        final algorithm = v['tsig_algorithm'] ?? '';
        final key = (v['tsig_key'] ?? '').trim();
        final next = (
          address: v['address']!.trim(),
          port: int.parse(v['port']!.trim()),
          tsigAlgorithm: algorithm.isEmpty ? null : algorithm,
          tsigKey: algorithm.isEmpty
              ? null
              : (key.isEmpty ? current?.tsigKey : key),
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
  /// (DNS-013); a new value only when all share one type. Confirms with
  /// the affected RRSets, then reports success or the number that failed
  /// (DNS-014).
  Future<void> _bulkEdit(Zone z, List<RRSet> sets) async {
    final l10n = AppLocalizations.of(context);
    final oneType = sets.map((s) => s.type).toSet().length == 1;
    Map<String, String>? input;
    await FormSheet.show(
      context,
      title: l10n.recordsBulkEdit(sets.length),
      fields: (_) => [
        if (oneType)
          FieldSpec('value', l10n.fieldNewValue, helper: l10n.keepIfEmpty),
        FieldSpec(
          'ttl',
          l10n.fieldTtl,
          helper: oneType ? l10n.keepIfEmpty : l10n.recordsBulkTtlOnly,
        ),
      ],
      valid: (v) =>
          ((v['value'] ?? '').trim().isNotEmpty ||
              (v['ttl'] ?? '').trim().isNotEmpty) &&
          validTtl(v['ttl']),
      onSave: (v) async => input = v,
    );
    final v = input;
    if (v == null || !mounted) return;
    final value = (v['value'] ?? '').trim();
    final ttl = int.tryParse(v['ttl']?.trim() ?? '');
    final ok = await ConfirmSheet.show(
      context,
      title: l10n.recordsBulkEdit(sets.length),
      consequence: value.isEmpty
          ? l10n.recordsBulkTtlConsequence
          : l10n.recordsBulkValueConsequence,
      confirmLabel: l10n.commonSave,
      resourceName: z.name,
      facts: [
        ConfirmFact(
          l10n.sectionRecords,
          sets.map((s) => '${s.name} ${s.type}').join('\n'),
          mono: true,
        ),
        if (value.isNotEmpty) ConfirmFact(l10n.fieldNewValue, value),
        if (ttl != null) ConfirmFact(l10n.fieldTtl, l10n.ttlValue(ttl)),
      ],
      destructive: value.isNotEmpty,
    );
    if (!ok || !mounted) return;
    final api = ref.read(cloudApiProvider(_scope.projectId));
    final tracker = ref.read(actionTrackerProvider(_scope));
    final container = ProviderScope.containerOf(context, listen: false);
    Future<bool> run(Future<int> start) async =>
        await _ended(tracker, await start);
    var failed = 0;
    for (final set in sets) {
      try {
        final records = [
          (value: normalizeRecord(set.type, value), comment: ''),
        ];
        if ((value.isNotEmpty &&
                !await run(changeRrset(api, z.id, set, SetRecords(records)))) ||
            (ttl != null &&
                !await run(changeRrset(api, z.id, set, ChangeRRSetTtl(ttl))))) {
          failed++;
        }
      } on FalcoError {
        failed++;
      }
    }
    refreshResource(container.invalidate, _scope, CloudType.zone, z.id);
    if (!mounted) return;
    setState(() => _selected = null);
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
    final setsProvider = rrsetsProvider(_scope, z.id);
    // A secondary zone's records come from its primaries (AXFR).
    final setsAsync = z.secondary
        ? const AsyncData(<RRSet>[])
        : ref.watch(setsProvider);
    final sets = setsAsync.value ?? const <RRSet>[];
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
      body: DetailPage(
        status: busy ? ResourceStatus.inProgress : z.resourceStatus,
        statusDetail: busy
            ? '${progress.progress} %'
            : (z.protectDelete ? l10n.protected : null),
        name: z.name,
        ids: [
          for (final ns in z.nameservers)
            DetailId(ns, icon: Icons.dns_outlined, copy: true),
        ],
        facts: [
          Fact(
            l10n.fieldMode,
            text: z.secondary ? l10n.zoneSecondary : l10n.zonePrimary,
          ),
          Fact(l10n.fieldDefaultTtl, text: '${z.ttl} s', mono: true),
          Fact(l10n.sectionRecords, text: '${z.recordCount}'),
          Fact(l10n.fieldDeleteProtection, on: z.protectDelete),
          Fact(l10n.fieldCreated, time: z.created),
        ],
        onRefresh: () => Future.wait([
          refreshQuietly(ref, provider.future),
          if (!z.secondary) refreshQuietly(ref, setsProvider.future),
        ]),
        actions: [
          DetailAction(
            icon: Icons.add,
            label: l10n.recordAdd,
            group: ActionGroup.manage,
            // Create or add needs the loaded RRSets (DNS-007).
            onTap: busy || z.secondary || !setsAsync.hasValue
                ? null
                : () => showRecordSheet(context, ref, _scope, z, sets),
          ),
          DetailAction(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            group: ActionGroup.manage,
            onTap: busy ? null : () => _edit(z),
          ),
          DetailAction(
            icon: z.protectDelete ? Icons.lock : Icons.lock_open,
            label: l10n.fieldProtection,
            group: ActionGroup.manage,
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
          if (!z.secondary) ...[
            DetailAction(
              icon: Icons.download,
              label: l10n.zoneExport,
              group: ActionGroup.backup,
              onTap: () => _export(z),
            ),
            DetailAction(
              label: l10n.recordsSelect,
              icon: Icons.checklist,
              group: ActionGroup.manage,
              onTap: () => setState(() => _selected = {}),
            ),
            DetailAction(
              label: l10n.zoneImport,
              icon: Icons.upload_file,
              group: ActionGroup.backup,
              onTap: () => _import(z),
            ),
          ],
          if (z.secondary)
            DetailAction(
              label: l10n.primaryAdd,
              icon: Icons.add,
              group: ActionGroup.manage,
              onTap: () => _primary(z),
            ),
        ],
        sections: [
          if (z.secondary)
            DetailSection(
              title: l10n.sectionPrimaries,
              child: entries([
                for (final p in z.primaries)
                  EntryRow(
                    title: _ns(p),
                    subtitle: p.tsigAlgorithm,
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
                          () => _selected = {
                            for (final s in sets)
                              if (bulkSelectable(s)) s.key,
                          },
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
                if (setsAsync.hasError && setsAsync.hasValue)
                  ErrorBanner(
                    message: errorText(toFalcoError(setsAsync.error!), l10n),
                    onRetry: () => ref.invalidate(setsProvider),
                  )
                else if (setsAsync.hasError)
                  ErrorCard(
                    message: errorText(toFalcoError(setsAsync.error!), l10n),
                    onRetry: () => ref.invalidate(setsProvider),
                  )
                else if (!setsAsync.hasValue)
                  const LinearProgressIndicator()
                else if (z.secondary)
                  Text(l10n.recordsFromPrimaries)
                else if (sets.isEmpty)
                  Text(l10n.recordsEmpty),
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
          labelsSection(l10n, z.labels),
          detailsSection(l10n, id: z.id),
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

/// Whether "Select all" takes [s]: not the SOA and not the apex NS,
/// which Hetzner manages (DNS-012).
bool bulkSelectable(RRSet s) =>
    s.type != 'SOA' && !(s.type == 'NS' && s.name == '@');

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
        ids: [
          if (zone case final z?)
            DetailId(z.name, icon: Icons.language, copy: true),
        ],
        facts: [
          Fact(l10n.fieldRecordName, text: s.name, mono: true),
          Fact(l10n.fieldType, text: s.type, mono: true),
          Fact(
            l10n.fieldTtl,
            text: s.ttl == null
                ? l10n.ttlDefault(zone?.ttl ?? 3600)
                : l10n.ttlValue(s.ttl!),
          ),
          Fact(l10n.fieldChangeProtection, on: s.protectChange),
        ],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          DetailAction(
            icon: Icons.add,
            label: l10n.valueAdd,
            group: ActionGroup.manage,
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
          DetailAction(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            group: ActionGroup.manage,
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
                      final api = ref.read(cloudApiProvider(scope.projectId));
                      final container = ProviderScope.containerOf(
                        context,
                        listen: false,
                      );
                      if (ttl != s.ttl) await change(ChangeRRSetTtl(ttl));
                      if (labels.toString() != s.labels.toString()) {
                        await updateRrset(api, zoneId, s, labels);
                      }
                      refreshResource(
                        container.invalidate,
                        scope,
                        CloudType.zone,
                        zoneId,
                      );
                    },
                  ),
          ),
          DetailAction(
            icon: s.protectChange ? Icons.lock : Icons.lock_open,
            label: l10n.fieldProtection,
            group: ActionGroup.manage,
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
          labelsSection(l10n, s.labels),
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
    final tracker = ref.read(actionTrackerProvider(scope));
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
        tracker.track(r.action);
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
