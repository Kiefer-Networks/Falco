// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert' show utf8;

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/files/text_files.dart' show decodeText;
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/dns/zone_pages.dart';
import 'package:falco/features/dns/zones.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../fake_cloud.dart';
import '../network_steps.dart';
import '../steps.dart';

FakeCloud withZone() => FakeCloud(
  zones: [
    zoneJson(id: 5, name: 'example.com', records: 3),
    zoneJson(
      id: 6,
      name: 'example.org',
      primaries: [
        {'address': '192.0.2.53', 'port': 53},
      ],
    ),
  ],
  rrsets: {
    5: [
      rrsetJson(zone: 5, name: '@', type: 'A', values: ['203.0.113.1']),
      rrsetJson(
        zone: 5,
        name: 'www',
        type: 'CNAME',
        values: ['example.com.'],
        ttl: 600,
      ),
      rrsetJson(zone: 5, name: '@', type: 'TXT', values: ['"v=spf1 -all"']),
    ],
  },
);

Future<FakeCloud> openZone(
  WidgetTester tester, [
  String zone = 'example.com',
]) async {
  final cloud = await openNetwork(tester, 'DNS', cloud: withZone());
  await tap(tester, zone);
  return cloud;
}

void main() {
  testWidgets('DNS-001 zone list with records, TTL, mode', (tester) async {
    await openNetwork(tester, 'DNS', cloud: withZone());
    expect(find.text('3 records · TTL 3600 s'), findsOneWidget);
    expect(find.text('0 records · TTL 3600 s · Secondary'), findsOneWidget);
  });

  testWidgets('empty state offers create', (tester) async {
    await openNetwork(tester, 'DNS');
    expect(find.text('No DNS zones in this project yet.'), findsOneWidget);
  });

  testWidgets('DNS-005 DNS-006 DNS-023 detail with RRSets', (tester) async {
    await openZone(tester);
    expect(find.textContaining('hydrogen.ns.hetzner.com.'), findsWidgets);
    expect(find.text('www CNAME'), findsOneWidget);
    expect(find.text('example.com. · TTL 600 s'), findsOneWidget);
    expect(find.text('203.0.113.1 · TTL 3600 s'), findsOneWidget);
  });

  testWidgets('DNS-002 DNS-022 create a secondary zone', (tester) async {
    final cloud = await openNetwork(tester, 'DNS');
    await tap(tester, 'Create zone');
    await tap(tester, 'Secondary');
    await tap(tester, 'Next');
    await enter(tester, 'name', 'example.net');
    await enter(tester, 'ttl', '30');
    await enter(tester, 'primaries', '192.0.2.1:5353\n[2001:db8::1]:53');
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next'))
          .onPressed,
      isNull,
      reason: 'TTL under 60',
    );
    await enter(tester, 'ttl', '');
    await tap(tester, 'Next');
    await tap(tester, 'Create');
    expect(cloud.body('POST /zones'), {
      'name': 'example.net',
      'mode': 'secondary',
      'ttl': 3600,
      'primary_nameservers': [
        {'address': '192.0.2.1', 'port': 5353},
        {'address': '2001:db8::1', 'port': 53},
      ],
      'labels': <String, Object?>{},
    });
    await settleAction(tester);
  });

  testWidgets('DNS-003 DNS-024 DNS-025 edit TTL and labels, protection', (
    tester,
  ) async {
    final cloud = await openZone(tester);
    await tile(tester, 'Edit');
    expect(find.text('example.com'), findsWidgets, reason: 'name stays');
    await enter(tester, 'ttl', '7200');
    await enter(tester, 'labels', 'team=web');
    await tap(tester, 'Save');
    expect(cloud.body('POST /zones/5/actions/change_ttl'), {'ttl': 7200});
    expect(cloud.body('PUT /zones/5'), {
      'labels': {'team': 'web'},
    });
    await settleAction(tester);
    await tile(tester, 'Protection');
    await confirm(tester, 'Protect');
    expect(cloud.body('POST /zones/5/actions/change_protection'), {
      'delete': true,
    });
    await settleAction(tester);
  });

  testWidgets('DNS-022 a secondary zone loads no records and edits only '
      'labels', (tester) async {
    final cloud = await openZone(tester, 'example.org');
    expect(cloud.calls, isNot(contains('GET /zones/6/rrsets')));
    expect(
      find.text(
        'The records of a secondary zone come from its primary nameservers.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    expect(find.text('Export'), findsNothing);
    expect(find.text('Select records'), findsNothing);
    await tester.tapAt(Offset.zero);
    await tester.pumpAndSettle();
    await tile(tester, 'Edit');
    expect(find.byKey(const ValueKey('ttl')), findsNothing);
    await enter(tester, 'labels', 'team=dns');
    await tap(tester, 'Save');
    expect(cloud.calls.where((c) => c.contains('change_ttl')), isEmpty);
    expect(cloud.body('PUT /zones/6'), {
      'labels': {'team': 'dns'},
    });
  });

  testWidgets('DNS-004 delete needs the zone name', (tester) async {
    final cloud = await openZone(tester);
    await tap(tester, 'Delete');
    expect(find.textContaining('all its records'), findsOneWidget);
    await typeName(tester, 'example.com');
    await confirm(tester, 'Delete');
    expect(cloud.calls, contains('DELETE /zones/5'));
    await settleAction(tester);
  });

  testWidgets('DNS-007 DNS-008 DNS-009 DNS-026 add a TXT RRSet with TTL', (
    tester,
  ) async {
    final cloud = await openZone(tester);
    await tile(tester, 'Add record');
    await enter(tester, 'name', 'mail');
    await tap(tester, 'TXT');
    expect(find.text('TLSA'), findsOneWidget);
    expect(find.text('SOA'), findsNothing);
    await enter(tester, 'ttl', '59');
    await enter(tester, 'values', 'v=DKIM1; k=rsa');
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'))
          .onPressed,
      isNull,
    );
    await enter(tester, 'ttl', '300');
    await tap(tester, 'Save');
    expect(cloud.body('POST /zones/5/rrsets'), {
      'name': 'mail',
      'type': 'TXT',
      'ttl': 300,
      'records': [
        {'value': '"v=DKIM1; k=rsa"'},
      ],
      'labels': <String, Object?>{},
    });
    await settleAction(tester);
    expect(find.text('mail TXT'), findsOneWidget);
  });

  testWidgets('DNS-007 a value for an existing RRSet is added to it', (
    tester,
  ) async {
    final cloud = await openZone(tester);
    await tile(tester, 'Add record');
    await enter(tester, 'values', '203.0.113.2');
    await tap(tester, 'Save');
    expect(cloud.body('POST /zones/5/rrsets/@/A/actions/add_records'), {
      'records': [
        {'value': '203.0.113.2'},
      ],
    });
    await settleAction(tester);
  });

  testWidgets('DNS-007 a new TTL for an existing RRSet waits for the added '
      'value', (tester) async {
    final cloud = await openZone(tester);
    await tile(tester, 'Add record');
    await enter(tester, 'ttl', '7200');
    await enter(tester, 'values', '203.0.113.2');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(
      cloud.calls,
      contains('POST /zones/5/rrsets/@/A/actions/add_records'),
    );
    expect(cloud.calls.where((c) => c.contains('change_ttl')), isEmpty);
    await settleAction(tester);
    expect(cloud.body('POST /zones/5/rrsets/@/A/actions/change_ttl'), {
      'ttl': 7200,
    });
    await settleAction(tester);
  });

  testWidgets('DNS-007 labels for an existing RRSet join its labels', (
    tester,
  ) async {
    final cloud = await openZone(tester);
    await tile(tester, 'Add record');
    await enter(tester, 'values', '203.0.113.2');
    await enter(tester, 'labels', 'cdn=yes');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    // The labels follow the added value, never before it.
    expect(cloud.calls.where((c) => c.startsWith('PUT')), isEmpty);
    await settleAction(tester);
    expect(cloud.body('PUT /zones/5/rrsets/@/A'), {
      'labels': {'cdn': 'yes'},
    });
  });

  testWidgets('DNS-007 a failed added value keeps the form with an error '
      'and skips the TTL', (tester) async {
    final cloud = await openZone(tester);
    await tile(tester, 'Add record');
    await enter(tester, 'ttl', '7200');
    await enter(tester, 'values', '203.0.113.2');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pump(const Duration(milliseconds: 50));
    cloud.actions.first
      ..['status'] = 'error'
      ..['error'] = {'code': 'action_failed', 'message': 'failed'};
    await settleAction(tester);
    expect(cloud.calls.where((c) => c.contains('change_ttl')), isEmpty);
    expect(find.text('The action failed. (action_failed)'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Save'), findsOneWidget);
  });

  testWidgets('DNS-012 DNS-013 DNS-014 select, bulk edit, result', (
    tester,
  ) async {
    final cloud = await openZone(tester);
    await more(tester, 'Select records');
    await tap(tester, 'Select all');
    expect(find.text('3 selected'), findsOneWidget);
    await tap(tester, 'Clear');
    await more(tester, 'Select records');
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(find.text('1 selected'), findsOneWidget);
    await tap(tester, 'Edit selected');
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'))
          .onPressed,
      isNull,
      reason: 'value or TTL needed',
    );
    await enter(tester, 'ttl', '900');
    await tap(tester, 'Save');
    await confirm(tester, 'Save');
    expect(cloud.body('POST /zones/5/rrsets/@/A/actions/change_ttl'), {
      'ttl': 900,
    });
    await settleAction(tester);
    expect(find.text('Records updated'), findsOneWidget);
  });

  testWidgets('DNS-014 bulk edit counts failures', (tester) async {
    final cloud = await openZone(tester);
    await more(tester, 'Select records');
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    await tap(tester, 'Edit selected');
    await enter(tester, 'value', '203.0.113.9');
    await tap(tester, 'Save');
    expect(find.textContaining('replaced by the new value'), findsOneWidget);
    cloud.failWith = (422, errorJson('invalid_input'));
    await confirm(tester, 'Save');
    expect(find.text('1 record set failed'), findsOneWidget);
  });

  testWidgets('DNS-012 DNS-013 select all skips SOA and apex NS; mixed '
      'types change only the TTL, after a confirmation', (tester) async {
    final cloud = withZone();
    cloud.rrsets[5]!.addAll([
      rrsetJson(
        zone: 5,
        name: '@',
        type: 'SOA',
        values: ['ns.example. dns.example. 1 86400 10800 3600000 3600'],
      ),
      rrsetJson(zone: 5, name: '@', type: 'NS', values: ['ns1.example.']),
      rrsetJson(zone: 5, name: 'sub', type: 'NS', values: ['ns2.example.']),
    ]);
    await openNetwork(tester, 'DNS', cloud: cloud);
    await tap(tester, 'example.com');
    await more(tester, 'Select records');
    await tap(tester, 'Select all');
    expect(find.text('4 selected'), findsOneWidget);
    await tap(tester, 'Edit selected');
    expect(find.byKey(const ValueKey('value')), findsNothing);
    await enter(tester, 'ttl', '900');
    await tap(tester, 'Save');
    expect(find.text('Edit 4 record sets'), findsOneWidget);
    // The confirmation lists the affected RRSets, one per line.
    expect(find.text('@ A\nwww CNAME\n@ TXT\nsub NS'), findsOneWidget);
    expect(cloud.calls.where((c) => c.contains('change_ttl')), isEmpty);
    await confirm(tester, 'Save');
    // A zone runs one action at a time: each waits for the one before.
    expect(cloud.calls.where((c) => c.contains('change_ttl')), hasLength(1));
    for (var i = 0; i < 4; i++) {
      await settleAction(tester);
    }
    expect(cloud.calls.where((c) => c.contains('change_ttl')), hasLength(4));
  });

  testWidgets(
    'DNS-015 QRS-025 import replaces all records after the typed name',
    (tester) async {
      final cloud = await openZone(tester);
      cloud.files.picked = (text: 'www IN A 203.0.113.5', tooLarge: false);
      await more(tester, 'Import zone file');
      expect(find.text('Replace all records of example.com?'), findsOneWidget);
      await typeName(tester, 'example.com');
      await confirm(tester, 'Import zone file');
      expect(cloud.body('POST /zones/5/actions/import_zonefile'), {
        'zonefile': 'www IN A 203.0.113.5',
      });
      await settleAction(tester);
      cloud.files.picked = (text: null, tooLarge: true);
      await more(tester, 'Import zone file');
      expect(find.text('The file is larger than 1 MiB.'), findsOneWidget);
    },
  );

  testWidgets('DNS-015 a file that is not UTF-8 text says so', (tester) async {
    expect(decodeText([0xff, 0xfe]), isNull);
    expect(decodeText(utf8.encode('www IN A 203.0.113.5')), isNotNull);
    // A byte order mark would hide a leading $ORIGIN.
    expect(
      decodeText([0xef, 0xbb, 0xbf, ...utf8.encode(r'$ORIGIN x.')]),
      r'$ORIGIN x.',
    );
    final cloud = await openZone(tester);
    cloud.files.picked = (text: null, tooLarge: false);
    await more(tester, 'Import zone file');
    expect(find.text('The file is not UTF-8 text.'), findsOneWidget);
  });

  testWidgets('DNS-016 export saves the BIND file', (tester) async {
    final cloud = await openZone(tester);
    await tile(tester, 'Export');
    expect(
      cloud.files.saved['example.com.zone'],
      contains('@ IN A 203.0.113.1'),
    );
    expect(find.text('Zone file saved'), findsOneWidget);
  });

  testWidgets('DNS-017 DNS-018 DNS-019 DNS-020 primary nameservers', (
    tester,
  ) async {
    final cloud = await openZone(tester, 'example.org');
    expect(find.text('192.0.2.53:53'), findsOneWidget);
    await more(tester, 'Add primary nameserver');
    await enter(tester, 'address', '192.0.2.54');
    await enter(tester, 'port', '0');
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'))
          .onPressed,
      isNull,
    );
    await enter(tester, 'port', '53');
    await tap(tester, 'Save');
    expect(cloud.body('POST /zones/6/actions/change_primary_nameservers'), {
      'primary_nameservers': [
        {'address': '192.0.2.53', 'port': 53},
        {'address': '192.0.2.54', 'port': 53},
      ],
    });
    await settleAction(tester);
    await tap(tester, '192.0.2.54:53');
    await enter(tester, 'port', '5353');
    await tap(tester, 'Save');
    expect(
      (cloud.body(
                'POST /zones/6/actions/change_primary_nameservers',
              )['primary_nameservers']!
              as List)
          .last,
      {'address': '192.0.2.54', 'port': 5353},
    );
    await settleAction(tester);
    await tester.tap(find.byTooltip('Remove').first);
    await tester.pumpAndSettle();
    expect(find.text('Remove 192.0.2.53:53?'), findsOneWidget);
    await confirm(tester, 'Remove');
    expect(cloud.body('POST /zones/6/actions/change_primary_nameservers'), {
      'primary_nameservers': [
        {'address': '192.0.2.54', 'port': 5353},
      ],
    });
    await settleAction(tester);
  });

  testWidgets('DNS-018 DNS-019 TSIG of primaries is kept and editable', (
    tester,
  ) async {
    final cloud = FakeCloud(
      zones: [
        zoneJson(
          id: 6,
          name: 'example.org',
          primaries: [
            {
              'address': '192.0.2.53',
              'port': 53,
              'tsig_key': 'c2VjcmV0',
              'tsig_algorithm': 'hmac-sha256',
            },
          ],
        ),
      ],
    );
    await openNetwork(tester, 'DNS', cloud: cloud);
    await tap(tester, 'example.org');
    expect(find.text('hmac-sha256'), findsOneWidget);
    await more(tester, 'Add primary nameserver');
    await enter(tester, 'address', '192.0.2.54');
    await tap(tester, 'hmac-sha1');
    await enter(tester, 'tsig_key', 'a2V5');
    await tap(tester, 'Save');
    expect(cloud.body('POST /zones/6/actions/change_primary_nameservers'), {
      'primary_nameservers': [
        {
          'address': '192.0.2.53',
          'port': 53,
          'tsig_key': 'c2VjcmV0',
          'tsig_algorithm': 'hmac-sha256',
        },
        {
          'address': '192.0.2.54',
          'port': 53,
          'tsig_key': 'a2V5',
          'tsig_algorithm': 'hmac-sha1',
        },
      ],
    });
    await settleAction(tester);
  });

  testWidgets('DNS-006 refresh reloads the records; a failure keeps them '
      'with a retry', (tester) async {
    final cloud = await openZone(tester);
    int loads() => cloud.calls.where((c) => c.endsWith('/rrsets')).length;
    final before = loads();
    cloud.failWith = (503, errorJson('unavailable'));
    await tester.fling(find.text('www CNAME'), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();
    expect(loads(), greaterThan(before));
    expect(find.text('www CNAME'), findsOneWidget);
    expect(find.byTooltip('Try again'), findsOneWidget);
    cloud.failWith = null;
    await tester.tap(find.byTooltip('Try again'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Try again'), findsNothing);
  });

  group('RRSet detail', () {
    Future<FakeCloud> openSet(WidgetTester tester) async {
      final cloud = await openZone(tester);
      await tap(tester, 'www CNAME');
      return cloud;
    }

    testWidgets(
      'DNS-027 DNS-010 DNS-031 value edit replaces, comment updates',
      (tester) async {
        final cloud = await openSet(tester);
        expect(cloud.calls, contains('GET /zones/5/rrsets/www/CNAME'));
        await tap(tester, 'example.com.');
        await enter(tester, 'comment', 'apex');
        await tap(tester, 'Save');
        expect(
          cloud.body('POST /zones/5/rrsets/www/CNAME/actions/update_records'),
          {
            'records': [
              {'value': 'example.com.', 'comment': 'apex'},
            ],
          },
        );
        await settleAction(tester);
        await tap(tester, 'example.com.');
        await enter(tester, 'value', 'example.net');
        await tap(tester, 'Save');
        expect(
          cloud.body('POST /zones/5/rrsets/www/CNAME/actions/set_records'),
          {
            'records': [
              {'value': 'example.net.', 'comment': 'apex'},
            ],
          },
        );
        await settleAction(tester);
      },
    );

    testWidgets('DNS-007 DNS-011 add and remove a value', (tester) async {
      final cloud = await openSet(tester);
      await tile(tester, 'Add value');
      await enter(tester, 'values', 'cdn.example.net');
      await tap(tester, 'Save');
      expect(cloud.body('POST /zones/5/rrsets/www/CNAME/actions/add_records'), {
        'records': [
          {'value': 'cdn.example.net.'},
        ],
      });
      await settleAction(tester);
      await tester.tap(find.byTooltip('Delete').first);
      await tester.pumpAndSettle();
      await confirm(tester, 'Delete');
      expect(
        cloud.body('POST /zones/5/rrsets/www/CNAME/actions/remove_records'),
        {
          'records': [
            {'value': 'example.com.'},
          ],
        },
      );
      await settleAction(tester);
    });

    testWidgets('DNS-010 DNS-028 DNS-030 TTL, labels, protection', (
      tester,
    ) async {
      final cloud = await openSet(tester);
      await tile(tester, 'Edit');
      await enter(tester, 'ttl', '');
      await enter(tester, 'labels', 'cdn=yes');
      await tap(tester, 'Save');
      expect(cloud.body('POST /zones/5/rrsets/www/CNAME/actions/change_ttl'), {
        'ttl': null,
      });
      expect(cloud.body('PUT /zones/5/rrsets/www/CNAME'), {
        'labels': {'cdn': 'yes'},
      });
      await settleAction(tester);
      await tile(tester, 'Protection');
      await confirm(tester, 'Protect');
      expect(
        cloud.body('POST /zones/5/rrsets/www/CNAME/actions/change_protection'),
        {'change': true},
      );
      await settleAction(tester);
    });

    testWidgets('DNS-029 delete the RRSet', (tester) async {
      final cloud = await openSet(tester);
      await tap(tester, 'Delete');
      await typeName(tester, 'www/CNAME');
      await confirm(tester, 'Delete');
      expect(cloud.calls, contains('DELETE /zones/5/rrsets/www/CNAME'));
      await settleAction(tester);
    });
  });

  test('DNS-009 normalizes values per type', () {
    expect(normalizeRecord('TXT', 'v=spf1 -all'), '"v=spf1 -all"');
    expect(normalizeRecord('TXT', '"quoted"'), '"quoted"');
    expect(normalizeRecord('TXT', 'say "hi"'), r'"say \"hi\""');
    expect(normalizeRecord('CNAME', 'example.com'), 'example.com.');
    expect(normalizeRecord('CNAME', 'example.com.'), 'example.com.');
    expect(
      normalizeRecord('MX', '10 mail.example.com'),
      '10 mail.example.com.',
    );
    expect(
      normalizeRecord('SRV', '10 5 5060 sip.example.com'),
      '10 5 5060 sip.example.com.',
    );
    expect(normalizeRecord('A', ' 203.0.113.1 '), '203.0.113.1');
  });

  test('DNS-009 TXT values over 255 bytes go out as several strings', () {
    final long = 'a' * 300;
    expect(normalizeRecord('TXT', long), '"${'a' * 255}" "${'a' * 45}"');
    expect(
      normalizeRecord('TXT', '"$long" "b"'),
      '"${'a' * 255}" "${'a' * 45}" "b"',
    );
    // An escape counts as one byte and is never split.
    expect(normalizeRecord('TXT', '${'a' * 254}"x'), '"${'a' * 254}\\"" "x"');
    // Bytes, not characters: ü takes two.
    expect(normalizeRecord('TXT', 'ü' * 128), '"${'ü' * 127}" "ü"');
  });

  test('DNS-002 DNS-007 BUG-003 one TTL rule from the spec', () {
    expect(validTtl(''), isTrue);
    expect(validTtl('', optional: false), isFalse);
    expect(validTtl('59'), isFalse);
    expect(validTtl('60'), isTrue);
    expect(validTtl('2147483648'), isFalse);
  });

  test('DNS-008 every record type of the spec but SOA', () {
    expect(
      rrTypes,
      containsAll([
        'A',
        'AAAA',
        'CAA',
        'MX',
        'PTR',
        'DS',
        'TLSA',
        'HINFO',
        'RP',
      ]),
    );
    expect(rrTypes, isNot(contains('SOA')));
  });

  test('DNS-018 nameserver parsing', () {
    expect(parseNameserver('192.0.2.1'), (
      address: '192.0.2.1',
      port: 53,
      tsigKey: null,
      tsigAlgorithm: null,
    ));
    expect(parseNameserver('ns.example.com:5353')?.port, 5353);
    expect(parseNameserver('[2001:db8::1]:53')?.address, '2001:db8::1');
    expect(parseNameserver('192.0.2.1:70000'), isNull);
    // A digit run past int range is invalid, not a crash in build.
    expect(parseNameserver('192.0.2.1:${'9' * 30}'), isNull);
    expect(parseNameservers('192.0.2.1:${'9' * 30}'), isNull);
    expect(parseNameservers('a.example\nb.example:54'), hasLength(2));
    expect(validNameserverPort('53'), isTrue);
  });

  test('DNS-021 BUG-005 BUG-006 zones of all projects as RRSets', () async {
    final cloud = withZone();
    final c = await fakeContainer(
      cloud,
      accounts: const [
        Account(
          id: 'a1',
          name: 'Acme',
          projects: [
            Project(id: 'p1', name: 'prod'),
            Project(id: 'p2', name: 'dev'),
          ],
        ),
      ],
    );
    final zones = await c.read(
      zonesProvider(const AllProjectsScope('a1')).future,
    );
    expect(zones.map((z) => z.projectId), containsAll(['p1', 'p2']));
    final sets = await c.read(
      rrsetsProvider(const ProjectScope('a1', 'p1'), 5).future,
    );
    expect(sets.first.key, '@/A');
    // Changes come back as actions the tracker follows (DNS-021).
    final api = c.read(cloudApiProvider('p1'));
    expect(await changeZone(api, 5, const ChangeZoneTtl(120)), isPositive);
  });
}
