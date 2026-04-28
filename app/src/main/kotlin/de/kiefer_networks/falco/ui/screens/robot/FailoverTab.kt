// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.robot

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
import de.kiefer_networks.falco.data.dto.RobotFailover
import de.kiefer_networks.falco.data.repo.RobotRepo
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

data class FailoverUiState(
    val loading: Boolean = true,
    val items: List<RobotFailover> = emptyList(),
    val error: String? = null,
)

@HiltViewModel
class FailoverViewModel @Inject constructor(private val repo: RobotRepo) : ViewModel() {
    private val _state = MutableStateFlow(FailoverUiState())
    val state: StateFlow<FailoverUiState> = _state.asStateFlow()

    init { refresh() }

    fun refresh() {
        viewModelScope.launch {
            _state.value = FailoverUiState(loading = true)
            runCatching { repo.listFailoverIps() }
                .onSuccess { _state.value = FailoverUiState(loading = false, items = it) }
                .onFailure { _state.value = FailoverUiState(loading = false, error = it.message) }
        }
    }
}

@Composable
fun FailoverTab(viewModel: FailoverViewModel = hiltViewModel()) {
    val s by viewModel.state.collectAsState()
    when {
        s.loading -> Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) { CircularProgressIndicator() }
        s.error != null -> Box(Modifier.fillMaxSize().padding(24.dp), contentAlignment = Alignment.Center) {
            Text(s.error!!)
        }
        s.items.isEmpty() -> Box(Modifier.fillMaxSize().padding(24.dp), contentAlignment = Alignment.Center) {
            Text(stringResource(R.string.empty_list))
        }
        else -> LazyColumn(Modifier.fillMaxSize().padding(12.dp)) {
            items(s.items, key = { it.ip }) { fo ->
                Card(Modifier.fillMaxWidth().padding(vertical = 6.dp)) {
                    Column(Modifier.padding(12.dp)) {
                        Text(fo.ip, style = MaterialTheme.typography.titleMedium)
                        Text(
                            "→ #${fo.serverNumber} (${fo.serverIp})",
                            style = MaterialTheme.typography.bodyMedium,
                        )
                        Text(
                            stringResource(R.string.robot_failover_active_on, fo.activeServerIp),
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.primary,
                        )
                    }
                }
            }
        }
    }
}
