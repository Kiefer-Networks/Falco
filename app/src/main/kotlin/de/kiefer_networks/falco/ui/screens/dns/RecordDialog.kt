// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.dns

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuDefaults
import androidx.compose.material3.MenuAnchorType
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
import de.kiefer_networks.falco.data.dto.CreateDnsRecord
import de.kiefer_networks.falco.data.dto.DnsRecord

private val RECORD_TYPES = listOf("A", "AAAA", "CNAME", "MX", "TXT", "NS", "SRV", "CAA")

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RecordDialog(
    zoneId: String,
    existing: DnsRecord?,
    onDismiss: () -> Unit,
    onConfirm: (CreateDnsRecord) -> Unit,
) {
    var name by remember { mutableStateOf(existing?.name ?: "") }
    var type by remember { mutableStateOf(existing?.type ?: RECORD_TYPES.first()) }
    var value by remember { mutableStateOf(existing?.value ?: "") }
    var ttl by remember { mutableStateOf(existing?.ttl?.toString() ?: "3600") }
    var typeExpanded by remember { mutableStateOf(false) }

    val titleRes = if (existing == null) R.string.dns_record_create_title else R.string.dns_record_edit_title
    val isValid = name.isNotBlank() && value.isNotBlank() && (ttl.toIntOrNull() ?: -1) >= 0

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(titleRes)) },
        text = {
            Column(Modifier.fillMaxWidth()) {
                OutlinedTextField(
                    value = name,
                    onValueChange = { name = it },
                    label = { Text(stringResource(R.string.dns_record_name)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                Spacer(Modifier.height(8.dp))
                ExposedDropdownMenuBox(
                    expanded = typeExpanded,
                    onExpandedChange = { typeExpanded = it },
                ) {
                    OutlinedTextField(
                        value = type,
                        onValueChange = {},
                        readOnly = true,
                        label = { Text(stringResource(R.string.dns_record_type)) },
                        trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = typeExpanded) },
                        modifier = Modifier
                            .menuAnchor(MenuAnchorType.PrimaryNotEditable, true)
                            .fillMaxWidth(),
                    )
                    ExposedDropdownMenu(
                        expanded = typeExpanded,
                        onDismissRequest = { typeExpanded = false },
                    ) {
                        RECORD_TYPES.forEach { option ->
                            DropdownMenuItem(
                                text = { Text(option) },
                                onClick = {
                                    type = option
                                    typeExpanded = false
                                },
                            )
                        }
                    }
                }
                Spacer(Modifier.height(8.dp))
                OutlinedTextField(
                    value = value,
                    onValueChange = { value = it },
                    label = { Text(stringResource(R.string.dns_record_value)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                Spacer(Modifier.height(8.dp))
                OutlinedTextField(
                    value = ttl,
                    onValueChange = { input -> ttl = input.filter { it.isDigit() } },
                    label = { Text(stringResource(R.string.dns_record_ttl)) },
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.fillMaxWidth(),
                )
            }
        },
        confirmButton = {
            TextButton(
                enabled = isValid,
                onClick = {
                    onConfirm(
                        CreateDnsRecord(
                            zoneId = zoneId,
                            name = name.trim(),
                            type = type,
                            value = value.trim(),
                            ttl = ttl.toIntOrNull(),
                        ),
                    )
                },
            ) { Text(stringResource(R.string.save)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}
