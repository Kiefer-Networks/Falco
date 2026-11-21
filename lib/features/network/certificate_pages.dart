// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/activity/activity_page.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/network/certificates.dart';
import 'package:falco/features/network/load_balancers.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

String _type(Certificate c, AppLocalizations l10n) =>
    c.managed ? l10n.certificateManaged : l10n.certificateUploaded;

String _expiry(Certificate c, AppLocalizations l10n) => switch (c.validUntil) {
  final u? => l10n.certificateValidUntil(formatDateTime(u, l10n.localeName)),
  null => l10n.certificatePending,
};

/// Certificates of a scope: name, type, domains, expiry (NET-079).
class CertificateList extends ConsumerWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = certificatesProvider(scope);
    final async = ref.watch(provider);
    final accounts = scope is AllProjectsScope
        ? ref.watch(accountsProvider).value
        : null;
    final now = DateTime.now();
    return ResourceList<Certificate>(
      title: l10n.resourceCertificates,
      items: async.value,
      loading: async.isLoading,
      error: async.hasError
          ? errorText(toFalcoError(async.error!), l10n)
          : null,
      onRefresh: () => refreshQuietly(ref, provider.future),
      empty: EmptyHint(
        message: l10n.emptyCertificates,
        actionLabel: l10n.certificateCreate,
        onAction: () =>
            CreateRoute.of(scope, CreateKind.certificate).push<void>(context),
      ),
      searchText: (c) => '${c.name} ${c.domains.join(' ')}',
      sorts: [
        ResourceSort(l10n.sortName, (a, b) => a.name.compareTo(b.name)),
        ResourceSort(
          l10n.sortExpiry,
          (a, b) => (a.validUntil ?? DateTime(9999)).compareTo(
            b.validUntil ?? DateTime(9999),
          ),
        ),
      ],
      itemBuilder: (context, c) => ResourceRow(
        status: c.status(now),
        name: c.name,
        monoLine: [
          _type(c, l10n),
          c.domains.join(', '),
          _expiry(c, l10n),
          if (accounts != null) projectName(accounts, c.projectId),
        ].where((s) => s.isNotEmpty).join(' · '),
        onTap: () => CertificateRoute(
          accountId: scope.accountId,
          projectId: c.projectId,
          certificateId: c.id,
        ).push<void>(context),
      ),
    );
  }
}

/// One certificate: details, edit, retry, delete (NET-082 to NET-085,
/// NET-090).
class CertificateDetailPage extends ConsumerWidget {
  const new({required this.scope, required this.certificateId, super.key});

  final ProjectScope scope;
  final int certificateId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = certificateProvider(scope, certificateId);
    final async = ref.watch(provider);
    final c = async.value;
    if (c == null) {
      return DetailLoading(
        title: l10n.resourceCertificate,
        error: async.error,
        onRetry: () => ref.invalidate(provider),
      );
    }
    final t = (
      scope: scope,
      type: CloudType.certificate,
      id: c.id,
      name: c.name,
    );
    final progress = ref
        .watch(trackedActionProvider(scope, CloudType.certificate, c.id))
        .value;
    final busy = progress != null && !progress.done;
    final lbs = {
      for (final l
          in ref.watch(loadBalancersProvider(scope)).value ??
              const <LoadBalancer>[])
        l.id: l.name,
    };
    String? status(String? s) => switch (s) {
      null => null,
      'pending' => l10n.certificatePending,
      'failed' => l10n.statusFailed,
      'completed' => l10n.statusDone,
      final other => other,
    };
    return FalcoScaffold(
      title: l10n.resourceCertificate,
      body: DetailPage(
        status: busy ? ResourceStatus.inProgress : c.status(DateTime.now()),
        statusDetail: busy ? '${progress.progress} %' : _expiry(c, l10n),
        name: c.name,
        ids: [_type(c, l10n), ...c.domains],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          ActionTile(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            onTap: () => editNameAndLabels(
              context,
              ref,
              t,
              c.labels,
              (api, name, labels) =>
                  updateCertificate(api, c.id, name: name, labels: labels),
            ),
          ),
          if (c.managed)
            ActionTile(
              icon: Icons.refresh,
              label: l10n.certificateRetry,
              onTap: c.failed && !busy
                  ? () => runAction(
                      context,
                      ref,
                      scope,
                      (api) => retryCertificate(api, c.id),
                    )
                  : null,
            ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionOverview,
            child: FactRows([
              ConfirmFact(l10n.fieldType, _type(c, l10n)),
              ConfirmFact(l10n.fieldDomains, c.domains.join('\n')),
              if (c.validFrom case final d?)
                ConfirmFact(
                  l10n.fieldValidFrom,
                  formatDateTime(d, l10n.localeName),
                ),
              if (c.validUntil case final d?)
                ConfirmFact(
                  l10n.fieldValidUntil,
                  formatDateTime(d, l10n.localeName),
                ),
              if (c.fingerprint case final f?)
                ConfirmFact(l10n.fieldFingerprint, f, mono: true),
              if (status(c.issuance) case final s?)
                ConfirmFact(l10n.fieldIssuance, s),
              if (status(c.renewal) case final s?)
                ConfirmFact(l10n.fieldRenewal, s),
              if (c.error case final e?) ConfirmFact(l10n.errorTitle, e),
              ConfirmFact(
                l10n.fieldCreated,
                formatDateTime(c.created, l10n.localeName),
              ),
              ConfirmFact(l10n.fieldLabels, labelsText(c.labels, l10n)),
            ]),
          ),
          DetailSection(
            title: l10n.sectionUsedBy,
            child: entries([
              for (final id in c.usedBy)
                EntryRow(
                  leading: const Icon(Icons.balance),
                  title: lbs[id] ?? '#$id',
                  onTap: () => LoadBalancerRoute(
                    accountId: scope.accountId,
                    projectId: scope.projectId,
                    lbId: id,
                  ).push<void>(context),
                ),
            ], l10n.certificateUnused),
          ),
          activitySection(l10n, scope, CloudType.certificate, c.id),
        ],
        dangerZone: [
          DeleteButton(
            onPressed: () => deleteResource(
              context,
              ref,
              t,
              l10n.certificateDeleteConsequence,
              (api) => deleteCertificate(api, c.id),
            ),
          ),
        ],
      ),
    );
  }
}

/// Upload a certificate or order a managed one (NET-080, NET-081).
class CreateCertificatePage extends ConsumerStatefulWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  ConsumerState<CreateCertificatePage> createState() =>
      _CreateCertificatePageState();
}

class _CreateCertificatePageState extends ConsumerState<CreateCertificatePage> {
  String? _project;
  bool _managed = true;
  var _values = <String, String>{};
  bool _creating = false;

  bool get _valid {
    final v = _values;
    if ((v['name'] ?? '').trim().isEmpty || !validLabels(v)) return false;
    return _managed
        ? splitDomains(v['domains'] ?? '').isNotEmpty
        : looksLikePem(v['certificate'] ?? '') &&
              looksLikePem(v['key'] ?? '', key: true);
  }

  Future<void> _create(ProjectScope scope) async {
    if (_creating) return;
    setState(() => _creating = true);
    final l10n = AppLocalizations.of(context);
    final name = _values['name']!.trim();
    final ok = await runChange(
      context,
      ref,
      (scope: scope, type: CloudType.certificate, id: 0, name: name),
      (api) async {
        final r = await createCertificate(
          api,
          name: name,
          domains: _managed ? splitDomains(_values['domains'] ?? '') : const [],
          certificate: _managed ? '' : _values['certificate'] ?? '',
          privateKey: _managed ? '' : _values['key'] ?? '',
          labels: parseLabels(_values['labels'] ?? '') ?? const {},
        );
        if (r.action case final a?) {
          ref.read(actionTrackerProvider(scope)).track(a);
        }
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
    return CreateWizard(
      title: l10n.certificateCreate,
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
          title: l10n.fieldType,
          child: ChoiceList(
            options: {
              'managed': l10n.certificateManaged,
              'uploaded': l10n.certificateUploaded,
            },
            details: {
              'managed': l10n.certificateManagedHint,
              'uploaded': l10n.certificateUploadedHint,
            },
            selected: _managed ? 'managed' : 'uploaded',
            onSelected: (v) => setState(() => _managed = v == 'managed'),
          ),
        ),
        WizardStep(
          title: l10n.wizardDetails,
          canContinue: _valid,
          child: FormFields(
            fields: [
              FieldSpec('name', l10n.fieldName, maxLength: 63),
              if (_managed)
                FieldSpec(
                  'domains',
                  l10n.fieldDomains,
                  helper: l10n.domainsHint,
                )
              else ...[
                FieldSpec(
                  'certificate',
                  l10n.fieldCertificatePem,
                  multiline: true,
                  helper: l10n.certificatePemHint,
                ),
                FieldSpec(
                  'key',
                  l10n.fieldPrivateKeyPem,
                  secret: true,
                  multiline: true,
                  helper: l10n.privateKeyPemHint,
                ),
              ],
              labelsField(l10n),
            ],
            values: _values,
            onChanged: (v) => setState(() => _values = {..._values, ...v}),
          ),
        ),
      ],
      summary: FactRows([
        ConfirmFact(l10n.fieldName, (_values['name'] ?? '').trim()),
        ConfirmFact(
          l10n.fieldType,
          _managed ? l10n.certificateManaged : l10n.certificateUploaded,
        ),
        if (_managed)
          ConfirmFact(
            l10n.fieldDomains,
            splitDomains(_values['domains'] ?? '').join(', '),
          ),
      ]),
    );
  }
}
