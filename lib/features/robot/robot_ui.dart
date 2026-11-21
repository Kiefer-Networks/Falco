// SPDX-License-Identifier: GPL-3.0-or-later
/// Robot flows used from more than one screen: reset, Wake on LAN,
/// reverse DNS, cancellation dates and firewall rules.
library;

import 'package:falco/api/robot/robot_client.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/features/robot/robot.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:material_ui/material_ui.dart';

/// Main IP (and IPv6 net) to server label, for routing targets.
Map<String, String> serverNames(WidgetRef ref, String accountId) => {
  for (final s
      in ref.watch(robotServersProvider(accountId)).value ??
          const <RobotServer>[]) ...{?s.ipv4: s.label, ?s.ipv6Net: s.label},
};

/// Server number to label.
Map<int, String> serverNumbers(WidgetRef ref, String accountId) => {
  for (final s
      in ref.watch(robotServersProvider(accountId)).value ??
          const <RobotServer>[])
    s.number: s.label,
};

/// An IP, or a subnet as `ip/mask`.
String addressText(RobotAddress a, AddressKind kind) =>
    kind == AddressKind.ip || a.mask == null
    ? formatIp(a.ip)
    : '${formatIp(a.ip)}/${a.mask}';

/// What a reset type does (ROB-009).
String resetTypeText(String type, AppLocalizations l10n) => switch (type) {
  'sw' => l10n.resetSw,
  'hw' => l10n.resetHw,
  'man' => l10n.resetMan,
  'power' => l10n.resetPower,
  'power_long' => l10n.resetPowerLong,
  _ => type,
};

/// Resets [s] with [type] after a level 1 confirmation (ROB-009).
Future<void> resetServer(
  BuildContext context,
  WidgetRef ref,
  String accountId,
  RobotServer s,
  String type,
) async {
  final l10n = AppLocalizations.of(context);
  final ok = await ConfirmSheet.show(
    context,
    title: l10n.resetTitle(s.label),
    consequence: type == 'man'
        ? l10n.resetManConsequence
        : l10n.robotResetConsequence,
    confirmLabel: l10n.actionReset,
    resourceName: s.label,
    facts: [ConfirmFact(l10n.fieldType, resetTypeText(type, l10n))],
    destructive: true,
  );
  if (ok && context.mounted) {
    await runRobot(
      context,
      ref,
      accountId,
      (api) => api.reset(s.number, type),
      command: RobotCommand.reset,
      server: s.number,
    );
  }
}

/// Sends Wake on LAN to [s] after a confirmation (ROB-010).
Future<void> wakeOnLan(
  BuildContext context,
  WidgetRef ref,
  String accountId,
  RobotServer s,
) async {
  final l10n = AppLocalizations.of(context);
  final ok = await ConfirmSheet.show(
    context,
    title: l10n.wolTitle(s.label),
    consequence: l10n.wolConsequence,
    confirmLabel: l10n.robotWol,
    resourceName: s.label,
  );
  if (ok && context.mounted) {
    await runRobot(
      context,
      ref,
      accountId,
      (api) => api.wakeOnLan(s.number),
      command: RobotCommand.wol,
      server: s.number,
    );
  }
}

/// Edits the PTR of [ip] (IP locked); loads the current entry first
/// (ROB-013, ROB-022, ROB-045). Without entry it is created with PUT
/// (ROB-046); an empty PTR resets to the default by deleting the entry.
Future<void> editRdns(
  BuildContext context,
  WidgetRef ref,
  String accountId,
  String ip,
) async {
  final l10n = AppLocalizations.of(context);
  final RobotRdns? current;
  try {
    current = await ref.read(robotApiProvider(accountId)).rdnsOf(ip);
  } on Object catch (e) {
    if (context.mounted) {
      FalcoScaffold.showSnack(context, robotErrorText(toFalcoError(e), l10n));
    }
    return;
  }
  if (!context.mounted) return;
  final saved = await FormSheet.show(
    context,
    title: l10n.reverseDns,
    fields: (_) => [
      FieldSpec('ptr', formatIp(ip), initial: current?.ptr ?? ''),
    ],
    valid: (_) => true,
    onSave: (v) => saveRobot(
      ref,
      accountId,
      (api) {
        final ptr = (v['ptr'] ?? '').trim();
        if (ptr.isEmpty) {
          return current == null ? Future.value() : api.deleteRdns(ip);
        }
        return api.setRdns(ip, ptr, create: current == null);
      },
      command: RobotCommand.rdns,
      refresh: <ProviderOrFamily>[robotRdnsProvider(accountId)],
    ),
  );
  if (saved && context.mounted) {
    FalcoScaffold.showSnack(context, l10n.robotDone);
  }
}

/// Deletes the PTR of [r] after a confirmation (ROB-023).
Future<void> deleteRdns(
  BuildContext context,
  WidgetRef ref,
  String accountId,
  RobotRdns r,
) async {
  final l10n = AppLocalizations.of(context);
  final ok = await ConfirmSheet.show(
    context,
    title: l10n.rdnsDeleteTitle(r.ip),
    consequence: l10n.rdnsDeleteConsequence,
    confirmLabel: l10n.actionDelete,
    resourceName: r.ip,
    destructive: true,
  );
  if (ok && context.mounted) {
    await runRobot(
      context,
      ref,
      accountId,
      (api) => api.deleteRdns(r.ip),
      command: RobotCommand.rdns,
      refresh: <ProviderOrFamily>[robotRdnsProvider(accountId)],
    );
  }
}

/// A cancellation date: "now" or a day from [earliest] on, picked in the
/// date picker (BUG-013). Null when cancelled.
Future<String?> pickCancellationDate(
  BuildContext context, {
  String earliest = '',
}) async {
  final l10n = AppLocalizations.of(context);
  final first = DateTime.tryParse(earliest) ?? DateTime.now();
  final when = await ChoiceList.show(
    context,
    title: l10n.cancelDate,
    selected: '',
    options: {'now': l10n.cancelNow, 'date': l10n.cancelAtDate(isoDate(first))},
  );
  if (when != 'date' || !context.mounted) return when;
  final day = await showDatePicker(
    context: context,
    firstDate: first,
    initialDate: first,
    lastDate: first.add(const Duration(days: 3 * 365)),
  );
  return day == null ? null : isoDate(day);
}

/// Text of a cancellation date: "immediately" or the date.
String cancelDateText(String date, AppLocalizations l10n) =>
    date == 'now' ? l10n.cancelNow : date;

/// Edits [rule] in a sheet, or a new one when null; resolves to the rule
/// and its direction (`input`, `output`), null when cancelled.
Future<(String, FirewallRule)?> editRule(
  BuildContext context, {
  String direction = 'input',
  FirewallRule? rule,
}) async {
  final l10n = AppLocalizations.of(context);
  (String, FirewallRule)? result;
  await FormSheet.show(
    context,
    title: rule == null ? l10n.ruleAdd : l10n.commonEdit,
    fields: (v) => [
      FieldSpec(
        'direction',
        l10n.fieldDirection,
        initial: direction,
        options: {'input': l10n.ruleInput, 'output': l10n.ruleOutput},
      ),
      FieldSpec('name', l10n.fieldName, initial: rule?['name'] ?? ''),
      FieldSpec(
        'ip_version',
        l10n.ruleIpVersion,
        initial: rule?['ip_version'] ?? '',
        options: {'': l10n.ruleAny, 'ipv4': 'IPv4', 'ipv6': 'IPv6'},
      ),
      FieldSpec(
        'protocol',
        l10n.fieldProtocol,
        initial: rule?['protocol'] ?? '',
        options: {
          '': l10n.ruleAny,
          for (final p in const ['tcp', 'udp', 'icmp', 'gre', 'esp', 'ah'])
            p: p,
        },
      ),
      for (final f in const ['src_ip', 'src_port', 'dst_ip', 'dst_port'])
        FieldSpec(f, ruleFieldText(f, l10n), initial: rule?[f] ?? ''),
      if ((v['protocol'] ?? rule?['protocol']) == 'tcp')
        FieldSpec(
          'tcp_flags',
          l10n.ruleTcpFlags,
          initial: rule?['tcp_flags'] ?? '',
        ),
      FieldSpec(
        'action',
        l10n.ruleAction,
        initial: rule?['action'] ?? 'accept',
        options: {'accept': l10n.ruleAccept, 'discard': l10n.ruleDiscard},
      ),
    ],
    valid: (v) => (v['action'] ?? '').isNotEmpty,
    onSave: (v) async => result = (
      v['direction'] ?? 'input',
      {
        // Fields the form does not show stay as they were.
        for (final MapEntry(:key, :value) in (rule ?? const {}).entries)
          if (!firewallRuleFields.contains(key)) key: value,
        for (final f in firewallRuleFields)
          if ((v[f] ?? '').trim().isNotEmpty &&
              (f != 'tcp_flags' || v['protocol'] == 'tcp'))
            f: v[f]!.trim(),
      },
    ),
  );
  return result;
}

/// Label of a rule field.
String ruleFieldText(String field, AppLocalizations l10n) => switch (field) {
  'src_ip' => l10n.ruleSourceIp,
  'src_port' => l10n.ruleSourcePort,
  'dst_ip' => l10n.ruleDestIp,
  'dst_port' => l10n.ruleDestPort,
  'protocol' => l10n.fieldProtocol,
  'ip_version' => l10n.ruleIpVersion,
  'tcp_flags' => l10n.ruleTcpFlags,
  'action' => l10n.ruleAction,
  _ => l10n.fieldName,
};

/// One line describing [rule].
String ruleSummary(FirewallRule rule, AppLocalizations l10n) => [
  if (rule['action'] == 'discard') l10n.ruleDiscard else l10n.ruleAccept,
  ?rule['ip_version'],
  ?rule['protocol'],
  if (rule['src_ip'] case final ip?) '${l10n.ruleFrom} $ip',
  if (rule['src_port'] case final p?) ':$p',
  if (rule['dst_ip'] case final ip?) '${l10n.ruleTo} $ip',
  if (rule['dst_port'] case final p?) '→ :$p',
  ?rule['tcp_flags'],
].join(' ');

/// The rules of a firewall or template per direction; tap edits, the
/// button removes, [onChanged] gets the new rules (ROB-057, ROB-058).
class RulesSection extends StatelessWidget {
  const new({required this.rules, required this.onChanged, super.key});

  final FirewallRules rules;
  final ValueChanged<FirewallRules> onChanged;

  static FirewallRules _without(FirewallRules rules, String d, int index) => {
    for (final MapEntry(:key, :value) in rules.entries)
      key: [
        for (final (i, r) in value.indexed)
          if (key != d || i != index) r,
      ],
  };

  static FirewallRules _with(
    FirewallRules rules,
    String d,
    FirewallRule rule, [
    int? at,
  ]) {
    final next = {
      for (final MapEntry(:key, :value) in rules.entries) key: [...value],
    };
    final list = next.putIfAbsent(d, () => []);
    if (at == null) {
      list.add(rule);
    } else {
      list[at] = rule;
    }
    return next;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final d in const ['input', 'output']) ...[
          Text(
            d == 'input' ? l10n.ruleInput : l10n.ruleOutput,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (rules[d]?.isEmpty ?? true) Text(l10n.rulesEmpty),
          for (final (i, r) in (rules[d] ?? const <FirewallRule>[]).indexed)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(r['name'] ?? '#${i + 1}'),
              subtitle: Mono(ruleSummary(r, l10n), maxLines: 2),
              onTap: () async {
                final edited = await editRule(context, direction: d, rule: r);
                if (edited == null) return;
                final (direction, rule) = edited;
                onChanged(
                  direction == d
                      ? _with(rules, d, rule, i)
                      : _with(_without(rules, d, i), direction, rule),
                );
              },
              trailing: IconButton(
                tooltip: l10n.actionDelete,
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => onChanged(_without(rules, d, i)),
              ),
            ),
        ],
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () async {
              final added = await editRule(context);
              if (added != null) onChanged(_with(rules, added.$1, added.$2));
            },
            icon: const Icon(Icons.add),
            label: Text(l10n.ruleAdd),
          ),
        ),
      ],
    );
  }
}
