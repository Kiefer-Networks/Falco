// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.components

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawWithCache
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.PathEffect
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.unit.dp
import java.text.DateFormat
import java.util.Date

/**
 * Compose-Canvas line chart. Plots `points` (epoch seconds → value) without
 * pulling in a charting library — F-Droid clean, no extra deps.
 *
 * Y-axis auto-scales to the data; [maxY] is a minimum ceiling (CPU keeps a
 * 100 % scale but grows past it on multi vCPU servers). An optional
 * [secondary] series is drawn on the same axes in [secondaryColor]. Three X-tick
 * timestamps (start / mid / end) are rendered using the system locale's short
 * time format.
 */
@Composable
fun LineChart(
    points: List<Pair<Long, Double>>,
    modifier: Modifier = Modifier,
    minY: Double = 0.0,
    maxY: Double? = null,
    unit: String = "",
    color: Color = MaterialTheme.colorScheme.primary,
    secondary: List<Pair<Long, Double>> = emptyList(),
    secondaryColor: Color = MaterialTheme.colorScheme.tertiary,
) {
    if (points.isEmpty()) {
        Box(
            modifier = modifier
                .fillMaxWidth()
                .height(140.dp),
            contentAlignment = Alignment.Center,
        ) {
            Text(
                "—",
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                style = MaterialTheme.typography.bodySmall,
            )
        }
        return
    }

    val all = points + secondary
    val (derivedMinY, derivedMaxY) = chartYRange(all.map { it.second }, minY, maxY)
    val labelColor = MaterialTheme.colorScheme.onSurfaceVariant
    val axisColor = MaterialTheme.colorScheme.outlineVariant
    val fillColor = color.copy(alpha = 0.18f)
    val timeFormat = DateFormat.getTimeInstance(DateFormat.SHORT)
    val labels = listOf(
        "%.0f%s".format(derivedMaxY, unit),
        "%.0f%s".format(derivedMinY + (derivedMaxY - derivedMinY) / 2.0, unit),
        "%.0f%s".format(derivedMinY, unit),
    )
    val xLabels = listOf(
        timeFormat.format(Date(points.first().first * 1000)),
        timeFormat.format(Date(points[points.size / 2].first * 1000)),
        timeFormat.format(Date(points.last().first * 1000)),
    )

    Column(modifier = modifier.fillMaxWidth()) {
        Row(modifier = Modifier.fillMaxWidth()) {
            Column(
                modifier = Modifier.fillMaxWidth(0.18f).height(140.dp),
                verticalArrangement = Arrangement.SpaceBetween,
            ) {
                labels.forEach {
                    Text(it, style = MaterialTheme.typography.labelSmall, color = labelColor)
                }
            }
            Canvas(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(140.dp)
                    .drawWithCache {
                        // Pre-compute pixel-space coordinates for the line path.
                        val w = size.width
                        val h = size.height
                        val tMin = all.minOf { it.first }
                        val tMax = all.maxOf { it.first }
                        val tSpan = tMax - tMin
                        val ySpan = (derivedMaxY - derivedMinY).coerceAtLeast(1e-6)
                        fun coordsOf(series: List<Pair<Long, Double>>) = series.map { (t, v) ->
                            // A single timestamp spans the full width as a flat line.
                            val x = if (tSpan <= 0L) 0.0 else ((t - tMin).toDouble() / tSpan) * w
                            val y = h - ((v - derivedMinY) / ySpan).toFloat().coerceIn(0f, 1f) * h
                            Offset(x.toFloat(), y)
                        }.let { if (it.size == 1) it + Offset(w, it[0].y) else it }
                        fun pathOf(coords: List<Offset>) = Path().apply {
                            coords.forEachIndexed { i, p ->
                                if (i == 0) moveTo(p.x, p.y) else lineTo(p.x, p.y)
                            }
                        }
                        val coords = coordsOf(points)
                        val linePath = pathOf(coords)
                        val secondaryPath = secondary.takeIf { it.isNotEmpty() }?.let { pathOf(coordsOf(it)) }
                        val fillPath = Path().apply {
                            addPath(linePath)
                            lineTo(coords.last().x, h)
                            lineTo(coords.first().x, h)
                            close()
                        }
                        onDrawBehind {
                            // grid: 3 horizontal lines (min/mid/max).
                            val grid = floatArrayOf(0f, h / 2f, h - 1f)
                            grid.forEach { y ->
                                drawLine(
                                    color = axisColor,
                                    start = Offset(0f, y),
                                    end = Offset(w, y),
                                    strokeWidth = 1f,
                                    pathEffect = PathEffect.dashPathEffect(floatArrayOf(6f, 6f)),
                                )
                            }
                            drawPath(path = fillPath, color = fillColor)
                            drawPath(
                                path = linePath,
                                color = color,
                                style = Stroke(width = 3f, cap = StrokeCap.Round),
                            )
                            secondaryPath?.let {
                                drawPath(
                                    path = it,
                                    color = secondaryColor,
                                    style = Stroke(width = 3f, cap = StrokeCap.Round),
                                )
                            }
                        }
                    },
            ) {}
        }
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            // pad to align under canvas
            Text("", modifier = Modifier.fillMaxWidth(0.18f), style = MaterialTheme.typography.labelSmall)
            xLabels.forEachIndexed { i, label ->
                Text(
                    text = label,
                    style = MaterialTheme.typography.labelSmall,
                    color = labelColor,
                )
                if (i < xLabels.lastIndex) {
                    androidx.compose.foundation.layout.Spacer(modifier = Modifier.fillMaxWidth(0.0001f))
                }
            }
        }
    }
}

/**
 * Y range of a chart: starts at [minY] (or lower data), ends at the data max,
 * never below [ceilingAtLeast] and never a zero height span (equal values).
 */
internal fun chartYRange(values: List<Double>, minY: Double, ceilingAtLeast: Double?): Pair<Double, Double> {
    val lo = minOf(minY, values.minOrNull() ?: minY)
    val dataMax = values.maxOrNull() ?: lo
    val hi = maxOf(dataMax, ceilingAtLeast ?: dataMax, lo + 1.0)
    return lo to hi
}
