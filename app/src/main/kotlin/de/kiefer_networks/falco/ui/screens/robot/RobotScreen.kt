// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.robot

import android.content.Context
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CalendarMonth
import androidx.compose.material.icons.filled.Computer
import androidx.compose.material.icons.filled.ContentCopy
import androidx.compose.material.icons.filled.Hub
import androidx.compose.material.icons.filled.Key
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Memory
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material.icons.filled.PowerSettingsNew
import androidx.compose.material.icons.filled.Public
import androidx.compose.material.icons.filled.RestartAlt
import androidx.compose.material.icons.filled.Speed
import androidx.compose.material.icons.filled.SwapHoriz
import androidx.compose.material.icons.filled.Tag
import androidx.compose.material3.AssistChip
import androidx.compose.material3.AssistChipDefaults
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Tab
import androidx.compose.material3.TabRow
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.RobotServer
import de.kiefer_networks.falco.data.repo.RobotRepo
import de.kiefer_networks.falco.ui.components.ErrorState
import de.kiefer_networks.falco.ui.components.LoadingState
import de.kiefer_networks.falco.ui.nav.LocalNavDrawer
import de.kiefer_networks.falco.ui.theme.Spacing
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import de.kiefer_networks.falco.data.util.sanitizeError
import javax.inject.Inject

data class RobotServersUiState(
    val loading: Boolean = true,
    val data: List<RobotServer> = emptyList(),
    val error: String? = null,
)

@HiltViewModel
class RobotServersViewModel @Inject constructor(private val repo: RobotRepo) : ViewModel() {
    private val _state = MutableStateFlow(RobotServersUiState())
    val state: StateFlow<RobotServersUiState> = _state.asStateFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.value = RobotServersUiState(loading = true)
        runCatching { repo.listServers() }
            .onSuccess { _state.value = RobotServersUiState(loading = false, data = it) }
            .onFailure { _state.value = RobotServersUiState(loading = false, error = sanitizeError(it)) }
    }
}

private data class RobotTab(val labelRes: Int, val icon: ImageVector)

private val ROBOT_TABS = listOf(
    RobotTab(R.string.robot_dedis, Icons.Filled.Computer),
    RobotTab(R.string.robot_failover, Icons.Filled.SwapHoriz),
    RobotTab(R.string.robot_vswitch, Icons.Filled.Hub),
    RobotTab(R.string.robot_ssh_keys, Icons.Filled.Key),
)

@Composable
fun RobotScreen(
    onServerClick: (Long) -> Unit = {},
) {
    var selected by rememberSaveable { mutableIntStateOf(0) }
    val drawer = LocalNavDrawer.current

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text(stringResource(R.string.nav_robot)) },
                navigationIcon = {
                    if (drawer.isCompact) {
                        IconButton(onClick = drawer::open) {
                            Icon(Icons.Filled.Menu, contentDescription = stringResource(R.string.nav_drawer_title))
                        }
                    }
                },
                actions = {
                    if (drawer.isCompact) {
                        androidx.compose.foundation.layout.Spacer(
                            modifier = Modifier.size(48.dp),
                        )
                    }
                },
            )
        },
    ) { padding ->
        Column(modifier = Modifier.fillMaxSize().padding(padding)) {
            TabRow(selectedTabIndex = selected) {
                ROBOT_TABS.forEachIndexed { index, tab ->
                    Tab(
                        selected = selected == index,
                        onClick = { selected = index },
                        icon = {
                            Icon(tab.icon, contentDescription = stringResource(tab.labelRes))
                        },
                    )
                }
            }
            Box(modifier = Modifier.fillMaxSize()) {
                when (selected) {
                    0 -> RobotServersTab(onServerClick = onServerClick)
                    1 -> FailoverTab()
                    2 -> VSwitchTab()
                    else -> RobotSshKeysTab()
                }
            }
        }
    }
}

@Composable
private fun RobotServersTab(
    viewModel: RobotServersViewModel = hiltViewModel(),
    onServerClick: (Long) -> Unit,
) {
    val s by viewModel.state.collectAsState()
    when {
        s.loading -> LoadingState()
        s.error != null -> ErrorState(message = s.error!!, onRetry = viewModel::refresh)
        s.data.isEmpty() -> Box(
            modifier = Modifier.fillMaxSize().padding(Spacing.lg),
            contentAlignment = Alignment.Center,
        ) {
            Text(stringResource(R.string.empty_list))
        }
        else -> LazyColumn(
            modifier = Modifier.fillMaxSize().padding(Spacing.md),
            verticalArrangement = Arrangement.spacedBy(Spacing.sm),
        ) {
            items(s.data, key = { it.serverNumber }) { server ->
                RobotServerCard(server, onClick = { onServerClick(server.serverNumber) })
            }
        }
    }
}

@OptIn(ExperimentalLayoutApi::class)
@Composable
private fun RobotServerCard(server: RobotServer, onClick: () -> Unit) {
    val ctx = LocalContext.current
    ElevatedCard(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onClick() },
    ) {
        Column(modifier = Modifier.padding(Spacing.md)) {
            // Hero: status dot + name + status text
            Row(verticalAlignment = Alignment.CenterVertically) {
                Box(
                    modifier = Modifier
                        .size(10.dp)
                        .background(statusColor(server), CircleShape),
                )
                Spacer(Modifier.size(8.dp))
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        server.serverName ?: server.serverIp ?: "#${server.serverNumber}",
                        style = MaterialTheme.typography.titleMedium,
                    )
                    server.status?.let {
                        Text(
                            if (server.cancelled) stringResource(R.string.robot_field_cancelled) else it,
                            style = MaterialTheme.typography.labelMedium,
                            color = if (server.cancelled) MaterialTheme.colorScheme.error else statusColor(server),
                        )
                    }
                }
            }

            Spacer(Modifier.size(Spacing.sm))

            // Chips: number, product, traffic
            FlowRow(
                horizontalArrangement = Arrangement.spacedBy(6.dp),
                verticalArrangement = Arrangement.spacedBy(4.dp),
            ) {
                StatChip(Icons.Filled.Tag, "#${server.serverNumber}")
                server.product?.takeIf { it.isNotBlank() }?.let {
                    StatChip(Icons.Filled.Memory, it)
                }
                server.traffic?.takeIf { it.isNotBlank() }?.let {
                    StatChip(Icons.Filled.Speed, it)
                }
            }

            Spacer(Modifier.size(Spacing.sm))
            HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant)
            Spacer(Modifier.size(Spacing.sm))

            // Network rows with copy
            server.serverIp?.let {
                CopyLine(Icons.Filled.Public, stringResource(R.string.server_public_ipv4), it, ctx)
            }
            server.serverIpv6Net?.let {
                CopyLine(Icons.Filled.Public, stringResource(R.string.robot_field_ipv6_net), it, ctx)
            }

            // Datacenter line
            server.dc?.takeIf { it.isNotBlank() }?.let {
                Row(
                    modifier = Modifier.padding(top = 4.dp),
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    Icon(
                        Icons.Filled.LocationOn,
                        contentDescription = null,
                        modifier = Modifier.size(16.dp),
                        tint = MaterialTheme.colorScheme.primary,
                    )
                    Spacer(Modifier.size(8.dp))
                    Column {
                        Text(
                            stringResource(R.string.robot_field_datacenter),
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                        Text(it, style = MaterialTheme.typography.bodyMedium)
                    }
                }
            }

            // Paid until
            server.paidUntil?.takeIf { it.isNotBlank() }?.let {
                Row(
                    modifier = Modifier.padding(top = 4.dp),
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    Icon(
                        Icons.Filled.CalendarMonth,
                        contentDescription = null,
                        modifier = Modifier.size(16.dp),
                        tint = MaterialTheme.colorScheme.primary,
                    )
                    Spacer(Modifier.size(8.dp))
                    Column {
                        Text(
                            stringResource(R.string.robot_field_paid_until),
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                        Text(it, style = MaterialTheme.typography.bodyMedium)
                    }
                }
            }

            Spacer(Modifier.size(Spacing.sm))

            // Quick actions: open detail (Reset / WoL live in detail sheet)
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedButton(onClick = onClick) {
                    Icon(Icons.Filled.RestartAlt, contentDescription = null, modifier = Modifier.size(16.dp))
                    Spacer(Modifier.size(6.dp))
                    Text(stringResource(R.string.action_reset))
                }
                OutlinedButton(onClick = onClick) {
                    Icon(Icons.Filled.PowerSettingsNew, contentDescription = null, modifier = Modifier.size(16.dp))
                    Spacer(Modifier.size(6.dp))
                    Text(stringResource(R.string.action_wol))
                }
            }
        }
    }
}

@Composable
private fun statusColor(server: RobotServer): Color {
    return when {
        server.cancelled -> MaterialTheme.colorScheme.error
        server.status?.equals("ready", ignoreCase = true) == true -> Color(0xFF2E7D32)
        else -> MaterialTheme.colorScheme.onSurfaceVariant
    }
}

@Composable
private fun StatChip(icon: ImageVector, text: String) {
    AssistChip(
        onClick = {},
        leadingIcon = {
            Icon(icon, contentDescription = null, modifier = Modifier.size(AssistChipDefaults.IconSize))
        },
        label = { Text(text, style = MaterialTheme.typography.labelMedium) },
    )
}

@Composable
private fun CopyLine(icon: ImageVector, label: String, value: String, ctx: Context) {
    Row(
        modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Icon(
            icon,
            contentDescription = null,
            modifier = Modifier.size(16.dp),
            tint = MaterialTheme.colorScheme.primary,
        )
        Spacer(Modifier.size(8.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(
                label,
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
            Text(value, style = MaterialTheme.typography.bodyMedium)
        }
        IconButton(onClick = {
            de.kiefer_networks.falco.ui.util.Clipboard.copySensitive(ctx, label, value)
        }) {
            Icon(
                Icons.Filled.ContentCopy,
                contentDescription = null,
                modifier = Modifier.size(18.dp),
            )
        }
    }
}
