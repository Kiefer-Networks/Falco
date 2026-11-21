// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:async';

import 'package:falco/core/actions/action_tracker.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/activity/activity_page.dart';
import 'package:falco/features/volumes/volumes.dart';
import 'package:falco/l10n/app_localizations_en.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';
import '../helpers.dart' show testApp;
import '../search_steps.dart';
import '../steps.dart';

const _scope = ProjectScope('a1', 'p1');
final _en = AppLocalizationsEn();

/// Resource types with an action list, with a resource of [searchCloud]
/// and the collection of their API path.
const List<(String, int, String)> _types = [
  (CloudType.server, 1, 'servers'),
  (CloudType.volume, 21, 'volumes'),
  (CloudType.image, 8, 'images'),
  (CloudType.network, 31, 'networks'),
  (CloudType.firewall, 32, 'firewalls'),
  (CloudType.floatingIp, 33, 'floating_ips'),
  (CloudType.primaryIp, 34, 'primary_ips'),
  (CloudType.loadBalancer, 35, 'load_balancers'),
  (CloudType.certificate, 36, 'certificates'),
  (CloudType.zone, 37, 'zones'),
];

/// One finished action per type, ids 501 and up.
List<Map<String, Object?>> _perType({String status = 'success'}) => [
  for (final (i, (type, id, _)) in _types.indexed)
    FakeCloud.action(
      501 + i,
      'change_protection',
      id,
      type: type,
      status: status,
    ),
];

void main() {
  setUpAll(() => initializeDateFormatting('en'));

  test('QRS-028 a server change reloads the volumes too', () {
    final invalidated = <ProviderOrFamily>[];
    refreshResource(invalidated.add, _scope, CloudType.server, 1);
    expect(invalidated, containsAll(<Object>[volumesProvider, volumeProvider]));
  });

  testWidgets('SUC-011 the preview of a detail says loading and failure', (
    tester,
  ) async {
    final failing = Completer<List<ActionProgress>>();
    Widget preview() => ProviderScope(
      overrides: [
        activityProvider(
          _scope,
          type: CloudType.server,
          id: 1,
        ).overrideWith((ref) => failing.future),
      ],
      child: testApp(
        SingleChildScrollView(
          child: activitySection(_en, _scope, CloudType.server, 1).child,
        ),
      ),
    );
    await tester.pumpWidget(preview());
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text(_en.activityEmpty), findsNothing);
    failing.completeError(const Server());
    await tester.pump();
    expect(find.byType(ErrorBanner), findsOneWidget);
    expect(find.text(_en.activityEmpty), findsNothing);
  });

  group('lists', () {
    test('SUC-006 STB-022 project activity: every resource type', () async {
      final cloud = searchCloud(actions: _perType());
      cloud.storage.actions.add({
        ...FakeCloud.action(801, 'create_snapshot', 41, type: 'storage_box'),
      });
      final c = await fakeContainer(cloud);
      final all = await c.read(activityProvider(_scope).future);
      expect(all, hasLength(_types.length + 1));
      for (final (_, _, coll) in _types) {
        expect(cloud.calls, contains('GET /$coll/actions'));
      }
      expect(cloud.calls, contains('GET /storage_boxes/actions'));
    });

    test('BUG-022 activity reads every page, not the first 30', () async {
      final cloud = searchCloud(
        actions: [
          for (var i = 0; i < 120; i++)
            FakeCloud.action(1000 + i, 'reboot_server', 1),
        ],
      );
      final c = await fakeContainer(cloud);
      final all = await c.read(
        activityProvider(_scope, type: CloudType.server, id: 1).future,
      );
      expect(all, hasLength(120));
      expect(cloud.calls.where((c) => c == 'GET /servers/1/actions'), [
        for (var i = 0; i < 3; i++) 'GET /servers/1/actions',
      ]);
    });

    test('CMP-045 SUC-011 SUC-015 SUC-018 SUC-021 SUC-024 SUC-027 SUC-030 '
        'SUC-033 SUC-039 actions of one resource of every type', () async {
      final cloud = searchCloud(actions: _perType());
      final c = await fakeContainer(cloud);
      for (final (i, (type, id, coll)) in _types.indexed) {
        final mine = await c.read(
          activityProvider(_scope, type: type, id: id).future,
        );
        expect(mine.single.id, 501 + i, reason: type);
        expect(cloud.calls, contains('GET /$coll/$id/actions'));
      }
      expect(
        await c.read(activityProvider(_scope, type: 'unknown', id: 1).future),
        isEmpty,
      );
    });

    // One endpoint serves every type: the per type action endpoints
    // return the same action object.
    test('SUC-013 SUC-014 SUC-016 SUC-017 SUC-019 SUC-020 SUC-022 SUC-023 '
        'SUC-025 SUC-026 SUC-028 SUC-029 SUC-031 SUC-032 SUC-034 SUC-035 '
        'SUC-036 SUC-037 SUC-038 SUC-040 the tracker follows actions of '
        'every type with GET /actions/{id}', () async {
      final cloud = searchCloud(actions: _perType(status: 'running'));
      final c = await fakeContainer(cloud);
      final tracker = c.read(actionTrackerProvider(_scope));
      final seen = await Future.wait([
        for (var i = 0; i < _types.length; i++)
          tracker.track(501 + i).map((a) => a.status).toList(),
      ]);
      for (final (i, s) in seen.indexed) {
        expect(s, [ActionStatus.running, ActionStatus.success]);
        expect(cloud.calls, contains('GET /actions/${501 + i}'));
      }
    });

    test('SUC-008 groups: running, today, yesterday, by day', () {
      final now = DateTime(2026, 11, 21, 9);
      ActionProgress at(DateTime t, [ActionStatus s = ActionStatus.success]) =>
          ActionProgress(
            id: 1,
            command: 'x',
            status: s,
            progress: 0,
            started: t,
          );
      expect(
        activityGroup(at(DateTime(2026), ActionStatus.running), now, _en),
        'In progress',
      );
      expect(activityGroup(at(DateTime(2026, 11, 21, 1)), now, _en), 'Today');
      expect(
        activityGroup(at(DateTime(2026, 11, 20, 23)), now, _en),
        'Yesterday',
      );
      expect(
        activityGroup(at(DateTime(2026, 3, 1, 14)), now, _en),
        'Mar 1, 2026',
      );
      expect(
        runningFirst([at(now), at(now, ActionStatus.running)])
            .map((a) => a.status),
        [ActionStatus.running, ActionStatus.success],
      );
    });
  });

  group('page', () {
    final old = DateTime(2026, 3, 1, 14, 5);
    List<Map<String, Object?>> history() => [
      FakeCloud.action(
        11,
        'reboot_server',
        1,
        status: 'running',
        started: DateTime.now(),
      ),
      FakeCloud.action(12, 'start_server', 2, status: 'error'),
      FakeCloud.action(13, 'attach_volume', 21, type: 'volume', started: old),
    ];

    Future<FakeCloud> openActivity(WidgetTester tester) async {
      final cloud = searchCloud(actions: history());
      setSurface(tester);
      await pumpFalco(tester, cloud);
      await tester.tap(find.byTooltip('Activity'));
      await tester.pumpAndSettle();
      return cloud;
    }

    Future<void> menu(WidgetTester tester, String button, String item) async {
      await tester.tap(find.text(button));
      await tester.pumpAndSettle();
      await tester.tap(find.text(item).last);
      await tester.pumpAndSettle();
    }

    testWidgets('SUC-012 SUC-009 entry in the header, rows with resource, '
        'time and progress, running on top', (tester) async {
      await openActivity(tester);
      expect(find.text('Activity'), findsWidgets);
      expect(find.text('IN PROGRESS'), findsOneWidget);
      expect(find.text('MAR 1, 2026'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Reboot server')).dy,
        lessThan(tester.getTopLeft(find.text('Power on server')).dy),
      );
      expect(find.textContaining('Server #1 · '), findsOneWidget);
      expect(find.textContaining('0 %'), findsOneWidget);
      expect(find.textContaining('action_failed'), findsOneWidget);
      expect(
        find.textContaining('Volume #21 · Mar 1, 2026 14:05'),
        findsOneWidget,
      );
    });

    testWidgets('SUC-007 status, type and time filters', (tester) async {
      await openActivity(tester);
      await tap(tester, 'In progress');
      expect(find.text('Reboot server'), findsOneWidget);
      expect(find.text('Power on server'), findsNothing);
      await tap(tester, 'Failed');
      expect(find.text('Power on server'), findsOneWidget);
      expect(find.text('Reboot server'), findsNothing);
      await tap(tester, 'All');
      await menu(tester, 'Type: All', 'Volume');
      expect(find.text('Attach volume'), findsOneWidget);
      expect(find.text('Reboot server'), findsNothing);
      await menu(tester, 'Type: Volume', 'All');
      await menu(tester, 'Time: Any time', 'Last 7 days');
      expect(find.text('Attach volume'), findsNothing);
      expect(find.text('Reboot server'), findsOneWidget);
    });

    testWidgets('SUC-010 pull to refresh reloads', (tester) async {
      final cloud = await openActivity(tester);
      int loads() =>
          cloud.calls.where((c) => c == 'GET /servers/actions').length;
      final before = loads();
      await tester.fling(
        find.text('Reboot server'),
        const Offset(0, 400),
        1000,
      );
      await tester.pumpAndSettle();
      expect(loads(), greaterThan(before));
    });

    testWidgets('a row opens its resource', (tester) async {
      await openActivity(tester);
      await tap(tester, 'Attach volume');
      expect(find.text('data'), findsWidgets);
      expect(find.text('Volume'), findsWidgets);
    });

    testWidgets('CMP-045 SUC-011 detail pages show their activity', (
      tester,
    ) async {
      final cloud = searchCloud(actions: history());
      setSurface(tester);
      await pumpFalco(tester, cloud);
      await tap(tester, 'Volumes');
      await tap(tester, 'data');
      await tester.scrollUntilVisible(find.text('Show all activity'), 200);
      await tester.pumpAndSettle();
      expect(find.text('Attach volume'), findsOneWidget);
      await tap(tester, 'Show all activity');
      expect(find.text('Attach volume'), findsOneWidget);
      expect(find.text('Reboot server'), findsNothing);
      expect(cloud.calls, contains('GET /volumes/21/actions'));
    });
  });
}
