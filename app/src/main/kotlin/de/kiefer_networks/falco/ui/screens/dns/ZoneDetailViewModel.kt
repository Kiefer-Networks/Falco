// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.dns

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.CreateDnsRecord
import de.kiefer_networks.falco.data.dto.DnsPrimaryServer
import de.kiefer_networks.falco.data.dto.DnsRecord
import de.kiefer_networks.falco.data.dto.DnsZone
import de.kiefer_networks.falco.data.repo.BindFileTooLargeException
import de.kiefer_networks.falco.data.repo.DnsRepo
import de.kiefer_networks.falco.data.util.sanitizeError
import de.kiefer_networks.falco.ui.nav.Routes
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

data class ZoneDetailUiState(
    val loading: Boolean = true,
    val error: String? = null,
    val zone: DnsZone? = null,
    val records: List<DnsRecord> = emptyList(),
    val busy: Boolean = false,
) {
    val primaryServers: List<DnsPrimaryServer> get() = zone?.primaryNameservers.orEmpty()
    val isSecondary: Boolean get() = zone?.mode == "secondary"
}

/**
 * One-shot UI events: BIND export string, validation result, transient
 * snackbar messages. These are not state — replaying them on configuration
 * change would re-trigger the SAF writer or duplicate snackbars.
 */
sealed interface ZoneDetailEvent {
    data class ExportReady(val text: String, val suggestedName: String) : ZoneDetailEvent
    data class SnackMessage(val message: String) : ZoneDetailEvent
    data object ImportSucceeded : ZoneDetailEvent
    data object BulkSucceeded : ZoneDetailEvent
    data class BulkFailed(val failedCount: Int) : ZoneDetailEvent
}

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

    private val _events = MutableSharedFlow<ZoneDetailEvent>(extraBufferCapacity = 4)
    val events: SharedFlow<ZoneDetailEvent> = _events.asSharedFlow()

    init {
        refresh()
    }

    fun refresh() {
        viewModelScope.launch {
            _state.value = _state.value.copy(loading = true, error = null)
            runCatching {
                val zone = repo.getZone(zoneId)
                // RRSets exist only for primary zones; secondary zones are AXFR copies.
                val records = if (zone.mode == "secondary") emptyList() else repo.listRecords(zoneId)
                zone to records
            }.onSuccess { (zone, records) ->
                _state.value = _state.value.copy(
                    loading = false,
                    zone = zone,
                    records = records,
                )
            }.onFailure { e ->
                _state.value = _state.value.copy(loading = false, error = sanitizeError(e))
            }
        }
    }

    /** Runs a mutation, surfaces errors, then reloads. Actions are awaited in the repo. */
    private fun mutate(block: suspend () -> Unit) {
        viewModelScope.launch {
            _state.value = _state.value.copy(busy = true)
            runCatching { block() }
                .onFailure { e -> _events.emit(ZoneDetailEvent.SnackMessage(sanitizeError(e))) }
            _state.value = _state.value.copy(busy = false)
            refresh()
        }
    }

    fun createRecord(record: CreateDnsRecord) = mutate { repo.createRecord(record) }

    fun updateRecord(old: DnsRecord, record: CreateDnsRecord) =
        mutate { repo.updateRecord(old, record, _state.value.records) }

    fun deleteRecord(record: DnsRecord) = mutate { repo.deleteRecord(record) }

    // ---- Bulk edit ------------------------------------------------------

    /**
     * Apply [newValue] and/or [newTtl] to the records in [selectedIds]. TTL is
     * per RRSet in the Cloud API, so it applies to the whole RRSet.
     */
    fun applyBulkEdit(selectedIds: Set<String>, newValue: String?, newTtl: Int?) {
        val all = _state.value.records
        val selected = all.filter { it.id != null && it.id in selectedIds }
        if (selected.isEmpty()) return
        mutate {
            val failed = repo.bulkEdit(all, selected, newValue, newTtl)
            _events.emit(if (failed > 0) ZoneDetailEvent.BulkFailed(failed) else ZoneDetailEvent.BulkSucceeded)
        }
    }

    // ---- Import / Export -----------------------------------------------

    fun importBind(bindText: String) {
        viewModelScope.launch {
            runCatching { repo.importZoneFile(zoneId, bindText) }
                .onSuccess {
                    _events.emit(ZoneDetailEvent.ImportSucceeded)
                    refresh()
                }
                .onFailure { e ->
                    when (e) {
                        is BindFileTooLargeException ->
                            _events.emit(ZoneDetailEvent.SnackMessage(BIND_TOO_LARGE))
                        else ->
                            _events.emit(ZoneDetailEvent.SnackMessage(sanitizeError(e)))
                    }
                }
        }
    }

    fun exportBind() {
        viewModelScope.launch {
            runCatching { repo.exportZone(zoneId) }
                .onSuccess { text ->
                    val suggested = (_state.value.zone?.name ?: zoneId) + ".zone"
                    _events.emit(ZoneDetailEvent.ExportReady(text, suggested))
                }
                .onFailure { e ->
                    _events.emit(ZoneDetailEvent.SnackMessage(sanitizeError(e)))
                }
        }
    }

    // ---- Primary servers ------------------------------------------------

    /** Primary nameservers are replaced as a whole list via change_primary_nameservers. */
    private fun setPrimaryServers(transform: (List<DnsPrimaryServer>) -> List<DnsPrimaryServer>) {
        val next = transform(_state.value.primaryServers)
        mutate { repo.setPrimaryServers(zoneId, next) }
    }

    fun addPrimaryServer(address: String, port: Int) =
        setPrimaryServers { it + DnsPrimaryServer(address = address, port = port) }

    fun updatePrimaryServer(id: String, address: String, port: Int) =
        setPrimaryServers { list -> list.map { if (it.id == id) it.copy(address = address, port = port) else it } }

    fun deletePrimaryServer(id: String) = setPrimaryServers { list -> list.filterNot { it.id == id } }

    private companion object {
        // Sentinel marker the screen swaps for the localised string. Kept here
        // so the VM stays free of Android resource lookups.
        const val BIND_TOO_LARGE = "__BIND_TOO_LARGE__"
    }
}

/**
 * Used by the screen to recognise the locale-independent placeholder emitted
 * when the BIND file exceeds the 1 MiB cap; the screen rewrites it through
 * `stringResource(R.string.dns_import_too_large)`.
 */
internal const val ZONE_DETAIL_BIND_TOO_LARGE = "__BIND_TOO_LARGE__"
