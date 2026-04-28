// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.data.repo.CloudRepo
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

sealed interface CloudUiState {
    data object Loading : CloudUiState
    data class Loaded(val servers: List<CloudServer>) : CloudUiState
    data class Failed(val message: String) : CloudUiState
}

@HiltViewModel
class CloudViewModel @Inject constructor(
    private val repo: CloudRepo,
) : ViewModel() {

    private val _state = MutableStateFlow<CloudUiState>(CloudUiState.Loading)
    val state: StateFlow<CloudUiState> = _state.asStateFlow()

    init { refresh() }

    fun refresh() {
        viewModelScope.launch {
            _state.value = CloudUiState.Loading
            _state.value = runCatching { repo.listServers() }
                .fold(
                    onSuccess = { CloudUiState.Loaded(it) },
                    onFailure = { CloudUiState.Failed(it.message ?: "error") },
                )
        }
    }

    fun action(action: ServerAction, id: Long) {
        viewModelScope.launch {
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
        }
    }

    enum class ServerAction { PowerOn, PowerOff, Reboot, Shutdown, Reset, Snapshot }
}
