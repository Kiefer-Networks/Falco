// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Inventory2
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilterChip
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudStorageBox
import de.kiefer_networks.falco.data.dto.CloudStorageBoxType
import de.kiefer_networks.falco.data.dto.Location
import de.kiefer_networks.falco.data.repo.CloudRepo
import de.kiefer_networks.falco.ui.components.EmptyState
import de.kiefer_networks.falco.ui.components.ErrorState
import de.kiefer_networks.falco.ui.components.LoadingState
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

data class CloudStorageBoxesUiState(
    val loading: Boolean = true,
    val error: String? = null,
    val data: List<ProjectAware<CloudStorageBox>> = emptyList(),
)

data class CreateStorageBoxOptions(
    val loading: Boolean = false,
    val running: Boolean = false,
    val types: List<CloudStorageBoxType> = emptyList(),
    val locations: List<Location> = emptyList(),
)

@HiltViewModel
class CloudStorageBoxesViewModel @Inject constructor(private val repo: CloudRepo) : ViewModel() {
    private val _state = MutableStateFlow(CloudStorageBoxesUiState())
    val state: StateFlow<CloudStorageBoxesUiState> = _state.asStateFlow()

    private val _create = MutableStateFlow(CreateStorageBoxOptions())
    val createOptions: StateFlow<CreateStorageBoxOptions> = _create.asStateFlow()

    private val _events = MutableSharedFlow<String>(extraBufferCapacity = 4)
    val events: SharedFlow<String> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.value = CloudStorageBoxesUiState(loading = true)
        runCatching { repo.listStorageBoxesAware() }
            .onSuccess { items ->
                _state.value = CloudStorageBoxesUiState(
                    loading = false,
                    data = items.map { (pid, b) -> ProjectAware(pid, b) },
                )
            }
            .onFailure { _state.value = CloudStorageBoxesUiState(loading = false, error = sanitizeError(it)) }
    }

    fun loadCreateOptions() = viewModelScope.launch {
        _create.update { it.copy(loading = true) }
        runCatching {
            val types = repo.listStorageBoxTypes()
            val locs = repo.listStorageBoxLocations()
            _create.update { it.copy(loading = false, types = types, locations = locs) }
        }.onFailure { e ->
            _create.update { it.copy(loading = false) }
            _events.emit(sanitizeError(e))
        }
    }

    fun create(
        name: String,
        storageBoxType: String,
        location: String,
        password: String?,
        onDone: (Boolean) -> Unit,
    ) {
        if (_create.value.running) return
        viewModelScope.launch {
            _create.update { it.copy(running = true) }
            val res = runCatching {
                repo.createStorageBox(
                    name = name,
                    storageBoxType = storageBoxType,
                    location = location,
                    password = password,
                )
            }
            _create.update { it.copy(running = false) }
            res.onSuccess {
                refresh()
                onDone(true)
            }.onFailure { e ->
                _events.emit(sanitizeError(e))
                onDone(false)
            }
        }
    }
}

@Composable
fun CloudStorageBoxesTab(
    viewModel: CloudStorageBoxesViewModel = hiltViewModel(),
    onOpen: (projectId: String?, id: Long) -> Unit = { _, _ -> },
) {
    val s by viewModel.state.collectAsState()
    var createOpen by remember { mutableStateOf(false) }
    androidx.compose.runtime.LaunchedEffect(Unit) { viewModel.refresh() }
    Box(modifier = Modifier.fillMaxSize()) {
        when {
            s.loading -> LoadingState()
            s.error != null -> ErrorState(message = s.error!!, onRetry = viewModel::refresh)
            s.data.isEmpty() -> EmptyState(
                icon = Icons.Filled.Inventory2,
                title = stringResource(R.string.cloud_storage_boxes),
                body = stringResource(R.string.empty_list),
            )
            else -> LazyColumn(
                modifier = Modifier.fillMaxSize().padding(horizontal = 12.dp, vertical = 8.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                items(
                    s.data,
                    key = { "${it.projectId.orEmpty()}-${it.item.id}" },
                ) { entry ->
                    val box = entry.item
                    StorageBoxCard(box, onClick = { onOpen(entry.projectId, box.id) })
                }
            }
        }
        FloatingActionButton(
            onClick = {
                viewModel.loadCreateOptions()
                createOpen = true
            },
            modifier = Modifier.align(Alignment.BottomEnd).padding(16.dp),
        ) {
            Icon(Icons.Filled.Add, contentDescription = stringResource(R.string.cloud_storage_box_create))
        }
    }

    if (createOpen) {
        CreateStorageBoxSheet(
            viewModel = viewModel,
            onDismiss = { createOpen = false },
            onCreated = { createOpen = false },
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class, ExperimentalLayoutApi::class)
@Composable
private fun CreateStorageBoxSheet(
    viewModel: CloudStorageBoxesViewModel,
    onDismiss: () -> Unit,
    onCreated: () -> Unit,
) {
    val opts by viewModel.createOptions.collectAsState()

    var step by remember { mutableStateOf(0) }
    var location by remember { mutableStateOf<String?>(null) }
    var typeName by remember { mutableStateOf<String?>(null) }
    var name by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }

    val stepLabels = listOf(
        stringResource(R.string.wizard_step_location),
        stringResource(R.string.wizard_step_type),
        stringResource(R.string.wizard_step_credentials),
    )

    val canGoNext = when (step) {
        0 -> location != null
        1 -> typeName != null
        2 -> name.isNotBlank() && password.length >= 8
        else -> false
    }

    de.kiefer_networks.falco.ui.components.wizard.WizardScaffold(
        title = stringResource(R.string.cloud_storage_box_create),
        steps = stepLabels,
        currentStep = step,
        canGoNext = canGoNext,
        isLastStep = step == stepLabels.lastIndex,
        isRunning = opts.running,
        onDismiss = onDismiss,
        onBack = { if (step > 0) step-- },
        onNext = { if (step < stepLabels.lastIndex) step++ },
        onFinish = {
            viewModel.create(
                name = name.trim(),
                storageBoxType = typeName!!,
                location = location!!,
                password = password,
                onDone = { ok -> if (ok) onCreated() },
            )
        },
        nextLabel = stringResource(R.string.wizard_next),
        finishLabel = stringResource(R.string.cloud_storage_box_create_action),
        backLabel = stringResource(R.string.wizard_back),
        cancelLabel = stringResource(R.string.cancel),
    ) {
        if (opts.loading) {
            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
            return@WizardScaffold
        }
        when (step) {
            0 -> LazyColumn(
                modifier = Modifier.fillMaxSize().padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                items(opts.locations, key = { it.name }) { loc ->
                    de.kiefer_networks.falco.ui.components.wizard.PickCard(
                        title = loc.city ?: loc.name,
                        subtitle = listOfNotNull(loc.country, loc.name).joinToString(" · "),
                        icon = Icons.Filled.LocationOn,
                        selected = location == loc.name,
                        onClick = { location = loc.name },
                    )
                }
            }
            1 -> LazyColumn(
                modifier = Modifier.fillMaxSize().padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                items(opts.types, key = { it.name }) { t ->
                    val sizeLabel = t.size?.let { de.kiefer_networks.falco.ui.util.formatBytes(it) }.orEmpty()
                    de.kiefer_networks.falco.ui.components.wizard.PickCard(
                        title = t.name,
                        subtitle = listOfNotNull(t.description, sizeLabel.ifBlank { null }).joinToString(" · "),
                        icon = Icons.Filled.Inventory2,
                        selected = typeName == t.name,
                        onClick = { typeName = t.name },
                    )
                }
            }
            2 -> Column(
                modifier = Modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp),
            ) {
                OutlinedTextField(
                    value = name,
                    onValueChange = { name = it },
                    label = { Text(stringResource(R.string.cloud_storage_box_create_name)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = password,
                    onValueChange = { password = it },
                    label = { Text(stringResource(R.string.cloud_storage_box_create_password)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                Text(
                    stringResource(R.string.cloud_storage_box_create_password_hint),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
        }
    }
}

@Composable
private fun StorageBoxCard(box: CloudStorageBox, onClick: () -> Unit) {
    ElevatedCard(
        onClick = onClick,
        modifier = Modifier.fillMaxWidth(),
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                StatusDotColor(active = box.accessible)
                Spacer(Modifier.size(12.dp))
                Column(modifier = Modifier.weight(1f)) {
                    Text(box.name, style = MaterialTheme.typography.titleMedium)
                    Text(
                        text = if (box.accessible) {
                            stringResource(R.string.cloud_storage_box_status_active)
                        } else {
                            stringResource(R.string.cloud_storage_box_status_inactive)
                        },
                        style = MaterialTheme.typography.bodySmall,
                        color = if (box.accessible) {
                            MaterialTheme.colorScheme.primary
                        } else {
                            MaterialTheme.colorScheme.onSurfaceVariant
                        },
                    )
                }
                if (box.protection?.delete == true) {
                    Text(
                        text = stringResource(R.string.cloud_storage_box_protected),
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.tertiary,
                    )
                }
            }
            box.storageBoxType?.let { st ->
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        stringResource(R.string.cloud_storage_box_type_label) + ": ",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                    Text(st.name, style = MaterialTheme.typography.bodyMedium)
                    if (st.size != null) {
                        Spacer(Modifier.size(8.dp))
                        Text(
                            text = "· ${de.kiefer_networks.falco.ui.util.formatBytes(st.size)}",
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                }
            }
            box.location?.let { loc ->
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(
                        Icons.Filled.LocationOn,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.primary,
                        modifier = Modifier.size(16.dp),
                    )
                    Spacer(Modifier.size(8.dp))
                    Text(
                        text = listOfNotNull(loc.name, loc.city, loc.country).joinToString(" · "),
                        style = MaterialTheme.typography.bodyMedium,
                    )
                }
            }
            val linkedCount = box.linkedResources.size
            Text(
                text = if (linkedCount == 0) {
                    stringResource(R.string.cloud_storage_box_unlinked)
                } else {
                    stringResource(R.string.cloud_storage_box_linked_resources, linkedCount)
                },
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
    }
}

@Composable
private fun StatusDotColor(active: Boolean) {
    Surface(
        shape = CircleShape,
        color = if (active) Color(0xFF2E7D32) else Color(0xFF9E9E9E),
        modifier = Modifier.size(12.dp),
    ) {}
}
