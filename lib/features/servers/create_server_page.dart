// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/compute/catalog.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/images/images.dart';
import 'package:falco/features/network/firewalls.dart';
import 'package:falco/features/network/ips.dart';
import 'package:falco/features/network/networks.dart';
import 'package:falco/features/placement_groups/placement_groups.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/features/ssh_keys/ssh_keys.dart';
import 'package:falco/features/volumes/volumes.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:material_ui/material_ui.dart';

/// "2 vCPU · 4 GiB · 40 GiB" for a server type.
String typeSpecs(ServerType t, AppLocalizations l10n) => [
  l10n.vcpuCount(t.cores),
  gb(t.memoryGb, l10n.localeName),
  gb(t.diskGb, l10n.localeName),
].join(' · ');

/// Images a server of [architecture] can boot: system images first, then
/// own snapshots and backups; deprecated ones marked (CMP-031, CMP-077).
({Map<String, String> options, Map<String, String> details}) bootImages(
  List<CloudImage> images,
  String architecture,
  AppLocalizations l10n,
) {
  final usable = [
    for (final i in images)
      if (i.architecture == architecture && i.kind != ImageKind.app) i,
  ]..sort((a, b) => a.kind.index.compareTo(b.kind.index));
  return (
    options: {for (final i in usable) '${i.id}': i.description},
    details: {
      for (final i in usable)
        '${i.id}': [
          switch (i.kind) {
            ImageKind.system => l10n.imageSystem,
            ImageKind.app => l10n.imageApp,
            ImageKind.snapshot => l10n.imageSnapshot,
            ImageKind.backup => l10n.imageBackup,
          },
          if (i.sizeGb case final size?) gb(size, l10n.localeName),
          if (i.deprecated) l10n.deprecated,
        ].join(' · '),
    },
  );
}

/// Create a server: location, type with price, image, SSH keys,
/// networking, volumes and placement group, details, summary
/// (CMP-008 to CMP-014, CMP-081 to CMP-086).
class CreateServerPage extends ConsumerStatefulWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  ConsumerState<CreateServerPage> createState() => _CreateServerPageState();
}

class _CreateServerPageState extends ConsumerState<CreateServerPage> {
  String? _project;
  String _location = '';
  String _type = '';
  String _image = '';
  Set<String> _sshKeys = {};
  Set<String> _networks = {};
  Set<String> _firewalls = {};
  Set<String> _volumes = {};
  bool _ipv4 = true;
  bool _ipv6 = true;

  /// Existing Primary IP ids; empty creates new ones (CMP-085).
  String _ipv4Id = '';
  String _ipv6Id = '';
  bool _automount = true;
  bool _start = true;
  String _group = '';
  String _userData = '';
  var _values = <String, String>{};
  bool _creating = false;

  List<int> _ids(Set<String> s) => [for (final v in s) int.parse(v)];

  Future<void> _create(ProjectScope scope) async {
    // Locked while running, so a double tap creates once (CMP-013).
    if (_creating) return;
    setState(() => _creating = true);
    final l10n = AppLocalizations.of(context);
    // Read before the first await: the page may be gone when it returns,
    // the one time root password must still be shown (root navigator).
    final api = ref.read(cloudApiProvider(scope.projectId));
    final tracker = ref.read(actionTrackerProvider(scope));
    final container = ProviderScope.containerOf(context, listen: false);
    final navigator = Navigator.of(context, rootNavigator: true);
    try {
      final r = await createServer(
        api,
        ServerDraft(
          name: _values['name']!.trim(),
          location: _location,
          type: _type,
          image: _image,
          sshKeys: _ids(_sshKeys),
          networks: _ids(_networks),
          firewalls: _ids(_firewalls),
          volumes: _ids(_volumes),
          automount: _automount,
          placementGroup: int.tryParse(_group),
          ipv4: _ipv4,
          ipv6: _ipv6,
          ipv4Id: int.tryParse(_ipv4Id),
          ipv6Id: int.tryParse(_ipv6Id),
          userData: _userData,
          labels: parseLabels(_values['labels'] ?? '') ?? const {},
          startAfterCreate: _start,
        ),
      );
      r.actions.forEach(tracker.track);
      refreshResource(container.invalidate, scope, CloudType.server, r.id);
      if (r.rootPassword case final password? when navigator.mounted) {
        await showSecretSheet(
          navigator.context,
          title: l10n.rootPasswordTitle,
          note: l10n.rootPasswordNote,
          secrets: {l10n.fieldRootPassword: password},
        );
      }
      if (!mounted) return;
      ServerRoute(
        accountId: scope.accountId,
        projectId: scope.projectId,
        serverId: r.id,
      ).pushReplacement(context);
    } on FalcoError catch (e) {
      if (mounted) {
        FalcoScaffold.showSnack(context, errorText(e, l10n));
        setState(() => _creating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = targetScope(widget.scope, _project);
    // Options of the target project; empty until a project is picked.
    List<T> load<T>(
      ProviderListenable<AsyncValue<List<T>>> Function(ProjectScope) p,
    ) => scope == null ? <T>[] : ref.watch(p(scope)).value ?? <T>[];

    final locations = load(locationsProvider.call);
    final types = [
      for (final t in load(serverTypesProvider.call))
        if (t.prices.containsKey(_location) && !t.deprecated) t,
    ];
    final type = types.where((t) => t.name == _type).firstOrNull;
    final pricing = scope == null
        ? null
        : ref.watch(pricingProvider(scope)).value;
    final currency = pricing?.currency ?? 'EUR';
    String price(ServerType t) => l10n.perMonth(
      formatMoney(t.prices[_location] ?? 0, currency, l10n.localeName),
    );
    final images = bootImages(
      load(imagesProvider.call),
      type?.architecture ?? 'x86',
      l10n,
    );
    final keys = load(sshKeysProvider.call);
    final networks = load(networksProvider.call);
    final firewalls = load(firewallsProvider.call);
    final volumes = [
      for (final v in load(volumesProvider.call))
        if (v.server == null && v.location == _location) v,
    ];
    final groups = load(placementGroupsProvider.call);
    // Free Primary IPs in the location, to use instead of new ones.
    Map<String, String> freeIps({required bool v6}) => {
      '': l10n.primaryIpNew,
      for (final ip
          in scope == null
              ? const <PublicIp>[]
              : ref.watch(publicIpsProvider(scope, IpKind.primary)).value ??
                    const <PublicIp>[])
        if (ip.server == null && ip.ipv6 == v6 && ip.location == _location)
          '${ip.id}': '${ip.name} · ${formatIp(ip.ip)}',
    };
    final free4 = freeIps(v6: false);
    final free6 = freeIps(v6: true);
    String names(Map<String, String> options, Set<String> picked) =>
        picked.isEmpty
        ? l10n.commonNone
        : [for (final p in picked) options[p] ?? p].join(', ');
    final keyNames = {for (final k in keys) '${k.id}': k.name};
    final netNames = {for (final n in networks) '${n.id}': n.name};
    final fwNames = {for (final f in firewalls) '${f.id}': f.name};
    final volNames = {
      for (final v in volumes)
        '${v.id}': '${v.name} · ${gb(v.sizeGb, l10n.localeName)}',
    };
    final groupNames = {
      '': l10n.commonNone,
      for (final g in groups) '${g.id}': g.name,
    };

    return CreateWizard(
      title: l10n.actionCreateServer,
      creating: _creating,
      onCreate: scope == null ? null : () => _create(scope),
      projectStep: projectStep(
        ref,
        l10n,
        widget.scope,
        _project,
        (p) => setState(() {
          _project = p;
          _location = _type = _image = '';
          _sshKeys = _networks = _firewalls = _volumes = {};
          _group = '';
        }),
      ),
      steps: [
        WizardStep(
          title: l10n.fieldLocation,
          canContinue: _location.isNotEmpty,
          child: ChoiceList(
            options: {for (final l in locations) l.name: l.name},
            details: {for (final l in locations) l.name: l.detail},
            selected: _location,
            onSelected: (v) => setState(() {
              _location = v;
              _type = _ipv4Id = _ipv6Id = '';
              _volumes = {};
            }),
          ),
        ),
        WizardStep(
          title: l10n.fieldType,
          canContinue: type != null,
          child: ChoiceList(
            options: {for (final t in types) t.name: t.name.toUpperCase()},
            details: {
              for (final t in types)
                t.name: '${typeSpecs(t, l10n)} · ${price(t)}',
            },
            selected: _type,
            onSelected: (v) => setState(() {
              _type = v;
              _image = '';
            }),
          ),
        ),
        WizardStep(
          title: l10n.fieldImage,
          canContinue: images.options.containsKey(_image),
          child: ChoiceList(
            options: images.options,
            details: images.details,
            selected: _image,
            searchable: true,
            onSelected: (v) => setState(() => _image = v),
          ),
        ),
        WizardStep(
          title: l10n.resourceSshKeys,
          child: keys.isEmpty
              ? Text(l10n.serverNoSshKeys)
              : MultiChoiceList(
                  options: keyNames,
                  details: {for (final k in keys) '${k.id}': k.fingerprint},
                  selected: _sshKeys,
                  onChanged: (v) => setState(() => _sshKeys = v),
                ),
        ),
        WizardStep(
          title: l10n.wizardNetworking,
          canContinue: _ipv4 || _ipv6 || _networks.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: Text(l10n.publicIpv4),
                value: _ipv4,
                onChanged: (v) => setState(() => _ipv4 = v),
              ),
              if (_ipv4 && free4.length > 1)
                ChoiceList(
                  options: free4,
                  selected: _ipv4Id,
                  onSelected: (v) => setState(() => _ipv4Id = v),
                ),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: Text(l10n.publicIpv6),
                value: _ipv6,
                onChanged: (v) => setState(() => _ipv6 = v),
              ),
              if (_ipv6 && free6.length > 1)
                ChoiceList(
                  options: free6,
                  selected: _ipv6Id,
                  onSelected: (v) => setState(() => _ipv6Id = v),
                ),
              _Heading(l10n.resourceNetworks),
              if (networks.isEmpty) Text(l10n.commonNone),
              MultiChoiceList(
                options: netNames,
                details: {for (final n in networks) '${n.id}': n.ipRange},
                selected: _networks,
                onChanged: (v) => setState(() => _networks = v),
              ),
              _Heading(l10n.resourceFirewalls),
              if (firewalls.isEmpty) Text(l10n.commonNone),
              MultiChoiceList(
                options: fwNames,
                selected: _firewalls,
                onChanged: (v) => setState(() => _firewalls = v),
              ),
            ],
          ),
        ),
        WizardStep(
          title: l10n.wizardExtras,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Heading(l10n.resourceVolumes),
              if (volumes.isEmpty) Text(l10n.serverNoVolumes(_location)),
              MultiChoiceList(
                options: volNames,
                selected: _volumes,
                onChanged: (v) => setState(() => _volumes = v),
              ),
              if (_volumes.isNotEmpty)
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  title: Text(l10n.volumeAutomount),
                  value: _automount,
                  onChanged: (v) => setState(() => _automount = v),
                ),
              _Heading(l10n.resourcePlacementGroup),
              ChoiceList(
                options: groupNames,
                selected: _group,
                onSelected: (v) => setState(() => _group = v),
              ),
            ],
          ),
        ),
        WizardStep(
          title: l10n.wizardDetails,
          canContinue:
              (_values['name'] ?? '').trim().isNotEmpty && validLabels(_values),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: FalcoSpacing.l,
            children: [
              FormFields(
                fields: [
                  FieldSpec('name', l10n.fieldName, maxLength: 63),
                  labelsField(l10n),
                ],
                values: _values,
                onChanged: (v) => setState(() => _values = {..._values, ...v}),
              ),
              TextFormField(
                key: const ValueKey('userData'),
                initialValue: _userData,
                minLines: 3,
                maxLines: 8,
                autocorrect: false,
                style: FalcoText.of(context).mono,
                onChanged: (v) => setState(() => _userData = v),
                decoration: InputDecoration(
                  labelText: l10n.fieldUserData,
                  helperText: l10n.userDataHint,
                ),
              ),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: Text(l10n.startAfterCreate),
                value: _start,
                onChanged: (v) => setState(() => _start = v),
              ),
            ],
          ),
        ),
      ],
      summary: FactRows([
        ConfirmFact(l10n.fieldName, (_values['name'] ?? '').trim()),
        ConfirmFact(l10n.fieldLocation, _location),
        if (type != null)
          ConfirmFact(
            l10n.fieldType,
            '${type.name.toUpperCase()} · ${typeSpecs(type, l10n)}',
          ),
        ConfirmFact(l10n.fieldImage, images.options[_image] ?? ''),
        ConfirmFact(l10n.resourceSshKeys, names(keyNames, _sshKeys)),
        ConfirmFact(
          l10n.wizardNetworking,
          [
            if (_ipv4)
              if (_ipv4Id.isEmpty)
                l10n.publicIpv4
              else
                '${l10n.publicIpv4} (${free4[_ipv4Id]})',
            if (_ipv6)
              if (_ipv6Id.isEmpty)
                l10n.publicIpv6
              else
                '${l10n.publicIpv6} (${free6[_ipv6Id]})',
            ..._networks.map((n) => netNames[n] ?? n),
          ].join(', '),
        ),
        ConfirmFact(l10n.resourceFirewalls, names(fwNames, _firewalls)),
        ConfirmFact(l10n.resourceVolumes, names(volNames, _volumes)),
        ConfirmFact(l10n.resourcePlacementGroup, groupNames[_group] ?? ''),
        ConfirmFact(
          l10n.fieldLabels,
          labelsText(parseLabels(_values['labels'] ?? '') ?? const {}, l10n),
        ),
        ConfirmFact(
          l10n.fieldUserData,
          yesNo(_userData.trim().isNotEmpty, l10n),
        ),
        ConfirmFact(l10n.startAfterCreate, yesNo(_start, l10n)),
        if (type != null) ConfirmFact(l10n.fieldPrice, price(type)),
        if (_sshKeys.isEmpty)
          ConfirmFact(l10n.fieldRootPassword, l10n.rootPasswordAfter),
      ]),
    );
  }
}

class _Heading extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: FalcoSpacing.l, bottom: FalcoSpacing.s),
    child: Text(text.toUpperCase(), style: FalcoText.of(context).sectionLabel),
  );
}
