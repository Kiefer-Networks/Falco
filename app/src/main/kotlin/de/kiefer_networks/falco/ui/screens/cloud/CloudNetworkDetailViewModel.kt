// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.CloudNetwork
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

data class CloudNetworkDetailUiState(
    val loading: Boolean = true,
    val network: CloudNetwork? = null,
    val running: Boolean = false,
    val error: String? = null,
    val deleted: Boolean = false,
)

sealed interface CloudNetworkEvent {
    data class Toast(val text: String) : CloudNetworkEvent
    data class Failure(val message: String) : CloudNetworkEvent
}

@HiltViewModel
class CloudNetworkDetailViewModel @Inject constructor(
    private val repo: CloudRepo,
    savedState: SavedStateHandle,
) : ViewModel() {

    private val networkId: Long = savedState.get<Long>(Routes.ARG_CLOUD_NETWORK_ID)
        ?: error("network id missing")

    private val _state = MutableStateFlow(CloudNetworkDetailUiState())
    val state: StateFlow<CloudNetworkDetailUiState> = _state.asStateFlow()

    private val _events = MutableSharedFlow<CloudNetworkEvent>(extraBufferCapacity = 4)
    val events: SharedFlow<CloudNetworkEvent> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.update { it.copy(loading = true, error = null) }
        runCatching { repo.getNetwork(networkId) }
            .onSuccess { n -> _state.update { it.copy(loading = false, network = n) } }
            .onFailure { e -> _state.update { it.copy(loading = false, error = sanitizeError(e)) } }
    }

    fun rename(newName: String) = wrap(refreshAfter = true) {
        repo.renameNetwork(networkId, newName)
    }

    fun delete() = wrap {
        val response = repo.deleteNetwork(networkId)
        if (response.isSuccessful) {
            _state.update { it.copy(deleted = true) }
        } else {
            error("HTTP ${response.code()}")
        }
    }

    fun setProtection(delete: Boolean) = wrap(refreshAfter = true) {
        repo.setNetworkProtection(networkId, delete = delete)
    }

    fun changeIpRange(ipRange: String) = wrap(refreshAfter = true) {
        repo.changeNetworkIpRange(networkId, ipRange)
    }

    fun addSubnet(type: String, networkZone: String, ipRange: String?) = wrap(refreshAfter = true) {
        repo.addNetworkSubnet(networkId, type = type, networkZone = networkZone, ipRange = ipRange)
    }

    fun deleteSubnet(ipRange: String) = wrap(refreshAfter = true) {
        repo.deleteNetworkSubnet(networkId, ipRange)
    }

    fun addRoute(destination: String, gateway: String) = wrap(refreshAfter = true) {
        repo.addNetworkRoute(networkId, destination, gateway)
    }

    fun deleteRoute(destination: String, gateway: String) = wrap(refreshAfter = true) {
        repo.deleteNetworkRoute(networkId, destination, gateway)
    }

    fun exposeToVSwitch(vswitchId: Long, expose: Boolean = true) = wrap(refreshAfter = true) {
        repo.exposeNetworkToVSwitch(networkId, vswitchId, expose)
    }

    private fun wrap(refreshAfter: Boolean = false, block: suspend () -> Unit) {
        if (_state.value.running) return
        _state.update { it.copy(running = true) }
        viewModelScope.launch {
            runCatching { block() }
                .onSuccess {
                    _events.emit(CloudNetworkEvent.Toast("done"))
                    if (refreshAfter) refresh()
                }
                .onFailure { e -> _events.emit(CloudNetworkEvent.Failure(sanitizeError(e))) }
            _state.update { it.copy(running = false) }
        }
    }
}
