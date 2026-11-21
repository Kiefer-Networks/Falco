// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/scope/scope_repository.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts.g.dart';

/// All accounts; invalidated after every change.
@Riverpod(keepAlive: true)
Future<List<Account>> accounts(Ref ref) =>
    ref.watch(scopeRepositoryProvider).accounts();

/// Adds a Cloud project, to the account [accountId] or, when null, to a
/// new account. The token is checked against the API before anything is
/// stored (ONB-017) and then lands in the SecretStore only.
class ProjectSetupPage extends ConsumerStatefulWidget {
  const new({this.accountId, super.key});

  /// Existing account, or null to create one.
  final String? accountId;

  @override
  ConsumerState<ProjectSetupPage> createState() => _ProjectSetupPageState();
}

class _ProjectSetupPageState extends ConsumerState<ProjectSetupPage> {
  final _account = TextEditingController();
  final _project = TextEditingController();
  final _token = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    for (final c in [_account, _project, _token]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _account.dispose();
    _project.dispose();
    _token.dispose();
    super.dispose();
  }

  bool get _newAccount => widget.accountId == null;

  Future<void> _save() async {
    // Locked while running, so a double tap saves once (ONB-018).
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final l10n = AppLocalizations.of(context);
    final token = _token.text.trim();
    try {
      await checkCloudToken(ref.read(cloudDioProvider)(bearerAuth(token)));
      final repo = ref.read(scopeRepositoryProvider);
      final project = Project(id: newId(), name: _project.text.trim());
      final existing = (await repo.accounts())
          .where((a) => a.id == widget.accountId)
          .firstOrNull;
      final account = existing == null
          ? Account(
              id: newId(),
              name: _account.text.trim(),
              projects: [project],
            )
          : existing.copyWith(projects: [...existing.projects, project]);
      // Token first: an account never points at a project without one.
      await ref.read(secretStoreProvider).setCloudToken(project.id, token);
      await repo.save(account);
      ref.invalidate(accountsProvider);
      if (!mounted) return;
      ProjectRoute(accountId: account.id, projectId: project.id).go(context);
    } on FalcoError catch (e) {
      setState(() => _error = errorText(e, l10n));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final projectStep = WizardStep(
      title: l10n.projectStep,
      canContinue:
          _project.text.trim().isNotEmpty && _token.text.trim().isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FalcoSpacing.l,
        children: [
          TextField(
            key: const ValueKey('project-name'),
            controller: _project,
            maxLength: 64,
            decoration: InputDecoration(labelText: l10n.fieldProjectName),
          ),
          TextField(
            key: const ValueKey('api-token'),
            controller: _token,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: l10n.fieldApiToken,
              helperText: l10n.tokenHint,
              helperMaxLines: 3,
            ),
          ),
        ],
      ),
    );
    return CreateWizard(
      title: _newAccount ? l10n.accountAdd : l10n.projectAdd,
      createLabel: l10n.tokenCheckSave,
      creating: _saving,
      onCreate: _save,
      steps: [
        if (_newAccount)
          WizardStep(
            title: l10n.accountStep,
            canContinue: _account.text.trim().isNotEmpty,
            child: TextField(
              key: const ValueKey('account-name'),
              controller: _account,
              maxLength: 64,
              decoration: InputDecoration(labelText: l10n.fieldAccountName),
            ),
          ),
        projectStep,
      ],
      summary: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FalcoSpacing.m,
        children: [
          if (_error case final error?) ErrorBanner(message: error),
          FactRows([
            if (_newAccount)
              ConfirmFact(l10n.fieldAccountName, _account.text.trim()),
            ConfirmFact(l10n.fieldProjectName, _project.text.trim()),
            ConfirmFact(l10n.fieldApiToken, l10n.tokenHidden),
          ]),
        ],
      ),
    );
  }
}

/// Name of project [projectId], empty while the accounts load.
String projectName(List<Account>? accounts, String projectId) =>
    accounts
        ?.expand((a) => a.projects)
        .where((p) => p.id == projectId)
        .firstOrNull
        ?.name ??
    '';
