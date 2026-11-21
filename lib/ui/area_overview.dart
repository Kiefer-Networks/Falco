// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/feedback.dart';
import 'package:falco/ui/status_badge.dart';
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:falco/ui/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

/// One resource type of an [AreaOverview]: icon, name, count and a
/// status summary. A tap opens its list.
@immutable
class OverviewTile {
  /// Creates a tile.
  const new({
    required this.icon,
    required this.label,
    required this.onTap,
    this.count,
    this.statuses,
    this.note,
    this.preview = const [],
  });

  /// Icon of the resource type.
  final IconData icon;

  /// Localized plural name, e.g. "Servers".
  final String label;

  /// Opens the list.
  final VoidCallback onTap;

  /// Number of resources; null while loading or when [note] says why not.
  final int? count;

  /// Status of each resource, for the summary and the status bar; null
  /// for types without a status.
  final List<ResourceStatus>? statuses;

  /// Replaces the summary, e.g. "Not available" after a failed load.
  final String? note;

  /// Rows shown inside the tile (usually `ResourceRow`s of the first
  /// servers); a tile with rows spans the full width.
  final List<Widget> preview;
}

/// The one overview of an area (Compute, Network, Storage, Robot): every
/// resource type as a tile with its count and status summary. Tiles with
/// [OverviewTile.preview] rows come first at full width, the others in a
/// grid. No tabs: a tap on a tile opens the type's list.
class AreaOverview extends StatelessWidget {
  /// Creates the overview.
  const new({
    required this.tiles,
    required this.onRefresh,
    this.error,
    super.key,
  });

  /// Resource types in display order.
  final List<OverviewTile> tiles;

  /// Localized cause when no type could load; shown above the tiles with
  /// "Try again".
  final String? error;

  /// Pull to refresh.
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final wide = [
      for (final t in tiles)
        if (t.preview.isNotEmpty) t,
    ];
    final grid = [
      for (final t in tiles)
        if (t.preview.isEmpty) t,
    ];
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = (constraints.maxWidth / 180).floor().clamp(2, 4);
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              FalcoSpacing.l,
              FalcoSpacing.m,
              FalcoSpacing.l,
              FalcoSpacing.xxl,
            ),
            children: [
              if (error case final error?) ...[
                ErrorCard(message: error, onRetry: onRefresh),
                const SizedBox(height: FalcoSpacing.m),
              ],
              for (final t in wide) ...[
                _Tile(tile: t),
                const SizedBox(height: FalcoSpacing.m),
              ],
              for (var i = 0; i < grid.length; i += columns) ...[
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var j = i; j < i + columns; j++) ...[
                        if (j > i) const SizedBox(width: FalcoSpacing.m),
                        Expanded(
                          child: j < grid.length
                              ? _Tile(tile: grid[j])
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: FalcoSpacing.m),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const new({required this.tile});

  final OverviewTile tile;

  /// "running: 3 · off: 1", most frequent first.
  static String? summary(List<ResourceStatus>? statuses, AppLocalizations l) {
    if (statuses == null || statuses.isEmpty) return null;
    final counts = <String, int>{};
    for (final s in statuses) {
      counts.update(s.label(l), (n) => n + 1, ifAbsent: () => 1);
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return [for (final e in sorted) l.overviewStatusCount(e.key, e.value)]
        .join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final l10n = AppLocalizations.of(context);
    final t = tile;
    final line = t.note ?? summary(t.statuses, l10n);
    final radius = BorderRadius.circular(FalcoRadius.card);
    final header = Semantics(
      button: true,
      label: [t.label, ?t.count?.toString(), ?line].join(', '),
      excludeSemantics: true,
      child: InkWell(
        borderRadius: radius,
        onTap: t.onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(t.icon, size: 22, color: c.accent),
                  const Spacer(),
                  if (t.count case final n?)
                    Text(
                      '$n',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: c.text),
                    )
                  else if (t.note == null)
                    const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  if (t.preview.isNotEmpty) ...[
                    const SizedBox(width: FalcoSpacing.xs),
                    Icon(Icons.chevron_right, color: c.textSecondary),
                  ],
                ],
              ),
              const SizedBox(height: FalcoSpacing.s),
              Text(
                t.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: c.text,
                ),
              ),
              if (line != null) ...[
                const SizedBox(height: 2),
                Text(
                  line,
                  style: TextStyle(fontSize: 13, color: c.textSecondary),
                ),
              ],
              if (t.statuses case final s? when s.isNotEmpty) ...[
                const SizedBox(height: FalcoSpacing.s),
                _StatusBar(statuses: s),
              ],
            ],
          ),
        ),
      ),
    );
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: c.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: t.preview.isEmpty
          ? header
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                header,
                Divider(height: 1, color: c.divider),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FalcoSpacing.s,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: t.preview,
                  ),
                ),
              ],
            ),
    );
  }
}

/// Share of each status tone as one thin bar.
class _StatusBar extends StatelessWidget {
  const new({required this.statuses});

  final List<ResourceStatus> statuses;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final tones = <StatusTone, (int, Color)>{};
    for (final s in statuses) {
      final (n, color) = tones[s.tone] ?? (0, s.color(c));
      tones[s.tone] = (n + 1, color);
    }
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: SizedBox(
          height: 4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (n, color) in tones.values)
                Expanded(
                  flex: n,
                  child: ColoredBox(color: color),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
