// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.CloudFloatingIp
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.data.repo.CloudRepo
import de.kiefer_networks.falco.data.util.sanitizeError
import de.kiefer_networks.falco.ui.nav.Routes
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

data class CloudFloatingIpDetailUiState(
    val loading: Boolean = true,
    val ip: CloudFloatingIp? = null,
    val servers: List<CloudServer> = emptyList(),
    val running: Boolean = false,
    val error: String? = null,
    val deleted: Boolean = false,
)

sealed interface CloudFloatingIpEvent {
    data class Toast(val text: String) : CloudFloatingIpEvent
    data class Failure(val message: String) : CloudFloatingIpEvent
}

@HiltViewModel
class CloudFloatingIpDetailViewModel @Inject constructor(
    private val repo: CloudRepo,
    savedState: SavedStateHandle,
) : ViewModel() {

    private val ipId: Long = savedState.get<Long>(Routes.ARG_FLOATING_IP_ID)
        ?: error("floating ip id missing")

    private val _state = MutableStateFlow(CloudFloatingIpDetailUiState())
    val state: StateFlow<CloudFloatingIpDetailUiState> = _state.asStateFlow()

    private val _events = MutableSharedFlow<CloudFloatingIpEvent>(extraBufferCapacity = 4)
    val events: SharedFlow<CloudFloatingIpEvent> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.update { it.copy(loading = true, error = null) }
        runCatching { repo.getFloatingIp(ipId) }
            .onSuccess { ip -> _state.update { it.copy(loading = false, ip = ip) } }
            .onFailure { e -> _state.update { it.copy(loading = false, error = sanitizeError(e)) } }
    }

    fun loadServers() = viewModelScope.launch {
        runCatching { repo.listServers() }.onSuccess { servers ->
            _state.update { it.copy(servers = servers) }
        }
    }

    fun rename(name: String) = wrap(refreshAfter = true) { repo.renameFloatingIp(ipId, name) }

    fun delete() = wrap {
        val response = repo.deleteFloatingIp(ipId)
        if (response.isSuccessful) _state.update { it.copy(deleted = true) }
        else error("HTTP ${response.code()}")
    }

    fun assign(serverId: Long) = wrap(refreshAfter = true) { repo.assignFloatingIp(ipId, serverId) }
    fun unassign() = wrap(refreshAfter = true) { repo.unassignFloatingIp(ipId) }
    fun changeReverseDns(ip: String, ptr: String?) = wrap(refreshAfter = true) {
        repo.changeFloatingIpDnsPtr(ipId, ip, ptr)
    }
    fun setProtection(delete: Boolean) = wrap(refreshAfter = true) {
        repo.setFloatingIpProtection(ipId, delete = delete)
    }

    private fun wrap(refreshAfter: Boolean = false, block: suspend () -> Unit) {
        if (_state.value.running) return
        _state.update { it.copy(running = true) }
        viewModelScope.launch {
            runCatching { block() }
                .onSuccess {
                    _events.emit(CloudFloatingIpEvent.Toast("done"))
                    if (refreshAfter) refresh()
                }
                .onFailure { e -> _events.emit(CloudFloatingIpEvent.Failure(sanitizeError(e))) }
            _state.update { it.copy(running = false) }
        }
    }
}
