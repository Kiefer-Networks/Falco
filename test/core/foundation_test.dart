// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:async';

import 'package:falco/core/actions/action_tracker.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/pagination.dart';
import 'package:flutter_test/flutter_test.dart';

ActionProgress action(ActionStatus status, int progress, {String? error}) =>
    ActionProgress(
      id: 1,
      command: 'reboot_server',
      status: status,
      progress: progress,
      resources: const [('server', 42)],
      errorCode: error,
    );

void main() {
  group('fetchAll (QRS-016)', () {
    test('follows next_page until it is null', () async {
      final pages = <int>[];
      final all = await fetchAll<int>((page) async {
        pages.add(page);
        return (
          items: [page * 10, page * 10 + 1],
          nextPage: page < 3 ? page + 1 : null,
        );
      });
      expect(pages, [1, 2, 3]);
      expect(all, [10, 11, 20, 21, 30, 31]);
    });

    test('stops on a next_page that does not advance', () async {
      var calls = 0;
      await fetchAll<int>((page) async {
        calls++;
        return (items: const <int>[], nextPage: 1);
      });
      expect(calls, 1);
    });
  });

  group('ActionTracker (QRS-028)', () {
    test('polls until done and reports the end once', () async {
      final answers = [
        action(ActionStatus.running, 0),
        action(ActionStatus.running, 60),
        action(ActionStatus.success, 100),
      ];
      final done = <ActionProgress>[];
      final tracker = ActionTracker(
        (_) async => answers.removeAt(0),
        onDone: done.add,
        interval: Duration.zero,
      );
      final progress = await tracker.track(1).map((a) => a.progress).toList();
      expect(progress, [0, 60, 100]);
      expect(done.single.resources, [('server', 42)]);
      expect(tracker.running, isEmpty);
    });

    test('shares one poll loop per action and lists it as running', () async {
      final gate = Completer<ActionProgress>();
      var calls = 0;
      final tracker = ActionTracker((_) {
        calls++;
        return calls == 1
            ? Future.value(action(ActionStatus.running, 10))
            : gate.future;
      }, interval: Duration.zero);
      final a = tracker.track(1).toList();
      final b = tracker.track(1).toList();
      await pumpEventQueue();
      expect(tracker.running.single.progress, 10);
      gate.complete(action(ActionStatus.success, 100));
      expect((await a).length, 2);
      expect((await b).length, 2);
      expect(calls, 2);
    });

    test('rides out short network errors', () async {
      var calls = 0;
      final tracker = ActionTracker((_) async {
        if (++calls < 3) throw const Network();
        return action(ActionStatus.success, 100);
      }, interval: Duration.zero);
      final last = await tracker.track(1).last;
      expect(last.status, ActionStatus.success);
    });

    test('ends with an error when the action is gone', () async {
      final done = <ActionProgress>[];
      final tracker = ActionTracker(
        (_) async => throw const NotFound(code: 'not_found'),
        onDone: done.add,
        interval: Duration.zero,
      );
      final last = await tracker.track(1).last;
      expect(last.status, ActionStatus.error);
      expect(last.errorCode, 'not_found');
      expect(done, hasLength(1));
    });

    test('reports failed actions with their error code', () async {
      final tracker = ActionTracker(
        (_) async => action(ActionStatus.error, 100, error: 'action_failed'),
        interval: Duration.zero,
      );
      expect((await tracker.track(1).single).errorCode, 'action_failed');
    });
  });
}
