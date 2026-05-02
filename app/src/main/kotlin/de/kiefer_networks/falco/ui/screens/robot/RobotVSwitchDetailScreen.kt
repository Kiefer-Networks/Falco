// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.robot

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Surface
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
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.unit.dp
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import androidx.compose.foundation.selection.selectable
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.RobotServer
import de.kiefer_networks.falco.data.dto.RobotVSwitch
import de.kiefer_networks.falco.data.dto.RobotVSwitchServer
import de.kiefer_networks.falco.ui.components.ErrorState
import de.kiefer_networks.falco.ui.components.LoadingState
import de.kiefer_networks.falco.ui.components.dialog.TypeToConfirmDeleteDialog
import de.kiefer_networks.falco.ui.theme.Spacing
import kotlinx.coroutines.launch

@Composable
fun RobotVSwitchDetailScreen(
    onBack: () -> Unit,
    viewModel: RobotVSwitchDetailViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsState()
    val snackbar = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    LaunchedEffect(Unit) {
        viewModel.events.collect { event ->
            val text = when (event) {
                is RobotVSwitchEvent.Toast -> event.text
                is RobotVSwitchEvent.Failure -> event.message
            }
            scope.launch { snackbar.showSnackbar(text) }
        }
    }

    LaunchedEffect(state.deleted) {
        if (state.deleted) onBack()
    }

    var editOpen by remember { mutableStateOf(false) }
    var deleteOpen by remember { mutableStateOf(false) }
    var attachOpen by remember { mutableStateOf(false) }
    var pendingDetach by remember { mutableStateOf<Long?>(null) }

    Scaffold(
        topBar = {
            Column {
                CenterAlignedTopAppBar(
                    title = {
                        Text(
                            text = state.vswitch?.name ?: stringResource(R.string.robot_vswitch),
                            style = MaterialTheme.typography.titleMedium,
                            maxLines = 1,
                        )
                    },
                    navigationIcon = {
                        IconButton(onClick = onBack) {
                            Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null)
                        }
                    },
                    actions = {
                        IconButton(onClick = viewModel::refresh) {
                            Icon(Icons.Filled.Refresh, contentDescription = null)
                        }
                        IconButton(onClick = { editOpen = true }) {
                            Icon(
                                Icons.Filled.Edit,
                                contentDescription = stringResource(R.string.robot_vswitch_rename_action),
                            )
                        }
                        IconButton(onClick = { deleteOpen = true }) {
                            Icon(
                                Icons.Filled.Delete,
                                contentDescription = stringResource(R.string.delete),
                                tint = MaterialTheme.colorScheme.error,
                            )
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
                val vs = state.vswitch ?: return@Scaffold
                LazyColumn(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(padding)
                        .padding(horizontal = Spacing.md, vertical = Spacing.sm),
                    verticalArrangement = Arrangement.spacedBy(Spacing.md),
                ) {
                    item { OverviewCard(vs) }

                    item {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            SectionHeader(stringResource(R.string.robot_vswitch_section_servers))
                            Spacer(Modifier.weight(1f))
                            FilledTonalButton(
                                onClick = {
                                    viewModel.loadServers()
                                    attachOpen = true
                                },
                                enabled = !state.running,
                            ) {
                                Icon(Icons.Filled.Add, contentDescription = null, modifier = Modifier.size(16.dp))
                                Spacer(Modifier.size(Spacing.xs))
                                Text(stringResource(R.string.robot_vswitch_add_server))
                            }
                        }
                    }

                    if (vs.server.isEmpty()) {
                        item { EmptyHint(stringResource(R.string.robot_vswitch_no_servers)) }
                    } else {
                        items(vs.server, key = { it.serverNumber ?: it.serverIp.hashCode().toLong() }) { srv ->
                            ServerRow(
                                server = srv,
                                onDetach = {
                                    srv.serverNumber?.let { pendingDetach = it }
                                },
                            )
                        }
                    }
                }
            }
        }
    }

    if (editOpen) {
        EditVSwitchDialog(
            initialName = state.vswitch?.name.orEmpty(),
            initialVlan = state.vswitch?.vlan?.toString().orEmpty(),
            onDismiss = { editOpen = false },
            onConfirm = { name, vlan ->
                viewModel.update(name, vlan)
                editOpen = false
            },
        )
    }

    if (deleteOpen) {
        DeleteVSwitchDialog(
            confirmName = state.vswitch?.name.orEmpty(),
            onDismiss = { deleteOpen = false },
            onConfirm = { date ->
                viewModel.delete(date)
                deleteOpen = false
            },
        )
    }

    pendingDetach?.let { serverNumber ->
        AlertDialog(
            onDismissRequest = { pendingDetach = null },
            title = { Text(stringResource(R.string.robot_vswitch_detach_title)) },
            text = { Text(stringResource(R.string.robot_vswitch_detach_warning)) },
            confirmButton = {
                TextButton(onClick = {
                    viewModel.detachServer(serverNumber)
                    pendingDetach = null
                }) {
                    Text(
                        stringResource(R.string.robot_vswitch_detach_action),
                        color = MaterialTheme.colorScheme.error,
                    )
                }
            },
            dismissButton = {
                TextButton(onClick = { pendingDetach = null }) {
                    Text(stringResource(R.string.cancel))
                }
            },
        )
    }

    if (attachOpen) {
        val attachedNumbers = state.vswitch?.server
            ?.mapNotNull { it.serverNumber }
            ?.toSet()
            .orEmpty()
        AttachServerDialog(
            servers = state.servers,
            excludedNumbers = attachedNumbers,
            onDismiss = { attachOpen = false },
            onConfirm = { number ->
                viewModel.attachServer(number)
                attachOpen = false
            },
        )
    }
}

@Composable
private fun OverviewCard(vs: RobotVSwitch) {
    OutlinedCard(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(Spacing.md), verticalArrangement = Arrangement.spacedBy(Spacing.xs)) {
            Text(
                vs.name,
                style = MaterialTheme.typography.headlineSmall,
            )
            DetailLine(stringResource(R.string.robot_vswitch_field_id), "#${vs.id}")
            DetailLine(stringResource(R.string.robot_vswitch_field_vlan), vs.vlan.toString())
            DetailLine(
                stringResource(R.string.robot_vswitch_field_status),
                if (vs.cancelled) {
                    stringResource(R.string.robot_vswitch_cancelled)
                } else {
                    stringResource(R.string.robot_vswitch_field_active)
                },
                tint = if (vs.cancelled) MaterialTheme.colorScheme.error else null,
            )
        }
    }
}

@Composable
private fun DetailLine(
    label: String,
    value: String,
    tint: androidx.compose.ui.graphics.Color? = null,
) {
    Column(modifier = Modifier.fillMaxWidth().padding(vertical = Spacing.xs)) {
        Text(
            label,
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
        Text(
            value,
            style = MaterialTheme.typography.bodyMedium,
            color = tint ?: MaterialTheme.colorScheme.onSurface,
        )
    }
    HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant)
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
private fun EmptyHint(text: String) {
    Text(
        text,
        style = MaterialTheme.typography.bodyMedium,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        modifier = Modifier.padding(Spacing.sm),
    )
}

@Composable
private fun ServerRow(
    server: RobotVSwitchServer,
    onDetach: () -> Unit,
) {
    OutlinedCard(modifier = Modifier.fillMaxWidth()) {
        Row(modifier = Modifier.padding(Spacing.md), verticalAlignment = Alignment.CenterVertically) {
            Column(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(2.dp)) {
                Text(
                    text = server.serverIp ?: server.serverNumber?.let {
                        stringResource(R.string.robot_vswitch_server_number_format, it)
                    } ?: "-",
                    style = MaterialTheme.typography.bodyMedium,
                )
                val number = server.serverNumber
                val status = server.status
                val meta = when {
                    number != null && !status.isNullOrBlank() ->
                        stringResource(R.string.robot_vswitch_server_status_format, number, status)
                    number != null -> stringResource(R.string.robot_vswitch_server_number_format, number)
                    !status.isNullOrBlank() -> status
                    else -> null
                }
                meta?.let {
                    Text(
                        it,
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
            }
            if (server.serverNumber != null) {
                IconButton(onClick = onDetach) {
                    Icon(
                        Icons.Filled.Delete,
                        contentDescription = stringResource(R.string.robot_vswitch_detach_action),
                        tint = MaterialTheme.colorScheme.error,
                    )
                }
            }
        }
    }
}

@Composable
private fun EditVSwitchDialog(
    initialName: String,
    initialVlan: String,
    onDismiss: () -> Unit,
    onConfirm: (name: String, vlan: Int) -> Unit,
) {
    var name by remember { mutableStateOf(initialName) }
    var vlan by remember { mutableStateOf(initialVlan) }
    val vlanInt = vlan.toIntOrNull()
    val vlanValid = vlanInt != null && vlanInt in 4000..4091
    val canSubmit = name.isNotBlank() && vlanValid

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.robot_vswitch_edit)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(Spacing.sm)) {
                OutlinedTextField(
                    value = name,
                    onValueChange = { name = it },
                    label = { Text(stringResource(R.string.robot_vswitch_name)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = vlan,
                    onValueChange = { v -> vlan = v.filter { it.isDigit() }.take(4) },
                    label = { Text(stringResource(R.string.robot_vswitch_vlan)) },
                    singleLine = true,
                    isError = vlan.isNotBlank() && !vlanValid,
                    keyboardOptions = KeyboardOptions(
                        keyboardType = KeyboardType.Number,
                        imeAction = ImeAction.Done,
                    ),
                    supportingText = {
                        Text(
                            if (vlan.isNotBlank() && !vlanValid) {
                                stringResource(R.string.robot_vswitch_invalid_vlan)
                            } else {
                                stringResource(R.string.robot_vswitch_vlan_hint)
                            },
                            color = if (vlan.isNotBlank() && !vlanValid) {
                                MaterialTheme.colorScheme.error
                            } else {
                                MaterialTheme.colorScheme.onSurfaceVariant
                            },
                        )
                    },
                    modifier = Modifier.fillMaxWidth(),
                )
            }
        },
        confirmButton = {
            Button(
                enabled = canSubmit,
                onClick = { onConfirm(name.trim(), vlanInt!!) },
            ) { Text(stringResource(R.string.save)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}

/**
 * Two-step delete dialog: first the user (optionally) provides a
 * cancellation date, then they must type the vSwitch name verbatim in the
 * reusable [TypeToConfirmDeleteDialog]. We keep the date in parent state so
 * the second step can forward it to the ViewModel on confirm.
 */
@Composable
private fun DeleteVSwitchDialog(
    confirmName: String,
    onDismiss: () -> Unit,
    onConfirm: (cancellationDate: String?) -> Unit,
) {
    // Two-phase flow: phase 1 collects the optional cancellation_date;
    // phase 2 is the standard type-to-confirm dialog. This avoids forking
    // [TypeToConfirmDeleteDialog] just to add an extra field.
    var phase by remember { mutableStateOf(DeletePhase.DateInput) }
    var date by remember { mutableStateOf("") }

    when (phase) {
        DeletePhase.DateInput -> AlertDialog(
            onDismissRequest = onDismiss,
            title = { Text(stringResource(R.string.robot_vswitch_delete_title)) },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(Spacing.sm)) {
                    Text(
                        stringResource(R.string.robot_vswitch_delete_warning),
                        style = MaterialTheme.typography.bodyMedium,
                    )
                    OutlinedTextField(
                        value = date,
                        onValueChange = { date = it },
                        label = {
                            Text(stringResource(R.string.robot_vswitch_delete_cancellation_date))
                        },
                        placeholder = { Text("YYYY-MM-DD") },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth(),
                    )
                }
            },
            confirmButton = {
                TextButton(
                    onClick = { phase = DeletePhase.TypeToConfirm },
                    colors = androidx.compose.material3.ButtonDefaults.textButtonColors(
                        contentColor = MaterialTheme.colorScheme.error,
                    ),
                ) { Text(stringResource(R.string.delete)) }
            },
            dismissButton = {
                TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
            },
        )
        DeletePhase.TypeToConfirm -> TypeToConfirmDeleteDialog(
            title = stringResource(R.string.robot_vswitch_delete_title),
            warning = stringResource(R.string.robot_vswitch_delete_warning),
            confirmName = confirmName,
            confirmButtonLabel = stringResource(R.string.delete),
            onConfirm = { onConfirm(date.trim().ifBlank { null }) },
            onDismiss = onDismiss,
        )
    }
}

private enum class DeletePhase { DateInput, TypeToConfirm }

@Composable
private fun AttachServerDialog(
    servers: List<RobotServer>,
    excludedNumbers: Set<Long>,
    onDismiss: () -> Unit,
    onConfirm: (Long) -> Unit,
) {
    var query by remember { mutableStateOf("") }
    var selected by remember { mutableStateOf<Long?>(null) }
    val available = servers.filter { it.serverNumber !in excludedNumbers }
    val filtered = if (query.isBlank()) {
        available
    } else {
        available.filter { srv ->
            val haystack = listOfNotNull(srv.serverName, srv.serverIp, "#${srv.serverNumber}")
                .joinToString(" ")
            haystack.contains(query, ignoreCase = true)
        }
    }

    Dialog(
        onDismissRequest = onDismiss,
        properties = DialogProperties(usePlatformDefaultWidth = false),
    ) {
        Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.background) {
            Scaffold(
                topBar = {
                    CenterAlignedTopAppBar(
                        title = { Text(stringResource(R.string.robot_vswitch_attach_title)) },
                        navigationIcon = {
                            IconButton(onClick = onDismiss) {
                                Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null)
                            }
                        },
                        actions = {
                            TextButton(
                                enabled = selected != null,
                                onClick = { selected?.let(onConfirm) },
                            ) { Text(stringResource(R.string.save)) }
                        },
                    )
                },
            ) { padding ->
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(padding)
                        .padding(horizontal = Spacing.md, vertical = Spacing.sm),
                    verticalArrangement = Arrangement.spacedBy(Spacing.sm),
                ) {
                    OutlinedTextField(
                        value = query,
                        onValueChange = { query = it },
                        label = { Text(stringResource(R.string.robot_vswitch_attach_search)) },
                        leadingIcon = { Icon(Icons.Filled.Search, contentDescription = null) },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth(),
                    )
                    if (filtered.isEmpty()) {
                        Box(
                            modifier = Modifier.fillMaxSize().padding(Spacing.lg),
                            contentAlignment = Alignment.Center,
                        ) {
                            Text(
                                stringResource(R.string.empty_list),
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                        }
                    } else {
                        LazyColumn(
                            modifier = Modifier.fillMaxSize(),
                            verticalArrangement = Arrangement.spacedBy(Spacing.sm),
                        ) {
                            items(filtered, key = { it.serverNumber }) { server ->
                                AttachServerCard(
                                    server = server,
                                    selected = selected == server.serverNumber,
                                    onClick = { selected = server.serverNumber },
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun AttachServerCard(
    server: RobotServer,
    selected: Boolean,
    onClick: () -> Unit,
) {
    OutlinedCard(modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .selectable(selected = selected, onClick = onClick)
                .padding(Spacing.md),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            RadioButton(selected = selected, onClick = onClick)
            Spacer(Modifier.size(Spacing.sm))
            Column(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(2.dp)) {
                Text(
                    server.serverName ?: server.serverIp ?: "#${server.serverNumber}",
                    style = MaterialTheme.typography.bodyMedium,
                )
                val parts = listOfNotNull(
                    "#${server.serverNumber}",
                    server.serverIp.takeIf { !it.isNullOrBlank() && server.serverName != null },
                    server.product?.takeIf { it.isNotBlank() },
                    server.dc?.takeIf { it.isNotBlank() },
                )
                if (parts.isNotEmpty()) {
                    Text(
                        parts.joinToString(" · "),
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
            }
        }
    }
}
