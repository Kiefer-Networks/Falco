// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:async';

import 'package:falco/ui/theme/tokens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings.g.dart';

/// Auto lock choices in seconds (SET-008).
const lockTimeouts = [0, 30, 60, 300, 900];

/// Auto lock default and maximum in seconds (SET-008).
const defaultLockTimeout = 60;
const _maxLockTimeout = 900;

/// A stored auto lock value made valid: missing or negative values fall
/// back to the default, values above 15 minutes are capped (SET-009).
int clampLockTimeout(int? seconds) => seconds == null || seconds < 0
    ? defaultLockTimeout
    : seconds > _maxLockTimeout
    ? _maxLockTimeout
    : seconds;

/// Non secret preferences. Secrets never go here.
@immutable
class Settings {
  /// Creates settings; the defaults are the first start.
  const new({
    this.variant = FalcoVariant.dark,
    this.accent = AccentPreset.amber,
    this.language,
    this.lock = true,
    this.lockTimeout = defaultLockTimeout,
    this.secureScreen = true,
    this.defaultAccount,
  });

  /// Surface variant; null follows the system (light or dark).
  final FalcoVariant? variant;

  /// Accent color.
  final AccentPreset accent;

  /// Language code (`de`, `en`); null follows the system.
  final String? language;

  /// Unlock at start and after [lockTimeout] in background (SET-007).
  final bool lock;

  /// Seconds in background before the app locks again.
  final int lockTimeout;

  /// Blocks screenshots and hides the app switcher preview (SET-014).
  final bool secureScreen;

  /// Account opened at start (ONB-027).
  final String? defaultAccount;

  /// Copy with changed fields; [variant], [language] and [defaultAccount]
  /// take a function so they can be set to null.
  Settings copyWith({
    FalcoVariant? Function()? variant,
    AccentPreset? accent,
    String? Function()? language,
    bool? lock,
    int? lockTimeout,
    bool? secureScreen,
    String? Function()? defaultAccount,
  }) => Settings(
    variant: variant == null ? this.variant : variant(),
    accent: accent ?? this.accent,
    language: language == null ? this.language : language(),
    lock: lock ?? this.lock,
    lockTimeout: lockTimeout ?? this.lockTimeout,
    secureScreen: secureScreen ?? this.secureScreen,
    defaultAccount: defaultAccount == null
        ? this.defaultAccount
        : defaultAccount(),
  );
}

/// Loaded once in `main` before the first frame and overridden there, so
/// theme and language never flash. Tests override it as well.
@Riverpod(keepAlive: true)
SharedPreferences preferences(Ref ref) =>
    throw UnimplementedError('preferencesProvider must be overridden');

/// The app settings, stored in [SharedPreferences].
@Riverpod(keepAlive: true)
class AppSettings extends _$AppSettings {
  static const _screen = MethodChannel('falco/screen');

  SharedPreferences get _prefs => ref.read(preferencesProvider);

  @override
  Settings build() {
    final p = _prefs;
    final variant = p.getString('variant');
    final settings = Settings(
      variant: variant == 'system'
          ? null
          : FalcoVariant.values.asNameMap()[variant] ?? FalcoVariant.dark,
      accent:
          AccentPreset.values.asNameMap()[p.getString('accent')] ??
          AccentPreset.amber,
      language: p.getString('language'),
      lock: p.getBool('lock') ?? true,
      lockTimeout: clampLockTimeout(p.getInt('lockTimeout')),
      secureScreen: p.getBool('secureScreen') ?? true,
      defaultAccount: p.getString('defaultAccount'),
    );
    _applySecureScreen(settings.secureScreen);
    return settings;
  }

  /// Stores [next] and makes it current.
  Future<void> update(Settings next) async {
    state = next;
    _applySecureScreen(next.secureScreen);
    final p = _prefs;
    await p.setString('variant', next.variant?.name ?? 'system');
    await p.setString('accent', next.accent.name);
    await _setOrRemove('language', next.language);
    await p.setBool('lock', next.lock);
    await p.setInt('lockTimeout', clampLockTimeout(next.lockTimeout));
    await p.setBool('secureScreen', next.secureScreen);
    await _setOrRemove('defaultAccount', next.defaultAccount);
  }

  Future<void> _setOrRemove(String key, String? value) =>
      value == null ? _prefs.remove(key) : _prefs.setString(key, value);

  // Android sets FLAG_SECURE natively; iOS has no channel and relies on
  // the app switcher cover of the LockGate.
  void _applySecureScreen(bool secure) {
    unawaited(
      _screen.invokeMethod<void>('setSecure', secure).catchError((Object _) {}),
    );
  }
}
