// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:material_ui/material_ui.dart';

/// Color family of a status.
enum StatusTone {
  /// Healthy and active (filled dot).
  running,

  /// Stopped (hollow ring).
  off,

  /// An action is in progress (filled dot in accent).
  progress,

  /// Failed (hollow ring).
  error,
}

/// Every status a resource can show. Maps to a [StatusTone] and a word.
enum ResourceStatus {
  /// Running.
  running(StatusTone.running),

  /// Off.
  off(StatusTone.off),

  /// Starting.
  starting(StatusTone.progress),

  /// Stopping.
  stopping(StatusTone.progress),

  /// Rebooting.
  rebooting(StatusTone.progress),

  /// Initializing.
  initializing(StatusTone.progress),

  /// Rebuilding.
  rebuilding(StatusTone.progress),

  /// Migrating.
  migrating(StatusTone.progress),

  /// Deleting.
  deleting(StatusTone.progress),

  /// Error.
  error(StatusTone.error),

  /// Ready to use (volumes, images).
  available(StatusTone.running),

  /// Not usable (images).
  unavailable(StatusTone.off),

  /// In service (Storage Boxes).
  active(StatusTone.running),

  /// Locked by Hetzner (Storage Boxes).
  locked(StatusTone.off),

  /// Unknown status from the API.
  unknown(StatusTone.off),

  /// A Hetzner action in progress.
  inProgress(StatusTone.progress),

  /// A Hetzner action that succeeded.
  done(StatusTone.running),

  /// A Hetzner action that failed.
  failed(StatusTone.error),

  /// Cancelled, ends at a date (Robot servers, vSwitches).
  cancelled(StatusTone.error);

  new(this.tone);

  /// Color family.
  final StatusTone tone;

  /// Localized word for this status.
  String label(AppLocalizations l10n) => switch (this) {
    running => l10n.statusRunning,
    off => l10n.statusOff,
    starting => l10n.statusStarting,
    stopping => l10n.statusStopping,
    rebooting => l10n.statusRebooting,
    initializing => l10n.statusInitializing,
    rebuilding => l10n.statusRebuilding,
    migrating => l10n.statusMigrating,
    deleting => l10n.statusDeleting,
    error => l10n.statusError,
    available => l10n.statusAvailable,
    unavailable => l10n.statusUnavailable,
    active => l10n.statusActive,
    locked => l10n.statusLocked,
    unknown => l10n.statusUnknown,
    inProgress => l10n.statusInProgress,
    done => l10n.statusDone,
    failed => l10n.statusFailed,
    cancelled => l10n.statusCancelled,
  };

  /// Token color for this status.
  Color color(FalcoColors c) => switch (tone) {
    StatusTone.running => c.running,
    StatusTone.off => c.off,
    StatusTone.progress => c.progress,
    StatusTone.error => c.error,
  };

  /// Off and error draw a hollow ring, the others a filled dot.
  bool get hollow => tone == StatusTone.off || tone == StatusTone.error;
}

/// The one status component: a dot (or hollow ring for off and error)
/// plus the status word, optionally followed by [detail]
/// (e.g. "running · up 41 days").
class StatusBadge extends StatelessWidget {
  /// Creates a badge for [status].
  const new({required this.status, this.detail, super.key});

  /// Status to show.
  final ResourceStatus status;

  /// Optional detail after the word.
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final color = status.color(FalcoColors.of(context));
    final word = status.label(AppLocalizations.of(context));
    final text = detail == null ? word : '$word · $detail';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatusDot(status: status),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, color: color),
          ),
        ),
      ],
    );
  }
}

/// The 8 px dot of a [StatusBadge], for layouts that place the word
/// elsewhere (list rows). Excluded from semantics; pair it with the word.
class StatusDot extends StatelessWidget {
  /// Creates the dot for [status].
  const new({required this.status, super.key});

  /// Status to show.
  final ResourceStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color(FalcoColors.of(context));
    return ExcludeSemantics(
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: status.hollow ? null : color,
          border: status.hollow ? Border.all(color: color, width: 1.5) : null,
        ),
      ),
    );
  }
}
