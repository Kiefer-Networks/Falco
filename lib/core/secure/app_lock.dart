// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_lock.g.dart';

/// Asks the platform for Face ID, Touch ID, fingerprint or the device PIN.
/// Returns false if the user cancelled. Overridden in tests.
@Riverpod(keepAlive: true)
Future<bool> Function(String reason) authenticator(Ref ref) {
  final auth = LocalAuthentication();
  return (reason) async {
    // Without a device lock there is nothing to check against; the app
    // cannot be locked (local_auth standard behaviour, BUG-023).
    if (!await auth.isDeviceSupported()) return true;
    try {
      return await auth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException {
      return false;
    } on PlatformException {
      return false;
    }
  };
}

/// App lock: locked at start and after [backgroundTimeout] in background.
@Riverpod(keepAlive: true)
class AppLock extends _$AppLock {
  /// Time in background after which the app locks again.
  static const backgroundTimeout = Duration(minutes: 1);

  DateTime? _pausedAt;

  /// Clock, replaceable in tests.
  DateTime Function() now = DateTime.now;

  @override
  bool build() => true;

  Future<void>? _pending;

  /// Asks for authentication; unlocks on success. Concurrent calls share
  /// one prompt.
  Future<void> unlock(String reason) {
    if (!state) return Future.value();
    return _pending ??= () async {
      try {
        if (await ref.read(authenticatorProvider)(reason)) state = false;
      } finally {
        _pending = null;
      }
    }();
  }

  /// Call when the app goes to background.
  void paused() => _pausedAt ??= now();

  /// Call when the app returns; locks after [backgroundTimeout].
  void resumed() {
    final pausedAt = _pausedAt;
    _pausedAt = null;
    if (pausedAt != null && now().difference(pausedAt) >= backgroundTimeout) {
      state = true;
    }
  }
}
