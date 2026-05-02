// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Apps
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Lan
import androidx.compose.material.icons.filled.Memory
import androidx.compose.material.icons.filled.Public
import androidx.compose.material.icons.filled.Shield
import androidx.compose.material.icons.filled.Shuffle
import androidx.compose.material.icons.filled.Tag
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.AssistChip
import androidx.compose.material3.AssistChipDefaults
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.FilledTonalIconButton
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.RadioButton
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
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudLoadBalancer
import de.kiefer_networks.falco.data.dto.CloudLoadBalancerType
import de.kiefer_networks.falco.data.dto.LoadBalancerHealthCheck
import de.kiefer_networks.falco.data.dto.LoadBalancerService
import de.kiefer_networks.falco.data.dto.LoadBalancerTarget
import de.kiefer_networks.falco.ui.components.ErrorState
import de.kiefer_networks.falco.ui.components.LoadingState
import de.kiefer_networks.falco.ui.components.detail.HeroCard
import de.kiefer_networks.falco.ui.components.detail.HeroStatus
import de.kiefer_networks.falco.ui.components.detail.Kpi
import de.kiefer_networks.falco.ui.components.detail.KpiStrip
import de.kiefer_networks.falco.ui.components.dialog.ActionsBottomSheetSections
import de.kiefer_networks.falco.ui.components.dialog.SheetAction
import de.kiefer_networks.falco.ui.components.dialog.SheetSection
import de.kiefer_networks.falco.ui.components.dialog.TypeToConfirmDeleteDialog
import de.kiefer_networks.falco.ui.theme.Spacing
import kotlinx.coroutines.launch

private enum class TargetKind { Server, LabelSelector, Ip }

@Composable
fun CloudLoadBalancerDetailScreen(
    onBack: () -> Unit,
    viewModel: CloudLoadBalancerDetailViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsState()
    val snackbar = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    LaunchedEffect(Unit) {
        viewModel.events.collect { ev ->
            val text = when (ev) {
                is CloudLoadBalancerEvent.Toast -> ev.text
                is CloudLoadBalancerEvent.Failure -> ev.message
            }
            scope.launch { snackbar.showSnackbar(text) }
        }
    }

    LaunchedEffect(state.deleted) { if (state.deleted) onBack() }

    var sheetOpen by remember { mutableStateOf(false) }
    var renameOpen by remember { mutableStateOf(false) }
    var deleteOpen by remember { mutableStateOf(false) }
    var algorithmOpen by remember { mutableStateOf(false) }
    var changeTypeOpen by remember { mutableStateOf(false) }
    var addServiceOpen by remember { mutableStateOf(false) }
    var editServiceOpen by remember { mutableStateOf<LoadBalancerService?>(null) }
    var addTargetOpen by remember { mutableStateOf(false) }

    Scaffold(
        topBar = {
            Column {
                CenterAlignedTopAppBar(
                    title = {
                        Text(
                            text = state.loadBalancer?.name ?: stringResource(R.string.cloud_load_balancers),
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
                        ) { Text(stringResource(R.string.actions_sheet_title)) }
                    },
                )
                if (state.running) LinearProgressIndicator(modifier = Modifier.fillMaxWidth())
            }
        },
        snackbarHost = { SnackbarHost(snackbar) },
    ) { padding ->
        when {
            state.loading -> Box(Modifier.padding(padding)) { LoadingState() }
            state.error != null -> Box(Modifier.padding(padding)) {
                ErrorState(message = state.error!!, onRetry = viewModel::refresh)
            }
            else -> {
                val lb = state.loadBalancer ?: return@Scaffold
                LazyColumn(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(padding)
                        .padding(horizontal = Spacing.md, vertical = Spacing.sm),
                    verticalArrangement = Arrangement.spacedBy(Spacing.md),
                ) {
                    item {
                        HeroCard(
                            title = lb.name,
                            status = statusFor(lb),
                            subtitle = lb.location?.city ?: lb.location?.name,
                        )
                    }
                    item { KpiStrip(items = kpis(lb)) }

                    item { SectionHeader(stringResource(R.string.cloud_lb_section_network)) }
                    val v4 = lb.publicNet?.ipv4?.ip
                    val v6 = lb.publicNet?.ipv6?.ip
                    if (v4 != null) item { DetailLine(stringResource(R.string.cloud_lb_public_ipv4), v4) }
                    if (v6 != null) item { DetailLine(stringResource(R.string.cloud_lb_public_ipv6), v6) }
                    if (v4 == null && v6 == null) {
                        item {
                            Text(
                                stringResource(R.string.cloud_lb_public_disabled),
                                style = MaterialTheme.typography.bodyMedium,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                        }
                    }
                    if (lb.privateNet.isNotEmpty()) {
                        items(lb.privateNet.size) { idx ->
                            val pn = lb.privateNet[idx]
                            DetailLine(
                                stringResource(R.string.cloud_lb_private_network, pn.network),
                                pn.ip ?: "-",
                            )
                        }
                    }

                    item {
                        SectionHeaderWithAdd(
                            text = stringResource(R.string.cloud_lb_section_services),
                            count = lb.services.size,
                            onAdd = { addServiceOpen = true },
                            addContentDescription = stringResource(R.string.cloud_lb_service_add),
                        )
                    }
                    if (lb.services.isEmpty()) {
                        item {
                            Text(
                                stringResource(R.string.cloud_lb_services_empty),
                                style = MaterialTheme.typography.bodyMedium,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                        }
                    } else {
                        items(lb.services.size) { idx ->
                            val svc = lb.services[idx]
                            ServiceRow(
                                service = svc,
                                onEdit = { editServiceOpen = svc },
                                onDelete = { viewModel.deleteService(svc.listenPort) },
                            )
                        }
                    }

                    item {
                        SectionHeaderWithAdd(
                            text = stringResource(R.string.cloud_lb_section_targets),
                            count = lb.targets.size,
                            onAdd = { addTargetOpen = true },
                            addContentDescription = stringResource(R.string.cloud_lb_target_add),
                        )
                    }
                    if (lb.targets.isEmpty()) {
                        item {
                            Text(
                                stringResource(R.string.cloud_lb_targets_empty),
                                style = MaterialTheme.typography.bodyMedium,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                        }
                    } else {
                        items(lb.targets.size) { idx ->
                            val tgt = lb.targets[idx]
                            TargetRow(target = tgt, onDelete = { viewModel.removeTarget(tgt) })
                        }
                    }

                    item { SectionHeader(stringResource(R.string.cloud_lb_section_protection)) }
                    item {
                        Row(
                            modifier = Modifier.fillMaxWidth().padding(vertical = Spacing.xs),
                            verticalAlignment = Alignment.CenterVertically,
                        ) {
                            Text(
                                stringResource(R.string.cloud_lb_delete_protection),
                                modifier = Modifier.weight(1f),
                                style = MaterialTheme.typography.bodyMedium,
                            )
                            Switch(
                                checked = lb.protection.delete,
                                onCheckedChange = { viewModel.setProtection(it) },
                            )
                        }
                    }
                }
            }
        }
    }

    if (sheetOpen) {
        val lb = state.loadBalancer
        val publicEnabled = lb?.publicNet?.enabled == true
        val sections = if (lb == null) emptyList() else listOf(
            SheetSection(
                title = stringResource(R.string.cloud_lb_section_settings),
                actions = listOf(
                    SheetAction(Icons.Filled.Edit, stringResource(R.string.cloud_lb_action_rename)) {
                        sheetOpen = false; renameOpen = true
                    },
                    SheetAction(Icons.Filled.Shuffle, stringResource(R.string.cloud_lb_action_change_algorithm)) {
                        sheetOpen = false; algorithmOpen = true
                    },
                    SheetAction(Icons.Filled.Memory, stringResource(R.string.cloud_lb_action_change_type)) {
                        sheetOpen = false
                        viewModel.loadTypes()
                        changeTypeOpen = true
                    },
                ),
            ),
            SheetSection(
                title = stringResource(R.string.cloud_lb_section_network),
                actions = listOf(
                    SheetAction(
                        icon = Icons.Filled.Public,
                        label = if (publicEnabled) {
                            stringResource(R.string.cloud_lb_action_disable_public)
                        } else {
                            stringResource(R.string.cloud_lb_action_enable_public)
                        },
                    ) {
                        sheetOpen = false
                        viewModel.togglePublicInterface(!publicEnabled)
                    },
                    SheetAction(Icons.Filled.Shield, stringResource(R.string.server_action_protection)) {
                        sheetOpen = false
                        viewModel.setProtection(!lb.protection.delete)
                    },
                ),
            ),
            SheetSection(
                title = stringResource(R.string.server_section_danger),
                actions = listOf(
                    SheetAction(Icons.Filled.Delete, stringResource(R.string.delete), destructive = true) {
                        sheetOpen = false; deleteOpen = true
                    },
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
            title = stringResource(R.string.cloud_lb_action_rename),
            initial = state.loadBalancer?.name.orEmpty(),
            onDismiss = { renameOpen = false },
            onConfirm = { newName ->
                viewModel.rename(newName.trim())
                renameOpen = false
            },
        )
    }

    if (deleteOpen) {
        val name = state.loadBalancer?.name.orEmpty()
        TypeToConfirmDeleteDialog(
            title = stringResource(R.string.cloud_lb_delete_title),
            warning = stringResource(R.string.cloud_lb_delete_warning, name),
            confirmName = name,
            confirmButtonLabel = stringResource(R.string.delete),
            onConfirm = {
                deleteOpen = false
                viewModel.delete()
            },
            onDismiss = { deleteOpen = false },
        )
    }

    if (algorithmOpen) {
        val lb = state.loadBalancer
        AlgorithmPickerDialog(
            current = lb?.algorithm?.type ?: "round_robin",
            onDismiss = { algorithmOpen = false },
            onConfirm = { picked ->
                algorithmOpen = false
                viewModel.changeAlgorithm(picked)
            },
        )
    }

    if (changeTypeOpen) {
        val lb = state.loadBalancer
        ChangeLoadBalancerTypeDialog(
            types = state.types,
            currentType = lb?.type?.name,
            onDismiss = { changeTypeOpen = false },
            onConfirm = { typeName ->
                changeTypeOpen = false
                viewModel.changeType(typeName)
            },
        )
    }

    if (addServiceOpen) {
        ServiceFormDialog(
            initial = null,
            onDismiss = { addServiceOpen = false },
            onConfirm = { service ->
                viewModel.addService(service)
                addServiceOpen = false
            },
        )
    }

    editServiceOpen?.let { existing ->
        ServiceFormDialog(
            initial = existing,
            onDismiss = { editServiceOpen = null },
            onConfirm = { updated ->
                // listen_port is the immutable identifier; everything else is patchable.
                viewModel.updateService(
                    listenPort = existing.listenPort,
                    protocol = updated.protocol.takeIf { it != existing.protocol },
                    destinationPort = updated.destinationPort.takeIf { it != existing.destinationPort },
                    proxyprotocol = updated.proxyprotocol.takeIf { it != existing.proxyprotocol },
                )
                editServiceOpen = null
            },
        )
    }

    if (addTargetOpen) {
        AddTargetDialog(
            onDismiss = { addTargetOpen = false },
            onConfirmServer = { id, usePrivate ->
                viewModel.addServerTarget(id, usePrivate)
                addTargetOpen = false
            },
            onConfirmLabelSelector = { selector ->
                viewModel.addLabelSelectorTarget(selector)
                addTargetOpen = false
            },
            onConfirmIp = { ip ->
                viewModel.addIpTarget(ip)
                addTargetOpen = false
            },
        )
    }
}

@Composable
private fun statusFor(lb: CloudLoadBalancer): HeroStatus {
    val publicOn = lb.publicNet?.enabled == true
    val color = if (publicOn) Color(0xFF2E7D32) else MaterialTheme.colorScheme.onSurfaceVariant
    val label = lb.algorithm.type
    return HeroStatus(label = label, color = color)
}

@Composable
private fun kpis(lb: CloudLoadBalancer): List<Kpi> = buildList {
    lb.type?.let { add(Kpi(Icons.Filled.Memory, stringResource(R.string.cloud_lb_kpi_type), it.name)) }
    add(Kpi(Icons.Filled.Apps, stringResource(R.string.cloud_lb_kpi_services), lb.services.size.toString()))
    add(Kpi(Icons.Filled.Lan, stringResource(R.string.cloud_lb_kpi_targets), lb.targets.size.toString()))
    add(Kpi(Icons.Filled.Tag, "ID", lb.id.toString()))
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
private fun SectionHeaderWithAdd(
    text: String,
    count: Int,
    addContentDescription: String,
    onAdd: () -> Unit,
) {
    Row(
        modifier = Modifier.fillMaxWidth().padding(top = Spacing.sm, bottom = Spacing.xs),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(
            "$text ($count)",
            style = MaterialTheme.typography.titleMedium,
            color = MaterialTheme.colorScheme.primary,
            modifier = Modifier.weight(1f),
        )
        FilledTonalIconButton(onClick = onAdd) {
            Icon(Icons.Filled.Add, contentDescription = addContentDescription)
        }
    }
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
private fun ServiceRow(
    service: LoadBalancerService,
    onEdit: () -> Unit,
    onDelete: () -> Unit,
) {
    ElevatedCard(
        modifier = Modifier.fillMaxWidth().clickable { onEdit() },
    ) {
        Row(
            modifier = Modifier.padding(Spacing.md),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    "${service.protocol.uppercase()}  ${service.listenPort} → ${service.destinationPort}",
                    style = MaterialTheme.typography.titleSmall,
                )
                if (service.proxyprotocol) {
                    Text(
                        stringResource(R.string.cloud_lb_service_proxyprotocol),
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
            }
            IconButton(onClick = onDelete) {
                Icon(
                    Icons.Filled.Delete,
                    contentDescription = stringResource(R.string.delete),
                    tint = MaterialTheme.colorScheme.error,
                )
            }
        }
    }
}

@Composable
private fun TargetRow(target: LoadBalancerTarget, onDelete: () -> Unit) {
    val (label, value) = when (target.type) {
        "server" -> stringResource(R.string.cloud_lb_target_type_server) to ("#${target.server?.id ?: "?"}")
        "label_selector" -> stringResource(R.string.cloud_lb_target_type_label_selector) to (target.labelSelector?.selector ?: "-")
        "ip" -> stringResource(R.string.cloud_lb_target_type_ip) to (target.ip?.ip ?: "-")
        else -> target.type to "-"
    }
    ElevatedCard(modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.padding(Spacing.md),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(label, style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                Text(value, style = MaterialTheme.typography.bodyMedium)
            }
            IconButton(onClick = onDelete) {
                Icon(
                    Icons.Filled.Delete,
                    contentDescription = stringResource(R.string.delete),
                    tint = MaterialTheme.colorScheme.error,
                )
            }
        }
    }
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
private fun AlgorithmPickerDialog(
    current: String,
    onDismiss: () -> Unit,
    onConfirm: (String) -> Unit,
) {
    val options = listOf(
        "round_robin" to stringResource(R.string.cloud_lb_algorithm_round_robin),
        "least_connections" to stringResource(R.string.cloud_lb_algorithm_least_connections),
    )
    var selected by remember { mutableStateOf(current) }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.cloud_lb_action_change_algorithm)) },
        text = {
            Column {
                options.forEach { (key, label) ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable { selected = key }
                            .padding(vertical = Spacing.xs),
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        RadioButton(selected = selected == key, onClick = { selected = key })
                        Text(label, modifier = Modifier.padding(start = Spacing.sm))
                    }
                }
            }
        },
        confirmButton = {
            TextButton(
                enabled = selected != current,
                onClick = { onConfirm(selected) },
            ) { Text(stringResource(R.string.save)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}

@Composable
private fun ChangeLoadBalancerTypeDialog(
    types: List<CloudLoadBalancerType>,
    currentType: String?,
    onDismiss: () -> Unit,
    onConfirm: (String) -> Unit,
) {
    var selected by remember { mutableStateOf<CloudLoadBalancerType?>(null) }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.cloud_lb_action_change_type)) },
        text = {
            if (types.isEmpty()) {
                Text(stringResource(R.string.loading))
            } else {
                Column(
                    modifier = Modifier.verticalScroll(rememberScrollState()),
                    verticalArrangement = Arrangement.spacedBy(Spacing.xs),
                ) {
                    types.forEach { t ->
                        val current = currentType == t.name
                        ElevatedCard(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clickable(enabled = !current) { selected = t },
                            colors = CardDefaults.elevatedCardColors(
                                containerColor = when {
                                    current -> MaterialTheme.colorScheme.surfaceVariant
                                    selected?.id == t.id -> MaterialTheme.colorScheme.primaryContainer
                                    else -> MaterialTheme.colorScheme.surface
                                },
                            ),
                        ) {
                            Column(modifier = Modifier.padding(Spacing.sm)) {
                                Text(
                                    if (current) {
                                        stringResource(R.string.cloud_lb_type_current, t.name)
                                    } else {
                                        t.name
                                    },
                                    style = MaterialTheme.typography.titleSmall,
                                )
                                t.description?.takeIf { it.isNotBlank() }?.let {
                                    Text(it, style = MaterialTheme.typography.bodySmall)
                                }
                                Text(
                                    stringResource(
                                        R.string.cloud_lb_type_specs,
                                        t.maxConnections,
                                        t.maxServices,
                                        t.maxTargets,
                                    ),
                                    style = MaterialTheme.typography.labelSmall,
                                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                                )
                            }
                        }
                    }
                }
            }
        },
        confirmButton = {
            TextButton(
                enabled = selected != null,
                onClick = { selected?.let { onConfirm(it.name) } },
            ) { Text(stringResource(R.string.save)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}

@Composable
private fun ServiceFormDialog(
    initial: LoadBalancerService?,
    onDismiss: () -> Unit,
    onConfirm: (LoadBalancerService) -> Unit,
) {
    val isEdit = initial != null
    var protocol by remember { mutableStateOf(initial?.protocol ?: "tcp") }
    var listenStr by remember { mutableStateOf(initial?.listenPort?.toString() ?: "") }
    var destStr by remember { mutableStateOf(initial?.destinationPort?.toString() ?: "") }
    var proxy by remember { mutableStateOf(initial?.proxyprotocol ?: false) }
    val protoOptions = listOf("tcp", "http", "https")

    val listen = listenStr.toIntOrNull()
    val dest = destStr.toIntOrNull()
    val valid = listen != null && listen in 1..65535 && dest != null && dest in 1..65535

    AlertDialog(
        onDismissRequest = onDismiss,
        title = {
            Text(
                if (isEdit) stringResource(R.string.cloud_lb_service_edit_title)
                else stringResource(R.string.cloud_lb_service_add_title),
            )
        },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(Spacing.sm)) {
                Text(
                    stringResource(R.string.cloud_lb_service_protocol),
                    style = MaterialTheme.typography.labelMedium,
                )
                Row(horizontalArrangement = Arrangement.spacedBy(Spacing.xs)) {
                    protoOptions.forEach { p ->
                        AssistChip(
                            onClick = { protocol = p },
                            label = { Text(p.uppercase()) },
                            colors = if (protocol == p) {
                                AssistChipDefaults.assistChipColors(
                                    containerColor = MaterialTheme.colorScheme.primaryContainer,
                                )
                            } else {
                                AssistChipDefaults.assistChipColors()
                            },
                        )
                    }
                }
                OutlinedTextField(
                    value = listenStr,
                    onValueChange = { listenStr = it.filter { ch -> ch.isDigit() } },
                    label = { Text(stringResource(R.string.cloud_lb_service_listen_port)) },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true,
                    enabled = !isEdit,
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = destStr,
                    onValueChange = { destStr = it.filter { ch -> ch.isDigit() } },
                    label = { Text(stringResource(R.string.cloud_lb_service_destination_port)) },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        stringResource(R.string.cloud_lb_service_proxyprotocol),
                        modifier = Modifier.weight(1f),
                    )
                    Switch(checked = proxy, onCheckedChange = { proxy = it })
                }
            }
        },
        confirmButton = {
            TextButton(
                enabled = valid,
                onClick = {
                    // Hetzner rejects add_service without a health_check block.
                    // Keep the form minimal but synthesise a sensible default
                    // (TCP probe on the destination port; the user can refine
                    // later via the API). The edit path doesn't send this.
                    val hc = if (isEdit) initial?.healthCheck else LoadBalancerHealthCheck(
                        protocol = "tcp",
                        port = dest!!,
                    )
                    onConfirm(
                        LoadBalancerService(
                            protocol = protocol,
                            listenPort = listen!!,
                            destinationPort = dest!!,
                            proxyprotocol = proxy,
                            healthCheck = hc,
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

@Composable
private fun AddTargetDialog(
    onDismiss: () -> Unit,
    onConfirmServer: (Long, Boolean) -> Unit,
    onConfirmLabelSelector: (String) -> Unit,
    onConfirmIp: (String) -> Unit,
) {
    var kind by remember { mutableStateOf(TargetKind.Server) }
    var serverIdStr by remember { mutableStateOf("") }
    var usePrivate by remember { mutableStateOf(false) }
    var selector by remember { mutableStateOf("") }
    var ip by remember { mutableStateOf("") }

    val canSubmit = when (kind) {
        TargetKind.Server -> serverIdStr.toLongOrNull() != null
        TargetKind.LabelSelector -> selector.isNotBlank()
        TargetKind.Ip -> ip.isNotBlank()
    }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.cloud_lb_target_add_title)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(Spacing.sm)) {
                TargetKind.entries.forEach { tk ->
                    val label = when (tk) {
                        TargetKind.Server -> stringResource(R.string.cloud_lb_target_type_server)
                        TargetKind.LabelSelector -> stringResource(R.string.cloud_lb_target_type_label_selector)
                        TargetKind.Ip -> stringResource(R.string.cloud_lb_target_type_ip)
                    }
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable { kind = tk },
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        RadioButton(selected = kind == tk, onClick = { kind = tk })
                        Text(label, modifier = Modifier.padding(start = Spacing.sm))
                    }
                }
                when (kind) {
                    TargetKind.Server -> {
                        OutlinedTextField(
                            value = serverIdStr,
                            onValueChange = { serverIdStr = it.filter { ch -> ch.isDigit() } },
                            label = { Text(stringResource(R.string.cloud_lb_target_server_id)) },
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                            singleLine = true,
                            modifier = Modifier.fillMaxWidth(),
                        )
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Text(
                                stringResource(R.string.cloud_lb_target_use_private_ip),
                                modifier = Modifier.weight(1f),
                            )
                            Switch(checked = usePrivate, onCheckedChange = { usePrivate = it })
                        }
                    }
                    TargetKind.LabelSelector -> {
                        OutlinedTextField(
                            value = selector,
                            onValueChange = { selector = it },
                            label = { Text(stringResource(R.string.cloud_lb_target_label_selector)) },
                            singleLine = true,
                            modifier = Modifier.fillMaxWidth(),
                        )
                        Text(
                            stringResource(R.string.cloud_lb_target_label_selector_hint),
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                    TargetKind.Ip -> {
                        OutlinedTextField(
                            value = ip,
                            onValueChange = { ip = it },
                            label = { Text(stringResource(R.string.cloud_lb_target_ip_address)) },
                            singleLine = true,
                            modifier = Modifier.fillMaxWidth(),
                        )
                    }
                }
            }
        },
        confirmButton = {
            TextButton(
                enabled = canSubmit,
                onClick = {
                    when (kind) {
                        TargetKind.Server -> onConfirmServer(serverIdStr.toLong(), usePrivate)
                        TargetKind.LabelSelector -> onConfirmLabelSelector(selector.trim())
                        TargetKind.Ip -> onConfirmIp(ip.trim())
                    }
                },
            ) { Text(stringResource(R.string.save)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}
