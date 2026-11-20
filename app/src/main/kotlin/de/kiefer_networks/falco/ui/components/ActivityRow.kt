// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.ui.theme.MonoStyle
import java.time.LocalDate
import java.time.OffsetDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.time.format.FormatStyle
import java.util.Locale

/**
 * One Hetzner action ("activity") entry: local start time in a mono column,
 * status mark and word, command, [subtitle] (affected resource and project)
 * in mono, and the error message of a failed action.
 *
 * [timeOnly] is for lists grouped by day: the time column then carries all
 * the time information. Otherwise the full start and finish times follow.
 */
@Composable
fun ActivityRow(
    command: String,
    status: String,
    started: String?,
    finished: String?,
    modifier: Modifier = Modifier,
    subtitle: String? = null,
    errorMessage: String? = null,
    timeOnly: Boolean = false,
) {
    val tone = actionStatusTone(status)
    Row(modifier = modifier.fillMaxWidth().padding(vertical = 10.dp)) {
        Text(
            formatActionClock(started).orEmpty(),
            style = MonoStyle,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.width(52.dp).padding(top = 2.dp),
        )
        StatusDot(tone, size = 10.dp, modifier = Modifier.padding(top = 5.dp))
        Column(
            modifier = Modifier.weight(1f).padding(start = 10.dp),
            verticalArrangement = Arrangement.spacedBy(2.dp),
        ) {
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Text(
                    humanizeActionCommand(command),
                    style = MaterialTheme.typography.bodyLarge.copy(fontSize = 15.sp, fontWeight = FontWeight.Medium),
                    modifier = Modifier.weight(1f, fill = false),
                )
                Text(
                    actionStatusLabel(status),
                    style = MaterialTheme.typography.bodySmall,
                    color = tone.color(),
                )
            }
            if (!subtitle.isNullOrBlank()) {
                Text(
                    subtitle,
                    style = MonoStyle,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
            }
            if (!timeOnly) {
                val times = listOfNotNull(
                    formatActionTime(started)?.let { "${stringResource(R.string.cloud_server_activity_started)} $it" },
                    formatActionTime(finished)?.let { "${stringResource(R.string.cloud_server_activity_finished)} $it" },
                )
                if (times.isNotEmpty()) {
                    Text(
                        times.joinToString("  ·  "),
                        style = MonoStyle.copy(fontSize = 11.sp),
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
            }
            if (!errorMessage.isNullOrBlank()) {
                Text(
                    errorMessage,
                    style = MaterialTheme.typography.bodyMedium.copy(fontSize = 13.sp),
                    color = MaterialTheme.colorScheme.error,
                    modifier = Modifier.padding(top = 2.dp),
                )
            }
        }
    }
}

@Composable
fun actionStatusLabel(status: String): String = when (status.lowercase(Locale.ROOT)) {
    "success" -> stringResource(R.string.activity_status_done)
    "running" -> stringResource(R.string.activity_status_running)
    "error" -> stringResource(R.string.activity_status_failed)
    else -> status
}

/** `change_dns_ptr` -> `Change dns ptr`. */
fun humanizeActionCommand(command: String): String =
    command.replace('_', ' ').replaceFirstChar { it.titlecase(Locale.getDefault()) }

private val actionTimeFormat: DateTimeFormatter = DateTimeFormatter.ofLocalizedDateTime(FormatStyle.SHORT)
private val actionClockFormat: DateTimeFormatter = DateTimeFormatter.ofPattern("HH:mm")

private fun parseLocal(iso: String?) = iso?.takeIf { it.isNotBlank() }?.let {
    runCatching { OffsetDateTime.parse(it).atZoneSameInstant(ZoneId.systemDefault()) }.getOrNull()
}

/** ISO 8601 timestamp from the API in the device's zone and locale; raw text if unparsable. */
fun formatActionTime(iso: String?): String? {
    if (iso.isNullOrBlank()) return null
    return parseLocal(iso)?.format(actionTimeFormat) ?: iso
}

/** Local `HH:mm` of an ISO 8601 timestamp, null if absent or unparsable. */
fun formatActionClock(iso: String?): String? = parseLocal(iso)?.format(actionClockFormat)

/** Local calendar day of an ISO 8601 timestamp, null if absent or unparsable. */
fun actionLocalDate(iso: String?): LocalDate? = parseLocal(iso)?.toLocalDate()
