// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/l10n/app_localizations.dart';

/// The one user facing text for each [FalcoError].
String errorText(FalcoError error, AppLocalizations l10n) => switch (error) {
  Unauthorized(code: 'ROBOT_LOGIN') => l10n.robotLoginRejected,
  Unauthorized(code: 'ROBOT_NO_LOGIN') => l10n.robotLoginMissing,
  Unauthorized() => l10n.errorUnauthorized,
  Forbidden() => l10n.errorForbidden,
  NotFound() => l10n.errorNotFound,
  Conflict() => l10n.errorConflict,
  RateLimited() => l10n.errorRateLimited,
  // Deletes the API refuses while a resource is still attached.
  Invalid(code: 'must_be_unassigned') => l10n.errorMustBeUnassigned,
  Invalid(code: 'resource_in_use') => l10n.errorResourceInUse,
  Invalid() => l10n.errorInvalid,
  Network() => l10n.errorNetwork,
  PinningFailed() => l10n.errorPinning,
  Server() => l10n.errorServer,
  Locked() => l10n.errorLocked,
  ActionFailed(:final code) =>
    code == null ? l10n.actionFailed : '${l10n.actionFailed} ($code)',
};
