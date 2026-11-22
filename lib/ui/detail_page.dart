// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/format/format.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/falco_scaffold.dart';
import 'package:falco/ui/mono.dart';
import 'package:falco/ui/sheets.dart';
import 'package:falco/ui/status_badge.dart';
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:falco/ui/theme/falco_text.dart';
import 'package:falco/ui/theme/tokens.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Group of a [DetailAction]. Action sheets list the groups in this
/// order under their header; [danger] always comes last, in red.
enum ActionGroup {
  /// Power on and off, reboot, Wake on LAN.
  power,

  /// Console, rescue, boot systems, passwords and access settings.
  access,

  /// Edit, protection, type, placement and other configuration.
  manage,

  /// IPs, reverse DNS, networks, firewalls, routing.
  network,

  /// Backups, snapshots, images, imports and exports.
  backup,

  /// Destructive actions (hard reset, delete selected).
  danger;

  /// Localized header of the group.
  String label(AppLocalizations l10n) => switch (this) {
    power => l10n.actionGroupPower,
    access => l10n.actionGroupAccess,
    manage => l10n.actionGroupManage,
    network => l10n.actionGroupNetwork,
    backup => l10n.actionGroupBackup,
    danger => l10n.dangerZone,
  };
}

/// An action of a resource: a button of the [DetailActionBar], an entry
/// of its "More" sheet or of a screen's [MoreMenu].
@immutable
class DetailAction {
  /// Creates an action; a null [onTap] disables it.
  const new({
    required this.icon,
    required this.label,
    required this.group,
    required this.onTap,
  });

  /// Icon of the button or sheet entry.
  final IconData icon;

  /// Localized label, never cut off.
  final String label;

  /// Header the action sheet lists it under.
  final ActionGroup group;

  /// Tap callback; null disables the action.
  final VoidCallback? onTap;

  /// Drawn in the error color: the actions of [ActionGroup.danger].
  bool get destructive => group == ActionGroup.danger;
}

/// Shows [actions] as the one action sheet: grouped by [ActionGroup]
/// under section headers, destructive last and red. Runs the picked one
/// after the sheet closed.
Future<void> showActionSheet(
  BuildContext context, {
  required String title,
  required List<DetailAction> actions,
}) async {
  final picked = await showFalcoSheet<DetailAction>(
    context,
    Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final c = FalcoColors.of(context);
        final text = FalcoText.of(context);
        return SheetFrame(
          title: title,
          children: [
            for (final g in ActionGroup.values)
              if (actions.where((a) => a.group == g).toList() case final items
                  when items.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        g.label(l10n).toUpperCase(),
                        style: text.sectionLabel.copyWith(
                          color: g == ActionGroup.danger ? c.error : null,
                        ),
                      ),
                    ),
                    for (final a in items)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        enabled: a.onTap != null,
                        leading: Icon(
                          a.icon,
                          color: a.destructive ? c.error : c.textSecondary,
                        ),
                        title: Text(
                          a.label,
                          style: TextStyle(
                            color: a.destructive ? c.error : null,
                          ),
                        ),
                        onTap: () => Navigator.pop(context, a),
                      ),
                  ],
                ),
          ],
        );
      },
    ),
  );
  picked?.onTap?.call();
}

/// A key identifier in a [DetailHeader]: an IP, a location code, a type.
@immutable
class DetailId {
  /// Creates an identifier; [copy] makes it a mono value that copies
  /// itself on tap (IPs, IDs, fingerprints), or [copyText] when given.
  const new(this.value, {this.icon, this.copy = false, this.copyText});

  /// Displayed value.
  final String value;

  /// Leading icon (place for a location, memory for a type).
  final IconData? icon;

  /// Copies [value] on tap; also draws it in mono.
  final bool copy;

  /// Raw value copied instead of [value] (`123` for `#123`).
  final String? copyText;
}

/// One fact of a [FactGrid] or a [DetailSection]: a [label] and exactly
/// one value. [text] is plain text ([mono] for technical values, [copy]
/// for values users copy), [on] a switch shown as a [StatusChip], [time]
/// a date shown relative and absolute, [child] anything else.
@immutable
class Fact {
  /// Creates a fact.
  const new(
    this.label, {
    this.text,
    this.on,
    this.time,
    this.child,
    this.mono = false,
    this.copy = false,
  }) : assert(
         (text != null ? 1 : 0) +
                 (on != null ? 1 : 0) +
                 (time != null ? 1 : 0) +
                 (child != null ? 1 : 0) ==
             1,
         'A fact has exactly one value',
       );

  /// Localized label.
  final String label;

  /// Plain text value.
  final String? text;

  /// On or off value.
  final bool? on;

  /// Date value.
  final DateTime? time;

  /// Custom value widget.
  final Widget? child;

  /// Draws [text] in mono (IPs, IDs, ranges, hostnames).
  final bool mono;

  /// Copies [text] on tap; implies [mono].
  final bool copy;
}

/// The value of a [Fact].
class _FactValue extends StatelessWidget {
  const new(this.fact, {this.large = false, this.end = false});

  final Fact fact;

  /// Tile size (a [FactGrid]) instead of row size.
  final bool large;

  /// Aligned to the end (a row of a [DetailSection]).
  final bool end;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final l10n = AppLocalizations.of(context);
    final align = end ? TextAlign.end : TextAlign.start;
    final cross = end ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final size = large ? 16.0 : 14.0;
    final f = fact;
    if (f.child case final child?) return child;
    if (f.on case final on?) return StatusChip(on: on);
    if (f.time case final time?) {
      final absolute = formatDateTime(time, l10n.localeName);
      final now = DateTime.now();
      // Future dates (validity, paid until) read best as the date alone.
      final relative = time.isAfter(now)
          ? absolute
          : formatRelative(time, now, l10n);
      return Column(
        crossAxisAlignment: cross,
        children: [
          Text(
            relative,
            textAlign: align,
            style: TextStyle(fontSize: size, color: c.text),
          ),
          // Older than a month the relative form is the absolute date.
          if (relative != absolute)
            Text(
              absolute,
              textAlign: align,
              style: TextStyle(fontSize: 12, color: c.textSecondary),
            ),
        ],
      );
    }
    final value = f.text!;
    if (f.copy) return CopyableValue(value);
    if (f.mono) {
      return Text(
        value,
        textAlign: align,
        style: FalcoText.of(context).mono
            .copyWith(fontSize: size - 1, color: c.text),
      );
    }
    return Text(
      value,
      textAlign: align,
      style: TextStyle(
        fontSize: size,
        fontWeight: large ? FontWeight.w500 : null,
        color: c.text,
      ),
    );
  }
}

/// An on or off chip for switches (protection, backups, auto delete),
/// instead of "Yes" or "No" text.
class StatusChip extends StatelessWidget {
  /// Creates the chip.
  const new({required this.on, super.key});

  /// Whether the switch is on.
  final bool on;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final l10n = AppLocalizations.of(context);
    final color = on ? c.running : c.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(FalcoRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: Icon(
              on ? Icons.check_circle : Icons.remove_circle_outline,
              size: 14,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              on ? l10n.commonOn : l10n.commonOff,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Labels as mono chips, or "None".
class LabelChips extends StatelessWidget {
  /// Creates the chips for [labels].
  const new(this.labels, {super.key});

  /// Hetzner labels.
  final Map<String, String> labels;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    if (labels.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: FalcoSpacing.s),
        child: Text(
          AppLocalizations.of(context).commonNone,
          style: TextStyle(fontSize: 14, color: c.textSecondary),
        ),
      );
    }
    final chips = Wrap(
      spacing: FalcoSpacing.s,
      runSpacing: FalcoSpacing.s,
      children: [
        for (final key in labels.keys.toList()..sort())
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: c.background,
              border: Border.all(color: c.hairline),
              borderRadius: BorderRadius.circular(FalcoRadius.small),
            ),
            child: Mono(
              labels[key]!.isEmpty ? key : '$key=${labels[key]}',
              maxLines: 3,
              style: TextStyle(color: c.text),
            ),
          ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FalcoSpacing.s),
      child: chips,
    );
  }
}

/// The surface card of the detail blocks: a Material, so ink of list
/// tiles and copy buttons inside stays visible.
class _Card extends StatelessWidget {
  const new({required this.child, this.padding = EdgeInsets.zero});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: c.hairline),
        borderRadius: BorderRadius.circular(FalcoRadius.card),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(padding: padding, child: child),
    );
  }
}

/// The head of a [DetailPage]: a card with the status pill, the name and
/// the key identifiers as chips; copyable ones copy on tap.
class DetailHeader extends StatelessWidget {
  /// Creates the header.
  const new({
    required this.name,
    this.status,
    this.statusDetail,
    this.ids = const [],
    super.key,
  });

  /// Resource name.
  final String name;

  /// Resource status; null for things without one (an account).
  final ResourceStatus? status;

  /// Detail after the status word (e.g. "up 41 days").
  final String? statusDetail;

  /// Key identifiers in display order.
  final List<DetailId> ids;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: status.color(c).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(FalcoRadius.pill),
                  ),
                  child: StatusBadge(status: status, detail: statusDetail),
                ),
              ),
              const SizedBox(height: 10),
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
                child: Wrap(
                  spacing: FalcoSpacing.s,
                  children: [for (final id in ids) _IdChip(id)],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IdChip extends StatelessWidget {
  const new(this.id);

  final DetailId id;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final l10n = AppLocalizations.of(context);
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.background,
        border: Border.all(color: c.hairline),
        borderRadius: BorderRadius.circular(FalcoRadius.small),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (id.icon case final icon?) ...[
            Icon(icon, size: 15, color: c.textSecondary),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: id.copy
                ? Mono(
                    id.value,
                    // Fingerprints and IPv6 addresses show in full.
                    maxLines: 3,
                    style: TextStyle(color: c.text),
                  )
                : Text(
                    id.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: c.text),
                  ),
          ),
          if (id.copy) ...[
            const SizedBox(width: 6),
            Icon(Icons.content_copy, size: 14, color: c.textSecondary),
          ],
        ],
      ),
    );
    // A 48 dp tall hit area around the chip.
    final padded = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: kFalcoMinTouchTarget),
      child: Align(widthFactor: 1, child: chip),
    );
    if (!id.copy) {
      return Semantics(label: id.value, excludeSemantics: true, child: padded);
    }
    Future<void> copy() async {
      await Clipboard.setData(ClipboardData(text: id.copyText ?? id.value));
      if (context.mounted) FalcoScaffold.showSnack(context, l10n.copied);
    }

    return Semantics(
      button: true,
      label: l10n.copyValue(id.value),
      onTap: copy,
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(FalcoRadius.small),
        onTap: copy,
        child: padded,
      ),
    );
  }
}

/// The key facts of a [DetailPage] as tiles: two columns on phones, three
/// or four on wider panes. Tiles of a row share their height.
class FactGrid extends StatelessWidget {
  /// Creates the grid.
  const new(this.facts, {super.key});

  /// The most important three to six facts.
  final List<Fact> facts;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final cols = w >= 840
            ? 4
            : w >= 520
            ? 3
            : 2;
        return Column(
          spacing: FalcoSpacing.s,
          children: [
            for (var i = 0; i < facts.length; i += cols)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: FalcoSpacing.s,
                  children: [
                    for (var j = i; j < i + cols; j++)
                      Expanded(
                        child: j >= facts.length
                            ? const SizedBox()
                            : MergeSemantics(
                                child: _Card(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    10,
                                    12,
                                    12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        facts[j].label,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: c.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      _FactValue(facts[j], large: true),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

/// A titled section of a [DetailPage], grouped by meaning (network,
/// configuration, protection, labels). [facts] are label and value rows
/// in one card, [child] free content in the same card below them, and
/// [cards] widgets that are cards themselves (a [RelatedCard], a
/// metric chart), stacked below.
class DetailSection extends StatelessWidget {
  /// Creates a section.
  const new({
    required this.title,
    this.facts = const [],
    this.child,
    this.cards = const [],
    super.key,
  });

  /// Localized title, shown upper case.
  final String title;

  /// Label and value rows.
  final List<Fact> facts;

  /// Free content of the card (entries, activity).
  final Widget? child;

  /// Cards below the card (related resources, charts).
  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final text = FalcoText.of(context);
    final child = this.child;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: FalcoSpacing.s,
      children: [
        Semantics(
          header: true,
          child: Text(title.toUpperCase(), style: text.sectionLabel),
        ),
        if (facts.isNotEmpty || child != null)
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (i, f) in facts.indexed) ...[
                  if (i > 0) Divider(height: 1, color: c.divider),
                  MergeSemantics(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              f.label,
                              style: TextStyle(
                                fontSize: 14,
                                color: c.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: FalcoSpacing.m),
                          Expanded(
                            flex: 3,
                            child: Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: _FactValue(f, end: true),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (child != null) ...[
                  if (facts.isNotEmpty) Divider(height: 1, color: c.divider),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    child: child,
                  ),
                ],
              ],
            ),
          ),
        ...cards,
      ],
    );
  }
}

/// A related resource (the server of an IP, the volumes of a server) as
/// a tappable card: icon, name, status or a mono subtitle, chevron.
class RelatedCard extends StatelessWidget {
  /// Creates the card.
  const new({
    required this.icon,
    required this.title,
    this.subtitle,
    this.status,
    this.onTap,
    this.trailing,
    super.key,
  });

  /// Type icon.
  final IconData icon;

  /// Resource name.
  final String title;

  /// Mono line (size, IP, type); after the status word when [status] is
  /// set.
  final String? subtitle;

  /// Status of the resource, if it has one.
  final ResourceStatus? status;

  /// Opens the resource; null for one without a detail page.
  final VoidCallback? onTap;

  /// Buttons instead of the chevron (edit, remove).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final sub = subtitle;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: c.hairline),
        borderRadius: BorderRadius.circular(FalcoRadius.card),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                ExcludeSemantics(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: c.accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(FalcoRadius.small),
                    ),
                    child: Icon(icon, size: 20, color: c.accent),
                  ),
                ),
                const SizedBox(width: FalcoSpacing.m),
                Expanded(
                  child: MergeSemantics(
                    child: Semantics(
                      button: onTap != null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: c.text,
                            ),
                          ),
                          if (status case final status?) ...[
                            const SizedBox(height: 2),
                            StatusBadge(status: status, detail: sub),
                          ] else if (sub != null && sub.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Mono(sub, maxLines: 3),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                ?trailing,
                if (trailing == null && onTap != null)
                  Icon(Icons.chevron_right, color: c.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The one detail layout: [DetailHeader], the key [facts] as a
/// [FactGrid], titled [sections] and the danger zone at the very bottom
/// of the content. Every action of the resource goes into [actions]; the
/// `FalcoScaffold` this page is the body of shows them as its
/// [DetailActionBar] at the bottom of the screen, where snackbars rise
/// above it. No more menu in the top bar.
class DetailPage extends StatelessWidget {
  /// Creates a detail page.
  const new({
    required this.name,
    this.status,
    this.statusDetail,
    this.ids = const [],
    this.facts = const [],
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

  /// Key identifiers of the header (IPs, location, type).
  final List<DetailId> ids;

  /// The three to six most important facts.
  final List<Fact> facts;

  /// Every action, most important first; the first
  /// [DetailActionBar.slots] are buttons, the rest sit behind "More".
  final List<DetailAction> actions;

  /// Sections in order (network, configuration, protection, related,
  /// metrics, labels, activity).
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

    final list = ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        FalcoSpacing.l,
        FalcoSpacing.xs,
        FalcoSpacing.l,
        FalcoSpacing.xxl,
      ),
      children: [
        DetailHeader(
          name: name,
          status: status,
          statusDetail: statusDetail,
          ids: ids,
        ),
        if (facts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: FalcoSpacing.s),
            child: FactGrid(facts),
          ),
        for (final s in sections)
          Padding(
            padding: const EdgeInsets.only(top: FalcoSpacing.xl),
            child: s,
          ),
        if (dangerZone.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: FalcoSpacing.s,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.dangerZone.toUpperCase(),
                    style: text.sectionLabel.copyWith(color: c.error),
                  ),
                ),
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
/// [slots] actions as icon buttons with their full label, the rest in
/// the grouped "More" sheet ([showActionSheet]). Labels wrap instead of
/// being cut off.
class DetailActionBar extends StatelessWidget {
  /// Creates the bar for [actions].
  const new({required this.actions, super.key});

  /// Buttons shown before "More".
  static const slots = 3;

  /// Every action, most important first.
  final List<DetailAction> actions;

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
                        onTap: () => showActionSheet(
                          context,
                          title: l10n.moreActions,
                          actions: actions.skip(slots).toList(),
                        ),
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
      // The InkWell's tap is excluded with its semantics: TalkBack and
      // VoiceOver activate through this node.
      onTap: onTap,
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

/// Label and value rows of a wizard summary or an info sheet. Detail
/// pages use [FactGrid] and [DetailSection] instead.
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
