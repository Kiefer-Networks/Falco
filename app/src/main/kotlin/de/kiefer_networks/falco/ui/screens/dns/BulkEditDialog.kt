// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.dns

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import de.kiefer_networks.falco.R

/**
 * Bulk apply-changes panel. Both fields are optional: leaving one empty keeps
 * the per-record original. Apply is disabled until at least one field is set,
 * which mirrors the API contract — sending unchanged records is a no-op that
 * still costs a request.
 */
@Composable
fun BulkEditDialog(
    selectedCount: Int,
    onDismiss: () -> Unit,
    onApply: (newValue: String?, newTtl: Int?) -> Unit,
) {
    var value by remember { mutableStateOf("") }
    var ttl by remember { mutableStateOf("") }

    val ttlValid = ttl.isBlank() || (ttl.toIntOrNull() ?: -1) >= 0
    val hasChange = value.isNotBlank() || ttl.isNotBlank()
    val canApply = ttlValid && hasChange

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.dns_bulk_apply_title, selectedCount)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                OutlinedTextField(
                    value = value,
                    onValueChange = { value = it },
                    label = { Text(stringResource(R.string.dns_bulk_value_optional)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = ttl,
                    onValueChange = { input -> ttl = input.filter { it.isDigit() } },
                    label = { Text(stringResource(R.string.dns_bulk_ttl_optional)) },
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.fillMaxWidth(),
                )
                if (!hasChange) {
                    Text(
                        stringResource(R.string.dns_bulk_no_changes),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
            }
        },
        confirmButton = {
            TextButton(
                enabled = canApply,
                onClick = {
                    onApply(
                        value.trim().ifBlank { null },
                        ttl.toIntOrNull(),
                    )
                },
            ) { Text(stringResource(R.string.dns_bulk_apply)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}
