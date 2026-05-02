// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Link
import androidx.compose.material.icons.filled.LinkOff
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Public
import androidx.compose.material.icons.filled.Shield
import androidx.compose.material.icons.filled.Tag
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
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

@Composable
fun CloudPrimaryIpDetailScreen(
    onBack: () -> Unit,
    viewModel: CloudPrimaryIpDetailViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsState()
    val snackbar = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    LaunchedEffect(Unit) {
        viewModel.events.collect { ev ->
            val text = when (ev) {
                is CloudPrimaryIpEvent.Toast -> ev.text
                is CloudPrimaryIpEvent.Failure -> ev.message
            }
            scope.launch { snackbar.showSnackbar(text) }
        }
    }

    LaunchedEffect(state.deleted) { if (state.deleted) onBack() }

    var sheetOpen by remember { mutableStateOf(false) }
    var assignOpen by remember { mutableStateOf(false) }
    var deleteOpen by remember { mutableStateOf(false) }

    Scaffold(
        topBar = {
            Column {
                CenterAlignedTopAppBar(
                    title = {
                        Text(
                            text = state.ip?.let { it.name.ifBlank { it.ip } }
                                ?: stringResource(R.string.cloud_primary_ips),
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
                val ip = state.ip ?: return@Scaffold
                LazyColumn(
                    modifier = Modifier.fillMaxSize().padding(padding).padding(horizontal = Spacing.md, vertical = Spacing.sm),
                    verticalArrangement = Arrangement.spacedBy(Spacing.md),
                ) {
                    item {
                        HeroCard(
                            title = ip.name.ifBlank { ip.ip },
                            subtitle = ip.ip,
                            status = HeroStatus(
                                label = if (ip.assigneeId != null) {
                                    stringResource(R.string.cloud_primary_ip_assigned)
                                } else {
                                    stringResource(R.string.cloud_primary_ip_unassigned)
                                },
                                color = if (ip.assigneeId != null) Color(0xFF2E7D32) else MaterialTheme.colorScheme.onSurfaceVariant,
                            ),
                        )
                    }
                    item {
                        KpiStrip(
                            items = buildList {
                                add(Kpi(Icons.Filled.Public, stringResource(R.string.cloud_primary_ip_type, ip.type), ip.ip))
                                add(Kpi(Icons.Filled.Tag, "ID", ip.id.toString()))
                                ip.datacenter?.let { dc ->
                                    add(Kpi(Icons.Filled.LocationOn, stringResource(R.string.server_label_location), dc.name))
                                }
                            },
                        )
                    }
                    item { SectionHeader(stringResource(R.string.cloud_primary_ip_section_assignment)) }
                    item {
                        if (ip.assigneeId != null) {
                            DetailLine(stringResource(R.string.cloud_attached_server, ip.assigneeId), "")
                        } else {
                            Text(
                                stringResource(R.string.cloud_primary_ip_unassigned),
                                style = MaterialTheme.typography.bodyMedium,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                        }
                    }
                    if (ip.dnsPtr.isNotEmpty()) {
                        item { SectionHeader(stringResource(R.string.cloud_primary_ip_section_reverse_dns)) }
                        items(ip.dnsPtr.size) { idx ->
                            val entry = ip.dnsPtr[idx]
                            DetailLine(entry.ip, entry.dnsPtr)
                        }
                    }
                }
            }
        }
    }

    if (sheetOpen) {
        val ip = state.ip
        val sections = if (ip == null) emptyList() else listOf(
            SheetSection(
                title = stringResource(R.string.cloud_primary_ip_section_assignment),
                actions = listOf(
                    if (ip.assigneeId != null) {
                        SheetAction(Icons.Filled.LinkOff, stringResource(R.string.cloud_volume_action_detach)) {
                            sheetOpen = false; viewModel.unassign()
                        }
                    } else {
                        SheetAction(Icons.Filled.Link, stringResource(R.string.cloud_volume_action_attach)) {
                            sheetOpen = false; viewModel.loadServers(); assignOpen = true
                        }
                    },
                ),
            ),
            SheetSection(
                title = stringResource(R.string.server_detail_section_settings),
                actions = listOf(
                    SheetAction(Icons.Filled.Shield, stringResource(R.string.server_action_protection)) {
                        sheetOpen = false
                        viewModel.setProtection(!(ip.protection?.delete ?: false))
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

    if (assignOpen) {
        AttachVolumeDialog(
            servers = state.servers,
            onDismiss = { assignOpen = false },
            onConfirm = { serverId, _ ->
                viewModel.assign(serverId)
                assignOpen = false
            },
        )
    }

    if (deleteOpen) {
        val ip = state.ip
        val confirmName = ip?.name?.ifBlank { ip.ip } ?: ip?.ip ?: ""
        TypeToConfirmDeleteDialog(
            title = stringResource(R.string.cloud_primary_ip_delete_title),
            warning = stringResource(R.string.cloud_primary_ip_delete_warning, confirmName),
            confirmName = confirmName,
            confirmButtonLabel = stringResource(R.string.delete),
            onConfirm = { deleteOpen = false; viewModel.delete() },
            onDismiss = { deleteOpen = false },
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
private fun DetailLine(label: String, value: String) {
    Column(modifier = Modifier.fillMaxWidth().padding(vertical = Spacing.xs)) {
        Text(label, style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
        if (value.isNotBlank()) Text(value, style = MaterialTheme.typography.bodyMedium)
    }
    HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant)
}
