// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.data.dto.CloudVolume
import de.kiefer_networks.falco.data.repo.CloudRepo
import de.kiefer_networks.falco.ui.nav.Routes
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import de.kiefer_networks.falco.data.util.sanitizeError
import javax.inject.Inject

data class CloudVolumeDetailUiState(
    val loading: Boolean = true,
    val volume: CloudVolume? = null,
    val servers: List<CloudServer> = emptyList(),
    val running: Boolean = false,
    val error: String? = null,
    val deleted: Boolean = false,
)

sealed interface CloudVolumeEvent {
    data class Toast(val text: String) : CloudVolumeEvent
    data class Failure(val message: String) : CloudVolumeEvent
}

@HiltViewModel
class CloudVolumeDetailViewModel @Inject constructor(
    private val repo: CloudRepo,
    savedState: SavedStateHandle,
) : ViewModel() {

    private val volumeId: Long = savedState.get<Long>(Routes.ARG_VOLUME_ID)
        ?: error("volume id missing")

    private val _state = MutableStateFlow(CloudVolumeDetailUiState())
    val state: StateFlow<CloudVolumeDetailUiState> = _state.asStateFlow()

    private val _events = MutableSharedFlow<CloudVolumeEvent>(extraBufferCapacity = 4)
    val events: SharedFlow<CloudVolumeEvent> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.update { it.copy(loading = true, error = null) }
        runCatching { repo.getVolume(volumeId) }
            .onSuccess { v -> _state.update { it.copy(loading = false, volume = v) } }
            .onFailure { e -> _state.update { it.copy(loading = false, error = sanitizeError(e)) } }
    }

    fun loadServers() = viewModelScope.launch {
        runCatching { repo.listServers() }.onSuccess { servers ->
            _state.update { it.copy(servers = servers) }
        }
    }

    fun rename(newName: String) = wrap(refreshAfter = true) { repo.renameVolume(volumeId, newName) }

    fun delete() = wrap {
        val response = repo.deleteVolume(volumeId)
        if (response.isSuccessful) {
            _state.update { it.copy(deleted = true) }
        } else {
            error("HTTP ${response.code()}")
        }
    }

    fun attach(serverId: Long, automount: Boolean) = wrap(refreshAfter = true) {
        repo.attachVolume(volumeId, serverId, automount)
    }

    fun detach() = wrap(refreshAfter = true) { repo.detachVolume(volumeId) }

    fun resize(newSize: Int) = wrap(refreshAfter = true) { repo.resizeVolume(volumeId, newSize) }

    fun setProtection(delete: Boolean) = wrap(refreshAfter = true) {
        repo.setVolumeProtection(volumeId, delete = delete)
    }

    private fun wrap(refreshAfter: Boolean = false, block: suspend () -> Unit) {
        if (_state.value.running) return
        _state.update { it.copy(running = true) }
        viewModelScope.launch {
            runCatching { block() }
                .onSuccess {
                    _events.emit(CloudVolumeEvent.Toast("done"))
                    if (refreshAfter) refresh()
                }
                .onFailure { e -> _events.emit(CloudVolumeEvent.Failure(sanitizeError(e))) }
            _state.update { it.copy(running = false) }
        }
    }
}
