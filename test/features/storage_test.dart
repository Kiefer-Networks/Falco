// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/actions/action_tracker.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/storage/storage_box_pages.dart';
import 'package:falco/features/storage/storage_boxes.dart';
import 'package:falco/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';
import '../steps.dart';
import '../storage_steps.dart';

const _scope = ProjectScope('a1', 'p1');

Map<String, Object?> _done(int id, String command) => {
  'id': id,
  'command': command,
  'status': 'success',
  'progress': 100,
  'started': '2026-02-01T10:00:00Z',
  'finished': null,
  'resources': [
    {'id': 41, 'type': 'storage_box'},
  ],
  'error': null,
};

Future<FakeCloud> openBox(WidgetTester tester, [String name = 'backup']) async {
  final cloud = await openStorage(tester, 'Storage Boxes');
  await tap(tester, name);
  return cloud;
}

void main() {
  group('list', () {
    testWidgets('STB-001 name, user, type, location, status, protection', (
      tester,
    ) async {
      await openStorage(tester, 'Storage Boxes');
      expect(find.text('backup'), findsOneWidget);
      expect(find.text('u41 · bx11 · fsn1'), findsOneWidget);
      expect(find.text('u42 · bx11 · fsn1 · protected'), findsOneWidget);
      expect(find.text('active'), findsWidgets);
      await tap(tester, 'protected');
      expect(find.text('backup'), findsNothing);
    });

    testWidgets('empty state offers create', (tester) async {
      await openStorage(tester, 'Storage Boxes', cloud: FakeCloud());
      expect(
        find.text('No Storage Boxes in this project yet.'),
        findsOneWidget,
      );
      expect(find.text('Create Storage Box'), findsWidgets);
    });
  });

  group('create', () {
    testWidgets('STB-002 STB-003 STB-004 location, type with price, access '
        'data, tracked', (tester) async {
      final cloud = await openStorage(tester, 'Storage Boxes');
      await tap(tester, 'Create Storage Box');
      await tap(tester, 'hel1');
      await tap(tester, 'Next');
      expect(find.textContaining('bx21 · 5 TiB · €10.90'), findsOneWidget);
      await tap(tester, 'bx11 · 1 TiB · €3.20');
      await tap(tester, 'Next');
      await enter(tester, 'name', 'offsite');
      await enter(tester, 'password', 'short');
      await enter(tester, 'repeat', 'short');
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next'))
            .onPressed,
        isNull,
      );
      await passwords(tester);
      await chip(tester, 'samba_enabled', 'Yes');
      await tap(tester, 'Next');
      await tap(tester, 'Create');
      final body = cloud.body('POST /storage_boxes');
      expect(body['location'], 'hel1');
      expect(body['storage_box_type'], 'bx11');
      expect(body['password'], boxPassword);
      expect((body['access_settings']! as Map)['samba_enabled'], isTrue);
      await settleAction(tester);
      expect(find.text('offsite'), findsOneWidget);
      expect(cloud.calls, contains('GET /storage_boxes/actions/700'));
    });

    test('STB-003 password policy of the API', () {
      expect(validBoxPassword(boxPassword), isTrue);
      expect(validBoxPassword('Sh0rt!'), isFalse);
      expect(validBoxPassword('alllowercase1!'), isFalse);
      expect(validBoxPassword('NoDigitsHere!!'), isFalse);
      expect(validBoxPassword('NoSpecial1234a'), isFalse);
      expect(validBoxPassword('Bad"Quote1234a'), isFalse);
    });
  });

  group('detail', () {
    testWidgets('STB-005 STB-006 overview with usage, access, plan', (
      tester,
    ) async {
      await openBox(tester);
      expect(find.text('u41.your-storagebox.de'), findsWidgets);
      expect(find.text('256 GiB of 1 TiB used'), findsOneWidget);
      expect(find.text('200 GiB'), findsOneWidget);
      expect(find.text('Daily at 03:30 UTC, keeps 7'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('STB-007 STB-008 STB-009 STB-010 STB-011 access settings', (
      tester,
    ) async {
      final cloud = await openBox(tester);
      await more(tester, 'Access');
      await chip(tester, 'samba_enabled', 'Yes');
      await chip(tester, 'webdav_enabled', 'Yes');
      await chip(tester, 'zfs_enabled', 'Yes');
      await chip(tester, 'reachable_externally', 'Yes');
      await chip(tester, 'ssh_enabled', 'No');
      await tap(tester, 'Save');
      expect(
        cloud.body('POST /storage_boxes/41/actions/update_access_settings'),
        {
          'ssh_enabled': false,
          'samba_enabled': true,
          'webdav_enabled': true,
          'zfs_enabled': true,
          'reachable_externally': true,
        },
      );
      await settleAction(tester);
    });

    testWidgets('STB-012 reset password needs the policy and a repeat', (
      tester,
    ) async {
      final cloud = await openBox(tester);
      await tile(tester, 'Reset password');
      await enter(tester, 'password', boxPassword);
      await enter(tester, 'repeat', '${boxPassword}x');
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'))
            .onPressed,
        isNull,
      );
      await enter(tester, 'repeat', boxPassword);
      await tap(tester, 'Save');
      expect(cloud.body('POST /storage_boxes/41/actions/reset_password'), {
        'password': boxPassword,
      });
      await settleAction(tester);
    });

    testWidgets('STB-013 STB-014 snapshots listed and created', (tester) async {
      final cloud = await openBox(tester);
      expect(find.text('before upgrade'), findsOneWidget);
      await tile(tester, 'Snapshot');
      await enter(tester, 'description', 'nightly');
      await tap(tester, 'Save');
      expect(cloud.body('POST /storage_boxes/41/snapshots'), {
        'description': 'nightly',
      });
      await settleAction(tester);
      expect(find.text('nightly'), findsOneWidget);
    });

    testWidgets('STB-017 STB-018 STB-025 subaccount with home from folders', (
      tester,
    ) async {
      final cloud = await openBox(tester);
      expect(find.text('u41-sub71'), findsOneWidget);
      expect(find.text('backup · nas'), findsOneWidget);
      await tile(tester, 'Add subaccount');
      expect(cloud.calls, contains('GET /storage_boxes/41/folders'));
      await chip(tester, 'folder', 'New folder');
      await enter(tester, 'home', 'shared');
      await passwords(tester);
      await chip(tester, 'readonly', 'Yes');
      await tap(tester, 'Save');
      final body = cloud.body('POST /storage_boxes/41/subaccounts');
      expect(body['home_directory'], 'shared');
      expect((body['access_settings']! as Map)['readonly'], isTrue);
      await settleAction(tester);
      expect(find.textContaining('shared · '), findsOneWidget);
    });

    testWidgets('STB-023 rename and relabel', (tester) async {
      final cloud = await openBox(tester);
      await tile(tester, 'Edit');
      await enter(tester, 'name', 'backup-2');
      await enter(tester, 'labels', 'env=prod');
      await tap(tester, 'Save');
      expect(cloud.body('PUT /storage_boxes/41'), {
        'name': 'backup-2',
        'labels': {'env': 'prod'},
      });
      expect(find.text('backup-2'), findsOneWidget);
    });

    testWidgets('STB-024 delete needs the name; protected cannot', (
      tester,
    ) async {
      final cloud = await openBox(tester);
      await tap(tester, 'Delete');
      await typeName(tester, 'backup');
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /storage_boxes/41'));
      await settleAction(tester);
      expect(find.text('u41 · bx11 · fsn1'), findsNothing);
      await tap(tester, 'archive');
      await tester.scrollUntilVisible(
        find.text('Delete'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(
        tester
            .widget<OutlinedButton>(
              find.ancestor(
                of: find.text('Delete'),
                matching: find.byType(OutlinedButton),
              ),
            )
            .onPressed,
        isNull,
      );
    });

    testWidgets('STB-026 activity of the box', (tester) async {
      final cloud = storageCloud();
      cloud.storage.actions.add(_done(803, 'create_snapshot'));
      await openStorage(tester, 'Storage Boxes', cloud: cloud);
      await tap(tester, 'backup');
      await tester.scrollUntilVisible(
        find.text('Create snapshot'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(cloud.calls, contains('GET /storage_boxes/41/actions'));
    });

    testWidgets('STB-028 protection after confirm', (tester) async {
      final cloud = await openBox(tester);
      await more(tester, 'Protect');
      await confirm(tester, 'Protect');
      expect(cloud.body('POST /storage_boxes/41/actions/change_protection'), {
        'delete': true,
      });
      await settleAction(tester);
    });

    testWidgets('STB-029 STB-037 change type with prices', (tester) async {
      final cloud = await openBox(tester);
      await more(tester, 'Change type');
      expect(find.textContaining('bx21 · 5 TiB · €10.90'), findsOneWidget);
      await chip(tester, 'type', 'bx21 · 5 TiB · €10.90');
      await tap(tester, 'Save');
      expect(cloud.body('POST /storage_boxes/41/actions/change_type'), {
        'storage_box_type': 'bx21',
      });
      await settleAction(tester);
    });

    testWidgets('STB-030 STB-031 snapshot plan on and off', (tester) async {
      final cloud = await openBox(tester);
      await more(tester, 'Snapshot plan');
      await enter(tester, 'hour', '24');
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'))
            .onPressed,
        isNull,
      );
      await enter(tester, 'hour', '4');
      await chip(tester, 'weekday', 'Sunday');
      await tap(tester, 'Save');
      expect(
        cloud.body('POST /storage_boxes/41/actions/enable_snapshot_plan'),
        {
          'max_snapshots': 7,
          'minute': 30,
          'hour': 4,
          // An unset day is left out: every day.
          'day_of_week': 7,
        },
      );
      await settleAction(tester);
      expect(find.text('Sundays at 04:30 UTC, keeps 7'), findsOneWidget);
      await more(tester, 'Snapshot plan');
      await chip(tester, 'enabled', 'No');
      await tap(tester, 'Save');
      expect(
        cloud.calls,
        contains('POST /storage_boxes/41/actions/disable_snapshot_plan'),
      );
      await settleAction(tester);
    });
  });

  group('snapshot', () {
    testWidgets('STB-035 STB-036 detail and edit description', (tester) async {
      final cloud = await openBox(tester);
      await tap(tester, 'before upgrade');
      expect(cloud.calls, contains('GET /storage_boxes/41/snapshots/61'));
      expect(find.text('1 GiB'), findsOneWidget);
      await tile(tester, 'Edit');
      await enter(tester, 'description', 'kept');
      await tap(tester, 'Save');
      expect(cloud.body('PUT /storage_boxes/41/snapshots/61'), {
        'description': 'kept',
        'labels': <String, Object?>{},
      });
    });

    testWidgets('STB-016 rollback is level 2', (tester) async {
      final cloud = await openBox(tester);
      await tap(tester, 'before upgrade');
      await tap(tester, 'Roll back');
      expect(find.byKey(const ValueKey('confirm-name')), findsOneWidget);
      await typeName(tester, '2026-02-08T03-00-00');
      await confirm(tester, 'Roll back');
      expect(cloud.body('POST /storage_boxes/41/actions/rollback_snapshot'), {
        'snapshot': '2026-02-08T03-00-00',
      });
      await settleAction(tester);
    });

    testWidgets('STB-015 delete with the name', (tester) async {
      final cloud = await openBox(tester);
      await tap(tester, 'before upgrade');
      await tap(tester, 'Delete');
      await typeName(tester, '2026-02-08T03-00-00');
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /storage_boxes/41/snapshots/61'));
      await settleAction(tester);
      expect(find.text('before upgrade'), findsNothing);
    });
  });

  group('subaccount', () {
    Future<FakeCloud> openSub(WidgetTester tester) async {
      final cloud = await openBox(tester);
      await tap(tester, 'u41-sub71');
      return cloud;
    }

    testWidgets('STB-032 STB-021 detail and edit', (tester) async {
      final cloud = await openSub(tester);
      expect(cloud.calls, contains('GET /storage_boxes/41/subaccounts/71'));
      await tile(tester, 'Edit');
      await enter(tester, 'description', 'office');
      await tap(tester, 'Save');
      expect(cloud.body('PUT /storage_boxes/41/subaccounts/71'), {
        'name': 'sub71',
        'description': 'office',
        'labels': <String, Object?>{},
      });
    });

    testWidgets('STB-033 home directory', (tester) async {
      final cloud = await openSub(tester);
      await tile(tester, 'Home directory');
      await chip(tester, 'folder', 'photos');
      await tap(tester, 'Save');
      expect(
        cloud.body(
          'POST /storage_boxes/41/subaccounts/71/actions/change_home_directory',
        ),
        {'home_directory': 'photos'},
      );
      await settleAction(tester);
    });

    testWidgets('STB-034 read only, external, protocols', (tester) async {
      final cloud = await openSub(tester);
      await tile(tester, 'Access');
      await chip(tester, 'readonly', 'Yes');
      await chip(tester, 'webdav_enabled', 'Yes');
      await tap(tester, 'Save');
      expect(
        cloud.body(
          'POST /storage_boxes/41/subaccounts/71/actions/update_access_settings',
        ),
        {
          'readonly': true,
          'ssh_enabled': true,
          'samba_enabled': false,
          'webdav_enabled': true,
          'reachable_externally': false,
        },
      );
      await settleAction(tester);
    });

    testWidgets('STB-020 reset password', (tester) async {
      final cloud = await openSub(tester);
      await tile(tester, 'Reset password');
      await passwords(tester);
      await tap(tester, 'Save');
      expect(
        cloud.body(
          'POST /storage_boxes/41/subaccounts/71/actions/reset_subaccount_password',
        ),
        {'password': boxPassword},
      );
      await settleAction(tester);
    });

    testWidgets('STB-019 delete with confirmation', (tester) async {
      final cloud = await openSub(tester);
      await tap(tester, 'Delete');
      await typeName(tester, 'u41-sub71');
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /storage_boxes/41/subaccounts/71'));
      await settleAction(tester);
      expect(find.text('u41-sub71'), findsNothing);
    });
  });

  group('actions', () {
    test('STB-027 the tracker follows a box action until done', () async {
      final cloud = storageCloud();
      final c = await fakeContainer(cloud);
      final a = cloud.storage.actions
        ..add({
          'id': 801,
          'command': 'reset_password',
          'status': 'running',
          'progress': 10,
          'started': '2026-02-01T10:00:00Z',
          'finished': null,
          'resources': [
            {'id': 41, 'type': 'storage_box'},
          ],
          'error': null,
        });
      expect(a, isNotEmpty);
      final seen = await c
          .read(storageBoxTrackerProvider(_scope))
          .track(801)
          .map((p) => p.status)
          .toList();
      expect(seen, [ActionStatus.running, ActionStatus.success]);
      expect(cloud.calls, contains('GET /storage_boxes/actions/801'));
    });

    test('STB-022 project activity includes Storage Box actions', () async {
      final cloud = storageCloud();
      cloud.storage.actions.add(_done(802, 'create_snapshot'));
      final c = await fakeContainer(cloud);
      final all = await c.read(activityProvider(_scope, null).future);
      expect(all.map((a) => a.command), contains('create_snapshot'));
      final mine = await c.read(boxActionsProvider(_scope, 41).future);
      expect(mine.single.id, 802);
    });

    test('plan text and type text', () {
      final l10n = AppLocalizationsEn();
      expect(planText(null, l10n), 'Off');
      expect(
        planText((
          maxSnapshots: 3,
          minute: 5,
          hour: 1,
          dayOfWeek: null,
          dayOfMonth: 15,
        ), l10n),
        'Monthly on day 15 at 01:05 UTC, keeps 3',
      );
      expect(planFrom({'max': '0', 'hour': '1', 'minute': '1'}), isNull);
    });
  });
}
