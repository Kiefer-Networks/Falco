// SPDX-License-Identifier: GPL-3.0-or-later
// Goldens of the vertical slice screens against the fake Cloud API.
@Tags(['golden'])
library;

import 'package:falco/ui/ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../fake_cloud.dart';
import '../../helpers.dart';

void main() {
  useTolerantGoldens('screens_golden_test.dart');

  Future<void> tap(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  Future<void> scrollTo(WidgetTester tester, String text) async {
    await tester.scrollUntilVisible(
      find.text(text),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  Future<void> settings(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
  }

  final screens = <String, Future<void> Function(WidgetTester)>{
    'welcome': (_) async {},
    'welcome_features': (tester) => tap(tester, 'Next'),
    'welcome_security': (tester) async {
      await tap(tester, 'Next');
      await tap(tester, 'Next');
    },
    'account_wizard_summary': (tester) async {
      await tap(tester, 'Skip');
      await tester.enterText(find.byKey(const ValueKey('name')), 'Acme');
      await tester.pump();
      await tap(tester, 'Next');
      await tap(tester, 'Robot');
      await tap(tester, 'Next');
      await tap(tester, 'Add project');
      await tester.enterText(find.byKey(const ValueKey('name')), 'prod');
      await tester.enterText(find.byKey(const ValueKey('token')), fakeToken);
      await tester.pump();
      await tap(tester, 'Save');
      await tap(tester, 'Next');
      await tester.enterText(
        find.byKey(const ValueKey('robotUser')),
        fakeRobotUser,
      );
      await tester.enterText(
        find.byKey(const ValueKey('robotPassword')),
        fakeRobotPassword,
      );
      await tester.pump();
      await tap(tester, 'Next');
    },
    'settings': settings,
    'accounts': (tester) async {
      await settings(tester);
      await tap(tester, 'Accounts');
    },
    'account': (tester) async {
      await settings(tester);
      await tap(tester, 'Accounts');
      await tap(tester, 'Acme');
    },
    'about': (tester) async {
      await settings(tester);
      await tester.scrollUntilVisible(find.text('ABOUT FALCO'), 200);
      await tap(tester, 'About Falco');
    },
    'server_list': (_) async {},
    'server_detail': (tester) async {
      await tester.tap(find.text('web-1'));
      await tester.pumpAndSettle();
    },
    'confirm_reboot': (tester) async {
      await tester.tap(find.text('web-1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reboot'));
      await tester.pumpAndSettle();
    },
    'activity': (tester) async {
      await tester.tap(find.byTooltip('Activity'));
      await tester.pumpAndSettle();
    },
    'server_metrics': (tester) async {
      await tap(tester, 'web-1');
      await scrollTo(tester, 'NETWORK');
    },
    'server_danger': (tester) async {
      await tap(tester, 'web-1');
      await scrollTo(tester, 'Rebuild');
    },
    'confirm_delete': (tester) async {
      await tap(tester, 'web-1');
      await scrollTo(tester, 'Delete');
      await tap(tester, 'Delete');
    },
    'create_server_type': (tester) async {
      await tap(tester, 'Create server');
      await tap(tester, 'fsn1');
      await tap(tester, 'Next');
    },
    'create_server_summary': (tester) async {
      await tap(tester, 'Create server');
      await tap(tester, 'fsn1');
      await tap(tester, 'Next');
      await tap(tester, 'CX22');
      await tap(tester, 'Next');
      await tap(tester, 'Debian 12');
      for (var i = 0; i < 4; i++) {
        await tap(tester, 'Next');
      }
      await tester.enterText(find.byKey(const ValueKey('name')), 'app-1');
      await tester.pump();
      await tap(tester, 'Next');
    },
    'volumes': (tester) => tap(tester, 'Volumes'),
    'volume_detail': (tester) async {
      await tap(tester, 'Volumes');
      await tap(tester, 'data');
    },
    'create_volume_size': (tester) async {
      await tap(tester, 'Volumes');
      await tap(tester, 'Create volume');
      await tap(tester, 'fsn1 · Falkenstein DC Park 1');
      await tap(tester, 'Next');
    },
    'images': (tester) => tap(tester, 'Images'),
    'image_detail': (tester) async {
      await tap(tester, 'Images');
      await tap(tester, 'nightly');
    },
    'placement_groups': (tester) => tap(tester, 'Placement groups'),
    'placement_group_detail': (tester) async {
      await tap(tester, 'Placement groups');
      await tap(tester, 'spread-1');
    },
    'ssh_keys': (tester) => tap(tester, 'SSH keys'),
    'ssh_key_detail': (tester) async {
      await tap(tester, 'SSH keys');
      await tap(tester, 'laptop');
    },
  };

  // PARITY rows each golden covers.
  const ids = {
    'welcome': 'ONB-001',
    'welcome_features': 'ONB-004',
    'welcome_security': 'ONB-005',
    'account_wizard_summary': 'ONB-016',
    'settings': 'SET-001 SET-002 SET-003',
    'accounts': 'ONB-021 ONB-022 ONB-023',
    'account': 'ONB-029',
    'about': 'ONB-040',
    'server_list': 'CMP-003',
    'server_detail': 'CMP-016 CMP-017 CMP-018',
    'server_metrics': 'CMP-027',
    'server_danger': 'CMP-049',
    'create_server_type': 'CMP-010',
    'volumes': 'CMP-050',
    'volume_detail': 'CMP-057 CMP-058',
    'images': 'CMP-090',
    'placement_groups': 'CMP-065',
    'ssh_keys': 'CMP-070',
  };

  for (final variant in [FalcoVariant.dark, FalcoVariant.light]) {
    group(variant.name, () {
      for (final MapEntry(key: name, value: open) in screens.entries) {
        testWidgets('$name ${ids[name] ?? ''}'.trim(), (tester) async {
          setSurface(tester, const Size(390, 844));
          await pumpFalco(
            tester,
            FakeCloud(
              actions: [
                FakeCloud.action(11, 'reboot_server', 1),
                FakeCloud.action(12, 'start_server', 2, status: 'error'),
              ],
              servers: [
                serverJson(
                  id: 1,
                  name: 'web-1',
                  volumes: [31],
                  labels: {'env': 'prod'},
                  placementGroup: placementGroupJson(id: 41, name: 'spread-1'),
                ),
                serverJson(id: 2, name: 'db-1', status: 'off'),
              ],
              volumes: [
                volumeJson(id: 31, name: 'data', server: 1),
                volumeJson(id: 32, name: 'spare', size: 10),
              ],
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
              placementGroups: [
                placementGroupJson(id: 41, name: 'spread-1', servers: [1]),
              ],
              sshKeys: [sshKeyJson(id: 61, name: 'laptop')],
            ),
            accounts: name.startsWith('welcome') || name.startsWith('account_')
                ? const []
                : const [acme],
            variant: variant,
          );
          await open(tester);
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('${name}_${variant.name}.png'),
          );
        });
      }

      testWidgets('lock (SET-011)', (tester) async {
        setSurface(tester, const Size(390, 844));
        await pumpFalco(
          tester,
          FakeCloud(),
          variant: variant,
          answers: [false],
        );
        expect(find.text('web-1'), findsNothing);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('lock_${variant.name}.png'),
        );
      });
    });
  }
}
