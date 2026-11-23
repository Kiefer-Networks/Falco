// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:math' as math;

import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/theme/falco_colors.dart';
import 'package:falco/ui/theme/falco_text.dart';
import 'package:falco/ui/theme/tokens.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// Time range of a [MetricChart].
enum MetricPeriod {
  /// Last hour.
  hour(Duration(hours: 1)),

  /// Last 24 hours.
  day(Duration(hours: 24)),

  /// Last 7 days.
  week(Duration(days: 7)),

  /// Last 30 days.
  month(Duration(days: 30));

  new(this.duration);

  /// Length of the range.
  final Duration duration;

  /// Localized short label.
  String label(AppLocalizations l10n) => switch (this) {
    hour => l10n.periodHour,
    day => l10n.periodDay,
    week => l10n.periodWeek,
    month => l10n.periodMonth,
  };
}

/// One line of a [MetricChart].
@immutable
class MetricSeries {
  /// Creates a series.
  const new({required this.label, required this.points});

  /// Localized legend label (e.g. "in", "out").
  final String label;

  /// Samples in time order.
  final List<(DateTime, double)> points;
}

/// Metric card: title, period selector (1h/24h/7d/30d), optional headline
/// value, legend for several series, and a line chart with unit labels.
class MetricChart extends StatelessWidget {
  /// Creates a chart.
  const new({
    required this.title,
    required this.unit,
    required this.series,
    required this.period,
    required this.onPeriodChanged,
    this.headline,
    this.caption,
    super.key,
  });

  /// Localized title, e.g. "CPU".
  final String title;

  /// Unit shown on the value axis, e.g. "%", "MB/s".
  final String unit;

  /// Lines; the first uses the accent, then text, muted (dashed), info.
  final List<MetricSeries> series;

  /// Selected period.
  final MetricPeriod period;

  /// Called with the new period.
  final ValueChanged<MetricPeriod> onPeriodChanged;

  /// Large value above the chart, e.g. "38%".
  final String? headline;

  /// Text next to [headline], e.g. "avg of 4 vCPU".
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    final text = FalcoText.of(context);
    final l10n = AppLocalizations.of(context);
    final colors = [c.accent, c.text, c.textMuted, c.info];
    final hasData = series.any((s) => s.points.length > 1);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.hairline),
        borderRadius: BorderRadius.circular(FalcoRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(title.toUpperCase(), style: text.sectionLabel),
                ),
              ),
              Semantics(
                label: l10n.chartPeriod,
                child: Row(
                  children: [
                    for (final p in MetricPeriod.values)
                      _PeriodButton(
                        label: p.label(l10n),
                        selected: p == period,
                        onTap: () => onPeriodChanged(p),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (headline != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(headline!, style: text.monoValue),
                if (caption != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    caption!,
                    style: TextStyle(fontSize: 12, color: c.textSecondary),
                  ),
                ],
              ],
            ),
          if (series.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(
                spacing: 12,
                children: [
                  for (final (i, s) in series.indexed)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 2,
                          color: colors[i % colors.length],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          s.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: hasData
                ? _chart(context, colors)
                : Center(
                    child: Text(
                      l10n.chartNoData,
                      style: TextStyle(fontSize: 13, color: c.textSecondary),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _chart(BuildContext context, List<Color> colors) {
    final c = FalcoColors.of(context);
    final axis = FalcoText.of(context).monoSmall
        .copyWith(fontSize: 11, color: c.textMuted);
    final locale = AppLocalizations.of(context).localeName;
    final timeFormat = period.duration <= const Duration(days: 1)
        ? DateFormat.Hm(locale)
        : DateFormat.MMMd(locale);
    final valueFormat = NumberFormat.compact(locale: locale);

    var minX = double.infinity;
    var maxX = -double.infinity;
    var maxY = 0.0;
    for (final s in series) {
      for (final (t, v) in s.points) {
        final x = t.millisecondsSinceEpoch.toDouble();
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (v > maxY) maxY = v;
      }
    }
    maxY = _niceCeil(maxY);
    // x runs from 0 so the three time labels land on start, middle, end.
    final span = maxX - minX == 0 ? 1.0 : maxX - minX;

    return Semantics(
      label: title,
      child: LineChart(
        duration: Duration.zero,
        LineChartData(
          minX: 0,
          maxX: span,
          minY: 0,
          maxY: maxY,
          lineTouchData: const LineTouchData(enabled: false),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: maxY / 2,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: c.divider, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 52,
                interval: maxY / 2,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    '${valueFormat.format(value)} $unit',
                    style: axis,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: span / 2,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    timeFormat.format(
                      DateTime.fromMillisecondsSinceEpoch(
                        (minX + value).toInt(),
                      ),
                    ),
                    style: axis,
                  ),
                ),
              ),
            ),
          ),
          lineBarsData: [
            for (final (i, s) in series.indexed)
              LineChartBarData(
                spots: [
                  for (final (t, v) in s.points)
                    FlSpot(t.millisecondsSinceEpoch - minX, v),
                ],
                color: colors[i % colors.length],
                barWidth: i == 0 ? 2 : 1.6,
                isStrokeJoinRound: true,
                dashArray: i == 2 ? const [4, 3] : null,
                dotData: const FlDotData(show: false),
              ),
          ],
        ),
      ),
    );
  }
}

/// Smallest of 1, 2, 2.5, 5 × 10^n that is at least [v] (axis maximum).
double _niceCeil(double v) {
  if (v <= 0) return 1;
  final base = math.pow(10, (math.log(v) / math.ln10).floor()).toDouble();
  for (final m in const [1.0, 2.0, 2.5, 5.0]) {
    if (m * base >= v) return m * base;
  }
  return 10 * base;
}

class _PeriodButton extends StatelessWidget {
  const new({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = FalcoColors.of(context);
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FalcoRadius.small),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: kFalcoMinTouchTarget,
            minHeight: kFalcoMinTouchTarget,
          ),
          child: Center(
            child: Container(
              height: 28,
              constraints: const BoxConstraints(minWidth: 40),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? c.surfaceSelected : null,
                borderRadius: BorderRadius.circular(FalcoRadius.small),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: selected ? c.text : c.textSecondary,
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
