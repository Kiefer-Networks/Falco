// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:async';

import 'package:flutter/services.dart';

/// Copies secrets to the clipboard, marked as sensitive and cleared after
/// [expiry].
///
/// Android (MainActivity) sets `EXTRA_IS_SENSITIVE` and clears the clip;
/// iOS (AppDelegate) writes a local only item with an expiration date.
/// Where the native channel is missing, a plain copy is cleared by a Dart
/// timer.
abstract final class SensitiveClipboard {
  /// Lifetime of a copied secret.
  static const Duration expiry = Duration(seconds: 60);

  static const _channel = MethodChannel('falco/clipboard');
  static Timer? _fallbackTimer;

  /// Copies [text] as sensitive data. Returns false when the system
  /// cannot mark it sensitive (Android before 13, or a plain copy, still
  /// cleared after [expiry]), so the caller can say so (SET-020).
  static Future<bool> copy(String text) async {
    _fallbackTimer?.cancel();
    try {
      // Android answers whether the flag works; iOS always protects.
      return await _channel.invokeMethod<bool>('setSensitive', {
            'text': text,
            'expirySeconds': expiry.inSeconds,
          }) ??
          true;
    } on MissingPluginException {
      await Clipboard.setData(ClipboardData(text: text));
      _fallbackTimer = Timer(expiry, () {
        unawaited(Clipboard.setData(const ClipboardData(text: '')));
      });
      return false;
    }
  }
}
