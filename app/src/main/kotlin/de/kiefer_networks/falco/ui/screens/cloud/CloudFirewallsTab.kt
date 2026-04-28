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
import androidx.compose.ui.res.pluralStringResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudFirewall
import de.kiefer_networks.falco.data.repo.CloudRepo
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

data class CloudFirewallsUiState(
    val loading: Boolean = true,
    val error: String? = null,
    val data: List<CloudFirewall> = emptyList(),
)

@HiltViewModel
class CloudFirewallsViewModel @Inject constructor(private val repo: CloudRepo) : ViewModel() {
    private val _state = MutableStateFlow(CloudFirewallsUiState())
    val state: StateFlow<CloudFirewallsUiState> = _state.asStateFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.value = CloudFirewallsUiState(loading = true)
        runCatching { repo.listFirewalls() }
            .onSuccess { _state.value = CloudFirewallsUiState(loading = false, data = it) }
            .onFailure { _state.value = CloudFirewallsUiState(loading = false, error = it.message ?: "error") }
    }
}

@Composable
fun CloudFirewallsTab(viewModel: CloudFirewallsViewModel = hiltViewModel()) {
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
            items(s.data, key = { it.id }) { firewall -> FirewallCard(firewall) }
        }
    }
}

@Composable
private fun FirewallCard(firewall: CloudFirewall) {
    Card(modifier = Modifier.fillMaxWidth().padding(vertical = 6.dp)) {
        Column(Modifier.padding(12.dp)) {
            Text(firewall.name, style = MaterialTheme.typography.titleMedium)
            Text(
                pluralStringResource(
                    R.plurals.cloud_firewall_rule_count,
                    firewall.rules.size,
                    firewall.rules.size,
                ),
                style = MaterialTheme.typography.bodyMedium,
            )
            Text(
                pluralStringResource(
                    R.plurals.cloud_firewall_applied_count,
                    firewall.appliedTo.size,
                    firewall.appliedTo.size,
                ),
                style = MaterialTheme.typography.bodyMedium,
            )
        }
    }
}
