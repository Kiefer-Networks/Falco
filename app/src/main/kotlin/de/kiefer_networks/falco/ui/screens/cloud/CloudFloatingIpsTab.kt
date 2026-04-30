// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.cloud

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
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Computer
import androidx.compose.material.icons.filled.Language
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudFloatingIp
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.data.dto.Location
import de.kiefer_networks.falco.data.repo.CloudRepo
import de.kiefer_networks.falco.data.util.sanitizeError
import de.kiefer_networks.falco.ui.components.wizard.PickCard
import de.kiefer_networks.falco.ui.components.wizard.WizardScaffold
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

data class CloudFloatingIpsUiState(
    val loading: Boolean = true,
    val error: String? = null,
    val data: List<CloudFloatingIp> = emptyList(),
)

data class CreateFloatingIpOptions(
    val loading: Boolean = false,
    val running: Boolean = false,
    val locations: List<Location> = emptyList(),
    val servers: List<CloudServer> = emptyList(),
)

@HiltViewModel
class CloudFloatingIpsViewModel @Inject constructor(private val repo: CloudRepo) : ViewModel() {
    private val _state = MutableStateFlow(CloudFloatingIpsUiState())
    val state: StateFlow<CloudFloatingIpsUiState> = _state.asStateFlow()

    private val _create = MutableStateFlow(CreateFloatingIpOptions())
    val createOptions: StateFlow<CreateFloatingIpOptions> = _create.asStateFlow()

    private val _events = MutableSharedFlow<String>(extraBufferCapacity = 4)
    val events: SharedFlow<String> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.value = CloudFloatingIpsUiState(loading = true)
        runCatching { repo.listFloatingIps() }
            .onSuccess { _state.value = CloudFloatingIpsUiState(loading = false, data = it) }
            .onFailure { _state.value = CloudFloatingIpsUiState(loading = false, error = sanitizeError(it)) }
    }

    fun loadCreateOptions() = viewModelScope.launch {
        _create.update { it.copy(loading = true) }
        runCatching {
            val locs = repo.listLocations()
            val servers = repo.listServers()
            _create.update { it.copy(loading = false, locations = locs, servers = servers) }
        }.onFailure { e ->
            _create.update { it.copy(loading = false) }
            _events.emit(sanitizeError(e))
        }
    }

    fun create(
        type: String,
        name: String?,
        description: String?,
        homeLocation: String?,
        serverId: Long?,
        onDone: (Boolean) -> Unit,
        projectId: String? = null,
    ) {
        if (_create.value.running) return
        viewModelScope.launch {
            _create.update { it.copy(running = true) }
            val res = runCatching {
                repo.createFloatingIp(
                    type = type,
                    name = name,
                    description = description,
                    homeLocation = homeLocation,
                    serverId = serverId,
                    projectId = projectId,
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
fun CloudFloatingIpsTab(viewModel: CloudFloatingIpsViewModel = hiltViewModel()) {
    val s by viewModel.state.collectAsState()
    var createOpen by remember { mutableStateOf(false) }
    androidx.compose.runtime.LaunchedEffect(Unit) { viewModel.refresh() }
    Box(Modifier.fillMaxSize()) {
        when {
            s.loading -> Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
            s.error != null -> Box(
                Modifier.fillMaxSize().padding(24.dp),
                contentAlignment = Alignment.Center,
            ) {
                Text(s.error!!, style = MaterialTheme.typography.bodyLarge)
            }
            s.data.isEmpty() -> Box(
                Modifier.fillMaxSize().padding(24.dp),
                contentAlignment = Alignment.Center,
            ) {
                Text(stringResource(R.string.empty_list))
            }
            else -> LazyColumn(Modifier.fillMaxSize().padding(12.dp)) {
                items(s.data, key = { it.id }) { fip -> FloatingIpCard(fip) }
            }
        }
        FloatingActionButton(
            onClick = {
                viewModel.loadCreateOptions()
                createOpen = true
            },
            modifier = Modifier.align(Alignment.BottomEnd).padding(16.dp),
        ) {
            Icon(Icons.Filled.Add, contentDescription = stringResource(R.string.cloud_floating_ip_create))
        }
    }

    if (createOpen) {
        CreateFloatingIpWizard(
            viewModel = viewModel,
            onDismiss = { createOpen = false },
            onCreated = { createOpen = false },
        )
    }
}

@Composable
private fun FloatingIpCard(fip: CloudFloatingIp) {
    Card(modifier = Modifier.fillMaxWidth().padding(vertical = 6.dp)) {
        Column(Modifier.padding(12.dp)) {
            Text(fip.ip, style = MaterialTheme.typography.titleMedium)
            Text(
                stringResource(R.string.cloud_floating_ip_type, fip.type),
                style = MaterialTheme.typography.bodyMedium,
            )
            fip.description?.takeIf { it.isNotBlank() }?.let {
                Text(it, style = MaterialTheme.typography.bodyMedium)
            }
            fip.server?.let {
                Text(
                    stringResource(R.string.cloud_attached_server, it),
                    style = MaterialTheme.typography.bodyMedium,
                )
            }
            fip.homeLocation?.let { loc ->
                Text(
                    stringResource(
                        R.string.cloud_home_location,
                        loc.city ?: loc.name,
                    ),
                    style = MaterialTheme.typography.bodyMedium,
                )
            }
        }
    }
}

@Composable
internal fun CreateFloatingIpWizard(
    viewModel: CloudFloatingIpsViewModel,
    onDismiss: () -> Unit,
    onCreated: () -> Unit,
    projectId: String? = null,
) {
    val opts by viewModel.createOptions.collectAsState()

    var step by remember { mutableStateOf(0) }
    var type by remember { mutableStateOf("ipv4") }
    var assignToServer by remember { mutableStateOf(false) }
    var serverId by remember { mutableStateOf<Long?>(null) }
    var location by remember { mutableStateOf<String?>(null) }
    var name by remember { mutableStateOf("") }
    var description by remember { mutableStateOf("") }

    val stepLabels = listOf(
        stringResource(R.string.cloud_floating_ip_type_label),
        stringResource(R.string.wizard_step_target),
        stringResource(R.string.wizard_step_details),
    )

    val canGoNext = when (step) {
        0 -> type.isNotBlank()
        1 -> if (assignToServer) serverId != null else location != null
        2 -> true
        else -> false
    }

    WizardScaffold(
        title = stringResource(R.string.cloud_floating_ip_create),
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
                type = type,
                name = name.trim().ifBlank { null },
                description = description.trim().ifBlank { null },
                homeLocation = if (assignToServer) null else location,
                serverId = if (assignToServer) serverId else null,
                onDone = { ok -> if (ok) onCreated() },
                projectId = projectId,
            )
        },
        nextLabel = stringResource(R.string.wizard_next),
        finishLabel = stringResource(R.string.cloud_floating_ip_create_action),
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
            0 -> Column(
                modifier = Modifier.fillMaxSize().padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                PickCard(
                    title = stringResource(R.string.cloud_floating_ip_type_ipv4),
                    icon = Icons.Filled.Language,
                    selected = type == "ipv4",
                    onClick = { type = "ipv4" },
                )
                PickCard(
                    title = stringResource(R.string.cloud_floating_ip_type_ipv6),
                    icon = Icons.Filled.Language,
                    selected = type == "ipv6",
                    onClick = { type = "ipv6" },
                )
            }
            1 -> Column(
                modifier = Modifier.fillMaxSize().padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        stringResource(R.string.cloud_floating_ip_assign_mode),
                        modifier = Modifier.weight(1f),
                        style = MaterialTheme.typography.bodyMedium,
                    )
                    Switch(checked = assignToServer, onCheckedChange = { assignToServer = it })
                }
                if (assignToServer) {
                    LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        items(opts.servers, key = { it.id }) { srv ->
                            PickCard(
                                title = srv.name,
                                subtitle = srv.status,
                                icon = Icons.Filled.Computer,
                                selected = serverId == srv.id,
                                onClick = { serverId = srv.id },
                            )
                        }
                    }
                } else {
                    LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        items(opts.locations, key = { it.name }) { loc ->
                            PickCard(
                                title = loc.city ?: loc.name,
                                subtitle = loc.country,
                                icon = Icons.Filled.LocationOn,
                                selected = location == loc.name,
                                onClick = { location = loc.name },
                            )
                        }
                    }
                }
            }
            2 -> Column(
                modifier = Modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp),
            ) {
                OutlinedTextField(
                    value = name,
                    onValueChange = { name = it },
                    label = { Text(stringResource(R.string.cloud_floating_ip_name)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = description,
                    onValueChange = { description = it },
                    label = { Text(stringResource(R.string.cloud_floating_ip_description)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                Spacer(Modifier.size(8.dp))
            }
        }
    }
}
