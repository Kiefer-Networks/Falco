// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/scope/scope_repository.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:falco/features/accounts/checks.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'package:falco/core/scope/scope_repository.dart' show accountsProvider;

part 'accounts.g.dart';

/// Hetzner Cloud Console page for API tokens (ONB-013).
const cloudTokensUrl = 'https://console.hetzner.cloud/security/tokens';

/// Robot page for webservice users (ONB-015).
const robotSettingsUrl = 'https://robot.hetzner.com/preferences/index';

/// Longest account or project name (ONB-008).
const maxNameLength = 64;

/// Object Storage location of a project, null without keys.
@riverpod
Future<String?> projectS3(Ref ref, String projectId) async =>
    (await ref.watch(secretStoreProvider).s3(projectId))?.region;

String _v(Map<String, String> values, String key) => values[key]?.trim() ?? '';

/// A name is required and at most [maxNameLength] characters (ONB-008).
bool validName(String? name) {
  final n = name?.trim() ?? '';
  return n.isNotEmpty && n.length <= maxNameLength;
}

/// Object Storage is optional; once a location is picked, both keys are
/// required (ONB-012).
bool validS3(Map<String, String> values) {
  final location = _v(values, 's3');
  return location.isEmpty ||
      (s3Locations.contains(location) &&
          _v(values, 'accessKey').isNotEmpty &&
          _v(values, 'secretKey').isNotEmpty);
}

/// Name and token are required, S3 complete when chosen (ONB-011, ONB-032).
bool validProject(Map<String, String> values) =>
    validName(values['name']) &&
    _v(values, 'token').isNotEmpty &&
    validS3(values);

/// Robot user and password are required (ONB-014).
bool validRobot(Map<String, String> values) =>
    _v(values, 'robotUser').isNotEmpty &&
    _v(values, 'robotPassword').isNotEmpty;

/// Name field.
FieldSpec nameField(String label, [String initial = '']) =>
    FieldSpec('name', label, initial: initial, maxLength: maxNameLength);

/// Token field; never prefilled (ONB-031).
FieldSpec tokenField(AppLocalizations l10n) => FieldSpec(
  'token',
  l10n.fieldApiToken,
  secret: true,
  helper: l10n.tokenHint,
);

/// Object Storage fields: location, and the keys once one is picked.
List<FieldSpec> s3Fields(
  AppLocalizations l10n, {
  required bool optional,
  String location = '',
}) => [
  FieldSpec(
    's3',
    l10n.fieldS3Location,
    initial: location,
    helper: l10n.s3Hint,
    options: {if (optional) '': l10n.s3None, for (final l in s3Locations) l: l},
  ),
  if (location.isNotEmpty || !optional) ...[
    FieldSpec('accessKey', l10n.fieldAccessKey, secret: true),
    FieldSpec('secretKey', l10n.fieldSecretKey, secret: true),
  ],
];

/// Robot fields.
List<FieldSpec> robotFields(AppLocalizations l10n) => [
  FieldSpec('robotUser', l10n.fieldRobotUser, helper: l10n.robotHint),
  FieldSpec('robotPassword', l10n.fieldRobotPassword, secret: true),
];

/// Checks a Cloud token against the API (ONB-017).
Future<void> checkToken(ProviderContainer ref, String token) =>
    checkCloudToken(ref.read(cloudDioProvider)(bearerAuth(token.trim())));

/// S3 credentials from form [values], null when no location is picked.
S3Credentials? s3FromValues(Map<String, String> values) {
  final location = _v(values, 's3');
  return location.isEmpty
      ? null
      : s3Credentials(
          location: location,
          accessKey: _v(values, 'accessKey'),
          secretKey: _v(values, 'secretKey'),
        );
}

/// Checks S3 keys with ListBuckets.
Future<void> checkS3Keys(ProviderContainer ref, S3Credentials c) =>
    checkS3(ref.read(s3DioProvider)(c));

/// Robot credentials from form [values].
RobotCredentials robotFromValues(Map<String, String> values) =>
    RobotCredentials(
      user: _v(values, 'robotUser'),
      password: _v(values, 'robotPassword'),
    );

/// Checks Robot credentials (ONB-039).
Future<void> checkRobotLogin(ProviderContainer ref, RobotCredentials c) =>
    checkRobot(ref.read(robotDioProvider)(basicAuth(c.user, c.password)));

/// Adds the secrets of a checked project draft to [changes] and returns
/// the project. Secrets go first: an account never points at a project
/// without them.
Project storeProject(SecretChanges changes, Map<String, String> values) {
  final project = Project(id: newId(), name: _v(values, 'name'));
  changes.cloudToken(project.id, _v(values, 'token'));
  if (s3FromValues(values) case final s3?) changes.s3(project.id, s3);
  return project;
}

/// Runs [check]; a failure is reported with the access it belongs to.
Future<void> _labelled(
  String label,
  Future<void> Function() check,
  AppLocalizations l10n,
) async {
  try {
    await check();
  } on FalcoError catch (e) {
    throw _LabelledError(label, errorText(e, l10n));
  }
}

class _LabelledError implements Exception {
  const new(this.label, this.message);
  final String label;
  final String message;

  @override
  String toString() => '$label: $message';
}

/// Adds a Cloud project to account [accountId]: project, Object Storage,
/// summary. Token and keys are checked before anything is stored
/// (ONB-017, ONB-030).
class ProjectSetupPage extends ConsumerStatefulWidget {
  const new({required this.accountId, super.key});

  /// The account.
  final String accountId;

  @override
  ConsumerState<ProjectSetupPage> createState() => _ProjectSetupPageState();
}

class _ProjectSetupPageState extends ConsumerState<ProjectSetupPage> {
  var _values = <String, String>{};
  bool _saving = false;
  String? _error;

  Future<void> _save() async {
    // Locked while running, so a double tap saves once (ONB-018).
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final l10n = AppLocalizations.of(context);
    // Read before the first await, so leaving the page cannot stop the
    // save half way.
    final container = ProviderScope.containerOf(context, listen: false);
    try {
      final repo = container.read(scopeRepositoryProvider);
      final account = (await repo.accounts())
          .where((a) => a.id == widget.accountId)
          .firstOrNull;
      if (account == null) throw const NotFound();
      await _labelled(
        l10n.projectStep,
        () => checkToken(container, _v(_values, 'token')),
        l10n,
      );
      if (s3FromValues(_values) case final s3?) {
        await _labelled(l10n.s3Step, () => checkS3Keys(container, s3), l10n);
      }
      late final Project project;
      await container
          .read(secretStoreProvider)
          .apply((c) => project = storeProject(c, _values));
      await repo.save(
        account.copyWith(projects: [...account.projects, project]),
      );
      container.invalidate(accountsProvider);
      if (!mounted) return;
      ProjectRoute(accountId: account.id, projectId: project.id).go(context);
    } on _LabelledError catch (e) {
      if (mounted) setState(() => _error = '$e');
    } on FalcoError catch (e) {
      if (mounted) setState(() => _error = errorText(e, l10n));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final s3 = _v(_values, 's3');
    return CreateWizard(
      title: l10n.projectAdd,
      createLabel: l10n.tokenCheckSave,
      creating: _saving,
      onCreate: _save,
      // The only route of an account without projects and Robot.
      onLeave: () => AccountRoute(accountId: widget.accountId).go(context),
      steps: [
        WizardStep(
          title: l10n.projectStep,
          canContinue:
              validName(_values['name']) && _v(_values, 'token').isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormFields(
                fields: [nameField(l10n.fieldProjectName), tokenField(l10n)],
                values: _values,
                onChanged: (v) => setState(() => _values = {..._values, ...v}),
              ),
              LinkButton(label: l10n.cloudOpenConsole, url: cloudTokensUrl),
            ],
          ),
        ),
        WizardStep(
          title: l10n.s3Step,
          canContinue: validS3(_values),
          child: FormFields(
            fields: s3Fields(l10n, optional: true, location: s3),
            values: _values,
            onChanged: (v) => setState(() => _values = {..._values, ...v}),
          ),
        ),
      ],
      summary: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: FalcoSpacing.m,
        children: [
          if (_error case final error?) ErrorBanner(message: error),
          FactRows([
            ConfirmFact(l10n.fieldProjectName, _v(_values, 'name')),
            ConfirmFact(l10n.fieldApiToken, l10n.tokenHidden),
            ConfirmFact(l10n.fieldS3Location, s3.isEmpty ? l10n.s3None : s3),
          ]),
        ],
      ),
    );
  }
}

/// New account: name, services, Cloud projects, Robot, summary, done
/// (ONB-007 to ONB-020). Every access is checked before anything is
/// stored.
class AccountWizardPage extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AccountWizardPage> createState() => _AccountWizardPageState();
}

class _AccountWizardPageState extends ConsumerState<AccountWizardPage> {
  var _account = <String, String>{};
  var _robot = <String, String>{};
  final _projects = <Map<String, String>>[];
  bool _cloud = true;
  bool _hasRobot = false;
  bool _saving = false;
  String? _error;
  Account? _done;

  Future<void> _addProject() async {
    final l10n = AppLocalizations.of(context);
    Map<String, String>? added;
    await FormSheet.show(
      context,
      title: l10n.projectAdd,
      fields: (v) => [
        nameField(l10n.fieldProjectName),
        tokenField(l10n),
        ...s3Fields(l10n, optional: true, location: _v(v, 's3')),
      ],
      valid: validProject,
      onSave: (v) async => added = v,
    );
    if (added case final p?) setState(() => _projects.add(p));
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final l10n = AppLocalizations.of(context);
    // Read before the first await, so leaving the page cannot stop the
    // save half way.
    final container = ProviderScope.containerOf(context, listen: false);
    try {
      final projects = _cloud ? _projects : const <Map<String, String>>[];
      for (final p in projects) {
        final name = _v(p, 'name');
        await _labelled(
          name,
          () => checkToken(container, _v(p, 'token')),
          l10n,
        );
        if (s3FromValues(p) case final s3?) {
          await _labelled(
            '$name, ${l10n.s3Step}',
            () => checkS3Keys(container, s3),
            l10n,
          );
        }
      }
      if (_hasRobot) {
        await _labelled(
          l10n.scopeRobot,
          () => checkRobotLogin(container, robotFromValues(_robot)),
          l10n,
        );
      }
      final id = newId();
      // One vault write for all secrets: one system check.
      final stored = <Project>[];
      await container.read(secretStoreProvider).apply((c) {
        stored.addAll([for (final p in projects) storeProject(c, p)]);
        if (_hasRobot) c.robot(id, robotFromValues(_robot));
      });
      final account = Account(
        id: id,
        name: _v(_account, 'name'),
        description: _v(_account, 'description'),
        projects: stored,
        hasRobot: _hasRobot,
      );
      await container.read(scopeRepositoryProvider).save(account);
      container.invalidate(accountsProvider);
      if (mounted) setState(() => _done = account);
    } on _LabelledError catch (e) {
      if (mounted) setState(() => _error = '$e');
    } on FalcoError catch (e) {
      if (mounted) setState(() => _error = errorText(e, l10n));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_done case final account?) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: ActionHint(
              message: l10n.accountDone(account.name),
              actionLabel: l10n.accountOpen,
              onAction: () => scopeRoute(firstScope(account)!).go(context),
            ),
          ),
        ),
      );
    }
    final steps = [
      WizardStep(
        title: l10n.accountStep,
        canContinue: validName(_account['name']),
        child: FormFields(
          fields: [
            nameField(l10n.fieldAccountName),
            FieldSpec(
              'description',
              l10n.fieldDescription,
              maxLength: maxNameLength * 2,
            ),
          ],
          values: _account,
          onChanged: (v) => setState(() => _account = v),
        ),
      ),
      WizardStep(
        title: l10n.servicesStep,
        canContinue: _cloud || _hasRobot,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CheckboxListTile(
              value: _cloud,
              onChanged: (v) => setState(() => _cloud = v!),
              title: Text(l10n.serviceCloud),
              subtitle: Text(l10n.serviceCloudHint),
            ),
            CheckboxListTile(
              value: _hasRobot,
              onChanged: (v) => setState(() => _hasRobot = v!),
              title: Text(l10n.scopeRobot),
              subtitle: Text(l10n.serviceRobotHint),
            ),
            if (!_cloud && !_hasRobot)
              ErrorBanner(message: l10n.servicesPickOne),
          ],
        ),
      ),
      if (_cloud)
        WizardStep(
          title: l10n.projectsStep,
          canContinue: _projects.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (i, p) in _projects.indexed)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.cloud_outlined),
                  title: Text(_v(p, 'name')),
                  subtitle: Text(_projectLine(p, l10n)),
                  trailing: IconButton(
                    tooltip: l10n.projectRemoveDraft(_v(p, 'name')),
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _projects.removeAt(i)),
                  ),
                ),
              OutlinedButton.icon(
                onPressed: _addProject,
                icon: const Icon(Icons.add),
                label: Text(l10n.projectAdd),
              ),
              LinkButton(label: l10n.cloudOpenConsole, url: cloudTokensUrl),
            ],
          ),
        ),
      if (_hasRobot)
        WizardStep(
          title: l10n.robotStep,
          canContinue: validRobot(_robot),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormFields(
                fields: robotFields(l10n),
                values: _robot,
                onChanged: (v) => setState(() => _robot = v),
              ),
              LinkButton(label: l10n.robotOpenSettings, url: robotSettingsUrl),
            ],
          ),
        ),
    ];
    int stepOf(String title) => steps.indexWhere((s) => s.title == title);
    return CreateWizard(
      title: l10n.accountAdd,
      createLabel: l10n.tokenCheckSave,
      creating: _saving,
      onCreate: _save,
      steps: steps,
      summary: Builder(
        builder: (context) {
          Widget section(String title, List<ConfirmFact> facts) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title.toUpperCase(),
                      style: FalcoText.of(context).sectionLabel,
                    ),
                  ),
                  TextButton(
                    onPressed: () => CreateWizard.goTo(context, stepOf(title)),
                    child: Text(l10n.commonEdit),
                  ),
                ],
              ),
              FactRows(facts),
            ],
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: FalcoSpacing.m,
            children: [
              if (_error case final error?) ErrorBanner(message: error),
              section(l10n.accountStep, [
                ConfirmFact(l10n.fieldAccountName, _v(_account, 'name')),
                if (_v(_account, 'description') case final d when d.isNotEmpty)
                  ConfirmFact(l10n.fieldDescription, d),
              ]),
              if (_cloud)
                section(l10n.projectsStep, [
                  for (final p in _projects)
                    ConfirmFact(_v(p, 'name'), _projectLine(p, l10n)),
                ]),
              if (_hasRobot)
                section(l10n.robotStep, [
                  ConfirmFact(
                    l10n.fieldRobotUser,
                    _v(_robot, 'robotUser'),
                    mono: true,
                  ),
                  ConfirmFact(l10n.fieldRobotPassword, l10n.tokenHidden),
                ]),
            ],
          );
        },
      ),
    );
  }
}

/// "Token hidden · S3 fsn1" for a project draft (ONB-016).
String _projectLine(Map<String, String> p, AppLocalizations l10n) {
  final s3 = _v(p, 's3');
  return [
    '${l10n.fieldApiToken} ${l10n.tokenHidden}',
    if (s3.isNotEmpty) 'S3 $s3',
  ].join(' · ');
}

/// The first scope of [account]: its first project, else Robot.
Scope? firstScope(Account account) => switch (account) {
  Account(projects: [final p, ...]) => ProjectScope(account.id, p.id),
  Account(hasRobot: true) => RobotScope(account.id),
  _ => null,
};

/// Name of project [projectId], empty while the accounts load.
String projectName(List<Account>? accounts, String projectId) =>
    accounts
        ?.expand((a) => a.projects)
        .where((p) => p.id == projectId)
        .firstOrNull
        ?.name ??
    '';
