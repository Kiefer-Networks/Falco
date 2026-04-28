// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.CloudImage
import de.kiefer_networks.falco.data.dto.CloudIso
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.data.dto.CloudServerType
import de.kiefer_networks.falco.data.repo.CloudRepo
import de.kiefer_networks.falco.data.repo.MetricPeriod
import de.kiefer_networks.falco.data.repo.MetricSeries
import de.kiefer_networks.falco.data.repo.MetricType
import de.kiefer_networks.falco.ui.nav.Routes
import kotlinx.coroutines.async
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

sealed interface MetricLoadState {
    data object Loading : MetricLoadState
    data class Loaded(val series: MetricSeries) : MetricLoadState
    data class Failed(val message: String) : MetricLoadState
}

data class CloudServerDetailUiState(
    val loading: Boolean = true,
    val server: CloudServer? = null,
    val cpuMetrics: MetricLoadState = MetricLoadState.Loading,
    val diskMetrics: MetricLoadState = MetricLoadState.Loading,
    val networkMetrics: MetricLoadState = MetricLoadState.Loading,
    val period: MetricPeriod = MetricPeriod.H24,
    val running: Boolean = false,
    val error: String? = null,
    val deleted: Boolean = false,
    val imageOptions: List<CloudImage> = emptyList(),
    val typeOptions: List<CloudServerType> = emptyList(),
    val isoOptions: List<CloudIso> = emptyList(),
)

sealed interface CloudServerEvent {
    data class Toast(val text: String) : CloudServerEvent
    data class Failure(val message: String) : CloudServerEvent
    data class RootPasswordRevealed(val password: String) : CloudServerEvent
}

@HiltViewModel
class CloudServerDetailViewModel @Inject constructor(
    private val repo: CloudRepo,
    savedState: SavedStateHandle,
) : ViewModel() {

    private val serverId: Long = savedState.get<Long>(Routes.ARG_CLOUD_SERVER_ID)
        ?: error("server id missing")

    private val _state = MutableStateFlow(CloudServerDetailUiState())
    val state: StateFlow<CloudServerDetailUiState> = _state.asStateFlow()

    private val _events = MutableSharedFlow<CloudServerEvent>(extraBufferCapacity = 4)
    val events: SharedFlow<CloudServerEvent> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() {
        viewModelScope.launch {
            _state.update { it.copy(loading = true, error = null) }
            runCatching { repo.getServer(serverId) }
                .onSuccess { server ->
                    _state.update { it.copy(loading = false, server = server) }
                    loadMetrics(_state.value.period)
                }
                .onFailure { e ->
                    _state.update { it.copy(loading = false, error = e.message ?: "error") }
                }
        }
    }

    fun setPeriod(period: MetricPeriod) {
        _state.update { it.copy(period = period) }
        loadMetrics(period)
    }

    private fun loadMetrics(period: MetricPeriod) {
        _state.update {
            it.copy(
                cpuMetrics = MetricLoadState.Loading,
                diskMetrics = MetricLoadState.Loading,
                networkMetrics = MetricLoadState.Loading,
            )
        }
        viewModelScope.launch {
            coroutineScope {
                val cpu = async { runCatching { repo.serverMetrics(serverId, MetricType.Cpu, period) } }
                val disk = async { runCatching { repo.serverMetrics(serverId, MetricType.Disk, period) } }
                val net = async { runCatching { repo.serverMetrics(serverId, MetricType.Network, period) } }
                val cpuRes = cpu.await()
                _state.update {
                    it.copy(
                        cpuMetrics = cpuRes.fold(
                            { s -> MetricLoadState.Loaded(s) },
                            { e -> MetricLoadState.Failed(e.message ?: "error") },
                        ),
                    )
                }
                val diskRes = disk.await()
                _state.update {
                    it.copy(
                        diskMetrics = diskRes.fold(
                            { s -> MetricLoadState.Loaded(s) },
                            { e -> MetricLoadState.Failed(e.message ?: "error") },
                        ),
                    )
                }
                val netRes = net.await()
                _state.update {
                    it.copy(
                        networkMetrics = netRes.fold(
                            { s -> MetricLoadState.Loaded(s) },
                            { e -> MetricLoadState.Failed(e.message ?: "error") },
                        ),
                    )
                }
            }
        }
    }

    fun powerOn() = wrap { repo.powerOn(serverId) }
    fun powerOff() = wrap { repo.powerOff(serverId) }
    fun reboot() = wrap { repo.reboot(serverId) }
    fun shutdown() = wrap { repo.shutdown(serverId) }
    fun reset() = wrap { repo.reset(serverId) }
    fun snapshot() = wrap { repo.snapshot(serverId) }

    fun rebuild(imageIdOrName: String) = wrap(refreshAfter = true) {
        repo.rebuildServer(serverId, imageIdOrName)
    }

    fun rename(newName: String) = wrap(refreshAfter = true) {
        repo.renameServer(serverId, newName)
    }

    fun setBackup(enabled: Boolean) = wrap(refreshAfter = true) {
        if (enabled) repo.enableBackup(serverId) else repo.disableBackup(serverId)
    }

    fun setRescue(enabled: Boolean, type: String = "linux64") = wrap(refreshAfter = true) {
        if (enabled) {
            val response = repo.enableRescue(serverId, type)
            response.rootPassword?.let { _events.emit(CloudServerEvent.RootPasswordRevealed(it)) }
        } else {
            repo.disableRescue(serverId)
        }
    }

    fun attachIso(iso: String) = wrap(refreshAfter = true) { repo.attachIso(serverId, iso) }
    fun detachIso() = wrap(refreshAfter = true) { repo.detachIso(serverId) }

    fun changeType(type: String, upgradeDisk: Boolean) = wrap(refreshAfter = true) {
        repo.changeServerType(serverId, type, upgradeDisk)
    }

    fun setProtection(delete: Boolean? = null, rebuild: Boolean? = null) = wrap(refreshAfter = true) {
        repo.setServerProtection(serverId, delete, rebuild)
    }

    fun delete() = wrap {
        repo.deleteServer(serverId)
        _state.update { it.copy(deleted = true) }
    }

    fun loadImages() = viewModelScope.launch {
        runCatching {
            val system = repo.listImages("system")
            val snapshots = runCatching { repo.listImages("snapshot") }.getOrDefault(emptyList())
            system + snapshots
        }.onSuccess { images ->
            _state.update { it.copy(imageOptions = images) }
        }
    }

    fun loadServerTypes() = viewModelScope.launch {
        runCatching { repo.listServerTypes() }.onSuccess { types ->
            _state.update { it.copy(typeOptions = types.filterNot { t -> t.deprecated }) }
        }
    }

    fun loadIsos() = viewModelScope.launch {
        runCatching { repo.listIsos() }.onSuccess { isos ->
            _state.update { it.copy(isoOptions = isos.filter { it.deprecated == null }) }
        }
    }

    private fun wrap(refreshAfter: Boolean = false, block: suspend () -> Unit) {
        if (_state.value.running) return
        _state.update { it.copy(running = true) }
        viewModelScope.launch {
            runCatching { block() }
                .onSuccess {
                    _events.emit(CloudServerEvent.Toast("done"))
                    if (refreshAfter) refresh()
                }
                .onFailure { e ->
                    _events.emit(CloudServerEvent.Failure(e.message ?: "error"))
                }
            _state.update { it.copy(running = false) }
        }
    }
}
