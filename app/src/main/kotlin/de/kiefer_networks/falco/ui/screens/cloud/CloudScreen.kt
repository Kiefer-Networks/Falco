// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(
    androidx.compose.foundation.layout.ExperimentalLayoutApi::class,
    androidx.compose.material3.ExperimentalMaterial3Api::class,
)
package de.kiefer_networks.falco.ui.screens.cloud

import android.content.Context
import androidx.compose.foundation.clickable
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
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ContentCopy
import androidx.compose.material.icons.filled.Dns
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Memory
import androidx.compose.material.icons.filled.PowerSettingsNew
import androidx.compose.material.icons.filled.Public
import androidx.compose.material.icons.filled.RestartAlt
import androidx.compose.material.icons.filled.Sell
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.Storage
import androidx.compose.material3.AssistChip
import androidx.compose.material3.AssistChipDefaults
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.ui.components.EmptyState
import de.kiefer_networks.falco.ui.components.ErrorState
import de.kiefer_networks.falco.ui.components.LoadingState

@Composable
fun CloudScreen(
    onOpenServer: (Long) -> Unit = {},
    viewModel: CloudViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsState()
    var createOpen by remember { mutableStateOf(false) }
    androidx.compose.runtime.LaunchedEffect(Unit) { viewModel.refresh() }
    Box(modifier = Modifier.fillMaxSize()) {
        when (val s = state) {
            is CloudUiState.Loading -> LoadingState()
            is CloudUiState.Failed -> ErrorState(message = s.message, onRetry = viewModel::refresh)
            is CloudUiState.Loaded -> ServerList(
                servers = s.servers,
                onAction = { action, id -> viewModel.action(action, id) },
                onOpen = onOpenServer,
            )
        }
        FloatingActionButton(
            onClick = {
                viewModel.loadCreateOptions()
                createOpen = true
            },
            modifier = Modifier.align(Alignment.BottomEnd).padding(16.dp),
        ) {
            Icon(Icons.Filled.Add, contentDescription = stringResource(R.string.cloud_server_create))
        }
    }
    if (createOpen) {
        CreateServerSheet(
            viewModel = viewModel,
            onDismiss = { createOpen = false },
            onCreated = { createOpen = false },
        )
    }
}

@Composable
private fun ServerList(
    servers: List<CloudServer>,
    onAction: (CloudViewModel.ServerAction, Long) -> Unit,
    onOpen: (Long) -> Unit,
) {
    if (servers.isEmpty()) {
        EmptyState(
            icon = Icons.Filled.Dns,
            title = stringResource(R.string.cloud_servers),
            body = stringResource(R.string.empty_list),
        )
        return
    }
    LazyColumn(
        modifier = Modifier.fillMaxSize().padding(horizontal = 12.dp, vertical = 8.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        items(servers, key = { it.id }) { server ->
            ServerCard(server = server, onAction = onAction, onClick = { onOpen(server.id) })
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun ServerCard(
    server: CloudServer,
    onAction: (CloudViewModel.ServerAction, Long) -> Unit,
    onClick: () -> Unit,
) {
    ElevatedCard(onClick = onClick, modifier = Modifier.fillMaxWidth()) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            // Header: status dot + name + status text
            Row(verticalAlignment = Alignment.CenterVertically) {
                StatusDot(status = server.status)
                Spacer(Modifier.width(12.dp))
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = server.name,
                        style = MaterialTheme.typography.titleMedium,
                        color = MaterialTheme.colorScheme.onSurface,
                    )
                    Text(
                        text = humanStatus(server.status),
                        style = MaterialTheme.typography.bodySmall,
                        color = statusColor(server.status),
                    )
                }
            }

            // Spec chips: cores, RAM, disk
            server.serverType?.let { st ->
                FlowRow(
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalArrangement = Arrangement.spacedBy(4.dp),
                ) {
                    SpecChip(icon = Icons.Filled.Settings, label = "${st.cores} ${pluralCores(st.cores)}")
                    SpecChip(icon = Icons.Filled.Memory, label = "${formatGb(st.memory)} RAM")
                    SpecChip(icon = Icons.Filled.Storage, label = "${st.disk} GB")
                    SpecChip(icon = Icons.Filled.Sell, label = st.name)
                }
            }

            HorizontalDivider()

            // Networking + location
            Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
                server.publicNet?.ipv4?.ip?.let {
                    PropertyRow(
                        icon = Icons.Filled.Public,
                        label = stringResource(R.string.server_label_ipv4),
                        value = it,
                        copyable = true,
                    )
                }
                server.publicNet?.ipv6?.ip?.let {
                    PropertyRow(
                        icon = Icons.Filled.Public,
                        label = stringResource(R.string.server_label_ipv6),
                        value = it,
                        copyable = true,
                    )
                }
                val locationLine = listOfNotNull(
                    server.datacenter?.name,
                    server.datacenter?.location?.city,
                    server.datacenter?.location?.country,
                ).joinToString(" · ")
                if (locationLine.isNotBlank()) {
                    PropertyRow(
                        icon = Icons.Filled.LocationOn,
                        label = stringResource(R.string.server_label_location),
                        value = locationLine,
                    )
                }
            }

            // Action chips
            FlowRow(
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                verticalArrangement = Arrangement.spacedBy(4.dp),
            ) {
                ActionChip(
                    icon = Icons.Filled.RestartAlt,
                    label = stringResource(R.string.action_reboot),
                    onClick = { onAction(CloudViewModel.ServerAction.Reboot, server.id) },
                )
                if (server.status == "running") {
                    ActionChip(
                        icon = Icons.Filled.PowerSettingsNew,
                        label = stringResource(R.string.action_shutdown),
                        onClick = { onAction(CloudViewModel.ServerAction.Shutdown, server.id) },
                    )
                } else {
                    ActionChip(
                        icon = Icons.Filled.PowerSettingsNew,
                        label = stringResource(R.string.action_power_on),
                        onClick = { onAction(CloudViewModel.ServerAction.PowerOn, server.id) },
                    )
                }
                ActionChip(
                    icon = Icons.Filled.Storage,
                    label = stringResource(R.string.action_snapshot),
                    onClick = { onAction(CloudViewModel.ServerAction.Snapshot, server.id) },
                )
            }
        }
    }
}

@Composable
private fun StatusDot(status: String) {
    val color = statusColor(status)
    Surface(
        shape = CircleShape,
        color = color,
        modifier = Modifier.size(12.dp),
    ) {}
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun SpecChip(icon: ImageVector, label: String) {
    AssistChip(
        onClick = {},
        leadingIcon = {
            Icon(
                imageVector = icon,
                contentDescription = null,
                modifier = Modifier.size(AssistChipDefaults.IconSize),
            )
        },
        label = { Text(label, style = MaterialTheme.typography.labelMedium) },
    )
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun ActionChip(icon: ImageVector, label: String, onClick: () -> Unit) {
    AssistChip(
        onClick = onClick,
        leadingIcon = {
            Icon(
                imageVector = icon,
                contentDescription = null,
                modifier = Modifier.size(AssistChipDefaults.IconSize),
            )
        },
        label = { Text(label) },
    )
}

@Composable
private fun PropertyRow(
    icon: ImageVector,
    label: String,
    value: String,
    copyable: Boolean = false,
) {
    val context = LocalContext.current
    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = Modifier
            .fillMaxWidth()
            .let {
                if (copyable) it.clickable { copyToClipboard(context, label, value) } else it
            }
            .padding(vertical = 2.dp),
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            tint = MaterialTheme.colorScheme.primary,
            modifier = Modifier.size(18.dp),
        )
        Spacer(Modifier.width(10.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = label,
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
            Text(
                text = value,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurface,
                fontFamily = FontFamily.Monospace,
            )
        }
        if (copyable) {
            IconButton(onClick = { copyToClipboard(context, label, value) }) {
                Icon(
                    imageVector = Icons.Filled.ContentCopy,
                    contentDescription = stringResource(R.string.copy),
                    tint = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.size(18.dp),
                )
            }
        }
    }
}

private fun copyToClipboard(context: Context, label: String, value: String) {
    de.kiefer_networks.falco.ui.util.Clipboard.copySensitive(context, label, value)
}

private fun statusColor(status: String): Color = when (status.lowercase()) {
    "running" -> Color(0xFF2E7D32) // green
    "starting", "initializing", "rebuilding", "migrating" -> Color(0xFFEF6C00) // orange
    "stopping", "off", "deleting" -> Color(0xFF6D4C41) // brown-grey
    else -> Color(0xFF9E9E9E) // grey
}

@Composable
private fun humanStatus(status: String): String = when (status.lowercase()) {
    "running" -> stringResource(R.string.server_status_running)
    "off" -> stringResource(R.string.server_status_off)
    "starting" -> stringResource(R.string.server_status_starting)
    "stopping" -> stringResource(R.string.server_status_stopping)
    "initializing" -> stringResource(R.string.server_status_initializing)
    "rebuilding" -> stringResource(R.string.server_status_rebuilding)
    "migrating" -> stringResource(R.string.server_status_migrating)
    "deleting" -> stringResource(R.string.server_status_deleting)
    else -> status
}

private fun formatGb(value: Double): String {
    return if (value % 1.0 == 0.0) "${value.toInt()} GB" else "%.1f GB".format(value)
}

@Composable
private fun pluralCores(cores: Int): String =
    if (cores == 1) stringResource(R.string.server_unit_core_singular)
    else stringResource(R.string.server_unit_core_plural)
