// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/feedback.dart';
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:falco/ui/theme/falco_text.dart';
import 'package:falco/ui/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

/// A filter chip of a [ResourceList].
@immutable
class ResourceFilter<T> {
  /// Creates a filter.
  const new(this.label, this.test);

  /// Localized chip label.
  final String label;

  /// Keeps an item when true.
  final bool Function(T item) test;
}

/// A sort option of a [ResourceList].
@immutable
class ResourceSort<T> {
  /// Creates a sort option.
  const new(this.label, this.compare);

  /// Localized label, shown as "Sort: label".
  final String label;

  /// Comparator.
  final int Function(T a, T b) compare;
}

/// The one list pattern: header with title and count, search, filter
/// chips, sort menu, pull to refresh, skeleton rows on first load,
/// [EmptyHint], [ErrorCard], and [ErrorBanner] over stale data.
///
/// State comes from the caller: [items] null means not loaded yet,
/// [error] a localized failure, [loading] a refresh in flight.
class ResourceList<T> extends StatefulWidget {
  /// Creates a list.
  const new({
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.onRefresh,
    required this.empty,
    this.loading = false,
    this.error,
    this.searchText,
    this.filters = const [],
    this.sorts = const [],
    super.key,
  });

  /// Section title, e.g. "Servers".
  final String title;

  /// Loaded items, null before the first successful load.
  final List<T>? items;

  /// Builds one row (usually a `ResourceRow`).
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Pull to refresh and retry.
  final Future<void> Function() onRefresh;

  /// Shown when [items] is empty.
  final EmptyHint empty;

  /// A refresh is running.
  final bool loading;

  /// Localized cause of the last failure.
  final String? error;

  /// Text searched by the search field; no search field when null.
  final String Function(T item)? searchText;

  /// Filter chips; the first is selected initially (usually "All").
  final List<ResourceFilter<T>> filters;

  /// Sort options; the first is the default.
  final List<ResourceSort<T>> sorts;

  @override
  State<ResourceList<T>> createState() => _ResourceListState<T>();
}

class _ResourceListState<T> extends State<ResourceList<T>> {
  String _query = '';
  int _filter = 0;
  int _sort = 0;

  List<T> _visible(List<T> items) {
    final q = _query.trim().toLowerCase();
    final search = widget.searchText;
    final filter = widget.filters.isEmpty ? null : widget.filters[_filter];
    final result = [
      for (final item in items)
        if ((filter == null || filter.test(item)) &&
            (q.isEmpty ||
                search == null ||
                search(item).toLowerCase().contains(q)))
          item,
    ];
    if (widget.sorts.isNotEmpty) result.sort(widget.sorts[_sort].compare);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = FalcoColors.of(context);
    final items = widget.items;
    final error = widget.error;
    final visible = items == null ? null : _visible(items);

    final Widget content;
    if (items == null && error != null) {
      content = _scrollable([
        Padding(
          padding: const EdgeInsets.all(FalcoSpacing.l),
          child: ErrorCard(message: error, onRetry: widget.onRefresh),
        ),
      ]);
    } else if (visible == null) {
      content = Semantics(
        label: l10n.commonLoading,
        child: _scrollable([for (var i = 0; i < 6; i++) const _SkeletonRow()]),
      );
    } else if (items!.isEmpty) {
      content = _scrollable([widget.empty]);
    } else if (visible.isEmpty) {
      content = _scrollable([EmptyHint(message: l10n.listNoMatches)]);
    } else {
      content = RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: FalcoSpacing.s),
          itemCount: visible.length,
          itemBuilder: (context, i) => widget.itemBuilder(context, visible[i]),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.searchText != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.commonSearch,
                prefixIcon: const Icon(Icons.search, size: 20),
              ),
            ),
          ),
        if (widget.filters.length > 1)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                for (final (i, f) in widget.filters.indexed)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: _FilterPill(
                      label: f.label,
                      selected: i == _filter,
                      onTap: () => setState(() => _filter = i),
                    ),
                  ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${widget.title} · ${visible?.length ?? '–'}'.toUpperCase(),
                  style: FalcoText.of(context).sectionLabel,
                ),
              ),
              if (widget.sorts.length > 1)
                PopupMenuButton<int>(
                  tooltip: l10n.listSort,
                  initialValue: _sort,
                  onSelected: (i) => setState(() => _sort = i),
                  itemBuilder: (context) => [
                    for (final (i, s) in widget.sorts.indexed)
                      PopupMenuItem(value: i, child: Text(s.label)),
                  ],
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: kFalcoMinTouchTarget,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        widthFactor: 1,
                        child: Text(
                          l10n.listSortBy(widget.sorts[_sort].label),
                          style: TextStyle(
                            fontSize: 13,
                            color: c.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 2,
          child: widget.loading && items != null
              ? const LinearProgressIndicator()
              : null,
        ),
        if (items != null && error != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: ErrorBanner(
              message: l10n.listStaleBanner,
              onRetry: widget.onRefresh,
            ),
          ),
        Expanded(child: content),
      ],
    );
  }

  Widget _scrollable(List<Widget> children) => RefreshIndicator(
    onRefresh: widget.onRefresh,
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: children,
    ),
  );
}

class _FilterPill extends StatelessWidget {
  const new({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final radius = BorderRadius.circular(FalcoRadius.pill);
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: SizedBox(
          height: kFalcoMinTouchTarget,
          child: Center(
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: radius,
                border: Border.all(color: selected ? c.accent : c.hairline),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: selected ? c.accent : c.textBody,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    Widget bar(double width, double height) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: c.surfaceSelected,
        borderRadius: BorderRadius.circular(4),
      ),
    );
    return ExcludeSemantics(
      child: Container(
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.divider)),
        ),
        child: Row(
          children: [
            bar(8, 8),
            const SizedBox(width: 14),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [bar(120, 12), const SizedBox(height: 8), bar(180, 10)],
            ),
          ],
        ),
      ),
    );
  }
}
