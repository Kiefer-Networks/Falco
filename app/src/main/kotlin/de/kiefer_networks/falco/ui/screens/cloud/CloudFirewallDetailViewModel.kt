// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.CloudFirewall
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.data.dto.FirewallRule
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

data class FirewallDetailUiState(
    val loading: Boolean = true,
    val firewall: CloudFirewall? = null,
    val servers: List<CloudServer> = emptyList(),
    val running: Boolean = false,
    val error: String? = null,
    val deleted: Boolean = false,
)

sealed interface FirewallEvent {
    data class Toast(val text: String) : FirewallEvent
    data class Failure(val message: String) : FirewallEvent
}

@HiltViewModel
class CloudFirewallDetailViewModel @Inject constructor(
    private val repo: CloudRepo,
    savedState: SavedStateHandle,
) : ViewModel() {

    private val firewallId: Long = savedState.get<Long>(Routes.ARG_FIREWALL_ID)
        ?: error("firewall id missing")

    private val _state = MutableStateFlow(FirewallDetailUiState())
    val state: StateFlow<FirewallDetailUiState> = _state.asStateFlow()

    private val _events = MutableSharedFlow<FirewallEvent>(extraBufferCapacity = 4)
    val events: SharedFlow<FirewallEvent> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() {
        viewModelScope.launch {
            _state.update { it.copy(loading = true, error = null) }
            runCatching { repo.getFirewall(firewallId) }
                .onSuccess { fw -> _state.update { it.copy(loading = false, firewall = fw) } }
                .onFailure { e -> _state.update { it.copy(loading = false, error = sanitizeError(e)) } }
        }
    }

    fun loadServers() = viewModelScope.launch {
        runCatching { repo.listServers() }.onSuccess { servers ->
            _state.update { it.copy(servers = servers) }
        }
    }

    fun rename(newName: String) = wrap(refreshAfter = true) {
        repo.renameFirewall(firewallId, newName)
    }

    fun delete() = wrap {
        val response = repo.deleteFirewall(firewallId)
        if (response.isSuccessful) {
            _state.update { it.copy(deleted = true) }
        } else {
            error("HTTP ${response.code()}")
        }
    }

    fun upsertRule(original: FirewallRule?, updated: FirewallRule) = wrap(refreshAfter = true) {
        val current = _state.value.firewall?.rules.orEmpty()
        val next = if (original == null) {
            current + updated
        } else {
            current.map { if (it == original) updated else it }
        }
        repo.setFirewallRules(firewallId, next)
    }

    fun removeRule(rule: FirewallRule) = wrap(refreshAfter = true) {
        val next = _state.value.firewall?.rules.orEmpty().filterNot { it == rule }
        repo.setFirewallRules(firewallId, next)
    }

    fun attachServer(serverId: Long) = wrap(refreshAfter = true) {
        repo.applyFirewallToServer(firewallId, serverId)
    }

    fun detachServer(serverId: Long) = wrap(refreshAfter = true) {
        repo.removeFirewallFromServer(firewallId, serverId)
    }

    private fun wrap(refreshAfter: Boolean = false, block: suspend () -> Unit) {
        if (_state.value.running) return
        _state.update { it.copy(running = true) }
        viewModelScope.launch {
            runCatching { block() }
                .onSuccess {
                    _events.emit(FirewallEvent.Toast("done"))
                    if (refreshAfter) refresh()
                }
                .onFailure { e -> _events.emit(FirewallEvent.Failure(sanitizeError(e))) }
            _state.update { it.copy(running = false) }
        }
    }
}
