// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/activity/activity_page.dart';
import 'package:falco/features/compute/catalog.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/network/ips.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

String _cloudType(IpKind kind) =>
    kind == IpKind.floating ? CloudType.floatingIp : CloudType.primaryIp;

/// Floating IPs or Primary IPs of a scope: IP, name, type, server,
/// location (NET-018, NET-031).
class IpList extends ConsumerWidget {
  const new({required this.scope, required this.kind, super.key});

  final Scope scope;
  final IpKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final floating = kind == IpKind.floating;
    final provider = publicIpsProvider(scope, kind);
    final async = ref.watch(provider);
    final servers = {
      for (final s
          in ref.watch(serversProvider(scope)).value ?? const <CloudServer>[])
        (s.projectId, s.id): s.name,
    };
    final accounts = scope is AllProjectsScope
        ? ref.watch(accountsProvider.select((a) => a.value))
        : null;
    return ResourceList<PublicIp>(
      title: floating ? l10n.resourceFloatingIps : l10n.resourcePrimaryIps,
      items: async.value,
      loading: async.isLoading,
      error: async.hasError
          ? errorText(toFalcoError(async.error!), l10n)
          : null,
      onRefresh: () => refreshQuietly(ref, provider.future),
      empty: EmptyHint(
        message: floating ? l10n.emptyFloatingIps : l10n.emptyPrimaryIps,
        actionLabel: floating ? l10n.floatingIpCreate : l10n.primaryIpCreate,
        onAction: () => CreateRoute.of(
          scope,
          floating ? CreateKind.floatingIp : CreateKind.primaryIp,
        ).push<void>(context),
      ),
      searchText: (i) => '${i.name} ${i.ip}',
      filters: [
        ResourceFilter(l10n.filterAll, (_) => true),
        ResourceFilter(l10n.filterAssigned, (i) => i.server != null),
        ResourceFilter(l10n.filterUnassigned, (i) => i.server == null),
      ],
      sorts: [ResourceSort(l10n.sortName, (a, b) => a.name.compareTo(b.name))],
      itemBuilder: (context, i) => ResourceRow(
        status: i.server == null
            ? ResourceStatus.off
            : ResourceStatus.available,
        name: i.name,
        monoLine: [
          formatIp(i.ip),
          if (i.ipv6) 'IPv6' else 'IPv4',
          switch (i.server) {
            null => l10n.ipNotAssigned,
            final id => servers[(i.projectId, id)] ?? '#$id',
          },
          i.location,
          if (accounts != null) projectName(accounts, i.projectId),
        ].join(' · '),
        onTap: () => openDetail(
          context,
          IpRoute(
            accountId: scope.accountId,
            projectId: i.projectId,
            kind: kind,
            ipId: i.id,
          ),
        ),
      ),
    );
  }
}

/// One Floating or Primary IP: assign or unassign, reverse DNS, edit,
/// protection, delete (NET-024 to NET-030, NET-034 to NET-038, NET-090,
/// NET-093, NET-094, BUG-001, BUG-015).
class IpDetailPage extends ConsumerWidget {
  const new({
    required this.scope,
    required this.kind,
    required this.ipId,
    super.key,
  });

  final ProjectScope scope;
  final IpKind kind;
  final int ipId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final floating = kind == IpKind.floating;
    final title = floating ? l10n.resourceFloatingIp : l10n.resourcePrimaryIp;
    final provider = publicIpProvider(scope, kind, ipId);
    final async = ref.watch(provider);
    final ip = async.value;
    if (ip == null) {
      return DetailLoading(
        title: title,
        error: async.error,
        onRetry: () => ref.invalidate(provider),
      );
    }
    final type = _cloudType(kind);
    final t = (scope: scope, type: type, id: ip.id, name: ip.name);
    final progress = ref.watch(trackedActionProvider(scope, type, ip.id)).value;
    final busy = progress != null && !progress.done;
    final servers =
        ref.watch(serversProvider(scope)).value ?? const <CloudServer>[];
    final server = servers.where((s) => s.id == ip.server).firstOrNull;
    final serverName = ip.server == null
        ? l10n.ipNotAssigned
        : server?.name ?? '#${ip.server}';

    Future<void> assign() async {
      // A Primary IP moves only to a server that is off, in its location
      // (NET-035).
      final candidates = [
        for (final s in servers)
          if (floating ||
              (s.status == ResourceStatus.off && s.location == ip.location))
            s,
      ];
      if (candidates.isEmpty) {
        FalcoScaffold.showSnack(
          context,
          floating ? l10n.ipNoServers : l10n.primaryIpNoServers(ip.location),
        );
        return;
      }
      final pick = await ChoiceList.show(
        context,
        title: l10n.ipAssign,
        searchable: true,
        selected: '',
        options: {for (final s in candidates) '${s.id}': s.name},
        details: {for (final s in candidates) '${s.id}': s.location},
      );
      if (pick != null && context.mounted) {
        await runAction(
          context,
          ref,
          scope,
          (api) => changeIp(api, kind, ip.id, AssignIp(int.parse(pick))),
        );
      }
    }

    return FalcoScaffold(
      title: title,
      body: DetailPage(
        status: busy
            ? ResourceStatus.inProgress
            : ip.server == null
            ? ResourceStatus.off
            : ResourceStatus.available,
        statusDetail: busy
            ? '${progress.progress} %'
            : ip.server == null
            ? l10n.ipNotAssigned
            : l10n.ipAssignedTo(serverName),
        name: ip.name,
        ids: [formatIp(ip.ip), ip.location],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          if (ip.server == null)
            ActionTile(
              icon: Icons.link,
              label: l10n.ipAssign,
              onTap: busy ? null : assign,
            )
          else
            ActionTile(
              icon: Icons.link_off,
              label: l10n.ipUnassign,
              onTap: busy
                  ? null
                  : () => confirmAction(
                      context,
                      ref,
                      scope,
                      title: l10n.ipUnassignTitle(ip.name, serverName),
                      consequence: floating
                          ? l10n.floatingIpUnassignConsequence
                          : l10n.primaryIpUnassignConsequence,
                      label: l10n.ipUnassign,
                      name: ip.name,
                      facts: [
                        ConfirmFact(l10n.fieldAddress, ip.ip, mono: true),
                      ],
                      start: (api) =>
                          changeIp(api, kind, ip.id, const UnassignIp()),
                    ),
            ),
          ActionTile(
            icon: Icons.dns_outlined,
            label: l10n.reverseDns,
            onTap: busy
                ? null
                : () => FormSheet.show(
                    context,
                    title: l10n.reverseDns,
                    fields: (_) => [
                      FieldSpec(
                        'ip',
                        l10n.fieldAddress,
                        initial:
                            ip.reverseDns.keys.firstOrNull ?? ip.ptrAddress,
                      ),
                      FieldSpec(
                        'ptr',
                        l10n.reverseDns,
                        initial: ip.reverseDns.values.firstOrNull ?? '',
                        helper: l10n.reverseDnsHint,
                      ),
                    ],
                    valid: (v) => (v['ip'] ?? '').trim().isNotEmpty,
                    onSave: (v) => startTracked(
                      ref,
                      scope,
                      (api) => changeIp(
                        api,
                        kind,
                        ip.id,
                        SetIpDnsPtr(v['ip']!, v['ptr'] ?? ''),
                      ),
                    ),
                  ),
          ),
          ActionTile(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            onTap: () => FormSheet.show(
              context,
              title: l10n.commonEdit,
              fields: (_) => [
                FieldSpec(
                  'name',
                  l10n.fieldName,
                  initial: ip.name,
                  maxLength: 63,
                ),
                if (floating)
                  FieldSpec(
                    'description',
                    l10n.fieldDescription,
                    initial: ip.description ?? '',
                  )
                else
                  FieldSpec(
                    'autoDelete',
                    l10n.fieldAutoDelete,
                    initial: '${ip.autoDelete}',
                    helper: l10n.autoDeleteHint,
                    options: {'true': l10n.commonYes, 'false': l10n.commonNo},
                  ),
                labelsField(l10n, ip.labels),
              ],
              valid: (v) =>
                  (v['name'] ?? '').trim().isNotEmpty && validLabels(v),
              onSave: (v) async {
                await updateIp(
                  ref.read(cloudApiProvider(scope.projectId)),
                  kind,
                  ip.id,
                  name: v['name']!.trim(),
                  labels: parseLabels(v['labels'] ?? ''),
                  description: floating ? v['description']?.trim() : null,
                  autoDelete: floating ? null : v['autoDelete'] == 'true',
                );
                refreshResource(ref.invalidate, scope, type, ip.id);
              },
            ),
          ),
          ActionTile(
            icon: ip.protectDelete ? Icons.lock : Icons.lock_open,
            label: l10n.fieldProtection,
            onTap: busy
                ? null
                : () => toggleProtection(
                    context,
                    ref,
                    t,
                    protected: ip.protectDelete,
                    start: (api, p) =>
                        changeIp(api, kind, ip.id, ProtectIp(delete: p)),
                  ),
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionOverview,
            child: FactRows([
              ConfirmFact(l10n.fieldAddress, formatIp(ip.ip), mono: true),
              ConfirmFact(l10n.fieldType, ip.ipv6 ? 'IPv6' : 'IPv4'),
              ConfirmFact(l10n.ipAssigned, yesNo(ip.server != null, l10n)),
              ConfirmFact(l10n.resourceServer, serverName),
              ConfirmFact(l10n.fieldLocation, ip.location),
              ConfirmFact(
                l10n.reverseDns,
                ip.reverseDns.isEmpty
                    ? l10n.commonNone
                    : [
                        for (final MapEntry(:key, :value)
                            in ip.reverseDns.entries)
                          '$key → $value',
                      ].join('\n'),
                mono: ip.reverseDns.isNotEmpty,
              ),
              if (floating)
                ConfirmFact(
                  l10n.fieldDescription,
                  ip.description ?? l10n.commonNone,
                )
              else
                ConfirmFact(l10n.fieldAutoDelete, yesNo(ip.autoDelete, l10n)),
              if (ip.blocked) ConfirmFact(l10n.ipBlocked, l10n.commonYes),
              ConfirmFact(
                l10n.fieldDeleteProtection,
                yesNo(ip.protectDelete, l10n),
              ),
              ConfirmFact(
                l10n.fieldCreated,
                formatDateTime(ip.created, l10n.localeName),
              ),
              ConfirmFact(l10n.fieldLabels, labelsText(ip.labels, l10n)),
            ]),
          ),
          if (server case final s?)
            DetailSection(
              title: l10n.resourceServer,
              child: EntryRow(
                leading: const Icon(Icons.dns_outlined),
                title: s.name,
                onTap: () => ServerRoute(
                  accountId: scope.accountId,
                  projectId: scope.projectId,
                  serverId: s.id,
                ).push<void>(context),
              ),
            ),
          activitySection(l10n, scope, type, ip.id),
        ],
        dangerZone: [
          DeleteButton(
            onPressed: busy
                ? null
                : () => deleteResource(
                    context,
                    ref,
                    t,
                    l10n.ipDeleteConsequence(ip.ip),
                    (api) => deleteIp(api, kind, ip.id),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Create a Floating or Primary IP: type, target, details (NET-019 to
/// NET-023, NET-032, NET-033).
class CreateIpPage extends ConsumerStatefulWidget {
  const new({required this.scope, required this.kind, super.key});

  final Scope scope;
  final IpKind kind;

  @override
  ConsumerState<CreateIpPage> createState() => _CreateIpPageState();
}

class _CreateIpPageState extends ConsumerState<CreateIpPage> {
  String? _project;
  bool _ipv6 = false;

  /// `location:fsn1` or `server:42`.
  String _target = '';
  var _values = <String, String>{};
  bool _creating = false;

  bool get _floating => widget.kind == IpKind.floating;

  Future<void> _create(ProjectScope scope) async {
    if (_creating) return;
    setState(() => _creating = true);
    final l10n = AppLocalizations.of(context);
    final name = (_values['name'] ?? '').trim();
    final server = _target.startsWith('server:')
        ? int.parse(_target.substring(7))
        : null;
    final ok = await runChange(
      context,
      ref,
      (scope: scope, type: _cloudType(widget.kind), id: 0, name: name),
      (api) async {
        final r = await createIp(
          api,
          widget.kind,
          ipv6: _ipv6,
          name: name,
          location: server == null ? _target.substring(9) : null,
          server: server,
          description: (_values['description'] ?? '').trim(),
          labels: parseLabels(_values['labels'] ?? '') ?? const {},
        );
        if (r.action case final a?) {
          ref.read(actionTrackerProvider(scope)).track(a);
        }
      },
      done: l10n.createdMessage(name.isEmpty ? l10n.resourceFloatingIp : name),
    );
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
    final servers = [
      for (final s
          in scope == null
              ? const <CloudServer>[]
              : ref.watch(serversProvider(scope)).value ??
                    const <CloudServer>[])
        // A new Primary IP goes to a server that is off (NET-035).
        if (_floating || s.status == ResourceStatus.off) s,
    ];
    final targets = {
      for (final l in locations)
        'location:${l.name}': '${l.name} · ${l.detail}',
      for (final s in servers)
        'server:${s.id}': l10n.ipOnServer(s.name, s.location),
    };
    final nameOk = !!_floating || (_values['name'] ?? '').trim().isNotEmpty;
    return CreateWizard(
      title: _floating ? l10n.floatingIpCreate : l10n.primaryIpCreate,
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
          title: l10n.fieldType,
          child: ChoiceList(
            options: const {'ipv4': 'IPv4', 'ipv6': 'IPv6'},
            selected: _ipv6 ? 'ipv6' : 'ipv4',
            onSelected: (v) => setState(() => _ipv6 = v == 'ipv6'),
          ),
        ),
        WizardStep(
          title: l10n.ipTarget,
          canContinue: targets.containsKey(_target),
          child: ChoiceList(
            options: targets,
            selected: _target,
            onSelected: (v) => setState(() => _target = v),
          ),
        ),
        WizardStep(
          title: l10n.wizardDetails,
          canContinue: nameOk && validLabels(_values),
          child: FormFields(
            fields: [
              FieldSpec(
                'name',
                _floating ? l10n.fieldNameOptional : l10n.fieldName,
                maxLength: 63,
              ),
              if (_floating) FieldSpec('description', l10n.fieldDescription),
              labelsField(l10n),
            ],
            values: _values,
            onChanged: (v) => setState(() => _values = {..._values, ...v}),
          ),
        ),
      ],
      summary: FactRows([
        ConfirmFact(l10n.fieldType, _ipv6 ? 'IPv6' : 'IPv4'),
        ConfirmFact(l10n.ipTarget, targets[_target] ?? ''),
        ConfirmFact(
          l10n.fieldName,
          (_values['name'] ?? '').trim().isEmpty
              ? l10n.commonNone
              : _values['name']!.trim(),
        ),
        if (_floating)
          ConfirmFact(
            l10n.fieldDescription,
            (_values['description'] ?? '').trim().isEmpty
                ? l10n.commonNone
                : _values['description']!.trim(),
          ),
      ]),
    );
  }
}
