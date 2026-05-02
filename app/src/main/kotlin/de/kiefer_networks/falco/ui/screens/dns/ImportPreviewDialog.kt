// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.dns

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.DnsValidateResponse

@Composable
fun ImportPreviewDialog(
    result: DnsValidateResponse,
    onConfirm: () -> Unit,
    onDismiss: () -> Unit,
) {
    val invalid = result.invalidRecords
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.dns_import_validate_title)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Text(
                    stringResource(
                        R.string.dns_import_validate_summary,
                        result.parsedRecords,
                        result.validRecords.size,
                        invalid.size,
                    ),
                    style = MaterialTheme.typography.bodyMedium,
                )
                if (invalid.isNotEmpty()) {
                    Text(
                        stringResource(R.string.dns_import_invalid_records),
                        style = MaterialTheme.typography.titleSmall,
                    )
                    LazyColumn(
                        modifier = Modifier
                            .fillMaxWidth()
                            // Keep the preview inside a single dialog without
                            // pushing the buttons offscreen on small phones.
                            .heightIn(max = 200.dp),
                        verticalArrangement = Arrangement.spacedBy(2.dp),
                    ) {
                        items(invalid) { rec ->
                            Text(
                                "${rec.name} ${rec.type} ${rec.value}".trim(),
                                style = MaterialTheme.typography.bodySmall,
                            )
                        }
                    }
                }
            }
        },
        confirmButton = {
            TextButton(onClick = onConfirm) {
                Text(stringResource(R.string.dns_import_confirm))
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}
