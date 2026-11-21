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

  /// True once the action ended.
  bool get done => status != ActionStatus.running;
}

/// Follows Hetzner actions until they end (QRS-028).
///
/// `fetch` loads one action (`GET /actions/{id}` or the Storage Box
/// equivalent). Each finished action is reported once to [onDone], which
/// invalidates the affected resources. The activity view reads [running].
class ActionTracker {
  /// Creates a tracker.
  new(
    this._fetch, {
    this.onDone,
    this.interval = const Duration(seconds: 1),
    this.maxInterval = const Duration(seconds: 5),
  });

  final Future<ActionProgress> Function(int id) _fetch;

  /// Called once per finished action.
  final void Function(ActionProgress action)? onDone;

  /// First poll delay; grows by half per poll up to [maxInterval].
  final Duration interval;

  /// Upper bound of the poll delay.
  final Duration maxInterval;

  final _streams = <int, Stream<ActionProgress>>{};
  final _latest = <int, ActionProgress>{};

  /// Actions that are being followed and have not ended.
  Iterable<ActionProgress> get running => _latest.values.where((a) => !a.done);

  /// Progress of action [id] until it ends. Tracking an id twice shares
  /// one poll loop.
  Stream<ActionProgress> track(int id) =>
      _streams[id] ??= _poll(id).asBroadcastStream();

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
          // A short network hiccup must not end the tracking; anything
          // else (gone, forbidden) does.
          if (e is! Network || ++failures >= 3) {
            action = ActionProgress(
              id: id,
              command: _latest[id]?.command ?? '',
              status: ActionStatus.error,
              progress: _latest[id]?.progress ?? 0,
              resources: _latest[id]?.resources ?? const [],
              errorCode: e.code ?? '$e',
            );
          } else {
            await Future<void>.delayed(delay);
            continue;
          }
        }
        _latest[id] = action;
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
