// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

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
import de.kiefer_networks.falco.data.dto.CloudFloatingIp
import de.kiefer_networks.falco.data.repo.CloudRepo
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

data class CloudFloatingIpsUiState(
    val loading: Boolean = true,
    val error: String? = null,
    val data: List<CloudFloatingIp> = emptyList(),
)

@HiltViewModel
class CloudFloatingIpsViewModel @Inject constructor(private val repo: CloudRepo) : ViewModel() {
    private val _state = MutableStateFlow(CloudFloatingIpsUiState())
    val state: StateFlow<CloudFloatingIpsUiState> = _state.asStateFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.value = CloudFloatingIpsUiState(loading = true)
        runCatching { repo.listFloatingIps() }
            .onSuccess { _state.value = CloudFloatingIpsUiState(loading = false, data = it) }
            .onFailure { _state.value = CloudFloatingIpsUiState(loading = false, error = it.message ?: "error") }
    }
}

@Composable
fun CloudFloatingIpsTab(viewModel: CloudFloatingIpsViewModel = hiltViewModel()) {
    val s by viewModel.state.collectAsState()
    when {
        s.loading -> Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            CircularProgressIndicator()
        }
        s.error != null -> Box(
            Modifier.fillMaxSize().padding(24.dp),
            contentAlignment = Alignment.Center,
        ) {
            Text(s.error!!, style = MaterialTheme.typography.bodyLarge)
        }
        s.data.isEmpty() -> Box(
            Modifier.fillMaxSize().padding(24.dp),
            contentAlignment = Alignment.Center,
        ) {
            Text(stringResource(R.string.empty_list))
        }
        else -> LazyColumn(Modifier.fillMaxSize().padding(12.dp)) {
            items(s.data, key = { it.id }) { fip -> FloatingIpCard(fip) }
        }
    }
}

@Composable
private fun FloatingIpCard(fip: CloudFloatingIp) {
    Card(modifier = Modifier.fillMaxWidth().padding(vertical = 6.dp)) {
        Column(Modifier.padding(12.dp)) {
            Text(fip.ip, style = MaterialTheme.typography.titleMedium)
            Text(
                stringResource(R.string.cloud_floating_ip_type, fip.type),
                style = MaterialTheme.typography.bodyMedium,
            )
            fip.description?.takeIf { it.isNotBlank() }?.let {
                Text(it, style = MaterialTheme.typography.bodyMedium)
            }
            fip.server?.let {
                Text(
                    stringResource(R.string.cloud_attached_server, it),
                    style = MaterialTheme.typography.bodyMedium,
                )
            }
            fip.homeLocation?.let { loc ->
                Text(
                    stringResource(
                        R.string.cloud_home_location,
                        loc.city ?: loc.name,
                    ),
                    style = MaterialTheme.typography.bodyMedium,
                )
            }
        }
    }
}
