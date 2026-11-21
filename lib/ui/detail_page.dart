// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/mono.dart';
import 'package:falco/ui/sheets.dart';
import 'package:falco/ui/status_badge.dart';
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:falco/ui/theme/falco_text.dart';
import 'package:falco/ui/theme/tokens.dart';
import 'package:flutter/semantics.dart';
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

/// An action of a [DetailPage]: a button of its bottom action bar or an
/// entry of its "More" sheet.
@immutable
class DetailAction {
  /// Creates an action; a null [onTap] disables it.
  const new({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  /// Icon of the button or sheet entry.
  final IconData icon;

  /// Localized label, never cut off.
  final String label;

  /// Tap callback; null disables the action.
  final VoidCallback? onTap;

  /// Draws the entry in the error color (reset, delete selected).
  final bool destructive;
}

/// The one detail layout: header (status, name, mono ids), sections and
/// the danger zone at the very bottom of the content. Every action of the
/// resource goes into [actions]; the `FalcoScaffold` this page is the
/// body of shows them as its [DetailActionBar] at the bottom of the
/// screen, where snackbars rise above it. No more menu in the top bar.
class DetailPage extends StatelessWidget {
  /// Creates a detail page.
  const new({
    required this.name,
    this.status,
    this.statusDetail,
    this.ids = const [],
    this.actions = const [],
    this.sections = const [],
    this.dangerZone = const [],
    this.onRefresh,
    super.key,
  });

  /// Resource status; null for things without one (an account).
  final ResourceStatus? status;

  /// Detail after the status word (e.g. "up 41 days").
  final String? statusDetail;

  /// Resource name.
  final String name;

  /// Mono identifiers (IPs, IDs), joined by " · ".
  final List<String> ids;

  /// Every action, most important first; the first
  /// [DetailActionBar.slots] are buttons, the rest sit behind "More".
  final List<DetailAction> actions;

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
          // Screen readers say the name first, then status and ids.
          child: Semantics(
            container: true,
            explicitChildNodes: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (status case final status?) ...[
                  Semantics(
                    sortKey: const OrdinalSortKey(1),
                    child: StatusBadge(status: status, detail: statusDetail),
                  ),
                  const SizedBox(height: 6),
                ],
                Semantics(
                  header: true,
                  sortKey: const OrdinalSortKey(0),
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                if (ids.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Semantics(
                    sortKey: const OrdinalSortKey(2),
                    child: Mono(ids.join(' · '), maxLines: 2),
                  ),
                ],
              ],
            ),
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

/// The bottom action bar of a [DetailPage], in thumb reach: up to
/// [slots] actions as icon buttons with their full label, the rest in a
/// "More" sheet. Labels wrap instead of being cut off.
class DetailActionBar extends StatelessWidget {
  /// Creates the bar for [actions].
  const new({required this.actions, super.key});

  /// Buttons shown before "More".
  static const slots = 3;

  /// Every action, most important first.
  final List<DetailAction> actions;

  Future<void> _more(BuildContext context, List<DetailAction> rest) async {
    final l10n = AppLocalizations.of(context);
    final c = FalcoColors.of(context);
    final picked = await showFalcoSheet<DetailAction>(
      context,
      Builder(
        builder: (context) => SheetFrame(
          title: l10n.moreActions,
          children: [
            Column(
              children: [
                for (final a in rest)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    enabled: a.onTap != null,
                    leading: Icon(
                      a.icon,
                      color: a.destructive ? c.error : c.textSecondary,
                    ),
                    title: Text(
                      a.label,
                      style: TextStyle(color: a.destructive ? c.error : null),
                    ),
                    onTap: () => Navigator.pop(context, a),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
    picked?.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final l10n = AppLocalizations.of(context);
    final overflow = actions.length > slots;
    final shown = overflow ? actions.take(slots) : actions;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.hairline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FalcoSpacing.s,
            vertical: FalcoSpacing.xs,
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final a in shown)
                  Expanded(
                    child: _BarButton(
                      icon: a.icon,
                      label: a.label,
                      color: a.destructive ? c.error : null,
                      onTap: a.onTap,
                    ),
                  ),
                if (overflow)
                  Expanded(
                    child: Tooltip(
                      message: l10n.moreActions,
                      child: _BarButton(
                        icon: Icons.more_horiz,
                        label: l10n.commonMore,
                        onTap: () =>
                            _more(context, actions.skip(slots).toList()),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final fg = onTap == null ? c.textMuted : (color ?? c.text);
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(FalcoRadius.card),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 22, color: fg),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, height: 1.2, color: fg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Label and value rows, e.g. the overview section of a detail page or a
/// wizard summary.
class FactRows extends StatelessWidget {
  /// Creates the rows.
  const new(this.facts, {super.key});

  /// Rows in display order.
  final List<ConfirmFact> facts;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: FalcoSpacing.s,
      children: [
        for (final f in facts)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  f.label,
                  style: TextStyle(fontSize: 14, color: c.textSecondary),
                ),
              ),
              Expanded(
                child: f.mono
                    ? Mono(f.value, maxLines: 2)
                    : Text(
                        f.value,
                        style: TextStyle(fontSize: 14, color: c.text),
                      ),
              ),
            ],
          ),
      ],
    );
  }
}
