// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.dns

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.AlertDialog
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
import de.kiefer_networks.falco.data.dto.DnsZone

/**
 * Compact create/edit dialog for a DNS zone.
 *
 * `existing == null` → create mode (title "New zone").
 * `existing != null` → edit mode (title "Edit zone", fields prefilled).
 *
 * Confirm callback receives a trimmed `name` and a parsed `ttl` (or `null` when
 * the field is blank — the API accepts an absent TTL and falls back to the
 * Hetzner default).
 */
@Composable
fun ZoneFormDialog(
    existing: DnsZone?,
    onDismiss: () -> Unit,
    onConfirm: (name: String, ttl: Int?) -> Unit,
) {
    var name by remember { mutableStateOf(existing?.name ?: "") }
    var ttl by remember { mutableStateOf(existing?.ttl?.toString() ?: "") }

    val titleRes = if (existing == null) R.string.dns_zone_create_title else R.string.dns_zone_edit_title
    // Allow empty TTL → null. When set, must be a non-negative integer.
    val ttlValid = ttl.isBlank() || (ttl.toIntOrNull() ?: -1) >= 0
    val canSave = name.isNotBlank() && ttlValid

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(titleRes)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                OutlinedTextField(
                    value = name,
                    onValueChange = { name = it },
                    label = { Text(stringResource(R.string.dns_zone_name)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = ttl,
                    onValueChange = { input -> ttl = input.filter { it.isDigit() } },
                    label = { Text(stringResource(R.string.dns_zone_default_ttl)) },
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.fillMaxWidth(),
                )
            }
        },
        confirmButton = {
            TextButton(
                enabled = canSave,
                onClick = { onConfirm(name.trim(), ttl.toIntOrNull()) },
            ) { Text(stringResource(R.string.save)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}
