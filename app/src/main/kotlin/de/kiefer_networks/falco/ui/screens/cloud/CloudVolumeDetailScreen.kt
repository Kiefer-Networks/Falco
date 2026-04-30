// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Link
import androidx.compose.material.icons.filled.LinkOff
import androidx.compose.material.icons.filled.Memory
import androidx.compose.material.icons.filled.AspectRatio
import androidx.compose.material.icons.filled.Shield
import androidx.compose.material.icons.filled.Storage
import androidx.compose.material.icons.filled.Tag
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudVolume
import de.kiefer_networks.falco.ui.components.ErrorState
import de.kiefer_networks.falco.ui.components.LoadingState
import de.kiefer_networks.falco.ui.components.detail.HeroCard
import de.kiefer_networks.falco.ui.components.detail.HeroStatus
import de.kiefer_networks.falco.ui.components.detail.Kpi
import de.kiefer_networks.falco.ui.components.detail.KpiStrip
import de.kiefer_networks.falco.ui.components.dialog.ActionsBottomSheetSections
import de.kiefer_networks.falco.ui.components.dialog.SheetAction
import de.kiefer_networks.falco.ui.components.dialog.SheetSection
import de.kiefer_networks.falco.ui.theme.Spacing
import androidx.compose.ui.graphics.Color
import kotlinx.coroutines.launch

@Composable
fun CloudVolumeDetailScreen(
    onBack: () -> Unit,
    viewModel: CloudVolumeDetailViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsState()
    val snackbar = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    LaunchedEffect(Unit) {
        viewModel.events.collect { ev ->
            val text = when (ev) {
                is CloudVolumeEvent.Toast -> ev.text
                is CloudVolumeEvent.Failure -> ev.message
            }
            scope.launch { snackbar.showSnackbar(text) }
        }
    }

    LaunchedEffect(state.deleted) { if (state.deleted) onBack() }

    var sheetOpen by remember { mutableStateOf(false) }
    var renameOpen by remember { mutableStateOf(false) }
    var resizeOpen by remember { mutableStateOf(false) }
    var attachOpen by remember { mutableStateOf(false) }
    var deleteOpen by remember { mutableStateOf(false) }
    var protectOpen by remember { mutableStateOf(false) }

    Scaffold(
        topBar = {
            Column {
                CenterAlignedTopAppBar(
                    title = {
                        Text(
                            text = state.volume?.name ?: stringResource(R.string.cloud_volumes),
                            style = MaterialTheme.typography.titleMedium,
                        )
                    },
                    navigationIcon = {
                        IconButton(onClick = onBack) {
                            Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null)
                        }
                    },
                    actions = {
                        FilledTonalButton(
                            onClick = { sheetOpen = true },
                            modifier = Modifier.padding(end = 8.dp),
                        ) {
                            Text(stringResource(R.string.actions_sheet_title))
                        }
                    },
                )
                if (state.running) {
                    LinearProgressIndicator(modifier = Modifier.fillMaxWidth())
                }
            }
        },
        snackbarHost = { SnackbarHost(snackbar) },
    ) { padding ->
        when {
            state.loading -> Box(modifier = Modifier.padding(padding)) { LoadingState() }
            state.error != null -> Box(modifier = Modifier.padding(padding)) {
                ErrorState(message = state.error!!, onRetry = viewModel::refresh)
            }
            else -> {
                val v = state.volume ?: return@Scaffold
                LazyColumn(
                    modifier = Modifier.fillMaxSize().padding(padding).padding(horizontal = Spacing.md, vertical = Spacing.sm),
                    verticalArrangement = Arrangement.spacedBy(Spacing.md),
                ) {
                    item {
                        HeroCard(
                            title = v.name,
                            status = statusFor(v),
                            subtitle = v.location?.city ?: v.location?.name,
                        )
                    }
                    item { KpiStrip(items = kpis(v)) }
                    item { SectionHeader(stringResource(R.string.cloud_volume_section_attachment)) }
                    item {
                        if (v.server != null) {
                            DetailLine(stringResource(R.string.cloud_attached_server, v.server), v.linuxDevice ?: "-")
                        } else {
                            Text(
                                stringResource(R.string.cloud_volume_unattached),
                                style = MaterialTheme.typography.bodyMedium,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                        }
                    }
                    item { SectionHeader(stringResource(R.string.cloud_volume_section_protection)) }
                    item {
                        Row(
                            modifier = Modifier.fillMaxWidth().padding(vertical = Spacing.xs),
                            verticalAlignment = Alignment.CenterVertically,
                        ) {
                            Text(
                                stringResource(R.string.cloud_volume_delete_protection),
                                modifier = Modifier.weight(1f),
                                style = MaterialTheme.typography.bodyMedium,
                            )
                            Switch(
                                checked = v.protection?.delete == true,
                                onCheckedChange = { protectOpen = false; viewModel.setProtection(it) },
                            )
                        }
                    }
                }
            }
        }
    }

    if (sheetOpen) {
        val v = state.volume
        val sections = if (v == null) emptyList() else listOf(
            SheetSection(
                title = stringResource(R.string.cloud_volume_section_attachment),
                actions = listOf(
                    if (v.server == null) {
                        SheetAction(Icons.Filled.Link, stringResource(R.string.cloud_volume_action_attach)) {
                            sheetOpen = false; viewModel.loadServers(); attachOpen = true
                        }
                    } else {
                        SheetAction(Icons.Filled.LinkOff, stringResource(R.string.cloud_volume_action_detach)) {
                            sheetOpen = false; viewModel.detach()
                        }
                    },
                ),
            ),
            SheetSection(
                title = stringResource(R.string.server_section_state),
                actions = listOf(
                    SheetAction(Icons.Filled.AspectRatio, stringResource(R.string.cloud_volume_action_resize)) {
                        sheetOpen = false; resizeOpen = true
                    },
                ),
            ),
            SheetSection(
                title = stringResource(R.string.server_detail_section_settings),
                actions = listOf(
                    SheetAction(Icons.Filled.Edit, stringResource(R.string.cloud_volume_action_rename)) {
                        sheetOpen = false; renameOpen = true
                    },
                    SheetAction(Icons.Filled.Shield, stringResource(R.string.server_action_protection)) {
                        sheetOpen = false
                        viewModel.setProtection(!(v.protection?.delete ?: false))
                    },
                ),
            ),
            SheetSection(
                title = stringResource(R.string.server_section_danger),
                actions = listOf(
                    SheetAction(
                        icon = Icons.Filled.Delete,
                        label = stringResource(R.string.delete),
                        destructive = true,
                    ) { sheetOpen = false; deleteOpen = true },
                ),
            ),
        )
        ActionsBottomSheetSections(
            title = stringResource(R.string.actions_sheet_title),
            sections = sections,
            onDismiss = { sheetOpen = false },
        )
    }

    if (renameOpen) {
        TextPrompt(
            title = stringResource(R.string.cloud_volume_action_rename),
            initial = state.volume?.name.orEmpty(),
            onDismiss = { renameOpen = false },
            onConfirm = { newName ->
                viewModel.rename(newName.trim())
                renameOpen = false
            },
        )
    }

    if (resizeOpen) {
        ResizeDialog(
            currentSize = state.volume?.size ?: 0,
            onDismiss = { resizeOpen = false },
            onConfirm = { size ->
                viewModel.resize(size)
                resizeOpen = false
            },
        )
    }

    if (attachOpen) {
        AttachVolumeDialog(
            servers = state.servers,
            onDismiss = { attachOpen = false },
            onConfirm = { serverId, automount ->
                viewModel.attach(serverId, automount)
                attachOpen = false
            },
        )
    }

    if (deleteOpen) {
        AlertDialog(
            onDismissRequest = { deleteOpen = false },
            title = { Text(stringResource(R.string.cloud_volume_delete_title)) },
            text = { Text(stringResource(R.string.cloud_volume_delete_warning, state.volume?.name.orEmpty())) },
            confirmButton = {
                TextButton(onClick = {
                    deleteOpen = false
                    viewModel.delete()
                }) {
                    Text(stringResource(R.string.delete), color = MaterialTheme.colorScheme.error)
                }
            },
            dismissButton = {
                TextButton(onClick = { deleteOpen = false }) { Text(stringResource(R.string.cancel)) }
            },
        )
    }
}

@Composable
private fun statusFor(v: CloudVolume): HeroStatus {
    val c = when (v.status) {
        "available" -> Color(0xFF2E7D32)
        "creating" -> MaterialTheme.colorScheme.tertiary
        else -> MaterialTheme.colorScheme.onSurfaceVariant
    }
    return HeroStatus(label = v.status, color = c)
}

@Composable
private fun kpis(v: CloudVolume): List<Kpi> = buildList {
    add(Kpi(Icons.Filled.Storage, stringResource(R.string.cloud_volume_size_label), "${v.size} GB"))
    v.format?.takeIf { it.isNotBlank() }?.let {
        add(Kpi(Icons.Filled.Memory, stringResource(R.string.cloud_volume_format), it))
    }
    add(Kpi(Icons.Filled.Tag, "ID", v.id.toString()))
}

@Composable
private fun SectionHeader(text: String) {
    Text(
        text,
        style = MaterialTheme.typography.titleMedium,
        color = MaterialTheme.colorScheme.primary,
        modifier = Modifier.padding(top = Spacing.sm, bottom = Spacing.xs),
    )
}

@Composable
private fun DetailLine(label: String, value: String) {
    Column(modifier = Modifier.fillMaxWidth().padding(vertical = Spacing.xs)) {
        Text(label, style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
        Text(value, style = MaterialTheme.typography.bodyMedium)
    }
    HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant)
}

@Composable
private fun TextPrompt(
    title: String,
    initial: String,
    onDismiss: () -> Unit,
    onConfirm: (String) -> Unit,
) {
    var text by remember { mutableStateOf(initial) }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(title) },
        text = {
            OutlinedTextField(
                value = text,
                onValueChange = { text = it },
                singleLine = true,
                modifier = Modifier.fillMaxWidth(),
            )
        },
        confirmButton = {
            TextButton(enabled = text.isNotBlank(), onClick = { onConfirm(text) }) {
                Text(stringResource(R.string.save))
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}

@Composable
private fun ResizeDialog(
    currentSize: Int,
    onDismiss: () -> Unit,
    onConfirm: (Int) -> Unit,
) {
    var input by remember { mutableStateOf(currentSize.toString()) }
    val newSize = input.toIntOrNull() ?: 0
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.cloud_volume_action_resize)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(Spacing.sm)) {
                Text(
                    stringResource(R.string.cloud_volume_resize_hint),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                OutlinedTextField(
                    value = input,
                    onValueChange = { input = it.filter { ch -> ch.isDigit() } },
                    label = { Text(stringResource(R.string.cloud_volume_size_label)) },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
            }
        },
        confirmButton = {
            TextButton(
                enabled = newSize > currentSize,
                onClick = { onConfirm(newSize) },
            ) { Text(stringResource(R.string.save)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}
