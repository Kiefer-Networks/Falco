// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/ui/ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers.dart';

typedef _Item = ({String name, bool on});

void main() {
  group('ConfirmSheet level 2', () {
    test('matches trimmed input case sensitively', () {
      expect(ConfirmSheet.matches('db-primary', 'db-primary'), isTrue);
      expect(ConfirmSheet.matches('  db-primary \n', 'db-primary'), isTrue);
      expect(ConfirmSheet.matches('DB-primary', 'db-primary'), isFalse);
      expect(ConfirmSheet.matches('db-prim', 'db-primary'), isFalse);
      expect(ConfirmSheet.matches('', 'db-primary'), isFalse);
    });

    testWidgets('QRS-010 confirm stays disabled until the name matches', (
      tester,
    ) async {
      bool? result;
      await tester.pumpWidget(
        testApp(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async => result = await ConfirmSheet.show(
                context,
                title: 'Delete db-primary?',
                consequence: 'Gone.',
                confirmLabel: 'Delete',
                resourceName: 'db-primary',
                level: ConfirmLevel.typeName,
                destructive: true,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      FilledButton confirm() =>
          tester.widget(find.widgetWithText(FilledButton, 'Delete'));
      expect(confirm().onPressed, isNull);

      await tester.enterText(find.byType(TextField), 'DB-PRIMARY');
      await tester.pump();
      expect(confirm().onPressed, isNull);

      await tester.enterText(find.byType(TextField), ' db-primary ');
      await tester.pump();
      expect(confirm().onPressed, isNotNull);

      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });

    testWidgets('QRS-009 level 1 confirms without typing, cancel resolves '
        'false', (tester) async {
      final results = <bool>[];
      await tester.pumpWidget(
        testApp(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async => results.add(
                await ConfirmSheet.show(
                  context,
                  title: 'Reboot?',
                  consequence: 'Restarts.',
                  confirmLabel: 'Reboot now',
                  resourceName: 'db-primary',
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNothing);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reboot now'));
      await tester.pumpAndSettle();
      expect(results, [false, true]);
    });
  });

  testWidgets('CopyableValue copies the raw value and confirms', (
    tester,
  ) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map<Object?, Object?>)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await tester.pumpWidget(
      testApp(const CopyableValue('2a01:4f8::1', copyText: '2a01:4f8::1/64')),
    );
    expect(
      tester.getSize(find.byType(CopyableValue)).height,
      greaterThanOrEqualTo(kFalcoMinTouchTarget),
    );
    expect(find.bySemanticsLabel('Copy 2a01:4f8::1'), findsOneWidget);

    await tester.tap(find.byType(CopyableValue));
    await tester.pump();
    expect(copied, '2a01:4f8::1/64');
    expect(find.text('Copied to clipboard'), findsOneWidget);
  });

  group('ResourceList', () {
    const items = <_Item>[
      (name: 'beta', on: true),
      (name: 'alpha', on: false),
      (name: 'gamma', on: true),
    ];
    var refreshes = 0;

    Widget list({List<_Item>? items, String? error}) => ResourceList<_Item>(
      title: 'Servers',
      items: items,
      error: error,
      onRefresh: () async => refreshes++,
      itemBuilder: (_, i) => ListTile(title: Text(i.name)),
      searchText: (i) => i.name,
      filters: [
        ResourceFilter('All', (_) => true),
        ResourceFilter('On', (i) => i.on),
      ],
      sorts: [ResourceSort('name', (a, b) => a.name.compareTo(b.name))],
      empty: const EmptyHint(message: 'Nothing here'),
    );

    setUp(() => refreshes = 0);

    testWidgets('shows skeleton rows before the first load', (tester) async {
      await tester.pumpWidget(testApp(list()));
      expect(find.bySemanticsLabel('Loading'), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
      expect(find.text('SERVERS · –'), findsOneWidget);
    });

    testWidgets('shows sorted items, searches and filters', (tester) async {
      await tester.pumpWidget(testApp(list(items: items)));
      expect(find.text('SERVERS · 3'), findsOneWidget);
      final names = tester
          .widgetList<ListTile>(find.byType(ListTile))
          .map((t) => (t.title! as Text).data)
          .toList();
      expect(names, ['alpha', 'beta', 'gamma']);

      await tester.enterText(find.byType(TextField), 'GAM');
      await tester.pump();
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('gamma'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '');
      await tester.tap(find.text('On'));
      await tester.pump();
      expect(find.text('alpha'), findsNothing);
      expect(find.text('SERVERS · 2'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'alpha');
      await tester.pump();
      expect(
        find.text('No results for this search or filter.'),
        findsOneWidget,
      );
    });

    testWidgets('shows the empty hint', (tester) async {
      await tester.pumpWidget(testApp(list(items: const [])));
      expect(find.text('Nothing here'), findsOneWidget);
    });

    testWidgets('shows an error card without data and retries', (tester) async {
      await tester.pumpWidget(testApp(list(error: 'No connection')));
      expect(find.byType(ErrorCard), findsOneWidget);
      expect(find.text('No connection'), findsOneWidget);
      await tester.tap(find.text('Try again'));
      expect(refreshes, 1);
    });

    testWidgets('keeps stale data visible under an error banner', (
      tester,
    ) async {
      await tester.pumpWidget(
        testApp(list(items: items, error: 'No connection')),
      );
      expect(find.byType(ErrorBanner), findsOneWidget);
      expect(find.byType(ErrorCard), findsNothing);
      expect(find.byType(ListTile), findsNWidgets(3));
    });

    testWidgets('QRS-004 pull to refresh calls onRefresh', (tester) async {
      await tester.pumpWidget(testApp(list(items: items)));
      await tester.fling(find.text('alpha'), const Offset(0, 400), 1000);
      await tester.pumpAndSettle();
      expect(refreshes, 1);
    });
  });

  testWidgets('icon buttons carry semantics labels', (tester) async {
    await tester.pumpWidget(
      testApp(const SecretReveal(label: 'Root password', secret: 's3cret')),
    );
    expect(find.byTooltip('Show'), findsOneWidget);
    expect(find.byTooltip('Copy'), findsOneWidget);
    expect(find.text('s3cret'), findsNothing);
    await tester.tap(find.byTooltip('Show'));
    await tester.pump();
    expect(find.text('s3cret'), findsOneWidget);
    expect(find.byTooltip('Hide'), findsOneWidget);
  });
}
