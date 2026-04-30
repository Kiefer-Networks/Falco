// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(
    androidx.compose.foundation.layout.ExperimentalLayoutApi::class,
    androidx.compose.material3.ExperimentalMaterial3Api::class,
)
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Album
import androidx.compose.material.icons.filled.Cloud
import androidx.compose.material.icons.filled.Computer
import androidx.compose.material.icons.filled.Key
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Memory
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.ui.components.wizard.PickCard
import de.kiefer_networks.falco.ui.components.wizard.WizardScaffold

@Composable
internal fun CreateServerSheet(
    viewModel: CloudViewModel,
    onDismiss: () -> Unit,
    onCreated: () -> Unit,
) {
    val opts by viewModel.createOptions.collectAsState()

    var step by remember { mutableStateOf(0) }
    var location by remember { mutableStateOf<String?>(null) }
    var serverType by remember { mutableStateOf<String?>(null) }
    var image by remember { mutableStateOf<String?>(null) }
    val sshSelected = remember { mutableStateOf<Set<Long>>(emptySet()) }
    var name by remember { mutableStateOf("") }
    var userData by remember { mutableStateOf("") }
    var startAfterCreate by remember { mutableStateOf(true) }

    val stepLabels = listOf(
        stringResource(R.string.wizard_step_location),
        stringResource(R.string.wizard_step_type),
        stringResource(R.string.wizard_step_image),
        stringResource(R.string.wizard_step_ssh),
        stringResource(R.string.wizard_step_details),
    )

    val canGoNext = when (step) {
        0 -> location != null
        1 -> serverType != null
        2 -> image != null
        3 -> true // SSH optional
        4 -> name.isNotBlank()
        else -> false
    }

    WizardScaffold(
        title = stringResource(R.string.cloud_server_create),
        steps = stepLabels,
        currentStep = step,
        canGoNext = canGoNext,
        isLastStep = step == stepLabels.lastIndex,
        isRunning = opts.running,
        onDismiss = onDismiss,
        onBack = { if (step > 0) step-- },
        onNext = { if (step < stepLabels.lastIndex) step++ },
        onFinish = {
            viewModel.createServer(
                name = name.trim(),
                serverType = serverType!!,
                image = image!!,
                location = location,
                sshKeyIds = sshSelected.value.toList(),
                userData = userData.trim().ifBlank { null },
                startAfterCreate = startAfterCreate,
                onDone = { ok -> if (ok) onCreated() },
            )
        },
        nextLabel = stringResource(R.string.wizard_next),
        finishLabel = stringResource(R.string.cloud_server_create_action),
        backLabel = stringResource(R.string.wizard_back),
        cancelLabel = stringResource(R.string.cancel),
    ) {
        if (opts.loading) {
            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
            return@WizardScaffold
        }
        when (step) {
            0 -> LazyColumn(
                modifier = Modifier.fillMaxSize().padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                items(opts.locations, key = { it.name }) { loc ->
                    PickCard(
                        title = loc.city ?: loc.name,
                        subtitle = listOfNotNull(loc.country, loc.name).joinToString(" · "),
                        icon = Icons.Filled.LocationOn,
                        selected = location == loc.name,
                        onClick = { location = loc.name },
                    )
                }
            }
            1 -> LazyColumn(
                modifier = Modifier.fillMaxSize().padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                items(opts.serverTypes.filter { !it.deprecated }, key = { it.id }) { st ->
                    PickCard(
                        title = st.name.uppercase(),
                        subtitle = "${st.cores} ${stringResource(R.string.cloud_create_cores)} · ${st.memory.toInt()} GB RAM · ${st.disk} GB",
                        icon = Icons.Filled.Memory,
                        badge = st.cpuType?.uppercase(),
                        selected = serverType == st.name,
                        onClick = { serverType = st.name },
                    )
                }
            }
            2 -> LazyColumn(
                modifier = Modifier.fillMaxSize().padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                items(opts.images.filter { it.type == "system" }, key = { it.id }) { img ->
                    val key = img.name ?: img.id.toString()
                    PickCard(
                        title = img.description ?: img.name ?: img.id.toString(),
                        subtitle = listOfNotNull(img.osFlavor, img.osVersion, img.architecture).joinToString(" · ").ifBlank { null },
                        icon = Icons.Filled.Album,
                        selected = image == key,
                        onClick = { image = key },
                    )
                }
            }
            3 -> {
                if (opts.sshKeys.isEmpty()) {
                    Box(modifier = Modifier.fillMaxSize().padding(24.dp), contentAlignment = Alignment.Center) {
                        Text(
                            stringResource(R.string.cloud_create_ssh_empty),
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                } else {
                    LazyColumn(
                        modifier = Modifier.fillMaxSize().padding(16.dp),
                        verticalArrangement = Arrangement.spacedBy(8.dp),
                    ) {
                        items(opts.sshKeys, key = { it.id }) { key ->
                            PickCard(
                                title = key.name,
                                subtitle = key.fingerprint ?: "",
                                icon = Icons.Filled.Key,
                                selected = key.id in sshSelected.value,
                                onClick = {
                                    sshSelected.value = if (key.id in sshSelected.value) {
                                        sshSelected.value - key.id
                                    } else {
                                        sshSelected.value + key.id
                                    }
                                },
                            )
                        }
                    }
                }
            }
            4 -> Column(
                modifier = Modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp),
            ) {
                OutlinedTextField(
                    value = name,
                    onValueChange = { name = it },
                    label = { Text(stringResource(R.string.cloud_server_create_name)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = userData,
                    onValueChange = { userData = it },
                    label = { Text(stringResource(R.string.cloud_server_create_user_data)) },
                    minLines = 3,
                    maxLines = 8,
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedCard(modifier = Modifier.fillMaxWidth()) {
                    Row(
                        modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 12.dp),
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                stringResource(R.string.cloud_server_create_start),
                                style = MaterialTheme.typography.bodyMedium,
                            )
                        }
                        Switch(checked = startAfterCreate, onCheckedChange = { startAfterCreate = it })
                    }
                }
                Spacer(Modifier.size(8.dp))
                SummaryCard(
                    location = location.orEmpty(),
                    serverType = serverType.orEmpty(),
                    image = image.orEmpty(),
                    sshCount = sshSelected.value.size,
                )
            }
        }
    }
}

@Composable
private fun SummaryCard(location: String, serverType: String, image: String, sshCount: Int) {
    OutlinedCard(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(6.dp)) {
            Text(
                stringResource(R.string.wizard_summary_title).uppercase(),
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
            SummaryRow(Icons.Filled.LocationOn, stringResource(R.string.wizard_step_location), location)
            SummaryRow(Icons.Filled.Memory, stringResource(R.string.wizard_step_type), serverType.uppercase())
            SummaryRow(Icons.Filled.Album, stringResource(R.string.wizard_step_image), image)
            SummaryRow(
                Icons.Filled.Key,
                stringResource(R.string.wizard_step_ssh),
                sshCount.toString(),
            )
        }
    }
}

@Composable
private fun SummaryRow(icon: androidx.compose.ui.graphics.vector.ImageVector, label: String, value: String) {
    Row(verticalAlignment = Alignment.CenterVertically) {
        androidx.compose.material3.Icon(
            icon,
            contentDescription = null,
            tint = MaterialTheme.colorScheme.primary,
            modifier = Modifier.size(18.dp),
        )
        Spacer(Modifier.size(8.dp))
        Text(
            label,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.weight(1f),
        )
        Text(value, style = MaterialTheme.typography.bodyMedium)
    }
}
