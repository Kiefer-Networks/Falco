// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/feedback.dart';
import 'package:falco/ui/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

/// The one adaptive frame of every list with details (QRS-027): from
/// [FalcoBreakpoint.twoPane] on, the detail of a row opens beside the
/// [list]; narrower windows show the list alone and open details as
/// pages. Rows open details through [ListDetail.maybeOf].
///
/// The detail pane is a navigator of its own, so a detail page that
/// closes itself (after a delete) only empties the pane, and system back
/// closes the detail before it leaves the screen.
class ListDetail extends StatefulWidget {
  /// Creates the frame around [list].
  const new({required this.list, super.key});

  /// The list, usually with tabs and a create button.
  final Widget list;

  /// The frame around [context] while it shows two panes, else null.
  static ListDetailState? maybeOf(BuildContext context) {
    final state = context.findAncestorStateOfType<ListDetailState>();
    return state != null && state._wide ? state : null;
  }

  @override
  State<ListDetail> createState() => ListDetailState();
}

/// State of a [ListDetail]; [show] puts a detail beside the list.
class ListDetailState extends State<ListDetail> {
  // Keeps the list's state (tab, scroll, search) when the window crosses
  // the breakpoint.
  final GlobalKey _listKey = GlobalKey();
  var _wide = false;
  ({Object key, Widget page})? _detail;

  /// Shows [page] beside the list. [key] names the detail; showing the
  /// same key again keeps its page and state.
  void show(Object key, Widget page) {
    if (_detail?.key == key) return;
    setState(() => _detail = (key: key, page: page));
  }

  void _close() => setState(() => _detail = null);

  @override
  Widget build(BuildContext context) {
    final list = KeyedSubtree(key: _listKey, child: widget.list);
    return LayoutBuilder(
      builder: (context, constraints) {
        _wide = constraints.maxWidth >= FalcoBreakpoint.twoPane;
        // ponytail: an open detail is dropped below the breakpoint; push
        // it as a page when rotating with an open detail matters.
        if (!_wide) return list;
        final detail = _detail;
        return PopScope(
          canPop: detail == null,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _close();
          },
          child: Row(
            children: [
              SizedBox(
                width: (constraints.maxWidth * 0.4).clamp(320, 420),
                child: list,
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: ClipRect(
                  child: Navigator(
                    pages: [
                      MaterialPage<void>(
                        child: Scaffold(
                          body: Center(
                            child: EmptyHint(
                              message: AppLocalizations.of(context).detailPick,
                            ),
                          ),
                        ),
                      ),
                      if (detail != null)
                        MaterialPage<void>(
                          key: ValueKey(detail.key),
                          child: detail.page,
                        ),
                    ],
                    onDidRemovePage: (page) {
                      if (page.key == ValueKey(detail?.key)) _close();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
