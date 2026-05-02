// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
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
import androidx.compose.material.icons.filled.Language
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
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
import de.kiefer_networks.falco.data.dto.CloudPrimaryIp
import de.kiefer_networks.falco.data.dto.Datacenter
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

data class CloudPrimaryIpsUiState(
    val loading: Boolean = true,
    val error: String? = null,
    val data: List<ProjectAware<CloudPrimaryIp>> = emptyList(),
)

data class CreatePrimaryIpOptions(
    val loading: Boolean = false,
    val running: Boolean = false,
    val datacenters: List<Datacenter> = emptyList(),
)

@HiltViewModel
class CloudPrimaryIpsViewModel @Inject constructor(private val repo: CloudRepo) : ViewModel() {
    private val _state = MutableStateFlow(CloudPrimaryIpsUiState())
    val state: StateFlow<CloudPrimaryIpsUiState> = _state.asStateFlow()

    private val _create = MutableStateFlow(CreatePrimaryIpOptions())
    val createOptions: StateFlow<CreatePrimaryIpOptions> = _create.asStateFlow()

    private val _events = MutableSharedFlow<String>(extraBufferCapacity = 4)
    val events: SharedFlow<String> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.value = CloudPrimaryIpsUiState(loading = true)
        runCatching { repo.listPrimaryIps() }
            .onSuccess { items ->
                // CloudRepo only exposes a flat listPrimaryIps() that already
                // fans out across projects in aggregate-projects mode. We don't
                // get project ids back, so wrap with null — selectProjectThen
                // is a no-op for null project ids.
                _state.value = CloudPrimaryIpsUiState(
                    loading = false,
                    data = items.map { ProjectAware(null, it) },
                )
            }
            .onFailure { _state.value = CloudPrimaryIpsUiState(loading = false, error = sanitizeError(it)) }
    }

    fun loadCreateOptions() = viewModelScope.launch {
        _create.update { it.copy(loading = true) }
        runCatching {
            val dcs = repo.listDatacenters()
            _create.update { it.copy(loading = false, datacenters = dcs) }
        }.onFailure { e ->
            _create.update { it.copy(loading = false) }
            _events.emit(sanitizeError(e))
        }
    }

    fun create(
        type: String,
        name: String,
        datacenter: String?,
        onDone: (Boolean) -> Unit,
    ) {
        if (_create.value.running) return
        viewModelScope.launch {
            _create.update { it.copy(running = true) }
            val res = runCatching {
                repo.createPrimaryIp(
                    name = name,
                    type = type,
                    assigneeType = "server",
                    datacenter = datacenter,
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
fun CloudPrimaryIpsTab(viewModel: CloudPrimaryIpsViewModel = hiltViewModel()) {
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
                items(
                    s.data,
                    key = { "${it.projectId.orEmpty()}-${it.item.id}" },
                ) { entry -> PrimaryIpCard(entry.item) }
            }
        }
        FloatingActionButton(
            onClick = {
                viewModel.loadCreateOptions()
                createOpen = true
            },
            modifier = Modifier.align(Alignment.BottomEnd).padding(16.dp),
        ) {
            Icon(Icons.Filled.Add, contentDescription = stringResource(R.string.cloud_primary_ip_create))
        }
    }

    if (createOpen) {
        CreatePrimaryIpWizard(
            viewModel = viewModel,
            onDismiss = { createOpen = false },
            onCreated = { createOpen = false },
        )
    }
}

@Composable
private fun PrimaryIpCard(ip: CloudPrimaryIp) {
    Card(modifier = Modifier.fillMaxWidth().padding(vertical = 6.dp)) {
        Column(Modifier.padding(12.dp)) {
            Text(ip.name, style = MaterialTheme.typography.titleMedium)
            Text(ip.ip, style = MaterialTheme.typography.bodyMedium)
            Text(
                stringResource(R.string.cloud_primary_ip_type, ip.type),
                style = MaterialTheme.typography.bodyMedium,
            )
            ip.assigneeId?.let {
                Text(
                    stringResource(R.string.cloud_attached_server, it),
                    style = MaterialTheme.typography.bodyMedium,
                )
            }
            ip.datacenter?.let { dc ->
                Text(
                    stringResource(
                        R.string.cloud_primary_ip_datacenter,
                        dc.name,
                    ),
                    style = MaterialTheme.typography.bodyMedium,
                )
            }
        }
    }
}

@Composable
internal fun CreatePrimaryIpWizard(
    viewModel: CloudPrimaryIpsViewModel,
    onDismiss: () -> Unit,
    onCreated: () -> Unit,
) {
    val opts by viewModel.createOptions.collectAsState()

    var step by remember { mutableStateOf(0) }
    var type by remember { mutableStateOf("ipv4") }
    var datacenter by remember { mutableStateOf<String?>(null) }
    var name by remember { mutableStateOf("") }

    val stepLabels = listOf(
        stringResource(R.string.cloud_primary_ip_type_label),
        stringResource(R.string.wizard_step_target),
        stringResource(R.string.wizard_step_details),
    )

    val canGoNext = when (step) {
        0 -> type.isNotBlank()
        1 -> datacenter != null
        2 -> name.isNotBlank()
        else -> false
    }

    WizardScaffold(
        title = stringResource(R.string.cloud_primary_ip_create),
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
                name = name.trim(),
                datacenter = datacenter,
                onDone = { ok -> if (ok) onCreated() },
            )
        },
        nextLabel = stringResource(R.string.wizard_next),
        finishLabel = stringResource(R.string.cloud_primary_ip_create_action),
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
                    title = stringResource(R.string.cloud_primary_ip_type_ipv4),
                    icon = Icons.Filled.Language,
                    selected = type == "ipv4",
                    onClick = { type = "ipv4" },
                )
                PickCard(
                    title = stringResource(R.string.cloud_primary_ip_type_ipv6),
                    icon = Icons.Filled.Language,
                    selected = type == "ipv6",
                    onClick = { type = "ipv6" },
                )
            }
            1 -> Column(
                modifier = Modifier.fillMaxSize().padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    items(opts.datacenters, key = { it.id }) { dc ->
                        PickCard(
                            title = dc.name,
                            subtitle = dc.location?.let { it.city ?: it.name },
                            icon = Icons.Filled.LocationOn,
                            selected = datacenter == dc.name,
                            onClick = { datacenter = dc.name },
                        )
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
                    label = { Text(stringResource(R.string.cloud_primary_ip_name)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                Spacer(Modifier.size(8.dp))
            }
        }
    }
}
