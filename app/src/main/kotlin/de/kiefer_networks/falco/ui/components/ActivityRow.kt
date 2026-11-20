// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import de.kiefer_networks.falco.R
import java.time.OffsetDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.time.format.FormatStyle
import java.util.Locale

/**
 * One Hetzner action ("activity") entry: command, status, local start and
 * finish time, and the error message of a failed action. [subtitle] carries
 * context such as the affected resource and project in the project view.
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
) {
    Column(
        modifier = modifier.fillMaxWidth().padding(vertical = 4.dp),
        verticalArrangement = Arrangement.spacedBy(2.dp),
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Surface(shape = CircleShape, color = activityStatusColor(status), modifier = Modifier.size(8.dp)) {}
            Spacer(Modifier.width(8.dp))
            Text(
                humanizeActionCommand(command),
                style = MaterialTheme.typography.bodyMedium,
                modifier = Modifier.weight(1f),
            )
            Text(status, style = MaterialTheme.typography.labelSmall, color = activityStatusColor(status))
        }
        if (!subtitle.isNullOrBlank()) {
            Text(subtitle, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
        }
        val times = listOfNotNull(
            formatActionTime(started)?.let { "${stringResource(R.string.cloud_server_activity_started)} $it" },
            formatActionTime(finished)?.let { "${stringResource(R.string.cloud_server_activity_finished)} $it" },
        )
        if (times.isNotEmpty()) {
            Text(
                times.joinToString("  •  "),
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
        if (!errorMessage.isNullOrBlank()) {
            Text(errorMessage, style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.error)
        }
    }
}

fun activityStatusColor(status: String): Color = when (status.lowercase(Locale.ROOT)) {
    "success" -> Color(0xFF2E7D32)
    "running" -> Color(0xFFEF6C00)
    "error" -> Color(0xFFC62828)
    else -> Color(0xFF9E9E9E)
}

/** `change_dns_ptr` -> `Change dns ptr`. */
fun humanizeActionCommand(command: String): String =
    command.replace('_', ' ').replaceFirstChar { it.titlecase(Locale.getDefault()) }

private val actionTimeFormat: DateTimeFormatter = DateTimeFormatter.ofLocalizedDateTime(FormatStyle.SHORT)

/** ISO 8601 timestamp from the API in the device's zone and locale; raw text if unparsable. */
fun formatActionTime(iso: String?): String? {
    if (iso.isNullOrBlank()) return null
    return runCatching {
        OffsetDateTime.parse(iso).atZoneSameInstant(ZoneId.systemDefault()).format(actionTimeFormat)
    }.getOrDefault(iso)
}
