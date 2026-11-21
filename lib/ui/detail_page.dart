// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/action_tile.dart';
import 'package:falco/ui/mono.dart';
import 'package:falco/ui/status_badge.dart';
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:falco/ui/theme/falco_text.dart';
import 'package:falco/ui/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

/// A titled section of a [DetailPage].
@immutable
class DetailSection {
  /// Creates a section.
  const new({required this.title, required this.child});

  /// Localized title, shown upper case.
  final String title;

  /// Section content.
  final Widget child;
}

/// The one detail layout: header (status, name, mono ids), up to four
/// [ActionTile]s, sections, and the danger zone at the very bottom.
/// Wrap it in a `FalcoScaffold` that carries the more menu.
class DetailPage extends StatelessWidget {
  /// Creates a detail page.
  const new({
    required this.status,
    required this.name,
    this.statusDetail,
    this.ids = const [],
    this.actions = const [],
    this.sections = const [],
    this.dangerZone = const [],
    this.onRefresh,
    super.key,
  }) : assert(actions.length <= 4, 'A detail page has at most 4 actions');

  /// Resource status.
  final ResourceStatus status;

  /// Detail after the status word (e.g. "up 41 days").
  final String? statusDetail;

  /// Resource name.
  final String name;

  /// Mono identifiers (IPs, IDs), joined by " · ".
  final List<String> ids;

  /// Primary actions, at most four.
  final List<ActionTile> actions;

  /// Sections in order (overview, metrics, network, settings, activity).
  final List<DetailSection> sections;

  /// Destructive actions (usually buttons opening a level 2 confirm).
  final List<Widget> dangerZone;

  /// Pull to refresh.
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final text = FalcoText.of(context);
    final l10n = AppLocalizations.of(context);
    Widget label(String t, [Color? color]) => Padding(
      padding: const EdgeInsets.only(bottom: FalcoSpacing.s),
      child: Semantics(
        header: true,
        child: Text(
          t.toUpperCase(),
          style: text.sectionLabel.copyWith(color: color),
        ),
      ),
    );

    final list = ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: FalcoSpacing.xxl),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusBadge(status: status, detail: statusDetail),
              const SizedBox(height: 6),
              Semantics(
                header: true,
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              if (ids.isNotEmpty) ...[
                const SizedBox(height: 6),
                Mono(ids.join(' · '), maxLines: 2),
              ],
            ],
          ),
        ),
        if (actions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: FalcoSpacing.l),
            child: Row(
              children: [
                for (final (i, a) in actions.indexed) ...[
                  if (i > 0) const SizedBox(width: FalcoSpacing.s),
                  Expanded(child: a),
                ],
                for (var i = actions.length; i < 4; i++) ...[
                  const SizedBox(width: FalcoSpacing.s),
                  const Spacer(),
                ],
              ],
            ),
          ),
        for (final s in sections)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [label(s.title), s.child],
            ),
          ),
        if (dangerZone.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                label(l10n.dangerZone, c.error),
                Container(
                  padding: const EdgeInsets.all(FalcoSpacing.m),
                  decoration: BoxDecoration(
                    border: Border.all(color: c.error.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(FalcoRadius.card),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: FalcoSpacing.s,
                    children: dangerZone,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
    final refresh = onRefresh;
    return refresh == null
        ? list
        : RefreshIndicator(onRefresh: refresh, child: list);
  }
}
