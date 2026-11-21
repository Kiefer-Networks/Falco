// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/areas.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/compute/catalog.dart';
import 'package:falco/features/images/images.dart';
import 'package:falco/features/placement_groups/placement_groups.dart';
import 'package:falco/features/servers/create_server_page.dart';
import 'package:falco/features/servers/server_actions.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/features/ssh_keys/ssh_keys.dart';
import 'package:falco/features/storage/object_storage.dart';
import 'package:falco/features/storage/storage_boxes.dart';
import 'package:falco/features/volumes/volume_pages.dart';
import 'package:falco/features/volumes/volumes.dart';
import 'package:falco/l10n/app_localizations_en.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';
import '../helpers.dart' show testApp;
import '../steps.dart';

const _scope = ProjectScope('a1', 'p1');

Future<FakeCloud> openTab(
  WidgetTester tester,
  String tab, {
  FakeCloud? cloud,
}) async {
  final c = cloud ?? FakeCloud();
  setSurface(tester);
  await pumpFalco(tester, c);
  await tester.tap(find.text(tab));
  await tester.pumpAndSettle();
  return c;
}

Future<void> typeName(WidgetTester tester, String name) async {
  await tester.enterText(find.byKey(const ValueKey('confirm-name')), name);
  await tester.pumpAndSettle();
}

void main() {
  group('volumes', () {
    FakeCloud withVolumes() => FakeCloud(
      volumes: [
        volumeJson(id: 31, name: 'data', server: 1),
        volumeJson(id: 32, name: 'spare', size: 10),
      ],
    );

    testWidgets('CMP-050 list with size, location and server', (tester) async {
      await openTab(tester, 'Volumes', cloud: withVolumes());
      expect(find.text('50 GiB · fsn1 · web-1'), findsOneWidget);
      expect(
        find.text('10 GiB · fsn1 · Not attached to any server'),
        findsOneWidget,
      );
      await tap(tester, 'Not attached');
      expect(find.text('data'), findsNothing);
    });

    testWidgets('empty state, failed refresh banner', (tester) async {
      final cloud = await openTab(tester, 'Volumes');
      expect(find.text('No volumes in this project yet.'), findsOneWidget);
      cloud.failWith = (500, errorJson('server_error'));
      await tester.fling(
        find.text('No volumes in this project yet.'),
        const Offset(0, 400),
        1000,
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Could not refresh. Showing the last loaded data.'),
        findsOneWidget,
      );
    });

    testWidgets('CMP-051 CMP-052 CMP-053 CMP-054 CMP-055 CMP-056 create next '
        'to a server with presets, format, automount and price', (
      tester,
    ) async {
      final cloud = await openTab(tester, 'Volumes');
      await tap(tester, 'Create volume');
      await tap(tester, 'Next to web-1 (fsn1)');
      await tap(tester, 'Next');
      await tap(tester, '100 GiB');
      expect(
        find.text('€4.40/month gross, €4.40 net, €0.04 per GB'),
        findsOneWidget,
      );
      await tap(tester, 'Next');
      expect(find.text('Mount automatically'), findsOneWidget);
      await tap(tester, 'xfs');
      await tester.enterText(find.byKey(const ValueKey('name')), 'logs');
      await tester.pumpAndSettle();
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      expect(cloud.body('POST /volumes'), {
        'name': 'logs',
        'size': 100,
        'assignee': {'id': 1, 'type': 'server'},
        'automount': true,
        'format': 'xfs',
        'labels': <String, Object?>{},
      });
      await settleAction(tester);
      expect(find.text('logs'), findsOneWidget);
    });

    testWidgets('CMP-057 CMP-058 CMP-060 detail and detach', (tester) async {
      final cloud = await openTab(tester, 'Volumes', cloud: withVolumes());
      await tap(tester, 'data');
      expect(find.text('/dev/disk/by-id/scsi-0HC_Volume_31'), findsOneWidget);
      expect(find.text('web-1'), findsOneWidget);
      await tap(tester, 'Detach');
      expect(find.text('Detach data?'), findsOneWidget);
      await confirm(tester, 'Detach');
      expect(cloud.calls, contains('POST /volumes/31/actions/detach'));
      await settleAction(tester);
      expect(find.text('Not attached to any server'), findsOneWidget);
    });

    testWidgets('CMP-059 attach picks a server with automount', (tester) async {
      final cloud = await openTab(tester, 'Volumes', cloud: withVolumes());
      await tap(tester, 'spare');
      await tap(tester, 'Attach');
      await tap(tester, 'db-1');
      await tap(tester, 'Yes');
      await tap(tester, 'Save');
      expect(cloud.body('POST /volumes/32/actions/attach'), {
        'assignee': {'id': 2, 'type': 'server'},
        'automount': true,
      });
      await settleAction(tester);
    });

    testWidgets('CMP-061 CMP-062 CMP-063 CMP-088 resize, edit, protection', (
      tester,
    ) async {
      final cloud = await openTab(tester, 'Volumes', cloud: withVolumes());
      await tap(tester, 'spare');
      await tap(tester, 'Resize');
      await tester.enterText(find.byKey(const ValueKey('size')), '20');
      await tester.pumpAndSettle();
      await tap(tester, 'Save');
      expect(cloud.body('POST /volumes/32/actions/resize'), {'size': 20});
      await tap(tester, 'Edit');
      await tester.enterText(find.byKey(const ValueKey('name')), 'spare-2');
      await tester.enterText(find.byKey(const ValueKey('labels')), 'tier=cold');
      await tester.pumpAndSettle();
      await tap(tester, 'Save');
      expect(cloud.body('PUT /volumes/32'), {
        'name': 'spare-2',
        'labels': {'tier': 'cold'},
      });
      await tap(tester, 'Protection');
      expect(find.text('Protect spare-2?'), findsOneWidget);
      await confirm(tester, 'Protect');
      expect(cloud.body('POST /volumes/32/actions/change_protection'), {
        'delete': true,
      });
      await settleAction(tester);
    });

    testWidgets('CMP-064 delete needs the name', (tester) async {
      final cloud = await openTab(tester, 'Volumes', cloud: withVolumes());
      await tap(tester, 'spare');
      await tap(tester, 'Delete');
      await typeName(tester, 'spare');
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /volumes/32'));
      expect(find.text('spare'), findsNothing);
    });

    test('CMP-052 CMP-055 CMP-061 presets, price and resize rule', () {
      expect(volumePresets.first, minVolumeGb);
      expect(volumePresets.last, maxVolumeGb);
      const p = (
        currency: 'EUR',
        volumeGross: 0.05,
        volumeNet: 0.04,
        vatRate: 19,
        ipv4Gross: <String, num>{},
      );
      expect(volumePrice(100, p), (gross: 5.0, net: 4.0));
      expect(validResize('60', 50), isTrue);
      expect(validResize('50', 50), isFalse);
      expect(validResize('20000', 50), isFalse);
      expect(validResize('x', 50), isFalse);
    });
  });

  group('images', () {
    FakeCloud withImages() => FakeCloud(
      images: [
        imageJson(id: 7, name: 'debian-12', description: 'Debian 12'),
        imageJson(
          id: 8,
          description: 'nightly',
          type: 'snapshot',
          size: 1.5,
          createdFrom: 'web-1',
        ),
        imageJson(id: 9, description: 'auto', type: 'backup', size: 2),
      ],
    );

    testWidgets('CMP-090 own snapshots and backups only', (tester) async {
      await openTab(tester, 'Images', cloud: withImages());
      expect(find.text('Debian 12'), findsNothing);
      expect(find.textContaining('Snapshot · 1.5 GiB'), findsOneWidget);
      expect(find.textContaining('web-1'), findsOneWidget);
      await tap(tester, 'Backup');
      expect(find.text('nightly'), findsNothing);
      expect(find.text('auto'), findsOneWidget);
    });

    testWidgets('empty state', (tester) async {
      await openTab(tester, 'Images');
      expect(
        find.textContaining('No snapshots or backups yet'),
        findsOneWidget,
      );
    });

    testWidgets('CMP-093 CMP-094 CMP-096 detail, edit, convert, protection', (
      tester,
    ) async {
      final cloud = await openTab(tester, 'Images', cloud: withImages());
      await tap(tester, 'auto');
      expect(find.text('Backup'), findsWidgets);
      await tap(tester, 'To snapshot');
      await confirm(tester, 'To snapshot');
      expect(cloud.body('PUT /images/9'), {'type': 'snapshot'});
      await tap(tester, 'Edit');
      await tester.enterText(find.byKey(const ValueKey('name')), 'golden');
      await tester.pumpAndSettle();
      await tap(tester, 'Save');
      expect(cloud.body('PUT /images/9'), {
        'description': 'golden',
        'labels': <String, Object?>{},
      });
      await tap(tester, 'Protection');
      await confirm(tester, 'Protect');
      expect(cloud.body('POST /images/9/actions/change_protection'), {
        'delete': true,
      });
      await settleAction(tester);
    });

    testWidgets('CMP-094 a description has no length limit', (tester) async {
      final cloud = await openTab(tester, 'Images', cloud: withImages());
      await tap(tester, 'auto');
      await tap(tester, 'Edit');
      final long = 'd' * 100;
      await tester.enterText(find.byKey(const ValueKey('name')), long);
      await tester.pumpAndSettle();
      await tap(tester, 'Save');
      expect(cloud.body('PUT /images/9')['description'], long);
    });

    testWidgets('CMP-095 delete needs the description', (tester) async {
      final cloud = await openTab(tester, 'Images', cloud: withImages());
      await tap(tester, 'nightly');
      await tap(tester, 'Delete');
      await typeName(tester, 'nightly');
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /images/8'));
    });
  });

  group('placement groups', () {
    testWidgets('CMP-065 CMP-069 list and detail with servers', (tester) async {
      final cloud = FakeCloud(
        placementGroups: [
          placementGroupJson(id: 41, name: 'spread-1', servers: [1]),
        ],
      );
      await openTab(tester, 'Placement groups', cloud: cloud);
      expect(find.text('spread · 1 server'), findsOneWidget);
      await tap(tester, 'spread-1');
      expect(find.text('web-1'), findsOneWidget);
      expect(cloud.calls, contains('GET /placement_groups/41'));
    });

    testWidgets('CMP-066 CMP-091 BUG-008 create with a type from the spec', (
      tester,
    ) async {
      final cloud = await openTab(tester, 'Placement groups');
      expect(find.textContaining('No placement groups'), findsOneWidget);
      await tap(tester, 'Create placement group');
      await tester.enterText(find.byKey(const ValueKey('name')), 'ha');
      await tester.pumpAndSettle();
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      expect(cloud.body('POST /placement_groups'), {
        'name': 'ha',
        'type': 'spread',
        'labels': <String, Object?>{},
      });
      expect(find.text('ha'), findsOneWidget);
    });

    testWidgets('CMP-067 CMP-068 rename and delete', (tester) async {
      final cloud = await openTab(
        tester,
        'Placement groups',
        cloud: FakeCloud(
          placementGroups: [placementGroupJson(id: 41, name: 'spread-1')],
        ),
      );
      await tap(tester, 'spread-1');
      await tap(tester, 'Edit');
      await tester.enterText(find.byKey(const ValueKey('name')), 'spread-2');
      await tester.pumpAndSettle();
      await tap(tester, 'Save');
      expect(cloud.body('PUT /placement_groups/41')['name'], 'spread-2');
      await tap(tester, 'Delete');
      await typeName(tester, 'spread-2');
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /placement_groups/41'));
    });

    test('CMP-091 types come from the spec, not a fixed value', () {
      expect(placementGroupTypes, ['spread']);
    });
  });

  group('SSH keys', () {
    testWidgets('CMP-070 CMP-099 list with fingerprint, detail with key', (
      tester,
    ) async {
      final cloud = await openTab(
        tester,
        'SSH keys',
        cloud: FakeCloud(sshKeys: [sshKeyJson(id: 61, name: 'laptop')]),
      );
      expect(find.textContaining('b7:2f:30'), findsOneWidget);
      await tap(tester, 'laptop');
      expect(find.textContaining('ssh-ed25519 AAAA'), findsOneWidget);
      expect(cloud.calls, contains('GET /ssh_keys/61'));
    });

    testWidgets('CMP-071 CMP-072 add checks the key', (tester) async {
      final cloud = await openTab(tester, 'SSH keys');
      await tap(tester, 'Add SSH key');
      await tester.enterText(find.byKey(const ValueKey('name')), 'laptop');
      await tester.enterText(
        find.byKey(const ValueKey('key')),
        '-----BEGIN OPENSSH PRIVATE KEY-----',
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('This is a private key'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('key')),
        'ssh-ed25519 AAAAFAKE me@laptop',
      );
      await tester.pumpAndSettle();
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      expect(
        cloud.body('POST /ssh_keys')['public_key'],
        'ssh-ed25519 AAAAFAKE me@laptop',
      );
    });

    testWidgets('CMP-074 with all projects the project comes first', (
      tester,
    ) async {
      const two = Account(
        id: 'a1',
        name: 'Acme',
        projects: [
          Project(id: 'p1', name: 'prod'),
          Project(id: 'p2', name: 'staging'),
        ],
      );
      setSurface(tester);
      await pumpFalco(tester, FakeCloud(), accounts: [two]);
      await tester.tap(find.text('prod'));
      await tester.pumpAndSettle();
      await tap(tester, 'All projects');
      await tap(tester, 'SSH keys');
      await tap(tester, 'Add SSH key');
      expect(find.text('Project'), findsWidgets);
      expect(find.text('staging'), findsOneWidget);
    });

    testWidgets('CMP-075 CMP-076 rename and delete', (tester) async {
      final cloud = await openTab(
        tester,
        'SSH keys',
        cloud: FakeCloud(sshKeys: [sshKeyJson(id: 61, name: 'laptop')]),
      );
      await tap(tester, 'laptop');
      await tap(tester, 'Edit');
      await tester.enterText(find.byKey(const ValueKey('name')), 'desk');
      await tester.pumpAndSettle();
      await tap(tester, 'Save');
      expect(cloud.body('PUT /ssh_keys/61')['name'], 'desk');
      await tap(tester, 'Delete');
      await typeName(tester, 'desk');
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /ssh_keys/61'));
    });

    test('CMP-072 CMP-073 key validation', () {
      for (final private in [
        '-----BEGIN RSA PRIVATE KEY-----',
        'PuTTY-User-Key-File-3: ssh-ed25519',
        '---- BEGIN SSH2 PUBLIC KEY ----',
        'ssh-ed25519-cert-v01@openssh.com AAAA',
      ]) {
        expect(sshKeyProblem(private), SshKeyProblem.privateKey);
      }
      for (final ok in [
        'ssh-rsa AAAA',
        'ssh-ed25519 AAAA',
        'ssh-dss AAAA',
        'ecdsa-sha2-nistp256 AAAA',
        'ecdsa-sha2-nistp384 AAAA',
        'ecdsa-sha2-nistp521 AAAA',
        'sk-ecdsa-sha2-nistp256@openssh.com AAAA',
        'sk-ssh-ed25519@openssh.com AAAA',
      ]) {
        expect(sshKeyProblem(ok), isNull);
      }
      expect(sshKeyProblem('rsa AAAA'), SshKeyProblem.unknownType);
      expect(sshKeyProblem('  '), SshKeyProblem.empty);
    });
  });

  test('CMP-017 CMP-057 CMP-093 details read enum values the spec does not '
      'know yet', () async {
    final cloud = FakeCloud(volumes: [volumeJson(id: 31, name: 'data')]);
    cloud.servers.first['status'] = 'hibernating';
    cloud.volumes.first['status'] = 'resizing';
    cloud.images.first['status'] = 'importing';
    final c = await fakeContainer(cloud);
    final s = cloud.servers.first['id']! as int;
    final v = cloud.volumes.first['id']! as int;
    final i = cloud.images.first['id']! as int;
    expect((await c.read(serverProvider(_scope, s).future)).id, s);
    expect((await c.read(volumeProvider(_scope, v).future)).id, v);
    expect((await c.read(imageProvider(_scope, i).future)).id, i);
  });

  test(
    'CMP-033 change type offers no smaller disk and no other storage',
    () async {
      final c = await fakeContainer(FakeCloud());
      final server = await c.read(serverProvider(_scope, 1).future);
      ServerType type(String name, num disk, [String storage = 'local']) =>
          ServerType(
            id: name.hashCode,
            name: name,
            cores: 2,
            memoryGb: 4,
            diskGb: disk,
            architecture: server.architecture,
            prices: {server.location: 5},
            storageType: storage,
          );
      final options = changeTypeOptions([
        type(server.type, server.diskGb),
        type('small', server.diskGb - 1),
        type('ceph', server.diskGb * 2, 'network'),
        type('big', server.diskGb * 2),
      ], server);
      expect([for (final t in options) t.name], [server.type, 'big']);
    },
  );

  test(
    'CMP-033 the current type stays without price at its location',
    () async {
      final c = await fakeContainer(FakeCloud());
      final server = await c.read(serverProvider(_scope, 1).future);
      final options = changeTypeOptions([
        ServerType(
          id: 1,
          name: server.type,
          cores: 2,
          memoryGb: 4,
          diskGb: server.diskGb,
          architecture: server.architecture,
          prices: const {},
          deprecated: true,
        ),
      ], server);
      expect([for (final t in options) t.name], [server.type]);
    },
  );

  test('CMP-031 boot images are available and fit the disk', () {
    CloudImage image(int id, {num disk = 5, ResourceStatus? status}) =>
        CloudImage(
          id: id,
          projectId: 'p1',
          kind: ImageKind.system,
          description: 'image $id',
          status: status ?? ResourceStatus.available,
          architecture: 'x86',
          created: DateTime(2026),
          diskGb: disk,
        );
    final boot = bootImages(
      [
        image(1),
        image(2, disk: 80),
        image(3, status: ResourceStatus.initializing),
      ],
      'x86',
      40,
      AppLocalizationsEn(),
    );
    expect(boot.options.keys, ['1']);
  });

  testWidgets('the Images tile counts own images only', (tester) async {
    final semantics = tester.ensureSemantics();
    setSurface(tester);
    await pumpFalco(tester, FakeCloud());
    expect(find.bySemanticsLabel(RegExp(r'^Images, 0\b')), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('the overview names projects that could not load', (
    tester,
  ) async {
    const all = AllProjectsScope('a1');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountsProvider.overrideWith((ref) async => const [acme]),
          storageBoxesProvider(all).overrideWith(
            (ref) async => PartialList(<StorageBox>[], const [
              Project(id: 'p2', name: 'staging'),
            ]),
          ),
          bucketsProvider(all).overrideWith((ref) async => null),
        ],
        child: testApp(const AreaOverviewPage(scope: all, area: Area.storage)),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Could not load: staging. Showing the other projects.'),
      findsOneWidget,
    );
  });

  group('catalog and activity', () {
    test('CMP-009 CMP-078 CMP-079 CMP-080 CMP-092 CMP-097 CMP-098 options of '
        'a project, location based, prices per location', () async {
      final cloud = FakeCloud();
      final container = await fakeContainer(cloud);
      final locations = await container.read(locationsProvider(_scope).future);
      expect([for (final l in locations) l.name], ['fsn1']);
      final types = await container.read(serverTypesProvider(_scope).future);
      expect(types.first.prices, {'fsn1': 4.51});
      expect(types[1].cores, 4);
      final pricing = await container.read(pricingProvider(_scope).future);
      expect(pricing.currency, 'EUR');
      expect(pricing.volumeGross, 0.044);
      expect(cloud.calls.where((c) => c.contains('datacenter')), isEmpty);
    });

    test('project activity includes volume and image actions', () async {
      final cloud = FakeCloud(
        actions: [
          FakeCloud.action(11, 'reboot_server', 1),
          FakeCloud.action(12, 'attach_volume', 31, type: 'volume'),
          FakeCloud.action(13, 'change_protection', 8, type: 'image'),
        ],
      );
      final container = await fakeContainer(cloud);
      final all = await container.read(activityProvider(_scope).future);
      expect({for (final a in all) a.id}, {11, 12, 13});
      expect(
        cloud.calls,
        containsAll([
          'GET /servers/actions',
          'GET /volumes/actions',
          'GET /images/actions',
        ]),
      );
    });

    test('labels round trip and validation', () {
      expect(parseLabels('env=prod, tier'), {'env': 'prod', 'tier': ''});
      expect(formatLabels({'b': '', 'a': '1'}), 'a=1, b');
      expect(parseLabels(''), <String, String>{});
      expect(parseLabels('bad key=1'), isNull);
      expect(parseLabels('k=bad value'), isNull);
      expect(parseLabels('example.com/role=web'), {'example.com/role': 'web'});
    });
  });
}
