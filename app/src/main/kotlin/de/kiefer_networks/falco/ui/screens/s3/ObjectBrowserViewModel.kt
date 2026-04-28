// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.s3

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.api.S3Client
import de.kiefer_networks.falco.data.repo.S3Repo
import de.kiefer_networks.falco.data.s3.S3DownloadHelper
import de.kiefer_networks.falco.ui.nav.Routes
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.io.OutputStream
import javax.inject.Inject

data class ObjectBrowserUiState(
    val loading: Boolean = true,
    val objects: List<S3Client.S3ObjectMeta> = emptyList(),
    val error: String? = null,
)

sealed interface ObjectBrowserEvent {
    data class ShareLinkReady(val key: String, val url: String) : ObjectBrowserEvent
    data class ShareLinkFailed(val message: String) : ObjectBrowserEvent
    data class DeleteSucceeded(val key: String) : ObjectBrowserEvent
    data class DeleteFailed(val message: String) : ObjectBrowserEvent
    data class DownloadSucceeded(val key: String) : ObjectBrowserEvent
    data class DownloadFailed(val message: String) : ObjectBrowserEvent
}

@HiltViewModel
class ObjectBrowserViewModel @Inject constructor(
    private val repo: S3Repo,
    private val downloader: S3DownloadHelper,
    savedStateHandle: SavedStateHandle,
) : ViewModel() {

    val bucket: String = checkNotNull(savedStateHandle.get<String>(Routes.ARG_BUCKET)) {
        "Missing ${Routes.ARG_BUCKET} argument"
    }
    val prefix: String = savedStateHandle.get<String>(Routes.ARG_PREFIX).orEmpty()

    private val _state = MutableStateFlow(ObjectBrowserUiState())
    val state: StateFlow<ObjectBrowserUiState> = _state.asStateFlow()

    private val _events = MutableStateFlow<ObjectBrowserEvent?>(null)
    val events: StateFlow<ObjectBrowserEvent?> = _events.asStateFlow()

    init { refresh() }

    fun refresh() {
        viewModelScope.launch {
            _state.value = _state.value.copy(loading = true, error = null)
            runCatching { repo.listObjects(bucket, prefix) }
                .onSuccess { items ->
                    val sorted = items.sortedWith(
                        compareByDescending<S3Client.S3ObjectMeta> { it.isDir }
                            .thenBy { it.key.lowercase() },
                    )
                    _state.value = ObjectBrowserUiState(loading = false, objects = sorted)
                }
                .onFailure { _state.value = ObjectBrowserUiState(loading = false, error = it.message) }
        }
    }

    fun delete(key: String) {
        viewModelScope.launch {
            runCatching { repo.delete(bucket, key) }
                .onSuccess {
                    _events.value = ObjectBrowserEvent.DeleteSucceeded(key)
                    refresh()
                }
                .onFailure { _events.value = ObjectBrowserEvent.DeleteFailed(it.message ?: "") }
        }
    }

    fun share(key: String, hours: Int) {
        viewModelScope.launch {
            runCatching { repo.shareLink(bucket, key, hours) }
                .onSuccess { _events.value = ObjectBrowserEvent.ShareLinkReady(key, it) }
                .onFailure { _events.value = ObjectBrowserEvent.ShareLinkFailed(it.message ?: "") }
        }
    }

    fun download(key: String, output: OutputStream, onComplete: () -> Unit = {}) {
        viewModelScope.launch {
            runCatching {
                output.use { downloader.download(bucket, key, it) }
            }
                .onSuccess { _events.value = ObjectBrowserEvent.DownloadSucceeded(key) }
                .onFailure { _events.value = ObjectBrowserEvent.DownloadFailed(it.message ?: "") }
            onComplete()
        }
    }

    fun consumeEvent() { _events.value = null }
}
