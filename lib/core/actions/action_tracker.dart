// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:async';

import 'package:falco/core/errors/falco_error.dart';

/// Status of a Hetzner action.
enum ActionStatus {
  /// Still running.
  running,

  /// Finished successfully.
  success,

  /// Finished with an error.
  error,
}

/// Snapshot of a Hetzner action, independent of the API it came from.
class ActionProgress {
  /// Creates a snapshot.
  const new({
    required this.id,
    required this.command,
    required this.status,
    required this.progress,
    this.resources = const [],
    this.errorCode,
    this.started,
    this.finished,
  });

  /// Action id.
  final int id;

  /// Command, e.g. `start_server`.
  final String command;

  /// Current status.
  final ActionStatus status;

  /// Progress in percent, 0 to 100.
  final int progress;

  /// Affected resources as (type, id), e.g. `('server', 42)`.
  final List<(String, int)> resources;

  /// Error code of a failed action, or of the polling itself.
  final String? errorCode;

  /// Start time, when the API reported it (activity view).
  final DateTime? started;

  /// End time of an ended action, when the API reported it.
  final DateTime? finished;

  /// True once the action ended.
  bool get done => status != ActionStatus.running;
}

/// Follows Hetzner actions until they end (QRS-028).
///
/// `fetch` loads one action (`GET /actions/{id}` or the Storage Box
/// equivalent). Each finished action is reported once to [onDone], which
/// invalidates the affected resources. The activity view reads [running].
///
/// Polling runs until the action ends, whether or not a screen listens, so
/// a detail page opened again finds its progress in [running] and
/// [changes].
class ActionTracker {
  /// Creates a tracker.
  new(
    this._fetch, {
    this.onDone,
    this.interval = const Duration(seconds: 1),
    this.maxInterval = const Duration(seconds: 5),
    this.maxFailures = 5,
  });

  final Future<ActionProgress> Function(int id) _fetch;

  /// Called once per finished action.
  final void Function(ActionProgress action)? onDone;

  /// First poll delay; grows by half per poll up to [maxInterval].
  final Duration interval;

  /// Upper bound of the poll delay.
  final Duration maxInterval;

  /// Consecutive transient poll failures (network, rate limit, 5xx) after
  /// which tracking ends with an error.
  final int maxFailures;

  final _streams = <int, Stream<ActionProgress>>{};
  final _latest = <int, ActionProgress>{};
  final _changes = StreamController<ActionProgress>.broadcast();

  /// Every update of every tracked action.
  Stream<ActionProgress> get changes => _changes.stream;

  /// Actions that are being followed and have not ended.
  Iterable<ActionProgress> get running => _latest.values.where((a) => !a.done);

  /// Progress of action [id] until it ends. Tracking an id twice shares
  /// one poll loop.
  Stream<ActionProgress> track(int id) =>
      _streams[id] ??= _poll(id).asBroadcastStream()
        ..listen(null, onError: (Object _) {});

  Stream<ActionProgress> _poll(int id) async* {
    var delay = interval;
    var failures = 0;
    try {
      while (true) {
        ActionProgress action;
        try {
          action = await _fetch(id);
          failures = 0;
        } on FalcoError catch (e) {
          // Hiccups (network, rate limit, 5xx) must not end the tracking
          // while the action still runs; gone, forbidden or unauthorized do,
          // and so does a hiccup that keeps coming.
          final transient = e is Network || e is RateLimited || e is Server;
          if (!transient || ++failures >= maxFailures) {
            action = ActionProgress(
              id: id,
              command: _latest[id]?.command ?? '',
              status: ActionStatus.error,
              progress: _latest[id]?.progress ?? 0,
              resources: _latest[id]?.resources ?? const [],
              errorCode: e.code ?? '$e',
            );
          } else {
            final wait = e is RateLimited ? e.retryAfter : null;
            await Future<void>.delayed(wait ?? delay * failures);
            continue;
          }
        }
        _latest[id] = action;
        _changes.add(action);
        yield action;
        if (action.done) {
          onDone?.call(action);
          return;
        }
        await Future<void>.delayed(delay);
        final next = delay * 1.5;
        delay = next > maxInterval ? maxInterval : next;
      }
    } finally {
      _streams.remove(id);
      _latest.remove(id);
    }
  }
}
