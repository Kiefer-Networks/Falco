// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/status_badge.dart';
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:falco/ui/theme/falco_text.dart';
import 'package:material_ui/material_ui.dart';

/// Compact list row: status dot, name with status word, a mono line and
/// an optional sparkline.
class ResourceRow extends StatelessWidget {
  /// Creates a row.
  const new({
    required this.status,
    required this.name,
    required this.monoLine,
    this.sparkline,
    this.onTap,
    super.key,
  });

  /// Status shown as dot and word.
  final ResourceStatus status;

  /// Resource name.
  final String name;

  /// Mono line, e.g. "49.13.204.17 · CX32 · fsn1".
  final String monoLine;

  /// Recent values for a 64×24 sparkline; hidden when null or shorter
  /// than two points.
  final List<double>? sparkline;

  /// Opens the detail.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final statusColor = status.color(c);
    final word = status.label(AppLocalizations.of(context));
    final points = sparkline;
    return Semantics(
      button: onTap != null,
      label: '$name, $word, $monoLine',
      onTap: onTap,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 64),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.divider)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 10,
                child: Center(child: StatusDot(status: status)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          word,
                          style: TextStyle(fontSize: 12, color: statusColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      monoLine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FalcoText.of(context).monoSmall,
                    ),
                  ],
                ),
              ),
              if (points != null && points.length > 1) ...[
                const SizedBox(width: 12),
                CustomPaint(
                  size: const Size(64, 24),
                  painter: _SparklinePainter(
                    points,
                    status.hollow ? c.hairline : c.sparkline,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  new(this.values, this.color);

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var min = values.first;
    var max = values.first;
    for (final v in values) {
      if (v < min) min = v;
      if (v > max) max = v;
    }
    final span = max - min == 0 ? 1.0 : max - min;
    const inset = 2.0;
    final h = size.height - inset * 2;
    final w = size.width - inset * 2;
    final path = Path();
    for (final (i, v) in values.indexed) {
      final x = inset + w * i / (values.length - 1);
      // Flat series sit at the bottom like an idle machine.
      final y = max == min ? inset + h : inset + h - h * (v - min) / span;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.values != values || old.color != color;
}
