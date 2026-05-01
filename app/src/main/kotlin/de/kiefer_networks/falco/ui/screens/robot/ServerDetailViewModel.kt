// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.robot

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.RobotServer
import de.kiefer_networks.falco.data.repo.RobotRepo
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

data class ServerDetailUiState(
    val loading: Boolean = true,
    val running: Boolean = false,
    val server: RobotServer? = null,
    val error: String? = null,
    val rescueActive: Boolean = false,
    val cancellationDate: String? = null,
    val cancellationCancelled: Boolean = false,
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

    private val _rescuePassword = MutableSharedFlow<String>(extraBufferCapacity = 1)
    val rescuePassword: SharedFlow<String> = _rescuePassword.asSharedFlow()

    init { refresh() }

    fun refresh() {
        viewModelScope.launch {
            _state.value = _state.value.copy(loading = true, error = null)
            runCatching { repo.getServer(serverNumber) }
                .onSuccess { server ->
                    _state.value = _state.value.copy(loading = false, server = server)
                }
                .onFailure { e ->
                    _state.value = _state.value.copy(loading = false, error = sanitizeError(e))
                }
            // Best-effort side fetches; ignore failures (some servers lack these endpoints).
            runCatching { repo.rescueOptions(serverNumber) }.onSuccess { r ->
                _state.value = _state.value.copy(rescueActive = r.active)
            }
            runCatching { repo.getCancellation(serverNumber) }.onSuccess { c ->
                _state.value = _state.value.copy(
                    cancellationDate = c.cancellationDate,
                    cancellationCancelled = c.cancelled,
                )
            }
        }
    }

    fun enableRescue(authorizedKey: String?, successMsg: String, failureFmt: (String) -> String) {
        viewModelScope.launch {
            _state.value = _state.value.copy(running = true)
            runCatching { repo.enableRescue(serverNumber, "linux", authorizedKey) }
                .onSuccess {
                    _state.value = _state.value.copy(rescueActive = true)
                    it.password?.let { pw -> _rescuePassword.tryEmit(pw) }
                    _events.value = ServerActionResult.Success(successMsg)
                }
                .onFailure { e -> _events.value = ServerActionResult.Failure(failureFmt(sanitizeError(e))) }
            _state.value = _state.value.copy(running = false)
        }
    }

    fun disableRescue(successMsg: String, failureFmt: (String) -> String) {
        viewModelScope.launch {
            _state.value = _state.value.copy(running = true)
            runCatching {
                val resp = repo.disableRescue(serverNumber)
                if (!resp.isSuccessful) error("HTTP ${resp.code()}")
            }
                .onSuccess {
                    _state.value = _state.value.copy(rescueActive = false)
                    _events.value = ServerActionResult.Success(successMsg)
                }
                .onFailure { e -> _events.value = ServerActionResult.Failure(failureFmt(sanitizeError(e))) }
            _state.value = _state.value.copy(running = false)
        }
    }

    fun setRdns(ip: String, ptr: String, successMsg: String, failureFmt: (String) -> String) {
        viewModelScope.launch {
            _state.value = _state.value.copy(running = true)
            runCatching { repo.setRdns(ip, ptr) }
                .onSuccess { _events.value = ServerActionResult.Success(successMsg) }
                .onFailure { e -> _events.value = ServerActionResult.Failure(failureFmt(sanitizeError(e))) }
            _state.value = _state.value.copy(running = false)
        }
    }

    fun cancelServer(date: String, reason: String?, successMsg: String, failureFmt: (String) -> String) {
        viewModelScope.launch {
            _state.value = _state.value.copy(running = true)
            runCatching { repo.cancelServer(serverNumber, date, reason) }
                .onSuccess { c ->
                    _state.value = _state.value.copy(cancellationDate = c.cancellationDate, cancellationCancelled = c.cancelled)
                    _events.value = ServerActionResult.Success(successMsg)
                }
                .onFailure { e -> _events.value = ServerActionResult.Failure(failureFmt(sanitizeError(e))) }
            _state.value = _state.value.copy(running = false)
        }
    }

    fun withdrawCancellation(successMsg: String, failureFmt: (String) -> String) {
        viewModelScope.launch {
            _state.value = _state.value.copy(running = true)
            runCatching {
                val resp = repo.withdrawCancellation(serverNumber)
                if (!resp.isSuccessful) error("HTTP ${resp.code()}")
            }
                .onSuccess {
                    _state.value = _state.value.copy(cancellationDate = null, cancellationCancelled = false)
                    _events.value = ServerActionResult.Success(successMsg)
                }
                .onFailure { e -> _events.value = ServerActionResult.Failure(failureFmt(sanitizeError(e))) }
            _state.value = _state.value.copy(running = false)
        }
    }

    fun reset(type: String, successMsg: String, failureFmt: (String) -> String) {
        viewModelScope.launch {
            _state.value = _state.value.copy(running = true)
            runCatching { repo.reset(serverNumber, type) }
                .onSuccess { _events.value = ServerActionResult.Success(successMsg) }
                .onFailure { e -> _events.value = ServerActionResult.Failure(failureFmt(sanitizeError(e))) }
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
                .onFailure { e -> _events.value = ServerActionResult.Failure(failureFmt(sanitizeError(e))) }
            _state.value = _state.value.copy(running = false)
        }
    }

    fun consumeEvent() { _events.value = null }
}
