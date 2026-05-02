// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.dns

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.CreateDnsRecord
import de.kiefer_networks.falco.data.dto.DnsPrimaryServer
import de.kiefer_networks.falco.data.dto.DnsRecord
import de.kiefer_networks.falco.data.dto.DnsValidateResponse
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
    val primaryServers: List<DnsPrimaryServer> = emptyList(),
    val primaryServersLoading: Boolean = false,
)

/**
 * One-shot UI events: BIND export string, validation result, transient
 * snackbar messages. These are not state — replaying them on configuration
 * change would re-trigger the SAF writer or duplicate snackbars.
 */
sealed interface ZoneDetailEvent {
    data class ExportReady(val text: String, val suggestedName: String) : ZoneDetailEvent
    data class ValidationReady(val result: DnsValidateResponse, val bindText: String) : ZoneDetailEvent
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
        refreshPrimaryServers()
    }

    fun refresh() {
        viewModelScope.launch {
            _state.value = _state.value.copy(loading = true, error = null)
            runCatching {
                val zone = repo.listZones().firstOrNull { it.id == zoneId }
                val records = repo.listRecords(zoneId)
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

    fun createRecord(record: CreateDnsRecord) {
        viewModelScope.launch {
            runCatching { repo.createRecord(record) }
                .onFailure { e -> _state.value = _state.value.copy(error = sanitizeError(e)) }
            refresh()
        }
    }

    fun updateRecord(id: String, record: CreateDnsRecord) {
        viewModelScope.launch {
            runCatching { repo.updateRecord(id, record) }
                .onFailure { e -> _state.value = _state.value.copy(error = sanitizeError(e)) }
            refresh()
        }
    }

    fun deleteRecord(id: String) {
        viewModelScope.launch {
            runCatching { repo.deleteRecord(id) }
                .onFailure { e -> _state.value = _state.value.copy(error = sanitizeError(e)) }
            refresh()
        }
    }

    // ---- Bulk edit ------------------------------------------------------

    /**
     * Apply [newValue] and/or [newTtl] to every record in [selectedIds] and
     * push the patched list through `bulkUpdateRecords`. Records keep their
     * other fields (name/type/zoneId) untouched.
     */
    fun applyBulkEdit(selectedIds: Set<String>, newValue: String?, newTtl: Int?) {
        viewModelScope.launch {
            val patched = _state.value.records
                .filter { it.id != null && it.id in selectedIds }
                .map { rec ->
                    rec.copy(
                        value = newValue ?: rec.value,
                        ttl = newTtl ?: rec.ttl,
                    )
                }
            if (patched.isEmpty()) return@launch
            runCatching { repo.bulkUpdateRecords(patched) }
                .onSuccess { resp ->
                    val failed = resp.failedRecords.size
                    if (failed > 0) {
                        _events.emit(ZoneDetailEvent.BulkFailed(failed))
                    } else {
                        _events.emit(ZoneDetailEvent.BulkSucceeded)
                    }
                }
                .onFailure { e -> _state.value = _state.value.copy(error = sanitizeError(e)) }
            refresh()
        }
    }

    // ---- Import / Export -----------------------------------------------

    /**
     * Validate a BIND zone file before import. The repo enforces the 1 MiB cap
     * locally; we surface that as a friendly snack instead of a stack trace.
     */
    fun validateBind(bindText: String) {
        viewModelScope.launch {
            runCatching { repo.validateZone(zoneId, bindText) }
                .onSuccess { result ->
                    _events.emit(ZoneDetailEvent.ValidationReady(result, bindText))
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

    fun refreshPrimaryServers() {
        viewModelScope.launch {
            _state.value = _state.value.copy(primaryServersLoading = true)
            runCatching { repo.listPrimaryServers(zoneId) }
                .onSuccess { list ->
                    _state.value = _state.value.copy(
                        primaryServers = list,
                        primaryServersLoading = false,
                    )
                }
                .onFailure { e ->
                    _state.value = _state.value.copy(
                        primaryServersLoading = false,
                        error = sanitizeError(e),
                    )
                }
        }
    }

    fun addPrimaryServer(address: String, port: Int) {
        viewModelScope.launch {
            runCatching { repo.createPrimaryServer(address, port, zoneId) }
                .onFailure { e -> _state.value = _state.value.copy(error = sanitizeError(e)) }
            refreshPrimaryServers()
        }
    }

    fun updatePrimaryServer(id: String, address: String, port: Int) {
        viewModelScope.launch {
            runCatching { repo.updatePrimaryServer(id, address, port, zoneId) }
                .onFailure { e -> _state.value = _state.value.copy(error = sanitizeError(e)) }
            refreshPrimaryServers()
        }
    }

    fun deletePrimaryServer(id: String) {
        viewModelScope.launch {
            runCatching { repo.deletePrimaryServer(id) }
                .onFailure { e -> _state.value = _state.value.copy(error = sanitizeError(e)) }
            refreshPrimaryServers()
        }
    }

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
