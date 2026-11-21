// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/activity/activity_page.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';

const _unauthorized =
    'The access data was rejected. Check the token or the credentials.';
const _serverError = 'The server reported an error. Try again later.';

void main() {
  group('server list', () {
    testWidgets('shows servers of the project with status and mono line', (
      tester,
    ) async {
      final cloud = FakeCloud();
      await pumpFalco(tester, cloud);
      expect(find.text('prod'), findsOneWidget);
      expect(find.text('web-1'), findsOneWidget);
      expect(find.text('db-1'), findsOneWidget);
      expect(find.text('203.0.113.1 · CX22 · fsn1'), findsOneWidget);
      expect(cloud.calls, contains('GET /servers'));
    });

    testWidgets('filters by status', (tester) async {
      await pumpFalco(tester, FakeCloud());
      await tester.tap(find.text('Off'));
      await tester.pumpAndSettle();
      expect(find.text('db-1'), findsOneWidget);
      expect(find.text('web-1'), findsNothing);
    });

    testWidgets('empty project shows the empty hint', (tester) async {
      await pumpFalco(tester, FakeCloud(servers: []));
      expect(find.text('No servers in this project yet.'), findsOneWidget);
    });

    testWidgets('rejected token shows the error card with retry', (
      tester,
    ) async {
      final cloud = FakeCloud()..failWith = (401, errorJson('unauthorized'));
      await pumpFalco(tester, cloud);
      expect(find.text(_unauthorized), findsOneWidget);
      cloud.failWith = null;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('web-1'), findsOneWidget);
    });

    testWidgets('failed refresh keeps the data under a banner', (tester) async {
      final cloud = FakeCloud();
      await pumpFalco(tester, cloud);
      cloud.failWith = (503, errorJson('unavailable'));
      await tester.fling(find.text('web-1'), const Offset(0, 400), 1000);
      await tester.pumpAndSettle();
      expect(find.text('web-1'), findsOneWidget);
      expect(
        find.text('Could not refresh. Showing the last loaded data.'),
        findsOneWidget,
      );
    });

    testWidgets('all projects name the project per row', (tester) async {
      const two = Account(
        id: 'a1',
        name: 'Acme',
        projects: [
          Project(id: 'p1', name: 'prod'),
          Project(id: 'p2', name: 'staging'),
        ],
      );
      await pumpFalco(tester, FakeCloud(), accounts: [two]);
      await tester.tap(find.text('prod'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('All projects'));
      await tester.pumpAndSettle();
      expect(find.text('203.0.113.1 · CX22 · fsn1 · prod'), findsOneWidget);
      expect(find.text('203.0.113.1 · CX22 · fsn1 · staging'), findsOneWidget);
    });
  });

  group('server detail', () {
    Future<FakeCloud> openDetail(WidgetTester tester) async {
      final cloud = FakeCloud();
      await pumpFalco(tester, cloud);
      await tester.tap(find.text('web-1'));
      await tester.pumpAndSettle();
      return cloud;
    }

    testWidgets('shows header, overview and metrics', (tester) async {
      final cloud = await openDetail(tester);
      expect(find.text('web-1'), findsOneWidget);
      expect(find.textContaining('203.0.113.1'), findsOneWidget);
      expect(find.text('CX22'), findsOneWidget);
      expect(find.text('4 GiB'), findsOneWidget);
      expect(cloud.calls, contains('GET /servers/1'));
      expect(cloud.calls, contains('GET /servers/1/metrics'));
    });

    testWidgets('a missing server shows the error card', (tester) async {
      final cloud = FakeCloud();
      await pumpFalco(tester, cloud);
      cloud.servers.removeAt(0);
      await tester.tap(find.text('web-1'));
      await tester.pumpAndSettle();
      expect(find.text('This resource no longer exists.'), findsOneWidget);
    });

    testWidgets('reboot asks, runs, tracks and refreshes (CMP-020)', (
      tester,
    ) async {
      final cloud = await openDetail(tester);
      await tester.tap(find.text('Reboot'));
      await tester.pumpAndSettle();
      expect(find.text('Reboot web-1?'), findsOneWidget);
      expect(find.text('prod'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Reboot'));
      await tester.pumpAndSettle();
      expect(cloud.calls, contains('POST /servers/1/actions/reboot'));
      expect(find.textContaining('rebooting'), findsOneWidget);
      final before = cloud.calls.where((c) => c == 'GET /servers/1').length;
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(cloud.calls.where((c) => c.startsWith('GET /actions/')), [
        'GET /actions/900',
        'GET /actions/900',
      ]);
      expect(
        cloud.calls.where((c) => c == 'GET /servers/1').length,
        greaterThan(before),
      );
      expect(find.textContaining('rebooting'), findsNothing);
    });

    testWidgets('progress survives leaving and reopening the detail', (
      tester,
    ) async {
      final cloud = await openDetail(tester);
      cloud.pollsToFinish = 6;
      await tester.tap(find.text('Reboot'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Reboot'));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('web-1'));
      await tester.pumpAndSettle();
      expect(find.textContaining('rebooting'), findsOneWidget);
      await tester.pump(const Duration(seconds: 30));
      await tester.pumpAndSettle();
      expect(find.textContaining('rebooting'), findsNothing);
    });

    testWidgets('cancel sends nothing', (tester) async {
      final cloud = await openDetail(tester);
      await tester.tap(find.text('Shutdown'));
      await tester.pumpAndSettle();
      expect(find.text('Shut down web-1?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(cloud.calls.where((c) => c.startsWith('POST')), isEmpty);
    });

    testWidgets('power on needs no confirmation (CMP-022)', (tester) async {
      final cloud = FakeCloud();
      await pumpFalco(tester, cloud);
      await tester.tap(find.text('db-1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Power on'));
      await tester.pumpAndSettle();
      expect(cloud.calls, contains('POST /servers/2/actions/poweron'));
      expect(find.textContaining('starting'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text('running'), findsOneWidget);
    });

    testWidgets('power off asks, reset sits in the more menu', (tester) async {
      final cloud = await openDetail(tester);
      await tester.tap(find.byTooltip('More actions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();
      expect(find.text('Reset web-1?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Power off'));
      await tester.pumpAndSettle();
      expect(find.text('Power off web-1?'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Power off'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(cloud.calls, contains('POST /servers/1/actions/poweroff'));
      expect(find.text('off'), findsOneWidget);
    });

    testWidgets('a failing action call shows its error', (tester) async {
      final cloud = await openDetail(tester);
      cloud.failWith = (423, errorJson('locked'));
      await tester.tap(find.text('Reboot'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Reboot'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'The resource is protected, locked or busy. Try again later.',
        ),
        findsOneWidget,
      );
    });
  });

  group('activity', () {
    List<Map<String, Object?>> history() => [
      FakeCloud.action(11, 'reboot_server', 1),
      FakeCloud.action(12, 'start_server', 2, status: 'error'),
    ];

    testWidgets('project activity lists all server actions', (tester) async {
      final cloud = FakeCloud(actions: history());
      await pumpFalco(tester, cloud);
      await tester.tap(find.byTooltip('Activity'));
      await tester.pumpAndSettle();
      expect(find.text('Reboot server'), findsOneWidget);
      expect(find.text('Power on server'), findsOneWidget);
      expect(
        actionCommandText(
          'reboot_server',
          lookupAppLocalizations(const Locale('de')),
        ),
        'Server neu starten',
      );
      expect(
        actionCommandText(
          'brand_new_thing',
          lookupAppLocalizations(const Locale('en')),
        ),
        'Brand new thing',
      );
      expect(find.text('server #1 · 5 minutes ago'), findsOneWidget);
      expect(cloud.calls, contains('GET /servers/actions'));
      await tester.tap(find.text('Failed'));
      await tester.pumpAndSettle();
      expect(find.text('Reboot server'), findsNothing);
      expect(find.text('Power on server'), findsOneWidget);
    });

    testWidgets('server activity shows only that server', (tester) async {
      final cloud = FakeCloud(actions: history());
      await pumpFalco(tester, cloud);
      await tester.tap(find.text('web-1'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Show all activity'), 200);
      await tester.pumpAndSettle();
      expect(find.text('Power on server'), findsNothing);
      await tester.tap(find.text('Show all activity'));
      await tester.pumpAndSettle();
      expect(find.text('Reboot server'), findsOneWidget);
      expect(find.text('Power on server'), findsNothing);
      expect(cloud.calls, contains('GET /servers/1/actions'));
    });

    testWidgets('empty state', (tester) async {
      await pumpFalco(tester, FakeCloud());
      await tester.tap(find.byTooltip('Activity'));
      await tester.pumpAndSettle();
      expect(find.text('No actions yet.'), findsOneWidget);
    });

    testWidgets('error state', (tester) async {
      final cloud = FakeCloud();
      await pumpFalco(tester, cloud);
      cloud.failWith = (500, errorJson('server_error'));
      await tester.tap(find.byTooltip('Activity'));
      await tester.pumpAndSettle();
      expect(find.text(_serverError), findsOneWidget);
    });
  });
}
