// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/l10n/app_localizations.dart';

/// The one user facing text for each [FalcoError].
String errorText(FalcoError error, AppLocalizations l10n) => switch (error) {
  Unauthorized() => l10n.errorUnauthorized,
  Forbidden() => l10n.errorForbidden,
  NotFound() => l10n.errorNotFound,
  Conflict() => l10n.errorConflict,
  RateLimited() => l10n.errorRateLimited,
  Invalid() => l10n.errorInvalid,
  Network() => l10n.errorNetwork,
  PinningFailed() => l10n.errorPinning,
  Server() => l10n.errorServer,
  Locked() => l10n.errorLocked,
};
