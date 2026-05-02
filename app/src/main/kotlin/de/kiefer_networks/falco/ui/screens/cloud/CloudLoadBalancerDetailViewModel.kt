// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.CloudLoadBalancer
import de.kiefer_networks.falco.data.dto.CloudLoadBalancerType
import de.kiefer_networks.falco.data.dto.LoadBalancerService
import de.kiefer_networks.falco.data.dto.LoadBalancerTarget
import de.kiefer_networks.falco.data.dto.LoadBalancerTargetIp
import de.kiefer_networks.falco.data.dto.LoadBalancerTargetLabelSelector
import de.kiefer_networks.falco.data.dto.LoadBalancerTargetServer
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

/**
 * State for the Load Balancer detail screen. The detail call returns the full
 * resource, so all rendering is driven from [loadBalancer]; [types] is loaded
 * lazily for the type-change picker.
 */
data class CloudLoadBalancerDetailUiState(
    val loading: Boolean = true,
    val loadBalancer: CloudLoadBalancer? = null,
    val types: List<CloudLoadBalancerType> = emptyList(),
    val running: Boolean = false,
    val error: String? = null,
    val deleted: Boolean = false,
)

sealed interface CloudLoadBalancerEvent {
    data class Toast(val text: String) : CloudLoadBalancerEvent
    data class Failure(val message: String) : CloudLoadBalancerEvent
}

@HiltViewModel
class CloudLoadBalancerDetailViewModel @Inject constructor(
    private val repo: CloudRepo,
    savedState: SavedStateHandle,
) : ViewModel() {

    private val lbId: Long = savedState.get<Long>(Routes.ARG_LOAD_BALANCER_ID)
        ?: error("load balancer id missing")

    private val _state = MutableStateFlow(CloudLoadBalancerDetailUiState())
    val state: StateFlow<CloudLoadBalancerDetailUiState> = _state.asStateFlow()

    private val _events = MutableSharedFlow<CloudLoadBalancerEvent>(extraBufferCapacity = 4)
    val events: SharedFlow<CloudLoadBalancerEvent> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.update { it.copy(loading = true, error = null) }
        runCatching { repo.getLoadBalancer(lbId) }
            .onSuccess { lb -> _state.update { it.copy(loading = false, loadBalancer = lb) } }
            .onFailure { e -> _state.update { it.copy(loading = false, error = sanitizeError(e)) } }
    }

    fun loadTypes() = viewModelScope.launch {
        runCatching { repo.listLoadBalancerTypes() }
            .onSuccess { ts -> _state.update { it.copy(types = ts) } }
            .onFailure { e -> _events.emit(CloudLoadBalancerEvent.Failure(sanitizeError(e))) }
    }

    fun rename(newName: String) = wrap(refreshAfter = true) { repo.renameLoadBalancer(lbId, newName) }

    fun delete() = wrap {
        val response = repo.deleteLoadBalancer(lbId)
        if (response.isSuccessful) {
            _state.update { it.copy(deleted = true) }
        } else {
            error("HTTP ${response.code()}")
        }
    }

    fun setProtection(delete: Boolean) = wrap(refreshAfter = true) {
        repo.setLoadBalancerProtection(lbId, delete = delete)
    }

    fun togglePublicInterface(enable: Boolean) = wrap(refreshAfter = true) {
        if (enable) repo.enableLoadBalancerPublic(lbId) else repo.disableLoadBalancerPublic(lbId)
    }

    fun changeAlgorithm(algorithm: String) = wrap(refreshAfter = true) {
        repo.changeLoadBalancerAlgorithm(lbId, algorithm)
    }

    fun changeType(typeName: String) = wrap(refreshAfter = true) {
        repo.changeLoadBalancerType(lbId, typeName)
    }

    fun addService(service: LoadBalancerService) = wrap(refreshAfter = true) {
        repo.addLoadBalancerService(lbId, service)
    }

    fun updateService(
        listenPort: Int,
        protocol: String?,
        destinationPort: Int?,
        proxyprotocol: Boolean?,
    ) = wrap(refreshAfter = true) {
        repo.updateLoadBalancerService(
            lbId,
            listenPort = listenPort,
            protocol = protocol,
            destinationPort = destinationPort,
            proxyprotocol = proxyprotocol,
        )
    }

    fun deleteService(listenPort: Int) = wrap(refreshAfter = true) {
        repo.deleteLoadBalancerService(lbId, listenPort)
    }

    fun addServerTarget(serverId: Long, usePrivateIp: Boolean = false) = wrap(refreshAfter = true) {
        repo.addLoadBalancerTarget(
            lbId,
            LoadBalancerTarget(
                type = "server",
                server = LoadBalancerTargetServer(serverId),
                usePrivateIp = usePrivateIp,
            ),
        )
    }

    fun addLabelSelectorTarget(selector: String) = wrap(refreshAfter = true) {
        repo.addLoadBalancerTarget(
            lbId,
            LoadBalancerTarget(
                type = "label_selector",
                labelSelector = LoadBalancerTargetLabelSelector(selector),
            ),
        )
    }

    fun addIpTarget(ip: String) = wrap(refreshAfter = true) {
        repo.addLoadBalancerTarget(
            lbId,
            LoadBalancerTarget(type = "ip", ip = LoadBalancerTargetIp(ip)),
        )
    }

    /**
     * Removes a target by re-shaping the target descriptor into the bare form
     * Hetzner expects on the remove endpoint (server -> {type, server.id};
     * label_selector -> {type, label_selector.selector}; ip -> {type, ip.ip}).
     * Other fields (e.g. health_status) must be omitted to avoid 422s.
     */
    fun removeTarget(target: LoadBalancerTarget) = wrap(refreshAfter = true) {
        val stripped = when (target.type) {
            "server" -> LoadBalancerTarget(
                type = "server",
                server = target.server,
                usePrivateIp = target.usePrivateIp,
            )
            "label_selector" -> LoadBalancerTarget(
                type = "label_selector",
                labelSelector = target.labelSelector,
            )
            "ip" -> LoadBalancerTarget(type = "ip", ip = target.ip)
            else -> target
        }
        repo.removeLoadBalancerTarget(lbId, stripped)
    }

    private fun wrap(refreshAfter: Boolean = false, block: suspend () -> Unit) {
        if (_state.value.running) return
        _state.update { it.copy(running = true) }
        viewModelScope.launch {
            runCatching { block() }
                .onSuccess {
                    _events.emit(CloudLoadBalancerEvent.Toast("done"))
                    if (refreshAfter) refresh()
                }
                .onFailure { e -> _events.emit(CloudLoadBalancerEvent.Failure(sanitizeError(e))) }
            _state.update { it.copy(running = false) }
        }
    }
}
