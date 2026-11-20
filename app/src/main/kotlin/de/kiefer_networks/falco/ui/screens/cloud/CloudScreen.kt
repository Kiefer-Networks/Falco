// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(
    androidx.compose.foundation.ExperimentalFoundationApi::class,
    androidx.compose.material3.ExperimentalMaterial3Api::class,
)
package de.kiefer_networks.falco.ui.screens.cloud

import android.content.Context
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Dns
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material.icons.filled.PowerSettingsNew
import androidx.compose.material.icons.filled.RestartAlt
import androidx.compose.material.icons.filled.Storage
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.ui.components.EmptyState
import de.kiefer_networks.falco.ui.components.ErrorState
import de.kiefer_networks.falco.ui.components.FleetStatusStrip
import de.kiefer_networks.falco.ui.components.LoadingState
import de.kiefer_networks.falco.ui.components.SectionLabel
import de.kiefer_networks.falco.ui.components.StatusDot
import de.kiefer_networks.falco.ui.components.StatusTone
import de.kiefer_networks.falco.ui.components.color
import de.kiefer_networks.falco.ui.components.serverStatusLabel
import de.kiefer_networks.falco.ui.components.serverStatusTone
import de.kiefer_networks.falco.ui.theme.MonoStyle
import de.kiefer_networks.falco.ui.theme.falcoColors
import java.util.Locale

@Composable
fun CloudScreen(
    onOpenServer: (projectId: String?, id: Long) -> Unit = { _, _ -> },
    viewModel: CloudViewModel = hiltViewModel(),
    projectsViewModel: ProjectsViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsState()
    val projectsState by projectsViewModel.state.collectAsState()
    var createOpen by remember { mutableStateOf(false) }
    // Target project of the create sheet; null = active project.
    var createProjectId by remember { mutableStateOf<String?>(null) }
    var chooseProject by remember { mutableStateOf(false) }
    // Power actions from the list cards always ask before running. The
    // server's own project travels along: in aggregate mode it may differ
    // from the active one.
    var pendingAction by remember { mutableStateOf<Triple<CloudViewModel.ServerAction, Long, String?>?>(null) }
    val context = androidx.compose.ui.platform.LocalContext.current
    androidx.compose.runtime.LaunchedEffect(Unit) { viewModel.refresh() }
    androidx.compose.runtime.LaunchedEffect(Unit) {
        viewModel.events.collect { msg ->
            android.widget.Toast.makeText(context, msg, android.widget.Toast.LENGTH_LONG).show()
        }
    }
    Box(modifier = Modifier.fillMaxSize()) {
        when (val s = state) {
            is CloudUiState.Loading -> LoadingState()
            is CloudUiState.Failed -> ErrorState(message = s.message, onRetry = viewModel::refresh)
            is CloudUiState.Loaded -> ServerList(
                servers = s.servers,
                onAction = { action, id, pid ->
                    if (action == CloudViewModel.ServerAction.Snapshot) viewModel.action(action, id, pid)
                    else pendingAction = Triple(action, id, pid)
                },
                onOpen = onOpenServer,
            )
        }
        FloatingActionButton(
            onClick = {
                if (projectsState.aggregateProjects && projectsState.projects.size > 1) {
                    chooseProject = true
                } else {
                    createProjectId = null
                    viewModel.loadCreateOptions()
                    createOpen = true
                }
            },
            modifier = Modifier.align(Alignment.BottomEnd).padding(16.dp),
        ) {
            Icon(Icons.Filled.Add, contentDescription = stringResource(R.string.cloud_server_create))
        }
    }
    if (chooseProject) {
        de.kiefer_networks.falco.ui.components.dialog.ProjectChooserDialog(
            projects = projectsState.projects,
            onDismiss = { chooseProject = false },
            onPick = { id ->
                chooseProject = false
                createProjectId = id
                viewModel.loadCreateOptions(id)
                createOpen = true
            },
        )
    }
    if (createOpen) {
        CreateServerSheet(
            viewModel = viewModel,
            onDismiss = { createOpen = false },
            onCreated = { createOpen = false },
            projectId = createProjectId,
        )
    }
    pendingAction?.let { (action, id, pid) ->
        val label = when (action) {
            CloudViewModel.ServerAction.PowerOn -> stringResource(R.string.action_power_on)
            CloudViewModel.ServerAction.PowerOff -> stringResource(R.string.action_power_off)
            CloudViewModel.ServerAction.Reboot -> stringResource(R.string.action_reboot)
            CloudViewModel.ServerAction.Shutdown -> stringResource(R.string.action_shutdown)
            CloudViewModel.ServerAction.Reset -> stringResource(R.string.action_reset)
            CloudViewModel.ServerAction.Snapshot -> stringResource(R.string.action_snapshot)
        }
        de.kiefer_networks.falco.ui.components.dialog.ConfirmDestructiveDialog(
            actionLabel = label,
            message = stringResource(R.string.confirm_server_action_msg, label),
            onConfirm = { viewModel.action(action, id, pid) },
            onDismiss = { pendingAction = null },
        )
    }
    val rootPassword by viewModel.rootPassword.collectAsState()
    rootPassword?.let { pw ->
        val ctx = androidx.compose.ui.platform.LocalContext.current
        de.kiefer_networks.falco.ui.components.dialog.SecureRevealDialog(
            title = stringResource(R.string.server_root_password_title),
            secret = pw,
            warning = stringResource(R.string.server_root_password_warning),
            onCopy = { copyToClipboard(ctx, "root password", pw) },
            onDismiss = viewModel::dismissRootPassword,
        )
    }
}

@Composable
private fun ServerList(
    servers: List<ProjectAware<CloudServer>>,
    onAction: (CloudViewModel.ServerAction, Long, String?) -> Unit,
    onOpen: (projectId: String?, id: Long) -> Unit,
) {
    if (servers.isEmpty()) {
        EmptyState(
            icon = Icons.Filled.Dns,
            title = stringResource(R.string.cloud_servers),
            body = stringResource(R.string.empty_list),
        )
        return
    }
    val tones = servers.map { serverStatusTone(it.item.status) }
    LazyColumn(
        modifier = Modifier.fillMaxSize(),
        // Bottom padding keeps the last row clear of the FAB.
        contentPadding = PaddingValues(start = 8.dp, end = 8.dp, top = 4.dp, bottom = 88.dp),
    ) {
        item(key = "fleet") {
            FleetStatusStrip(
                running = tones.count { it == StatusTone.Running },
                off = tones.count { it == StatusTone.Off },
                inProgress = tones.count { it == StatusTone.Progress },
                modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
            )
        }
        item(key = "label") {
            SectionLabel(
                text = "${stringResource(R.string.cloud_servers)} · ${servers.size}",
                modifier = Modifier.padding(start = 8.dp, end = 8.dp, top = 16.dp, bottom = 6.dp),
            )
        }
        items(servers, key = { "${it.projectId.orEmpty()}-${it.item.id}" }) { entry ->
            val server = entry.item
            ServerRow(
                server = server,
                onAction = { action, id -> onAction(action, id, entry.projectId) },
                onClick = { onOpen(entry.projectId, server.id) },
            )
        }
    }
}

@Composable
private fun ServerRow(
    server: CloudServer,
    onAction: (CloudViewModel.ServerAction, Long) -> Unit,
    onClick: () -> Unit,
) {
    val context = LocalContext.current
    val tone = serverStatusTone(server.status)
    val ipv4 = server.publicNet?.ipv4?.ip
    val ipLabel = stringResource(R.string.server_label_ipv4)
    val meta = listOfNotNull(
        ipv4 ?: server.publicNet?.ipv6?.ip,
        server.serverType?.name?.uppercase(Locale.ROOT),
        server.location?.name ?: server.datacenter?.location?.name ?: server.datacenter?.name,
    ).joinToString(" · ")
    var menuOpen by remember { mutableStateOf(false) }
    Column {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .heightIn(min = 64.dp)
                .combinedClickable(
                    onClick = onClick,
                    // Long press copies the IPv4 address, like the copy button of the old card.
                    onLongClick = if (ipv4 != null) {
                        { copyToClipboard(context, ipLabel, ipv4) }
                    } else {
                        null
                    },
                )
                .padding(start = 8.dp, top = 8.dp, bottom = 8.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Box(Modifier.width(10.dp), contentAlignment = Alignment.Center) { StatusDot(tone) }
            Spacer(Modifier.width(12.dp))
            Column(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(3.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text(
                        text = server.name,
                        style = MaterialTheme.typography.titleMedium,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis,
                        modifier = Modifier.weight(1f, fill = false),
                    )
                    Text(
                        text = serverStatusLabel(server.status).lowercase(Locale.getDefault()),
                        style = MaterialTheme.typography.bodySmall,
                        color = tone.color(),
                        maxLines = 1,
                    )
                }
                if (meta.isNotBlank()) {
                    Text(
                        text = meta,
                        style = MonoStyle,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis,
                    )
                }
            }
            Box {
                IconButton(onClick = { menuOpen = true }) {
                    Icon(
                        Icons.Filled.MoreVert,
                        contentDescription = stringResource(R.string.cloud_server_quick_actions),
                        tint = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
                DropdownMenu(expanded = menuOpen, onDismissRequest = { menuOpen = false }) {
                    QuickAction(Icons.Filled.RestartAlt, stringResource(R.string.action_reboot)) {
                        menuOpen = false
                        onAction(CloudViewModel.ServerAction.Reboot, server.id)
                    }
                    if (server.status == "running") {
                        QuickAction(Icons.Filled.PowerSettingsNew, stringResource(R.string.action_shutdown)) {
                            menuOpen = false
                            onAction(CloudViewModel.ServerAction.Shutdown, server.id)
                        }
                    } else {
                        QuickAction(Icons.Filled.PowerSettingsNew, stringResource(R.string.action_power_on)) {
                            menuOpen = false
                            onAction(CloudViewModel.ServerAction.PowerOn, server.id)
                        }
                    }
                    QuickAction(Icons.Filled.Storage, stringResource(R.string.action_snapshot)) {
                        menuOpen = false
                        onAction(CloudViewModel.ServerAction.Snapshot, server.id)
                    }
                }
            }
        }
        HorizontalDivider(color = MaterialTheme.falcoColors.divider)
    }
}

@Composable
private fun QuickAction(icon: ImageVector, label: String, onClick: () -> Unit) {
    DropdownMenuItem(
        text = { Text(label) },
        leadingIcon = { Icon(icon, contentDescription = null) },
        onClick = onClick,
    )
}

private fun copyToClipboard(context: Context, label: String, value: String) {
    de.kiefer_networks.falco.ui.util.Clipboard.copySensitive(context, label, value)
}
