// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/secure/secret_store.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_lock.g.dart';

/// Asks the platform for Face ID, Touch ID, fingerprint or the device PIN
/// (local_auth falls back to the PIN, SET-013, BUG-023). Returns false if
/// the user cancelled and null when the device has no screen lock at all.
/// With a hardware bound vault, opening it is the check, so the user sees
/// one prompt (SET-015). Overridden in tests.
@Riverpod(keepAlive: true)
Future<bool?> Function(String reason) authenticator(Ref ref) {
  final auth = LocalAuthentication();
  final secrets = ref.watch(secretStoreProvider);
  return (reason) async {
    if (!await auth.isDeviceSupported()) return null;
    try {
      if (await secrets.bound) return await secrets.open();
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

/// State of the app lock. Held in memory only, never persisted (SET-011).
enum AppLockState {
  /// Content visible.
  unlocked,

  /// Content covered until authentication succeeds.
  locked,

  /// Locked, but the device has no screen lock to check against (SET-012).
  unavailable,
}

/// App lock: locked at start and after the auto lock time in background,
/// both only while the lock is on in the settings (SET-007, SET-010).
@Riverpod(keepAlive: true)
class AppLock extends _$AppLock {
  DateTime? _pausedAt;

  /// Clock, replaceable in tests.
  DateTime Function() now = DateTime.now;

  @override
  AppLockState build() => ref.read(appSettingsProvider).lock
      ? AppLockState.locked
      : AppLockState.unlocked;

  Future<void>? _pending;

  /// Asks for authentication; unlocks on success. Concurrent calls share
  /// one prompt.
  Future<void> unlock(String reason) {
    if (state == AppLockState.unlocked) return Future.value();
    return _pending ??= () async {
      try {
        state = switch (await ref.read(authenticatorProvider)(reason)) {
          true => AppLockState.unlocked,
          false => AppLockState.locked,
          null => AppLockState.unavailable,
        };
      } finally {
        _pending = null;
      }
    }();
  }

  /// Turns the lock off from the "no screen lock" screen: without a device
  /// lock there is nothing to authenticate against.
  Future<void> disable() async {
    final settings = ref.read(appSettingsProvider.notifier);
    await settings.update(ref.read(appSettingsProvider).copyWith(lock: false));
    state = AppLockState.unlocked;
  }

  /// Call when the app goes to background.
  void paused() => _pausedAt ??= now();

  /// Call when the app returns; locks after the auto lock time.
  void resumed() {
    final pausedAt = _pausedAt;
    _pausedAt = null;
    final settings = ref.read(appSettingsProvider);
    if (!settings.lock || pausedAt == null) return;
    if (now().difference(pausedAt).inSeconds >= settings.lockTimeout) {
      state = AppLockState.locked;
      // Secrets need the next unlock again (SET-015).
      ref.read(secretStoreProvider).close();
    }
  }
}
