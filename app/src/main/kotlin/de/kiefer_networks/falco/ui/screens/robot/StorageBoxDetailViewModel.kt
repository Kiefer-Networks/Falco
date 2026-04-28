// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.robot

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.RobotSnapshot
import de.kiefer_networks.falco.data.dto.RobotStorageBox
import de.kiefer_networks.falco.data.dto.RobotSubaccount
import de.kiefer_networks.falco.data.repo.RobotRepo
import de.kiefer_networks.falco.ui.nav.Routes
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

data class StorageBoxDetailUiState(
    val loading: Boolean = true,
    val running: Boolean = false,
    val box: RobotStorageBox? = null,
    val snapshots: List<RobotSnapshot> = emptyList(),
    val subaccounts: List<RobotSubaccount> = emptyList(),
    val error: String? = null,
)

@HiltViewModel
class StorageBoxDetailViewModel @Inject constructor(
    private val repo: RobotRepo,
    savedStateHandle: SavedStateHandle,
) : ViewModel() {

    val boxId: Long = checkNotNull(
        savedStateHandle.get<Long>(Routes.ARG_STORAGE_BOX_ID)
            ?: savedStateHandle.get<String>(Routes.ARG_STORAGE_BOX_ID)?.toLongOrNull(),
    ) { "Missing ${Routes.ARG_STORAGE_BOX_ID} argument" }

    private val _state = MutableStateFlow(StorageBoxDetailUiState())
    val state: StateFlow<StorageBoxDetailUiState> = _state.asStateFlow()

    private val _events = MutableStateFlow<ServerActionResult?>(null)
    val events: StateFlow<ServerActionResult?> = _events.asStateFlow()

    init { refresh() }

    fun refresh() {
        viewModelScope.launch {
            _state.value = _state.value.copy(loading = true, error = null)
            runCatching {
                val box = repo.listStorageBoxes().firstOrNull { it.id == boxId }
                val snapshots = repo.snapshots(boxId)
                val subaccounts = repo.subaccounts(boxId)
                Triple(box, snapshots, subaccounts)
            }.onSuccess { (box, snapshots, subaccounts) ->
                _state.value = _state.value.copy(
                    loading = false,
                    box = box,
                    snapshots = snapshots,
                    subaccounts = subaccounts,
                )
            }.onFailure { e ->
                _state.value = _state.value.copy(loading = false, error = e.message)
            }
        }
    }

    fun createSnapshot(successMsg: String, failureFmt: (String) -> String) {
        viewModelScope.launch {
            _state.value = _state.value.copy(running = true)
            runCatching { repo.createSnapshot(boxId) }
                .onSuccess {
                    _events.value = ServerActionResult.Success(successMsg)
                    runCatching { repo.snapshots(boxId) }
                        .onSuccess { _state.value = _state.value.copy(snapshots = it) }
                }
                .onFailure { e -> _events.value = ServerActionResult.Failure(failureFmt(e.message ?: "")) }
            _state.value = _state.value.copy(running = false)
        }
    }

    fun consumeEvent() { _events.value = null }
}
