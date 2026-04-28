// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.robot

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.RobotServer
import de.kiefer_networks.falco.data.repo.RobotRepo
import de.kiefer_networks.falco.ui.nav.Routes
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

data class ServerDetailUiState(
    val loading: Boolean = true,
    val running: Boolean = false,
    val server: RobotServer? = null,
    val error: String? = null,
)

sealed interface ServerActionResult {
    data class Success(val message: String) : ServerActionResult
    data class Failure(val message: String) : ServerActionResult
}

@HiltViewModel
class ServerDetailViewModel @Inject constructor(
    private val repo: RobotRepo,
    savedStateHandle: SavedStateHandle,
) : ViewModel() {

    val serverNumber: Long = checkNotNull(
        savedStateHandle.get<Long>(Routes.ARG_SERVER_NUMBER)
            ?: savedStateHandle.get<String>(Routes.ARG_SERVER_NUMBER)?.toLongOrNull(),
    ) { "Missing ${Routes.ARG_SERVER_NUMBER} argument" }

    private val _state = MutableStateFlow(ServerDetailUiState())
    val state: StateFlow<ServerDetailUiState> = _state.asStateFlow()

    private val _events = MutableStateFlow<ServerActionResult?>(null)
    val events: StateFlow<ServerActionResult?> = _events.asStateFlow()

    init { refresh() }

    fun refresh() {
        viewModelScope.launch {
            _state.value = _state.value.copy(loading = true, error = null)
            runCatching {
                repo.listServers().firstOrNull { it.serverNumber == serverNumber }
            }.onSuccess { server ->
                _state.value = _state.value.copy(loading = false, server = server)
            }.onFailure { e ->
                _state.value = _state.value.copy(loading = false, error = e.message)
            }
        }
    }

    fun reset(type: String, successMsg: String, failureFmt: (String) -> String) {
        viewModelScope.launch {
            _state.value = _state.value.copy(running = true)
            runCatching { repo.reset(serverNumber, type) }
                .onSuccess { _events.value = ServerActionResult.Success(successMsg) }
                .onFailure { e -> _events.value = ServerActionResult.Failure(failureFmt(e.message ?: "")) }
            _state.value = _state.value.copy(running = false)
        }
    }

    fun wakeOnLan(successMsg: String, failureFmt: (String) -> String) {
        viewModelScope.launch {
            _state.value = _state.value.copy(running = true)
            runCatching {
                val resp = repo.wakeOnLan(serverNumber)
                if (!resp.isSuccessful) error("HTTP ${resp.code()}")
            }
                .onSuccess { _events.value = ServerActionResult.Success(successMsg) }
                .onFailure { e -> _events.value = ServerActionResult.Failure(failureFmt(e.message ?: "")) }
            _state.value = _state.value.copy(running = false)
        }
    }

    fun consumeEvent() { _events.value = null }
}
