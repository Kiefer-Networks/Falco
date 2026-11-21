// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:material_ui/material_ui.dart';

/// Screen frame: top bar with the scope switcher (or a title), icon
/// [actions] and the [moreMenu], plus the snackbar host.
///
/// Show feedback with [FalcoScaffold.showSnack]; it replaces the current
/// snackbar so a screen never stacks more than one.
class FalcoScaffold extends StatelessWidget {
  /// Creates the frame around [body].
  const new({
    required this.body,
    this.scopeSwitcher,
    this.title,
    this.actions = const [],
    this.moreMenu,
    this.bottomNavigationBar,
    this.floatingActionButton,
    super.key,
  });

  /// Main content.
  final Widget body;

  /// Scope switcher slot (usually `ScopeSwitcherButton`); wins over [title].
  final Widget? scopeSwitcher;

  /// Plain title when there is no scope switcher.
  final String? title;

  /// Icon buttons before the more menu (search, activity). Each must carry
  /// a tooltip or semantics label.
  final List<Widget> actions;

  /// The single "more" menu (usually `MoreMenu`).
  final Widget? moreMenu;

  /// Bottom navigation.
  final Widget? bottomNavigationBar;

  /// Floating action button.
  final Widget? floatingActionButton;

  /// Shows [message] as the screen's one snackbar.
  static void showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: scopeSwitcher == null ? null : 8,
        title: scopeSwitcher ?? (title == null ? null : Text(title!)),
        actions: [...actions, ?moreMenu, const SizedBox(width: 4)],
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}

/// One entry of a [MoreMenu].
@immutable
class MoreMenuItem {
  /// Creates an entry.
  const new({
    required this.label,
    required this.onSelected,
    this.icon,
    this.destructive = false,
  });

  /// Localized label.
  final String label;

  /// Called when chosen.
  final VoidCallback onSelected;

  /// Optional leading icon.
  final IconData? icon;

  /// Draws the entry in the error color (e.g. "Delete").
  final bool destructive;
}

/// The single "more" menu of a screen's top bar.
class MoreMenu extends StatelessWidget {
  /// Creates the menu with [items].
  const new({required this.items, super.key});

  /// Entries in display order.
  final List<MoreMenuItem> items;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    return PopupMenuButton<int>(
      tooltip: AppLocalizations.of(context).moreActions,
      icon: Icon(Icons.more_vert, color: c.text),
      onSelected: (i) => items[i].onSelected(),
      itemBuilder: (context) => [
        for (final (i, item) in items.indexed)
          PopupMenuItem(
            value: i,
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Icon(
                    item.icon,
                    size: 20,
                    color: item.destructive ? c.error : c.textSecondary,
                  ),
                  const SizedBox(width: 12),
                ],
                Flexible(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: item.destructive ? c.error : c.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
