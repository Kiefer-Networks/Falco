// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.cloud

import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.expandVertically
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.shrinkVertically
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.UploadFile
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.SmallFloatingActionButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudSshKey
import de.kiefer_networks.falco.data.repo.CloudRepo
import de.kiefer_networks.falco.data.util.sanitizeError
import de.kiefer_networks.falco.ui.components.ErrorState
import de.kiefer_networks.falco.ui.components.LoadingState
import de.kiefer_networks.falco.ui.theme.Spacing
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

data class CloudSshKeysUiState(
    val loading: Boolean = true,
    val keys: List<CloudSshKey> = emptyList(),
    val error: String? = null,
    val running: Boolean = false,
)

@HiltViewModel
class CloudSshKeysViewModel @Inject constructor(private val repo: CloudRepo) : ViewModel() {
    private val _state = MutableStateFlow(CloudSshKeysUiState())
    val state: StateFlow<CloudSshKeysUiState> = _state.asStateFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.value = CloudSshKeysUiState(loading = true)
        runCatching { repo.listSshKeys() }
            .onSuccess { _state.value = CloudSshKeysUiState(loading = false, keys = it) }
            .onFailure { e -> _state.value = CloudSshKeysUiState(loading = false, error = sanitizeError(e)) }
    }

    fun create(name: String, data: String, projectId: String? = null) = viewModelScope.launch {
        if (_state.value.running) return@launch
        _state.update { it.copy(running = true) }
        runCatching { repo.createSshKey(name, data, projectId) }.onSuccess { refresh() }
        _state.update { it.copy(running = false) }
    }

    fun delete(id: Long) = viewModelScope.launch {
        if (_state.value.running) return@launch
        _state.update { it.copy(running = true) }
        runCatching { repo.deleteSshKey(id) }.onSuccess { refresh() }
        _state.update { it.copy(running = false) }
    }
}

private sealed interface SshAddMode {
    data object Manual : SshAddMode
    data class FromFile(val initialName: String, val initialData: String) : SshAddMode
}

@Composable
fun CloudSshKeysTab(
    viewModel: CloudSshKeysViewModel = hiltViewModel(),
    projectsViewModel: ProjectsViewModel = hiltViewModel(),
) {
    val s by viewModel.state.collectAsState()
    val projectsState by projectsViewModel.state.collectAsState()
    val context = LocalContext.current
    var fabExpanded by remember { mutableStateOf(false) }
    var addMode by remember { mutableStateOf<SshAddMode?>(null) }
    var pendingDelete by remember { mutableStateOf<CloudSshKey?>(null) }
    var pickProjectFor by remember { mutableStateOf<Pair<String, String>?>(null) }

    LaunchedEffect(Unit) { viewModel.refresh() }

    val picker = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.OpenDocument(),
    ) { uri: Uri? ->
        if (uri != null) {
            val text = runCatching {
                context.contentResolver.openInputStream(uri)?.use { it.bufferedReader().readText() }
            }.getOrNull().orEmpty()
            val name = uri.lastPathSegment
                ?.substringAfterLast('/')
                ?.removeSuffix(".pub")
                .orEmpty()
            addMode = SshAddMode.FromFile(name, text.trim())
        }
        fabExpanded = false
    }

    Box(modifier = Modifier.fillMaxSize()) {
        when {
            s.loading -> LoadingState()
            s.error != null -> ErrorState(message = s.error!!, onRetry = viewModel::refresh)
            s.keys.isEmpty() -> Box(
                modifier = Modifier.fillMaxSize().padding(Spacing.lg),
                contentAlignment = Alignment.Center,
            ) {
                Text(stringResource(R.string.empty_list))
            }
            else -> LazyColumn(
                modifier = Modifier.fillMaxSize().padding(Spacing.md),
                verticalArrangement = Arrangement.spacedBy(Spacing.sm),
            ) {
                items(s.keys, key = { it.id }) { key ->
                    KeyCard(key, onDelete = { pendingDelete = key })
                }
            }
        }

        FabMenu(
            expanded = fabExpanded,
            onToggle = { fabExpanded = !fabExpanded },
            onPickFile = { picker.launch(arrayOf("*/*")) },
            onCreateManual = {
                addMode = SshAddMode.Manual
                fabExpanded = false
            },
            modifier = Modifier
                .align(Alignment.BottomEnd)
                .padding(Spacing.md),
        )
    }

    addMode?.let { mode ->
        AddKeySheet(
            initialName = (mode as? SshAddMode.FromFile)?.initialName.orEmpty(),
            initialData = (mode as? SshAddMode.FromFile)?.initialData.orEmpty(),
            onDismiss = { addMode = null },
            onConfirm = { name, data ->
                addMode = null
                if (projectsState.aggregateProjects && projectsState.projects.size > 1) {
                    pickProjectFor = name.trim() to data.trim()
                } else {
                    viewModel.create(name.trim(), data.trim())
                }
            },
        )
    }

    pickProjectFor?.let { (name, data) ->
        de.kiefer_networks.falco.ui.components.dialog.ProjectChooserDialog(
            projects = projectsState.projects,
            onDismiss = { pickProjectFor = null },
            onPick = { id ->
                viewModel.create(name, data, projectId = id)
                pickProjectFor = null
            },
        )
    }

    pendingDelete?.let { key ->
        AlertDialog(
            onDismissRequest = { pendingDelete = null },
            title = { Text(stringResource(R.string.robot_ssh_key_delete_title)) },
            text = { Text(key.name) },
            confirmButton = {
                TextButton(onClick = {
                    viewModel.delete(key.id)
                    pendingDelete = null
                }) {
                    Text(stringResource(R.string.delete), color = MaterialTheme.colorScheme.error)
                }
            },
            dismissButton = {
                TextButton(onClick = { pendingDelete = null }) { Text(stringResource(R.string.cancel)) }
            },
        )
    }
}

@Composable
private fun FabMenu(
    expanded: Boolean,
    onToggle: () -> Unit,
    onPickFile: () -> Unit,
    onCreateManual: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(
        modifier = modifier,
        horizontalAlignment = Alignment.End,
        verticalArrangement = Arrangement.spacedBy(Spacing.sm),
    ) {
        AnimatedVisibility(
            visible = expanded,
            enter = fadeIn() + expandVertically(expandFrom = Alignment.Bottom),
            exit = fadeOut() + shrinkVertically(shrinkTowards = Alignment.Bottom),
        ) {
            Column(
                horizontalAlignment = Alignment.End,
                verticalArrangement = Arrangement.spacedBy(Spacing.sm),
            ) {
                MiniFabRow(Icons.Filled.UploadFile, stringResource(R.string.robot_ssh_key_pick_file), onPickFile)
                MiniFabRow(Icons.Filled.Edit, stringResource(R.string.robot_ssh_key_add_manual), onCreateManual)
            }
        }
        FloatingActionButton(onClick = onToggle) {
            Icon(
                if (expanded) Icons.Filled.Close else Icons.Filled.Add,
                contentDescription = stringResource(R.string.robot_ssh_key_add),
            )
        }
    }
}

@Composable
private fun MiniFabRow(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    label: String,
    onClick: () -> Unit,
) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(Spacing.sm),
    ) {
        Surface(
            shape = RoundedCornerShape(8.dp),
            color = MaterialTheme.colorScheme.surfaceVariant,
            tonalElevation = 4.dp,
        ) {
            Text(
                label,
                style = MaterialTheme.typography.labelLarge,
                color = MaterialTheme.colorScheme.onSurface,
                modifier = Modifier.padding(horizontal = Spacing.md, vertical = Spacing.xs),
            )
        }
        SmallFloatingActionButton(
            onClick = onClick,
            containerColor = MaterialTheme.colorScheme.secondaryContainer,
            contentColor = MaterialTheme.colorScheme.onSecondaryContainer,
        ) {
            Icon(icon, contentDescription = null)
        }
    }
}

@Composable
private fun AddKeySheet(
    initialName: String,
    initialData: String,
    onDismiss: () -> Unit,
    onConfirm: (name: String, data: String) -> Unit,
) {
    val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
    var name by remember { mutableStateOf(initialName) }
    var data by remember { mutableStateOf(initialData) }

    ModalBottomSheet(onDismissRequest = onDismiss, sheetState = sheetState) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = Spacing.lg, vertical = Spacing.md)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(Spacing.md),
        ) {
            Text(stringResource(R.string.robot_ssh_key_add), style = MaterialTheme.typography.titleLarge)
            OutlinedTextField(
                value = name,
                onValueChange = { name = it },
                label = { Text(stringResource(R.string.robot_ssh_key_name)) },
                singleLine = true,
                modifier = Modifier.fillMaxWidth(),
            )
            OutlinedTextField(
                value = data,
                onValueChange = { data = it },
                label = { Text(stringResource(R.string.robot_ssh_key_data)) },
                singleLine = false,
                minLines = 4,
                modifier = Modifier.fillMaxWidth(),
            )
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.End) {
                TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
                Spacer(Modifier.size(Spacing.sm))
                Button(
                    enabled = name.isNotBlank() && data.isNotBlank(),
                    onClick = { onConfirm(name, data) },
                ) { Text(stringResource(R.string.save)) }
            }
            Spacer(Modifier.size(Spacing.md))
        }
    }
}

@Composable
private fun KeyCard(key: CloudSshKey, onDelete: () -> Unit) {
    OutlinedCard(modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.padding(Spacing.md),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(key.name, style = MaterialTheme.typography.titleSmall)
                Text(
                    key.fingerprint,
                    style = MaterialTheme.typography.bodySmall,
                    fontFamily = FontFamily.Monospace,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
            IconButton(onClick = onDelete) {
                Icon(
                    Icons.Filled.Delete,
                    contentDescription = stringResource(R.string.delete),
                    tint = MaterialTheme.colorScheme.error,
                )
            }
        }
    }
}
