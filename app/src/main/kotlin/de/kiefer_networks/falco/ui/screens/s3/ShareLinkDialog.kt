// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.s3

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ContentCopy
import androidx.compose.material.icons.filled.Share
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import de.kiefer_networks.falco.R

private data class TtlOption(val hours: Int, val labelRes: Int)

private val TTL_OPTIONS = listOf(
    TtlOption(1, R.string.s3_ttl_1h),
    TtlOption(24, R.string.s3_ttl_24h),
    TtlOption(24 * 7, R.string.s3_ttl_7d),
    TtlOption(24 * 30, R.string.s3_ttl_30d),
)

/**
 * Two-stage dialog. First the user picks a TTL and confirms; then we display
 * the generated URL with copy / share actions. The caller drives the URL
 * lifecycle by passing [generatedUrl] (null = picker stage, non-null = result).
 */
@Composable
fun ShareLinkDialog(
    objectKey: String,
    generatedUrl: String?,
    onConfirmTtl: (hours: Int) -> Unit,
    onDismiss: () -> Unit,
) {
    if (generatedUrl == null) {
        TtlPickerDialog(objectKey = objectKey, onConfirm = onConfirmTtl, onDismiss = onDismiss)
    } else {
        ResultDialog(url = generatedUrl, onDismiss = onDismiss)
    }
}

@Composable
private fun TtlPickerDialog(
    objectKey: String,
    onConfirm: (Int) -> Unit,
    onDismiss: () -> Unit,
) {
    var selectedHours by rememberSaveable { mutableStateOf(24) }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.s3_share_link)) },
        text = {
            Column {
                Text(
                    text = objectKey,
                    style = MaterialTheme.typography.bodySmall,
                    modifier = Modifier.padding(bottom = 8.dp),
                )
                TTL_OPTIONS.forEach { opt ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable { selectedHours = opt.hours }
                            .padding(vertical = 4.dp),
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        RadioButton(
                            selected = selectedHours == opt.hours,
                            onClick = { selectedHours = opt.hours },
                        )
                        Text(
                            text = stringResource(opt.labelRes),
                            modifier = Modifier.padding(start = 8.dp),
                        )
                    }
                }
            }
        },
        confirmButton = {
            TextButton(onClick = { onConfirm(selectedHours) }) {
                Text(stringResource(R.string.ok))
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}

@Composable
private fun ResultDialog(url: String, onDismiss: () -> Unit) {
    val context = LocalContext.current
    val clipboard = remember(context) {
        context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
    }
    val clipLabel = stringResource(R.string.s3_share_link_clip_label)

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.s3_share_link)) },
        text = {
            Column {
                Text(
                    text = url,
                    style = MaterialTheme.typography.bodySmall,
                    modifier = Modifier.padding(bottom = 12.dp),
                )
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                ) {
                    OutlinedButton(
                        onClick = {
                            val clip = ClipData.newPlainText(clipLabel, url)
                            clipboard.setPrimaryClip(clip)
                        },
                        modifier = Modifier.fillMaxWidth().weight(1f),
                    ) {
                        Icon(Icons.Filled.ContentCopy, contentDescription = null)
                        Text(
                            stringResource(R.string.copy),
                            modifier = Modifier.padding(start = 6.dp),
                        )
                    }
                    OutlinedButton(
                        onClick = {
                            val intent = Intent(Intent.ACTION_SEND).apply {
                                type = "text/plain"
                                putExtra(Intent.EXTRA_TEXT, url)
                                putExtra("android.intent.extra.IS_SENSITIVE", true)
                            }
                            context.startActivity(Intent.createChooser(intent, null))
                        },
                        modifier = Modifier.fillMaxWidth().weight(1f),
                    ) {
                        Icon(Icons.Filled.Share, contentDescription = null)
                        Text(
                            stringResource(R.string.share),
                            modifier = Modifier.padding(start = 6.dp),
                        )
                    }
                }
            }
        },
        confirmButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.close)) }
        },
    )
}
