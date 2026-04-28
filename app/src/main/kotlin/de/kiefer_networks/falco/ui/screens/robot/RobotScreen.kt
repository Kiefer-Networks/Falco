// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.robot

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.RobotServer
import de.kiefer_networks.falco.data.dto.RobotStorageBox
import de.kiefer_networks.falco.data.repo.RobotRepo
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

data class RobotUiState(
    val loading: Boolean = true,
    val servers: List<RobotServer> = emptyList(),
    val boxes: List<RobotStorageBox> = emptyList(),
    val error: String? = null,
)

@HiltViewModel
class RobotViewModel @Inject constructor(private val repo: RobotRepo) : ViewModel() {
    private val _state = MutableStateFlow(RobotUiState())
    val state: StateFlow<RobotUiState> = _state.asStateFlow()

    init { refresh() }

    fun refresh() {
        viewModelScope.launch {
            _state.value = _state.value.copy(loading = true, error = null)
            runCatching {
                _state.value = RobotUiState(
                    loading = false,
                    servers = repo.listServers(),
                    boxes = repo.listStorageBoxes(),
                )
            }.onFailure { e ->
                _state.value = _state.value.copy(loading = false, error = e.message)
            }
        }
    }
}

@Composable
fun RobotScreen(
    viewModel: RobotViewModel = hiltViewModel(),
    onServerClick: (Long) -> Unit = {},
    onStorageBoxClick: (Long) -> Unit = {},
) {
    val s by viewModel.state.collectAsState()
    if (s.loading) {
        Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) { CircularProgressIndicator() }
        return
    }
    if (s.error != null) {
        Box(Modifier.fillMaxSize().padding(24.dp), contentAlignment = Alignment.Center) { Text(s.error!!) }
        return
    }
    LazyColumn(Modifier.fillMaxSize().padding(12.dp)) {
        item { Section(stringResource(R.string.robot_dedis)) }
        items(s.servers, key = { it.serverNumber }) { server ->
            Card(
                Modifier
                    .fillMaxWidth()
                    .padding(vertical = 6.dp)
                    .clickable { onServerClick(server.serverNumber) },
            ) {
                Column(Modifier.padding(12.dp)) {
                    Text(server.serverName ?: server.serverIp ?: "#${server.serverNumber}",
                        style = MaterialTheme.typography.titleMedium)
                    Text("${server.product ?: ""} • ${server.dc ?: ""}",
                        style = MaterialTheme.typography.bodyMedium)
                }
            }
        }
        item { Section(stringResource(R.string.robot_storageboxes)) }
        items(s.boxes, key = { it.id }) { box ->
            Card(
                Modifier
                    .fillMaxWidth()
                    .padding(vertical = 6.dp)
                    .clickable { onStorageBoxClick(box.id) },
            ) {
                Column(Modifier.padding(12.dp)) {
                    Text(box.name ?: box.login, style = MaterialTheme.typography.titleMedium)
                    Text("${box.product ?: ""} • ${box.location ?: ""}",
                        style = MaterialTheme.typography.bodyMedium)
                }
            }
        }
    }
}

@Composable
private fun Section(title: String) {
    Text(
        text = title,
        style = MaterialTheme.typography.titleLarge,
        modifier = Modifier.padding(top = 12.dp, bottom = 8.dp),
    )
}
