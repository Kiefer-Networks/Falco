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
import de.kiefer_networks.falco.data.dto.DnsPrimaryServer

@Composable
fun PrimaryServerDialog(
    existing: DnsPrimaryServer?,
    onDismiss: () -> Unit,
    onConfirm: (address: String, port: Int) -> Unit,
) {
    var address by remember { mutableStateOf(existing?.address ?: "") }
    var port by remember { mutableStateOf(existing?.port?.toString() ?: "53") }

    val titleRes = if (existing == null) {
        R.string.dns_primary_server_add
    } else {
        R.string.dns_primary_server_edit
    }
    // Hetzner DNS API rejects ports outside 1..65535; mirror that locally so we
    // do not waste a request on something the server is guaranteed to reject.
    val parsedPort = port.toIntOrNull()
    val portValid = parsedPort != null && parsedPort in 1..65535
    val canSave = address.isNotBlank() && portValid

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(titleRes)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                OutlinedTextField(
                    value = address,
                    onValueChange = { address = it },
                    label = { Text(stringResource(R.string.dns_primary_server_address)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = port,
                    onValueChange = { input -> port = input.filter { it.isDigit() } },
                    label = { Text(stringResource(R.string.dns_primary_server_port)) },
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.fillMaxWidth(),
                )
            }
        },
        confirmButton = {
            TextButton(
                enabled = canSave,
                onClick = { onConfirm(address.trim(), parsedPort ?: 53) },
            ) { Text(stringResource(R.string.save)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}
