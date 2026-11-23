// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/detail_page.dart';
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

  /// Bottom navigation. A [DetailPage] body brings its own: the
  /// [DetailActionBar] of its actions.
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
      bottomNavigationBar:
          bottomNavigationBar ??
          switch (body) {
            DetailPage(:final actions) when actions.isNotEmpty =>
              DetailActionBar(actions: actions),
            _ => null,
          },
      floatingActionButton: floatingActionButton,
    );
  }
}

/// The single "more" menu of a screen's top bar or of a row: opens the
/// grouped action sheet ([showActionSheet]) with [actions].
class MoreMenu extends StatelessWidget {
  /// Creates the menu with [actions].
  const new({required this.actions, this.title, super.key});

  /// Entries; the sheet groups them by [ActionGroup].
  final List<DetailAction> actions;

  /// Sheet title; defaults to "More actions".
  final String? title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return IconButton(
      tooltip: l10n.moreActions,
      icon: Icon(Icons.more_vert, color: FalcoColors.of(context).text),
      onPressed: () => showActionSheet(
        context,
        title: title ?? l10n.moreActions,
        actions: actions,
      ),
    );
  }
}
