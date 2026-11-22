// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/l10n/app_localizations.dart';

/// The one user facing text for each [FalcoError].
String errorText(FalcoError error, AppLocalizations l10n) => switch (error) {
  Unauthorized(code: 'ROBOT_LOGIN') => l10n.robotLoginRejected,
  Unauthorized(code: 'ROBOT_NO_LOGIN') => l10n.robotLoginMissing,
  // S3 refuses a signature from a device clock that is off.
  Unauthorized(code: 'RequestTimeTooSkewed') ||
  Forbidden(code: 'RequestTimeTooSkewed') => l10n.errorClockSkew,
  Unauthorized() => l10n.errorUnauthorized,
  Forbidden(code: 'resource_limit_exceeded') => l10n.errorLimitReached,
  Forbidden() => l10n.errorForbidden,
  NotFound() => l10n.errorNotFound,
  Conflict(code: 'uniqueness_error') => l10n.errorNotUnique,
  // A firewall rule edited here was changed or removed elsewhere.
  Conflict(code: 'rule_gone') => l10n.errorRuleGone,
  Conflict() => l10n.errorConflict,
  RateLimited() => l10n.errorRateLimited,
  // Deletes the API refuses while a resource is still attached.
  Invalid(code: 'must_be_unassigned') => l10n.errorMustBeUnassigned,
  Invalid(code: 'resource_in_use') => l10n.errorResourceInUse,
  Invalid(code: 'server_not_stopped') => l10n.errorServerNotStopped,
  Invalid() => l10n.errorInvalid,
  Network() => l10n.errorNetwork,
  PinningFailed() => l10n.errorPinning,
  Server() => l10n.errorServer,
  Locked() => l10n.errorLocked,
  ActionFailed(:final code) =>
    code == null ? l10n.actionFailed : '${l10n.actionFailed} ($code)',
};
