// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.search

import androidx.compose.foundation.clickable
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
import androidx.compose.material.icons.filled.Apps
import androidx.compose.material.icons.filled.Cloud
import androidx.compose.material.icons.filled.Computer
import androidx.compose.material.icons.filled.Hub
import androidx.compose.material.icons.filled.Inventory2
import androidx.compose.material.icons.filled.Key
import androidx.compose.material.icons.filled.Lan
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Memory
import androidx.compose.material.icons.filled.Public
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Security
import androidx.compose.material.icons.filled.Storage
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.ui.theme.Spacing

@Composable
fun SearchScreen(
    viewModel: SearchViewModel = hiltViewModel(),
    onOpenServer: (Long) -> Unit = {},
    onOpenVolume: (Long) -> Unit = {},
    onOpenFloatingIp: (Long) -> Unit = {},
    onOpenFirewall: (Long) -> Unit = {},
    onOpenStorageBox: (Long) -> Unit = {},
    onOpenRobot: (Long) -> Unit = {},
    onOpenDnsZone: (String) -> Unit = {},
    onBack: () -> Unit = {},
) {
    val state by viewModel.state.collectAsState()
    val drawer = de.kiefer_networks.falco.ui.nav.LocalNavDrawer.current
    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text(stringResource(R.string.search_title)) },
                navigationIcon = {
                    if (drawer.isCompact) {
                        IconButton(onClick = drawer::open) {
                            Icon(
                                Icons.AutoMirrored.Filled.ArrowBack,
                                contentDescription = stringResource(R.string.nav_drawer_title),
                            )
                        }
                    }
                },
            )
        },
    ) { padding ->
        Column(
            modifier = Modifier.fillMaxSize().padding(padding).padding(Spacing.md),
            verticalArrangement = Arrangement.spacedBy(Spacing.sm),
        ) {
            OutlinedTextField(
                value = state.query,
                onValueChange = viewModel::onQueryChange,
                modifier = Modifier.fillMaxWidth(),
                singleLine = true,
                leadingIcon = { Icon(Icons.Filled.Search, contentDescription = null) },
                placeholder = { Text(stringResource(R.string.search_placeholder)) },
            )

            if (state.indexing) {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    CircularProgressIndicator()
                }
                return@Column
            }
            if (state.query.isBlank()) {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Text(
                        stringResource(R.string.search_hint),
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
                return@Column
            }
            if (state.results.isEmpty()) {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Text(
                        stringResource(R.string.search_empty),
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
                return@Column
            }

            LazyColumn(verticalArrangement = Arrangement.spacedBy(Spacing.sm)) {
                items(state.results, key = { "${it.kind}-${it.projectId.orEmpty()}-${it.id}" }) { hit ->
                    ResultRow(hit) {
                        // Switch active Cloud project so detail screens hit the right token.
                        hit.projectId?.let { viewModel.selectProject(it) }
                        when (hit.kind) {
                            ResultKind.CloudServer -> onOpenServer(hit.id.toLong())
                            ResultKind.Volume -> onOpenVolume(hit.id.toLong())
                            ResultKind.FloatingIp -> onOpenFloatingIp(hit.id.toLong())
                            ResultKind.Firewall -> onOpenFirewall(hit.id.toLong())
                            ResultKind.StorageBox -> onOpenStorageBox(hit.id.toLong())
                            ResultKind.RobotServer -> onOpenRobot(hit.id.toLong())
                            ResultKind.DnsZone -> onOpenDnsZone(hit.id)
                            else -> Unit
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun ResultRow(hit: SearchHit, onClick: () -> Unit) {
    OutlinedCard(modifier = Modifier.fillMaxWidth().clickable(onClick = onClick)) {
        Row(
            modifier = Modifier.padding(horizontal = 12.dp, vertical = 10.dp).fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Icon(
                iconFor(hit.kind),
                contentDescription = null,
                tint = MaterialTheme.colorScheme.primary,
                modifier = Modifier.size(20.dp),
            )
            Spacer(Modifier.size(12.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(hit.title, style = MaterialTheme.typography.bodyLarge)
                Text(
                    hit.subtitle,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
            Text(
                stringResource(labelFor(hit.kind)).uppercase(),
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.primary,
            )
        }
    }
}

private fun iconFor(kind: ResultKind): ImageVector = when (kind) {
    ResultKind.CloudServer -> Icons.Filled.Cloud
    ResultKind.RobotServer -> Icons.Filled.Memory
    ResultKind.Volume -> Icons.Filled.Storage
    ResultKind.Network -> Icons.Filled.Hub
    ResultKind.FloatingIp -> Icons.Filled.Public
    ResultKind.Firewall -> Icons.Filled.Security
    ResultKind.StorageBox -> Icons.Filled.Inventory2
    ResultKind.DnsZone -> Icons.Filled.Hub
    ResultKind.SshKey -> Icons.Filled.Key
    ResultKind.LoadBalancer -> Icons.Filled.Lan
    ResultKind.Certificate -> Icons.Filled.Lock
    ResultKind.PlacementGroup -> Icons.Filled.Apps
    ResultKind.PrimaryIp -> Icons.Filled.Public
    ResultKind.Computer -> Icons.Filled.Computer
}

private fun labelFor(kind: ResultKind): Int = when (kind) {
    ResultKind.CloudServer -> R.string.cloud_servers
    ResultKind.RobotServer -> R.string.robot_dedis
    ResultKind.Volume -> R.string.cloud_volumes
    ResultKind.Network -> R.string.cloud_networks
    ResultKind.FloatingIp -> R.string.cloud_floating_ips
    ResultKind.Firewall -> R.string.cloud_firewalls
    ResultKind.StorageBox -> R.string.cloud_storage_boxes
    ResultKind.DnsZone -> R.string.dns_zones
    ResultKind.SshKey -> R.string.cloud_ssh_keys
    ResultKind.LoadBalancer -> R.string.cloud_load_balancers
    ResultKind.Certificate -> R.string.cloud_certificates
    ResultKind.PlacementGroup -> R.string.cloud_placement_groups
    ResultKind.PrimaryIp -> R.string.cloud_servers
    ResultKind.Computer -> R.string.cloud_servers
}
