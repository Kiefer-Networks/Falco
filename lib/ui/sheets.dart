// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:falco/ui/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Shows [sheet] as a modal bottom sheet that follows the keyboard.
Future<R?> _showSheet<R>(BuildContext context, Widget sheet) =>
    showModalBottomSheet<R>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => sheet,
    );

/// Common frame: handle, title, content, buttons; padded above the
/// keyboard.
class _SheetFrame extends StatelessWidget {
  const new({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: c.hairline),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(FalcoRadius.sheet),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          10,
          20,
          24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: FalcoSpacing.l,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: c.handle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Semantics(
              header: true,
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Edit pattern: a bottom sheet with a form and "Save".
class EditSheet extends StatelessWidget {
  /// Creates the sheet content.
  const new({
    required this.title,
    required this.child,
    required this.onSave,
    this.saving = false,
    super.key,
  });

  /// Opens an [EditSheet] modally.
  static Future<void> show(
    BuildContext context, {
    required String title,
    required Widget child,
    required VoidCallback? onSave,
  }) => _showSheet<void>(
    context,
    EditSheet(title: title, onSave: onSave, child: child),
  );

  /// Localized title, e.g. "Rename".
  final String title;

  /// Form fields.
  final Widget child;

  /// Save callback; null disables "Save" (e.g. invalid form).
  final VoidCallback? onSave;

  /// Shows progress on "Save" and disables it.
  final bool saving;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _SheetFrame(
      title: title,
      children: [
        child,
        FilledButton(
          onPressed: saving ? null : onSave,
          child: saving
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.commonSave),
        ),
      ],
    );
  }
}

/// Confirmation level. The rule lives here, not per screen:
/// [simple] for reversible actions (reboot, shutdown, detach, protection),
/// [typeName] for destructive ones (delete, rebuild, overwrite data).
enum ConfirmLevel {
  /// Level 1: title, consequence, primary action.
  simple,

  /// Level 2: additionally type the resource name.
  typeName,
}

/// A fact row in a [ConfirmSheet] (e.g. Project, Address).
@immutable
class ConfirmFact {
  /// Creates a fact.
  const new(this.label, this.value, {this.mono = false});

  /// Localized label.
  final String label;

  /// Value.
  final String value;

  /// Shows [value] in mono.
  final bool mono;
}

/// The one confirmation pattern. Pops `true` when confirmed.
///
/// With [ConfirmLevel.typeName] the confirm button stays disabled until
/// the trimmed input equals [resourceName] exactly (case sensitive).
class ConfirmSheet extends StatefulWidget {
  /// Creates the sheet content.
  const new({
    required this.title,
    required this.consequence,
    required this.confirmLabel,
    required this.resourceName,
    this.level = ConfirmLevel.simple,
    this.facts = const [],
    this.destructive = false,
    super.key,
  });

  /// Opens a [ConfirmSheet] and resolves to true when confirmed.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String consequence,
    required String confirmLabel,
    required String resourceName,
    ConfirmLevel level = ConfirmLevel.simple,
    List<ConfirmFact> facts = const [],
    bool destructive = false,
  }) async =>
      await _showSheet<bool>(
        context,
        ConfirmSheet(
          title: title,
          consequence: consequence,
          confirmLabel: confirmLabel,
          resourceName: resourceName,
          level: level,
          facts: facts,
          destructive: destructive,
        ),
      ) ??
      false;

  /// Whether [input] confirms [resourceName] at level 2.
  static bool matches(String input, String resourceName) =>
      input.trim() == resourceName;

  /// Question, e.g. "Reboot db-primary?".
  final String title;

  /// What will happen.
  final String consequence;

  /// Primary button label.
  final String confirmLabel;

  /// Name to type at level 2.
  final String resourceName;

  /// Confirmation level.
  final ConfirmLevel level;

  /// Context facts.
  final List<ConfirmFact> facts;

  /// Error colored primary button.
  final bool destructive;

  @override
  State<ConfirmSheet> createState() => _ConfirmSheetState();
}

class _ConfirmSheetState extends State<ConfirmSheet> {
  String _input = '';

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final needsName = widget.level == ConfirmLevel.typeName;
    final enabled =
        !needsName || ConfirmSheet.matches(_input, widget.resourceName);
    return _SheetFrame(
      title: widget.title,
      children: [
        Text(widget.consequence, style: theme.textTheme.bodyLarge),
        if (widget.facts.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: c.hairline),
              borderRadius: BorderRadius.circular(FalcoRadius.field),
            ),
            child: Column(
              spacing: FalcoSpacing.s,
              children: [
                for (final f in widget.facts)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 96,
                        child: Text(
                          f.label,
                          style: TextStyle(
                            fontSize: 13,
                            color: c.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          f.value,
                          style: TextStyle(
                            fontSize: 13,
                            color: c.text,
                            fontFamily: f.mono ? 'IBMPlexMono' : null,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        if (needsName)
          TextField(
            key: const ValueKey('confirm-name'),
            autocorrect: false,
            enableSuggestions: false,
            onChanged: (v) => setState(() => _input = v),
            decoration: InputDecoration(
              labelText: l10n.confirmTypeNameLabel,
              helperText: l10n.confirmTypeName(widget.resourceName),
              helperMaxLines: 2,
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: FalcoSpacing.s,
          children: [
            FilledButton(
              style: widget.destructive
                  ? FilledButton.styleFrom(
                      backgroundColor: c.error,
                      foregroundColor: c.onError,
                    )
                  : null,
              onPressed: enabled ? () => Navigator.pop(context, true) : null,
              child: Text(widget.confirmLabel),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.commonCancel),
            ),
          ],
        ),
      ],
    );
  }
}

/// A Cloud project in the [ScopeSwitcherSheet].
@immutable
class ScopeProjectItem {
  /// Creates a project entry.
  const new({required this.id, required this.name});

  /// Project id.
  final String id;

  /// Display name.
  final String name;
}

/// An account in the [ScopeSwitcherSheet].
@immutable
class ScopeAccountItem {
  /// Creates an account entry.
  const new({
    required this.id,
    required this.name,
    this.projects = const [],
    this.hasRobot = false,
  });

  /// Account id.
  final String id;

  /// Display name.
  final String name;

  /// Cloud projects.
  final List<ScopeProjectItem> projects;

  /// Whether a Robot login exists.
  final bool hasRobot;
}

/// What a scope entry points at.
enum ScopeKind {
  /// One Cloud project.
  project,

  /// All Cloud projects of the account.
  allProjects,

  /// The Robot login of the account.
  robot,
}

/// A selected scope; [projectId] is set for [ScopeKind.project] only.
@immutable
class ScopeChoice {
  /// Creates a choice.
  const new(this.accountId, this.kind, [this.projectId]);

  /// Account id.
  final String accountId;

  /// Kind.
  final ScopeKind kind;

  /// Project id for [ScopeKind.project].
  final String? projectId;

  @override
  bool operator ==(Object other) =>
      other is ScopeChoice &&
      other.accountId == accountId &&
      other.kind == kind &&
      other.projectId == projectId;

  @override
  int get hashCode => Object.hash(accountId, kind, projectId);
}

/// Scope switcher: accounts with their projects, an "All projects" entry
/// per account and Robot. Pure UI: pops the chosen [ScopeChoice].
class ScopeSwitcherSheet extends StatelessWidget {
  /// Creates the sheet content.
  const new({required this.accounts, required this.selected, super.key});

  /// Opens the sheet; resolves to the choice or null when dismissed.
  static Future<ScopeChoice?> show(
    BuildContext context, {
    required List<ScopeAccountItem> accounts,
    required ScopeChoice selected,
  }) => _showSheet<ScopeChoice>(
    context,
    ScopeSwitcherSheet(accounts: accounts, selected: selected),
  );

  /// Accounts in display order.
  final List<ScopeAccountItem> accounts;

  /// Current scope.
  final ScopeChoice selected;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final l10n = AppLocalizations.of(context);
    Widget entry(String label, ScopeChoice choice, IconData icon) {
      final isSelected = choice == selected;
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        selected: isSelected,
        selectedColor: c.accent,
        leading: Icon(icon, size: 20),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? c.accent : c.text,
          ),
        ),
        trailing: isSelected ? Icon(Icons.check, color: c.accent) : null,
        onTap: () => Navigator.pop(context, choice),
      );
    }

    return _SheetFrame(
      title: l10n.scopeSwitch,
      children: [
        for (final a in accounts)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                a.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.78,
                  color: c.textSecondary,
                ),
              ),
              if (a.projects.length > 1)
                entry(
                  l10n.scopeAllProjects,
                  ScopeChoice(a.id, ScopeKind.allProjects),
                  Icons.layers_outlined,
                ),
              for (final p in a.projects)
                entry(
                  p.name,
                  ScopeChoice(a.id, ScopeKind.project, p.id),
                  Icons.cloud_outlined,
                ),
              if (a.hasRobot)
                entry(
                  l10n.scopeRobot,
                  ScopeChoice(a.id, ScopeKind.robot),
                  Icons.dns_outlined,
                ),
            ],
          ),
      ],
    );
  }
}

/// Top bar trigger for the [ScopeSwitcherSheet]: small caption over the
/// current scope name with a chevron.
class ScopeSwitcherButton extends StatelessWidget {
  /// Creates the trigger.
  const new({
    required this.scopeName,
    required this.onTap,
    this.caption,
    super.key,
  });

  /// Current project, "All projects" or "Robot".
  final String scopeName;

  /// Caption above the name; defaults to "Project".
  final String? caption;

  /// Opens the sheet.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      label: '${l10n.scopeSwitch}: $scopeName',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (caption ?? l10n.scopeProject).toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.66,
                      color: c.textSecondary,
                    ),
                  ),
                  Text(
                    scopeName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: c.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              Icon(Icons.expand_more, size: 18, color: c.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
