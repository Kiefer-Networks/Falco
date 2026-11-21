// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/network/firewalls.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:material_ui/material_ui.dart';

/// Firewalls of a scope with "Active" or "Not applied" (NET-001).
class FirewallList extends ConsumerWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = firewallsProvider(scope);
    final async = ref.watch(provider);
    final accounts = scope is AllProjectsScope
        ? ref.watch(accountsProvider).value
        : null;
    return ResourceList<Firewall>(
      title: l10n.resourceFirewalls,
      items: async.value,
      loading: async.isLoading,
      error: async.hasError
          ? errorText(toFalcoError(async.error!), l10n)
          : null,
      onRefresh: () => refreshQuietly(ref, provider.future),
      empty: EmptyHint(
        message: l10n.emptyFirewalls,
        actionLabel: l10n.firewallCreate,
        onAction: () =>
            CreateRoute.of(scope, CreateKind.firewall).push<void>(context),
      ),
      searchText: (f) => f.name,
      filters: [
        ResourceFilter(l10n.filterAll, (_) => true),
        ResourceFilter(l10n.firewallActive, (f) => f.active),
        ResourceFilter(l10n.firewallNotApplied, (f) => !f.active),
      ],
      sorts: [ResourceSort(l10n.sortName, (a, b) => a.name.compareTo(b.name))],
      itemBuilder: (context, f) => ResourceRow(
        status: f.active ? ResourceStatus.available : ResourceStatus.off,
        name: f.name,
        monoLine: [
          if (f.active) l10n.firewallActive else l10n.firewallNotApplied,
          l10n.ruleCount(f.rules.length),
          if (accounts != null) projectName(accounts, f.projectId),
        ].join(' · '),
        onTap: () => FirewallRoute(
          accountId: scope.accountId,
          projectId: f.projectId,
          firewallId: f.id,
        ).push<void>(context),
      ),
    );
  }
}

/// IP presets of the rule form (NET-009).
const _anyIps = '$anyIpv4, $anyIpv6';

/// Fields of a rule: direction, protocol, port for tcp and udp, IPs with
/// presets, description (NET-005 to NET-010).
List<FieldSpec> ruleFields(AppLocalizations l10n, Map<String, String> v) => [
  FieldSpec(
    'direction',
    l10n.fieldDirection,
    initial: 'in',
    options: {'in': l10n.ruleInbound, 'out': l10n.ruleOutbound},
  ),
  FieldSpec(
    'protocol',
    l10n.fieldProtocol,
    initial: 'tcp',
    options: {for (final p in firewallProtocols) p: p.toUpperCase()},
  ),
  if (hasPort(v['protocol'] ?? 'tcp'))
    FieldSpec('port', l10n.fieldPort, helper: l10n.portHint),
  FieldSpec(
    'preset',
    (v['direction'] ?? 'in') == 'in' ? l10n.fieldSourceIps : l10n.fieldDestIps,
    initial: 'any',
    options: {
      'any': l10n.ipsAny,
      'v4': l10n.ipsAnyV4,
      'v6': l10n.ipsAnyV6,
      'custom': l10n.ipsCustom,
    },
  ),
  if (v['preset'] == 'custom')
    FieldSpec('ips', l10n.fieldIps, helper: l10n.ipsHint),
  FieldSpec('description', l10n.fieldDescription, maxLength: 255),
];

String _ipsOf(Map<String, String> v) => switch (v['preset'] ?? 'any') {
  'v4' => anyIpv4,
  'v6' => anyIpv6,
  'custom' => v['ips'] ?? '',
  _ => _anyIps,
};

/// Whether rule form [v] is complete (NET-007 to NET-009).
bool validRule(Map<String, String> v) =>
    (!hasPort(v['protocol'] ?? 'tcp') || validPort(v['port'] ?? '')) &&
    validIps(_ipsOf(v));

/// The rule of form [v].
FirewallRule ruleOf(Map<String, String> v) => FirewallRule(
  inbound: (v['direction'] ?? 'in') == 'in',
  protocol: v['protocol'] ?? 'tcp',
  port: hasPort(v['protocol'] ?? 'tcp') ? v['port']?.trim() : null,
  ips: splitIps(_ipsOf(v)),
  description: v['description']?.trim(),
);

/// Form values of [r] for editing (NET-011).
Map<String, String> ruleValues(FirewallRule r) {
  final ips = r.ips.join(', ');
  return {
    'direction': r.inbound ? 'in' : 'out',
    'protocol': r.protocol,
    'port': r.port ?? '',
    'preset': switch (ips) {
      _anyIps => 'any',
      anyIpv4 => 'v4',
      anyIpv6 => 'v6',
      _ => 'custom',
    },
    'ips': ips,
    'description': r.description ?? '',
  };
}

/// The rule sheet, empty for a new rule or filled with [initial]
/// (NET-005, NET-011). [save] gets the rule.
Future<bool> showRuleSheet(
  BuildContext context, {
  required String title,
  required Future<void> Function(FirewallRule rule) save,
  FirewallRule? initial,
}) {
  final l10n = AppLocalizations.of(context);
  final values = initial == null ? null : ruleValues(initial);
  return FormSheet.show(
    context,
    title: title,
    fields: (v) => prefill(ruleFields(l10n, v), values),
    valid: validRule,
    onSave: (v) => save(ruleOf(v)),
  );
}

/// One line for a rule: protocol and port.
String ruleTitle(FirewallRule r) =>
    [r.protocol.toUpperCase(), ?r.port].join(' ');

/// One firewall: rules in and out, targets, edit, delete (NET-004 to
/// NET-017, NET-089, NET-090).
class FirewallDetailPage extends ConsumerWidget {
  const new({required this.scope, required this.firewallId, super.key});

  final ProjectScope scope;
  final int firewallId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = firewallProvider(scope, firewallId);
    final async = ref.watch(provider);
    final f = async.value;
    if (f == null) {
      return DetailLoading(
        title: l10n.resourceFirewall,
        error: async.error,
        onRetry: () => ref.invalidate(provider),
      );
    }
    final t = (scope: scope, type: CloudType.firewall, id: f.id, name: f.name);
    final servers = {
      for (final s
          in ref.watch(serversProvider(scope)).value ?? const <CloudServer>[])
        s.id: s.name,
    };

    // Rules and targets change by actions per applied server; the
    // firewall itself refreshes at once.
    Future<void> track(Future<List<int>> Function(cloud.Server api) run) async {
      final ids = await run(ref.read(cloudApiProvider(scope.projectId)));
      ids.forEach(ref.read(actionTrackerProvider(scope)).track);
      refreshResource(ref.invalidate, scope, CloudType.firewall, f.id);
    }

    Future<void> setAll(List<FirewallRule> rules) =>
        track((api) => setRules(api, f.id, rules));

    Future<void> removeRule(FirewallRule r) async {
      final ok = await ConfirmSheet.show(
        context,
        title: l10n.ruleDeleteTitle(ruleTitle(r)),
        consequence: l10n.ruleDeleteConsequence,
        confirmLabel: l10n.actionDelete,
        resourceName: f.name,
        destructive: true,
        facts: [ConfirmFact(l10n.fieldIps, r.ips.join(', '), mono: true)],
      );
      if (!ok || !context.mounted) return;
      await runChange(
        context,
        ref,
        t,
        (_) => setAll([...f.rules.where((x) => !identical(x, r))]),
      );
    }

    Widget rules(bool inbound) => entries([
      for (final r in f.rules)
        if (r.inbound == inbound)
          EntryRow(
            title: ruleTitle(r),
            subtitle: [
              r.ips.join(', '),
              if (r.description case final d? when d.isNotEmpty) d,
            ].join(' · '),
            onTap: () => showRuleSheet(
              context,
              title: l10n.ruleEdit,
              initial: r,
              save: (rule) => setAll([
                for (final x in f.rules)
                  if (identical(x, r)) rule else x,
              ]),
            ),
            onRemove: () => removeRule(r),
          ),
    ], l10n.rulesEmpty);

    Future<void> apply() async {
      final applied = {for (final a in f.appliedTo) ?a.server};
      final pick = await ChoiceList.show(
        context,
        title: l10n.firewallApply,
        searchable: true,
        selected: '',
        options: {
          'selector': l10n.labelSelector,
          for (final MapEntry(:key, :value) in servers.entries)
            if (!applied.contains(key)) '$key': value,
        },
      );
      if (pick == null || !context.mounted) return;
      if (pick != 'selector') {
        await runChange(
          context,
          ref,
          t,
          (_) => track(
            (api) => applyFirewall(api, f.id, (
              server: int.parse(pick),
              selector: null,
            )),
          ),
        );
        return;
      }
      await FormSheet.show(
        context,
        title: l10n.labelSelector,
        fields: (_) => [
          FieldSpec('selector', l10n.labelSelector, helper: l10n.selectorHint),
        ],
        valid: (v) => (v['selector'] ?? '').trim().isNotEmpty,
        onSave: (v) => track(
          (api) => applyFirewall(api, f.id, (
            server: null,
            selector: v['selector']!.trim(),
          )),
        ),
      );
    }

    final inbound = f.rules.where((r) => r.inbound).length;
    return FalcoScaffold(
      title: l10n.resourceFirewall,
      body: DetailPage(
        status: f.active ? ResourceStatus.available : ResourceStatus.off,
        statusDetail: f.active ? l10n.firewallActive : l10n.firewallNotApplied,
        name: f.name,
        ids: [l10n.ruleCount(f.rules.length)],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          ActionTile(
            icon: Icons.add,
            label: l10n.ruleAdd,
            onTap: () => showRuleSheet(
              context,
              title: l10n.ruleAdd,
              save: (rule) => setAll([...f.rules, rule]),
            ),
          ),
          ActionTile(
            icon: Icons.shield_outlined,
            label: l10n.firewallApply,
            onTap: apply,
          ),
          ActionTile(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            onTap: () => editNameAndLabels(
              context,
              ref,
              t,
              f.labels,
              (api, name, labels) =>
                  updateFirewall(api, f.id, name: name, labels: labels),
            ),
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionOverview,
            child: FactRows([
              ConfirmFact(l10n.ruleInbound, '$inbound'),
              ConfirmFact(l10n.ruleOutbound, '${f.rules.length - inbound}'),
              ConfirmFact(l10n.sectionAppliedTo, '${f.appliedTo.length}'),
              ConfirmFact(
                l10n.fieldCreated,
                formatDateTime(f.created, l10n.localeName),
              ),
              ConfirmFact(l10n.fieldLabels, labelsText(f.labels, l10n)),
            ]),
          ),
          DetailSection(title: l10n.ruleInbound, child: rules(true)),
          DetailSection(title: l10n.ruleOutbound, child: rules(false)),
          DetailSection(
            title: l10n.sectionAppliedTo,
            child: entries([
              for (final a in f.appliedTo)
                EntryRow(
                  leading: Icon(
                    a.server != null ? Icons.dns_outlined : Icons.label_outline,
                  ),
                  title: switch (a) {
                    (server: final id?, selector: _) => servers[id] ?? '#$id',
                    (server: _, selector: final s) => s ?? '',
                  },
                  subtitle: a.server != null ? null : l10n.labelSelector,
                  removeLabel: l10n.actionRemove,
                  onRemove: () async {
                    final name = a.server != null
                        ? servers[a.server] ?? '#${a.server}'
                        : a.selector!;
                    final ok = await ConfirmSheet.show(
                      context,
                      title: l10n.firewallRemoveTitle(f.name, name),
                      consequence: l10n.firewallRemoveConsequence,
                      confirmLabel: l10n.actionRemove,
                      resourceName: f.name,
                    );
                    if (ok && context.mounted) {
                      await runChange(
                        context,
                        ref,
                        t,
                        (_) => track(
                          (api) => applyFirewall(api, f.id, a, remove: true),
                        ),
                      );
                    }
                  },
                ),
            ], l10n.firewallNotAppliedHint),
          ),
        ],
        dangerZone: [
          DeleteButton(
            onPressed: () => deleteResource(
              context,
              ref,
              t,
              l10n.firewallDeleteConsequence,
              (api) => deleteFirewall(api, f.id),
            ),
          ),
        ],
      ),
    );
  }
}

/// Create a firewall: name, rules and targets in the wizard (NET-002).
class CreateFirewallPage extends ConsumerStatefulWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  ConsumerState<CreateFirewallPage> createState() => _CreateFirewallPageState();
}

class _CreateFirewallPageState extends ConsumerState<CreateFirewallPage> {
  String? _project;
  var _values = <String, String>{};
  final _rules = <FirewallRule>[];
  Set<String> _servers = {};
  bool _creating = false;

  Future<void> _create(ProjectScope scope) async {
    if (_creating) return;
    setState(() => _creating = true);
    final l10n = AppLocalizations.of(context);
    final name = _values['name']!.trim();
    final selector = (_values['selector'] ?? '').trim();
    final ok = await runChange(
      context,
      ref,
      (scope: scope, type: CloudType.firewall, id: 0, name: name),
      (api) async {
        final r = await createFirewall(
          api,
          name: name,
          rules: _rules,
          applyTo: [
            for (final s in _servers) (server: int.parse(s), selector: null),
            if (selector.isNotEmpty) (server: null, selector: selector),
          ],
          labels: parseLabels(_values['labels'] ?? '') ?? const {},
        );
        r.actions.forEach(ref.read(actionTrackerProvider(scope)).track);
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
    final servers = {
      for (final s
          in scope == null
              ? const <CloudServer>[]
              : ref.watch(serversProvider(scope)).value ??
                    const <CloudServer>[])
        '${s.id}': s.name,
    };
    return CreateWizard(
      title: l10n.firewallCreate,
      creating: _creating,
      onCreate: scope == null ? null : () => _create(scope),
      projectStep: projectStep(
        ref,
        l10n,
        widget.scope,
        _project,
        (p) => setState(() {
          _project = p;
          _servers = {};
        }),
      ),
      steps: [
        WizardStep(
          title: l10n.wizardDetails,
          canContinue:
              (_values['name'] ?? '').trim().isNotEmpty && validLabels(_values),
          child: FormFields(
            fields: [
              FieldSpec('name', l10n.fieldName, maxLength: 63),
              labelsField(l10n),
            ],
            values: _values,
            onChanged: (v) => setState(() => _values = {..._values, ...v}),
          ),
        ),
        WizardStep(
          title: l10n.sectionRules,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              entries([
                for (final r in _rules)
                  EntryRow(
                    title:
                        '${r.inbound ? l10n.ruleInbound : l10n.ruleOutbound} '
                        '${ruleTitle(r)}',
                    subtitle: r.ips.join(', '),
                    onRemove: () => setState(() => _rules.remove(r)),
                  ),
              ], l10n.rulesEmpty),
              OutlinedButton.icon(
                onPressed: () => showRuleSheet(
                  context,
                  title: l10n.ruleAdd,
                  save: (rule) async => setState(() => _rules.add(rule)),
                ),
                icon: const Icon(Icons.add),
                label: Text(l10n.ruleAdd),
              ),
            ],
          ),
        ),
        WizardStep(
          title: l10n.sectionAppliedTo,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (servers.isEmpty) Text(l10n.commonNone),
              MultiChoiceList(
                options: servers,
                selected: _servers,
                onChanged: (v) => setState(() => _servers = v),
              ),
              FormFields(
                fields: [
                  FieldSpec(
                    'selector',
                    l10n.labelSelector,
                    helper: l10n.selectorHint,
                  ),
                ],
                values: _values,
                onChanged: (v) => setState(() => _values = {..._values, ...v}),
              ),
            ],
          ),
        ),
      ],
      summary: FactRows([
        ConfirmFact(l10n.fieldName, (_values['name'] ?? '').trim()),
        ConfirmFact(l10n.sectionRules, l10n.ruleCount(_rules.length)),
        ConfirmFact(
          l10n.sectionAppliedTo,
          [
            for (final s in _servers) servers[s] ?? s,
            if ((_values['selector'] ?? '').trim().isNotEmpty)
              _values['selector']!.trim(),
          ].join(', ').ifEmpty(l10n.commonNone),
        ),
        ConfirmFact(
          l10n.fieldLabels,
          labelsText(parseLabels(_values['labels'] ?? '') ?? const {}, l10n),
        ),
      ]),
    );
  }
}

extension on String {
  String ifEmpty(String other) => isEmpty ? other : this;
}
