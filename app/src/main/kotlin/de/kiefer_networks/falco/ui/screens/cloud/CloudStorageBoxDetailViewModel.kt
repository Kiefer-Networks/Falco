// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.CloudStorageBox
import de.kiefer_networks.falco.data.dto.CloudStorageBoxSnapshot
import de.kiefer_networks.falco.data.dto.CloudStorageBoxSubaccount
import de.kiefer_networks.falco.data.dto.CloudSubaccountAccessSettings
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

data class StorageBoxDetailUiState(
    val loading: Boolean = true,
    val box: CloudStorageBox? = null,
    val snapshots: List<CloudStorageBoxSnapshot> = emptyList(),
    val subaccounts: List<CloudStorageBoxSubaccount> = emptyList(),
    val running: Boolean = false,
    val error: String? = null,
)

sealed interface StorageBoxEvent {
    data class Toast(val text: String) : StorageBoxEvent
    data class Failure(val message: String) : StorageBoxEvent
}

@HiltViewModel
class CloudStorageBoxDetailViewModel @Inject constructor(
    private val repo: CloudRepo,
    savedState: SavedStateHandle,
) : ViewModel() {

    private val boxId: Long = savedState.get<Long>(Routes.ARG_STORAGE_BOX_ID)
        ?: error("storage box id missing in nav args")

    private val _state = MutableStateFlow(StorageBoxDetailUiState())
    val state: StateFlow<StorageBoxDetailUiState> = _state.asStateFlow()

    private val _events = MutableSharedFlow<StorageBoxEvent>(extraBufferCapacity = 4)
    val events: SharedFlow<StorageBoxEvent> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() {
        viewModelScope.launch {
            _state.update { it.copy(loading = true, error = null) }
            runCatching {
                val box = repo.getStorageBox(boxId)
                val snapshots = repo.listStorageBoxSnapshots(boxId)
                val subs = repo.listStorageBoxSubaccounts(boxId)
                _state.update {
                    it.copy(
                        loading = false,
                        box = box,
                        snapshots = snapshots,
                        subaccounts = subs,
                    )
                }
            }.onFailure { e ->
                _state.update { it.copy(loading = false, error = sanitizeError(e)) }
            }
        }
    }

    fun resetPassword(newPassword: String) = wrap {
        repo.resetStorageBoxPassword(boxId, newPassword)
    }

    fun setSamba(enabled: Boolean) = wrap(refreshAfter = true) {
        repo.updateStorageBoxAccessSettings(boxId, sambaEnabled = enabled)
    }
    fun setSsh(enabled: Boolean) = wrap(refreshAfter = true) {
        repo.updateStorageBoxAccessSettings(boxId, sshEnabled = enabled)
    }
    fun setWebdav(enabled: Boolean) = wrap(refreshAfter = true) {
        repo.updateStorageBoxAccessSettings(boxId, webdavEnabled = enabled)
    }
    fun setZfs(enabled: Boolean) = wrap(refreshAfter = true) {
        repo.updateStorageBoxAccessSettings(boxId, zfsEnabled = enabled)
    }
    fun setExternal(enabled: Boolean) = wrap(refreshAfter = true) {
        repo.updateStorageBoxAccessSettings(boxId, reachableExternally = enabled)
    }

    fun createSnapshot(description: String?) = wrap(refreshAfter = true) {
        repo.createStorageBoxSnapshot(boxId, description)
    }

    fun deleteSnapshot(snapshotId: Long) = wrap(refreshAfter = true) {
        repo.deleteStorageBoxSnapshot(boxId, snapshotId)
    }

    fun rollbackSnapshot(snapshotId: Long) = wrap(refreshAfter = true) {
        repo.rollbackStorageBoxSnapshot(boxId, snapshotId)
    }

    fun createSubaccount(
        password: String,
        homeDirectory: String,
        access: CloudSubaccountAccessSettings,
        description: String?,
    ) = wrap(refreshAfter = true) {
        repo.createStorageBoxSubaccount(boxId, password, homeDirectory, access, description)
    }

    fun deleteSubaccount(subaccountId: Long) = wrap(refreshAfter = true) {
        repo.deleteStorageBoxSubaccount(boxId, subaccountId)
    }

    fun resetSubaccountPassword(subaccountId: Long, newPassword: String) = wrap {
        repo.resetSubaccountPassword(boxId, subaccountId, newPassword)
    }

    private fun wrap(refreshAfter: Boolean = false, block: suspend () -> Unit) {
        if (_state.value.running) return
        _state.update { it.copy(running = true) }
        viewModelScope.launch {
            runCatching { block() }
                .onSuccess {
                    _events.emit(StorageBoxEvent.Toast("done"))
                    if (refreshAfter) refresh()
                }
                .onFailure { e -> _events.emit(StorageBoxEvent.Failure(sanitizeError(e))) }
            _state.update { it.copy(running = false) }
        }
    }
}
