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
        ? ref.watch(accountsProvider.select((a) => a.value))
        : null;
    return ResourceList<Firewall>(
      title: l10n.resourceFirewalls,
      items: async.value,
      loading: async.isLoading,
      error: async.hasError
          ? errorText(toFalcoError(async.error!), l10n)
          : null,
      onRefresh: () => refreshQuietly(ref, provider.future),
      empty: EmptyHint(message: l10n.emptyFirewalls),
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
        onTap: () => openDetail(
          context,
          FirewallRoute(
            accountId: scope.accountId,
            projectId: f.projectId,
            firewallId: f.id,
          ),
        ),
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
  port: hasPort(v['protocol'] ?? 'tcp')
      ? v['port']?.replaceAll(RegExp(r'\s'), '').toLowerCase()
      : null,
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

/// Position of the [nth] rule equal to [rule] in [rules] (0 based), or -1.
/// Equal rules can exist twice; an edit acts on the one tapped.
int ruleIndex(List<FirewallRule> rules, FirewallRule rule, int nth) {
  var seen = 0;
  for (final (i, x) in rules.indexed) {
    if (x == rule && seen++ == nth) return i;
  }
  return -1;
}

/// [rules] with the [nth] copy of [old] replaced by [next], or [next]
/// added when [old] is null (NET-005, NET-011). An edit never adds a
/// second copy of [next]. Throws [Conflict] (`rule_gone`) when [old] was
/// changed or removed meanwhile.
List<FirewallRule> editRule(
  List<FirewallRule> rules,
  FirewallRule? old,
  FirewallRule next, [
  int nth = 0,
]) {
  if (old == null) return rules.contains(next) ? rules : [...rules, next];
  final i = ruleIndex(rules, old, nth);
  if (i < 0) throw const Conflict(code: 'rule_gone');
  if (next == old) return rules;
  final out = [...rules]..removeAt(i);
  return out.contains(next) ? out : (out..insert(i, next));
}

/// [rules] without the [nth] copy of [rule]; unchanged when it is gone.
List<FirewallRule> removeRuleAt(
  List<FirewallRule> rules,
  FirewallRule rule,
  int nth,
) {
  final i = ruleIndex(rules, rule, nth);
  return i < 0 ? rules : ([...rules]..removeAt(i));
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
        s.id: s,
    };
    final progress = ref
        .watch(trackedActionProvider(scope, CloudType.firewall, f.id))
        .value;
    // A rule change starts one action per applied server besides
    // set_firewall_rules: busy until all of them ended, not only the one
    // reported last.
    final busy =
        (progress != null && !progress.done) ||
        ref
            .watch(actionTrackerProvider(scope))
            .running
            .any((a) => a.resources.contains((CloudType.firewall, f.id)));

    // Rules and targets change by actions per applied server; the
    // firewall itself refreshes at once.
    Future<void> track(Future<List<int>> Function(cloud.Server api) run) async {
      final api = ref.read(cloudApiProvider(scope.projectId));
      final tracker = ref.read(actionTrackerProvider(scope));
      final container = ProviderScope.containerOf(context, listen: false);
      final ids = await run(api);
      ids.forEach(tracker.track);
      refreshResource(container.invalidate, scope, CloudType.firewall, f.id);
    }

    // A rule change applies to the rules the firewall has now, not to
    // this page's: a rule added meanwhile is never dropped.
    Future<void> setAll(List<FirewallRule> Function(List<FirewallRule>) edit) =>
        track(
          (api) => getFirewall(
            api,
            scope,
            f.id,
          ).then((now) => setRules(api, f.id, edit(now.rules))),
        );

    Future<void> removeRule(FirewallRule r, int nth) async {
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
        (_) => setAll((now) => removeRuleAt(now, r, nth)),
      );
    }

    // Which copy of an equal rule a row shows.
    int nthOf(int i) => f.rules.take(i).where((x) => x == f.rules[i]).length;

    Widget rules(bool inbound) => entries([
      for (final (i, r) in f.rules.indexed)
        if (r.inbound == inbound)
          EntryRow(
            title: ruleTitle(r),
            subtitle: [
              r.ips.join(', '),
              if (r.description case final d? when d.isNotEmpty) d,
            ].join(' · '),
            onTap: busy
                ? null
                : () => showRuleSheet(
                    context,
                    title: l10n.ruleEdit,
                    initial: r,
                    save: (rule) =>
                        setAll((now) => editRule(now, r, rule, nthOf(i))),
                  ),
            onRemove: busy ? null : () => removeRule(r, nthOf(i)),
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
            if (!applied.contains(key)) '$key': value.name,
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

    Future<void> removeTarget(FirewallTarget a) async {
      final name = a.server != null
          ? servers[a.server]?.name ?? '#${a.server}'
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
          (_) => track((api) => applyFirewall(api, f.id, a, remove: true)),
        );
      }
    }

    final inbound = f.rules.where((r) => r.inbound).length;
    return FalcoScaffold(
      title: l10n.resourceFirewall,
      body: DetailPage(
        status: f.active ? ResourceStatus.available : ResourceStatus.off,
        statusDetail: f.active ? l10n.firewallActive : l10n.firewallNotApplied,
        name: f.name,
        facts: [
          Fact(l10n.ruleInbound, text: '$inbound'),
          Fact(l10n.ruleOutbound, text: '${f.rules.length - inbound}'),
          Fact(l10n.sectionAppliedTo, text: '${f.appliedTo.length}'),
          Fact(l10n.fieldCreated, time: f.created),
        ],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          DetailAction(
            icon: Icons.add,
            label: l10n.ruleAdd,
            group: ActionGroup.manage,
            onTap: busy
                ? null
                : () => showRuleSheet(
                    context,
                    title: l10n.ruleAdd,
                    save: (rule) => setAll((now) => editRule(now, null, rule)),
                  ),
          ),
          DetailAction(
            icon: Icons.shield_outlined,
            label: l10n.firewallApply,
            group: ActionGroup.network,
            onTap: apply,
          ),
          DetailAction(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            group: ActionGroup.manage,
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
          DetailSection(title: l10n.ruleInbound, child: rules(true)),
          DetailSection(title: l10n.ruleOutbound, child: rules(false)),
          DetailSection(
            title: l10n.sectionAppliedTo,
            cards: [
              if (f.appliedTo.isEmpty) Text(l10n.firewallNotAppliedHint),
              for (final a in f.appliedTo)
                RelatedCard(
                  icon: a.server != null
                      ? Icons.dns_outlined
                      : Icons.label_outline,
                  title: switch (a) {
                    (server: final id?, selector: _) =>
                      servers[id]?.name ?? '#$id',
                    (server: _, selector: final s) => s ?? '',
                  },
                  status: servers[a.server]?.status,
                  subtitle: a.server != null ? null : l10n.labelSelector,
                  onTap: switch (a.server) {
                    final id? => () => ServerRoute(
                      accountId: scope.accountId,
                      projectId: scope.projectId,
                      serverId: id,
                    ).push<void>(context),
                    null => null,
                  },
                  trailing: IconButton(
                    tooltip: l10n.actionRemove,
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => removeTarget(a),
                  ),
                ),
            ],
          ),
          labelsSection(l10n, f.labels),
          detailsSection(l10n, id: f.id),
          activitySection(l10n, scope, CloudType.firewall, f.id),
        ],
        dangerZone: [
          // The API refuses to delete an applied firewall (resource_in_use).
          if (f.appliedTo.isNotEmpty) Text(l10n.firewallInUseHint),
          DeleteButton(
            onPressed: f.appliedTo.isNotEmpty
                ? null
                : () => deleteResource(
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
    final tracker = ref.read(actionTrackerProvider(scope));
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
        r.actions.forEach(tracker.track);
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
