// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.components

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.IntrinsicSize
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.FilterChip
import androidx.compose.material3.FilterChipDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.ui.theme.MonoStyle
import de.kiefer_networks.falco.ui.theme.SectionLabelStyle
import de.kiefer_networks.falco.ui.theme.falcoColors
import java.util.Locale

val CardShape = RoundedCornerShape(14.dp)
val PillShape = RoundedCornerShape(18.dp)

/** Status families. Off and error are drawn as hollow rings, the rest filled. */
enum class StatusTone { Running, Off, Progress, Error }

@Composable
@ReadOnlyComposable
fun StatusTone.color(): Color = when (this) {
    StatusTone.Running -> MaterialTheme.falcoColors.running
    StatusTone.Off -> MaterialTheme.falcoColors.off
    StatusTone.Progress -> MaterialTheme.falcoColors.progress
    StatusTone.Error -> MaterialTheme.falcoColors.error
}

/** Hetzner Cloud server status to tone. */
fun serverStatusTone(status: String): StatusTone = when (status.lowercase(Locale.ROOT)) {
    "running" -> StatusTone.Running
    "off" -> StatusTone.Off
    "unknown" -> StatusTone.Error
    else -> StatusTone.Progress
}

/** Hetzner action status (`running`, `success`, `error`) to tone. */
fun actionStatusTone(status: String): StatusTone = when (status.lowercase(Locale.ROOT)) {
    "success" -> StatusTone.Running
    "running" -> StatusTone.Progress
    "error" -> StatusTone.Error
    else -> StatusTone.Off
}

@Composable
fun serverStatusLabel(status: String): String = when (status.lowercase(Locale.ROOT)) {
    "running" -> stringResource(R.string.server_status_running)
    "off" -> stringResource(R.string.server_status_off)
    "starting" -> stringResource(R.string.server_status_starting)
    "stopping" -> stringResource(R.string.server_status_stopping)
    "initializing" -> stringResource(R.string.server_status_initializing)
    "rebuilding" -> stringResource(R.string.server_status_rebuilding)
    "migrating" -> stringResource(R.string.server_status_migrating)
    "deleting" -> stringResource(R.string.server_status_deleting)
    else -> status
}

@Composable
fun StatusDot(tone: StatusTone, modifier: Modifier = Modifier, size: Dp = 8.dp) {
    val c = tone.color()
    val ring = tone == StatusTone.Off || tone == StatusTone.Error
    Box(
        modifier
            .size(size)
            .clip(CircleShape)
            .then(
                if (ring) Modifier.border(1.5.dp, c, CircleShape) else Modifier.background(c),
            ),
    )
}

/** Dot or ring plus the status word in the same color. Status is never color alone. */
@Composable
fun StatusIndicator(
    tone: StatusTone,
    label: String,
    modifier: Modifier = Modifier,
    style: TextStyle = MaterialTheme.typography.bodySmall,
) {
    Row(
        modifier = modifier,
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        StatusDot(tone)
        Text(label, style = style, color = tone.color())
    }
}

/** Uppercase, letter spaced label above a group. */
@Composable
fun SectionLabel(
    text: String,
    modifier: Modifier = Modifier,
    color: Color = MaterialTheme.colorScheme.onSurfaceVariant,
    trailing: @Composable (() -> Unit)? = null,
) {
    Row(modifier = modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
        Text(
            text.uppercase(Locale.getDefault()),
            style = SectionLabelStyle,
            color = color,
            modifier = Modifier.weight(1f),
        )
        trailing?.invoke()
    }
}

/** Card with a 1 dp hairline instead of elevation or a tonal fill. */
@Composable
fun HairlineCard(
    modifier: Modifier = Modifier,
    onClick: (() -> Unit)? = null,
    content: @Composable ColumnScope.() -> Unit,
) {
    val colors = CardDefaults.outlinedCardColors(containerColor = MaterialTheme.colorScheme.surface)
    val border = BorderStroke(1.dp, MaterialTheme.falcoColors.hairline)
    if (onClick != null) {
        OutlinedCard(onClick = onClick, modifier = modifier, shape = CardShape, colors = colors, border = border, content = content)
    } else {
        OutlinedCard(modifier = modifier, shape = CardShape, colors = colors, border = border, content = content)
    }
}

/**
 * Cells separated by 1 dp hairlines inside a rounded hairline frame.
 * Rows with fewer than [columns] cells get empty filler cells.
 */
@Composable
fun HairlineGrid(
    columns: Int,
    count: Int,
    modifier: Modifier = Modifier,
    cell: @Composable (index: Int) -> Unit,
) {
    val hairline = MaterialTheme.falcoColors.hairline
    val surface = MaterialTheme.colorScheme.surface
    Column(
        modifier = modifier
            .fillMaxWidth()
            .clip(CardShape)
            .background(hairline)
            .border(1.dp, hairline, CardShape)
            .padding(1.dp),
        verticalArrangement = Arrangement.spacedBy(1.dp),
    ) {
        for (rowStart in 0 until count step columns) {
            Row(
                modifier = Modifier.fillMaxWidth().height(IntrinsicSize.Min),
                horizontalArrangement = Arrangement.spacedBy(1.dp),
            ) {
                for (i in rowStart until rowStart + columns) {
                    Box(Modifier.weight(1f).fillMaxHeight().background(surface)) {
                        if (i < count) cell(i)
                    }
                }
            }
        }
    }
}

/** Key over mono value, for spec grids. */
@Composable
fun SpecCell(label: String, value: String) {
    Column(Modifier.padding(horizontal = 14.dp, vertical = 10.dp)) {
        Text(
            label.uppercase(Locale.getDefault()),
            style = SectionLabelStyle.copy(fontSize = 11.sp),
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
        Text(
            value,
            style = MonoStyle.copy(fontSize = 14.sp, lineHeight = 20.sp),
            color = MaterialTheme.colorScheme.onSurface,
            modifier = Modifier.padding(top = 2.dp),
        )
    }
}

/** Running / Off / In progress counts. */
@Composable
fun FleetStatusStrip(running: Int, off: Int, inProgress: Int, modifier: Modifier = Modifier) {
    val cells = listOf(
        Triple(R.string.fleet_running, running, MaterialTheme.colorScheme.onSurface),
        Triple(R.string.fleet_off, off, MaterialTheme.colorScheme.onSurface),
        Triple(
            R.string.fleet_in_progress,
            inProgress,
            if (inProgress > 0) MaterialTheme.falcoColors.progress else MaterialTheme.colorScheme.onSurface,
        ),
    )
    HairlineGrid(columns = 3, count = cells.size, modifier = modifier) { i ->
        val (label, value, color) = cells[i]
        Column(Modifier.padding(start = 12.dp, end = 12.dp, top = 12.dp, bottom = 10.dp)) {
            Text(
                stringResource(label).uppercase(Locale.getDefault()),
                style = SectionLabelStyle.copy(fontSize = 11.sp),
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                maxLines = 1,
            )
            Text(
                value.toString(),
                style = MonoStyle.copy(fontSize = 24.sp, lineHeight = 30.sp, fontWeight = FontWeight.Medium),
                color = color,
            )
        }
    }
}

/** Filter or tab pill: hairline outline, accent outline and text when selected. */
@Composable
fun PillChip(
    selected: Boolean,
    onClick: () -> Unit,
    label: String,
    modifier: Modifier = Modifier,
) {
    val accent = MaterialTheme.colorScheme.primary
    FilterChip(
        selected = selected,
        onClick = onClick,
        label = {
            Text(
                label,
                style = MaterialTheme.typography.bodyMedium.copy(
                    fontWeight = if (selected) FontWeight.SemiBold else FontWeight.Normal,
                ),
            )
        },
        modifier = modifier.height(36.dp),
        shape = PillShape,
        colors = FilterChipDefaults.filterChipColors(
            containerColor = Color.Transparent,
            labelColor = MaterialTheme.colorScheme.onSurface,
            selectedContainerColor = Color.Transparent,
            selectedLabelColor = accent,
        ),
        border = FilterChipDefaults.filterChipBorder(
            enabled = true,
            selected = selected,
            borderColor = MaterialTheme.falcoColors.hairline,
            selectedBorderColor = accent,
            selectedBorderWidth = 1.dp,
        ),
    )
}
