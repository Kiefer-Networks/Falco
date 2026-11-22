// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/scope/scope_repository.dart';
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
/// one prompt (SET-015); it is read again, so an open vault never answers
/// for the user. A vault the system invalidated (new fingerprints) is reset
/// by that read; the device check then decides (SET-013). Overridden in
/// tests.
@Riverpod(keepAlive: true)
Future<bool?> Function(String reason) authenticator(Ref ref) {
  final auth = LocalAuthentication();
  final secrets = ref.watch(secretStoreProvider);
  return (reason) async {
    if (!await auth.isDeviceSupported()) return null;
    try {
      if (await secrets.bound) {
        await secrets.verify();
        if (await secrets.bound) return true;
      }
      return await auth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException {
      return false;
    } on Locked {
      return false;
    } on PlatformException {
      return false;
    }
  };
}

/// Closes the vault once at launch while the lock is on, before anything
/// reads it, so background work at launch fails as [Locked] instead of
/// raising the system prompt over the cover.
void closeVaultAtStart(ProviderContainer container) {
  if (container.read(appLockProvider) != AppLockState.unlocked) {
    container.read(secretStoreProvider).close();
  }
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
/// Before the first account there is nothing to protect: [unlock] then
/// opens without asking, so a first start never prompts (SET-023). The
/// first secret goes into the vault with the platform's own check.
@Riverpod(keepAlive: true)
class AppLock extends _$AppLock {
  (DateTime, Duration)? _pausedAt;
  int _prompts = 0;

  /// The app returned while a check ran; a failed check applies it.
  bool _resumedInCheck = false;

  /// Wall clock, replaceable in tests.
  DateTime Function() now = DateTime.now;

  /// Monotonic clock that ignores changes of the device time, replaceable
  /// in tests.
  Duration Function() uptime = () => _uptime.elapsed;

  static final _uptime = Stopwatch()..start();

  /// Locked at start while the lock is on. No side effect here: a first
  /// read of the lock after the vault opened must not close it again;
  /// [closeVaultAtStart] closes it once at launch.
  @override
  AppLockState build() => ref.read(appSettingsProvider).lock
      ? AppLockState.locked
      : AppLockState.unlocked;

  Future<void>? _pending;

  /// Asks for authentication; unlocks on success. Concurrent calls share
  /// one prompt. Without any account it unlocks without a prompt.
  Future<void> unlock(String reason) {
    if (state == AppLockState.unlocked) return Future.value();
    return _pending ??= () async {
      try {
        if (await _noAccounts()) {
          _open();
          return;
        }
        switch (await check(reason)) {
          case true:
            _open();
          case false:
            state = AppLockState.locked;
          case null:
            state = AppLockState.unavailable;
        }
      } finally {
        _pending = null;
      }
    }();
  }

  /// An unreadable account list counts as accounts: ask rather than open.
  Future<bool> _noAccounts() async {
    try {
      return (await ref.read(scopeRepositoryProvider).accounts()).isEmpty;
    } on Object {
      return false;
    }
  }

  /// Asks the user through the system prompt, also while unlocked (turning
  /// the lock off). The app leaving the foreground for the prompt does not
  /// count as background time once the check succeeds; a failed or
  /// cancelled check keeps it, so leaving during the prompt still locks.
  Future<bool?> check(String reason) async {
    _prompts++;
    bool? ok;
    try {
      return ok = await ref.read(authenticatorProvider)(reason);
    } finally {
      _prompts--;
      if (_prompts == 0) {
        final resumedInCheck = _resumedInCheck;
        _resumedInCheck = false;
        if (ok ?? false) {
          _pausedAt = null;
        } else if (resumedInCheck) {
          resumed();
        }
      }
    }
  }

  /// Turns the lock off from the "no screen lock" screen: without a device
  /// lock there is nothing to authenticate against.
  Future<void> disable() async {
    final settings = ref.read(appSettingsProvider.notifier);
    await settings.update(ref.read(appSettingsProvider).copyWith(lock: false));
    _open();
  }

  /// Unlocks; a check that did not read the vault (no account, local_auth,
  /// lock off) still ends its closed state, else every secret stays
  /// [Locked] until a restart.
  void _open() {
    ref.read(secretStoreProvider).release();
    state = AppLockState.unlocked;
  }

  /// Call when the app goes to background.
  void paused() {
    _pausedAt ??= (now(), uptime());
  }

  /// Call when the app returns; locks after the auto lock time and then
  /// returns true. Both clocks count: the monotonic one ignores a device
  /// time set back, the wall clock also runs while the device sleeps. A
  /// wall clock that went back gives no usable time and locks. While a
  /// check runs, its result decides (see [check]).
  bool resumed() {
    if (_prompts > 0) {
      _resumedInCheck = _pausedAt != null;
      return false;
    }
    final pausedAt = _pausedAt;
    _pausedAt = null;
    final settings = ref.read(appSettingsProvider);
    if (!settings.lock || pausedAt == null) return false;
    final timeout = Duration(seconds: settings.lockTimeout);
    final wall = now().difference(pausedAt.$1);
    if (wall.isNegative ||
        wall >= timeout ||
        uptime() - pausedAt.$2 >= timeout) {
      state = AppLockState.locked;
      // Secrets need the next unlock again (SET-015).
      ref.read(secretStoreProvider).close();
      return true;
    }
    return false;
  }
}
