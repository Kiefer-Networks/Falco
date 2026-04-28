// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.dns

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.CreateDnsRecord
import de.kiefer_networks.falco.data.dto.DnsRecord
import de.kiefer_networks.falco.data.dto.DnsZone
import de.kiefer_networks.falco.data.repo.DnsRepo
import de.kiefer_networks.falco.ui.nav.Routes
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

data class ZoneDetailUiState(
    val loading: Boolean = true,
    val error: String? = null,
    val zone: DnsZone? = null,
    val records: List<DnsRecord> = emptyList(),
)

@HiltViewModel
class ZoneDetailViewModel @Inject constructor(
    private val repo: DnsRepo,
    savedState: SavedStateHandle,
) : ViewModel() {

    val zoneId: String = checkNotNull(savedState.get<String>(Routes.ARG_ZONE_ID)) {
        "Missing ${Routes.ARG_ZONE_ID} argument"
    }

    private val _state = MutableStateFlow(ZoneDetailUiState())
    val state: StateFlow<ZoneDetailUiState> = _state.asStateFlow()

    init { refresh() }

    fun refresh() {
        viewModelScope.launch {
            _state.value = _state.value.copy(loading = true, error = null)
            runCatching {
                val zone = repo.listZones().firstOrNull { it.id == zoneId }
                val records = repo.listRecords(zoneId)
                zone to records
            }.onSuccess { (zone, records) ->
                _state.value = ZoneDetailUiState(
                    loading = false,
                    zone = zone,
                    records = records,
                )
            }.onFailure { e ->
                _state.value = _state.value.copy(loading = false, error = e.message)
            }
        }
    }

    fun createRecord(record: CreateDnsRecord) {
        viewModelScope.launch {
            runCatching { repo.createRecord(record) }
                .onFailure { e -> _state.value = _state.value.copy(error = e.message) }
            refresh()
        }
    }

    fun updateRecord(id: String, record: CreateDnsRecord) {
        viewModelScope.launch {
            // The DnsRepo currently exposes only listRecords/createRecord/deleteRecord,
            // so we emulate update via delete+create to avoid touching the data layer.
            runCatching {
                repo.deleteRecord(id)
                repo.createRecord(record)
            }.onFailure { e -> _state.value = _state.value.copy(error = e.message) }
            refresh()
        }
    }

    fun deleteRecord(id: String) {
        viewModelScope.launch {
            runCatching { repo.deleteRecord(id) }
                .onFailure { e -> _state.value = _state.value.copy(error = e.message) }
            refresh()
        }
    }
}
