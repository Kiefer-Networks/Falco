// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/feedback.dart';
import 'package:falco/ui/sheets.dart';
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:falco/ui/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

/// One form field: text (optionally secret) or a choice of [options].
@immutable
class FieldSpec {
  /// Creates a field; the widget key is `ValueKey(key)`.
  const new(
    this.key,
    this.label, {
    this.initial = '',
    this.secret = false,
    this.maxLength,
    this.helper,
    this.options = const {},
    this.multiple = false,
    this.multiline = false,
  });

  /// Value key in the form map and widget key.
  final String key;

  /// Localized label.
  final String label;

  /// Initial value; secrets are never prefilled.
  final String initial;

  /// Obscured, no suggestions.
  final bool secret;

  /// Maximum length.
  final int? maxLength;

  /// Helper text below the field.
  final String? helper;

  /// Value to label; a non empty map makes the field a choice.
  final Map<String, String> options;

  /// A choice of several [options]; the value joins them with commas.
  final bool multiple;

  /// Several lines of text (PEM, zone files). Never obscured, since
  /// Flutter obscures single lines only; suggestions stay off for secrets.
  final bool multiline;
}

/// Renders [fields] and reports all values on every change. Fields may
/// come and go between builds; values of a key are kept.
class FormFields extends StatefulWidget {
  /// Creates the fields.
  const new({
    required this.fields,
    required this.onChanged,
    this.values = const {},
    super.key,
  });

  /// Fields in display order.
  final List<FieldSpec> fields;

  /// Values entered before (e.g. when a wizard step is shown again); win
  /// over [FieldSpec.initial].
  final Map<String, String> values;

  /// Called with all current values (by key).
  final ValueChanged<Map<String, String>> onChanged;

  /// Initial values of [fields].
  static Map<String, String> initialValues(List<FieldSpec> fields) => {
    for (final f in fields) f.key: f.initial,
  };

  @override
  State<FormFields> createState() => _FormFieldsState();
}

class _FormFieldsState extends State<FormFields> {
  final _text = <String, TextEditingController>{};
  late final Map<String, String> _values = {
    ...FormFields.initialValues(widget.fields),
    ...widget.values,
  };

  @override
  void dispose() {
    for (final c in _text.values) {
      c.dispose();
    }
    super.dispose();
  }

  Set<String> _picked(FieldSpec f) =>
      (_values[f.key] ?? f.initial).split(',').toSet();

  void _set(String key, String value) {
    setState(() => _values[key] = value);
    widget.onChanged(Map.of(_values));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: FalcoSpacing.l,
      children: [
        for (final f in widget.fields)
          if (f.options.isNotEmpty)
            InputDecorator(
              decoration: InputDecoration(
                labelText: f.label,
                helperText: f.helper,
                helperMaxLines: 3,
              ),
              child: Wrap(
                key: ValueKey(f.key),
                spacing: FalcoSpacing.s,
                runSpacing: FalcoSpacing.s,
                children: [
                  for (final MapEntry(key: value, value: label)
                      in f.options.entries)
                    if (f.multiple)
                      FilterChip(
                        label: Text(label),
                        selected: _picked(f).contains(value),
                        onSelected: (on) => _set(
                          f.key,
                          [
                            for (final o in f.options.keys)
                              if (o == value ? on : _picked(f).contains(o)) o,
                          ].join(','),
                        ),
                      )
                    else
                      ChoiceChip(
                        label: Text(label),
                        selected: (_values[f.key] ?? f.initial) == value,
                        onSelected: (_) => _set(f.key, value),
                      ),
                ],
              ),
            )
          else
            TextField(
              key: ValueKey(f.key),
              controller: _text[f.key] ??= TextEditingController(
                text: _values[f.key] ??= f.initial,
              ),
              obscureText: f.secret && !f.multiline,
              // iOS shows no system menu for obscured fields, so paste
              // would be impossible there; they get the Flutter menu.
              contextMenuBuilder: (context, state) =>
                  !f.secret && SystemContextMenu.isSupportedByField(state)
                  ? SystemContextMenu.editableText(editableTextState: state)
                  : AdaptiveTextSelectionToolbar.editableText(
                      editableTextState: state,
                    ),
              minLines: f.multiline ? 3 : null,
              maxLines: f.multiline ? 8 : 1,
              keyboardType: f.multiline ? TextInputType.multiline : null,
              autocorrect: !f.secret,
              enableSuggestions: !f.secret,
              maxLength: f.maxLength,
              onChanged: (v) => _set(f.key, v),
              decoration: InputDecoration(
                labelText: f.label,
                helperText: f.helper,
                helperMaxLines: 3,
              ),
            ),
      ],
    );
  }
}

/// Edit pattern with a form whose save may fail: runs [onSave] with the
/// values, shows its [FalcoError] in the sheet, and pops `true` when it
/// succeeded. Nothing is stored by the sheet itself.
class FormSheet extends StatefulWidget {
  /// Creates the sheet.
  const new({
    required this.title,
    required this.fields,
    required this.valid,
    required this.onSave,
    super.key,
  });

  /// Opens the sheet; resolves to true after a successful save.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required List<FieldSpec> Function(Map<String, String> values) fields,
    required bool Function(Map<String, String> values) valid,
    required Future<void> Function(Map<String, String> values) onSave,
  }) async =>
      await showFalcoSheet<bool>(
        context,
        FormSheet(title: title, fields: fields, valid: valid, onSave: onSave),
      ) ??
      false;

  /// Localized title.
  final String title;

  /// Fields for the current values (fields may depend on a choice).
  final List<FieldSpec> Function(Map<String, String> values) fields;

  /// Enables "Save".
  final bool Function(Map<String, String> values) valid;

  /// Checks and stores; throws a [FalcoError] to stay open.
  final Future<void> Function(Map<String, String> values) onSave;

  @override
  State<FormSheet> createState() => _FormSheetState();
}

class _FormSheetState extends State<FormSheet> {
  var _entered = <String, String>{};

  /// What was entered over the initial values of the fields shown now, so
  /// a field that appears later (after a choice) counts with its default.
  Map<String, String> get _values => {
    ...FormFields.initialValues(widget.fields(_entered)),
    ..._entered,
  };
  bool _saving = false;
  String? _error;

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.onSave(_values);
      if (mounted) Navigator.pop(context, true);
    } on FalcoError catch (e) {
      if (mounted) setState(() => _error = errorText(e, l10n));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => EditSheet(
    title: widget.title,
    saving: _saving,
    onSave: widget.valid(_values) ? _save : null,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: FalcoSpacing.m,
      children: [
        if (_error case final error?) ErrorBanner(message: error),
        FormFields(
          fields: widget.fields(_values),
          onChanged: (v) => setState(() => _entered = {..._entered, ...v}),
        ),
      ],
    ),
  );
}

/// A single choice as a list: label per value, an optional detail line, a
/// check at the selected one, and a search field for long lists.
class ChoiceList extends StatefulWidget {
  /// Creates the list.
  const new({
    required this.options,
    required this.selected,
    required this.onSelected,
    this.details = const {},
    this.searchable = false,
    super.key,
  });

  /// Shows [options] in a sheet; resolves to the picked value.
  static Future<String?> show(
    BuildContext context, {
    required String title,
    required Map<String, String> options,
    required String selected,
    Map<String, String> details = const {},
    bool searchable = false,
  }) => showFalcoSheet<String>(
    context,
    Builder(
      builder: (context) => SheetFrame(
        title: title,
        children: [
          ChoiceList(
            options: options,
            selected: selected,
            details: details,
            searchable: searchable,
            onSelected: (v) => Navigator.pop(context, v),
          ),
        ],
      ),
    ),
  );

  /// Value to label.
  final Map<String, String> options;

  /// Selected value.
  final String selected;

  /// Value to a second line (size, price, "deprecated").
  final Map<String, String> details;

  /// Shows a search field over labels and details.
  final bool searchable;

  /// Called with the tapped value.
  final ValueChanged<String> onSelected;

  @override
  State<ChoiceList> createState() => _ChoiceListState();
}

class _ChoiceListState extends State<ChoiceList> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    // Without a search field there is no query to filter by.
    final q = widget.searchable ? _query.trim().toLowerCase() : '';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.searchable)
          TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).commonSearch,
              prefixIcon: const Icon(Icons.search, size: 20),
            ),
          ),
        for (final MapEntry(key: value, value: label) in widget.options.entries)
          if (q.isEmpty ||
              '$label ${widget.details[value] ?? ''}'.toLowerCase().contains(q))
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              selected: value == widget.selected,
              selectedColor: c.accent,
              title: Text(label),
              subtitle: switch (widget.details[value]) {
                final d? => Text(d),
                null => null,
              },
              trailing: value == widget.selected
                  ? Icon(Icons.check, color: c.accent)
                  : null,
              onTap: () => widget.onSelected(value),
            ),
      ],
    );
  }
}

/// A multiple choice as check boxes with optional detail lines.
class MultiChoiceList extends StatelessWidget {
  /// Creates the list.
  const new({
    required this.options,
    required this.selected,
    required this.onChanged,
    this.details = const {},
    super.key,
  });

  /// Value to label.
  final Map<String, String> options;

  /// Checked values.
  final Set<String> selected;

  /// Value to a second line.
  final Map<String, String> details;

  /// Called with the new set.
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final MapEntry(key: value, value: label) in options.entries)
        CheckboxListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          value: selected.contains(value),
          title: Text(label),
          subtitle: switch (details[value]) {
            final d? => Text(d),
            null => null,
          },
          onChanged: (on) => onChanged(
            on ?? false
                ? {...selected, value}
                : {...selected.where((v) => v != value)},
          ),
        ),
    ],
  );
}
