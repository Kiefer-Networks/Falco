// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
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
        Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.background) {
            Scaffold(
                topBar = {
                    CenterAlignedTopAppBar(
                        title = { Text(stringResource(R.string.server_change_type_title)) },
                        navigationIcon = {
                            IconButton(onClick = onDismiss) {
                                Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null)
                            }
                        },
                        actions = {
                            TextButton(
                                enabled = selected != null,
                                onClick = { selected?.let { onConfirm(it.name, upgradeDisk) } },
                            ) { Text(stringResource(R.string.save)) }
                        },
                    )
                },
            ) { padding ->
                Column(modifier = Modifier.fillMaxSize().padding(padding)) {
                    Text(
                        stringResource(R.string.server_change_type_warning),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.error,
                        modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp),
                    )
                    Row(
                        modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 4.dp),
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        Text(
                            stringResource(R.string.server_change_type_upgrade_disk),
                            modifier = Modifier.weight(1f),
                            style = MaterialTheme.typography.bodyMedium,
                        )
                        Switch(checked = upgradeDisk, onCheckedChange = { upgradeDisk = it })
                    }
                    LazyColumn(
                        modifier = Modifier.fillMaxSize().padding(horizontal = 16.dp, vertical = 8.dp),
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
            val title = if (current) {
                "${type.name} ${stringResource(R.string.server_type_current_suffix)}"
            } else {
                type.name
            }
            Text(title, style = MaterialTheme.typography.titleSmall)
            val baseSpecs = stringResource(
                R.string.server_type_specs,
                type.cores.toString(),
                type.memory.toString(),
                type.disk,
            )
            val extrasList = listOfNotNull(type.cpuType, type.architecture).filter(String::isNotBlank)
            val extras = if (extrasList.isEmpty()) "" else " · " + extrasList.joinToString(" · ")
            Text(baseSpecs + extras, style = MaterialTheme.typography.bodySmall)
            if (!type.description.isBlank()) {
                Text(type.description, style = MaterialTheme.typography.labelSmall)
            }
        }
    }
}
