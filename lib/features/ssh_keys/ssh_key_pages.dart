// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/ssh_keys/ssh_keys.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// SSH keys of a scope with fingerprint (CMP-070).
class SshKeyList extends ConsumerWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = sshKeysProvider(scope);
    final async = ref.watch(provider);
    final accounts = scope is AllProjectsScope
        ? ref.watch(accountsProvider.select((a) => a.value))
        : null;
    return ResourceList<SshKey>(
      title: l10n.resourceSshKeys,
      items: async.value,
      loading: async.isLoading,
      error: async.hasError
          ? errorText(toFalcoError(async.error!), l10n)
          : null,
      onRefresh: () => refreshQuietly(ref, provider.future),
      empty: EmptyHint(
        message: l10n.emptySshKeys,
        actionLabel: l10n.sshKeyAdd,
        onAction: () =>
            CreateRoute.of(scope, CreateKind.sshKey).push<void>(context),
      ),
      searchText: (k) => '${k.name} ${k.fingerprint}',
      sorts: [ResourceSort(l10n.sortName, (a, b) => a.name.compareTo(b.name))],
      itemBuilder: (context, k) => ResourceRow(
        status: ResourceStatus.available,
        name: k.name,
        monoLine: [
          k.fingerprint,
          if (accounts != null) projectName(accounts, k.projectId),
        ].join(' · '),
        onTap: () => openDetail(
          context,
          SshKeyRoute(
            accountId: scope.accountId,
            projectId: k.projectId,
            keyId: k.id,
          ),
        ),
      ),
    );
  }
}

/// One SSH key: fingerprint, key, labels; rename, delete
/// (CMP-075, CMP-076, CMP-099).
class SshKeyDetailPage extends ConsumerWidget {
  const new({required this.scope, required this.keyId, super.key});

  final ProjectScope scope;
  final int keyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = sshKeyProvider(scope, keyId);
    final async = ref.watch(provider);
    final k = async.value;
    if (k == null) {
      return DetailLoading(
        title: l10n.resourceSshKey,
        error: async.error,
        onRetry: () => ref.invalidate(provider),
      );
    }
    final t = (scope: scope, type: CloudType.sshKey, id: k.id, name: k.name);
    return FalcoScaffold(
      title: l10n.resourceSshKey,
      body: DetailPage(
        name: k.name,
        ids: [k.fingerprint],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          ActionTile(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            onTap: () => editNameAndLabels(
              context,
              ref,
              t,
              k.labels,
              (api, name, labels) =>
                  updateSshKey(api, k.id, name: name, labels: labels),
            ),
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionOverview,
            child: FactRows([
              ConfirmFact(l10n.fieldFingerprint, k.fingerprint, mono: true),
              ConfirmFact(
                l10n.fieldCreated,
                formatDateTime(k.created, l10n.localeName),
              ),
              ConfirmFact(l10n.fieldLabels, labelsText(k.labels, l10n)),
            ]),
          ),
          DetailSection(
            title: l10n.fieldPublicKey,
            child: CopyableValue(k.publicKey),
          ),
        ],
        dangerZone: [
          DeleteButton(
            onPressed: () async {
              if (!await confirmDelete(
                    context,
                    t,
                    l10n.sshKeyDeleteConsequence,
                  ) ||
                  !context.mounted) {
                return;
              }
              final deleted = await runChange(
                context,
                ref,
                t,
                (api) => deleteSshKey(api, k.id),
                done: l10n.deletedMessage(k.name),
              );
              if (deleted && context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

/// Localized reason a pasted key is refused (CMP-072, CMP-073).
String? sshKeyProblemText(String key, AppLocalizations l10n) =>
    switch (sshKeyProblem(key)) {
      null || SshKeyProblem.empty => null,
      SshKeyProblem.privateKey => l10n.sshKeyPrivate,
      SshKeyProblem.unknownType => l10n.sshKeyUnknown,
    };

/// Add an SSH key: name, public key, labels (CMP-071, CMP-074).
class CreateSshKeyPage extends ConsumerStatefulWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  ConsumerState<CreateSshKeyPage> createState() => _CreateSshKeyPageState();
}

class _CreateSshKeyPageState extends ConsumerState<CreateSshKeyPage> {
  String? _project;
  var _values = <String, String>{};
  bool _creating = false;

  Future<void> _create(ProjectScope scope) async {
    if (_creating) return;
    setState(() => _creating = true);
    final ok = await runChange(
      context,
      ref,
      (scope: scope, type: CloudType.sshKey, id: 0, name: ''),
      (api) => createSshKey(
        api,
        name: _values['name']!.trim(),
        publicKey: _values['key']!,
        labels: parseLabels(_values['labels'] ?? '') ?? const {},
      ),
      done: AppLocalizations.of(context).createdMessage(_values['name']!),
    );
    if (!mounted) return;
    setState(() => _creating = false);
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = targetScope(widget.scope, _project);
    final key = _values['key'] ?? '';
    return CreateWizard(
      title: l10n.sshKeyAdd,
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
          title: l10n.wizardDetails,
          canContinue:
              (_values['name'] ?? '').trim().isNotEmpty &&
              sshKeyProblem(key) == null &&
              validLabels(_values),
          child: FormFields(
            fields: [
              FieldSpec('name', l10n.fieldName, maxLength: 63),
              FieldSpec(
                'key',
                l10n.fieldPublicKey,
                helper: sshKeyProblemText(key, l10n) ?? l10n.sshKeyHint,
              ),
              labelsField(l10n),
            ],
            values: _values,
            onChanged: (v) => setState(() => _values = {..._values, ...v}),
          ),
        ),
      ],
      summary: FactRows([
        ConfirmFact(l10n.fieldName, (_values['name'] ?? '').trim()),
        ConfirmFact(l10n.fieldPublicKey, key.trim(), mono: true),
      ]),
    );
  }
}
