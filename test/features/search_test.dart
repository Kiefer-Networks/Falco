// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/scope/scope.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/features/search/search.dart';
import 'package:falco/features/search/search_page.dart';
import 'package:falco/features/servers/servers.dart';
import 'package:falco/l10n/app_localizations_en.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';
import '../helpers.dart' hide setSurface;
import '../search_steps.dart';
import '../steps.dart';

final _en = AppLocalizationsEn();

/// Acme (Robot) and Beta with project "staging".
const _beta = Account(
  id: 'a2',
  name: 'Beta',
  projects: [Project(id: 'p2', name: 'staging')],
);

void main() {
  group('index', () {
    Future<SearchIndexState> load(
      FakeCloud cloud, {
      List<Account> accounts = const [acmeRobot],
    }) async {
      final c = await fakeContainer(cloud, accounts: accounts, s3: true);
      return await settled(c);
    }

    SearchHit hit(SearchIndexState index, String query, [SearchGroup? g]) =>
        searchHits(
          index.hits,
          query,
        ).firstWhere((h) => g == null || h.group == g);

    test('SUC-002 loads every resource of every project plus Robot', () async {
      final cloud = searchCloud();
      final index = await load(cloud);
      expect(index.failed, 0);
      expect({for (final h in index.hits) h.group}, SearchGroup.values.toSet());
      for (final call in [
        'GET /servers',
        'GET /volumes',
        'GET /networks',
        'GET /floating_ips',
        'GET /primary_ips',
        'GET /firewalls',
        'GET /load_balancers',
        'GET /certificates',
        'GET /placement_groups',
        'GET /ssh_keys',
        'GET /storage_boxes',
        'GET /zones',
        'GET /server',
      ]) {
        expect(cloud.calls, contains(call));
      }
      // System images are in every project; only own images count.
      expect(searchHits(index.hits, 'debian'), isEmpty);
    });

    test('matches name, IP, label and id; every word must match', () async {
      final index = await load(searchCloud());
      expect(hit(index, 'WEB-1').name, 'web-1');
      expect(hit(index, '203.0.113.2').name, 'db-1');
      expect(hit(index, 'env=prod').name, 'web-1');
      expect(hit(index, '35').name, 'web-lb');
      expect(hit(index, '15:28:b0').name, 'laptop');
      expect(searchHits(index.hits, 'web env=prod').map((h) => h.name), [
        'web-1',
      ]);
      // The account and project name match too.
      expect(searchHits(index.hits, 'acme robot server1'), hasLength(1));
      expect(searchHits(index.hits, '  '), isEmpty);
      expect(searchHits(index.hits, 'nothing-like-this'), isEmpty);
    });

    test('SUC-003 hits come grouped by type, then by name', () async {
      final index = await load(searchCloud());
      expect(searchHits(index.hits, 'web').map((h) => h.group), [
        SearchGroup.server,
        SearchGroup.image,
        SearchGroup.placementGroup,
        SearchGroup.firewall,
        SearchGroup.floatingIp,
        SearchGroup.loadBalancer,
        SearchGroup.certificate,
      ]);
    });

    test('SUC-004 the line below the name', () async {
      final index = await load(searchCloud());
      String detail(String q, [SearchGroup? g]) => hit(index, q, g).detail(_en);
      expect(detail('example.com', SearchGroup.zone), '3 records');
      expect(detail('backend-net'), '10.0.0.0/16');
      expect(detail('deploy'), contains(':'));
      expect(
        detail('laptop'),
        '15:28:b0:03:95:f0:77:b3:10:56:15:6b:77:22:a5:bb',
      );
      expect(detail('backup'), contains('u'));
      expect(detail('web-1'), '203.0.113.1 · cx22 · fsn1');
      expect(hit(index, 'web-1').where, 'Acme · prod');
      expect(hit(index, 'server1').where, 'Acme · Robot');
    });

    test('SUC-005 every hit opens its page in its scope', () async {
      final index = await load(searchCloud());
      String at(String q, [SearchGroup? g]) => hit(index, q, g).route.location;
      expect(at('web-1'), '/a/a1/p/p1/servers/1');
      expect(at('data'), '/a/a1/p/p1/volumes/21');
      expect(at('nightly'), '/a/a1/p/p1/images/8');
      expect(at('spread-web'), '/a/a1/p/p1/placement-groups/23');
      expect(at('deploy'), '/a/a1/p/p1/ssh-keys/24');
      expect(at('backend-net'), '/a/a1/p/p1/networks/31');
      expect(at('web-fw'), '/a/a1/p/p1/firewalls/32');
      expect(at('web-ip'), '/a/a1/p/p1/ips/floating/33');
      expect(at('mail-ip'), '/a/a1/p/p1/ips/primary/34');
      expect(at('web-lb'), '/a/a1/p/p1/load-balancers/35');
      expect(at('web-cert'), '/a/a1/p/p1/certificates/36');
      expect(at('example.com', SearchGroup.zone), '/a/a1/p/p1/zones/37');
      expect(at('backup'), '/a/a1/p/p1/storage-boxes/41');
      expect(at('media'), '/a/a1/p/p1/buckets/fsn1/media');
      expect(at('server1'), '/a/a1/robot/servers/321');
      expect(at('123.123.123.200'), '/a/a1/robot/failover/123.123.123.200');
      expect(at('vlan 4000'), '/a/a1/robot/vswitches/1234');
      expect(at('laptop'), startsWith('/a/a1/robot/keys/'));
    });

    test('hits of every account carry their own scope', () async {
      final index = await load(
        searchCloud(),
        accounts: const [acmeRobot, _beta],
      );
      final web = searchHits(
        index.hits,
        'web-1',
      ).where((h) => h.group == SearchGroup.server);
      expect(
        {for (final h in web) h.route.location},
        {'/a/a1/p/p1/servers/1', '/a/a2/p/p2/servers/1'},
      );
      expect({for (final h in web) h.where}, {'Acme · prod', 'Beta · staging'});
    });

    test('a failed refresh keeps the loaded hits (offline)', () async {
      final cloud = searchCloud();
      final c = await fakeContainer(
        cloud,
        accounts: const [acmeRobot],
        s3: true,
      );
      await settled(c);
      cloud.failWith = (500, errorJson('server_error'));
      c.invalidate(serversProvider);
      final stale = await settled(c);
      expect(stale.failed, greaterThan(0));
      expect(searchHits(stale.hits, 'web-1'), isNotEmpty);
    });

    test('nothing loaded and every source failing is an error', () async {
      final cloud = searchCloud()..failWith = (500, errorJson('server_error'));
      final c = await fakeContainer(
        cloud,
        accounts: const [acmeRobot],
        s3: true,
      );
      final index = await settled(c);
      expect(index.hits, isEmpty);
      expect(index.error, isNotNull);
    });
  });

  group('recent searches', () {
    test('newest first, without repeats, at most eight, stored', () async {
      final c = await fakeContainer(FakeCloud());
      final recent = c.read(recentSearchesProvider.notifier);
      for (var i = 0; i < 10; i++) {
        recent.add('q$i');
      }
      recent
        ..add('q5')
        ..add('  ');
      expect(c.read(recentSearchesProvider), [
        'q5',
        'q9',
        'q8',
        'q7',
        'q6',
        'q4',
        'q3',
        'q2',
      ]);
      expect(
        c.read(preferencesProvider).getStringList('recentSearches')!.first,
        'q5',
      );
      recent.clear();
      expect(c.read(recentSearchesProvider), isEmpty);
    });
  });

  group('page', () {
    testWidgets('SUC-001 hint before input, nothing matches', (tester) async {
      await openSearch(tester);
      expect(
        find.text(
          'Search servers, IPs, labels and IDs in all accounts, projects '
          'and Robot.',
        ),
        findsOneWidget,
      );
      await search(tester, 'nothing-like-this');
      expect(find.text('Nothing matches.'), findsOneWidget);
    });

    testWidgets('SUC-003 results grouped by type', (tester) async {
      await openSearch(tester, query: 'backend');
      expect(find.text('NETWORKS'), findsOneWidget);
      expect(find.text('VSWITCHES'), findsOneWidget);
      expect(find.widgetWithText(ResourceRow, 'backend-net'), findsOneWidget);
      expect(find.widgetWithText(ResourceRow, 'backend'), findsOneWidget);
    });

    testWidgets('SUC-005 a hit opens its page; the search is remembered', (
      tester,
    ) async {
      await openSearch(tester, query: 'mail');
      await tap(tester, 'mail-ip');
      expect(find.text('198.51.100.20'), findsWidgets);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await search(tester, '');
      expect(find.text('RECENT SEARCHES'), findsOneWidget);
      await tap(tester, 'mail');
      expect(find.text('mail-ip'), findsOneWidget);
      await search(tester, '');
      await tap(tester, 'Clear');
      expect(find.text('RECENT SEARCHES'), findsNothing);
    });

    testWidgets('loading shows skeleton rows', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            preferencesProvider.overrideWithValue(await testPrefs()),
            searchIndexProvider.overrideWithValue((
              hits: const [],
              loading: true,
              failed: 0,
              error: null,
            )),
          ],
          child: testApp(const SearchPage()),
        ),
      );
      await tester.enterText(find.byType(TextField), 'web');
      await tester.pump();
      expect(find.bySemanticsLabel('Loading'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('error card when nothing could be loaded', (tester) async {
      final cloud = searchCloud();
      setSurface(tester);
      await pumpFalco(tester, cloud);
      cloud.failWith = (500, errorJson('server_error'));
      await tester.tap(find.byTooltip('Search'));
      await tester.pumpAndSettle();
      await search(tester, 'web');
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('banner when a source failed, other hits stay', (tester) async {
      final cloud = searchCloud()..validTokens.clear();
      await openSearch(tester, cloud: cloud, query: 'server1');
      expect(find.widgetWithText(ResourceRow, 'server1'), findsOneWidget);
      expect(
        find.text('Could not refresh. Showing the last loaded data.'),
        findsOneWidget,
      );
    });
  });

  group('navigation', () {
    for (final (area, tab) in [
      ('Compute', 'Servers'),
      ('Network', 'Networks'),
      ('Storage', 'Storage Boxes'),
    ]) {
      testWidgets('QRS-001 from Robot, $area opens $area of the project', (
        tester,
      ) async {
        setSurface(tester);
        await pumpFalco(tester, FakeCloud(), accounts: const [acmeRobot]);
        await tester.tap(find.text('Robot').last);
        await tester.pumpAndSettle();
        await tester.tap(find.text(area).last);
        await tester.pumpAndSettle();
        expect(find.text('prod'), findsOneWidget);
        expect(find.widgetWithText(Tab, tab), findsOneWidget);
      });
    }
  });
}

/// The index of [c] once no source is loading any more.
Future<SearchIndexState> settled(ProviderContainer c) async {
  final sub = c.listen(searchIndexProvider, (_, _) {});
  addTearDown(sub.close);
  for (var i = 0; i < 400 && c.read(searchIndexProvider).loading; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
  final index = c.read(searchIndexProvider);
  return index;
}
