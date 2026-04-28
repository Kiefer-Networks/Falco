// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.robot

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Tab
import androidx.compose.material3.TabRow
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.RobotSnapshot
import de.kiefer_networks.falco.data.dto.RobotSubaccount
import kotlinx.coroutines.launch

@Composable
fun StorageBoxDetailScreen(viewModel: StorageBoxDetailViewModel = hiltViewModel()) {
    val state by viewModel.state.collectAsState()
    val event by viewModel.events.collectAsState()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    var showSnapshotDialog by remember { mutableStateOf(false) }
    var selectedTab by remember { mutableIntStateOf(0) }

    val doneMsg = stringResource(R.string.robot_action_done)
    val failedFmt = stringResource(R.string.robot_action_failed)

    LaunchedEffect(event) {
        event?.let {
            val msg = when (it) {
                is ServerActionResult.Success -> it.message
                is ServerActionResult.Failure -> it.message
            }
            scope.launch { snackbarHostState.showSnackbar(msg) }
            viewModel.consumeEvent()
        }
    }

    Scaffold(snackbarHost = { SnackbarHost(snackbarHostState) }) { padding ->
        Box(Modifier.fillMaxSize().padding(padding)) {
            when {
                state.loading -> Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    CircularProgressIndicator()
                }
                state.error != null -> Box(
                    Modifier.fillMaxSize().padding(24.dp),
                    contentAlignment = Alignment.Center,
                ) { Text(state.error!!) }
                state.box == null -> Box(
                    Modifier.fillMaxSize().padding(24.dp),
                    contentAlignment = Alignment.Center,
                ) { Text(stringResource(R.string.empty_list)) }
                else -> {
                    val box = state.box!!
                    Column(Modifier.fillMaxSize()) {
                        Column(Modifier.padding(16.dp)) {
                            Text(
                                box.name ?: box.login,
                                style = MaterialTheme.typography.titleLarge,
                            )
                            Spacer(Modifier.height(8.dp))
                            Card(Modifier.fillMaxWidth()) {
                                Column(Modifier.padding(12.dp)) {
                                    DetailRow(stringResource(R.string.robot_field_login), box.login)
                                    box.product?.let { DetailRow(stringResource(R.string.robot_field_product), it) }
                                    box.location?.let { DetailRow(stringResource(R.string.robot_field_location), it) }
                                    box.paidUntil?.let { DetailRow(stringResource(R.string.robot_field_paid_until), it) }
                                    if (box.diskQuota != null || box.diskUsage != null) {
                                        DetailRow(
                                            stringResource(R.string.robot_field_disk),
                                            stringResource(
                                                R.string.robot_disk_value,
                                                box.diskUsage ?: 0L,
                                                box.diskQuota ?: 0L,
                                            ),
                                        )
                                    }
                                    DetailRow(
                                        stringResource(R.string.robot_field_protocols),
                                        formatProtocols(box.webdav, box.samba, box.ssh, box.zfs),
                                    )
                                }
                            }
                        }
                        TabRow(selectedTabIndex = selectedTab) {
                            Tab(
                                selected = selectedTab == 0,
                                onClick = { selectedTab = 0 },
                                text = { Text(stringResource(R.string.storagebox_snapshots)) },
                            )
                            Tab(
                                selected = selectedTab == 1,
                                onClick = { selectedTab = 1 },
                                text = { Text(stringResource(R.string.storagebox_subaccounts)) },
                            )
                        }
                        when (selectedTab) {
                            0 -> SnapshotsSection(
                                snapshots = state.snapshots,
                                running = state.running,
                                onCreate = { showSnapshotDialog = true },
                            )
                            1 -> SubaccountsSection(state.subaccounts)
                        }
                    }
                }
            }
        }
    }

    if (showSnapshotDialog) {
        AlertDialog(
            onDismissRequest = { showSnapshotDialog = false },
            title = { Text(stringResource(R.string.robot_create_snapshot)) },
            text = { Text(stringResource(R.string.robot_create_snapshot_confirm)) },
            confirmButton = {
                Button(onClick = {
                    showSnapshotDialog = false
                    viewModel.createSnapshot(
                        successMsg = doneMsg,
                        failureFmt = { msg -> failedFmt.format(msg) },
                    )
                }) { Text(stringResource(R.string.ok)) }
            },
            dismissButton = {
                TextButton(onClick = { showSnapshotDialog = false }) {
                    Text(stringResource(R.string.cancel))
                }
            },
        )
    }
}

@Composable
private fun SnapshotsSection(
    snapshots: List<RobotSnapshot>,
    running: Boolean,
    onCreate: () -> Unit,
) {
    Column(Modifier.fillMaxSize().padding(16.dp)) {
        Row(
            Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Button(onClick = onCreate, enabled = !running) {
                Text(stringResource(R.string.robot_create_snapshot))
            }
            if (running) {
                Text(
                    stringResource(R.string.robot_action_running),
                    style = MaterialTheme.typography.bodyMedium,
                )
            }
        }
        Spacer(Modifier.height(12.dp))
        if (snapshots.isEmpty()) {
            Box(Modifier.fillMaxWidth().padding(24.dp), contentAlignment = Alignment.Center) {
                Text(stringResource(R.string.empty_list))
            }
        } else {
            LazyColumn(Modifier.fillMaxSize()) {
                items(snapshots, key = { it.name }) { snap ->
                    Card(Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
                        Column(Modifier.padding(12.dp)) {
                            Text(snap.name, style = MaterialTheme.typography.titleMedium)
                            Text(snap.timestamp, style = MaterialTheme.typography.bodyMedium)
                            val sizeText = snap.size?.let { "$it" } ?: "-"
                            val fs = snap.filesystem ?: "-"
                            Text(
                                stringResource(R.string.robot_snapshot_meta, sizeText, fs),
                                style = MaterialTheme.typography.bodyMedium,
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun SubaccountsSection(subaccounts: List<RobotSubaccount>) {
    Column(Modifier.fillMaxSize().padding(16.dp)) {
        if (subaccounts.isEmpty()) {
            Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                Text(stringResource(R.string.empty_list))
            }
        } else {
            LazyColumn(Modifier.fillMaxSize()) {
                items(subaccounts, key = { it.username }) { sa ->
                    Card(Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
                        Column(Modifier.padding(12.dp)) {
                            Text(sa.username, style = MaterialTheme.typography.titleMedium)
                            sa.homeDirectory?.let {
                                Text(it, style = MaterialTheme.typography.bodyMedium)
                            }
                            Text(
                                formatProtocols(sa.webdav, sa.samba, sa.ssh, null),
                                style = MaterialTheme.typography.bodyMedium,
                            )
                            sa.comment?.takeIf { it.isNotBlank() }?.let {
                                Text(it, style = MaterialTheme.typography.bodyMedium)
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun DetailRow(label: String, value: String) {
    Row(Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
        Text(
            text = label,
            style = MaterialTheme.typography.bodyMedium,
            modifier = Modifier.padding(end = 12.dp),
        )
        Text(text = value, style = MaterialTheme.typography.bodyMedium)
    }
}

private fun formatProtocols(webdav: Boolean?, samba: Boolean?, ssh: Boolean?, zfs: Boolean?): String {
    val parts = buildList {
        if (webdav == true) add("WebDAV")
        if (samba == true) add("Samba")
        if (ssh == true) add("SSH")
        if (zfs == true) add("ZFS")
    }
    return if (parts.isEmpty()) "-" else parts.joinToString(", ")
}
