// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

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
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R

@Composable
fun CloudScreen(viewModel: CloudViewModel = hiltViewModel()) {
    val state by viewModel.state.collectAsState()
    when (val s = state) {
        is CloudUiState.Loading -> Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            CircularProgressIndicator()
        }
        is CloudUiState.Failed -> Box(Modifier.fillMaxSize().padding(24.dp), contentAlignment = Alignment.Center) {
            Text(text = s.message, style = MaterialTheme.typography.bodyLarge)
        }
        is CloudUiState.Loaded -> ServerList(
            servers = s,
            onAction = { action, id -> viewModel.action(action, id) },
        )
    }
}

@Composable
private fun ServerList(
    servers: CloudUiState.Loaded,
    onAction: (CloudViewModel.ServerAction, Long) -> Unit,
) {
    if (servers.servers.isEmpty()) {
        Box(Modifier.fillMaxSize().padding(24.dp), contentAlignment = Alignment.Center) {
            Text(stringResource(R.string.empty_list))
        }
        return
    }
    LazyColumn(modifier = Modifier.fillMaxSize().padding(12.dp)) {
        items(servers.servers, key = { it.id }) { server ->
            Card(modifier = Modifier.fillMaxWidth().padding(vertical = 6.dp)) {
                Column(Modifier.padding(12.dp)) {
                    Text(server.name, style = MaterialTheme.typography.titleMedium)
                    Text(
                        listOfNotNull(
                            server.serverType?.name,
                            server.publicNet?.ipv4?.ip,
                            server.datacenter?.location?.city,
                        ).joinToString(" • "),
                        style = MaterialTheme.typography.bodyMedium,
                    )
                    Text("Status: ${server.status}", style = MaterialTheme.typography.bodyMedium)
                    Spacer(Modifier.height(8.dp))
                    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        OutlinedButton(onClick = { onAction(CloudViewModel.ServerAction.Reboot, server.id) }) {
                            Text(stringResource(R.string.action_reboot))
                        }
                        if (server.status == "running") {
                            OutlinedButton(onClick = { onAction(CloudViewModel.ServerAction.Shutdown, server.id) }) {
                                Text(stringResource(R.string.action_shutdown))
                            }
                        } else {
                            OutlinedButton(onClick = { onAction(CloudViewModel.ServerAction.PowerOn, server.id) }) {
                                Text(stringResource(R.string.action_power_on))
                            }
                        }
                    }
                }
            }
        }
    }
}
