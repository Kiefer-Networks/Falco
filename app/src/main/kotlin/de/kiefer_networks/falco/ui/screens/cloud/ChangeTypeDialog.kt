// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Button
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudServerType

@Composable
fun ChangeTypeDialog(
    types: List<CloudServerType>,
    currentType: String?,
    onDismiss: () -> Unit,
    onConfirm: (typeName: String, upgradeDisk: Boolean) -> Unit,
) {
    var selected by remember { mutableStateOf<CloudServerType?>(null) }
    var upgradeDisk by remember { mutableStateOf(false) }
    Dialog(onDismissRequest = onDismiss, properties = DialogProperties(usePlatformDefaultWidth = false)) {
        Surface(modifier = Modifier.fillMaxSize().padding(16.dp), shape = MaterialTheme.shapes.large) {
            Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
                Text(
                    stringResource(R.string.server_change_type_title),
                    style = MaterialTheme.typography.titleLarge,
                    modifier = Modifier.padding(bottom = 8.dp),
                )
                Text(
                    stringResource(R.string.server_change_type_warning),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.error,
                    modifier = Modifier.padding(bottom = 8.dp),
                )
                LazyColumn(
                    modifier = Modifier.fillMaxWidth().fillMaxHeight(0.8f),
                    verticalArrangement = Arrangement.spacedBy(8.dp),
                ) {
                    items(types, key = { it.id }) { type ->
                        TypeRow(
                            type = type,
                            current = currentType == type.name,
                            selected = selected?.id == type.id,
                            onClick = { selected = type },
                        )
                    }
                }
                Row(modifier = Modifier.fillMaxWidth().padding(top = 8.dp), verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        stringResource(R.string.server_change_type_upgrade_disk),
                        modifier = Modifier.weight(1f),
                        style = MaterialTheme.typography.bodyMedium,
                    )
                    Switch(checked = upgradeDisk, onCheckedChange = { upgradeDisk = it })
                }
                Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.CenterEnd) {
                    Button(
                        enabled = selected != null,
                        onClick = {
                            selected?.let { onConfirm(it.name, upgradeDisk) }
                        },
                    ) { Text(stringResource(R.string.ok)) }
                }
            }
        }
    }
}

@Composable
private fun TypeRow(type: CloudServerType, current: Boolean, selected: Boolean, onClick: () -> Unit) {
    ElevatedCard(
        modifier = Modifier.fillMaxWidth().clickable(enabled = !current, onClick = onClick),
        colors = CardDefaults.elevatedCardColors(
            containerColor = when {
                current -> MaterialTheme.colorScheme.surfaceVariant
                selected -> MaterialTheme.colorScheme.primaryContainer
                else -> MaterialTheme.colorScheme.surface
            },
        ),
    ) {
        Column(modifier = Modifier.padding(12.dp)) {
            Text(type.name + if (current) " (current)" else "", style = MaterialTheme.typography.titleSmall)
            Text(
                "${type.cores} cores · ${type.memory} GB RAM · ${type.disk} GB disk · ${type.cpuType ?: ""} · ${type.architecture ?: ""}",
                style = MaterialTheme.typography.bodySmall,
            )
            if (!type.description.isBlank()) {
                Text(type.description, style = MaterialTheme.typography.labelSmall)
            }
        }
    }
}
