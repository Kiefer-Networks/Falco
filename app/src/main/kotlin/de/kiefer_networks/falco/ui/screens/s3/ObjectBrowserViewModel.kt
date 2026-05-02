// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.s3

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.api.S3Client
import de.kiefer_networks.falco.data.repo.S3Repo
import de.kiefer_networks.falco.data.s3.S3DownloadHelper
import de.kiefer_networks.falco.data.util.sanitizeError
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

/**
 * Lightweight projection of [io.minio.StatObjectResponse] so the UI layer
 * never imports MinIO types directly.
 */
data class ObjectStat(
    val key: String,
    val size: Long,
    val lastModified: String?,
    val contentType: String?,
    val etag: String?,
)

sealed interface ObjectBrowserEvent {
    data class ShareLinkReady(val key: String, val url: String) : ObjectBrowserEvent
    data class ShareLinkFailed(val message: String) : ObjectBrowserEvent
    data class DeleteSucceeded(val key: String) : ObjectBrowserEvent
    data class DeleteFailed(val message: String) : ObjectBrowserEvent
    data class DownloadSucceeded(val key: String) : ObjectBrowserEvent
    data class DownloadFailed(val message: String) : ObjectBrowserEvent
    data class MultiDeleteSucceeded(val count: Int) : ObjectBrowserEvent
    data class MultiDeleteFailed(val message: String) : ObjectBrowserEvent
    data class CopySucceeded(val srcKey: String, val dstKey: String) : ObjectBrowserEvent
    data class CopyFailed(val message: String) : ObjectBrowserEvent
    data class MoveSucceeded(val srcKey: String, val dstKey: String) : ObjectBrowserEvent
    data class MoveFailed(val message: String) : ObjectBrowserEvent
    data class StatLoaded(val stat: ObjectStat) : ObjectBrowserEvent
    data class StatFailed(val message: String) : ObjectBrowserEvent
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
                .onFailure { _state.value = ObjectBrowserUiState(loading = false, error = sanitizeError(it)) }
        }
    }

    fun delete(key: String) {
        viewModelScope.launch {
            runCatching { repo.delete(bucket, key) }
                .onSuccess {
                    _events.value = ObjectBrowserEvent.DeleteSucceeded(key)
                    refresh()
                }
                .onFailure { _events.value = ObjectBrowserEvent.DeleteFailed(sanitizeError(it)) }
        }
    }

    fun deleteMany(keys: Collection<String>) {
        if (keys.isEmpty()) return
        val keyList = keys.toList()
        viewModelScope.launch {
            runCatching { repo.deleteAll(bucket, keyList) }
                .onSuccess { deleted ->
                    _events.value = ObjectBrowserEvent.MultiDeleteSucceeded(deleted.size)
                    refresh()
                }
                .onFailure { _events.value = ObjectBrowserEvent.MultiDeleteFailed(sanitizeError(it)) }
        }
    }

    fun share(key: String, hours: Int) {
        viewModelScope.launch {
            runCatching { repo.shareLink(bucket, key, hours) }
                .onSuccess { _events.value = ObjectBrowserEvent.ShareLinkReady(key, it) }
                .onFailure { _events.value = ObjectBrowserEvent.ShareLinkFailed(sanitizeError(it)) }
        }
    }

    fun download(key: String, output: OutputStream, onComplete: () -> Unit = {}) {
        viewModelScope.launch {
            runCatching {
                output.use { downloader.download(bucket, key, it) }
            }
                .onSuccess { _events.value = ObjectBrowserEvent.DownloadSucceeded(key) }
                .onFailure { _events.value = ObjectBrowserEvent.DownloadFailed(sanitizeError(it)) }
            onComplete()
        }
    }

    fun copyTo(srcKey: String, dstBucket: String, dstKey: String) {
        viewModelScope.launch {
            runCatching { repo.copy(bucket, srcKey, dstBucket, dstKey) }
                .onSuccess {
                    _events.value = ObjectBrowserEvent.CopySucceeded(srcKey, dstKey)
                    if (dstBucket == bucket) refresh()
                }
                .onFailure { _events.value = ObjectBrowserEvent.CopyFailed(sanitizeError(it)) }
        }
    }

    /**
     * Move = server-side copy then source delete. We only delete the source
     * after the copy succeeds; if the copy fails, the source is left intact.
     * If the destination is in a different bucket, we still refresh because a
     * deleted source could change the local listing.
     */
    fun moveTo(srcKey: String, dstBucket: String, dstKey: String) {
        viewModelScope.launch {
            val copy = runCatching { repo.copy(bucket, srcKey, dstBucket, dstKey) }
            if (copy.isFailure) {
                _events.value = ObjectBrowserEvent.MoveFailed(sanitizeError(copy.exceptionOrNull()!!))
                return@launch
            }
            runCatching { repo.delete(bucket, srcKey) }
                .onSuccess {
                    _events.value = ObjectBrowserEvent.MoveSucceeded(srcKey, dstKey)
                    refresh()
                }
                .onFailure { _events.value = ObjectBrowserEvent.MoveFailed(sanitizeError(it)) }
        }
    }

    fun loadStat(key: String) {
        viewModelScope.launch {
            runCatching { repo.stat(bucket, key) }
                .onSuccess { resp ->
                    val stat = ObjectStat(
                        key = key,
                        size = runCatching { resp.size() }.getOrDefault(0L),
                        lastModified = runCatching { resp.lastModified()?.toString() }.getOrNull(),
                        contentType = runCatching { resp.contentType() }.getOrNull(),
                        etag = runCatching { resp.etag() }.getOrNull(),
                    )
                    _events.value = ObjectBrowserEvent.StatLoaded(stat)
                }
                .onFailure { _events.value = ObjectBrowserEvent.StatFailed(sanitizeError(it)) }
        }
    }

    fun consumeEvent() { _events.value = null }
}
