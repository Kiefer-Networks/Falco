// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.s3

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Text
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import de.kiefer_networks.falco.R
import java.text.DateFormat
import java.util.Date

/**
 * Bottom sheet that shows the result of `S3Repo.stat`. Renders a loading
 * spinner while [stat] is null, then a fixed key/value list. ETag is
 * intentionally rendered last and clipped to a single line — it's a long
 * hex string that adds no value above the fold.
 */
@Composable
fun ObjectInfoSheet(
    objectKey: String,
    stat: ObjectStat?,
    error: String?,
    onDismiss: () -> Unit,
) {
    val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
    ModalBottomSheet(onDismissRequest = onDismiss, sheetState = sheetState) {
        Column(
            Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 8.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            Text(
                stringResource(R.string.s3_info_title),
                style = MaterialTheme.typography.titleMedium,
            )
            Text(
                objectKey,
                style = MaterialTheme.typography.bodySmall,
                maxLines = 2,
                overflow = TextOverflow.Ellipsis,
            )
            when {
                error != null -> Text(
                    stringResource(R.string.s3_info_failed) + ": " + error,
                    color = MaterialTheme.colorScheme.error,
                )
                stat == null -> Box(
                    Modifier.fillMaxWidth().padding(vertical = 24.dp),
                    contentAlignment = Alignment.Center,
                ) { CircularProgressIndicator() }
                else -> {
                    InfoRow(stringResource(R.string.s3_info_size), humanSize(stat.size))
                    InfoRow(
                        stringResource(R.string.s3_info_last_modified),
                        stat.lastModified?.let { formatStatDate(it) } ?: "—",
                    )
                    InfoRow(
                        stringResource(R.string.s3_info_content_type),
                        stat.contentType.orEmpty().ifEmpty { "—" },
                    )
                    InfoRow(
                        stringResource(R.string.s3_info_etag),
                        stat.etag.orEmpty().ifEmpty { "—" },
                    )
                }
            }
        }
    }
}

@Composable
private fun InfoRow(label: String, value: String) {
    Column(Modifier.fillMaxWidth()) {
        Text(label, style = MaterialTheme.typography.labelMedium, color = MaterialTheme.colorScheme.onSurfaceVariant)
        Text(
            value,
            style = MaterialTheme.typography.bodyMedium,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis,
        )
    }
}

private fun humanSize(bytes: Long): String {
    if (bytes < 1024) return "$bytes B"
    val kb = bytes / 1024.0
    if (kb < 1024) return String.format("%.1f KB", kb)
    val mb = kb / 1024.0
    if (mb < 1024) return String.format("%.1f MB", mb)
    val gb = mb / 1024.0
    return String.format("%.2f GB", gb)
}

private fun formatStatDate(raw: String): String = runCatching {
    val instant = java.time.OffsetDateTime.parse(raw).toInstant()
    DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.MEDIUM).format(Date.from(instant))
}.getOrDefault(raw)
