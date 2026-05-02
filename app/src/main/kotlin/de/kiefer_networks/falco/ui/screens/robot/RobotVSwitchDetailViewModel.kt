// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.robot

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.RobotServer
import de.kiefer_networks.falco.data.dto.RobotVSwitch
import de.kiefer_networks.falco.data.repo.RobotRepo
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

data class RobotVSwitchDetailUiState(
    val loading: Boolean = true,
    val vswitch: RobotVSwitch? = null,
    val servers: List<RobotServer> = emptyList(),
    val running: Boolean = false,
    val error: String? = null,
    val deleted: Boolean = false,
)

sealed interface RobotVSwitchEvent {
    data class Toast(val text: String) : RobotVSwitchEvent
    data class Failure(val message: String) : RobotVSwitchEvent
}

@HiltViewModel
class RobotVSwitchDetailViewModel @Inject constructor(
    private val repo: RobotRepo,
    savedState: SavedStateHandle,
) : ViewModel() {

    private val vswitchId: Long = checkNotNull(
        savedState.get<Long>(Routes.ARG_VSWITCH_ID)
            ?: savedState.get<String>(Routes.ARG_VSWITCH_ID)?.toLongOrNull(),
    ) { "Missing ${Routes.ARG_VSWITCH_ID} argument" }

    private val _state = MutableStateFlow(RobotVSwitchDetailUiState())
    val state: StateFlow<RobotVSwitchDetailUiState> = _state.asStateFlow()

    private val _events = MutableSharedFlow<RobotVSwitchEvent>(extraBufferCapacity = 4)
    val events: SharedFlow<RobotVSwitchEvent> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() {
        viewModelScope.launch {
            _state.update { it.copy(loading = true, error = null) }
            runCatching { repo.getVSwitch(vswitchId) }
                .onSuccess { vs -> _state.update { it.copy(loading = false, vswitch = vs) } }
                .onFailure { e -> _state.update { it.copy(loading = false, error = sanitizeError(e)) } }
        }
    }

    fun loadServers() = viewModelScope.launch {
        runCatching { repo.listServers() }.onSuccess { servers ->
            _state.update { it.copy(servers = servers) }
        }
    }

    fun update(name: String, vlan: Int) = wrap(refreshAfter = true) {
        repo.updateVSwitch(vswitchId, name, vlan)
    }

    fun delete(cancellationDate: String?) = wrap {
        val response = repo.deleteVSwitch(vswitchId, cancellationDate)
        if (response.isSuccessful) {
            _state.update { it.copy(deleted = true) }
        } else {
            error("HTTP ${response.code()}")
        }
    }

    fun attachServer(serverNumber: Long) = wrap(refreshAfter = true) {
        val response = repo.attachServerToVSwitch(vswitchId, serverNumber)
        if (!response.isSuccessful) error("HTTP ${response.code()}")
    }

    fun detachServer(serverNumber: Long) = wrap(refreshAfter = true) {
        val response = repo.detachServerFromVSwitch(vswitchId, serverNumber)
        if (!response.isSuccessful) error("HTTP ${response.code()}")
    }

    private fun wrap(refreshAfter: Boolean = false, block: suspend () -> Unit) {
        if (_state.value.running) return
        _state.update { it.copy(running = true) }
        viewModelScope.launch {
            runCatching { block() }
                .onSuccess {
                    _events.emit(RobotVSwitchEvent.Toast("done"))
                    if (refreshAfter) refresh()
                }
                .onFailure { e -> _events.emit(RobotVSwitchEvent.Failure(sanitizeError(e))) }
            _state.update { it.copy(running = false) }
        }
    }
}
