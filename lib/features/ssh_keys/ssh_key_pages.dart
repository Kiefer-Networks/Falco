// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/files/text_files.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/ssh_keys/openssh.dart';
import 'package:falco/features/ssh_keys/ssh_keys.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/foundation.dart';
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
      empty: EmptyHint(message: l10n.emptySshKeys),
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
        ids: [DetailId(k.fingerprint, icon: Icons.fingerprint, copy: true)],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          DetailAction(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            group: ActionGroup.manage,
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
            title: l10n.fieldPublicKey,
            child: CopyableValue(k.publicKey),
          ),
          labelsSection(l10n, k.labels),
          detailsSection(l10n, id: k.id, created: k.created),
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
      SshKeyProblem.severalKeys => l10n.sshKeySeveral,
    };

/// Fills a public key field from a `.pub` file or a new Ed25519 key pair
/// (CMP-071, CMP-100, ROB-033, ROB-061). [onKey] gets the public key and,
/// for a generated pair, the pair; keep that only until [showPrivateKey]
/// handed its private key over.
class SshKeySources extends ConsumerWidget {
  const new({required this.comment, required this.onKey, super.key});

  /// Comment of a generated key, usually its name.
  final String comment;

  final void Function(String publicKey, SshKeyPair? pair) onKey;

  Future<void> _fromFile(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final picked = await ref.read(textFilesProvider).pick(maxBytes: 16 * 1024);
    if (picked == null || !context.mounted) return;
    final text = picked.text;
    if (picked.tooLarge || text == null) {
      FalcoScaffold.showSnack(
        context,
        picked.tooLarge ? l10n.fileTooLarge : l10n.fileNotText,
      );
      return;
    }
    // A private key file stays out of the field (CMP-072).
    if (sshKeyProblem(text) == SshKeyProblem.privateKey) {
      FalcoScaffold.showSnack(context, l10n.sshKeyPrivate);
      return;
    }
    onKey(text.trim(), null);
  }

  Future<void> _generate(BuildContext context) async {
    final pair = await generateEd25519(comment: comment.trim());
    if (!context.mounted) return;
    onKey(pair.publicKey, pair);
    FalcoScaffold.showSnack(
      context,
      AppLocalizations.of(context).sshKeyGenerated,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: FalcoSpacing.s,
      children: [
        TextButton.icon(
          onPressed: () => _fromFile(context, ref),
          icon: const Icon(Icons.file_open_outlined),
          label: Text(l10n.keyFromFile),
        ),
        TextButton.icon(
          onPressed: () => _generate(context),
          icon: const Icon(Icons.vpn_key_outlined),
          label: Text(l10n.sshKeyGenerate),
        ),
      ],
    );
  }
}

/// Hands a generated private key over once, after its public key was
/// added (CMP-100): show, copy (sensitive clipboard), save to a file.
/// Falco keeps no copy. Also after a [failed] add, since the key may have
/// reached Hetzner although the answer got lost. Only the close button
/// ends the sheet, so a stray tap cannot lose the key.
Future<void> showPrivateKey(
  BuildContext context,
  WidgetRef ref,
  String privateKey, {
  bool failed = false,
}) {
  final l10n = AppLocalizations.of(context);
  return showSecretSheet(
    context,
    title: l10n.sshKeyPrivateTitle,
    note: failed ? l10n.sshKeyPrivateFailed : l10n.sshKeyPrivateNote,
    secrets: {l10n.sshKeyPrivateTitle: privateKey},
    dismissible: false,
    onSave: () async {
      // Android's picker appends '.bin' to a name without an extension;
      // the iOS picker keeps the name as given.
      final name = defaultTargetPlatform == TargetPlatform.android
          ? 'id_ed25519.pem'
          : 'id_ed25519';
      final saved = await ref.read(textFilesProvider).save(name, privateKey);
      if (saved && context.mounted) {
        FalcoScaffold.showSnack(context, l10n.savedMessage);
      }
    },
  );
}

/// Add an SSH key: name, public key from paste, file or a new key pair,
/// labels (CMP-071, CMP-074, CMP-100).
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

  /// A generated pair until its private key is handed over.
  SshKeyPair? _pair;

  /// Counts filled keys, so the key field shows them.
  int _fills = 0;

  /// The generated private key while the key field holds its public key;
  /// a changed comment or line break does not count (CMP-100).
  String? get _private => switch (_pair) {
    final p? when sameSshKey(_values['key'] ?? '', p.publicKey) => p.privateKey,
    _ => null,
  };

  Future<void> _create(ProjectScope scope) async {
    if (_creating) return;
    final private = _private;
    setState(() => _creating = true);
    final ok = await runChange(
      context,
      ref,
      (scope: scope, type: CloudType.sshKey, id: 0, name: ''),
      (api) => createSshKey(
        api,
        name: _values['name']!.trim(),
        publicKey: normalizeSshKey(_values['key']!),
        labels: parseLabels(_values['labels'] ?? '') ?? const {},
      ),
      done: AppLocalizations.of(context).createdMessage(_values['name']!),
    );
    if (!mounted) return;
    setState(() => _creating = false);
    if (private != null) {
      if (ok) _pair = null;
      await showPrivateKey(context, ref, private, failed: !ok);
    }
    if (ok && mounted) Navigator.pop(context);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormFields(
                key: ValueKey(_fills),
                fields: [
                  FieldSpec('name', l10n.fieldName, maxLength: 63),
                  FieldSpec(
                    'key',
                    l10n.fieldPublicKey,
                    multiline: true,
                    helper: sshKeyProblemText(key, l10n) ?? l10n.sshKeyHint,
                  ),
                  labelsField(l10n),
                ],
                values: _values,
                onChanged: (v) => setState(() => _values = {..._values, ...v}),
              ),
              SshKeySources(
                comment: _values['name'] ?? '',
                onKey: (public, pair) => setState(() {
                  _values = {..._values, 'key': public};
                  _pair = pair;
                  _fills++;
                }),
              ),
            ],
          ),
        ),
      ],
      summary: FactRows([
        ConfirmFact(l10n.fieldName, (_values['name'] ?? '').trim()),
        ConfirmFact(l10n.fieldPublicKey, key.trim(), mono: true),
        if (_private != null)
          ConfirmFact(l10n.sshKeyPrivateTitle, l10n.sshKeyPrivateAfter),
      ]),
    );
  }
}
