// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.CloudImage
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.data.dto.CloudServerType
import de.kiefer_networks.falco.data.dto.CloudSshKey
import de.kiefer_networks.falco.data.dto.Location
import de.kiefer_networks.falco.data.repo.CloudRepo
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

sealed interface CloudUiState {
    data object Loading : CloudUiState
    data class Loaded(val servers: List<ProjectAware<CloudServer>>) : CloudUiState
    data class Failed(val message: String) : CloudUiState
}

@HiltViewModel
class CloudViewModel @Inject constructor(
    private val repo: CloudRepo,
) : ViewModel() {

    private val _state = MutableStateFlow<CloudUiState>(CloudUiState.Loading)
    val state: StateFlow<CloudUiState> = _state.asStateFlow()

    private val _create = MutableStateFlow(CreateOptions())
    val createOptions: StateFlow<CreateOptions> = _create.asStateFlow()

    private val _events = MutableSharedFlow<String>(extraBufferCapacity = 4)
    val events: SharedFlow<String> = _events.asSharedFlow()

    data class CreateOptions(
        val loading: Boolean = false,
        val running: Boolean = false,
        val serverTypes: List<CloudServerType> = emptyList(),
        val images: List<CloudImage> = emptyList(),
        val locations: List<Location> = emptyList(),
        val sshKeys: List<CloudSshKey> = emptyList(),
    )

    init { refresh() }

    fun loadCreateOptions() {
        viewModelScope.launch {
            _create.update { it.copy(loading = true) }
            runCatching {
                val st = repo.listServerTypes()
                val img = repo.listImages("system")
                val loc = repo.listLocations()
                val keys = repo.listSshKeys()
                _create.update {
                    it.copy(
                        loading = false,
                        serverTypes = st,
                        images = img,
                        locations = loc,
                        sshKeys = keys,
                    )
                }
            }.onFailure { e ->
                _create.update { it.copy(loading = false) }
                _events.emit(sanitizeError(e))
            }
        }
    }

    fun createServer(
        name: String,
        serverType: String,
        image: String,
        location: String?,
        sshKeyIds: List<Long>,
        userData: String?,
        startAfterCreate: Boolean,
        onDone: (Boolean) -> Unit,
    ) {
        if (_create.value.running) return
        viewModelScope.launch {
            _create.update { it.copy(running = true) }
            val res = runCatching {
                repo.createServer(
                    name = name,
                    serverType = serverType,
                    image = image,
                    location = location,
                    sshKeyIds = sshKeyIds.takeIf { it.isNotEmpty() },
                    userData = userData?.takeIf { it.isNotBlank() },
                    startAfterCreate = startAfterCreate,
                )
            }
            _create.update { it.copy(running = false) }
            res.onSuccess {
                refresh()
                onDone(true)
            }.onFailure { e ->
                _events.emit(sanitizeError(e))
                onDone(false)
            }
        }
    }

    fun refresh() {
        viewModelScope.launch {
            _state.value = CloudUiState.Loading
            _state.value = runCatching { repo.listServersAware() }
                .fold(
                    onSuccess = { items ->
                        CloudUiState.Loaded(items.map { (pid, srv) -> ProjectAware(pid, srv) })
                    },
                    onFailure = { CloudUiState.Failed(sanitizeError(it)) },
                )
        }
    }

    private val inFlight = java.util.concurrent.atomic.AtomicBoolean(false)

    fun action(action: ServerAction, id: Long) {
        if (!inFlight.compareAndSet(false, true)) return // guard against concurrent triggers
        viewModelScope.launch {
            try {
                runCatching {
                    when (action) {
                        ServerAction.PowerOn -> repo.powerOn(id)
                        ServerAction.PowerOff -> repo.powerOff(id)
                        ServerAction.Reboot -> repo.reboot(id)
                        ServerAction.Shutdown -> repo.shutdown(id)
                        ServerAction.Reset -> repo.reset(id)
                        ServerAction.Snapshot -> repo.snapshot(id)
                    }
                }
                refresh()
            } finally {
                inFlight.set(false)
            }
        }
    }

    enum class ServerAction { PowerOn, PowerOff, Reboot, Shutdown, Reset, Snapshot }
}
