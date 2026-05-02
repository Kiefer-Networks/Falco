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
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.AltRoute
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Hub
import androidx.compose.material.icons.filled.Lan
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Shield
import androidx.compose.material.icons.filled.SwapHoriz
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.FilterChip
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Surface
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
import de.kiefer_networks.falco.data.dto.CloudNetwork
import de.kiefer_networks.falco.data.dto.NetworkRoute
import de.kiefer_networks.falco.data.dto.NetworkSubnet
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

private val NETWORK_ZONES_DETAIL = listOf("eu-central", "us-east", "us-west", "ap-southeast")
private val SUBNET_TYPES = listOf("cloud", "server", "vswitch")

@Composable
fun CloudNetworkDetailScreen(
    onBack: () -> Unit,
    viewModel: CloudNetworkDetailViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsState()
    val snackbar = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    LaunchedEffect(Unit) {
        viewModel.events.collect { ev ->
            val text = when (ev) {
                is CloudNetworkEvent.Toast -> ev.text
                is CloudNetworkEvent.Failure -> ev.message
            }
            scope.launch { snackbar.showSnackbar(text) }
        }
    }

    LaunchedEffect(state.deleted) { if (state.deleted) onBack() }

    var sheetOpen by remember { mutableStateOf(false) }
    var renameOpen by remember { mutableStateOf(false) }
    var changeIpRangeOpen by remember { mutableStateOf(false) }
    var exposeOpen by remember { mutableStateOf(false) }
    var deleteOpen by remember { mutableStateOf(false) }
    var addSubnetOpen by remember { mutableStateOf(false) }
    var addRouteOpen by remember { mutableStateOf(false) }
    var pendingSubnetDelete by remember { mutableStateOf<NetworkSubnet?>(null) }
    var pendingRouteDelete by remember { mutableStateOf<NetworkRoute?>(null) }

    Scaffold(
        topBar = {
            Column {
                CenterAlignedTopAppBar(
                    title = {
                        Text(
                            text = state.network?.name ?: stringResource(R.string.cloud_networks),
                            style = MaterialTheme.typography.titleMedium,
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
                val net = state.network ?: return@Scaffold
                LazyColumn(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(padding)
                        .padding(horizontal = Spacing.md, vertical = Spacing.sm),
                    verticalArrangement = Arrangement.spacedBy(Spacing.md),
                ) {
                    item {
                        HeroCard(
                            title = net.name,
                            status = HeroStatus(
                                label = net.ipRange,
                                color = MaterialTheme.colorScheme.primary,
                            ),
                        )
                    }
                    item { KpiStrip(items = kpisFor(net)) }

                    item { SectionHeader(stringResource(R.string.cloud_network_section_protection)) }
                    item {
                        Row(
                            modifier = Modifier.fillMaxWidth().padding(vertical = Spacing.xs),
                            verticalAlignment = Alignment.CenterVertically,
                        ) {
                            Text(
                                stringResource(R.string.cloud_network_delete_protection),
                                modifier = Modifier.weight(1f),
                                style = MaterialTheme.typography.bodyMedium,
                            )
                            Switch(
                                checked = net.protection?.delete == true,
                                onCheckedChange = { viewModel.setProtection(it) },
                            )
                        }
                    }

                    item {
                        SectionRowWithAdd(
                            title = stringResource(R.string.cloud_network_section_subnets),
                            addContentDescription = stringResource(R.string.cloud_network_subnet_add),
                            onAdd = { addSubnetOpen = true },
                        )
                    }
                    if (net.subnets.isEmpty()) {
                        item { EmptyHint(stringResource(R.string.cloud_network_no_subnets)) }
                    } else {
                        items(
                            net.subnets,
                            key = { "subnet-${it.ipRange}-${it.networkZone}" },
                        ) { subnet ->
                            SubnetCard(
                                subnet = subnet,
                                onDelete = { pendingSubnetDelete = subnet },
                            )
                        }
                    }

                    item {
                        SectionRowWithAdd(
                            title = stringResource(R.string.cloud_network_section_routes),
                            addContentDescription = stringResource(R.string.cloud_network_route_add),
                            onAdd = { addRouteOpen = true },
                        )
                    }
                    if (net.routes.isEmpty()) {
                        item { EmptyHint(stringResource(R.string.cloud_network_no_routes)) }
                    } else {
                        items(
                            net.routes,
                            key = { "route-${it.destination}->${it.gateway}" },
                        ) { route ->
                            RouteCard(
                                route = route,
                                onDelete = { pendingRouteDelete = route },
                            )
                        }
                    }
                }
            }
        }
    }

    if (sheetOpen) {
        val net = state.network
        val sections = if (net == null) emptyList() else listOf(
            SheetSection(
                title = stringResource(R.string.server_detail_section_settings),
                actions = listOf(
                    SheetAction(Icons.Filled.Edit, stringResource(R.string.cloud_network_action_rename)) {
                        sheetOpen = false; renameOpen = true
                    },
                    SheetAction(Icons.Filled.SwapHoriz, stringResource(R.string.cloud_network_action_change_ip_range)) {
                        sheetOpen = false; changeIpRangeOpen = true
                    },
                    SheetAction(Icons.Filled.Shield, stringResource(R.string.server_action_protection)) {
                        sheetOpen = false
                        viewModel.setProtection(!(net.protection?.delete ?: false))
                    },
                    SheetAction(Icons.Filled.AltRoute, stringResource(R.string.cloud_network_action_expose_vswitch)) {
                        sheetOpen = false; exposeOpen = true
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
        TextPromptDialog(
            title = stringResource(R.string.cloud_network_action_rename),
            label = stringResource(R.string.cloud_network_create_name),
            initial = state.network?.name.orEmpty(),
            onDismiss = { renameOpen = false },
            onConfirm = { newName ->
                viewModel.rename(newName.trim())
                renameOpen = false
            },
        )
    }

    if (changeIpRangeOpen) {
        ChangeIpRangeDialog(
            current = state.network?.ipRange.orEmpty(),
            onDismiss = { changeIpRangeOpen = false },
            onConfirm = { value ->
                viewModel.changeIpRange(value.trim())
                changeIpRangeOpen = false
            },
        )
    }

    if (exposeOpen) {
        ExposeVSwitchDialog(
            onDismiss = { exposeOpen = false },
            onConfirm = { vswitchId, expose ->
                viewModel.exposeToVSwitch(vswitchId, expose)
                exposeOpen = false
            },
        )
    }

    if (addSubnetOpen) {
        AddSubnetDialog(
            onDismiss = { addSubnetOpen = false },
            onConfirm = { type, zone, ipRange ->
                viewModel.addSubnet(type, zone, ipRange)
                addSubnetOpen = false
            },
        )
    }

    if (addRouteOpen) {
        AddRouteDialog(
            onDismiss = { addRouteOpen = false },
            onConfirm = { destination, gateway ->
                viewModel.addRoute(destination.trim(), gateway.trim())
                addRouteOpen = false
            },
        )
    }

    pendingSubnetDelete?.let { subnet ->
        AlertDialog(
            onDismissRequest = { pendingSubnetDelete = null },
            title = { Text(stringResource(R.string.cloud_network_subnet_delete_title)) },
            text = { Text(stringResource(R.string.cloud_network_subnet_delete_warning, subnet.ipRange)) },
            confirmButton = {
                TextButton(onClick = {
                    viewModel.deleteSubnet(subnet.ipRange)
                    pendingSubnetDelete = null
                }) {
                    Text(stringResource(R.string.delete), color = MaterialTheme.colorScheme.error)
                }
            },
            dismissButton = {
                TextButton(onClick = { pendingSubnetDelete = null }) {
                    Text(stringResource(R.string.cancel))
                }
            },
        )
    }

    pendingRouteDelete?.let { route ->
        AlertDialog(
            onDismissRequest = { pendingRouteDelete = null },
            title = { Text(stringResource(R.string.cloud_network_route_delete_title)) },
            text = {
                Text(
                    stringResource(
                        R.string.cloud_network_route_delete_warning,
                        route.destination,
                        route.gateway,
                    ),
                )
            },
            confirmButton = {
                TextButton(onClick = {
                    viewModel.deleteRoute(route.destination, route.gateway)
                    pendingRouteDelete = null
                }) {
                    Text(stringResource(R.string.delete), color = MaterialTheme.colorScheme.error)
                }
            },
            dismissButton = {
                TextButton(onClick = { pendingRouteDelete = null }) {
                    Text(stringResource(R.string.cancel))
                }
            },
        )
    }

    if (deleteOpen) {
        TypeToConfirmDeleteDialog(
            title = stringResource(R.string.cloud_network_delete_title),
            warning = stringResource(R.string.cloud_network_delete_warning, state.network?.name.orEmpty()),
            confirmName = state.network?.name ?: "",
            confirmButtonLabel = stringResource(R.string.delete),
            onConfirm = {
                deleteOpen = false
                viewModel.delete()
            },
            onDismiss = { deleteOpen = false },
        )
    }
}

@Composable
private fun kpisFor(net: CloudNetwork): List<Kpi> = buildList {
    add(Kpi(Icons.Filled.Hub, stringResource(R.string.cloud_network_kpi_ip_range), net.ipRange))
    add(
        Kpi(
            Icons.Filled.Lan,
            stringResource(R.string.cloud_network_kpi_subnets),
            net.subnets.size.toString(),
        ),
    )
    add(
        Kpi(
            Icons.Filled.AltRoute,
            stringResource(R.string.cloud_network_kpi_routes),
            net.routes.size.toString(),
        ),
    )
    val vswitch = net.subnets.firstOrNull { it.vswitchId != null }?.vswitchId
    if (vswitch != null) {
        add(
            Kpi(
                Icons.Filled.SwapHoriz,
                stringResource(R.string.cloud_network_kpi_vswitch),
                vswitch.toString(),
            ),
        )
    }
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
private fun SectionRowWithAdd(
    title: String,
    addContentDescription: String,
    onAdd: () -> Unit,
) {
    Row(
        modifier = Modifier.fillMaxWidth().padding(top = Spacing.sm, bottom = Spacing.xs),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(
            title,
            style = MaterialTheme.typography.titleMedium,
            color = MaterialTheme.colorScheme.primary,
            modifier = Modifier.weight(1f),
        )
        Surface(
            onClick = onAdd,
            shape = RoundedCornerShape(50),
            color = MaterialTheme.colorScheme.surfaceVariant,
        ) {
            Row(
                modifier = Modifier.padding(horizontal = 12.dp, vertical = 4.dp),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(6.dp),
            ) {
                Icon(
                    Icons.Filled.Add,
                    contentDescription = addContentDescription,
                    tint = MaterialTheme.colorScheme.primary,
                )
                Text(
                    text = addContentDescription,
                    color = MaterialTheme.colorScheme.primary,
                    style = MaterialTheme.typography.labelMedium,
                )
            }
        }
    }
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
private fun SubnetCard(subnet: NetworkSubnet, onDelete: () -> Unit) {
    OutlinedCard(modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.padding(Spacing.md),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Column(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(2.dp)) {
                Text(subnet.ipRange, style = MaterialTheme.typography.titleSmall)
                Text(
                    "${subnet.networkZone} · ${subnet.type}",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                subnet.gateway?.let {
                    Text(
                        stringResource(R.string.cloud_network_subnet_gateway, it),
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
                subnet.vswitchId?.let {
                    Text(
                        stringResource(R.string.cloud_network_subnet_vswitch, it),
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
private fun RouteCard(route: NetworkRoute, onDelete: () -> Unit) {
    OutlinedCard(modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.padding(Spacing.md),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Column(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(2.dp)) {
                Text(
                    stringResource(R.string.cloud_network_route_destination, route.destination),
                    style = MaterialTheme.typography.titleSmall,
                )
                Text(
                    stringResource(R.string.cloud_network_route_gateway, route.gateway),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
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
private fun TextPromptDialog(
    title: String,
    label: String,
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
                label = { Text(label) },
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
private fun ChangeIpRangeDialog(
    current: String,
    onDismiss: () -> Unit,
    onConfirm: (String) -> Unit,
) {
    var text by remember { mutableStateOf(current) }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.cloud_network_action_change_ip_range)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(Spacing.sm)) {
                Text(
                    stringResource(R.string.cloud_network_change_ip_range_warning),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.error,
                )
                OutlinedTextField(
                    value = text,
                    onValueChange = { text = it },
                    label = { Text(stringResource(R.string.cloud_network_create_ip_range)) },
                    supportingText = { Text(stringResource(R.string.cloud_network_create_ip_range_hint)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
            }
        },
        confirmButton = {
            TextButton(
                enabled = text.isNotBlank() && text != current,
                onClick = { onConfirm(text) },
            ) { Text(stringResource(R.string.save)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}

@Composable
private fun ExposeVSwitchDialog(
    onDismiss: () -> Unit,
    onConfirm: (vswitchId: Long, expose: Boolean) -> Unit,
) {
    var idText by remember { mutableStateOf("") }
    var expose by remember { mutableStateOf(true) }
    val vswitchId = idText.toLongOrNull()
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.cloud_network_action_expose_vswitch)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(Spacing.sm)) {
                Text(
                    stringResource(R.string.cloud_network_expose_vswitch_hint),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                OutlinedTextField(
                    value = idText,
                    onValueChange = { v -> idText = v.filter { it.isDigit() } },
                    label = { Text(stringResource(R.string.cloud_network_expose_vswitch_id)) },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        stringResource(R.string.cloud_network_expose_vswitch_toggle),
                        modifier = Modifier.weight(1f),
                        style = MaterialTheme.typography.bodyMedium,
                    )
                    Switch(checked = expose, onCheckedChange = { expose = it })
                }
            }
        },
        confirmButton = {
            TextButton(
                enabled = vswitchId != null,
                onClick = { vswitchId?.let { onConfirm(it, expose) } },
            ) { Text(stringResource(R.string.save)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}

@Composable
private fun AddSubnetDialog(
    onDismiss: () -> Unit,
    onConfirm: (type: String, zone: String, ipRange: String?) -> Unit,
) {
    var type by remember { mutableStateOf("cloud") }
    var zone by remember { mutableStateOf("eu-central") }
    var ipRange by remember { mutableStateOf("") }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.cloud_network_subnet_add)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(Spacing.sm)) {
                Text(
                    stringResource(R.string.cloud_network_subnet_type).uppercase(),
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    SUBNET_TYPES.forEach { t ->
                        FilterChip(
                            selected = type == t,
                            onClick = { type = t },
                            label = { Text(t) },
                        )
                    }
                }
                Text(
                    stringResource(R.string.cloud_network_subnet_zone).uppercase(),
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    NETWORK_ZONES_DETAIL.forEach { z ->
                        FilterChip(
                            selected = zone == z,
                            onClick = { zone = z },
                            label = { Text(z) },
                        )
                    }
                }
                OutlinedTextField(
                    value = ipRange,
                    onValueChange = { ipRange = it },
                    label = { Text(stringResource(R.string.cloud_network_subnet_ip_range)) },
                    supportingText = { Text(stringResource(R.string.cloud_network_subnet_ip_range_hint)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
            }
        },
        confirmButton = {
            TextButton(onClick = {
                onConfirm(type, zone, ipRange.trim().ifBlank { null })
            }) { Text(stringResource(R.string.save)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}

@Composable
private fun AddRouteDialog(
    onDismiss: () -> Unit,
    onConfirm: (destination: String, gateway: String) -> Unit,
) {
    var destination by remember { mutableStateOf("") }
    var gateway by remember { mutableStateOf("") }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.cloud_network_route_add)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(Spacing.sm)) {
                OutlinedTextField(
                    value = destination,
                    onValueChange = { destination = it },
                    label = { Text(stringResource(R.string.cloud_network_route_destination_label)) },
                    supportingText = { Text(stringResource(R.string.cloud_network_route_destination_hint)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = gateway,
                    onValueChange = { gateway = it },
                    label = { Text(stringResource(R.string.cloud_network_route_gateway_label)) },
                    supportingText = { Text(stringResource(R.string.cloud_network_route_gateway_hint)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
            }
        },
        confirmButton = {
            TextButton(
                enabled = destination.isNotBlank() && gateway.isNotBlank(),
                onClick = { onConfirm(destination, gateway) },
            ) { Text(stringResource(R.string.save)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}
