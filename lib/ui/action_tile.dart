// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:falco/ui/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

/// A primary action of a detail page: icon over label in a 64 dp tile.
/// A `DetailPage` shows at most four.
class ActionTile extends StatelessWidget {
  /// Creates a tile; a null [onTap] disables it.
  const new({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  /// Icon above the label.
  final IconData icon;

  /// Localized label.
  final String label;

  /// Tap callback; null disables the tile.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final fg = onTap == null ? c.textMuted : c.text;
    final radius = BorderRadius.circular(FalcoRadius.card);
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: c.hairline),
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: SizedBox(
            height: 64,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: fg),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: fg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
