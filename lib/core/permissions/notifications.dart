// SPDX-License-Identifier: GPL-3.0-or-later
/// The notification permission background transfers use for their
/// progress (OBJ-007, SET-024, SET-025). Asked once in the welcome pages
/// and again before each transfer; the system shows its dialog only while
/// the user has not decided. Transfers run without it. Tests override
/// [notificationPermissionProvider].
library;

import 'package:background_downloader/background_downloader.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications.g.dart';

/// Asks the system for the notification permission.
class NotificationPermission {
  const new();

  /// Requests the permission (Android 13+, iOS); true when granted.
  /// Older Android grants it with the install; asking there fails, so the
  /// status comes first.
  Future<bool> request() async {
    final permissions = FileDownloader().permissions;
    if (await permissions.status(PermissionType.notifications) ==
        PermissionStatus.granted) {
      return true;
    }
    return switch (await permissions.request(PermissionType.notifications)) {
      PermissionStatus.granted || PermissionStatus.partial => true,
      _ => false,
    };
  }
}

/// Asks before a transfer starts (SET-025): empty when notifications are
/// on, otherwise a second line for the start message saying the transfer
/// runs anyway. A failing or hanging request counts as not granted, so
/// the transfer always starts.
Future<String> notificationHint(WidgetRef ref, AppLocalizations l10n) async {
  try {
    if (await ref
        .read(notificationPermissionProvider)
        .request()
        .timeout(const Duration(seconds: 30))) {
      return '';
    }
  } on Object {
    // Not granted.
  }
  return '\n${l10n.transferNoNotifications}';
}

@Riverpod(keepAlive: true)
NotificationPermission notificationPermission(Ref ref) =>
    const NotificationPermission();
