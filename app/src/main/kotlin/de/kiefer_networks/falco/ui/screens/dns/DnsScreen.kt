// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.dns

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
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.DnsZone
import de.kiefer_networks.falco.data.repo.DnsRepo
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

data class DnsUiState(val loading: Boolean = true, val zones: List<DnsZone> = emptyList(), val error: String? = null)

@HiltViewModel
class DnsViewModel @Inject constructor(private val repo: DnsRepo) : ViewModel() {
    private val _state = MutableStateFlow(DnsUiState())
    val state: StateFlow<DnsUiState> = _state.asStateFlow()
    init { refresh() }
    fun refresh() = viewModelScope.launch {
        _state.value = DnsUiState(loading = true)
        runCatching { repo.listZones() }
            .onSuccess { _state.value = DnsUiState(loading = false, zones = it) }
            .onFailure { _state.value = DnsUiState(loading = false, error = it.message) }
    }
}

@Composable
fun DnsScreen(
    onZoneClick: (String) -> Unit = {},
    viewModel: DnsViewModel = hiltViewModel(),
) {
    val s by viewModel.state.collectAsState()
    when {
        s.loading -> Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) { CircularProgressIndicator() }
        s.error != null -> Box(Modifier.fillMaxSize().padding(24.dp), contentAlignment = Alignment.Center) { Text(s.error!!) }
        else -> LazyColumn(Modifier.fillMaxSize().padding(12.dp)) {
            items(s.zones, key = { it.id }) { zone ->
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 6.dp)
                        .clickable { onZoneClick(zone.id) },
                ) {
                    Column(Modifier.padding(12.dp)) {
                        Text(zone.name, style = MaterialTheme.typography.titleMedium)
                        Text("${zone.recordsCount ?: 0} records", style = MaterialTheme.typography.bodyMedium)
                    }
                }
            }
        }
    }
}
