// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:async';

import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/scope/scope.dart';
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

  group('CreateWizard', () {
    Widget wizard({
      bool creating = false,
      VoidCallback? onLeave,
      int initialStep = 0,
    }) => CreateWizard(
      title: 'Create',
      creating: creating,
      onLeave: onLeave,
      initialStep: initialStep,
      onCreate: () {},
      summary: Builder(
        builder: (context) => TextButton(
          onPressed: () => CreateWizard.goTo(context, 0),
          child: const Text('summary'),
        ),
      ),
      steps: [
        WizardStep(
          title: 'Image',
          child: ChoiceList(
            options: const {'a': 'alpha', 'b': 'beta'},
            selected: '',
            searchable: true,
            onSelected: (_) {},
          ),
        ),
        WizardStep(
          title: 'Type',
          child: ChoiceList(
            options: const {'x': 'xray', 'y': 'yankee'},
            selected: '',
            onSelected: (_) {},
          ),
        ),
      ],
    );

    testWidgets('CMP-013 steps do not share a search query', (tester) async {
      await tester.pumpWidget(testApp(wizard()));
      await tester.enterText(find.byType(TextField), 'alp');
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('xray'), findsOneWidget);
      expect(find.text('yankee'), findsOneWidget);
    });

    testWidgets('CMP-013 close leaves the only route, not while creating', (
      tester,
    ) async {
      var left = 0;
      await tester.pumpWidget(testApp(wizard(onLeave: () => left++)));
      await tester.tap(find.byType(CloseButton));
      await tester.pump();
      expect(left, 1);
      await tester.pumpWidget(
        testApp(wizard(creating: true, onLeave: () => left++)),
      );
      expect(
        tester.widget<CloseButton>(find.byType(CloseButton)).onPressed,
        isNull,
      );
      expect(
        find.descendant(
          of: find.byType(CreateWizard),
          matching: find.byWidgetPredicate((w) => w is PopScope && !w.canPop),
        ),
        findsOneWidget,
      );
    });

    testWidgets('CMP-013 back and jumps wait while creating', (tester) async {
      await tester.pumpWidget(testApp(wizard(creating: true, initialStep: 2)));
      expect(
        tester
            .widget<OutlinedButton>(find.widgetWithText(OutlinedButton, 'Back'))
            .onPressed,
        isNull,
      );
      // The create button spins: pump, not settle.
      await tester.tap(find.text('summary'));
      await tester.pump();
      expect(find.text('STEP 3 OF 3'), findsOneWidget);
    });
  });

  group('loadForPicker', () {
    testWidgets('a failure is a snackbar, a second tap waits for the first', (
      tester,
    ) async {
      await tester.pumpWidget(testApp(const SizedBox()));
      final context = tester.element(find.byType(SizedBox));
      final first = Completer<int>();
      final loading = loadForPicker(context, () => first.future);
      expect(await loadForPicker(context, () async => 2), isNull);
      first.complete(1);
      expect(await loading, 1);
      expect(
        await loadForPicker<int>(context, () async => throw const Network()),
        isNull,
      );
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(await loadForPicker(context, () async => 3), 3);
    });
  });

  testWidgets('AreaOverview shows the banner over loaded tiles', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        AreaOverview(
          banner: 'Could not load: staging.',
          onRefresh: () async {},
          tiles: [
            OverviewTile(icon: Icons.dns, label: 'Servers', onTap: () {}),
          ],
        ),
      ),
    );
    expect(
      find.widgetWithText(ErrorBanner, 'Could not load: staging.'),
      findsOne,
    );
    expect(find.text('Servers'), findsOneWidget);
  });

  testWidgets('QRS-026 rows and action bar buttons take a screen reader tap', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      testApp(
        Column(
          children: [
            ResourceRow(
              status: ResourceStatus.running,
              name: 'web-1',
              monoLine: 'cx22',
              onTap: () => taps++,
            ),
            DetailActionBar(
              actions: [
                DetailAction(
                  icon: Icons.refresh,
                  label: 'Reboot',
                  group: ActionGroup.power,
                  onTap: () => taps++,
                ),
              ],
            ),
          ],
        ),
      ),
    );
    for (final label in [RegExp('^web-1'), RegExp('^Reboot')]) {
      tester.semantics.tap(find.semantics.byLabel(label));
    }
    expect(taps, 2);
  });

  testWidgets('QRS-008 the More sheet groups actions, danger zone last', (
    tester,
  ) async {
    var picked = '';
    DetailAction action(String label, ActionGroup group) => DetailAction(
      icon: Icons.circle,
      label: label,
      group: group,
      onTap: () => picked = label,
    );
    await tester.pumpWidget(
      testApp(
        Align(
          alignment: Alignment.bottomCenter,
          child: DetailActionBar(
            actions: [
              action('A', ActionGroup.power),
              action('B', ActionGroup.power),
              action('C', ActionGroup.power),
              action('Wipe', ActionGroup.danger),
              action('Rename', ActionGroup.manage),
              action('Off', ActionGroup.power),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    double y(String text) => tester.getTopLeft(find.text(text)).dy;
    expect(y('POWER') < y('Off'), isTrue);
    expect(y('Off') < y('MANAGE'), isTrue);
    expect(y('Rename') < y('DANGER ZONE'), isTrue);
    expect(y('DANGER ZONE') < y('Wipe'), isTrue);
    expect(find.text('NETWORK'), findsNothing);
    await tester.tap(find.text('Wipe'));
    await tester.pumpAndSettle();
    expect(picked, 'Wipe');
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

    testWidgets('names the projects a partial list misses', (tester) async {
      await tester.pumpWidget(
        testApp(
          list(
            items: PartialList(items.toList(), const [
              Project(id: 'p2', name: 'staging'),
            ]),
          ),
        ),
      );
      expect(
        find.text('Could not load: staging. Showing the other projects.'),
        findsOneWidget,
      );
      expect(find.byType(ListTile), findsNWidgets(3));
    });

    testWidgets('a filter menu keeps its choice when options move', (
      tester,
    ) async {
      Widget menu(List<ResourceFilter<_Item>> options) => ResourceList<_Item>(
        title: 'Servers',
        items: items,
        onRefresh: () async {},
        itemBuilder: (_, i) => ListTile(title: Text(i.name)),
        empty: const EmptyHint(message: 'Nothing here'),
        menuFilters: [ResourceMenuFilter('Type', options)],
      );
      final all = ResourceFilter<_Item>('All', (_) => true);
      final on = ResourceFilter<_Item>('On', (i) => i.on);
      final off = ResourceFilter<_Item>('Off', (i) => !i.on);
      await tester.pumpWidget(testApp(menu([all, on, off])));
      await tester.tap(find.text('Type: All'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Off').last);
      await tester.pumpAndSettle();
      expect(find.text('Type: Off'), findsOneWidget);
      await tester.pumpWidget(testApp(menu([all, off, on])));
      expect(find.text('Type: Off'), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('QRS-004 pull to refresh calls onRefresh', (tester) async {
      await tester.pumpWidget(testApp(list(items: items)));
      await tester.fling(find.text('alpha'), const Offset(0, 400), 1000);
      await tester.pumpAndSettle();
      expect(refreshes, 1);
    });
  });

  testWidgets('SET-021 QRS-026 the reveal hides the secret until shown, its '
      'icon buttons carry semantics labels', (tester) async {
    await tester.pumpWidget(
      testApp(const SecretReveal(label: 'Root password', secret: 's3cret')),
    );
    expect(find.byTooltip('Show'), findsOneWidget);
    expect(find.byTooltip('Copy'), findsOneWidget);
    expect(find.text('s3cret'), findsNothing);
    expect(find.bySemanticsLabel('Hidden secret'), findsOneWidget);
    await tester.tap(find.byTooltip('Show'));
    await tester.pump();
    expect(find.text('s3cret'), findsOneWidget);
    expect(find.byTooltip('Hide'), findsOneWidget);
  });

  group('SensitiveClipboard', () {
    final calls = <MethodCall>[];
    String? clip;

    void mock(WidgetTester tester, {required bool native, bool? marks}) {
      final messenger = tester.binding.defaultBinaryMessenger
        ..setMockMethodCallHandler(const MethodChannel('falco/clipboard'), (
          call,
        ) async {
          calls.add(call);
          // A platform without the channel answers nothing.
          if (!native) throw MissingPluginException();
          return marks;
        })
        ..setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            clip = (call.arguments as Map<Object?, Object?>)['text'] as String?;
          }
          return null;
        });
      calls.clear();
      clip = null;
      addTearDown(() {
        messenger
          ..setMockMethodCallHandler(
            const MethodChannel('falco/clipboard'),
            null,
          )
          ..setMockMethodCallHandler(SystemChannels.platform, null);
      });
    }

    testWidgets('SET-019 SET-020 the platform marks the copy sensitive and '
        'clears it after 60 s', (tester) async {
      mock(tester, native: true);
      await tester.pumpWidget(
        testApp(const SecretReveal(label: 'Root password', secret: 's3cret')),
      );
      await tester.tap(find.byTooltip('Copy'));
      await tester.pump();
      expect(calls.single.method, 'setSensitive');
      expect(calls.single.arguments, {'text': 's3cret', 'expirySeconds': 60});
      expect(clip, isNull);
      expect(
        find.text('Copied. The clipboard clears in 60 s.'),
        findsOneWidget,
      );
    });

    testWidgets('SET-020 Android before 13 cannot mark the copy and the user '
        'is told (K5)', (tester) async {
      mock(tester, native: true, marks: false);
      await tester.pumpWidget(
        testApp(const SecretReveal(label: 'Root password', secret: 's3cret')),
      );
      await tester.tap(find.byTooltip('Copy'));
      await tester.pump();
      expect(calls.single.method, 'setSensitive');
      expect(find.textContaining('cannot hide it'), findsOneWidget);
    });

    testWidgets('SET-019 SET-020 without the platform a plain copy is '
        'cleared after 60 s and the user is told', (tester) async {
      mock(tester, native: false);
      await tester.pumpWidget(
        testApp(const SecretReveal(label: 'Root password', secret: 's3cret')),
      );
      await tester.tap(find.byTooltip('Copy'));
      await tester.pump();
      expect(clip, 's3cret');
      expect(find.textContaining('cannot hide it'), findsOneWidget);
      await tester.pump(const Duration(seconds: 59));
      expect(clip, 's3cret');
      await tester.pump(const Duration(seconds: 1));
      expect(clip, '');
    });
  });
}
