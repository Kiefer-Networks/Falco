// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(
    androidx.compose.material3.ExperimentalMaterial3Api::class,
    androidx.compose.foundation.ExperimentalFoundationApi::class,
)
package de.kiefer_networks.falco.ui.screens.s3

import android.widget.Toast
import androidx.compose.foundation.clickable
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Card
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.repo.S3Repo
import de.kiefer_networks.falco.data.util.sanitizeError
import de.kiefer_networks.falco.ui.components.dialog.TypeToConfirmDeleteDialog
import de.kiefer_networks.falco.ui.nav.LocalNavDrawer
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

data class S3UiState(val loading: Boolean = true, val buckets: List<String> = emptyList(), val error: String? = null)

sealed interface S3Event {
    data class CreateSucceeded(val bucket: String) : S3Event
    data class CreateFailed(val message: String) : S3Event
    data class DeleteSucceeded(val bucket: String) : S3Event
    data class DeleteFailed(val message: String) : S3Event
    data class VersioningStatusLoaded(val bucket: String, val status: String) : S3Event
    data class VersioningStatusFailed(val message: String) : S3Event
    data class VersioningUpdated(val bucket: String, val enabled: Boolean) : S3Event
    data class VersioningFailed(val message: String) : S3Event
}

@HiltViewModel
class S3ViewModel @Inject constructor(private val repo: S3Repo) : ViewModel() {
    private val _state = MutableStateFlow(S3UiState())
    val state: StateFlow<S3UiState> = _state.asStateFlow()

    private val _events = MutableStateFlow<S3Event?>(null)
    val events: StateFlow<S3Event?> = _events.asStateFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.value = S3UiState(loading = true)
        runCatching { repo.listBuckets() }
            .onSuccess { _state.value = S3UiState(loading = false, buckets = it) }
            .onFailure { _state.value = S3UiState(loading = false, error = sanitizeError(it)) }
    }

    fun createBucket(name: String, region: String?) {
        viewModelScope.launch {
            runCatching { repo.createBucket(name, region) }
                .onSuccess {
                    _events.value = S3Event.CreateSucceeded(name)
                    refresh()
                }
                .onFailure { _events.value = S3Event.CreateFailed(sanitizeError(it)) }
        }
    }

    fun deleteBucket(name: String) {
        viewModelScope.launch {
            runCatching { repo.deleteBucket(name) }
                .onSuccess {
                    _events.value = S3Event.DeleteSucceeded(name)
                    refresh()
                }
                .onFailure { _events.value = S3Event.DeleteFailed(sanitizeError(it)) }
        }
    }

    fun loadVersioning(bucket: String) {
        viewModelScope.launch {
            runCatching { repo.versioningStatus(bucket) }
                .onSuccess { _events.value = S3Event.VersioningStatusLoaded(bucket, it) }
                .onFailure { _events.value = S3Event.VersioningStatusFailed(sanitizeError(it)) }
        }
    }

    fun setVersioning(bucket: String, enabled: Boolean) {
        viewModelScope.launch {
            runCatching { repo.setVersioning(bucket, enabled) }
                .onSuccess { _events.value = S3Event.VersioningUpdated(bucket, enabled) }
                .onFailure { _events.value = S3Event.VersioningFailed(sanitizeError(it)) }
        }
    }

    fun consumeEvent() { _events.value = null }
}

@Composable
fun S3Screen(
    onOpenBucket: (String) -> Unit = {},
    viewModel: S3ViewModel = hiltViewModel(),
) {
    val s by viewModel.state.collectAsState()
    val event by viewModel.events.collectAsState()
    val drawer = LocalNavDrawer.current
    val context = LocalContext.current

    var createOpen by rememberSaveable { mutableStateOf(false) }
    var actionsBucket by rememberSaveable { mutableStateOf<String?>(null) }
    var deleteBucket by rememberSaveable { mutableStateOf<String?>(null) }
    var settingsBucket by rememberSaveable { mutableStateOf<String?>(null) }
    var versioningStatus by rememberSaveable { mutableStateOf<String?>(null) }

    LaunchedEffect(event) {
        when (val e = event) {
            is S3Event.CreateSucceeded -> {
                Toast.makeText(context, e.bucket, Toast.LENGTH_SHORT).show()
                createOpen = false
            }
            is S3Event.CreateFailed ->
                Toast.makeText(
                    context,
                    context.getString(R.string.s3_bucket_create_failed) + ": " + e.message,
                    Toast.LENGTH_LONG,
                ).show()
            is S3Event.DeleteSucceeded -> {
                deleteBucket = null
                actionsBucket = null
            }
            is S3Event.DeleteFailed ->
                Toast.makeText(
                    context,
                    context.getString(R.string.s3_bucket_delete_failed) + ": " + e.message,
                    Toast.LENGTH_LONG,
                ).show()
            is S3Event.VersioningStatusLoaded -> {
                if (e.bucket == settingsBucket) versioningStatus = e.status
            }
            is S3Event.VersioningStatusFailed ->
                Toast.makeText(context, e.message, Toast.LENGTH_LONG).show()
            is S3Event.VersioningUpdated -> {
                if (e.bucket == settingsBucket) {
                    versioningStatus = if (e.enabled) "Enabled" else "Suspended"
                }
            }
            is S3Event.VersioningFailed ->
                Toast.makeText(
                    context,
                    context.getString(R.string.s3_versioning_failed) + ": " + e.message,
                    Toast.LENGTH_LONG,
                ).show()
            null -> Unit
        }
        if (event != null) viewModel.consumeEvent()
    }

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text(stringResource(R.string.nav_storage)) },
                navigationIcon = {
                    if (drawer.isCompact) {
                        IconButton(onClick = drawer::open) {
                            Icon(Icons.Filled.Menu, contentDescription = stringResource(R.string.nav_drawer_title))
                        }
                    }
                },
            )
        },
        floatingActionButton = {
            FloatingActionButton(onClick = { createOpen = true }) {
                Icon(Icons.Filled.Add, contentDescription = stringResource(R.string.s3_bucket_create_title))
            }
        },
    ) { padding ->
        when {
            s.loading -> Box(Modifier.fillMaxSize().padding(padding), contentAlignment = Alignment.Center) { CircularProgressIndicator() }
            s.error != null -> Box(Modifier.fillMaxSize().padding(padding).padding(24.dp), contentAlignment = Alignment.Center) { Text(s.error!!) }
            else -> LazyColumn(Modifier.fillMaxSize().padding(padding).padding(12.dp)) {
                items(s.buckets, key = { it }) { bucket ->
                    Card(
                        Modifier
                            .fillMaxWidth()
                            .padding(vertical = 6.dp)
                            .combinedClickable(
                                onClick = { onOpenBucket(bucket) },
                                onLongClick = { actionsBucket = bucket },
                            ),
                    ) {
                        Column(Modifier.padding(12.dp)) {
                            Text(bucket, style = MaterialTheme.typography.titleMedium)
                        }
                    }
                }
            }
        }
    }

    if (createOpen) {
        CreateBucketDialog(
            onDismiss = { createOpen = false },
            onConfirm = { name, region -> viewModel.createBucket(name, region) },
        )
    }

    actionsBucket?.let { bucket ->
        BucketActionsSheet(
            bucket = bucket,
            onDismiss = { actionsBucket = null },
            onDelete = {
                deleteBucket = bucket
                actionsBucket = null
            },
            onSettings = {
                settingsBucket = bucket
                versioningStatus = null
                viewModel.loadVersioning(bucket)
                actionsBucket = null
            },
        )
    }

    deleteBucket?.let { bucket ->
        TypeToConfirmDeleteDialog(
            title = stringResource(R.string.s3_bucket_delete_title),
            warning = stringResource(R.string.s3_bucket_delete_warning, bucket),
            confirmName = bucket,
            confirmButtonLabel = stringResource(R.string.s3_bucket_action_delete),
            onConfirm = {
                viewModel.deleteBucket(bucket)
                deleteBucket = null
            },
            onDismiss = { deleteBucket = null },
        )
    }

    settingsBucket?.let { bucket ->
        BucketSettingsDialog(
            bucket = bucket,
            currentStatus = versioningStatus,
            onDismiss = { settingsBucket = null; versioningStatus = null },
            onSetVersioning = { enabled -> viewModel.setVersioning(bucket, enabled) },
        )
    }
}

@Composable
private fun CreateBucketDialog(
    onDismiss: () -> Unit,
    onConfirm: (name: String, region: String?) -> Unit,
) {
    var name by remember { mutableStateOf("") }
    var region by remember { mutableStateOf("") }
    val trimmedName = name.trim()
    val canSubmit = trimmedName.isNotEmpty()

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.s3_bucket_create_title)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(
                    value = name,
                    onValueChange = { name = it },
                    label = { Text(stringResource(R.string.s3_bucket_name)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = region,
                    onValueChange = { region = it },
                    label = { Text(stringResource(R.string.s3_bucket_region_optional)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
            }
        },
        confirmButton = {
            TextButton(
                onClick = { onConfirm(trimmedName, region.trim().ifEmpty { null }) },
                enabled = canSubmit,
            ) { Text(stringResource(R.string.s3_bucket_create)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}

@Composable
private fun BucketActionsSheet(
    bucket: String,
    onDismiss: () -> Unit,
    onDelete: () -> Unit,
    onSettings: () -> Unit,
) {
    val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
    ModalBottomSheet(onDismissRequest = onDismiss, sheetState = sheetState) {
        Column(Modifier.fillMaxWidth().padding(bottom = 16.dp)) {
            Text(
                bucket,
                style = MaterialTheme.typography.titleMedium,
                modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp),
            )
            ListItem(
                headlineContent = { Text(stringResource(R.string.s3_bucket_action_settings)) },
                modifier = Modifier.clickable(onClick = onSettings),
            )
            ListItem(
                headlineContent = {
                    Text(
                        stringResource(R.string.s3_bucket_action_delete),
                        color = MaterialTheme.colorScheme.error,
                    )
                },
                modifier = Modifier.clickable(onClick = onDelete),
            )
        }
    }
}

@Composable
private fun BucketSettingsDialog(
    bucket: String,
    currentStatus: String?,
    onDismiss: () -> Unit,
    onSetVersioning: (enabled: Boolean) -> Unit,
) {
    val isEnabled = currentStatus.equals("Enabled", ignoreCase = true) || currentStatus.equals("On", ignoreCase = true)
    val statusLabel = currentStatus ?: stringResource(R.string.s3_info_loading)

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(bucket) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Text(
                    stringResource(R.string.s3_versioning_title),
                    style = MaterialTheme.typography.titleSmall,
                )
                Text(stringResource(R.string.s3_versioning_status, statusLabel))
                if (currentStatus != null) {
                    androidx.compose.foundation.layout.Row(
                        modifier = Modifier.fillMaxWidth(),
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        Text(
                            text = if (isEnabled) {
                                stringResource(R.string.s3_versioning_disable)
                            } else {
                                stringResource(R.string.s3_versioning_enable)
                            },
                            modifier = Modifier.weight(1f),
                        )
                        Switch(
                            checked = isEnabled,
                            onCheckedChange = { onSetVersioning(it) },
                        )
                    }
                    Text(
                        text = if (isEnabled) {
                            stringResource(R.string.s3_versioning_warning_disable)
                        } else {
                            stringResource(R.string.s3_versioning_warning_enable)
                        },
                        style = MaterialTheme.typography.bodySmall,
                    )
                } else {
                    CircularProgressIndicator()
                }
            }
        },
        confirmButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.close)) }
        },
    )
}
