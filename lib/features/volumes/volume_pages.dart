// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/activity/activity_page.dart';
import 'package:falco/features/compute/catalog.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/features/volumes/volumes.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Volumes of a scope (CMP-050).
class VolumeList extends ConsumerWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = volumesProvider(scope);
    final async = ref.watch(provider);
    final servers = {
      for (final s
          in ref.watch(serversProvider(scope)).value ?? const <CloudServer>[])
        (s.projectId, s.id): s.name,
    };
    final accounts = scope is AllProjectsScope
        ? ref.watch(accountsProvider.select((a) => a.value))
        : null;
    return ResourceList<Volume>(
      title: l10n.resourceVolumes,
      items: async.value,
      loading: async.isLoading,
      error: async.hasError
          ? errorText(toFalcoError(async.error!), l10n)
          : null,
      onRefresh: () => refreshQuietly(ref, provider.future),
      empty: EmptyHint(message: l10n.emptyVolumes),
      searchText: (v) => v.name,
      filters: [
        ResourceFilter(l10n.filterAll, (_) => true),
        ResourceFilter(l10n.filterAttached, (v) => v.server != null),
        ResourceFilter(l10n.filterDetached, (v) => v.server == null),
      ],
      sorts: [
        ResourceSort(l10n.sortName, (a, b) => a.name.compareTo(b.name)),
        ResourceSort(l10n.sortSize, (a, b) => b.sizeGb.compareTo(a.sizeGb)),
      ],
      itemBuilder: (context, v) => ResourceRow(
        status: v.status,
        name: v.name,
        monoLine: [
          gb(v.sizeGb, l10n.localeName),
          v.location,
          switch (v.server) {
            null => l10n.volumeNotAttached,
            final id => servers[(v.projectId, id)] ?? '#$id',
          },
          if (accounts != null) projectName(accounts, v.projectId),
        ].join(' · '),
        onTap: () => openDetail(
          context,
          VolumeRoute(
            accountId: scope.accountId,
            projectId: v.projectId,
            volumeId: v.id,
          ),
        ),
      ),
    );
  }
}

/// One volume: attach or detach, resize, edit, protection, delete
/// (CMP-057 to CMP-064, CMP-088).
class VolumeDetailPage extends ConsumerWidget {
  const new({required this.scope, required this.volumeId, super.key});

  final ProjectScope scope;
  final int volumeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = volumeProvider(scope, volumeId);
    final async = ref.watch(provider);
    final v = async.value;
    if (v == null) {
      return DetailLoading(
        title: l10n.resourceVolume,
        error: async.error,
        onRetry: () => ref.invalidate(provider),
      );
    }
    final t = (scope: scope, type: CloudType.volume, id: v.id, name: v.name);
    final progress = ref
        .watch(trackedActionProvider(scope, CloudType.volume, v.id))
        .value;
    final busy = progress != null && !progress.done;
    final server = v.server == null
        ? null
        : ref
              .watch(serversProvider(scope))
              .value
              ?.where((s) => s.id == v.server)
              .firstOrNull;
    Future<void> protect() async {
      if (await confirmProtection(context, t, protect: !v.protectDelete) &&
          context.mounted) {
        await runAction(
          context,
          ref,
          scope,
          (api) => protectVolume(api, v.id, delete: !v.protectDelete),
        );
      }
    }

    return FalcoScaffold(
      title: l10n.resourceVolume,
      body: DetailPage(
        status: busy ? ResourceStatus.inProgress : v.status,
        statusDetail: busy ? '${progress.progress} %' : null,
        name: v.name,
        ids: [DetailId(v.location, icon: Icons.place_outlined)],
        facts: [
          Fact(l10n.fieldSize, text: gb(v.sizeGb, l10n.localeName)),
          Fact(l10n.fieldFormat, text: v.format ?? l10n.commonNone),
          Fact(
            l10n.resourceServer,
            text: v.server == null
                ? l10n.volumeNotAttached
                : server?.name ?? '#${v.server}',
          ),
          Fact(l10n.fieldDeleteProtection, on: v.protectDelete),
        ],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          if (v.server == null)
            DetailAction(
              icon: Icons.link,
              label: l10n.volumeAttach,
              group: ActionGroup.manage,
              onTap: busy ? null : () => _attach(context, ref, v),
            )
          else
            DetailAction(
              icon: Icons.link_off,
              label: l10n.volumeDetach,
              group: ActionGroup.manage,
              onTap: busy ? null : () => _detach(context, ref, v, server),
            ),
          DetailAction(
            icon: Icons.open_in_full,
            label: l10n.volumeResize,
            group: ActionGroup.manage,
            onTap: busy ? null : () => _resize(context, ref, v),
          ),
          DetailAction(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            group: ActionGroup.manage,
            onTap: () => editNameAndLabels(
              context,
              ref,
              t,
              v.labels,
              (api, name, labels) =>
                  updateVolume(api, v.id, name: name, labels: labels),
            ),
          ),
          DetailAction(
            icon: v.protectDelete ? Icons.lock : Icons.lock_open,
            label: l10n.fieldProtection,
            group: ActionGroup.manage,
            onTap: busy ? null : protect,
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionConfiguration,
            facts: [Fact(l10n.fieldDevice, text: v.device, mono: true)],
          ),
          if (v.server case final id?)
            DetailSection(
              title: l10n.sectionAttachment,
              cards: [
                RelatedCard(
                  icon: Icons.dns_outlined,
                  title: server?.name ?? '#$id',
                  status: server?.status,
                  subtitle: server?.type.toUpperCase(),
                  onTap: () => ServerRoute(
                    accountId: scope.accountId,
                    projectId: scope.projectId,
                    serverId: id,
                  ).push<void>(context),
                ),
              ],
            ),
          labelsSection(l10n, v.labels),
          detailsSection(l10n, id: v.id, created: v.created),
          activitySection(l10n, scope, CloudType.volume, v.id),
        ],
        dangerZone: [
          // The API refuses to delete an attached volume.
          if (v.server != null) Text(l10n.volumeAttachedHint),
          DeleteButton(
            onPressed: busy || v.server != null
                ? null
                : () async {
                    if (!await confirmDelete(
                      context,
                      t,
                      l10n.volumeDeleteConsequence,
                    )) {
                      return;
                    }
                    if (!context.mounted) return;
                    final deleted = await runChange(
                      context,
                      ref,
                      t,
                      (api) => deleteVolume(api, v.id),
                      done: l10n.deletedMessage(v.name),
                    );
                    if (deleted && context.mounted) Navigator.pop(context);
                  },
          ),
        ],
      ),
    );
  }

  Future<void> _attach(BuildContext context, WidgetRef ref, Volume v) async {
    final l10n = AppLocalizations.of(context);
    final all = await loadForPicker(
      context,
      () => ref.read(serversProvider(scope).future),
    );
    if (all == null || !context.mounted) return;
    final servers = [
      for (final s in all)
        if (s.location == v.location) s,
    ];
    if (servers.isEmpty) {
      FalcoScaffold.showSnack(context, l10n.volumeNoServers(v.location));
      return;
    }
    await FormSheet.show(
      context,
      title: l10n.volumeAttach,
      fields: (_) => [
        FieldSpec(
          'server',
          l10n.resourceServer,
          options: {for (final s in servers) '${s.id}': s.name},
        ),
        FieldSpec(
          'automount',
          l10n.volumeAutomount,
          initial: 'false',
          options: {'true': l10n.commonYes, 'false': l10n.commonNo},
        ),
      ],
      valid: (values) => (values['server'] ?? '').isNotEmpty,
      onSave: (values) => startTracked(
        ref,
        scope,
        (api) => attachVolume(
          api,
          v.id,
          int.parse(values['server']!),
          automount: values['automount'] == 'true',
        ),
      ),
    );
  }

  Future<void> _detach(
    BuildContext context,
    WidgetRef ref,
    Volume v,
    CloudServer? server,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.volumeDetachTitle(v.name),
      consequence: l10n.volumeDetachConsequence,
      confirmLabel: l10n.volumeDetach,
      resourceName: v.name,
      facts: [ConfirmFact(l10n.resourceServer, server?.name ?? '#${v.server}')],
    );
    if (confirmed && context.mounted) {
      await runAction(context, ref, scope, (api) => detachVolume(api, v.id));
    }
  }

  Future<void> _resize(BuildContext context, WidgetRef ref, Volume v) {
    final l10n = AppLocalizations.of(context);
    return FormSheet.show(
      context,
      title: l10n.volumeResize,
      fields: (_) => [
        FieldSpec(
          'size',
          l10n.fieldSizeGb,
          initial: '${v.sizeGb}',
          helper: l10n.volumeResizeHint(v.sizeGb, maxVolumeGb),
        ),
      ],
      valid: (values) => validResize(values['size'], v.sizeGb),
      onSave: (values) async {
        await startTracked(
          ref,
          scope,
          (api) => resizeVolume(api, v.id, int.parse(values['size']!.trim())),
        );
      },
    );
  }
}

/// A new size must grow the volume and stay within the limit (CMP-061).
bool validResize(String? input, int current) {
  final size = int.tryParse(input?.trim() ?? '');
  return size != null && size > current && size <= maxVolumeGb;
}

/// Create a volume: target, size with price, details (CMP-051 to CMP-056).
class CreateVolumePage extends ConsumerStatefulWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  ConsumerState<CreateVolumePage> createState() => _CreateVolumePageState();
}

class _CreateVolumePageState extends ConsumerState<CreateVolumePage> {
  String? _project;

  /// `location:fsn1` or `server:42`.
  String _target = '';
  int _size = 10;
  var _values = <String, String>{'format': 'ext4', 'automount': 'true'};
  bool _creating = false;

  Future<void> _create(ProjectScope scope) async {
    if (_creating) return;
    setState(() => _creating = true);
    final server = _target.startsWith('server:')
        ? int.parse(_target.substring(7))
        : null;
    final container = ProviderScope.containerOf(context, listen: false);
    final ok = await runActions(
      context,
      ref,
      scope,
      (api) => createVolume(
        api,
        name: _values['name']!.trim(),
        sizeGb: _size,
        location: server == null ? _target.substring(9) : null,
        server: server,
        format: _values['format'] ?? '',
        automount: _values['automount'] == 'true',
        labels: parseLabels(_values['labels'] ?? '') ?? const {},
      ),
    );
    // The new volume shows at once; the tracker refreshes it when ready.
    container.invalidate(volumesProvider);
    if (!mounted) return;
    setState(() => _creating = false);
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = targetScope(widget.scope, _project);
    final locations = scope == null
        ? const <Named>[]
        : ref.watch(locationsProvider(scope)).value ?? const <Named>[];
    final servers = scope == null
        ? const <CloudServer>[]
        : ref.watch(serversProvider(scope)).value ?? const <CloudServer>[];
    final price = scope == null
        ? null
        : ref.watch(pricingProvider(scope)).value;
    final toServer = _target.startsWith('server:');
    final targets = {
      for (final l in locations)
        'location:${l.name}': '${l.name} · ${l.detail}',
      for (final s in servers)
        'server:${s.id}': l10n.volumeNextTo(s.name, s.location),
    };
    String priceText() {
      if (price == null) return '';
      final p = volumePrice(_size, price);
      return l10n.priceMonthly(
        formatMoney(p.gross, price.currency, l10n.localeName),
        formatMoney(p.net, price.currency, l10n.localeName),
        formatMoney(price.volumeGross, price.currency, l10n.localeName),
      );
    }

    final details = [
      FieldSpec('name', l10n.fieldName, maxLength: 63),
      FieldSpec(
        'format',
        l10n.fieldFormat,
        initial: 'ext4',
        options: {
          for (final f in volumeFormats) f: f.isEmpty ? l10n.commonNone : f,
        },
      ),
      if (toServer)
        FieldSpec(
          'automount',
          l10n.volumeAutomount,
          initial: 'true',
          options: {'true': l10n.commonYes, 'false': l10n.commonNo},
        ),
      labelsField(l10n),
    ];
    return CreateWizard(
      title: l10n.volumeCreate,
      creating: _creating,
      onCreate: scope == null ? null : () => _create(scope),
      projectStep: projectStep(
        ref,
        l10n,
        widget.scope,
        _project,
        (p) => setState(() {
          _project = p;
          _target = '';
        }),
      ),
      steps: [
        WizardStep(
          title: l10n.volumeTarget,
          canContinue: targets.containsKey(_target),
          child: ChoiceList(
            options: targets,
            selected: _target,
            onSelected: (v) => setState(() => _target = v),
          ),
        ),
        WizardStep(
          title: l10n.fieldSize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: FalcoSpacing.m,
            children: [
              Wrap(
                spacing: FalcoSpacing.s,
                runSpacing: FalcoSpacing.s,
                children: [
                  for (final p in volumePresets)
                    ChoiceChip(
                      label: Text(gb(p, l10n.localeName)),
                      selected: _size == p,
                      onSelected: (_) => setState(() => _size = p),
                    ),
                ],
              ),
              Slider(
                value: _size.toDouble(),
                min: minVolumeGb.toDouble(),
                max: maxVolumeGb.toDouble(),
                label: gb(_size, l10n.localeName),
                onChanged: (v) => setState(() => _size = v.round()),
              ),
              Text(
                gb(_size, l10n.localeName),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(priceText()),
            ],
          ),
        ),
        WizardStep(
          title: l10n.wizardDetails,
          canContinue:
              (_values['name'] ?? '').trim().isNotEmpty && validLabels(_values),
          child: FormFields(
            fields: details,
            values: _values,
            onChanged: (v) => setState(() => _values = {..._values, ...v}),
          ),
        ),
      ],
      summary: FactRows([
        ConfirmFact(l10n.fieldName, (_values['name'] ?? '').trim()),
        ConfirmFact(l10n.volumeTarget, targets[_target] ?? ''),
        ConfirmFact(l10n.fieldSize, gb(_size, l10n.localeName)),
        ConfirmFact(
          l10n.fieldFormat,
          (_values['format'] ?? '').isEmpty
              ? l10n.commonNone
              : _values['format']!,
        ),
        if (toServer)
          ConfirmFact(
            l10n.volumeAutomount,
            yesNo(_values['automount'] == 'true', l10n),
          ),
        ConfirmFact(l10n.fieldPrice, priceText()),
      ]),
    );
  }
}
