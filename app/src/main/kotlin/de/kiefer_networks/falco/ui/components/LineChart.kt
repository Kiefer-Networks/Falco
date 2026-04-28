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
 * Y-axis auto-scales between [minY] and [maxY] (auto when null). Three X-tick
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

    val derivedMaxY = (maxY ?: points.maxOf { it.second }.coerceAtLeast(minY + 1.0))
    val derivedMinY = minOf(minY, points.minOf { it.second })
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
                        val tMin = points.first().first
                        val tMax = points.last().first
                        val tSpan = (tMax - tMin).coerceAtLeast(1L)
                        val ySpan = (derivedMaxY - derivedMinY).coerceAtLeast(1e-6)
                        val coords = points.map { (t, v) ->
                            val x = ((t - tMin).toDouble() / tSpan) * w
                            val y = h - ((v - derivedMinY) / ySpan).toFloat() * h
                            Offset(x.toFloat(), y)
                        }
                        val linePath = Path().apply {
                            coords.forEachIndexed { i, p ->
                                if (i == 0) moveTo(p.x, p.y) else lineTo(p.x, p.y)
                            }
                        }
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
