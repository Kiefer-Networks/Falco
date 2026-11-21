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

  /// Copies [text] as sensitive data.
  static Future<void> copy(String text) async {
    _fallbackTimer?.cancel();
    try {
      await _channel.invokeMethod<void>('setSensitive', {
        'text': text,
        'expirySeconds': expiry.inSeconds,
      });
    } on MissingPluginException {
      await Clipboard.setData(ClipboardData(text: text));
      _fallbackTimer = Timer(expiry, () {
        unawaited(Clipboard.setData(const ClipboardData(text: '')));
      });
    }
  }
}
