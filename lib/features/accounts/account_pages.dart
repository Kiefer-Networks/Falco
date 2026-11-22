// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/scope/scope_repository.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// All accounts with their services, "Active" and "Default"
/// (ONB-021 to ONB-024, ONB-042).
class AccountsPage extends ConsumerWidget {
  const new({this.activeAccountId, super.key});

  /// Account of the scope the user came from.
  final String? activeAccountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = FalcoColors.of(context);
    final async = ref.watch(accountsProvider);
    final defaultId = ref.watch(
      appSettingsProvider.select((s) => s.defaultAccount),
    );
    final accounts = async.value;
    void add() => const SetupRoute().push<void>(context);
    return FalcoScaffold(
      title: l10n.accountsTitle,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: add,
        icon: const Icon(Icons.person_add_alt),
        label: Text(l10n.accountAdd),
      ),
      body: switch (accounts) {
        null when async.hasError => Padding(
          padding: const EdgeInsets.all(FalcoSpacing.l),
          child: ErrorCard(
            message: errorText(toFalcoError(async.error!), l10n),
            onRetry: () => ref.invalidate(accountsProvider),
          ),
        ),
        null => const Center(child: CircularProgressIndicator()),
        [] => EmptyHint(message: l10n.accountsEmpty),
        _ => ListView(
          padding: const EdgeInsets.only(bottom: 96),
          children: [
            for (final a in accounts)
              ListTile(
                title: Text(a.name),
                subtitle: Text(
                  [
                    if (a.description.isNotEmpty) a.description,
                    [
                      if (a.projects.isNotEmpty)
                        l10n.accountCloudBadge(a.projects.length),
                      if (a.hasRobot) l10n.scopeRobot,
                    ].join(' · '),
                  ].join('\n'),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final tag in [
                      if (a.id == activeAccountId) l10n.accountActive,
                      if (a.id == defaultId) l10n.accountDefault,
                    ])
                      Text(
                        tag,
                        style: TextStyle(fontSize: 12, color: c.accent),
                      ),
                  ],
                ),
                onTap: () => openDetail(context, AccountRoute(accountId: a.id)),
              ),
          ],
        ),
      },
    );
  }
}

/// One account: open, edit, default, projects with their accesses,
/// Robot access, delete (ONB-025 to ONB-033).
class AccountPage extends ConsumerWidget {
  const new({required this.accountId, super.key});

  /// The account.
  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = FalcoColors.of(context);
    final accounts = ref.watch(accountsProvider.select((a) => a.value));
    final account = accounts?.where((a) => a.id == accountId).firstOrNull;
    final settings = ref.watch(appSettingsProvider);
    if (account == null) {
      return FalcoScaffold(
        title: l10n.accountTitle,
        body: accounts == null
            ? const Center(child: CircularProgressIndicator())
            : EmptyHint(message: l10n.errorNotFound),
      );
    }
    final ops = _AccountOps(
      context,
      ProviderScope.containerOf(context, listen: false),
      account,
      l10n,
    );
    final isDefault = settings.defaultAccount == account.id;
    return FalcoScaffold(
      title: l10n.accountTitle,
      body: DetailPage(
        name: account.name,
        ids: [
          if (account.description.isNotEmpty)
            DetailId(account.description, icon: Icons.notes),
        ],
        facts: [
          Fact(l10n.projectsStep, text: '${account.projects.length}'),
          Fact(l10n.scopeRobot, on: account.hasRobot),
          Fact(l10n.accountDefault, on: isDefault),
        ],
        actions: [
          DetailAction(
            icon: Icons.open_in_browser,
            label: l10n.accountOpen,
            group: ActionGroup.access,
            onTap: firstScope(account) == null
                ? null
                : () => scopeRoute(firstScope(account)!).go(context),
          ),
          DetailAction(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            group: ActionGroup.manage,
            onTap: ops.edit,
          ),
          DetailAction(
            icon: isDefault ? Icons.star : Icons.star_outline,
            label: l10n.accountDefault,
            group: ActionGroup.manage,
            onTap: () => ref
                .read(appSettingsProvider.notifier)
                .update(
                  settings.copyWith(
                    defaultAccount: () => isDefault ? null : account.id,
                  ),
                ),
          ),
          DetailAction(
            icon: Icons.add,
            label: l10n.projectAdd,
            group: ActionGroup.manage,
            onTap: () =>
                AddProjectRoute(accountId: account.id).push<void>(context),
          ),
        ],
        sections: [
          DetailSection(
            title: l10n.projectsStep,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (account.projects.isEmpty) Text(l10n.projectsEmpty),
                for (final p in account.projects) _ProjectTile(ops, p),
              ],
            ),
          ),
          DetailSection(
            title: l10n.scopeRobot,
            child: account.hasRobot
                ? ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.dns_outlined),
                    title: Text(l10n.robotAccess),
                    subtitle: Text(l10n.robotStored),
                    trailing: MoreMenu(
                      title: l10n.robotAccess,
                      actions: [
                        DetailAction(
                          label: l10n.robotChange,
                          icon: Icons.key,
                          group: ActionGroup.access,
                          onTap: ops.robot,
                        ),
                        DetailAction(
                          label: l10n.robotDelete,
                          icon: Icons.delete_outline,
                          group: ActionGroup.danger,
                          onTap: ops.deleteRobot,
                        ),
                      ],
                    ),
                  )
                : OutlinedButton.icon(
                    onPressed: ops.robot,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.robotAdd),
                  ),
          ),
        ],
        dangerZone: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(foregroundColor: c.error),
            onPressed: ops.delete,
            child: Text(l10n.accountDelete),
          ),
        ],
      ),
    );
  }
}

class _ProjectTile extends ConsumerWidget {
  const new(this.ops, this.project);

  final _AccountOps ops;
  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final s3 = ref.watch(projectS3Provider(project.id)).value;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.cloud_outlined),
      title: Text(project.name),
      subtitle: Text(s3 == null ? l10n.s3NoKeys : l10n.s3Keys(s3)),
      trailing: MoreMenu(
        title: project.name,
        actions: [
          DetailAction(
            label: l10n.actionRename,
            icon: Icons.edit_outlined,
            group: ActionGroup.manage,
            onTap: () => ops.rename(project),
          ),
          DetailAction(
            label: l10n.tokenChange,
            icon: Icons.key,
            group: ActionGroup.access,
            onTap: () => ops.token(project),
          ),
          DetailAction(
            label: l10n.s3Change,
            icon: Icons.inventory_2_outlined,
            group: ActionGroup.access,
            onTap: () => ops.s3(project),
          ),
          if (s3 != null)
            DetailAction(
              label: l10n.s3Delete,
              icon: Icons.key_off,
              group: ActionGroup.danger,
              onTap: () => ops.deleteS3(project),
            ),
          DetailAction(
            label: l10n.projectDelete,
            icon: Icons.delete_outline,
            group: ActionGroup.danger,
            onTap: () => ops.deleteProject(project),
          ),
        ],
      ),
    );
  }
}

/// The changes of one account. Every access is checked before it is
/// stored; every delete asks first and removes the secrets.
class _AccountOps {
  const new(this.context, this.container, this.account, this.l10n);

  final BuildContext context;

  /// Outlives the page, so a save that ends after it closed completes.
  final ProviderContainer container;
  final Account account;
  final AppLocalizations l10n;

  ScopeRepository get _repo => container.read(scopeRepositoryProvider);
  SecretStore get _secrets => container.read(secretStoreProvider);

  Future<void> _save(Account next) async {
    await _repo.save(next);
    container.invalidate(accountsProvider);
  }

  void _done(bool saved, String message) {
    if (saved && context.mounted) FalcoScaffold.showSnack(context, message);
  }

  /// Runs a confirmed delete; a failure, like a cancelled system check,
  /// is shown and leaves everything as it was.
  Future<void> _guarded(Future<void> Function() change) async {
    try {
      await change();
    } on FalcoError catch (e) {
      if (context.mounted) {
        FalcoScaffold.showSnack(context, errorText(e, l10n));
      }
    }
  }

  Future<void> edit() async => _done(
    await FormSheet.show(
      context,
      title: l10n.accountEdit,
      fields: (_) => [
        nameField(l10n.fieldAccountName, account.name),
        FieldSpec(
          'description',
          l10n.fieldDescription,
          initial: account.description,
          maxLength: maxNameLength * 2,
        ),
      ],
      valid: (v) => validName(v['name']),
      onSave: (v) => _save(
        account.copyWith(
          name: v['name']!.trim(),
          description: v['description']!.trim(),
        ),
      ),
    ),
    l10n.savedMessage,
  );

  Future<void> rename(Project p) async => _done(
    await FormSheet.show(
      context,
      title: l10n.actionRename,
      fields: (_) => [nameField(l10n.fieldProjectName, p.name)],
      valid: (v) => validName(v['name']),
      onSave: (v) => _save(
        account.copyWith(
          projects: [
            for (final q in account.projects)
              if (q.id == p.id)
                Project(id: p.id, name: v['name']!.trim())
              else
                q,
          ],
        ),
      ),
    ),
    l10n.savedMessage,
  );

  Future<void> token(Project p) async => _done(
    await FormSheet.show(
      context,
      title: l10n.tokenChange,
      fields: (_) => [tokenField(l10n)],
      valid: (v) => v['token']!.trim().isNotEmpty,
      onSave: (v) async {
        final token = v['token']!.trim();
        await checkToken(container, token);
        await _secrets.setCloudToken(p.id, token);
      },
    ),
    l10n.savedMessage,
  );

  Future<void> s3(Project p) async {
    final saved = await FormSheet.show(
      context,
      title: l10n.s3Change,
      fields: (v) => s3Fields(l10n, optional: false, location: v['s3'] ?? ''),
      valid: (v) => v['s3']!.isNotEmpty && validS3(v),
      onSave: (v) async {
        final c = s3FromValues(v)!;
        await checkS3Keys(container, c);
        await _secrets.setS3(p.id, c);
      },
    );
    container.invalidate(projectS3Provider(p.id));
    _done(saved, l10n.savedMessage);
  }

  Future<void> deleteS3(Project p) async {
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.s3DeleteTitle(p.name),
      consequence: l10n.s3DeleteConsequence,
      confirmLabel: l10n.actionDelete,
      resourceName: p.name,
      destructive: true,
    );
    if (!confirmed) return;
    await _guarded(() async {
      await _secrets.deleteS3(p.id);
      container.invalidate(projectS3Provider(p.id));
    });
  }

  Future<void> deleteProject(Project p) async {
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.projectDeleteTitle(p.name),
      consequence: l10n.projectDeleteConsequence,
      confirmLabel: l10n.actionDelete,
      resourceName: p.name,
      level: ConfirmLevel.typeName,
      destructive: true,
    );
    if (!confirmed) return;
    await _guarded(() async {
      await _repo.deleteProject(account.id, p.id);
      container
        ..invalidate(accountsProvider)
        ..invalidate(projectS3Provider(p.id));
    });
  }

  Future<void> robot() async => _done(
    await FormSheet.show(
      context,
      title: account.hasRobot ? l10n.robotChange : l10n.robotAdd,
      fields: (_) => robotFields(l10n),
      valid: validRobot,
      onSave: (v) async {
        final c = robotFromValues(v);
        await checkRobotLogin(container, c);
        await _secrets.setRobot(account.id, c);
        await _save(account.copyWith(hasRobot: true));
      },
    ),
    l10n.savedMessage,
  );

  Future<void> deleteRobot() async {
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.robotDeleteTitle(account.name),
      consequence: l10n.robotDeleteConsequence,
      confirmLabel: l10n.actionDelete,
      resourceName: account.name,
      destructive: true,
    );
    if (!confirmed) return;
    await _guarded(() async {
      await _secrets.deleteRobot(account.id);
      await _save(account.copyWith(hasRobot: false));
    });
  }

  Future<void> delete() async {
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.accountDeleteTitle(account.name),
      consequence: l10n.accountDeleteConsequence,
      confirmLabel: l10n.actionDelete,
      resourceName: account.name,
      level: ConfirmLevel.typeName,
      destructive: true,
    );
    if (!confirmed) return;
    await _guarded(() async {
      await _repo.deleteAccount(account.id);
      final settings = container.read(appSettingsProvider);
      if (settings.defaultAccount == account.id) {
        await container
            .read(appSettingsProvider.notifier)
            .update(settings.copyWith(defaultAccount: () => null));
      }
      container.invalidate(accountsProvider);
      if (context.mounted) const HomeRoute().go(context);
    });
  }
}
