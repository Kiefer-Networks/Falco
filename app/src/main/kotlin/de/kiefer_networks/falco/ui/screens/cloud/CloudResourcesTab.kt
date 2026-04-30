// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

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
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Computer
import androidx.compose.material.icons.filled.Hub
import androidx.compose.material.icons.filled.Link
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Public
import androidx.compose.material.icons.filled.Apps
import androidx.compose.material.icons.filled.Lan
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Storage
import androidx.compose.material3.AssistChip
import androidx.compose.material3.AssistChipDefaults
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.FilledTonalIconButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.pluralStringResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudCertificate
import de.kiefer_networks.falco.data.dto.CloudFloatingIp
import de.kiefer_networks.falco.data.dto.CloudLoadBalancer
import de.kiefer_networks.falco.data.dto.CloudNetwork
import de.kiefer_networks.falco.data.dto.CloudPlacementGroup
import de.kiefer_networks.falco.data.dto.CloudVolume
import de.kiefer_networks.falco.ui.theme.Spacing

@Composable
fun CloudResourcesTab(
    onOpenVolume: (Long) -> Unit = {},
    onOpenFloatingIp: (Long) -> Unit = {},
    volumesViewModel: CloudVolumesViewModel = hiltViewModel(),
    networksViewModel: CloudNetworksViewModel = hiltViewModel(),
    floatingIpsViewModel: CloudFloatingIpsViewModel = hiltViewModel(),
    loadBalancersViewModel: CloudLoadBalancersViewModel = hiltViewModel(),
    certificatesViewModel: CloudCertificatesViewModel = hiltViewModel(),
    placementGroupsViewModel: CloudPlacementGroupsViewModel = hiltViewModel(),
) {
    val v by volumesViewModel.state.collectAsState()
    val n by networksViewModel.state.collectAsState()
    val f by floatingIpsViewModel.state.collectAsState()
    val lb by loadBalancersViewModel.state.collectAsState()
    val cert by certificatesViewModel.state.collectAsState()
    val pg by placementGroupsViewModel.state.collectAsState()

    var createVolumeOpen by remember { mutableStateOf(false) }
    var createNetworkOpen by remember { mutableStateOf(false) }
    var createFloatingIpOpen by remember { mutableStateOf(false) }
    var createPlacementGroupOpen by remember { mutableStateOf(false) }
    var uploadCertOpen by remember { mutableStateOf(false) }
    val snackbarHostState = remember { SnackbarHostState() }

    LaunchedEffect(Unit) {
        volumesViewModel.refresh()
        networksViewModel.refresh()
        floatingIpsViewModel.refresh()
        loadBalancersViewModel.refresh()
        certificatesViewModel.refresh()
        placementGroupsViewModel.refresh()
    }
    LaunchedEffect(volumesViewModel) {
        volumesViewModel.events.collect { snackbarHostState.showSnackbar(it) }
    }
    LaunchedEffect(networksViewModel) {
        networksViewModel.events.collect { snackbarHostState.showSnackbar(it) }
    }
    LaunchedEffect(floatingIpsViewModel) {
        floatingIpsViewModel.events.collect { snackbarHostState.showSnackbar(it) }
    }
    LaunchedEffect(loadBalancersViewModel) {
        loadBalancersViewModel.events.collect { snackbarHostState.showSnackbar(it) }
    }
    LaunchedEffect(certificatesViewModel) {
        certificatesViewModel.events.collect { snackbarHostState.showSnackbar(it) }
    }
    LaunchedEffect(placementGroupsViewModel) {
        placementGroupsViewModel.events.collect { snackbarHostState.showSnackbar(it) }
    }

    Scaffold(
        snackbarHost = { SnackbarHost(snackbarHostState) },
        contentWindowInsets = androidx.compose.foundation.layout.WindowInsets(0, 0, 0, 0),
    ) { padding ->
    LazyColumn(
        modifier = Modifier.fillMaxSize().padding(padding).padding(Spacing.md),
        verticalArrangement = Arrangement.spacedBy(Spacing.sm),
    ) {
        item {
            SectionHeader(
                stringResource(R.string.cloud_volumes),
                v.data.size,
                addContentDescription = stringResource(R.string.cloud_volume_create),
                onAdd = {
                    volumesViewModel.loadCreateOptions()
                    createVolumeOpen = true
                },
            )
        }
        if (v.loading) item { LoadingRow() }
        else if (v.data.isEmpty()) item { EmptyRow() }
        else items(v.data, key = { "vol-${it.id}" }) { ResourceVolumeCard(it, onClick = { onOpenVolume(it.id) }) }

        item {
            SectionHeader(
                stringResource(R.string.cloud_networks),
                n.data.size,
                addContentDescription = stringResource(R.string.cloud_network_create),
                onAdd = { createNetworkOpen = true },
            )
        }
        if (n.loading) item { LoadingRow() }
        else if (n.data.isEmpty()) item { EmptyRow() }
        else items(n.data, key = { "net-${it.id}" }) { ResourceNetworkCard(it) }

        item {
            SectionHeader(
                stringResource(R.string.cloud_floating_ips),
                f.data.size,
                addContentDescription = stringResource(R.string.cloud_floating_ip_create),
                onAdd = {
                    floatingIpsViewModel.loadCreateOptions()
                    createFloatingIpOpen = true
                },
            )
        }
        if (f.loading) item { LoadingRow() }
        else if (f.data.isEmpty()) item { EmptyRow() }
        else items(f.data, key = { "fip-${it.id}" }) { ResourceFloatingIpCard(it, onClick = { onOpenFloatingIp(it.id) }) }

        item { SectionHeader(stringResource(R.string.cloud_load_balancers), lb.data.size) }
        if (lb.loading) item { LoadingRow() }
        else if (lb.data.isEmpty()) item { EmptyRow() }
        else items(lb.data, key = { "lb-${it.id}" }) { ResourceLoadBalancerCard(it) }

        item {
            SectionHeader(
                stringResource(R.string.cloud_certificates),
                cert.data.size,
                addContentDescription = stringResource(R.string.cloud_certificate_upload),
                onAdd = { uploadCertOpen = true },
            )
        }
        if (cert.loading) item { LoadingRow() }
        else if (cert.data.isEmpty()) item { EmptyRow() }
        else items(cert.data, key = { "cert-${it.id}" }) { ResourceCertificateCard(it) }

        item {
            SectionHeader(
                stringResource(R.string.cloud_placement_groups),
                pg.data.size,
                addContentDescription = stringResource(R.string.cloud_placement_group_create),
                onAdd = { createPlacementGroupOpen = true },
            )
        }
        if (pg.loading) item { LoadingRow() }
        else if (pg.data.isEmpty()) item { EmptyRow() }
        else items(pg.data, key = { "pg-${it.id}" }) { ResourcePlacementGroupCard(it) }
    }
    }

    if (createVolumeOpen) {
        CreateVolumeWizard(
            viewModel = volumesViewModel,
            onDismiss = { createVolumeOpen = false },
            onCreated = { createVolumeOpen = false },
        )
    }
    if (createNetworkOpen) {
        CreateNetworkWizard(
            viewModel = networksViewModel,
            onDismiss = { createNetworkOpen = false },
            onCreated = { createNetworkOpen = false },
        )
    }
    if (uploadCertOpen) {
        UploadCertificateDialog(
            onDismiss = { uploadCertOpen = false },
            onUpload = { name, cert, key ->
                certificatesViewModel.upload(name, cert, key) { ok -> if (ok) uploadCertOpen = false }
            },
            onRequestManaged = { name, domains ->
                certificatesViewModel.requestManaged(name, domains) { ok -> if (ok) uploadCertOpen = false }
            },
        )
    }
    if (createPlacementGroupOpen) {
        CreatePlacementGroupDialog(
            onDismiss = { createPlacementGroupOpen = false },
            onCreate = { name, type ->
                placementGroupsViewModel.create(name, type) { ok -> if (ok) createPlacementGroupOpen = false }
            },
        )
    }
    if (createFloatingIpOpen) {
        CreateFloatingIpWizard(
            viewModel = floatingIpsViewModel,
            onDismiss = { createFloatingIpOpen = false },
            onCreated = { createFloatingIpOpen = false },
        )
    }
}

@Composable
private fun SectionHeader(
    title: String,
    count: Int,
    addContentDescription: String? = null,
    onAdd: (() -> Unit)? = null,
) {
    Row(
        modifier = Modifier.fillMaxWidth().padding(top = Spacing.md, bottom = Spacing.xs),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(
            text = "$title ($count)",
            style = MaterialTheme.typography.titleMedium,
            color = MaterialTheme.colorScheme.primary,
            modifier = Modifier.weight(1f),
        )
        if (onAdd != null) {
            FilledTonalIconButton(onClick = onAdd) {
                Icon(Icons.Filled.Add, contentDescription = addContentDescription)
            }
        }
    }
}

@Composable
private fun EmptyRow() {
    Text(
        stringResource(R.string.empty_list),
        style = MaterialTheme.typography.bodyMedium,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        modifier = Modifier.padding(Spacing.sm),
    )
}

@Composable
private fun LoadingRow() {
    Text(
        stringResource(R.string.loading),
        style = MaterialTheme.typography.bodyMedium,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        modifier = Modifier.padding(Spacing.sm),
    )
}

@Composable
private fun ResourceVolumeCard(volume: CloudVolume, onClick: () -> Unit = {}) {
    val accent = when (volume.status) {
        "available" -> Color(0xFF2E7D32)
        "creating" -> MaterialTheme.colorScheme.tertiary
        else -> MaterialTheme.colorScheme.onSurfaceVariant
    }
    ResourceCardShell(
        icon = Icons.Filled.Storage,
        title = volume.name,
        statusLabel = volume.status,
        statusColor = accent,
        onClick = onClick,
    ) {
        StatChip(Icons.Filled.Storage, stringResource(R.string.cloud_volume_size_gb, volume.size))
        if (volume.server != null) {
            StatChip(Icons.Filled.Link, "#${volume.server}")
        }
        volume.location?.let { loc -> StatChip(Icons.Filled.LocationOn, loc.city ?: loc.name) }
    }
}

@Composable
private fun ResourceNetworkCard(network: CloudNetwork) {
    ResourceCardShell(
        icon = Icons.Filled.Hub,
        title = network.name,
        statusLabel = network.ipRange,
        statusColor = MaterialTheme.colorScheme.primary,
        onClick = null,
    ) {
        StatChip(
            Icons.Filled.Hub,
            pluralStringResource(R.plurals.cloud_network_subnet_count, network.subnets.size, network.subnets.size),
        )
        StatChip(
            Icons.Filled.Computer,
            pluralStringResource(R.plurals.cloud_network_server_count, network.servers.size, network.servers.size),
        )
    }
}

@Composable
private fun ResourceFloatingIpCard(fip: CloudFloatingIp, onClick: () -> Unit = {}) {
    val active = fip.server != null
    ResourceCardShell(
        icon = Icons.Filled.Public,
        title = fip.name ?: fip.ip,
        statusLabel = if (active) {
            stringResource(R.string.floating_ip_assigned)
        } else {
            stringResource(R.string.floating_ip_unassigned)
        },
        statusColor = if (active) Color(0xFF2E7D32) else MaterialTheme.colorScheme.onSurfaceVariant,
        onClick = onClick,
    ) {
        StatChip(Icons.Filled.Public, fip.type.uppercase())
        if (active) StatChip(Icons.Filled.Link, "#${fip.server}")
        fip.homeLocation?.let { loc -> StatChip(Icons.Filled.LocationOn, loc.city ?: loc.name) }
    }
}

@OptIn(ExperimentalLayoutApi::class)
@Composable
private fun ResourceCardShell(
    icon: ImageVector,
    title: String,
    statusLabel: String,
    statusColor: Color,
    onClick: (() -> Unit)?,
    chips: @Composable () -> Unit,
) {
    val mod = if (onClick != null) {
        Modifier.fillMaxWidth().clickable { onClick() }
    } else {
        Modifier.fillMaxWidth()
    }
    ElevatedCard(modifier = mod) {
        Column(
            modifier = Modifier.padding(Spacing.md),
            verticalArrangement = Arrangement.spacedBy(Spacing.sm),
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Surface(
                    shape = RoundedCornerShape(10.dp),
                    color = MaterialTheme.colorScheme.primaryContainer,
                    modifier = Modifier.size(36.dp),
                ) {
                    Box(contentAlignment = Alignment.Center, modifier = Modifier.size(36.dp)) {
                        Icon(
                            icon,
                            contentDescription = null,
                            tint = MaterialTheme.colorScheme.onPrimaryContainer,
                            modifier = Modifier.size(20.dp),
                        )
                    }
                }
                Spacer(Modifier.size(12.dp))
                Column(modifier = Modifier.weight(1f)) {
                    Text(title, style = MaterialTheme.typography.titleSmall)
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Box(
                            modifier = Modifier
                                .size(8.dp)
                                .background(color = statusColor, shape = CircleShape),
                        )
                        Spacer(Modifier.size(6.dp))
                        Text(
                            statusLabel,
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                }
            }
            FlowRow(
                horizontalArrangement = Arrangement.spacedBy(6.dp),
                verticalArrangement = Arrangement.spacedBy(4.dp),
            ) {
                chips()
            }
        }
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
private fun ResourceLoadBalancerCard(lb: CloudLoadBalancer) {
    ResourceCardShell(
        icon = Icons.Filled.Lan,
        title = lb.name,
        statusLabel = lb.type?.name ?: "-",
        statusColor = MaterialTheme.colorScheme.primary,
        onClick = null,
    ) {
        StatChip(Icons.Filled.Apps, "${lb.services.size} svc")
        StatChip(Icons.Filled.Computer, "${lb.targets.size} tgt")
        lb.location?.let { loc -> StatChip(Icons.Filled.LocationOn, loc.city ?: loc.name) }
    }
}

@Composable
private fun ResourceCertificateCard(c: CloudCertificate) {
    val statusLabel = when {
        c.type == "managed" && c.status?.issuance != null -> c.status.issuance
        else -> c.notValidAfter ?: c.type
    }
    ResourceCardShell(
        icon = Icons.Filled.Lock,
        title = c.name,
        statusLabel = statusLabel ?: "-",
        statusColor = MaterialTheme.colorScheme.primary,
        onClick = null,
    ) {
        StatChip(Icons.Filled.Public, "${c.domainNames.size} dn")
        StatChip(Icons.Filled.Storage, c.type)
    }
}

@Composable
private fun ResourcePlacementGroupCard(pg: CloudPlacementGroup) {
    ResourceCardShell(
        icon = Icons.Filled.Apps,
        title = pg.name,
        statusLabel = pg.type,
        statusColor = MaterialTheme.colorScheme.primary,
        onClick = null,
    ) {
        StatChip(Icons.Filled.Computer, "${pg.servers.size} srv")
    }
}

@Composable
private fun UploadCertificateDialog(
    onDismiss: () -> Unit,
    onUpload: (name: String, cert: String, key: String) -> Unit,
    onRequestManaged: (name: String, domains: List<String>) -> Unit,
) {
    var managed by remember { mutableStateOf(false) }
    var name by remember { mutableStateOf("") }
    var pem by remember { mutableStateOf("") }
    var key by remember { mutableStateOf("") }
    var domains by remember { mutableStateOf("") }
    androidx.compose.material3.AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.cloud_certificate_upload)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Row {
                    androidx.compose.material3.FilterChip(
                        selected = !managed,
                        onClick = { managed = false },
                        label = { Text(stringResource(R.string.cloud_certificate_uploaded)) },
                    )
                    Spacer(Modifier.size(8.dp))
                    androidx.compose.material3.FilterChip(
                        selected = managed,
                        onClick = { managed = true },
                        label = { Text(stringResource(R.string.cloud_certificate_managed)) },
                    )
                }
                androidx.compose.material3.OutlinedTextField(
                    value = name,
                    onValueChange = { name = it },
                    label = { Text(stringResource(R.string.cloud_certificate_name)) },
                    singleLine = true,
                )
                if (managed) {
                    androidx.compose.material3.OutlinedTextField(
                        value = domains,
                        onValueChange = { domains = it },
                        label = { Text(stringResource(R.string.cloud_certificate_domains)) },
                        placeholder = { Text("example.com, www.example.com") },
                        singleLine = false,
                        minLines = 2,
                    )
                } else {
                    androidx.compose.material3.OutlinedTextField(
                        value = pem,
                        onValueChange = { pem = it },
                        label = { Text(stringResource(R.string.cloud_certificate_pem)) },
                        singleLine = false,
                        minLines = 3,
                    )
                    androidx.compose.material3.OutlinedTextField(
                        value = key,
                        onValueChange = { key = it },
                        label = { Text(stringResource(R.string.cloud_certificate_private_key)) },
                        singleLine = false,
                        minLines = 3,
                    )
                }
            }
        },
        confirmButton = {
            androidx.compose.material3.Button(
                enabled = name.isNotBlank() && (
                    if (managed) domains.isNotBlank()
                    else pem.isNotBlank() && key.isNotBlank()
                    ),
                onClick = {
                    if (managed) {
                        onRequestManaged(
                            name.trim(),
                            domains.split(',').map { it.trim() }.filter { it.isNotEmpty() },
                        )
                    } else {
                        onUpload(name.trim(), pem.trim(), key.trim())
                    }
                },
            ) { Text(stringResource(R.string.ok)) }
        },
        dismissButton = {
            androidx.compose.material3.TextButton(onClick = onDismiss) {
                Text(stringResource(R.string.cancel))
            }
        },
    )
}

@Composable
private fun CreatePlacementGroupDialog(
    onDismiss: () -> Unit,
    onCreate: (name: String, type: String) -> Unit,
) {
    var name by remember { mutableStateOf("") }
    androidx.compose.material3.AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.cloud_placement_group_create)) },
        text = {
            androidx.compose.material3.OutlinedTextField(
                value = name,
                onValueChange = { name = it },
                label = { Text(stringResource(R.string.cloud_placement_group_name)) },
                singleLine = true,
            )
        },
        confirmButton = {
            androidx.compose.material3.Button(
                enabled = name.isNotBlank(),
                onClick = { onCreate(name.trim(), "spread") },
            ) { Text(stringResource(R.string.ok)) }
        },
        dismissButton = {
            androidx.compose.material3.TextButton(onClick = onDismiss) {
                Text(stringResource(R.string.cancel))
            }
        },
    )
}
